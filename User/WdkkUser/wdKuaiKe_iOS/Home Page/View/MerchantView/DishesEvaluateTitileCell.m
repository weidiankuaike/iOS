//
//  DishesEvaluateTitileCell.m
//  wdKuaiKe_iOS
//
//  Created by Skyer God on 16/9/26.
//  Copyright © 2016年 weiDianKuaiKe. All rights reserved.
//

#import "DishesEvaluateTitileCell.h"

@implementation DishesEvaluateTitileCell
{

        UIView *_circlePoint;
        UILabel *_titleLabel;
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {

        _circlePoint = [[UIView alloc] init];
        _circlePoint.backgroundColor = RGB(236, 125, 123);
        [self.contentView addSubview:_circlePoint];

        _titleLabel = [[UILabel alloc] init];
        _titleLabel.text = @"商品详情";
        _titleLabel.font = [UIFont systemFontOfSize:15];
        [self.contentView addSubview:_titleLabel];
        _titleLabel.textColor = [UIColor grayColor];

        UILabel *bottomSeparator = [[UILabel alloc] init];
        bottomSeparator.backgroundColor = [UIColor lightTextColor];
        [self.contentView addSubview:bottomSeparator];





        _circlePoint.sd_layout
        .leftSpaceToView(self.contentView, 5)
        .topSpaceToView(self.contentView, 20)
        .widthIs(5)
        .heightEqualToWidth();
        _circlePoint.sd_cornerRadiusFromWidthRatio = @(0.5);

        _titleLabel.sd_layout
        .leftSpaceToView(_circlePoint, 5)
        .topSpaceToView(self.contentView, 7.5)
        .heightIs(30);
        [_titleLabel setSingleLineAutoResizeWithMaxWidth:100];

        bottomSeparator.sd_layout
        .leftEqualToView(self.contentView)
        .topSpaceToView(_titleLabel, 7.5)
        .rightEqualToView(self.contentView)
        .heightIs(1);
        [self setupAutoHeightWithBottomViewsArray:@[_circlePoint, _titleLabel, bottomSeparator] bottomMargin:1];
    }
    return self;
}
-(void)setModel:(DishesInfoModel *)model{
//    _titleLabel.text = model.evaluateTitle;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
