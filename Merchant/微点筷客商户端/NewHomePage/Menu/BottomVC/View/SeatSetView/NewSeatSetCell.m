//
//  NewSeatSetCell.m
//  微点筷客商户端
//
//  Created by Skyer God on 16/12/6.
//  Copyright © 2016年 张森森. All rights reserved.
//

#import "NewSeatSetCell.h"

@implementation NewSeatSetCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor clearColor];
        [self create];
    }
    return self;
}
- (void)create{
    UIColor *commanColor = UIColorFromRGB(0xfd7577);
    UIView *contentView = [[UIView alloc] init];
    contentView.backgroundColor = [UIColorFromRGB(0xffedee) colorWithAlphaComponent:0.4];
    [self.contentView addSubview:contentView];
    contentView.sd_layout.spaceToSuperView(UIEdgeInsetsZero);
    [contentView updateLayout];
    contentView.sd_cornerRadiusFromHeightRatio = @(0.1);
    contentView.layer.borderColor = [UIColorFromRGB(0xfd7577) colorWithAlphaComponent:0.5].CGColor;
    contentView.layer.borderWidth = 0.7;

    _numLabel = [[UILabel alloc] init];
    _numLabel.text = @"编号";
    _numLabel.textColor = commanColor;
    [contentView addSubview:_numLabel];

    _deskCategoryLabel = [[UILabel alloc] init];
    _deskCategoryLabel.textColor = _numLabel.textColor;
    _deskCategoryLabel.text = @"类型";
    [contentView addSubview:_deskCategoryLabel];
    
    _scanButton = [ButtonStyle buttonWithType:UIButtonTypeCustom];
    [_scanButton setImage:[UIImage imageNamed:@"qrCode_red"] forState:UIControlStateNormal];
    [_scanButton addTarget:self action:@selector(scanOrDeleteBTAction:) forControlEvents:UIControlEventTouchUpInside];
    [_scanButton setTintColor:commanColor];
    [contentView addSubview:_scanButton];

    _deleteButton = [ButtonStyle buttonWithType:UIButtonTypeCustom];
    [_deleteButton setImage:[UIImage imageNamed:@"delete_red"] forState:UIControlStateNormal];
    [_deleteButton addTarget:self action:@selector(scanOrDeleteBTAction:) forControlEvents:UIControlEventTouchUpInside];
    [contentView addSubview:_deleteButton];
    _deleteButton.hidden = YES;

    _numLabel.sd_layout
    .leftSpaceToView(contentView, 15)
    .topEqualToView(contentView)
    .bottomEqualToView(contentView);
    [_numLabel setSingleLineAutoResizeWithMaxWidth:100];

    _scanButton.sd_layout
    .topSpaceToView(contentView, 5)
    .rightSpaceToView(contentView, 5)
    .bottomSpaceToView(contentView, 5)
    .widthIs(contentView.size.height - 5 * 2);

    _deleteButton.sd_layout
    .topSpaceToView(contentView, 5)
    .rightSpaceToView(contentView, 5)
    .bottomSpaceToView(contentView, 5)
    .widthIs(contentView.size.height - 5 * 2);


    _deskCategoryLabel.sd_layout
    .topEqualToView(contentView)
    .rightSpaceToView(_scanButton, 5)
    .bottomEqualToView(contentView);
    [_deskCategoryLabel setSingleLineAutoResizeWithMaxWidth:100];



}
- (void)setModel:(DeskSetModel *)model{

    _model = model;
    [_model.leftDic enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {

        if ([obj isEqualToString:model.boardType]) {
            _deskCategoryLabel.text = key;
            return ;
        }
    }];
    if (![model.isBind boolValue]) {
        [_scanButton setImage:[UIImage imageNamed:@"scan_red"] forState:UIControlStateNormal];
    } else {
        [_scanButton setImage:[UIImage imageNamed:@"qrCode_red"] forState:UIControlStateNormal];
    }
    _numLabel.text = [NSString stringWithFormat:@"%@%@号", model.boardType, model.boardNum];
    _deskId = model.boardId;
    
}
- (void)scanOrDeleteBTAction:(ButtonStyle *)sender{
    if (sender == _scanButton) {
        if (self.scanOrDeleteClick) {
            _scanOrDeleteClick(0);
        }
    } else {
        if (self.scanOrDeleteClick) {
            _scanOrDeleteClick(1);
        }
    }
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
