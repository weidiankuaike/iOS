//
//  JudgeViewController.h
//  wdKuaiKe_iOS
//
//  Created by 张森森 on 17/1/9.
//  Copyright © 2017年 weiDianKuaiKe. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Myordermodel.h"
@interface JudgeViewController : UIViewController
@property (nonatomic,copy) NSString * imagestr;//店铺图片
@property (nonatomic,copy) NSString * namestr;
@property (nonatomic,strong) Myordermodel * model;
@property (nonatomic,copy) NSString * orderId;
@end
