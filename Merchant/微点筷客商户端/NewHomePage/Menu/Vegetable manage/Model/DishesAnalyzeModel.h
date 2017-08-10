//
//  DishesAnalyzeModel.h
//  merchantClient
//
//  Created by Skyer God on 2017/7/18.
//  Copyright © 2017年 张甜. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DishesAnalyzeModel : NSObject
/** 开始时间  (NSString) **/
@property (nonatomic, copy) NSString *beginTime;
/** 结束时间  (NSString) **/
@property (nonatomic, copy) NSString *endTime;
/** 好评  (NSString) **/
@property (nonatomic, copy) NSString *love;
/** 百分比  (NSString) **/
@property (nonatomic, copy) NSString *pct;
/** 销售量  (NSString) **/
@property (nonatomic, copy) NSString *productCnt;
/** 销售额  (NSString) **/
@property (nonatomic, copy) NSString *sumFee;
/** 菜品  (NSString) **/
@property (nonatomic, copy) NSString *productName;

#pragma mark --- 数据处理
/** 编号  (NSString) **/
@property (nonatomic, copy) NSString *number;
/** 检索类型 sum_fee销售额 product_cnt销售量  love好评 (NSString) **/
@property (nonatomic, copy) NSString *flowType;
@end
