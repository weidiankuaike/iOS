//
//  AddVoucherVC.h
//  微点筷客商户端
//
//  Created by Skyer God on 16/10/24.
//  Copyright © 2016年 张森森. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseNaviSetVC.h"
#import "VoucherViewMedel.h"

typedef void(^returnValues)(NSMutableDictionary *dic);
@interface AddVoucherVC : BaseNaviSetVC
/** block属性   (copy) **/
@property (nonatomic, copy) returnValues returnValues;
- (void)returnVoucherValues:(returnValues)valuesDic;

/** 卡券model   (strong) **/
@property (nonatomic, strong) VoucherViewMedel *model;

/** 卡券类型  (NSString) **/ 
@property (nonatomic, copy) NSString *category;

/** 判断是添加活动还是添加卡券   (NSInteger) **/
@property (nonatomic, assign) BOOL isVoucherCard;
@end
