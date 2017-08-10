//
//  PhoneTableViewCell.m
//  wdKuaiKe_iOS
//
//  Created by Skyer God on 16/8/8.
//  Copyright © 2016年 weiDianKuaiKe. All rights reserved.
//

#import "PhoneTableViewCell.h"

#import "CalculateStringTool.h"

@implementation PhoneTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self create];
    }
    return self;
}
- (void)create{
    
    self.timeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.timeButton setImage:[UIImage imageNamed:@"时间-(1)"] forState:UIControlStateNormal];
    [self.timeButton setTitle:@"暂无" forState:UIControlStateNormal];
    self.timeButton.titleLabel.font = [UIFont systemFontOfSize:autoScaleW(12)];
    [self.timeButton setTitleColor:RGB(48,48,48) forState:UIControlStateNormal];
    [self.contentView addSubview:_timeButton];
    self.timeButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    
    self.phoneButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.phoneButton setImage:[UIImage imageNamed:@"电话"] forState:UIControlStateNormal];
    [self.phoneButton setTitle:@"0592-00000000" forState:UIControlStateNormal];
    self.phoneButton.titleLabel.font = _timeButton.titleLabel.font;
    [self.phoneButton setTitleColor:RGB(48,48,48) forState:UIControlStateNormal];
    [self.contentView addSubview:_phoneButton];
    
    

    self.timeButton.sd_layout
    .leftSpaceToView(self.contentView, autoScaleW(23))
    .topEqualToView(self.contentView)
    .rightSpaceToView (self.contentView, 200)
    .heightIs(autoScaleH(40));

    self.phoneButton.sd_layout
    .rightSpaceToView(self.contentView, 10)
    .topEqualToView(self.contentView)
    .leftSpaceToView(_timeButton, 5)
    .heightIs(autoScaleH(40));

    self.phoneButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [self.timeButton setTitleEdgeInsets:UIEdgeInsetsMake(0, autoScaleW(9), 0, 0)];
    [self.phoneButton setTitleEdgeInsets:UIEdgeInsetsMake(0, autoScaleW(9), 0, 0)];

    [self setupAutoHeightWithBottomViewsArray:@[_timeButton, _phoneButton] bottomMargin:0];
    
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
//    self.timeButton.sd_layout.leftSpaceToView(self, -150).topSpaceToView(self, 14).heightIs(19.0).widthIs(52.0);



}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
