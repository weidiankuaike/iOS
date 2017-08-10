//
//  CircularProgressBar.h
//  CircularProgressBar
//
//  Created by du on 10/8/15.
//  Copyright © 2015 du. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CircularProgressBar.h"
@protocol CircularProgressDelegate

- (void)CircularProgressEnd;
- (void)Gettime:(NSString *)timestring CircularProgressBar:(UIView*)Circul;

@end


@interface CircularProgressBar : UIView 
{
    CGFloat startAngle;
    CGFloat endAngle;
    
    UIFont *textFont;
    UIColor *textColor;
    NSMutableParagraphStyle *textStyle;
    bool b_timerRunning;
}

@property(nonatomic, assign) id<CircularProgressDelegate> delegate;
@property(nonatomic)CGFloat time_left;
@property(nonatomic,strong) NSTimer *m_timer;
@property (nonatomic,assign)     int     totalTime;
@property (nonatomic,strong)    NSString *textContent;


- (void)setTotalSecondTime:(CGFloat)time;
- (void)setTotalMinuteTime:(CGFloat)time;

- (void)startTimer;
- (void)stopTimer;
- (void)pauseTimer;

@end
