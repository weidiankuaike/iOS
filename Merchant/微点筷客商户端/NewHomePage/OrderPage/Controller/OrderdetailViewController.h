//
//  OrderdetailViewController.h
//  微点筷客商户端
//
//  Created by 张森森 on 16/10/10.
//  Copyright © 2016年 张森森. All rights reserved.
//

#import "BaseNaviSetVC.h"
#import "OrderModel.h"
@interface OrderdetailViewController : BaseNaviSetVC
@property (nonatomic,assign)NSInteger ztingeger;//1 已预订
/** 订单记录  (NSString) **/
@property (nonatomic, assign) BOOL isOrderRecord;
@property (nonatomic,strong)OrderModel * model;
/** 订单详情界面接单回调   (strong) **/
@property (nonatomic, strong) void(^clickReceiveOrderBT)(BOOL receive);
@end
