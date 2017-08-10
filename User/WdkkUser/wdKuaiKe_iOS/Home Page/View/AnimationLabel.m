//
//  AnimationLabel.m
//  wdKuaiKe_iOS
//
//  Created by 张森森 on 2017/7/6.
//  Copyright © 2017年 weiDianKuaiKe. All rights reserved.
//

#import "AnimationLabel.h"
#import "UIViewClassHandleTools.h"
#import "UIImage+SSex.h"
@implementation AnimationLabel
- (id)initWithFrame:(CGRect)frame text:(NSString*)text image:(UIImageView *)bacImage{
    
    self = [super init];
    if (self) {
        
        _text = text;
        _backgrounImage = bacImage;
        [self creatLabelWithframe:frame];
        
    }
    
    return self;
}
- (void)creatLabelWithframe:(CGRect)frame{
    
    self.scrollLabel = [[UILabel alloc]init];
    self.scrollLabel.font = [UIFont systemFontOfSize:autoScaleW(13)];
    self.scrollLabel.text = _text;
     CGFloat width = [self windfortextString:_text height:frame.size.height fontsize:autoScaleW(13)];
    self.scrollLabel.frame = CGRectMake(0, 0,width, frame.size.height);
    [self addSubview:self.scrollLabel];
    [self setTextColor:self.scrollLabel frame:frame];

    
    if (width>frame.size.width) {
        
    self.secondLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.scrollLabel.frame.size.width, self.scrollLabel.frame.origin.y, self.scrollLabel.frame.size.width ,self.scrollLabel.frame.size.height)];
        self.secondLabel.font = self.scrollLabel.font;
        self.secondLabel.text = _text;
        [self addSubview:self.secondLabel];
        [self setTextColor:self.secondLabel frame:frame];

        [self addAnimation];
    }
    

}
- (void) addAnimation{
    
    CGRect scrollFrame = self.scrollLabel.frame;
    CGRect secondFrame = self.secondLabel.frame;
    
    [UIView animateWithDuration:15 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
        self.scrollLabel.frame = CGRectMake(-self.scrollLabel.frame.size.width, self.scrollLabel.frame.origin.y, self.scrollLabel.frame.size.width, self.scrollLabel.frame.size.height);
        self.secondLabel.frame = CGRectMake(0, self.secondLabel.frame.origin.y, self.secondLabel.frame.size.width, self.secondLabel.frame.size.height);
    } completion:^(BOOL finished) {
        self.scrollLabel.frame = scrollFrame;
        self.secondLabel.frame = secondFrame;
        [self addAnimation];
    }];
    
}
- (CGFloat) windfortextString:(NSString*)str height:(CGFloat)height fontsize:(CGFloat)size{
    
    
    
    NSDictionary * dict = @{NSFontAttributeName:[UIFont systemFontOfSize:size]};
    CGRect rect  = [str boundingRectWithSize:CGSizeMake(MAXFLOAT, height) options:NSStringDrawingTruncatesLastVisibleLine|NSStringDrawingUsesFontLeading|NSStringDrawingUsesLineFragmentOrigin attributes:dict context:nil];
    
    return  rect.size.width+5;
}

- (void)setTextColor:(UILabel*)label frame:(CGRect)frame{
    UIColor *color = nil;
    UIImage * bfImage = [UIViewClassHandleTools shotWithView:_backgrounImage scope:frame];
    if(bfImage != nil)
    {
        color = [bfImage mostcolorWithimage:bfImage];
    }
    else{
        color = _backgrounImage.backgroundColor;
    }
    
    if([self isLightColor:color]){
          [label setTextColor:[UIColor blackColor]];
//          [self.scrollLabel setTextColor:[UIColor blackColor]];
//          [self.secondLabel setTextColor:[UIColor blackColor]];
    }
    else{
        [label setTextColor:[UIColor whiteColor]];
//        [self.scrollLabel setTextColor:[UIColor whiteColor]];
//        [self.secondLabel setTextColor:[UIColor whiteColor]];
    }
}



//判断颜色是不是亮色
-(BOOL) isLightColor:(UIColor*)clr {
    CGFloat components[3];
    [self getRGBComponents:components forColor:clr];
    NSLog(@"%f %f %f", components[0], components[1], components[2]);
    
    CGFloat num = components[0] + components[1] + components[2];
    if(num < 382)
        return NO;
    else
        return YES;
}



//获取RGB值
- (void)getRGBComponents:(CGFloat [3])components forColor:(UIColor *)color {
#if __IPHONE_OS_VERSION_MAX_ALLOWED > __IPHONE_6_1
    int bitmapInfo = kCGBitmapByteOrderDefault | kCGImageAlphaPremultipliedLast;
#else
    int bitmapInfo = kCGImageAlphaPremultipliedLast;
#endif
    
    CGColorSpaceRef rgbColorSpace = CGColorSpaceCreateDeviceRGB();
    unsigned char resultingPixel[4];
    CGContextRef context = CGBitmapContextCreate(&resultingPixel,
                                                 1,
                                                 1,
                                                 8,
                                                 4,
                                                 rgbColorSpace,
                                                 bitmapInfo);
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, CGRectMake(0, 0, 1, 1));
    CGContextRelease(context);
    CGColorSpaceRelease(rgbColorSpace);
    
    for (int component = 0; component < 3; component++) {
        components[component] = resultingPixel[component];
    }
}
@end
