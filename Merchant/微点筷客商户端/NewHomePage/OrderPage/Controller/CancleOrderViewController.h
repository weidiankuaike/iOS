//
//  CancleOrderViewController.h
//  微点筷客商户端
//
//  Created by 张森森 on 16/10/13.
//  Copyright © 2016年 张森森. All rights reserved.
//

#import "BaseNaviSetVC.h"

@interface CancleOrderViewController : BaseNaviSetVC
@property (nonatomic,copy)NSString * orderid;
/** 取消上传成功之后   (strong) **/
@property (nonatomic, strong) void (^NetUploadSuccess)(BOOL success);
/** 订单状态（0 新订单 1-已预订 2-进行中）   (NSInteger) **/
@property (nonatomic, assign) NSInteger orderType;
/** haoma  (NSString) **/
@property (nonatomic, copy) NSString *phoneNum;
@end
