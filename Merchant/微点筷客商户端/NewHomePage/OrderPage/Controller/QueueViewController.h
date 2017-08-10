//
//  QueueViewController.h
//  微点筷客商户端
//
//  Created by 张森森 on 16/10/31.
//  Copyright © 2016年 张森森. All rights reserved.
//

#import "BaseNaviSetVC.h"
 typedef void(^queueblock)(NSInteger queueint);
@interface QueueViewController : BaseNaviSetVC

@property (nonatomic,copy)queueblock block;




//-(void)GetsomethingWithblock:(queueblock)block;
@end
