//
//  VerifyViewController.h
//  微点筷客商户端
//
//  Created by 张森森 on 16/10/8.
//  Copyright © 2016年 张森森. All rights reserved.
//

#import "BaseNaviSetVC.h"

@interface VerifyViewController : BaseNaviSetVC
@property (nonatomic,assign)CGFloat pageOffset;//审核状态 0 填写审核资料  1 等待审核 2 填写餐厅资料
@property (nonatomic,assign)NSInteger isJohnedStatus;//判断更多设置或者初始设置 判断入驻前1 还是入住后2
@property (nonatomic,strong)NSDictionary * xxdict;
@end
