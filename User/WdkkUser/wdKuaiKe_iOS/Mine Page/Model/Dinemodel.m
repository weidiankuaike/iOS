//
//  Dinemodel.m
//  wdKuaiKe_iOS
//
//  Created by 张森森 on 17/1/4.
//  Copyright © 2017年 weiDianKuaiKe. All rights reserved.
//

#import "Dinemodel.h"

@implementation Dinemodel
-(id)initWithgetsomethingwithdict:(NSDictionary*)dict
{
    self = [super init];
    if (self)
    {
        NSString * image = [NSString stringWithFormat:@"%@",[dict objectForKey:@"images"]];
        NSArray * imageary = [image componentsSeparatedByString:@"?"];
        _imagestr = imageary.firstObject;
         
        _islack = [[dict objectForKey:@"isLack"] integerValue];
        _orderid = [dict objectForKey:@"orderId"];
        _productname = [dict objectForKey:@"productName"];
        _productnumber = [[dict objectForKey:@"quantity"] integerValue];
        _served =  [[dict objectForKey:@"foodNum"] integerValue];
        _foodIndex = [NSString stringWithFormat:@"%@",[dict objectForKey:@"foodIndex"]];
        
    }
    
    return self;
}

@end
