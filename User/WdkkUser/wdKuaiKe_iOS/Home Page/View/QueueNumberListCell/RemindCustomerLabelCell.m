//
//  RemindCustomerLabelCell.m
//  wdKuaiKe_iOS
//
//  Created by Skyer God on 16/9/9.
//  Copyright © 2016年 weiDianKuaiKe. All rights reserved.
//

#import "RemindCustomerLabelCell.h"

@interface RemindCustomerLabelCell ()
{
    UILabel *_pointLabel;
    UILabel *_detailLabel;
}

@end
@implementation RemindCustomerLabelCell

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

    _pointLabel = [[UILabel alloc] init];
    _pointLabel.backgroundColor = [UIColor blackColor];
    [self.contentView addSubview:_pointLabel];

    _detailLabel = [[UILabel alloc] init];
    _detailLabel.textColor = [UIColor grayColor];
    [self.contentView addSubview:_detailLabel];
    _detailLabel.text = @"过好不作废，在现场排号的基础上延顺3桌安排";
    _detailLabel.font = [UIFont systemFontOfSize:autoScaleW(12)];



}
-(void)layoutSubviews{
    [super layoutSubviews];
    CGFloat star_x = autoScaleW(24);
    CGFloat width = autoScaleW(10);
    CGFloat height = width;
    _pointLabel.sd_layout.centerYIs(self.contentView.centerY).leftSpaceToView(self.contentView, star_x).widthIs(width).heightIs(height);

    _pointLabel.layer.cornerRadius = width / 2;
    _pointLabel.layer.masksToBounds = YES;

    _detailLabel.sd_layout.leftSpaceToView(self.contentView, star_x + width + autoScaleW(5)).centerYIs(self.contentView.centerY).widthIs(self.contentView.size.width - (star_x + width + autoScaleW(5))).heightIs(self.contentView.size.height - width / 2);
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
