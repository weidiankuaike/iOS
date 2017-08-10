//
//  DishesCategoryCell.m
//  wdKuaiKe_iOS
//
//  Created by Skyer God on 16/9/20.
//  Copyright © 2016年 weiDianKuaiKe. All rights reserved.
//

#import "DishesCategoryCell.h"

@implementation DishesCategoryCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = RGB(238, 238, 238);
        [self create];
    }
    return self;
}
- (void)create{

    _categoryLabel = [[UILabel alloc] init];
    _categoryLabel.font = [UIFont systemFontOfSize:14];
    _categoryLabel.numberOfLines = 0;
    _categoryLabel.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:_categoryLabel];
    
    
    UILabel *bottomSeparatorLine = [[UILabel alloc] init];
    bottomSeparatorLine.backgroundColor = [UIColor lightGrayColor];
    [self.contentView addSubview:bottomSeparatorLine];

    bottomSeparatorLine.sd_layout
    .leftEqualToView(self.contentView)
    .bottomEqualToView(self.contentView)
    .rightEqualToView(self.contentView)
    .heightIs(0.5);




}
-(void)layoutSubviews{
    
    [super layoutSubviews];
    
    _categoryLabel.numberOfLines = 0;
    _categoryLabel.sd_layout
    .centerXEqualToView(self.contentView)
    .centerYEqualToView(self.contentView)
    .heightIs(self.contentView.size.height - 2)
    .widthRatioToView(self.contentView, 0.8);
    [_categoryLabel setMaxNumberOfLinesToShow:0];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    if (self.selected) {
        self.backgroundColor = [UIColor whiteColor];
    } else {
        self.backgroundColor = RGB(238, 238, 238);
    }



    // Configure the view for the selected state
}

@end
