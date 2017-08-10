//
//  OrderModel.h
//  微点筷客商户端
//
//  Created by 张森森 on 16/12/16.
//  Copyright © 2016年 张森森. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OrderPrintDetailModel.h"
@interface OrderModel : NSObject

@property(nonatomic,copy)NSString *imagestr, * namestr,*idstr,*creattime,*orderidstr,*userid,*totalmoney,*arrivaltime,*arrivalTime,*peoplenumstr,*ordertype,*phonestr,*severalStore,*tomeval,*ddbhstr,*remarkstr,*orderid;
@property (nonatomic,strong)NSMutableArray * caipinary,*numary,*caimoneyary;
@property (nonatomic,strong)NSDate * timeld;

/** 卡券类型  (NSString) **/
@property (nonatomic, copy) NSString *cardTitle;
/** 优惠类型  (NSString) **/
@property (nonatomic, copy) NSString *cardType;
/** 到店实付  (NSString) **/
@property (nonatomic, copy) NSString *realTotalFee;
/** 优惠金额  (NSString) **/
@property (nonatomic, copy) NSString *discountedPrice;
/** 桌号 用于订单进行中展示  (NSString) **/
@property (nonatomic, copy) NSString *boardNum;
/** 到店消费  (NSString) **/
@property (nonatomic, copy) NSString *extraFee;
/** 到店用餐  (NSString) **/
@property (nonatomic, copy) NSString *disOrderType;
/** 菜品详情   (strong) **/
@property (nonatomic, strong) NSMutableArray *orderDets;
/** 卡券id 没有用卡券为0  (NSString) **/
@property (nonatomic, copy) NSString *activitiesId;
-(id)initWithgetsomethingwithdict:(NSDictionary*)dict;

/** 可选择退菜菜单  (NSString) **/
@property (nonatomic, strong) NSMutableArray <OrderPrintDetailModel *> *beBackDets;
/** 已退菜菜单  (NSString) **/
@property (nonatomic, strong) NSMutableArray <OrderPrintDetailModel *> *hasBackDets;
/** 退菜前剩余金额  不包含优惠金额(NSString) **/
@property (nonatomic, copy) NSString *backMoneyCondition;
/** 优惠条件  (NSString) **/
@property (nonatomic, copy) NSString *consumptionOver;
@end
