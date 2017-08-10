//
//  Myordermodel.m
//  wdKuaiKe_iOS
//
//  Created by 张森森 on 16/12/27.
//  Copyright © 2016年 weiDianKuaiKe. All rights reserved.
//

#import "Myordermodel.h"

@implementation Myordermodel

-(id)initWithgetsomethingwithdict:(NSDictionary*)dict
{
    self = [super init];
    if (self)
    {
        _storename = [dict objectForKey:@"storeName"];
        _storeimage = [NSString stringWithFormat:@"%@",[dict objectForKey:@"storeImage"]];
        _ordertype =  [NSString stringWithFormat:@"%@",[dict objectForKey:@"orderType"]] ;
        _moneystr = [dict objectForKey:@"totalFee"];
        _mealsno = [dict objectForKey:@"mealsNo"];
        _orderid = [dict objectForKey:@"orderId"];
        _timers = [dict objectForKey:@"timers"];
        _remaekstr = [dict objectForKey:@"remark"];
        _disorderType = [NSString stringWithFormat:@"%@",dict[@"disOrderType"]];
        
        _ordername = [dict objectForKey:@"orderName"];
        _addresstr = [dict objectForKey:@"address"];
        _storephone = [dict objectForKey:@"storePhone"];
        _storeid = [dict objectForKey:@"storeId"];
        
        if (![[dict objectForKey:@"orderId"] isNull]) {
              _caiary = [dict objectForKey:@"orderDets"];
        }
        
        
        NSString * arrvetime = [dict objectForKey:@"arrivalTime"];
        NSString * time = [dict objectForKey:@"createTime"];
        
        
        NSTimeInterval timestr = [time doubleValue]/1000.0;
        _creatimedata = [NSDate dateWithTimeIntervalSince1970:timestr];
        NSDateFormatter * dateformatter = [[NSDateFormatter alloc]init];
        [dateformatter setDateFormat:@"MM-dd HH:mm"];
        _creattime = [dateformatter stringFromDate:_creatimedata];
        
        
        NSTimeInterval arrveltime = [arrvetime doubleValue]/1000.0;
        _arrivedate = [NSDate dateWithTimeIntervalSince1970:arrveltime];
        NSDateFormatter * dateformatte = [[NSDateFormatter alloc]init];
        [dateformatte setDateFormat:@"MM-dd HH:mm"];
        _arrivaltime = [dateformatte stringFromDate:_arrivedate];
        
    }
    
    
    return self;
}
@end
