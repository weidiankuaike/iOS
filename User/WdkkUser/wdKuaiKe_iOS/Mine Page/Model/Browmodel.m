//
//  Browmodel.m
//  wdKuaiKe_iOS
//
//  Created by 张森森 on 16/12/24.
//  Copyright © 2016年 weiDianKuaiKe. All rights reserved.
//

#import "Browmodel.h"

@implementation Browmodel
-(id)initWithgetstrwithdict:(NSDictionary*)dict
{
    self = [self init];
    if (self)
    {
//        NSString * distancestr = [dict objectForKey:@"distance"];
        float dist = [dict[@"distance"] floatValue];
        if (dist>1000) {
            
            _distance = [NSString stringWithFormat:@"%.2fkm",dist/1000];
        }
        else
        {
            _distance = [NSString stringWithFormat:@"%.2fm",dist];
        }
        
        
        _introduction = [dict objectForKey:@"introduction"];
        _namestr = [dict objectForKey:@"name"];
        _pricestr = [dict objectForKey:@"perCapitaPrice"];
        _storeidstr = [dict objectForKey:@"storeId"];
        _storeidimage = [NSString stringWithFormat:@"%@",dict[@"storeImage"]];
        
        
    }
    
    
    return self;
}
@end
