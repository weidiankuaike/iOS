//
//  OrderPrintDetailModel.h
//  微点筷客商户端
//
//  Created by Skyer God on 17/1/4.
//  Copyright © 2017年 张森森. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OrderPrintDetailModel : NSObject
/** 订单商品名称(orderDets里)  (NSString) **/
@property (nonatomic, copy) NSString *productName;
/** 订单商品数量(orderDets里)  (NSString) **/
@property (nonatomic, copy) NSString *quantity;
/** (订单用)订单商品单价(orderDets里)  (NSString) **/
@property (nonatomic, copy) NSString *pfee;
/** （打印用）订单商品单价(orderDets里)  (NSString) **/
@property (nonatomic, copy) NSString *fee;
/** productImage  (NSString) **/
@property (nonatomic, copy) NSString *productImage;
/** 菜品ID  (NSString) **/
@property (nonatomic, copy) NSString *productId;
/** 退菜数量  (NSString) **/
@property (nonatomic, copy) NSString *isRetreat;
@end
