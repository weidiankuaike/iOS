//
//  ServiceCategoryCell.m
//  微点筷客商户端
//
//  Created by Skyer God on 16/11/22.
//  Copyright © 2016年 张森森. All rights reserved.
//

#import "ServiceCategoryCell.h"

#import "ZTAddOrSubAlertView.h"
@implementation ServiceCategoryCell
{
    UIView *backView;
}
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
    backView = [[UIView alloc] init];
    backView.backgroundColor =  [UIColorFromRGB(0xffedee) colorWithAlphaComponent:0.4];
    [self.contentView addSubview:backView];


    backView.sd_cornerRadiusFromHeightRatio = @(0.1);
    backView.layer.borderColor = [UIColorFromRGB(0xfd7577) colorWithAlphaComponent:0.5].CGColor;
    backView.layer.borderWidth = 0.7;
    _titleLabel = [[UILabel alloc] init];
//    _titleLabel.backgroundColor = [UIColor whiteColor];
    _titleLabel.font = [UIFont systemFontOfSize:15];
    _titleLabel.textColor = UIColorFromRGB(0xfd7577);
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    _titleLabel.userInteractionEnabled = YES;
    _titleLabel.accessibilityViewIsModal = YES;
    _titleLabel.accessibilityElementsHidden = YES;
    _titleLabel.shouldGroupAccessibilityChildren = YES;
    [self.contentView addSubview:_titleLabel];

    _deleteBT = [ButtonStyle buttonWithType:UIButtonTypeCustom];
    [_deleteBT setImage:[UIImage imageNamed:@"delete_red"] forState:UIControlStateNormal];
    [backView addSubview:_deleteBT];
    [_deleteBT addTarget:self action:@selector(deleteClickAction:) forControlEvents:UIControlEventTouchUpInside];
    _deleteBT.hidden = YES;

    backView.sd_layout.spaceToSuperView(UIEdgeInsetsMake(6, 12, 2, 12));
    _titleLabel.sd_layout
    .centerXEqualToView(backView)
    .centerYEqualToView(backView)
    .heightRatioToView(backView, 1);
    [_titleLabel setSingleLineAutoResizeWithMaxWidth:100];

    self.deleteBT.sd_layout
    .centerYEqualToView(self.contentView)
    .rightSpaceToView(backView, 10)
    .widthIs(_deleteBT.currentImage.size.width * 2)
    .heightEqualToWidth(0);
    [_deleteBT setSd_cornerRadiusFromWidthRatio:@(0.5)];



    



}
-(void)deleteClickAction:(ButtonStyle *)sender{

    ZTAddOrSubAlertView *alertV = [[ZTAddOrSubAlertView alloc] initWithStyle:ZTalertSheetStyleTitle];
    alertV.titleLabel.text = @"确定删除?";
    [alertV.confirmBT setTitle:@"删除" forState:UIControlStateNormal];
    [alertV showView];

    alertV.complete = ^(BOOL isSure){
        if (_deleteClick && isSure) {
            _deleteClick(_index);
        }
    };
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
