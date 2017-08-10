//
//  TextFiledAlertView.h
//  微点筷客商户端
//
//  Created by Skyer God on 16/10/24.
//  Copyright © 2016年 张森森. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^returnTextFiledValue)(NSString *text);
@interface TextFiledAlertView : UIView
/** 发放条件弹窗   (strong) **/
@property (nonatomic, strong) UIView *conditionView;
/** 设置消费额度   (strong) **/
@property (nonatomic, strong) UITextField *textFiled;
/** 输入框下，提示文字   (strong) **/
@property (nonatomic, strong) UILabel *littleTitle;
- (instancetype)initWithFrame:(CGRect)frame withParentView:(UIView *)_maskView;
/** 设置弹窗标题   (strong) **/
@property (nonatomic, strong) UILabel *titleLabel;
/**  返回  (strong) **/
@property (nonatomic, strong) ButtonStyle *cancenlBT;
/** 确定按钮   (strong) **/
@property (nonatomic, strong) ButtonStyle *confirmBT;
@property (nonatomic, copy) returnTextFiledValue text;
- (void)returnTextFieldValue:(returnTextFiledValue)text;
- (void)showInView:(UIView *)view;
@end
