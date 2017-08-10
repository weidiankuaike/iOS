//
//  SunmitViewController.h
//  wdKuaiKe_iOS
//
//  Created by 张森森 on 17/1/16.
//  Copyright © 2017年 weiDianKuaiKe. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SunmitViewController : UIViewController
@property (nonatomic,copy)NSString * peoplestr,* timestr,*feestr;
@property (nonatomic,strong)NSMutableArray * dictary;
@property (nonatomic,copy)NSString * storeid;
@property (nonatomic,copy)NSString * updatetime;
@property (nonatomic,assign)NSInteger number;//总个数
@property (nonatomic,assign)NSInteger orderCount;//判断第一次点菜还是加菜
@property (nonatomic,copy)NSString * bookady;
@end
