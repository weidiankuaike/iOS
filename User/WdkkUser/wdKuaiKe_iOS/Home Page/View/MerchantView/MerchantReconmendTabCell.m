//
//  MerchantReconmendTabCell.m
//  wdKuaiKe_iOS
//
//  Created by Skyer God on 16/9/8.
//  Copyright © 2016年 weiDianKuaiKe. All rights reserved.
//

#import "MerchantReconmendTabCell.h"

#import "UIImageView+WebCache.h"
@implementation MerchantReconmendTabCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier;
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self create];
    }
    return self;
}
- (void)create{

    _titleLabel = [[UILabel alloc] init];
    _titleLabel.text = @"推荐菜品";
    _titleLabel.font = [UIFont systemFontOfSize:autoScaleW(14)];
    _titleLabel.textColor = [UIColor colorWithRed:0.2 green:0.2 blue:0.2 alpha:1.0];
    [self.contentView addSubview:_titleLabel];

    NSArray *imageArr = @[@"1",@"2",@"3",@"4"];
    for (NSInteger i = 0; i < imageArr.count; i++) {
        UIImageView *imageView = [[UIImageView alloc] init];

        imageView.userInteractionEnabled = YES;

        imageView.backgroundColor = [UIColor colorWithRed: arc4random() % 255 / 255.0 green: arc4random() % 255 / 255.0 blue: arc4random() % 255 / 255.0 alpha:1];
//        [imageView sd_setImageWithURL:nil placeholderImage:[UIImage imageNamed:imageArr[i]]];
        [self.contentView addSubview:imageView];
        imageView.image = [UIImage imageNamed:imageArr[i]];

        imageView.tag = 3500 + i;
    }

    UIView *bottomSeparator = [[UIView alloc] init];
    bottomSeparator.backgroundColor = RGB(238, 238, 238);
    [self.contentView addSubview:bottomSeparator];


    CGFloat star_x = autoScaleW(15);

    self.titleLabel.sd_layout
    .leftSpaceToView(self.contentView, star_x)
    .topEqualToView(self.contentView)
    .rightEqualToView(self.contentView)
    .heightIs(autoScaleH(30));
    for (NSInteger i = 0; i < 4; i++) {
        UIImageView *imageView = [self.contentView viewWithTag:3500 + i];
        CGFloat col_Space = autoScaleW(5);
        CGFloat width = ([UIScreen mainScreen].bounds.size.width - col_Space * 3 - star_x * 2) / 4;

        imageView.sd_layout
        .leftSpaceToView(self.contentView, star_x + (width +col_Space) * i)
        .topSpaceToView(_titleLabel, 1)
        .widthIs(width)
        .heightIs(autoScaleH(65));
    }

    bottomSeparator.sd_layout
    .leftEqualToView(self.contentView)
    .topSpaceToView([self.contentView  viewWithTag:3500], 5)
    .rightEqualToView(self.contentView)
    .heightIs(autoScaleH(5));


    [self setupAutoHeightWithBottomViewsArray:@[bottomSeparator, [self.contentView viewWithTag:3500]] bottomMargin:0];
}

-(void)layoutSubviews{
    [super layoutSubviews];

}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
