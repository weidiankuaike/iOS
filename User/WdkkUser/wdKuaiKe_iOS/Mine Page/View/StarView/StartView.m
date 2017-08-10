//
//  StartView.m
//  wdKuaiKe_iOS
//
//  Created by 张森森 on 17/1/10.
//  Copyright © 2017年 weiDianKuaiKe. All rights reserved.
//

#import "StartView.h"
#define FOREGROUND_STAR_IMAGE_NAME @"b27_icon_star_yellow"
#define BACKGROUND_STAR_IMAGE_NAME @"b27_icon_star_gray"
#define DEFALUT_STAR_NUMBER 5
@interface StartView ()
@property (nonatomic, strong) UIView *foregroundStarView;
@property (nonatomic, strong) UIView *backgroundStarView;
@property (nonatomic, assign) NSInteger numberOfStars;
@end


@implementation StartView
- (instancetype)initWithFrame:(CGRect)frame
{
    return [self initWithFrame:frame numberOfStars:DEFALUT_STAR_NUMBER];
}
- (instancetype)initWithFrame:(CGRect)frame numberOfStars:(NSInteger)numberOfStar
{
    if (self = [super initWithFrame:frame]) {
        _numberOfStars = numberOfStar;
        [self buildDataAndUI];
    }
    return self;
}
- (void)buildDataAndUI
{
    _scorePercent = 1;
    self.foregroundStarView = [self createStarViewWithImage:FOREGROUND_STAR_IMAGE_NAME];
    self.backgroundStarView = [self createStarViewWithImage:BACKGROUND_STAR_IMAGE_NAME];
    
    [self addSubview:self.backgroundStarView];
    [self addSubview:self.foregroundStarView];
}
- (UIView *)createStarViewWithImage:(NSString *)imageName
{
    UIView *view = [[UIView alloc] initWithFrame:self.bounds];
    view.clipsToBounds = YES;
    view.backgroundColor = [UIColor clearColor];
    for (int i = 0; i < self.numberOfStars; i++) {
        UIImageView *imgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"星星"]];
        imgView.frame = CGRectMake(i * self.bounds.size.width / self.numberOfStars, 0, self.bounds.size.width / self.numberOfStars, self.bounds.size.height );
        imgView.contentMode = UIViewContentModeScaleAspectFit;
        [view addSubview:imgView];
    }
    return view;
}
- (void)setScorePercent:(CGFloat)scorePercent
{
    if (_scorePercent == scorePercent) {
        return;
    }
    if (scorePercent < 0) {
        _scorePercent = 0;
        
    } else if (scorePercent > 1) {
        _scorePercent = 1;
    } else {
        _scorePercent = scorePercent;
    }
    self.foregroundStarView.frame = CGRectMake(0,0,self.bounds.size.width * self.scorePercent , self.bounds.size.height);
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
