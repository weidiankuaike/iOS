//
//  StuffAccountModel.h
//  微点筷客商户端
//
//  Created by Skyer God on 17/1/10.
//  Copyright © 2017年 张森森. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface StuffAccountModel : NSObject
/** 员工姓名  (NSString) **/
@property (nonatomic, copy) NSString *name;
/** 号码  (NSString) **/
@property (nonatomic, copy) NSString *phone;
/** 排队管理权限  (NSString) **/
@property (nonatomic, copy) NSString *isKitchenManage;//0：关 1：开
/** 订单管理权限  (NSString) **/
@property (nonatomic, copy) NSString *isOrderManage;//0：关 1：开
/** 店铺管理权限  (NSString) **/
@property (nonatomic, copy) NSString *isStoreManage;//0：关 1：开
/** 现场管理权限  (NSString) **/
@property (nonatomic, copy) NSString *isServiceManage;//0：关 1：开
/** 级别  (NSString) **/
@property (nonatomic, copy) NSString *staffType;//修改员工时，0：店主 1：员工
/** 操作类型  (NSString) **/
@property (nonatomic, copy) NSString *operation;//0:查询 1：添加 2：删除 3：修改

/** 权限数组   (strong) **/
@property (nonatomic, strong) NSArray *manageArr;

/** 区分店主 店员  (NSString) **/
@property (nonatomic, assign) BOOL isBoss;
@end
