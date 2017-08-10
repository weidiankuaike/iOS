//
//  ShoucangModel.m
//  wdKuaiKe_iOS
//
//  Created by 张森森 on 16/12/22.
//  Copyright © 2016年 weiDianKuaiKe. All rights reserved.
//

#import "ShoucangModel.h"

@implementation ShoucangModel
- (id)initWithgetsomethingwithdict:(NSDictionary*)dictary
{
    self = [super init];
    if (self)
    {
        
            _modelarray = [NSMutableArray array];
            _storenamestr = dictary[@"name"];
            _storeid = dictary[@"storeId"];
            _storeimage = dictary[@"storeImage"];
            
            NSArray * xinxiary = dictary[@"myCollectVoList"];
            for (int a =0; a<xinxiary.count; a++)
            {
                Shoucangcellmodel * model = [[Shoucangcellmodel alloc]initWithgetsomethingwithdict:xinxiary[a]];
                [_modelarray addObject:model];
            }
        
            
            
            
        
        
        
        
    }
    
    
    return self;
}



@end
