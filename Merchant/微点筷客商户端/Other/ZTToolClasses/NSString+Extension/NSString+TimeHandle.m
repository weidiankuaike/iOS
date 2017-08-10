//
//  NSString+TimeHandle.m
//  微点筷客商户端
//
//  Created by Skyer God on 2017/4/20.
//  Copyright © 2017年 张森森. All rights reserved.
//

#import "NSString+TimeHandle.h"

@implementation NSString (TimeHandle)
+ (NSString *)getDateFromNow:(TimeFormatOptions)options{
    NSDate *date = [NSDate dateWithTimeIntervalSinceNow:0];
    NSDateFormatter * dateformatter = [[NSDateFormatter alloc]init];
    if (options == 0) {
        [dateformatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    } else {
        [dateformatter setDateFormat:@"yyyy-MM-dd"];
    }
    return [dateformatter stringFromDate:date];
}
+(NSDateComponents *)getDateSubFromNowTime:(NSString *)beginTime endTime:(NSString *)endTime {
    //    // 截止时间字符串格式
    //    NSString *expireDateStr = endTime;
    //    // 当前时间字符串格式
    NSDate *nowDate = [NSDate date];
    NSDateFormatter *dateFomatter = [[NSDateFormatter alloc] init];
    dateFomatter.dateFormat = @"yyyy-MM-dd HH:mm:ss.0";


    NSString *nowDateStr = [dateFomatter stringFromDate:nowDate];
    // 截止时间data格式
    NSString *expireDate =  [dateFomatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:[endTime integerValue] / 1000]];
    NSDate *expireD = [dateFomatter dateFromString:expireDate];
    // 当前时间data格式
    nowDate = [dateFomatter dateFromString:nowDateStr];
    // 当前日历
    NSCalendar *calendar = [NSCalendar currentCalendar];
    // 需要对比的时间数据
    NSCalendarUnit unit = NSCalendarUnitYear | NSCalendarUnitMonth
    | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    // 对比时间差
    NSDateComponents *dateCom = [calendar components:unit fromDate:expireD toDate:nowDate options:0];

    return dateCom;
}
- (NSString *)getDateTimeFromTimeStrWithOption:(TimeFormatOptions)options{
    NSTimeInterval timestr = [self doubleValue]/1000.0;
    NSDate * detaild = [NSDate dateWithTimeIntervalSince1970:timestr];
    NSDateFormatter * dateformatter = [[NSDateFormatter alloc]init];
    if (options == 0) {
        [dateformatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    } else {
        [dateformatter setDateFormat:@"yyyy-MM-dd"];
    }
    return [dateformatter stringFromDate:detaild];
}
- (NSInteger )getDateNumberStrFromNow:(TimeFormatOptions)options{
    NSDate* date = [NSDate dateWithTimeIntervalSinceNow:0];
    // *1000 是精确到毫秒，不乘就是精确到秒
    NSTimeInterval a = 0;
    if (options == 0) {
         a=[date timeIntervalSince1970]*1000;
    } else {
         a=[date timeIntervalSince1970]*1000;
    }
    return a;
}


@end
