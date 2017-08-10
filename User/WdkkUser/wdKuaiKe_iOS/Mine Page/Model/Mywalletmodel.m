//
//  Mywalletmodel.m
//  wdKuaiKe_iOS
//
//  Created by 张森森 on 16/12/22.
//  Copyright © 2016年 weiDianKuaiKe. All rights reserved.
//

#import "Mywalletmodel.h"

@implementation Mywalletmodel

-(id)initWithgetstrWithdict:(NSDictionary*)dict
{
    self = [super init];
    
    if (self)
    {
        _namestr = [NSString stringWithFormat:@"%@",[dict objectForKey:@"payType"]] ;
        NSString * begtimestr = [dict objectForKey:@"createTime"];
        _ztstr = [NSString stringWithFormat:@"%@",[dict objectForKey:@"status"]] ;
        _moneystr = [dict objectForKey:@"payAmount"];
        
        NSTimeInterval timestr = [begtimestr doubleValue]/1000.0;
        NSDate * detaild = [NSDate dateWithTimeIntervalSince1970:timestr];
        NSDateFormatter * dateformatter = [[NSDateFormatter alloc]init];
        [dateformatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        _timestr = [dateformatter stringFromDate:detaild];
    }
    
    return self;
}



@end
