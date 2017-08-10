//
//  Shoucangcellmodel.m
//  wdKuaiKe_iOS
//
//  Created by 张森森 on 16/12/22.
//  Copyright © 2016年 weiDianKuaiKe. All rights reserved.
//

#import "Shoucangcellmodel.h"

@implementation Shoucangcellmodel
- (id)initWithgetsomethingwithdict:(NSDictionary*)dict
{
    self = [super init];
    if (self)
    {
        _namestr = dict[@"productName"];
        _imagestr = dict[@"images"];
        _caiid = dict[@"productId"];
        _moneystr = dict[@"fee"];
        
        NSLog(@"lll%@ %@",_moneystr,_imagestr);
        
    }
    
    return self;
}
@end
