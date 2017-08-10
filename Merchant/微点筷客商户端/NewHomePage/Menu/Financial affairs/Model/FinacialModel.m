//
//  FinacialModel.m
//  微点筷客商户端
//
//  Created by 张森森 on 16/12/14.
//  Copyright © 2016年 张森森. All rights reserved.
//

#import "FinacialModel.h"

@implementation FinacialModel
-(id)initWithgetsonthingwithdict:(NSDictionary*)dict
{
    self = [super init];
    if (self)
    {
        _cardstr = [dict objectForKey:@"transactionCard"];
        NSString * creattime = [dict objectForKey:@"createTime"];
        _balance = [dict objectForKey:@"transactionBalance"];//余额
        _moneystr = [dict objectForKey:@"transactionMoney"];
        _typestr = [dict objectForKey:@"transactionType"];
        _trackstr = [dict objectForKey:@"transactionTrack"];
        _statusstr = [dict objectForKey:@"transactionStatus"];
        _markstr = [dict objectForKey:@"transactionRemark"];
        _liushuistr = [dict objectForKey:@"transactionSn"];
        
        NSTimeInterval timestr = [creattime doubleValue]/1000.0;
        NSDate * detaild = [NSDate dateWithTimeIntervalSince1970:timestr];
        NSDateFormatter * dateformatter = [[NSDateFormatter alloc]init];
        [dateformatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        _timestr = [dateformatter stringFromDate:detaild];

    }
    
    
    return self;
}
@end
