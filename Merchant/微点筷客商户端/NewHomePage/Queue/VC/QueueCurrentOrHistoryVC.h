//
//  QueueCurrentOrHistoryVC.h
//  微点筷客商户端
//
//  Created by Skyer God on 2017/7/5.
//  Copyright © 2017年 张甜. All rights reserved.
//

#import "BaseNaviSetVC.h"

@interface QueueCurrentOrHistoryVC : BaseNaviSetVC
/** 区分  0 正在排号 1 历史排号(NSInteger) **/
@property (nonatomic, assign) NSInteger vcType;
/** 导航标签下标索引 0 1 2   (NSInteger) **/
@property (nonatomic, assign) NSInteger selectIndex;
@end
