//
//  MBProgress+GodSkyer.h
//  微点筷客商户端
//
//  Created by Skyer God on 16/12/21.
//  Copyright © 2016年 张森森. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MBProgress_GodSkyer : NSObject
+(MBProgress_GodSkyer *)shareManager;

- (void)showSimple:(UIView *)parentView;
- (void)showWithLabelWithMessage:(NSString *)message inView:(UIView *)parentView;
- (void)showWithDetailsLabelMessage:(NSString *)message detailMessage:(NSString *)detailMsg inView:(UIView *)parentView;
- (void)showWithLabelDeterminate:(NSString *)message inView:(UIView *)parentView;
- (void)showWIthLabelAnnularDeterminate:(UIView *)parentView;
- (void)showWithLabelDeterminateHorizontalBarWithProgress:(CGFloat )progress inView:(UIView *)parentView;
- (void)showWithCustomView:(NSString *)message inView:(UIView *)parentView;
- (void)showWithLabelMixed:(UIView *)parentView;
- (void)showUsingBlocks:(UIView *)parentView;
- (void)showOnWindow:(UIView *)parentView;
- (void)showURL:(UIView *)parentView;

- (void)myTask;
- (void)myProgressTask;
- (void)myMixedTask;
- (void)hiddenHUD;

@end
