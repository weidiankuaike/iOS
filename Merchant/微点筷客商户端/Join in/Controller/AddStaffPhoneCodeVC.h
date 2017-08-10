//
//  AddStaffPhoneCodeVC.h
//  微点筷客商户端
//
//  Created by Skyer God on 17/1/11.
//  Copyright © 2017年 张森森. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseNaviSetVC.h"
@interface AddStaffPhoneCodeVC :BaseNaviSetVC
/** 员工号码  (NSString) **/
@property (nonatomic, copy) NSString *phoneNum;
/** 员工姓名  (NSString) **/
@property (nonatomic, copy) NSString *staffName;
/** 店铺名称  (NSString) **/
@property (nonatomic, copy) NSString *storeName;
/** 商户姓名  (NSString) **/
@property (nonatomic, copy) NSString *name;

/** 验证成功回调   (strong) **/
@property (nonatomic, strong) void(^vertiftSuccess)(BOOL success);
@end
