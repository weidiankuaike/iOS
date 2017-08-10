//
//  LoginStoreInfoModel.h
//  微点筷客商户端
//
//  Created by Skyer God on 17/1/12.
//  Copyright © 2017年 张森森. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LoginStoreInfoModel : NSObject
/** 商家地址  (NSString) **/
@property (nonatomic, copy) NSString *address;
/** <#注释#>  (NSString) **/
@property (nonatomic, copy) NSString *announcementStatus;
/** 可提前预订天数  (NSString) **/
@property (nonatomic, copy) NSString *bookDays;
/** 餐厅经营范围  (NSString) **/
@property (nonatomic, copy) NSString *catagory;
/** 座机号  (NSString) **/
@property (nonatomic, copy) NSString *cellphone;
/** 店铺创建时间  (NSString) **/
@property (nonatomic, copy) NSString *createTime;
/** 店铺id (NSString) **/
@property (nonatomic, copy) NSString *id;
/** 身份证背面  (NSString) **/
@property (nonatomic, copy) NSString *idCardImgDown;
/** 正面  (NSString) **/
@property (nonatomic, copy) NSString *idCardImgUp;
/** 店铺介绍  (NSString) **/
@property (nonatomic, copy) NSString *introduction;
/** 是否通过审核  (NSString) -1 未提交审核 0 等待审核 1 审核通过 2 初始化设置 3 完成设置**/
@property (nonatomic, copy, readonly) NSString *isChecked;
/** 入驻后是否通过审核  (assign) isEdit 0 提交资料 1 正在审核 2 完成认证 **/
@property (nonatomic, copy, readonly) NSString *isEdit;
/** 0正常 1排队 2繁忙   (NSString) **/
@property (nonatomic, copy, readonly) NSString *isWait;
/** 北纬  (NSString) **/
@property (nonatomic, copy) NSString *lat;
/** <#注释#>  (NSString) **/
@property (nonatomic, copy) NSString *level;
/** 东经  (NSString) **/
@property (nonatomic, copy) NSString *lng;
/** 店铺名称  (NSString) **/
@property (nonatomic, copy) NSString *name;
/** 商家公告  (NSString) **/
@property (nonatomic, copy) NSString *noticeBoard;
/** 营业执照  (NSString) **/
@property (nonatomic, copy) NSString *openZz;
/** 总销售量  (NSString) **/
@property (nonatomic, copy) NSString *orderSales;
/** 均价  (NSString) **/
@property (nonatomic, copy) NSString *perCapitaPrice;
/** 0休业 1营业 2繁忙  (NSString) **/
@property (nonatomic, copy, readonly) NSString *status;
/** 店铺logo  (NSString) **/
@property (nonatomic, copy) NSString *storeImage;
/** 营业许可证  (NSString) **/
@property (nonatomic, copy) NSString *storeLicense;
/** 餐厅负责人  (NSString) **/
@property (nonatomic, copy) NSString *storeManager;
/** 版本号  (NSString) **/
@property (nonatomic, copy, readonly) NSString *version;
/** 排队等待时间  (NSString) **/
@property (nonatomic, copy) NSString *waitTime;
@end
