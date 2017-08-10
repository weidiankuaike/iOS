//
//  TimeErectViewController.h
//  微点筷客商户端
//
//  Created by 张森森 on 16/12/8.
//  Copyright © 2016年 张森森. All rights reserved.
//

#import "BaseNaviSetVC.h"

@interface TimeErectViewController : BaseNaviSetVC
/** 入驻状态   (NSInteger) **/
@property (nonatomic, assign) NSInteger isChecked;
/** 设置时间成功后回调   (strong) **/
@property (nonatomic, strong) void(^timeSuccess)(BOOL success);
@end
