//
//  CancelReasonCell.m
//  微点筷客商户端
//
//  Created by Skyer God on 17/4/6.
//  Copyright © 2017年 张森森. All rights reserved.
//

#import "CancelReasonCell.h"

@implementation CancelReasonCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {

        UILabel * linelabel = [[UILabel alloc]init];
        linelabel.backgroundColor = UIColorFromRGB(0xeeeeee);
        [self.contentView addSubview:linelabel];
        linelabel.sd_layout.leftSpaceToView(self.contentView,0).rightSpaceToView(self.contentView,0).bottomEqualToView(self.contentView).heightIs(0.5);
        _leftTitleL = [[UILabel alloc]init];
        [self.contentView addSubview:_leftTitleL];
        _leftTitleL.backgroundColor = self.contentView.backgroundColor;
        _leftTitleL.sd_layout.leftSpaceToView(self.contentView,15).topEqualToView(self.contentView).heightIs(autoScaleH(45)).widthIs(200);
        _phoneImage = [[UIImageView alloc]init];
        _phoneImage.image = [UIImage imageNamed:@"电话2"];
        _phoneImage.hidden = YES;
        [self.contentView addSubview:_phoneImage];
        _phoneImage.sd_layout.rightSpaceToView(self.contentView, autoScaleW(10)).topSpaceToView(self.contentView ,autoScaleH(12.5)).widthIs(autoScaleW(20)).heightIs(autoScaleH(20));

        _rightBT = [ButtonStyle buttonWithType:UIButtonTypeCustom];
        _rightBT.hidden = YES;
        _rightBT.userInteractionEnabled = NO;
        [_rightBT setBackgroundImage:[UIImage imageNamed:@"取消选择y"] forState:UIControlStateNormal];
        [_rightBT setBackgroundImage:[UIImage imageNamed:@"取消选择n"] forState:UIControlStateSelected];

        [self.contentView addSubview:_rightBT];

        _rightBT.sd_layout.rightSpaceToView(self.contentView,autoScaleW(10)).topSpaceToView(self.contentView ,autoScaleH(12.5)).widthIs(autoScaleW(15)).heightIs(autoScaleH(15));
    }
    return self;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
