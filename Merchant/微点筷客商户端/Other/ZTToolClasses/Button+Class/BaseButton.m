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
    self.titleLabel.font = [UIFont systemFontOfSize:autoScaleW(11)];
    

}

- (CGRect)imageRectForContentRect:(CGRect)contentRect{
    CGFloat inteval = CGRectGetWidth(contentRect) / 4.0;
    inteval = MIN(inteval, autoScaleW(6));

    CGRect rect = CGRectMake(_Image_X * 1.5, _Image_Y, contentRect.size.width - _Image_X * 3, contentRect.size.width - _Image_X * 3);


    return rect;
}

- (CGRect)titleRectForContentRect:(CGRect)contentRect {

    CGFloat title_y = contentRect.size.width - _Image_X * 3 + _Title_Space;
    CGFloat width = contentRect.size.width * 1.3;
    CGFloat title_x = -(width - contentRect.size.width ) / 2;
    CGFloat height = contentRect.size.height - title_y - _Title_Space;
    CGRect rect = CGRectMake(title_x, title_y , width, height);
    return rect;

}
//-(void)layoutSubviews{
//    [super layoutSubviews];
//    if (self.titleLabel.text != nil) {
//        NSString *text = self.titleLabel.text;
//        NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:text];
//        [str addAttributes:self.titleLabel.attributedText.attributes range:NSMakeRange(0, text.length)];
//        [str addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInt:NSUnderlineStyleNone] range:NSMakeRange(0,text.length)];
//
//        if (self.isSelected) {
//            [str addAttribute:NSForegroundColorAttributeName value:UIColorFromRGB(0xfd7577) range:NSMakeRange(0, text.length)];
//            [self setAttributedTitle:str forState:UIControlStateSelected];
//        } else {
//            [self setAttributedTitle:str forState:UIControlStateNormal];
//        }
//    }
//    
//}



@end
