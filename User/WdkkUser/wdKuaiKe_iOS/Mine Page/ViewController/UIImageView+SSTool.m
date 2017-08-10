//
//  UIImageView+SSTool.m
//  wdKuaiKe_iOS
//
//  Created by 张森森 on 17/6/20.
//  Copyright © 2017年 weiDianKuaiKe. All rights reserved.
//

#import "UIImageView+SSTool.h"

@implementation UIImageView (SSTool)

- (void)setRoundedCornersSize:(CGFloat)cornersSize {
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds
                                                        cornerRadius:cornersSize];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = self.bounds;
    maskLayer.path = maskPath.CGPath;
    self.layer.mask = maskLayer;
}
@end
