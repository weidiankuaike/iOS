//
//  VoucherViewMedel.h
//  微点筷客商户端
//
//  Created by Skyer God on 16/10/24.
//  Copyright © 2016年 张森森. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VoucherViewMedel : NSObject

/** cardTitle  (NSString) **/
@property (nonatomic, copy) NSString *cardTitle;
/** 卡券ID   (strong) **/
@property (nonatomic, copy) NSString *voucheID;
/** 卡券类型   (copy) 0:代金券，1:折扣卷，2：店铺活动（满减）3：店铺活动（折扣）**/
@property (nonatomic, copy) NSString *cardType;
/** 优惠金额   (copy) **/
@property (nonatomic, copy) NSString *discountedPrice;
/** 折扣  (NSString) **/
@property (nonatomic, copy) NSString *discount;
/** 补贴卡，官方发放  (NSString) **/
@property (nonatomic, copy) NSString *subsidyCard;
/** 发放时机  (NSString) **/
@property (nonatomic, copy) NSString *issuingOpportunity;
/** 使用条件  (NSString) **/
@property (nonatomic, copy) NSString *conditions;
/** 开始时间  (NSString) **/
@property (nonatomic, copy) NSString *beginTime;
/** 结束时间  (NSString) **/
@property (nonatomic, copy) NSString *endTime;
/** 补贴卡代替补贴金额  (NSString) **/
@property (nonatomic, copy) NSString *consumptionOver;
/** 卡券有效状态 0 启用 1 停用  2 过期  type
  (NSString) **/
@property (nonatomic, copy) NSString *type;

/** <#行注释#>   (strong) **/
@property (nonatomic, strong) NSMutableDictionary *voucherDic;

@end
