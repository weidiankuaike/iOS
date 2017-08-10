//
//  UIView+ZTShakes.m
//  微点筷客商户端
//
//  Created by Skyer God on 16/11/2.
//  Copyright © 2016年 张森森. All rights reserved.
//

#import "UIView+ZTShakes.h"

@implementation UIView (ZTShakes)

-(void)shakeWithShakeDirection:(ZTDirection)shakeDirection{

    [self shakeWithTimes:10 speed:0.05 range:5 shakeDirection:shakeDirection];
}
- (void)shakeWithTimes:(NSInteger)times shakeDirection:(ZTDirection)shakeDirection{
    [self shakeWithTimes:times speed:0.05 range:5 shakeDirection:shakeDirection];
}
- (void)shakeWithTimes:(NSInteger)times speed:(CGFloat)speed shakeDirection:(ZTDirection)shakeDirection{
    [self shakeWithTimes:times speed:speed range:5 shakeDirection:shakeDirection];
}
-(void)shakeWithTimes:(NSInteger)times speed:(CGFloat)speed range:(CGFloat)range shakeDirection:(ZTDirection)shakeDirection{
    [self viewShakesWithTiems:times speed:speed range:range shakeDirection:shakeDirection currentTimes:0 direction:1];
}

/**
 *  @param times          震动的次数
 *  @param speed          震动的速度
 *  @param range          震动的幅度
 *  @param shakeDirection 哪个方向上的震动
 *  @param currentTimes   当前的震动次数
 *  @param direction      向哪边震动
 */

- (void)viewShakesWithTiems:(NSInteger)times speed:(CGFloat)speed range:(CGFloat)range shakeDirection:(ZTDirection)shakeDirection currentTimes:(NSInteger)currentTimes direction:(int)direction{

    [UIView animateWithDuration:speed animations:^{
        switch (shakeDirection) {
            case ZTDirectionHorizontal:
                self.transform = CGAffineTransformMakeTranslation(range * direction, 0);
                break;

            case ZTDirectionVertical:
                self.transform = CGAffineTransformMakeTranslation(0, range * direction);
                break;

            case ZTDirectionRotation:
//                self.transform = CGAffineTransformMakeTranslation(M_PI / 8, M_PI/4);
                [self shakeImage:range speed:speed];
//                [self resume];


                break;

            default:
                break;
        }
    } completion:^(BOOL finished) {
        if (currentTimes >= times) {
            [UIView animateWithDuration:speed animations:^{
                self.transform = CGAffineTransformIdentity;
            }];
            return;
        }
#pragma mark - 循环到times == currentTimes时候 会跳出该方法
        [self viewShakesWithTiems:times - 1
                            speed:speed
                            range:range
                   shakeDirection:shakeDirection
                     currentTimes:currentTimes + 1
                        direction:direction * -1];
    }];
    
    
}

- (void)shakeImage:(CGFloat)range speed:(CGFloat)speed {
    //创建动画对象,绕Z轴旋转
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];

    //设置属性，周期时长
    [animation setDuration:0.08];

    //抖动角度
    animation.fromValue = @(-M_1_PI/range);
    animation.toValue = @(M_1_PI/range);
    //重复次数，无限大
    animation.repeatCount = HUGE_VAL;
    //恢复原样
    animation.autoreverses = YES;
    //锚点设置为图片中心，绕中心抖动
    self.layer.anchorPoint = CGPointMake(0.5, 0.5);
    self.layer.speed = speed;

    [self.layer addAnimation:animation forKey:@"rotation"];
}
- (void)pause{
    self.layer.speed = 0.0;
    self.layer.autoreverses = YES;
}

- (void)resume:(CGFloat)speed{
    self.layer.speed = speed;
}

@end
