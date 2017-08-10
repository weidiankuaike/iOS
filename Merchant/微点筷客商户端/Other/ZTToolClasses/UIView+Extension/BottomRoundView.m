//
//  BottomRoundView.m
//  tabbar
//
//  Created by Skyer God on 2017/5/4.
//  Copyright © 2017年 weiDianKuaiKe. All rights reserved.
//

#import "BottomRoundView.h"
#define  buttonWidth  55
#define SelfDefaultFrame CGRectMake(0, [[UIScreen mainScreen] bounds].size.height - 64, [[UIScreen mainScreen] bounds].size.width, 64)
#define MiddelDefaultPadding [[UIScreen mainScreen] bounds].size.width - (buttonWidth / 2)
@implementation BottomRoundView{
    ButtonStyle *button;
}

- (instancetype)initWithFrame:(CGRect)frame middleIcon:(NSString *)imageIcon
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];

        button = [ButtonStyle buttonWithType:UIButtonTypeCustom];
        [button setBackgroundImage:[UIImage imageNamed:imageIcon] forState:UIControlStateNormal];
        button.backgroundColor = [UIColor whiteColor];

        button.frame = CGRectMake(self.frame.size.width / 2 - buttonWidth / 2, -buttonWidth / 2, buttonWidth, buttonWidth);
        [self addSubview:button];
        [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        button.layer.cornerRadius = buttonWidth / 2;
        button.clipsToBounds = YES;

        CAGradientLayer *gradientLayer = [CAGradientLayer layer];
        gradientLayer.colors = @[(__bridge id)RGB(238, 238, 238).CGColor, (__bridge id)RGB(238, 238, 238).CGColor, (__bridge id)RGB(238, 238, 238).CGColor];
        gradientLayer.locations = @[@0.3, @0.5, @1.0];
        gradientLayer.startPoint = CGPointMake(0, 0);
        gradientLayer.endPoint = CGPointMake(1.0, 0);
        gradientLayer.frame = CGRectMake(0, 0, self.frame.size.width / 2 - buttonWidth / 2, 1.5);
        [self.layer addSublayer:gradientLayer];
        CAGradientLayer *secGradientLayer = [CAGradientLayer layer];
//        secGradientLayer.colors = @[(__bridge id)[UIColor blueColor].CGColor, (__bridge id)[UIColor yellowColor].CGColor, (__bridge id)[UIColor redColor].CGColor];
        secGradientLayer.colors = @[(__bridge id)RGB(238, 238, 238).CGColor, (__bridge id)RGB(238, 238, 238).CGColor, (__bridge id)RGB(238, 238, 238).CGColor];
        secGradientLayer.locations = @[@0.3, @0.5, @1.0];
        secGradientLayer.startPoint = CGPointMake(0, 0);
        secGradientLayer.endPoint = CGPointMake(1.0, 0);
        secGradientLayer.frame = CGRectMake(self.frame.size.width / 2 + buttonWidth / 2, 0, self.frame.size.width / 2 - buttonWidth / 2, 1.5);
        [self.layer addSublayer:secGradientLayer];
    }
    return self;
}
- (void)buttonClick:(ButtonStyle *)sender{
    if (_middleButtonClick) {
        _middleButtonClick(sender);
    }
}
- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event
{
    UIView *hitView = nil;
    //NSLog(@"point:%@", NSStringFromCGPoint(point));
    ButtonStyle *roundBtn = button;
    BOOL pointInRound = [self touchPointInsideCircle:roundBtn.center radius:30 targetPoint:point];
    if (pointInRound && !self.isHidden) {
        hitView = roundBtn;
    } else {
        hitView = nil;
    }
    return hitView;
}
- (BOOL)touchPointInsideCircle:(CGPoint)center radius:(CGFloat)radius targetPoint:(CGPoint)point
{
    CGFloat dist = sqrtf((point.x - center.x) * (point.x - center.x) +
                         (point.y - center.y) * (point.y - center.y));
    return (dist <= radius);
}
@end
