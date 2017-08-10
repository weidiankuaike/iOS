//
//  RecommendTableViewCell.m
//  WDKKtest
//
//  Created by Skyer God on 16/7/21.
//  Copyright © 2016年 weiDianKuaiKe. All rights reserved.
//
#define Start_X 15.0f
#define Start_Y 15.0f
#define Row_Space 20.0f
#define ImageV_Width (self.frame.size.width - ((Start_X * 2) + Row_Space)) / 2
#import "RecommendTableViewCell.h"

@implementation RecommendTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    

    
}
- (instancetype)initWithFrame:(CGRect)frame{

    self = [super initWithFrame:frame];
    
    if (self) {
        [self createRecommendImageView];
    }
    return self;
}
- (void)createRecommendImageView{
    
    self.firstImageV = [[UIImageView alloc] init];
    
    [self addSubview:_firstImageV];
    
    self.secondImageV = [[UIImageView alloc] init];
    
    [self addSubview:_secondImageV];
    
    self.firstImageV.image = [UIImage imageNamed:@"first"];
    
    self.secondImageV.image = [UIImage imageNamed:@"second"];
    
    self.backgroundColor = [UIColor whiteColor];
    
    self.layer.borderColor = [UIColor colorWithRed:0.7482 green:0.7482 blue:0.7482 alpha:1.0].CGColor;
    self.layer.borderWidth = 0.5f;
}
- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.firstImageV.frame = CGRectMake(Start_X, Start_Y, ImageV_Width, self.frame.size.height - Start_Y * 2);
    self.firstImageV.layer.cornerRadius = self.frame.size.height / 12;
    self.firstImageV.clipsToBounds = YES;
    
    self.secondImageV.frame = CGRectMake(_firstImageV.frame.origin.x + _firstImageV.frame.size.width + Row_Space, _firstImageV.frame.origin.y, _firstImageV.frame.size.width, _firstImageV.frame.size.height);
    
    self.secondImageV.layer.cornerRadius = _firstImageV.layer.cornerRadius;
    self.secondImageV.clipsToBounds = YES;
    
}

@end
