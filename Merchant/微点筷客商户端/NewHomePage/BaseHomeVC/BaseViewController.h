//
//  BaseViewController.h
//  微点筷客商户端
//
//  Created by Skyer God on 16/10/17.
//  Copyright © 2016年 张森森. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BaseViewController : UIViewController
/** 左边菜单   (strong) **/
@property (nonatomic, strong) ButtonStyle *leftButton;
/** 标题    (strong) **/
@property (nonatomic, strong) UILabel *titleView;
/** 展开收合状态  (NSString) **/
@property (nonatomic, assign) BOOL isOut;
//子类重写此方法，可以获取菜单展开状态
- (void)judgeBaseViewControllerStatus:(BOOL)isOut;
@end
