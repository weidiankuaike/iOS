//
//  OutKitchenModel.h
//  微点筷客商户端
//
//  Created by Skyer God on 16/11/9.
//  Copyright © 2016年 张森森. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "InnerKitchenModel.h"
@interface OutKitchenModel : NSObject
/** 名称  (NSString) **/
@property (nonatomic, copy) NSString *name;
@property (nonatomic, assign) CGFloat height;
@property (nonatomic, strong) NSMutableArray *voList;

/** 外层控制cell收合   (strong) **/
@property (nonatomic, assign) BOOL isShow;



/* * * * 8* 8* 8 88 */

/** 菜品名称  (NSString) **/
@property (nonatomic, copy) NSString *productName;
/** 菜品ID  (NSString) **/
@property (nonatomic, copy) NSString *productId;
/** 该菜所有桌未上菜数量  (NSString) **/
@property (nonatomic, copy) NSString *unServingNum;
/** 菜品图片  (NSString) **/
@property (nonatomic, copy) NSString *images;
/** 餐桌号  (NSString) **/
@property (nonatomic, copy) NSString *boardNum;
/** 该菜该桌未上菜数量  (NSString) **/
@property (nonatomic, copy) NSString *unserved;
/** 订单id  (NSString) **/
@property (nonatomic, copy) NSString *orderId;
/** 内层model  (NSString) **/
@property (nonatomic, strong) InnerKitchenModel *innerModel;
/** 订单数组，留给滑动外层用  (nsstring) **/
@property (nonatomic, copy) NSString *ids;
@end
