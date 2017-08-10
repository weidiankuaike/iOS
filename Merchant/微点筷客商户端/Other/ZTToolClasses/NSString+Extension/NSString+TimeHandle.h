//
//  NSString+TimeHandle.h
//  微点筷客商户端
//
//  Created by Skyer God on 2017/4/20.
//  Copyright © 2017年 张森森. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef NS_ENUM (NSUInteger, TimeFormatOptions){
    TIME_TO_SEC,//精确到时分秒
    TIME_TO_DAY,//精确到天数
};
@interface NSString (TimeHandle)

//获取当前时间
+ (NSString *)getDateFromNow:(TimeFormatOptions )options;
//获取从时间戳获取日起
- (NSString *)getDateTimeFromTimeStrWithOption:(TimeFormatOptions )options;
//获取当前时间戳
- (NSInteger )getDateNumberStrFromNow:(TimeFormatOptions )options;
//获取时间差
+(NSDateComponents *)getDateSubFromNowTime:(NSString *)beginTime endTime:(NSString *)endTime;
@end
