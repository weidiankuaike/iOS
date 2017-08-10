//
//  MyticketModel.m
//  wdKuaiKe_iOS
//
//  Created by 张森森 on 16/12/21.
//  Copyright © 2016年 weiDianKuaiKe. All rights reserved.
//

#import "MyticketModel.h"

@implementation MyticketModel

-(id)initWithGetstrWithdict:(NSDictionary*)dict
{
    self = [super init];
    if (self)
    {
        NSString * begtimestr = [dict objectForKey:@"startTime"];
        NSString * endtimestr = [dict objectForKey:@"overTime"];
        _cardtype = [NSString stringWithFormat:@"%@",[dict objectForKey:@"cardType"]];
        if ([_cardtype isEqualToString:@"0"]) {
            _discount = [dict objectForKey:@"discountedPrice"];
        }
        else
        {
            _discount = [dict objectForKey:@"discount"];
        }
        
        
        _consumover = [dict objectForKey:@"consumptionOver"];
        
        _typestr = [NSString stringWithFormat:@"%@",[dict objectForKey:@"type"]] ;
        
        _namestr = [dict objectForKey:@"cardTitle"];
        _conditions = [dict objectForKey:@"conditions"];
        _cardId = dict[@"id"];
        
        NSTimeInterval timestr = [begtimestr doubleValue]/1000.0;
        NSDate * detaild = [NSDate dateWithTimeIntervalSince1970:timestr];
        NSDateFormatter * dateformatter = [[NSDateFormatter alloc]init];
        [dateformatter setDateFormat:@"yyyy-MM-dd"];
        _begintime = [dateformatter stringFromDate:detaild];
        
        
        NSTimeInterval arrveltime = [endtimestr doubleValue]/1000.0;
        NSDate* timeld = [NSDate dateWithTimeIntervalSince1970:arrveltime];
        NSDateFormatter * dateformatte = [[NSDateFormatter alloc]init];
        [dateformatte setDateFormat:@"yyyy-MM-dd"];
        _endtime = [dateformatte stringFromDate:timeld];
        
        
    }
    
    
    
    return self;
}

@end
