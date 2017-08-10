//
//  DishesInfoCell.m
//  wdKuaiKe_iOS
//
//  Created by Skyer God on 16/9/19.
//  Copyright © 2016年 weiDianKuaiKe. All rights reserved.
//

#import "DishesInfoCell.h"
#import "DishesInfoModel.h"
@implementation DishesInfoCell{
    UIView *bottomSeparatorLine;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self create];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}
- (void)create{
//    _bgView = [[UIView alloc] init];
//    _bgView.backgroundColor = [UIColor whiteColor];
//    [self.contentView addSubview:_bgView];

    UIView *contentView = self.contentView;

    self.imageV = [[UIImageView alloc] init];
    [self.imageV setImage:[UIImage imageNamed:@""]];
    [contentView addSubview:_imageV];

    self.titleLabel = [[UILabel alloc] init];
    self.titleLabel.text = @"招牌手撕鸡";
    self.titleLabel.font = [UIFont systemFontOfSize:15];
    [contentView addSubview:_titleLabel];

    self.saleMth = [[UILabel alloc] init];
    self.saleMth.text = @"月售：104";
    self.saleMth.font = [UIFont systemFontOfSize:11];
    self.saleMth.textColor = [UIColor grayColor];
    [contentView addSubview:_saleMth];

    self.discountPrice = [[UILabel alloc] init];
    self.discountPrice.text = @"¥20.5";
    self.discountPrice.textColor = RGB(236, 125, 123);
    self.discountPrice.font = [UIFont systemFontOfSize:17];
    [contentView addSubview:_discountPrice];

    self.originalPrice = [[UILabel alloc] init];
    self.originalPrice.text = @"¥30.6";
    self.originalPrice.textColor = [UIColor grayColor];
    self.originalPrice.font = [UIFont systemFontOfSize:14];
    [contentView addSubview:_originalPrice];

    self.shoppingCart = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.shoppingCart setTitle:@"+ 加入购物车" forState:UIControlStateNormal];
    [self.shoppingCart setBackgroundColor:RGB(236, 125, 123)];
    [self.shoppingCart.titleLabel setFont:[UIFont systemFontOfSize:15]];
    [contentView addSubview:_shoppingCart];

    bottomSeparatorLine = [[UIView alloc] init];
    bottomSeparatorLine.backgroundColor = UIColorFromRGB(0xeeeeee);
    [self.contentView addSubview:bottomSeparatorLine];


    CGFloat start_X = 15;
    CGFloat height = [[UIScreen mainScreen] bounds].size.height / 3.7;
    _imageV.sd_layout.leftEqualToView(contentView)
    .topEqualToView(contentView)
    .rightEqualToView(contentView)
    .heightIs(height);

    _titleLabel.sd_layout
    .leftSpaceToView(contentView, start_X)
    .topSpaceToView(_imageV, 10)
    .heightIs(30);
    [_titleLabel setSingleLineAutoResizeWithMaxWidth:180];

    _saleMth.sd_layout
    .leftSpaceToView(contentView, start_X)
    .topSpaceToView(_titleLabel, -3)
    .heightIs(20);
    [_saleMth setSingleLineAutoResizeWithMaxWidth:180];

    _discountPrice.sd_layout
    .leftEqualToView(_saleMth)
    .topSpaceToView(_saleMth, 4)
    .heightIs(30);
    [_discountPrice setSingleLineAutoResizeWithMaxWidth:180];

    _originalPrice.sd_layout
    .leftSpaceToView(_discountPrice, 2)
    .bottomEqualToView(_discountPrice)
    .heightIs(28);
    [_originalPrice setSingleLineAutoResizeWithMaxWidth:180];

    _shoppingCart.sd_layout
    .rightSpaceToView(contentView, 10)
    .bottomSpaceToView(contentView, 50);
    [_shoppingCart setupAutoSizeWithHorizontalPadding:10 buttonHeight:30];

    bottomSeparatorLine.sd_layout
    .leftEqualToView(contentView)
    .rightEqualToView(contentView)
    .topSpaceToView(_discountPrice, 35)
    .heightIs(1);




    [self setupAutoHeightWithBottomViewsArray:@[bottomSeparatorLine, _originalPrice] bottomMargin:1];



}
- (void)setModel:(DishesInfoModel *)model{
    _model = model;
//
//    _imageV.image = [UIImage imageNamed:model.imgUrl];
//    _titleLabel.text = model.dishesName;
//    _saleMth.text = [NSString stringWithFormat:@"月售：%@", model.saleMoth];
//    _discountPrice.text = [NSString stringWithFormat:@"¥%@", model.discountPrice];
//
//    _originalPrice.text = [NSString stringWithFormat:@"¥%@", model.originalPrice];
//
    NSMutableAttributedString *arrStr = [[NSMutableAttributedString alloc] initWithString:self.originalPrice.text];
    NSRange range = [self.originalPrice.text rangeOfString:self.originalPrice.text];
    [arrStr addAttribute:NSStrikethroughStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:range];
    [arrStr addAttribute:NSStrikethroughColorAttributeName
                    value:[UIColor redColor]
                    range:range];
    _originalPrice.attributedText = arrStr;

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
