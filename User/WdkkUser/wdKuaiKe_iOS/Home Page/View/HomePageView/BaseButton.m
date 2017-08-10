//
//  BaseButton.m
//  WDKKtest
//
//  Created by Skyer God on 16/7/22.
//  Copyright © 2016年 weiDianKuaiKe. All rights reserved.
//


//#define Row_Space 15.0
//#define Title_Space 5.0f
#import "BaseButton.h"

@interface BaseButton ()

@end
@implementation BaseButton

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
static int imageHeight = 0;

-(instancetype)initWithFrame:(CGRect)frame{
     self = [super initWithFrame:frame];
    if (self) {
        
        [self initWithButton];
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        
    }
    return self;
}

- (void)initWithButton{
    
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.titleLabel.font = [UIFont systemFontOfSize:autoScaleW(15)];
    
    if (_isCircle) {
        
        self.imageView.layer.cornerRadius = (imageHeight - _Image_Y) / 2;
        self.imageView.layer.masksToBounds = YES;
    }
}
- (CGRect)imageRectForContentRect:(CGRect)contentRect{
    CGFloat inteval = CGRectGetWidth(contentRect) / 4.0;
    inteval = MIN(inteval, autoScaleW(6));

    CGRect rect = CGRectMake(_Image_X * 1.5, _Image_Y, contentRect.size.width - _Image_X * 3, contentRect.size.width - _Image_X * 3);
    
    imageHeight = rect.size.height + _Image_Y;

    return rect;
}

- (void)imageWithStart_Y:(CGFloat)start_Y{
    
     _Image_Y = start_Y;
    [self initWithButton];
    
}
- (CGRect)titleRectForContentRect:(CGRect)contentRect {

    
    return  CGRectMake(_Image_X, imageHeight + _Title_Space , contentRect.size.width - _Image_X * 2, contentRect.size.height - imageHeight - _Title_Space - _Image_Y );

}


@end
