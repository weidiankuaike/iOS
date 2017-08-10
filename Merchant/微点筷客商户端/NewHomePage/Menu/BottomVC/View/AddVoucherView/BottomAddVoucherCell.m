//
//  BottomAddVoucherCell.m
//  微点筷客商户端
//
//  Created by Skyer God on 16/12/1.
//  Copyright © 2016年 张森森. All rights reserved.
//

#import "BottomAddVoucherCell.h"

@implementation BottomAddVoucherCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier ];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self create];
    }
    return self;
}
- (void)create{
    _addVoucherBT = [ButtonStyle buttonWithType:UIButtonTypeCustom];
    [_addVoucherBT setBackgroundColor:RGB(253, 242, 223)];
    [_addVoucherBT setBackgroundImage:[UIImage imageNamed:@"虚线"] forState:UIControlStateNormal];
//    [_addVoucherBT addTarget:self action:@selector(addVoucherBTAction:) forControlEvents:UIControlEventTouchUpInside];
    [_addVoucherBT setTitle:@"+ 添加活动" forState:UIControlStateNormal];
    [_addVoucherBT setTitleColor:RGB(241, 157, 78) forState:UIControlStateNormal];
    _addVoucherBT.adjustsImageWhenHighlighted = NO;
    [self.contentView addSubview:_addVoucherBT];

    _addVoucherBT.sd_layout
    .leftEqualToView(self.contentView)
    .topSpaceToView(self.contentView, 5)
    .rightEqualToView(self.contentView)
    .bottomSpaceToView(self.contentView, 0);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
