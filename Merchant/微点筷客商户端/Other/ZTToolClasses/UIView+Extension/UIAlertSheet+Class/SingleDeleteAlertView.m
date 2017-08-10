//
//  SingleDeleteAlertView.m
//  微点筷客商户端
//
//  Created by Skyer God on 16/10/27.
//  Copyright © 2016年 张森森. All rights reserved.
//

#import "SingleDeleteAlertView.h"

@implementation SingleDeleteAlertView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
{
    UIView *_parentView;
    UIView *maskView;
}
- (instancetype)initWithParentView:(UIView *)parentView
{
    self = [super init];
    if (self) {
        _parentView = parentView;
        [self create];

    }
    return self;
}

- (void)create{
    maskView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    [[UIApplication sharedApplication].keyWindow addSubview:maskView];
    maskView.backgroundColor = RGBA(0, 0, 0, 0.3);

    self.backgroundColor = [UIColor whiteColor];
    [maskView addSubview:self];

    _titleLabel = [[UILabel alloc] init];
    _titleLabel.text = @"确定删除这道菜？";
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    _titleLabel.font = [UIFont systemFontOfSize:14];
    [self addSubview:_titleLabel];;


    UILabel *separatorLine = [[UILabel alloc]init];
    separatorLine.backgroundColor = [UIColor lightGrayColor];
    [self addSubview:separatorLine];

    UILabel *midSeparator = [[UILabel alloc] init];
    midSeparator.backgroundColor = [UIColor lightGrayColor];
    [self addSubview:midSeparator];

    ButtonStyle *cancelBT = [ButtonStyle buttonWithType:UIButtonTypeCustom];
    [cancelBT setTitle:@"取消" forState:UIControlStateNormal];
    [cancelBT setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [cancelBT.titleLabel setFont:[UIFont systemFontOfSize:14]];
    [cancelBT addTarget:self action:@selector(cancelAction) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:cancelBT];

    ButtonStyle *confirmBT = [ButtonStyle buttonWithType:UIButtonTypeCustom];
    [confirmBT setTitle:@"确定" forState:UIControlStateNormal];
    [confirmBT setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [confirmBT addTarget:self action:@selector(confirmAction) forControlEvents:UIControlEventTouchUpInside];
    [confirmBT.titleLabel setFont:[UIFont systemFontOfSize:14]];
    [self addSubview:confirmBT];

    self.sd_layout
    .centerXEqualToView(maskView)
    .centerYEqualToView(maskView)
    .widthRatioToView(maskView, 0.61);

    _titleLabel.sd_layout
    .leftEqualToView(self)
    .rightEqualToView(self)
    .topSpaceToView(self, 7)
    .heightIs(40);



    separatorLine.sd_layout
    .leftEqualToView(self)
    .rightEqualToView(self)
    .topSpaceToView(_titleLabel, 0)
    .heightIs(0.8);

    midSeparator.sd_layout
    .centerXEqualToView(self)
    .topSpaceToView(separatorLine, 0)
    .widthIs(0.8)
    .heightIs(40);

    cancelBT.sd_layout
    .leftEqualToView(self)
    .topEqualToView(midSeparator)
    .rightSpaceToView(midSeparator, 0)
    .bottomEqualToView(midSeparator);

    confirmBT.sd_layout
    .leftSpaceToView(midSeparator, 0)
    .topEqualToView(cancelBT)
    .rightEqualToView(self)
    .bottomEqualToView(cancelBT);

    [self setupAutoHeightWithBottomView:midSeparator bottomMargin:0];
    
    
    
    
}

- (void)showView{
    [UIView animateWithDuration:.35 animations:^{
        maskView.alpha = 1;
        maskView.hidden = NO;
    }];
}
- (void)dismiss{

    [maskView removeFromSuperview];
    [UIView animateWithDuration:.35 animations:^{
        maskView.alpha = 0;
        maskView.hidden = YES;
    }];
}
- (void)cancelAction{
    [self dismiss];
    self.complete(NO);
}
- (void)confirmAction{
    [self dismiss];
    self.complete(YES);
}
@end
