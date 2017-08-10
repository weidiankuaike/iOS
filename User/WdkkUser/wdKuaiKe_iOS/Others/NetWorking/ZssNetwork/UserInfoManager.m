//
//  UserInfoManager.m
//  MDSNS
//
//  Created by fyp on 13-6-6.
//  Copyright (c) 2013年 fyp. All rights reserved.
//

#import "UserInfoManager.h"
//#import "NSString+Expend.h"

@interface UserInfoManager()
{
    NSUserDefaults *userDefaultsObj;
}


@end


/***********************************************************/
/***               UserInfoManager(类定义)                ***/
/***********************************************************/

#pragma mark -
#pragma mark UserInfoManager(类定义)

@implementation UserInfoManager

static NSString *_secret;
+(void)removeUserMessage
{

    NSUserDefaults *object = [NSUserDefaults standardUserDefaults];
    NSDictionary *dict = [object dictionaryRepresentation];
    for (id key in dict) {
        NSRange range = [key rangeOfString:@"CFBundleVersion"];
        if (range.location != NSNotFound) {//有@“心”
            
        }
        else
        {
           [object removeObjectForKey:key];
        }
        
    }
	[object synchronize];
}



+ (NSString *)generateHashableStringFromObject:(id)object
{
	if ([object isKindOfClass:[NSData class]]) {
		// Data
		return [NSString stringWithFormat:@"%@", object];
	}else if ([object isKindOfClass:[NSNull class]])
    {
        return @"";
    }
    else if ([object isKindOfClass:[NSString class]]) {
		// String
		return [NSString stringWithFormat:@"%@", object];
	} else if ([object isKindOfClass:[NSNumber class]]) {
		// Number
		return [NSString stringWithFormat:@"%@", object];
	} else if ([object isKindOfClass:[NSDate class]]) {
		// Date
		return [NSString stringWithFormat:@"%@", object];
	} else if ([object isKindOfClass:[NSArray class]]) {
		// Array
		NSMutableString *hash = [NSMutableString stringWithString:@"array"];
		for (int i = 0; i < [object count]; i++) {
			[hash appendFormat:@"%d%@", i,
             [self generateHashableStringFromObject:[object objectAtIndex:i]]];
		}
		return hash;
	} else if ([object isKindOfClass:[NSDictionary class]]) {
		// Dictionary
		NSMutableString *hash = [NSMutableString stringWithString:@"dictionary"];
		// Add hashes to a dictionary. We will sort them because NSDictionaries are not sorted.
		NSMutableArray *hashes = [NSMutableArray array];
		for (NSString *key in object) {
			[hashes addObject:[NSString stringWithFormat:@"%@%@", key,
							   [self generateHashableStringFromObject:[object objectForKey:key]]]];
		}
		
		// Now sort hashes...
		[hashes sortUsingSelector:@selector(compare:)];
		
		// and transform them into one string
		for (int i = 0; i < [hashes count]; i++) {
			[hash appendString:[hashes objectAtIndex:i]];
		}
		
		return hash;
	} else {
		// Everything else
		NSAssert1(NO, @"Unsupported object: %@", object);
		return nil;
	}
}

+ (id)validateValueForKey:(NSString *)key
{
	NSDictionary *data = [[NSUserDefaults standardUserDefaults] dictionaryForKey:key];
	if (data != nil) {
		id value = [data objectForKey:@"value"];
		NSString *hash = [data objectForKey:@"hash"];
		
		NSString *checkHash = [[NSString stringWithFormat:@"%@%@",
								[self generateHashableStringFromObject:value], _secret] md5Hash];
		if ([checkHash isEqualToString:hash]) {
			return value;
		} else {
			return nil;
		}
	} else {
		return nil;
	}
}
+ (void)setSecuredObject:(id)value forKey:(NSString *)key userDefaults:(NSUserDefaults *)defaults
{
	NSString *hash = [self generateHashableStringFromObject:value];
    //DEBUG_Log(@"%@=====================",hash);
	NSString *finalHash = [[NSString stringWithFormat:@"%@%@", hash, _secret] md5Hash];
	NSDictionary *data = [NSDictionary dictionaryWithObjectsAndKeys:finalHash, @"hash",
						  value, @"value", nil];
	[defaults setObject:data forKey:key];
}
/***********************************************************/
/***				       类函数				        	***/
/***********************************************************/

