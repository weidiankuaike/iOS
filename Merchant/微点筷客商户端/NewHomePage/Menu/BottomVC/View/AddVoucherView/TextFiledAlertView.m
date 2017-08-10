//
//  TextFiledAlertView.m
//  微点筷客商户端
//
//  Created by Skyer God on 16/10/24.
//  Copyright © 2016年 张森森. All rights reserved.
//

#import "TextFiledAlertView.h"

@interface TextFiledAlertView ()<UITextFieldDelegate>

@end
@implementation TextFiledAlertView
- (instancetype)initWithFrame:(CGRect)frame withParentView:(UIView *)_maskView
{
    self = [super initWithFrame:frame];
    if (self) {

        [_maskView addSubview:self];
        self.backgroundColor = [UIColor whiteColor];
        self.sd_layout
        .leftEqualToView(_maskView)
        .rightEqualToView(_maskView)
        .bottomEqualToView(_maskView)
        .heightIs(100);

        _cancenlBT = [ButtonStyle buttonWithType:UIButtonTypeCustom];
        [_cancenlBT setTitle:@"取消" forState:UIControlStateNormal];
        [_cancenlBT setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        [_cancenlBT.titleLabel setFont:[UIFont systemFontOfSize:14]];
        [_cancenlBT addTarget:self action:@selector(cancelBTAction:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_cancenlBT];

        _titleLabel = [[UILabel alloc] init];
        _titleLabel.text = @"设置发放条件额度";
        _titleLabel.textColor = RGBA(0, 0, 0, 0.5);
        _titleLabel.font = [UIFont systemFontOfSize:14];
        [self addSubview:_titleLabel];

        _textFiled = [[UITextField alloc] init];
        _textFiled.backgroundColor = [UIColor lightTextColor];
        _textFiled.placeholder = @"30";
        _textFiled.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        _textFiled.textAlignment = NSTextAlignmentCenter;
        _textFiled.delegate = self;
        _textFiled.font = [UIFont systemFontOfSize:14];
        _textFiled.returnKeyType = UIReturnKeyDone;
        _textFiled.keyboardType = UIKeyboardTypeDecimalPad;

        [self addSubview:_textFiled];

        UILabel *placeLabel = [[UILabel alloc] init];
        placeLabel.textColor = [UIColor lightGrayColor];
        placeLabel.text = @"人民币/元";
        placeLabel.font = [UIFont systemFontOfSize:14];
        [_textFiled addSubview:placeLabel];

        _littleTitle = [[UILabel alloc] init];
        _littleTitle.textColor = [UIColor lightGrayColor];
        _littleTitle.text = @"补贴卡最大可代替商户补贴10元";
        _littleTitle.font = [UIFont systemFontOfSize:11];
        [self addSubview:_littleTitle];

        _confirmBT = [ButtonStyle buttonWithType:UIButtonTypeCustom];
        [_confirmBT setTitle:@"确定" forState:UIControlStateNormal];
        [_confirmBT setBackgroundColor:[UIColor lightGrayColor]];
        [_confirmBT addTarget:self action:@selector(confirmBTAction:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_confirmBT];
        CGFloat start_x = 10;
        _cancenlBT.sd_layout
        .leftSpaceToView(self, start_x)
        .topSpaceToView(self, 3)
        .heightIs(45);
        [_cancenlBT setupAutoSizeWithHorizontalPadding:1 buttonHeight:35];

        _titleLabel.sd_layout
        .centerXEqualToView(self)
        .topSpaceToView(self, 3)
        .heightIs(45);
        [_titleLabel setSingleLineAutoResizeWithMaxWidth:220];

        _textFiled.sd_layout
        .leftEqualToView(_cancenlBT)
        .topSpaceToView(_titleLabel, 3)
        .rightSpaceToView(self, start_x)
        .heightIs(50);
        _textFiled.layer.borderWidth = 0.8;
        _textFiled.layer.borderColor = [UIColor lightGrayColor].CGColor;
        [_textFiled setSd_cornerRadiusFromHeightRatio:@(0.23)];

        placeLabel.sd_layout
        .centerYEqualToView(_textFiled)
        .rightSpaceToView(_textFiled, 2)
        .heightIs(20);
        [placeLabel setSingleLineAutoResizeWithMaxWidth:100];

        _littleTitle.sd_layout
        .leftEqualToView(_cancenlBT)
        .topSpaceToView(_textFiled, 2)
        .heightIs(30);
        [_littleTitle setSingleLineAutoResizeWithMaxWidth:340];
        
        _confirmBT.sd_layout
        .leftEqualToView(_cancenlBT)
        .topSpaceToView(_littleTitle, 2)
        .rightEqualToView(_textFiled)
        .heightIs(45);
        
        [_confirmBT setSd_cornerRadiusFromHeightRatio:@(0.23)];
        
        [self setupAutoHeightWithBottomView:_confirmBT bottomMargin:8];
        _conditionView = _maskView;
    }
    return self;
}
- (void)showInView:(UIView *)view {

    [UIView animateWithDuration:0.7f animations:^{
        self.frame = CGRectMake(0, view.frame.size.height-200, view.frame.size.width, 800);
        // self.backgroundColor = [UIColor redColor];
    } completion:^(BOOL finished) {
        //self.frame = CGRectMake(0, view.frame.size.height-200, view.frame.size.width, 200);
    }];
}
- (void)textFieldDidEndEditing:(UITextField *)textField{
    _text(_textFiled.text);
}
-(void)returnTextFieldValue:(returnTextFiledValue)text{
    _text = text;
}
- (void)textFieldCancelBTAction{

    [self removeFromSuperview];
}
- (void)confirmBTAction:(ButtonStyle *)sender{
    [_conditionView removeFromSuperview];
}
- (void)cancelBTAction:(ButtonStyle *)sender{
    [_conditionView removeFromSuperview];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
