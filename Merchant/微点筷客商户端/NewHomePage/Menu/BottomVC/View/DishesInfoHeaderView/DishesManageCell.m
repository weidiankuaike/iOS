//
//  DishesManageCell.m
//  微点筷客商户端
//
//  Created by Skyer God on 16/10/19.
//  Copyright © 2016年 张森森. All rights reserved.
//

#import "DishesManageCell.h"
#import "DishesInfoModel.h"
#import "ZTAddOrSubAlertView.h"
@implementation DishesManageCell
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self create];
    }
    return self;
}
- (void)create{
    _imageV = [[UIImageView alloc] init];
    [self.contentView addSubview:_imageV];

    UIView *maskView = [[UIView alloc] init];
    maskView.backgroundColor = RGBA(0, 0, 0, 0.3);
    [_imageV addSubview:maskView];

    _downStairLabel = [[UILabel alloc] init];
    _downStairLabel.text = @"点击下架";
    _downStairLabel.textColor = [UIColor whiteColor];
    _downStairLabel.font = [UIFont systemFontOfSize:autoScaleW(17)];
    [maskView addSubview:_downStairLabel];

    _dishesNameLabel = [[UILabel alloc] init];
    _dishesNameLabel.font = [UIFont systemFontOfSize:15];
    _dishesNameLabel.text = @"麻辣烫";
    _dishesNameLabel.textColor = RGBA(0, 0, 0, 0.7);
    _dishesNameLabel.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:_dishesNameLabel];

    _dishesPriceLabel = [[UILabel alloc] init];
    _dishesPriceLabel.text = @"￥50";
    _dishesPriceLabel.font = [UIFont systemFontOfSize:15 weight:15];
    [maskView addSubview:_dishesPriceLabel];


    _deleteBT = [ButtonStyle buttonWithType:UIButtonTypeCustom];
    [_deleteBT setImage:nil forState:UIControlStateNormal];
    [_deleteBT setImage:[UIImage imageNamed:@"小红点"] forState:UIControlStateSelected];
    [_deleteBT addTarget:self action:@selector(showSingleDeleteView:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:_deleteBT];

    _deleteBT.userInteractionEnabled = YES;
    _deleteBT.hidden = YES;
    _downStairLabel.hidden = YES;



    _deleteBT.sd_layout
    .topSpaceToView(self.contentView,0)
    .rightSpaceToView(self.contentView, 0)
    .widthIs(15)
    .heightIs(15);

    [_deleteBT setSd_cornerRadiusFromHeightRatio:@(0.5)];

    _imageV.sd_layout
    .leftSpaceToView(self.contentView, 5)
    .topSpaceToView(self.contentView, 5)
    .rightSpaceToView(self.contentView , 5)
    .bottomSpaceToView(self.contentView, 35);

    maskView.sd_layout
    .leftEqualToView(_imageV)
    .topEqualToView(_imageV)
    .rightEqualToView(_imageV)
    .bottomEqualToView(_imageV);

    _downStairLabel.sd_layout
    .centerXEqualToView(maskView)
    .centerYEqualToView(maskView)
    .heightIs(20);
    [_downStairLabel setSingleLineAutoResizeWithMaxWidth:120];

    _dishesNameLabel.sd_layout
    .leftEqualToView(self.contentView)
    .topSpaceToView(_imageV, 0)
    .bottomSpaceToView(self.contentView, 0)
    .rightEqualToView(self.contentView);

    _dishesPriceLabel.sd_layout
    .rightEqualToView(maskView)
    .bottomEqualToView(maskView)
    .heightIs(20);
    [_dishesPriceLabel setSingleLineAutoResizeWithMaxWidth:100];
    _dishesPriceLabel.textColor = [UIColor whiteColor];


}
- (void)setModel:(DishesInfoModel *)model{

    _dishesNameLabel.text = model.dishesName;
    _dishesPriceLabel.text = [NSString stringWithFormat:@"%@元 ", model.price];
    NSString *url = [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:model.img]] ? model.img : [model.img stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [_imageV sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:[UIImage imageNamed:@"loadingIcon"] options:SDWebImageRetryFailed completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
    }];

    self.descrpt = model.descrpt;

}
- (void)showSingleDeleteView:(ButtonStyle *)sender{
    ZTAddOrSubAlertView *alertV = [[ZTAddOrSubAlertView alloc] initWithStyle:ZTalertSheetStyleTitle];
    alertV.titleLabel.text = @"确定删除这道菜?";
    [alertV.confirmBT setTitle:@"删除" forState:UIControlStateNormal];
    [alertV showView];

    alertV.complete = ^(BOOL isSure){
        if (_deleteClick && isSure) {
            _deleteClick(_indexP);
        }
    };
}
- (UIViewController *)viewController {
    for (UIView* next = [self superview]; next; next = next.superview) {
        UIResponder *nextResponder = [next nextResponder];
        if ([nextResponder isKindOfClass:[UIViewController class]]) {
            return (UIViewController *)nextResponder;
        }
    }
    return nil;
}
-(void)UpdateCellWithState:(BOOL)select{
    self.deleteBT.selected = select;
    _isSelected = select;
}


@end