+ (void)setSecret:(NSString *)secret
{
    _secret = nil;
	_secret = [secret copy];
}
+(void)userInfoSetDefineObject:(id)value forKey:(NSString *)defaultName
{
    NSData *objColor = [NSKeyedArchiver archivedDataWithRootObject:value];
    NSUserDefaults *object = [NSUserDefaults standardUserDefaults];
    [object setObject:objColor forKey:defaultName];
	[object synchronize];
}
+ (id)userInfoDefineObjectForKey:(NSString *)defaultName
{
    NSData *objColor = [[NSUserDefaults standardUserDefaults]objectForKey:defaultName];
    return [NSKeyedUnarchiver unarchiveObjectWithData:objColor];
}

+ (id)userInfoObjectForKey:(NSString *)defaultName
{
	return [self validateValueForKey:defaultName];
}
+ (void)userInfoSetObject:(id)value forKey:(NSString *)defaultName
{
	NSUserDefaults *object = [NSUserDefaults standardUserDefaults];
	//[object setObject:value forKey:defaultName];
    if ([value isKindOfClass:[NSNull class]]) {
        value = @"";
    }
	[self setSecuredObject:value forKey:defaultName userDefaults:object];
	[object synchronize];
}


+ (void)userInfoSetMyObject:(id)value forKey:(NSString *)defaultName
{
    NSUserDefaults *object = [NSUserDefaults standardUserDefaults];
    
    if ([value isKindOfClass:[NSNull class]]) {
        value = @"";
    }
   
    [object setObject:value forKey:defaultName];
    [object synchronize];
}

+ (id)userInfoMyObjectForKey:(NSString *)defaultName
{
    if (defaultName) {
        return [[NSUserDefaults standardUserDefaults] dictionaryForKey:defaultName];
    }else
    {
        return nil;
    }
    
}
+ (void)userInfoRemoveMyObjectForKey:(NSString *)defaultName
{
    if (defaultName) {
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:defaultName];
        [[NSUserDefaults standardUserDefaults]synchronize];
    }
    
}


+ (BOOL)userInfoBoolForKey:(NSString *)defaultName
{
	id object = [self validateValueForKey:defaultName];
	return [object boolValue];
}
+ (void)userInfoSetBool:(BOOL)value forKey:(NSString *)defaultName
{
	NSUserDefaults *boolObject = [NSUserDefaults standardUserDefaults];
	NSNumber *dataNum = [[NSNumber alloc] initWithBool:value];
	[self setSecuredObject:dataNum forKey:defaultName userDefaults:boolObject];
//	[dataNum release];
	[boolObject synchronize];
}
+ (unsigned long long)userInfoUnsignedLongLongForKey:(NSString *)defaultName
{
	NSNumber *object = [self validateValueForKey:defaultName];
	if (object)
	{
		return [object unsignedLongLongValue];
	}
	else {
		return 0;
	}
}
+ (void)userInfoSetUnsignedLongLong:(unsigned long long)value forKey:(NSString *)defaultName
{
	NSUserDefaults *unsignedLongLongObject = [NSUserDefaults standardUserDefaults];
	NSNumber *dataNum = [[NSNumber alloc] initWithUnsignedLongLong:value];
	[self setSecuredObject:dataNum forKey:defaultName userDefaults:unsignedLongLongObject];
//	[dataNum release];
	[unsignedLongLongObject synchronize];
}

