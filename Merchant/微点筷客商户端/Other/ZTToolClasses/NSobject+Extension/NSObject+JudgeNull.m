//
//  NSObject+JudgeNull.m
//  微点筷客商户端
//
//  Created by Skyer God on 16/12/6.
//  Copyright © 2016年 张森森. All rights reserved.
//

#import "NSObject+JudgeNull.h"

@implementation NSObject (JudgeNull)
//判断对象是否为空
- (BOOL)isNull
{

    if ([self isEqual:@""]) {
        return YES;
    }
    if (self == nil) {
        return YES;
    }
//    double start =  CFAbsoluteTimeGetCurrent();
    if ([self isEqual:[NSNull null]]) {
        return YES;
    } else {
        if ([self isKindOfClass:[NSNull class]]) {
            return YES;
        } else {
            if (self==nil) {
                return YES;
            }
        }
    }

    if ([self isKindOfClass:[NSString class]]) {
        if ([((NSString *)self) isEqualToString:@"<null>"] || [[((NSString *)self) stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]length]==0 || self == nil || [(NSString *)self isEqualToString:@""]) {
            return YES;
        }
    } else if ([self isKindOfClass:[NSArray class]] || [self isKindOfClass:[NSMutableArray class]]) {
        if ([((NSArray *)self) count] == 0 || [((NSMutableArray *)self) count] == 0) {
            return YES;
        }
    } else if ([self isKindOfClass:[NSDictionary class]] || [self isKindOfClass:[NSMutableDictionary class]]) {
        if ([((NSDictionary *)self) count] == 0 || [((NSMutableDictionary *)self) count] == 0) {
            return YES;
        }
    } else{
        ZTLog(@"++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++");
        ZTLog(@"%@", self);
    };
//    double end = CFAbsoluteTimeGetCurrent();
//    ZTLog(@"%lf", end - start);
    return NO;
}
- (NSString *)judgeDeskPeopleNumFromDeskCategory:(NSString *)category{
    NSDictionary *dic = @{@"双人":@"A", @"四人":@"B", @"多人":@"C"};
    __block NSString *deskPeopleNum = @"";
    [dic enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        if ([obj isEqualToString:category]) {
            deskPeopleNum = key;
            *stop = YES;
        }
    }];

    return deskPeopleNum;
}
- (NSString *)judgeDeskCategoryFromString:(NSString *)category{
    NSDictionary *dic = @{@"双人":@"A", @"四人":@"B", @"多人":@"C"};
    __block NSString *deskPeopleNum = @"";
    [dic enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        if ([obj isEqualToString:category]) {
            deskPeopleNum = key;
            *stop = YES;
        }
    }];

    return deskPeopleNum;
}


@end
