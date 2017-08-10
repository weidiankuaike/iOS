//
//  PaydetailViewController.h
//  wdKuaiKe_iOS
//
//  Created by 张森森 on 17/5/17.
//  Copyright © 2017年 weiDianKuaiKe. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PaydetailViewController : UIViewController
@property (nonatomic,copy)NSString * orderId;
@property (nonatomic,copy)NSString * storeId;
@property (nonatomic,strong)NSMutableArray * dishesAry;
@property (nonatomic,assign)float sum;
@end
