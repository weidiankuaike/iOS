//
//  BackDishesVC.h
//  微点筷客商户端
//
//  Created by Skyer God on 2017/5/12.
//  Copyright © 2017年 张森森. All rights reserved.
//

#import "BaseNaviSetVC.h"
#import "OrderModel.h"

@interface BackDishesVC : BaseNaviSetVC
/** 订单号  (NSString) **/
@property (nonatomic, copy) NSString *orderId;
/** <#行注释#>   (strong) **/
@property (nonatomic, strong) NSMutableDictionary *selectDic;
/** <#行注释#>   (strong) **/
@property (nonatomic, strong) OrderModel *orderModel;
@end
