//
//  DishesCollectionReusableView.m
//  微点筷客商户端
//
//  Created by Skyer God on 16/10/19.
//  Copyright © 2016年 张森森. All rights reserved.
//

#import "DishesCollectionReusableView.h"
#import "ZTAddOrSubAlertView.h"
@implementation DishesCollectionReusableView
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {

        UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(20, 10, [UIScreen mainScreen].bounds.size.width - 20 * 2, self.frame.size.height)];
        backView.backgroundColor =RGBA(238, 238, 238, 0.4);
        [self addSubview:backView];
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.backgroundColor = RGBA(238, 238, 238, 0.4);
        _titleLabel.font = [UIFont systemFontOfSize:15];
        _titleLabel.textColor = RGBA(0, 0, 0, 0.7);
        [backView addSubview:_titleLabel];
        _titleLabel.sd_layout
        .leftSpaceToView(backView, 0.8)
        .topSpaceToView(backView, 0.8)
        .bottomSpaceToView(backView, 0.8)
        .rightSpaceToView(backView, 0.8);

        backView.layer.borderColor = RGBA(0, 0, 0, 0.2).CGColor;
        backView.layer.borderWidth = 0.21;

        _selectAllBT = [ButtonStyle buttonWithType:UIButtonTypeCustom];
        [_selectAllBT setImage:[UIImage imageNamed:@"小红点"] forState:UIControlStateNormal];
        [backView addSubview:_selectAllBT];
        [_selectAllBT addTarget:self action:@selector(selectAllBTAction:) forControlEvents:UIControlEventTouchUpInside];

        _selectAllBT.hidden = YES;

        _selectAllBT.sd_layout
        .centerYEqualToView(backView)
        .rightSpaceToView(backView, 5)
        .widthIs(15)
        .heightIs(15);



        [_selectAllBT setSd_cornerRadiusFromHeightRatio:@(0.5)];

    }
    return self;
}

- (void)selectAllBTAction:(ButtonStyle *)sender{
    ZTAddOrSubAlertView *alertV = [[ZTAddOrSubAlertView alloc] initWithStyle:ZTalertSheetStyleSubTitle];
    alertV.titleLabel.text = @"确定删除?";
    alertV.littleLabel.text = @"确定删除这个分类？删除后此分类的所有菜品也将被删除。";
    [alertV.confirmBT setTitle:@"删除" forState:UIControlStateNormal];
    [alertV showView];

    alertV.complete = ^(BOOL isSure){
        if (_deleteClick && isSure) {
            _deleteClick(_indexP);
        }
    };
}
@end
