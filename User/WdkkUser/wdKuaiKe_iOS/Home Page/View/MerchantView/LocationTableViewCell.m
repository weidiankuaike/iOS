//
//  LocationTableViewCell.m
//  wdKuaiKe_iOS
//
//  Created by Skyer God on 16/8/8.
//  Copyright © 2016年 weiDianKuaiKe. All rights reserved.
//

#import "LocationTableViewCell.h"

@implementation LocationTableViewCell
{
    UILabel *_bottomseparator;
    UILabel *_topseparator;
}
- (void)awakeFromNib {
    [super awakeFromNib];

    // Initialization code
}
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self create];
    }
    return self;
    
}

- (void)create{


    _topseparator = [[UILabel alloc] init];
    _topseparator.backgroundColor = RGB(238, 238, 238);
    [self.contentView addSubview:_topseparator];
    
    self.locationBT = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.locationBT setImage:[UIImage imageNamed:@"地址"] forState:UIControlStateNormal];
    [self.locationBT setTitle:@"厦门市思明区软件园二期观日路XXXX" forState:UIControlStateNormal];
    [self.locationBT setTitleColor:RGB(48,48,48) forState:UIControlStateNormal];
    [self.locationBT.titleLabel setFont:[UIFont systemFontOfSize:autoScaleW(12)]];
    [self.locationBT setTitleEdgeInsets:UIEdgeInsetsMake(0, autoScaleW(10), 0, 0)];
    [self.locationBT.titleLabel setTextAlignment:NSTextAlignmentLeft];
    [self.contentView addSubview:_locationBT];
    _locationBT.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    
    self.arrowBT = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.arrowBT setImage:[UIImage imageNamed:@"形状-1-拷贝"] forState:UIControlStateNormal];
    [self.arrowBT setTitle:@"到这去" forState:UIControlStateNormal];
    [self.arrowBT setTitleColor:RGB(132, 132, 132) forState:UIControlStateNormal];
    [self.arrowBT.titleLabel setFont:[UIFont systemFontOfSize:autoScaleW(12)]];
    [self.contentView addSubview:_arrowBT];
    //self.arrowBT.contentHorizontalAlignment = UIControlContentHorizontalAlignmentFill;


    self.arrowBT.userInteractionEnabled = NO;
    self.locationBT.userInteractionEnabled = NO;


    _bottomseparator = [[UILabel alloc] init];
    _bottomseparator.backgroundColor = RGB(238, 238, 238);
    [self.contentView addSubview:_bottomseparator];

    _topseparator.sd_layout
    .leftEqualToView(self.contentView)
    .topEqualToView(self.contentView)
    .rightEqualToView(self.contentView)
    .heightIs(1);

    self.locationBT.sd_layout
    .leftSpaceToView(self.contentView, autoScaleW(24))
    .topSpaceToView(self.contentView, autoScaleH(11))
    .rightSpaceToView(self.contentView, 47)
    .heightIs(autoScaleH(21));

    self.arrowBT.sd_layout.topSpaceToView(self.contentView, autoScaleH(14)).rightSpaceToView(self.contentView, autoScaleW(15)).heightIs(autoScaleH(13)).widthIs(47);
    [self.arrowBT setImageEdgeInsets:UIEdgeInsetsMake(0, (36 + 3), 0, 0)];
    [self.arrowBT setTitleEdgeInsets:UIEdgeInsetsMake(0, (-14), 0, 0)];

    _bottomseparator.sd_layout
    .leftEqualToView(self.contentView)
    .bottomEqualToView(self.contentView)
    .rightEqualToView(self.contentView)
    .heightIs(autoScaleH(3));


    [self setupAutoHeightWithBottomView:_bottomseparator bottomMargin:0];

    

   
    
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
