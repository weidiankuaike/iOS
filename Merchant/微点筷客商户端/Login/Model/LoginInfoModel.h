//
//  LoginInfoModel.h
//  微点筷客商户端
//
//  Created by Skyer God on 17/1/12.
//  Copyright © 2017年 张森森. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LoginStoreInfoModel.h"
@interface LoginInfoModel : NSObject
/** 商家logo  (NSString) **/
@property (nonatomic, copy) NSString *avatar;
/** 上架id  (NSString) **/
@property (nonatomic, copy) NSString *id;
/** 排队管理权限  (NSString) **/
@property (nonatomic, copy) NSString *isKitchenManage;
/** 订单管理权限  (NSString) **/
@property (nonatomic, copy) NSString *isOrderManage;
/** 现场服务权限  (NSString) **/
@property (nonatomic, copy) NSString *isServiceManage;
/** 餐厅管理权限  (NSString) **/
@property (nonatomic, copy) NSString *isStoreManage;
/** 登录账号  (NSString) **/
@property (nonatomic, copy) NSString *loginName;
/** 姓名  (NSString) **/
@property (nonatomic, copy) NSString *name;
/** 店铺信息  (NSString) **/
@property (nonatomic, strong) LoginStoreInfoModel *storeBase;
/** 是否是老板   (strong) **/
@property (nonatomic, strong) NSString *isBoss;
/** 是否通过审核  (NSString) 入驻前-1 未提交审核 0 等待审核 1 审核通过 2 初始化设置 3 完成设置 **/
@property (nonatomic, copy) NSString *isChecked;
/** 入驻前token  (NSString) **/
@property (nonatomic, copy) NSString *token;

@end
