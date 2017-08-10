//
//  MyTableBar.h
//  wdKuaiKe_iOS
//
//  Created by Skyer God on 16/8/22.
//  Copyright © 2016年 weiDianKuaiKe. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MyTableBar;
@protocol MytabBarDelegate <UITabBarDelegate>
@optional
- (void)tabbarDidCkickButton:(MyTableBar*)tabar;

@end
@interface MyTableBar : UITabBar
@property (nonatomic,weak)id<MytabBarDelegate>myDelegate;
@property (nonatomic, strong) UIButton *midBarButtonItem;
@end
