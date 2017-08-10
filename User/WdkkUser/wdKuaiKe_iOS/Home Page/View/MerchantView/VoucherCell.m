//
//  VoucherCell.m
//  wdKuaiKe_iOS
//
//  Created by Skyer God on 16/9/23.
//  Copyright © 2016年 weiDianKuaiKe. All rights reserved.
//

#import "VoucherCell.h"

@implementation VoucherCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self create];
    }
    return self;
}
- (void)create{

    self.backImageV = [[UIImageView alloc] init];
    self.backImageV.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:_backImageV];
    self.backImageV.image = [UIImage imageNamed:@"即将过期"];


    self.discountLabel = [[UILabel alloc] init];
    [_backImageV addSubview:_discountLabel];
    _discountLabel.text = @"￥5.6";
    _discountLabel.textColor = [UIColor whiteColor];
    _discountLabel.font = [UIFont systemFontOfSize:autoScaleW(20) weight:autoScaleW(10)];
    _discountLabel.textAlignment = NSTextAlignmentCenter;

    self.voucherLabel = [[UILabel alloc] init];
    [_backImageV addSubview:_voucherLabel];
    _voucherLabel.text = @"优惠券";
    _voucherLabel.textColor = [UIColor whiteColor];
    _voucherLabel.font = [UIFont systemFontOfSize:autoScaleW(15) weight:autoScaleW(10)];
    _voucherLabel.textAlignment = NSTextAlignmentCenter;


    self.titleLabel = [[UILabel alloc] init];
    [_backImageV addSubview:_titleLabel];
    self.titleLabel.textAlignment = self.discountLabel.textAlignment;
    self.titleLabel.textColor = [UIColor blackColor];
    self.titleLabel.font = [UIFont systemFontOfSize:autoScaleW(18) weight:autoScaleW(5)];
    self.titleLabel.text = @"餐厅通用";

    self.detailLabel = [[UILabel alloc] init];
    self.detailLabel.textColor = [UIColor grayColor];
    self.detailLabel.font = [UIFont systemFontOfSize:autoScaleW(11)];
    self.detailLabel.text = @"满43元可用。 仅限15080018698使用";
    [_backImageV addSubview:_detailLabel];

    self.limitDataLabel = [[UILabel alloc] init];
    self.limitDataLabel.textColor = self.detailLabel.textColor;
    self.limitDataLabel.font = self.detailLabel.font;
    self.limitDataLabel.text = @"2016/09/15 - 2016/09/22";
    [_backImageV addSubview:_limitDataLabel];

    _backImageV.sd_layout
    .leftSpaceToView(self.contentView, autoScaleW(15))
    .topSpaceToView(self.contentView, autoScaleH(8))
    .rightSpaceToView(self.contentView, autoScaleW(15))
    .bottomSpaceToView(self.contentView, autoScaleH(8));


    CGFloat maxWidth = self.contentView.size.width * 168 / 613.0;
    _discountLabel.sd_layout
    .leftSpaceToView(_backImageV, 0)
    .topSpaceToView(_backImageV, autoScaleH(30))
    .heightIs(autoScaleH(30))
    .widthIs(maxWidth);



    _voucherLabel.sd_layout
    .leftEqualToView(_discountLabel)
    .topSpaceToView(_discountLabel, 1)
    .rightEqualToView(_discountLabel)
    .heightIs(autoScaleH(20));


    _titleLabel.sd_layout
    .leftSpaceToView(_backImageV, maxWidth + autoScaleW(25))
    .topSpaceToView(_backImageV, autoScaleH(20))
    .heightIs(autoScaleH(30));
    [self.titleLabel setSingleLineAutoResizeWithMaxWidth:180];

    _detailLabel.sd_layout
    .leftEqualToView(_titleLabel)
    .topSpaceToView(_titleLabel, 1)
    .heightIs(autoScaleH(20))
    .rightSpaceToView(_backImageV, autoScaleW(20));

    _limitDataLabel.sd_layout
    .leftEqualToView(_detailLabel)
    .topSpaceToView(_detailLabel, 1)
    .rightSpaceToView(_backImageV, autoScaleW(20))
    .heightIs(autoScaleH(20));






}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