//double
+ (double)userInfoDoubleForKey:(NSString *)defaultName
{
	NSNumber *object = [self validateValueForKey:defaultName];
	return [object doubleValue];
}
+ (void)userInfoSetDouble:(double)value forKey:(NSString *)defaultName
{
	NSUserDefaults *unsignedLongLongObject = [NSUserDefaults standardUserDefaults];
	NSNumber *dataNum = [[NSNumber alloc] initWithDouble:value];
	[self setSecuredObject:dataNum forKey:defaultName userDefaults:unsignedLongLongObject];
//	[dataNum release];
	[unsignedLongLongObject synchronize];
}


+ (NSInteger)userInfoUnsignedIntForKey:(NSString *)defaultName
{
	id object = [self validateValueForKey:defaultName];
	return [object integerValue];
}
+ (void)userInfoSetUnsignedInt:(NSInteger)value forKey:(NSString *)defaultName
{
	NSUserDefaults *integerObject = [NSUserDefaults standardUserDefaults];
	NSNumber *dataNum = [[NSNumber alloc] initWithInteger:value];
	[self setSecuredObject:dataNum forKey:defaultName userDefaults:integerObject];
//	[dataNum release];
	[integerObject synchronize];
}


+ (id)userInfoUserDefinedObjectForKey:(NSString *)defaultName//自定义类
{
	NSData	*data = [self validateValueForKey:defaultName];
	return [NSKeyedUnarchiver unarchiveObjectWithData: data];
}
+ (void)userInfoUserDefinedSetObject:(id)value forKey:(NSString *)defaultName//自定义类
{
	NSUserDefaults *saveUserInfoToPhone = [NSUserDefaults standardUserDefaults];
	NSData* data = [NSKeyedArchiver archivedDataWithRootObject: value];
	[self setSecuredObject:data forKey:defaultName userDefaults:saveUserInfoToPhone];
	[saveUserInfoToPhone synchronize];
}

- (id)init
{
	if (self = [super init]) {
		userDefaultsObj = [NSUserDefaults standardUserDefaults];
	}
	return self;
}
- (void)userInfoObjectSetObject:(id)value forKey:(NSString *)defaultName
{
	[UserInfoManager setSecuredObject:value forKey:defaultName userDefaults:userDefaultsObj];
}
- (void)userInfoObjectSetBool:(BOOL)value forKey:(NSString *)defaultName
{
	NSNumber *dataNum = [[NSNumber alloc] initWithBool:value];
	[UserInfoManager setSecuredObject:dataNum forKey:defaultName userDefaults:userDefaultsObj];
//	[dataNum release];
}
- (void)userInfoObjectSetUnsignedLongLong:(unsigned long long)value forKey:(NSString *)defaultName
{
	NSNumber *dataNum = [[NSNumber alloc] initWithUnsignedLongLong:value];
	[UserInfoManager setSecuredObject:dataNum forKey:defaultName userDefaults:userDefaultsObj];
//	[dataNum release];
}
- (void)userInfoObjectSetInteger:(NSInteger)value forKey:(NSString *)defaultName
{
	NSNumber *dataNum = [[NSNumber alloc] initWithInteger:value];
	[UserInfoManager setSecuredObject:dataNum forKey:defaultName userDefaults:userDefaultsObj];
//	[dataNum release];
}
- (BOOL)userInfoObjectSynchronize
{
	if ( [userDefaultsObj synchronize] ) {
		return TRUE;
	}
	else {
		return FALSE;
	}
}

+ (void)userInfoRemoveObjectForKey:(NSString *)defaultName
{
    NSUserDefaults *flushObject = [NSUserDefaults standardUserDefaults];
	[flushObject removeObjectForKey:defaultName];
	[flushObject synchronize];
}
+ (void)flushUserInfo
{
	NSUserDefaults *flushObject = [NSUserDefaults standardUserDefaults];

/*************************************************用户信息*/
//    [flushObject removeObjectForKey:USER_DB_INIT_FLAG];
    
    
	[flushObject synchronize];
}


@end
