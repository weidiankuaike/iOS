//
//  TextFieldViewController.h
//  微点筷客商户端
//
//  Created by Skyer God on 16/11/29.
//  Copyright © 2016年 张森森. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseNaviSetVC.h"
@interface TextFieldViewController : BaseNaviSetVC
/** pushing的viewController   (strong) **/
@property (nonatomic, strong) UIViewController *pushingViewController;
/** 标题   (strong) **/
@property (nonatomic, strong) UILabel *titleLabel;
/** 符号   (strong) **/
@property (nonatomic, strong) UILabel *pointLabel;
/** textField   (strong) **/
@property (nonatomic, strong) UITextField *textFeild;
/** 返回回调  (NSString) **/
@property (nonatomic, copy) void(^textDidFinish)(NSString *text);
@end
