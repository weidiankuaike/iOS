//
//  DishesIntroductionInfoCell.m
//  wdKuaiKe_iOS
//
//  Created by Skyer God on 16/9/19.
//  Copyright © 2016年 weiDianKuaiKe. All rights reserved.
//

#import "DishesIntroductionInfoCell.h"

#import "DishesInfoModel.h"

@implementation DishesIntroductionInfoCell
{
    UIView *_circlePoint;
    UILabel *_titleLabel;

    UILabel *bottomSeparator;
    
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self create];
    }
    return self;
}
- (void)create{

    _circlePoint = [[UIView alloc] init];
    _circlePoint.backgroundColor = RGB(236, 125, 123);
    [self.contentView addSubview:_circlePoint];

    _titleLabel = [[UILabel alloc] init];
    _titleLabel.text = @"商品详情";
    _titleLabel.font = [UIFont systemFontOfSize:15];
    [self.contentView addSubview:_titleLabel];
    _titleLabel.textColor = [UIColor grayColor];

    self.dishesDetail = [[UILabel alloc] init];
    self.dishesDetail.textColor = RGB(132,132,132);
    self.dishesDetail.font = [UIFont systemFontOfSize:10];
    self.dishesDetail.numberOfLines = 0;
    [self.contentView addSubview:_dishesDetail];

    bottomSeparator = [[UILabel alloc] init];
    bottomSeparator.backgroundColor = UIColorFromRGB(0xeeeeee);
    [self.contentView addSubview:bottomSeparator];


    _circlePoint.sd_layout
    .leftSpaceToView(self.contentView, 5)
    .topSpaceToView(self.contentView, 20)
    .widthIs(5)
    .heightEqualToWidth();
    _circlePoint.sd_cornerRadiusFromWidthRatio = @(0.5);

    _titleLabel.sd_layout
    .leftSpaceToView(_circlePoint, 5)
    .topSpaceToView(self.contentView, 7.5)
    .heightIs(30);
    [_titleLabel setSingleLineAutoResizeWithMaxWidth:100];

    _dishesDetail.sd_layout
    .leftEqualToView(_titleLabel)
    .topSpaceToView(_titleLabel, 20)
    .rightSpaceToView(self.contentView, 15)
    .autoHeightRatio(0);

    bottomSeparator.sd_layout
    .leftEqualToView(self.contentView)
    .topSpaceToView(_dishesDetail, 20)
    .rightEqualToView(self.contentView)
    .heightIs(1.0);

    [self setupAutoHeightWithBottomView:bottomSeparator bottomMargin:0];


}

- (void)setModel:(DishesInfoModel *)model{
    _model = model;
    self.dishesDetail.text = model.productCategory;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
