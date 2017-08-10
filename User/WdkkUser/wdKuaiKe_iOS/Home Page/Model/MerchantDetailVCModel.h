//
//  MerchantDetailVCModel.h
//  wdKuaiKe_iOS
//
//  Created by Skyer God on 16/8/15.
//  Copyright © 2016年 weiDianKuaiKe. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MerchantDetailVCModel.h"

@interface MerchantDetailVCModel : NSObject

@property (nonatomic, copy) NSString *evaluateDetail;

/** 店铺ID **/
@property (nonatomic, assign) NSInteger merchantID;
/** 店铺名称 **/
@property (nonatomic, copy) NSString *name;
/** 店铺图片  (NSString) **/
@property (nonatomic, copy) NSString *storeImage;
/** 排队或预定 **/
@property (nonatomic, assign) NSInteger queue_or_book;
/** 推荐等级 **/
@property (nonatomic, assign) NSInteger level;
/** 均价 **/
@property (nonatomic, assign) NSInteger per_capita_price;
/** 店铺类型 **/
@property (nonatomic, copy) NSString *catagory;
/** 距离 **/
@property (nonatomic, assign) NSInteger distance;
/** 所在城市  (NSString) **/
@property (nonatomic, copy) NSString *city_name;



@end
