//
//  InnerKitchenModel.h
//  微点筷客商户端
//
//  Created by Skyer God on 16/11/9.
//  Copyright © 2016年 张森森. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface InnerKitchenModel : NSObject
/** 名称  (NSString) **/
@property (nonatomic, copy) NSString *name;
@property (nonatomic, assign) CGFloat height;
/** <#行注释#>   (strong) **/
@property (nonatomic, strong) NSMutableArray *array;


/** <#行注释#>   (NSInteger) **/
@property (nonatomic, assign) BOOL isShowDeleteLine;


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
/** 已上菜，且该桌未结账  (NSString) **/
@property (nonatomic, copy) NSString *served;
/** 上菜状态  (NSString) **/
@property (nonatomic, assign) Boolean isServed;//1 展示unserving, 0 展示served
/** 订单数组，留给滑动外层用  (nsstring) **/
@property (nonatomic, copy) NSString *ids;
@end
