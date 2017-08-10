//
//  RestaurantOrderCell.m
//  wdKuaiKe_iOS
//
//  Created by Skyer God on 16/9/18.
//  Copyright © 2016年 weiDianKuaiKe. All rights reserved.
//
#define Start_X 15.0f
#define Start_Y 10.f
#define Row_Space 15.0f

#define ImageWidth [UIScreen mainScreen].bounds.size.height / 10.5
#import "RestaurantOrderCell.h"
#import "DishesInfoModel.h"
@implementation RestaurantOrderCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.number = 0;
        [self create];
        self.selectionStyle = UITableViewCellSelectionStyleNone;

    }
    return self;
}
- (void)create{

    //设置顶部label
    self.bottomSeparator = [[UIView alloc] init];
    self.bottomSeparator.backgroundColor = UIColorFromRGB(0xEEEEEE);
    [self.contentView addSubview:_bottomSeparator];


    //设置商家列表图片
    self.menuImageV = [[UIImageView alloc] init];
    self.menuImageV.backgroundColor = [UIColor blueColor];

//    self.menuImageV.image = [UIImage imageNamed:@"example"];
    [self.contentView addSubview:_menuImageV];

    //设置商家名
    self.titleLabel = [[UILabel alloc] init];

    self.titleLabel.font = [UIFont systemFontOfSize:autoScaleW(13)];

    self.titleLabel.textAlignment = NSTextAlignmentLeft;
    _titleLabel.numberOfLines = 0;
    [self.contentView addSubview:_titleLabel];

    self.peolpleLabel = [[UILabel alloc]init];
    self.peolpleLabel.font = [UIFont systemFontOfSize:12];
    self.peolpleLabel.textColor = [UIColor lightGrayColor];
    self.titleLabel.textAlignment = NSTextAlignmentLeft;
    [self.contentView addSubview:self.peolpleLabel];
    
    //设置单价／人

    self.priceLabel = [[UILabel alloc] init];


    _priceLabel.textAlignment = NSTextAlignmentCenter;

    _priceLabel.font = [UIFont systemFontOfSize:autoScaleW(15)];

    _priceLabel.textColor = [UIColor colorWithRed:0.3013 green:0.3013 blue:0.3013 alpha:1.0];
    [self.contentView addSubview:_priceLabel];
    

    _addBT = [UIButton buttonWithType:UIButtonTypeCustom];
    [_addBT setBackgroundImage:[UIImage imageNamed:@"加号"] forState:UIControlStateNormal];
    [self.contentView addSubview:_addBT];


    self.numLabel = [[UILabel alloc] init];
    self.numLabel.textColor = [UIColor blackColor];
    self.numLabel.font = [UIFont systemFontOfSize:14];
    self.numLabel.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:_numLabel];

    self.subtractBT = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.subtractBT setBackgroundImage:[UIImage imageNamed:@"减号"] forState:UIControlStateNormal];
    [self.contentView addSubview:_subtractBT];
    
    
    [self.addBT addTarget:self action:@selector(clickAddBT:) forControlEvents:UIControlEventTouchUpInside];
    [self.subtractBT addTarget:self action:@selector(clickSubBT:) forControlEvents:UIControlEventTouchUpInside];
//
        self.numLabel.hidden = YES;
        self.subtractBT.hidden = YES;

    
    
//    if([self.numLabel.text isEqualToString:@"0"]){
//        
//        self.numLabel.hidden = YES;
//        self.subtractBT.hidden = YES;
//    }

    self.menuImageV.sd_layout
    .leftSpaceToView(self.contentView, Start_X)
    .topSpaceToView(self.contentView, Start_Y)
    .widthIs(ImageWidth)
    .heightIs(ImageWidth);

    self.bottomSeparator.sd_layout.leftEqualToView(self.contentView).topSpaceToView(_menuImageV, Start_Y).rightEqualToView(self.contentView).heightIs(3);


    self.titleLabel.sd_layout
    .leftSpaceToView(_menuImageV, Start_X)
    .topSpaceToView(self.contentView, Start_Y - 3)
    .heightIs(ImageWidth /2)
    .rightSpaceToView(self.contentView, 3);
    
    self.peolpleLabel.sd_layout.leftEqualToView(_titleLabel)
    .topSpaceToView (_titleLabel,2)
    .heightIs(12);
    [self.peolpleLabel setSingleLineAutoResizeWithMaxWidth:100];

    
    self.priceLabel.sd_layout
    .leftEqualToView(_titleLabel)
    .topSpaceToView(_peolpleLabel,5)
    .heightIs(ImageWidth/4);

    [self.priceLabel setSingleLineAutoResizeWithMaxWidth:180];

//    self.hotBT.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;


    CGFloat buttonWidth = 25;
    CGFloat right_space = 15;


    self.addBT.sd_layout.centerYEqualToView(self.contentView) .widthIs(buttonWidth).heightIs(buttonWidth).rightSpaceToView(self.contentView, 15);

    self.numLabel.sd_layout
    .rightSpaceToView(_addBT, 3)
    .topEqualToView(_addBT)
    .heightIs(buttonWidth);
    [self.numLabel setSingleLineAutoResizeWithMaxWidth:40];

    self.subtractBT.sd_layout
    .rightSpaceToView(_numLabel, 3)
    .topEqualToView(_numLabel)
    .heightIs(buttonWidth)
    .widthIs(buttonWidth);

//    button.sd_layout
//    .leftSpaceToView(_addBT, 0)
//    .topSpaceToView(self.contentView, 5)
//    .rightEqualToView(self.contentView)
//    .bottomSpaceToView(self.contentView, Start_Y * 3);


    [self setupAutoHeightWithBottomViewsArray:@[_bottomSeparator, _menuImageV, _priceLabel, _addBT] bottomMargin:0];


}

- (void)clickAddBT:(UIButton *)sender{


    self.number = [self.numLabel.text intValue];
    self.number += 1;
    self.plusBlock(self.number, YES);
    [self showOrderNumbers:self.number];


}
- (void)clickSubBT:(UIButton *)sender{

    self.number = [self.numLabel.text intValue];
    self.number -=1;
    self.plusBlock(self.number, NO);
    [self showOrderNumbers:self.number];
}

-(void)showOrderNumbers:(NSUInteger)count
{
    self.numLabel.text = [NSString stringWithFormat:@"%lu",(unsigned long)self.number];
    if (self.number > 0)
    {
        [self.subtractBT setHidden:NO];
        [self.numLabel setHidden:NO];
    }
    else
    {
        [self.subtractBT setHidden:YES];
        [self.numLabel setHidden:YES];
    }
}
-(void)setModel:(DishesDetailModel *)model{
    _model = model;
    
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:model.images]]) {
        
        [_menuImageV sd_setImageWithURL:[NSURL URLWithString:model.images] placeholderImage:[UIImage imageNamed:@"loadingIcon"]];
    }else{
        
        NSString * imageStr = [model.images stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
        [_menuImageV sd_setImageWithURL:[NSURL URLWithString:imageStr] placeholderImage:[UIImage imageNamed:@"loadingIcon"]];
    }
    
    
     _titleLabel.text = _model.productName;
//    _titleLabel.adjustsFontSizeToFitWidth = YES;
    
    _priceLabel.text = [NSString stringWithFormat:@"￥%@",_model.fee] ;
    _peolpleLabel.text = [NSString stringWithFormat:@"%@人点过",_model.sales];
    
    self.numLabel.text = @"0";
    self.numLabel.hidden = YES;
    self.subtractBT.hidden = YES;
    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
