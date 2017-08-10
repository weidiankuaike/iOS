//
//  AssignViewController.h
//  微点筷客商户端
//
//  Created by 张森森 on 16/10/14.
//  Copyright © 2016年 张森森. All rights reserved.
//

#import "BaseNaviSetVC.h"
 typedef void(^xianblack)(NSString * string);
@interface AssignViewController : BaseNaviSetVC
@property (nonatomic,copy)xianblack block;

-(void)getstring:(xianblack)block;
@end
