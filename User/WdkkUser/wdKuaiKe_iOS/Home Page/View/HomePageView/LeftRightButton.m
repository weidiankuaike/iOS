//
//  LeftRightButton.m
//  WDKKtest
//
//  Created by Skyer God on 16/7/26.
//  Copyright © 2016年 weiDianKuaiKe. All rights reserved.
//

#import "LeftRightButton.h"

@implementation LeftRightButton

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self initWithButton];
    }
    return self;
}
- (void)initWithButton{
    
    self.titleLabel.font = [UIFont systemFontOfSize:autoScaleW(15)];
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
}
-(CGRect)titleRectForContentRect:(CGRect)contentRect{

    return CGRectMake(autoScaleW(20), 0, contentRect.size.width - autoScaleW(20) * 2, contentRect.size.height);
}
-(CGRect)imageRectForContentRect:(CGRect)contentRect{
    return CGRectMake(contentRect.size.width - autoScaleW(20), _start_Y == 0 ? contentRect.size.height / 2  : _start_Y, autoScaleW(10), autoScaleH(10));
}
@end
