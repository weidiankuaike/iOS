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

    if ([self isEqual:[NSNull null]])
    {
        return YES;
    }
    else
    {
        if ([self isKindOfClass:[NSNull class]])
        {
            return YES;
        }
        else
        {
            if (self==nil)
            {
                return YES;
            }
        }
    }
    if ([self isKindOfClass:[NSString class]]) {
        if ([((NSString *)self) isEqualToString:@"<null>"] || [((NSString *)self) isEqualToString:@""] || self == nil) {
            return YES;
        }
    }
    return NO;
}
@end
