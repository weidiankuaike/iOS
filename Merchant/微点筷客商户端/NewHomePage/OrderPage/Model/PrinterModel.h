//
//  PrinterModel.h
//  微点筷客商户端
//
//  Created by Skyer God on 17/1/3.
//  Copyright © 2017年 张森森. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PrinterModel : NSObject
/** 订单号  (NSString) **/
@property (nonatomic, copy) NSString *orderId;
/** 到店时间  (NSString) **/
@property (nonatomic, copy) NSString *arrivalTime;
/** 订单状态  (NSString) **/
@property (nonatomic, copy) NSString *orderType;
/** 订单名称（用户昵称）  (NSString) **/
@property (nonatomic, copy) NSString *orderName;
/** 用餐人数  (NSString) **/
@property (nonatomic, copy) NSString *mealsNo;
/** 商家电话  (NSString) **/
@property (nonatomic, copy) NSString *storePhone;
/** 订单商品详情  (NSString) **/
@property (nonatomic, strong) NSArray *orderDets;
/** 订单商品名称(orderDets里)  (NSString) **/
@property (nonatomic, copy) NSString *productName;
/** 订单商品数量(orderDets里)  (NSString) **/
@property (nonatomic, copy) NSString *quantity;
/** 订单商品单价(orderDets里)  (NSString) **/
@property (nonatomic, copy) NSString *fee;
/** 到店次数  (NSString) **/
@property (nonatomic, copy) NSString *severalStore;
/** 创建时间  (NSString) **/
@property (nonatomic, copy) NSString *createTime;
/** 订单人电话  (NSString) **/
@property (nonatomic, copy) NSString *userPhone;
/** 优惠标题  (NSString) **/
@property (nonatomic, copy) NSString *cardTitle;
/** 优惠金额  (NSString) **/
@property (nonatomic, copy) NSString *discountedPrice;
/** 实付金额  (NSString) **/
@property (nonatomic, copy) NSString *realTotalFee;
/** 餐桌  (NSString) **/
@property (nonatomic, copy) NSString *boardNum;
/** 备注信息  (NSString) **/
@property (nonatomic, copy) NSString *remark;
/** 打印联数  (NSString) **/
@property (nonatomic, copy) NSString *printPage;


/** 可选择退菜菜单  (NSString) **/
@property (nonatomic, strong) NSMutableArray *beBackDets;
/** 已退菜菜单  (NSString) **/
@property (nonatomic, strong) NSMutableArray *hasBackDets;
/** 退菜前剩余金额  不包含优惠金额(NSString) **/
@property (nonatomic, copy) NSString *backMoneyCondition;
/** 优惠条件  (NSString) **/
@property (nonatomic, copy) NSString *consumptionOver;
/** 退菜金额  (NSString) **/
@property (nonatomic, copy) NSString *retreatPrice;
@end

