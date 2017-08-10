//
//  SearchStoreModel.h
//  wdKuaiKe_iOS
//
//  Created by 张森森 on 17/1/18.
//  Copyright © 2017年 weiDianKuaiKe. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SearchStoreModel : NSObject
@property (nonatomic,copy)NSString * storeId;//店铺id
@property (nonatomic,copy)NSString * storeName;//店铺名称
@property (nonatomic,copy)NSString * storeImage;//logo
@property (nonatomic,copy)NSString * avgScore;//评分
@property (nonatomic,strong)NSArray * voList;
@property (nonatomic,copy)NSString * sales;//菜品销量
@property (nonatomic,copy)NSString * distance;//距离
@property (nonatomic,copy)NSString * perCapitaPrice;//人均价格
@property (nonatomic,copy)NSString * orderSales;//店铺成交量
@property (nonatomic,copy)NSString * storeAct;//优惠券
@property (nonatomic,strong)NSArray * activList;//店铺活动
@end
