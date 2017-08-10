//
//  AllocationNumRemindCell.m
//  wdKuaiKe_iOS
//
//  Created by Skyer God on 16/9/8.
//  Copyright © 2016年 weiDianKuaiKe. All rights reserved.
//

#import "AllocationNumRemindCell.h"
#import "TwoLineLabelButton.h"

@interface AllocationNumRemindCell ()
{
    UILabel *_middleLbl;
    UIButton *_remindMeBT;
}

@end
@implementation AllocationNumRemindCell


- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.layer.borderWidth = 1;
        self.layer.borderColor = [UIColor colorWithRed:0.5 green:0.5 blue:0.5 alpha:0.17].CGColor;

        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self create];
    }
    return self;
}
- (void)create{
        /** 中间label分割线 **/
    _middleLbl = [[UILabel alloc] init];
    _middleLbl.backgroundColor = [UIColor colorWithRed:arc4random() % 255 / 255.0 green:arc4random() % 255 / 255.0 blue:arc4random() % 255 / 255.0 alpha:arc4random() % 255 / 255.0];
    [self.contentView addSubview:_middleLbl];


    NSArray *first = @[@"当前距离", @"1.1km", @"限制距离", @"30.0km"];
    NSArray *firstColor = @[[UIColor grayColor], [UIColor blackColor]];


    for (NSInteger i = 0; i < 4; i++) {

        UILabel *twoLineBt = [[UILabel alloc] init];

        [self.contentView addSubview:twoLineBt];
        twoLineBt.text = first[i];
        twoLineBt.tag = 1050 + i;

        twoLineBt.font = [UIFont systemFontOfSize:autoScaleW(12)];

        twoLineBt.backgroundColor = [UIColor colorWithRed:arc4random() % 255 / 255.0 green:arc4random() % 255 / 255.0 blue:arc4random() % 255 / 255.0 alpha:arc4random() % 255 / 255.0];



    }

    _remindMeBT = [UIButton buttonWithType:UIButtonTypeCustom];
    [_remindMeBT setTitle:@"放号提醒我" forState:UIControlStateNormal];
    [_remindMeBT setBackgroundColor:[UIColor colorWithRed:0.6843 green:0.0 blue:0.1897 alpha:1.0]];
    [self.contentView addSubview:_remindMeBT];
    [_remindMeBT.titleLabel setFont:[UIFont systemFontOfSize:autoScaleW(14)]];


}

-(void)layoutSubviews{
    [super layoutSubviews];

    _middleLbl.sd_layout.centerXEqualToView(self.contentView).centerYEqualToView(self.contentView).widthIs(autoScaleW(1)).heightIs(self.contentView.size.height / 8 * 5);

    CGFloat top_space = autoScaleH(5);
    CGFloat width = self.contentView.size.width / 7;
    CGFloat height = (self.contentView.size.height - top_space * 2 ) / 2;
    CGFloat col_sapce = autoScaleW(5);
    for (NSInteger i = 0; i < 4; i++) {

        UILabel *button = [self.contentView viewWithTag:1050 + i];
        NSInteger j = i;
        button.sd_layout.leftSpaceToView(self.contentView, autoScaleW(20) + (width + col_sapce) * (i < 2 ? i : i - 2)).topSpaceToView(self.contentView, top_space + height * (j < 2 ? 0 : 1)).widthIs(width).heightIs(height);


    }
    _remindMeBT.sd_layout.centerXIs(self.contentView.centerX * 3 / 2).centerYIs(self.contentView.centerY).widthIs(self.contentView.size.width / 4 - autoScaleW(10)).heightIs(height * 2 - top_space);


}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
