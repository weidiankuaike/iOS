//
//  OrderdetailViewController.h
//  wdKuaiKe_iOS
//
//  Created by 张森森 on 16/12/28.
//  Copyright © 2016年 weiDianKuaiKe. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Myordermodel.h"
@interface OrderdetailViewController : UIViewController

@property (nonatomic,strong)Myordermodel * model;
@property (nonatomic,copy)NSString * orderId;
@end
