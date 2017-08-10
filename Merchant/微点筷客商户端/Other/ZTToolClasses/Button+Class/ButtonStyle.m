//
//  ButtonStyle.m
//  merchantClient
//
//  Created by Skyer God on 2017/7/20.
//  Copyright © 2017年 张甜. All rights reserved.
//
#define DefaultSapce 5
#import "ButtonStyle.h"

@implementation ButtonStyle


-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {


        self.titleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return self;
}
-(void)setZtButtonStyle:(NSUInteger)ztButtonStyle{
    _ztButtonStyle = ztButtonStyle;
    switch (ztButtonStyle) {
        case ZTButtonStyleNormal:
            ;
            break;
        case ZTButtonStyleTextLeftImageRight:
        {
            CGSize size = [self.currentTitle sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:self.titleLabel.font,NSFontAttributeName, nil]];
            CGFloat imageWidth = self.currentImage.size.width;
            CGFloat space = _textToImageSapce == 0 ? DefaultSapce : _textToImageSapce;
            CGFloat width = size.width + imageWidth + space;
            CGFloat offset = width - self.frame.size.width;
            [self setImageEdgeInsets:UIEdgeInsetsMake(0, size.width + space, 0, 0)];
            [self setTitleEdgeInsets:UIEdgeInsetsMake(0, - imageWidth, 0, imageWidth + space)];
            self.frame = CGRectMake(self.frame.origin.x - offset, self.frame.origin.y, width, self.frame.size.height);
            self.contentMode = UIControlContentVerticalAlignmentCenter;
        };
            break;

        case ZTButtonStyleTextBottomImageTopNormal:
        {
            CGSize size = [self.currentTitle sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:self.titleLabel.font,NSFontAttributeName, nil]];
            
        };
            break;

        case ZTButtonStyletextBottomIamgeTopCircle:
            ;
            break;

        default:
            break;
    }
}
-(void)layoutSubviews{
    [super layoutSubviews];
    if (self.titleLabel.text != nil) {
        NSString *text = self.titleLabel.text;
        NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:text];
        [str addAttributes:self.titleLabel.attributedText.attributes range:NSMakeRange(0, text.length)];
        [str addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInt:NSUnderlineStyleNone] range:NSMakeRange(0,text.length)];

        if (self.isSelected && _ztButtonStyle == 0) {
            [str addAttribute:NSForegroundColorAttributeName value:UIColorFromRGB(0xfd7577) range:NSMakeRange(0, text.length)];
            [self setAttributedTitle:str forState:UIControlStateSelected];
        } else {
            [self setAttributedTitle:str forState:UIControlStateNormal];
        }
    }

}
@end
