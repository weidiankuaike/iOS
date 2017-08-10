//
//  StuffCenterCell.m
//  微点筷客商户端
//
//  Created by Skyer God on 17/2/23.
//  Copyright © 2017年 张森森. All rights reserved.
//
#define space 15
#import "StuffCenterCell.h"
#import "MBProgressHUD+SS.h"
@implementation StuffCenterCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.separatorInset = UIEdgeInsetsMake(0, 5, 0, 5);
        self.backgroundColor = [UIColor whiteColor];

        [self setUp];
    }
    return self;
}
- (void)setUp{
    //    UILabel *topLine = [[UILabel alloc] init];
    //    topLine.backgroundColor = [UIColor lightGrayColor];
    //    [self.contentView addSubview:topLine];
    //    topLine.sd_layout
    //    .leftSpaceToView()
    //
    //    UILabel *bottomLine = [[UILabel alloc] init];
    //    bottomLine.backgroundColor = [UIColor lightGrayColor];
    //    [self.contentView addSubview:bottomLine];


    //分区一，row 2

    _lockButton = [ButtonStyle buttonWithType:UIButtonTypeCustom];
    [_lockButton setImage:[UIImage imageNamed:@"lock_off"] forState:UIControlStateNormal];
    
    [self.contentView addSubview:_lockButton];
    _lockButton.hidden = YES;

    _detailLB = [[UILabel alloc] init];
    _detailLB.text = @"负荷违法 i 绝望";
    [self.contentView addSubview:_detailLB];
    _detailLB.hidden = YES;

    _lockButton.sd_layout
    .rightSpaceToView(self.contentView, autoScaleW(space))
    .centerYEqualToView(self.contentView)
    .widthIs(30)
    .heightIs(30);

    _detailLB.sd_layout
    .rightSpaceToView(_lockButton, 3)
    .centerYEqualToView(_lockButton)
    .heightIs(30);
    [_detailLB setSingleLineAutoResizeWithMaxWidth:120];




    _switchBT = [[UISwitch alloc]init];
    _switchBT.on = YES;
    [_switchBT setOnTintColor:UIColorFromRGB(0xfd7577)];
    [_switchBT addTarget:self action:@selector(swChange:) forControlEvents:UIControlEventValueChanged];
    [self.contentView addSubview:_switchBT];
    _switchBT.hidden = YES;
    _switchBT.sd_layout
    .rightSpaceToView(self.contentView, autoScaleW(space + 3))
    .centerYEqualToView(self.contentView);
}
- (void)swChange:(UISwitch *)sender{
    sender.on = YES;
    [MBProgressHUD showError:@"暂无权限"];

}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
