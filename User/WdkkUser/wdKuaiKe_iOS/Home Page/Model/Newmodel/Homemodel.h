//
//  Homemodel.h
//  wdKuaiKe_iOS
//
//  Created by 张森森 on 17/1/11.
//  Copyright © 2017年 weiDianKuaiKe. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Homemodel : NSObject

//id
@property (nonatomic,copy)NSString * storeId;
//名称
@property (nonatomic,copy)NSString * name;
//图片
@property (nonatomic,copy)NSString * storeImage;
//人均价
@property (nonatomic,copy)NSString * perCapitaPrice;
//成交量
@property (nonatomic,copy)NSString * orderSales;
//评分
@property (nonatomic,assign)double level;
//距离
@property (nonatomic,copy)NSString * distance;

@end
