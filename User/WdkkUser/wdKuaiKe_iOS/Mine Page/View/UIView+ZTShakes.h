//
//  UIView+ZTShakes.h
//  微点筷客商户端
//
//  Created by Skyer God on 16/11/2.
//  Copyright © 2016年 张森森. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, ZTDirection) {
    ZTDirectionHorizontal,
    ZTDirectionVertical,
    ZTDirectionRotation
};
@interface UIView (ZTShakes)

- (void)shakeWithShakeDirection:(ZTDirection)shakeDirection;
- (void)shakeWithTimes:(NSInteger)times shakeDirection:(ZTDirection)shakeDirection;
- (void)shakeWithTimes:(NSInteger)times speed:(CGFloat)speed shakeDirection:(ZTDirection)shakeDirection;
- (void)shakeWithTimes:(NSInteger)times speed:(CGFloat)speed range:(CGFloat)range shakeDirection:(ZTDirection)shakeDirection;
- (void)pause;
- (void)resume:(CGFloat)speed;
@end
