//
//  UIButton+LimitClickTime.h
//  微点筷客商户端
//
//  Created by Skyer God on 2017/4/20.
//  Copyright © 2017年 张森森. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIButton (LimitClickTime)
/**
 *  为按钮添加点击间隔 eventTimeInterval秒
 */
@property (nonatomic, assign) NSTimeInterval eventTimeInterval;
@end
