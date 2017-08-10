//
//  ViewController.h
//  wdKuaiKe_iOS
//
//  Created by Skyer God on 16/8/3.
//  Copyright © 2016年 weiDianKuaiKe. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController
@property (nonatomic, strong) UIView *navigationView;
/** 左边返回按钮 */
@property (nonatomic, strong) UIButton *leftBarItem;
/** 中间title */
@property (nonatomic, strong) UILabel *titleLabel;
/** 底部分割线 */
@property (nonatomic, strong) UIView *separaLine;

- (void)leftBarItemAction:(UIButton *)sender;
@end

