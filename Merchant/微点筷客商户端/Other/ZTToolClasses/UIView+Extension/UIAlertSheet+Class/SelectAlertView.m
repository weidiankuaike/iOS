//
//  SelectAlertView.m
//  微点筷客商户端
//
//  Created by Skyer God on 16/10/27.
//  Copyright © 2016年 张森森. All rights reserved.
//

#import "SelectAlertView.h"

@implementation SelectAlertView

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

    maskView = [[UIView alloc] initWithFrame:_parentView.frame];
    
    maskView.backgroundColor = RGBA(0, 0, 0, 0.3);
    [[UIApplication sharedApplication].keyWindow addSubview:maskView];

    self.backgroundColor = [UIColor whiteColor];
    [maskView addSubview:self];



    _titleLabel = [[UILabel alloc] init];
    _titleLabel.text = @"确定删除这个品类？";
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    _titleLabel.font = [UIFont systemFontOfSize:14];
    [self addSubview:_titleLabel];;

    _littleLabel = [[UILabel alloc] init];
    _littleLabel.text = @"同时会删除该品类的所有菜品";
    _littleLabel.textAlignment = NSTextAlignmentCenter;
    _littleLabel.font = [UIFont systemFontOfSize:13];
    _littleLabel.textColor = [UIColor redColor];
    [self addSubview:_littleLabel];

    UILabel *separatorLine = [[UILabel alloc]init];
    separatorLine.backgroundColor = [UIColor lightGrayColor];
    [self addSubview:separatorLine];

    UILabel *midSeparator = [[UILabel alloc] init];
    midSeparator.backgroundColor = [UIColor lightGrayColor];
    [self addSubview:midSeparator];

    _cancelBT = [ButtonStyle buttonWithType:UIButtonTypeCustom];
    [_cancelBT setTitle:@"取消" forState:UIControlStateNormal];
    [_cancelBT setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [_cancelBT addTarget:self action:@selector(cancelAction) forControlEvents:UIControlEventTouchUpInside];
    [_cancelBT.titleLabel setFont:[UIFont systemFontOfSize:14]];
    [self addSubview:_cancelBT];

    _confirmBT = [ButtonStyle buttonWithType:UIButtonTypeCustom];
    [_confirmBT setTitle:@"确定" forState:UIControlStateNormal];
    [_confirmBT setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_confirmBT addTarget:self action:@selector(confirmAction) forControlEvents:UIControlEventTouchUpInside];
    [_confirmBT.titleLabel setFont:[UIFont systemFontOfSize:14]];
    [self addSubview:_confirmBT];


    self.sd_layout
    .centerXEqualToView(maskView)
    .centerYEqualToView(maskView)
    .widthRatioToView(maskView, 0.61);

    _titleLabel.sd_layout
    .leftEqualToView(self)
    .rightEqualToView(self)
    .topSpaceToView(self, 7)
    .heightIs(40);

    _littleLabel.sd_layout
    .leftEqualToView(_titleLabel)
    .topSpaceToView(_titleLabel, 0)
    .rightEqualToView(_titleLabel)
    .heightIs(30);

    separatorLine.sd_layout
    .leftEqualToView(self)
    .rightEqualToView(self)
    .topSpaceToView(_littleLabel, 5)
    .heightIs(0.8);

    midSeparator.sd_layout
    .centerXEqualToView(self)
    .topSpaceToView(separatorLine, 0)
    .widthIs(0.8)
    .heightIs(40);

    _cancelBT.sd_layout
    .leftEqualToView(self)
    .topEqualToView(midSeparator)
    .rightSpaceToView(midSeparator, 0)
    .bottomEqualToView(midSeparator);

    _confirmBT.sd_layout
    .leftSpaceToView(midSeparator, 0)
    .topEqualToView(_cancelBT)
    .rightEqualToView(self)
    .bottomEqualToView(_cancelBT);

    [self setupAutoHeightWithBottomViewsArray:@[_cancelBT, midSeparator] bottomMargin:0];


}
- (void)showView{
    [UIView animateWithDuration:.35 animations:^{
        maskView.alpha = 1;
        maskView.hidden = NO;
    }];

}
- (void)cancelAction{
    [self dismiss];
    self.complete(NO);
}
- (void)dismiss{
    [maskView removeFromSuperview];
    [UIView animateWithDuration:.35 animations:^{
        maskView.alpha = 0;
        maskView.hidden = YES;
    }];
}
- (void)confirmAction{
    [self dismiss];
    self.complete(YES);

}
@end
