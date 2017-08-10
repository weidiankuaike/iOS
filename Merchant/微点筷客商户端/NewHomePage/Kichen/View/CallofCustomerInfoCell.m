//
//  CallofCustomerInfoCell.m
//  微点筷客商户端
//
//  Created by Skyer God on 16/10/14.
//  Copyright © 2016年 张森森. All rights reserved.
//

#import "CallofCustomerInfoCell.h"

@implementation CallofCustomerInfoCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = 0;
        [self create];
    }
    return self;
}
- (void) create{

    _imageV = [[UIImageView alloc] init];
    _imageV.image = [UIImage imageNamed:@"提示"];
    [self.contentView addSubview:_imageV];

    _callInfoLabel = [[UILabel alloc] init];
    NSString *keyword = @"27号";
    _callInfoLabel.text = [NSString stringWithFormat:@"%@桌的客人呼叫点餐", keyword];
    _callInfoLabel.textColor = RGB(136, 136, 136);
    _callInfoLabel.font = [UIFont systemFontOfSize:12];

    NSMutableAttributedString *att = [[NSMutableAttributedString alloc] initWithString:_callInfoLabel.text];
    NSRange range = [_callInfoLabel.text rangeOfString:keyword];
    [att addAttribute:NSForegroundColorAttributeName
                value:[UIColor redColor]
                range:range];
    _callInfoLabel.attributedText = att;
    [self.contentView addSubview:_callInfoLabel];

    _recivBT = [ButtonStyle buttonWithType:UIButtonTypeCustom];
    [_recivBT setTitle:@"上菜" forState:UIControlStateNormal];
    [_recivBT setTitleColor:RGB(234, 52, 38) forState:UIControlStateSelected];
    [_recivBT setTitleColor:RGB(136, 136, 136) forState:UIControlStateNormal];
    [_recivBT.titleLabel setFont:_callInfoLabel.font];
    [self.contentView addSubview:_recivBT];

    UILabel *verticalLbel = [[UILabel alloc] init];
    verticalLbel.backgroundColor = RGB(136, 136, 136);
    [self.contentView addSubview:verticalLbel];

    _checkBT = [ButtonStyle buttonWithType:UIButtonTypeCustom];
    [_checkBT setTitle:@"查看" forState:UIControlStateNormal];
    [_checkBT setTitleColor:RGB(234, 52, 38) forState:UIControlStateSelected];
    [_checkBT setTitleColor:RGB(136, 136, 136) forState:UIControlStateNormal];
    [_checkBT.titleLabel setFont:_callInfoLabel.font];
    [self.contentView addSubview:_checkBT];


    CGFloat start_x = 5;
    _imageV.sd_layout
    .leftSpaceToView(self.contentView, start_x)
    .centerYEqualToView(self.contentView)
    .widthIs(15)
    .heightIs(15);

    _recivBT.sd_layout
    .topEqualToView(self.contentView)
    .rightSpaceToView(self.contentView, start_x)
    .bottomEqualToView(self.contentView)
    .widthIs(30);

    verticalLbel.sd_layout
    .topSpaceToView(self.contentView, 8)
    .rightSpaceToView(_recivBT, 15)
    .bottomSpaceToView(self.contentView, 8)
    .widthIs(0.8);

    _checkBT.sd_layout
    .topEqualToView(_recivBT)
    .bottomEqualToView(_recivBT)
    .rightSpaceToView(verticalLbel, 15)
    .widthIs(30);

    _callInfoLabel.sd_layout
    .leftSpaceToView(_imageV, 5)
    .topEqualToView(self.contentView)
    .bottomEqualToView(self.contentView)
    .rightSpaceToView(_checkBT, 8);

    [_recivBT addTarget:self action:@selector(reciveClick:) forControlEvents:UIControlEventTouchUpInside];
}
- (void)reciveClick:(ButtonStyle *)sender{
    sender.selected = !sender.selected;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
