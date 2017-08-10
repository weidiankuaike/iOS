//
//  DishesInfoModel.h
//  微点筷客商户端
//
//  Created by Skyer God on 16/10/19.
//  Copyright © 2016年 张森森. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DishesInfoModel : NSObject
/** 菜名  (NSString) **/
@property (nonatomic, copy) NSString *dishesName;
/** 菜样图片  (NSString) **/
@property (nonatomic, copy) id img;
/** 价格  (NSString) **/
@property (nonatomic, copy) NSString *price;
/** 分类  (NSString) **/
@property (nonatomic, copy) NSString *category;
/** 菜ID标示  (NSString) **/
@property (nonatomic, copy) NSString *dishesID;
/** 是否下架  (NSString) **/
@property (nonatomic, copy) NSString *downStair;

/** 菜品描述  (NSString) **/
@property (nonatomic, copy) NSString *descrpt;
/** 店铺ID   (strong) **/
@property (nonatomic, copy) NSString *pstoreId;


/** 分类ID   (strong) **/
@property (nonatomic, strong) NSString *categoryId;
/** 所有菜品id   (strong) **/
@property (nonatomic, strong) NSDictionary *allDishesIdDic;

@end
