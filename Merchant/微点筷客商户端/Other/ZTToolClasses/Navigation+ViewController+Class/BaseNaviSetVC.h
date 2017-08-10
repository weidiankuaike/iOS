//
//  BaseNaviSetVC.h
//  微点筷客商户端
//
//  Created by Skyer God on 16/10/21.
//  Copyright © 2016年 张森森. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ButtonStyle.h"
@interface BaseNaviSetVC : UIViewController
@property (nonatomic, strong) ButtonStyle *leftBarItem;
/** 右边导航   (strong) **/
@property (nonatomic, strong) ButtonStyle *rightBarItem;
/** 标题   (strong) **/
@property (nonatomic, strong) UILabel * titleView;
        /** 左边导航action **/
- (void)leftBarButtonItemAction;
//右边按钮方法
- (void)rightBarButtonItemAction:(ButtonStyle *)sender;
@end
