//
//  UserInfoManager.h
//  MDSNS
//
//  Created by fyp on 13-6-6.
//  Copyright (c) 2013年 fyp. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface UserInfoManager : NSObject

#define SignTimeSave @"SignTimeSave_Act"

#define SignAlarmId @"SignAlarmId"
#define UserIsOpenAlarm @"UserIsOpenAlarm"

#define UserName @"userName"
#define UserSecret @"userSecret"

#define UserNeedReflesh @"UserNeedReflesh"

#define expired_time @"expired_time"//token的过期时间

#define UserKind @"kind"//用户类型
#define UserLevel @"level"
#define UserExp @"exp"

#define UserSex @"sex"//用户类型

#define UserDeviceToken @"UserDeviceToken"//token
/**
 *  商品类目 存储key
 */
#define GoodsListList @"GoodsListList"

#define UserUID @"UID"
#define UserGroup_id @"group_id"
#define UserType @"type"
#define UserEmail @"email"

#define UserStatus @"status"
#define UserRegip @"regip"
#define UserRegdate @"regdate"
#define UserLastloginip @"lastloginip"
#define UserLastlogintime @"lastlogintime"
#define UserScore @"score"
#define UserMoney @"money"

#define UserBirthday @"birthday"

+ (void)setSecret:(NSString *)secret;

+(void)userInfoSetDefineObject:(id)value forKey:(NSString *)defaultName;
+ (id)userInfoDefineObjectForKey:(NSString *)defaultName;
//id
+ (id)userInfoObjectForKey:(NSString *)defaultName;
+ (void)userInfoSetObject:(id)value forKey:(NSString *)defaultName;

//bool
+ (BOOL)userInfoBoolForKey:(NSString *)defaultName;
+ (void)userInfoSetBool:(BOOL)value forKey:(NSString *)defaultName;

//unsigned long long
+ (unsigned long long)userInfoUnsignedLongLongForKey:(NSString *)defaultName;
+ (void)userInfoSetUnsignedLongLong:(unsigned long long)value forKey:(NSString *)defaultName;

//double
+ (double)userInfoDoubleForKey:(NSString *)defaultName;
+ (void)userInfoSetDouble:(double)value forKey:(NSString *)defaultName;

//unsigned int
+ (NSInteger)userInfoUnsignedIntForKey:(NSString *)defaultName;
+ (void)userInfoSetUnsignedInt:(NSInteger)value forKey:(NSString *)defaultName;

//自定义类
+ (id)userInfoUserDefinedObjectForKey:(NSString *)defaultName;//自定义类
+ (void)userInfoUserDefinedSetObject:(id)value forKey:(NSString *)defaultName;//自定义类


- (id)init;
- (void)userInfoObjectSetObject:(id)value forKey:(NSString *)defaultName;
- (void)userInfoObjectSetBool:(BOOL)value forKey:(NSString *)defaultName;
- (void)userInfoObjectSetUnsignedLongLong:(unsigned long long)value forKey:(NSString *)defaultName;
- (void)userInfoObjectSetInteger:(NSInteger)value forKey:(NSString *)defaultName;
- (BOOL)userInfoObjectSynchronize;

+ (void)userInfoRemoveObjectForKey:(NSString *)defaultName;
+ (void)flushUserInfo;

+(void)removeUserMessage;
+ (void)userInfoSetMyObject:(id)value forKey:(NSString *)defaultName;
+ (id)userInfoMyObjectForKey:(NSString *)defaultName;
+ (void)userInfoRemoveMyObjectForKey:(NSString *)defaultName;
@end



#pragma mark -
#pragma mark CC_MD5
@interface NSString (PASSWORDUserDefaults)
- (NSString *)md5Hash;

@end


