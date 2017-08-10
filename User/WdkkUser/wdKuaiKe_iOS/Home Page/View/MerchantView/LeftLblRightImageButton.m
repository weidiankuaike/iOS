//
//  LeftLblRightImageButton.m
//  wdKuaiKe_iOS
//
//  Created by Skyer God on 16/9/7.
//  Copyright © 2016年 weiDianKuaiKe. All rights reserved.
//

#import "LeftLblRightImageButton.h"

@implementation LeftLblRightImageButton

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {

    }
    return self;
}

-(CGRect)imageRectForContentRect:(CGRect)contentRect{
    CGFloat width = contentRect.size.width - _titileWidth - _imageSpace;
    return CGRectMake(_titileWidth + _imageSpace, _image_Y, _image_Width, _image_Width);
}
-(CGRect)titleRectForContentRect:(CGRect)contentRect{
    return CGRectMake(0, 0, _titileWidth, contentRect.size.height);
}
@end
