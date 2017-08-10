//
//  UIView+Tool.m
//  wdKuaiKe_iOS
//
//  Created by 张森森 on 17/6/7.
//  Copyright © 2017年 weiDianKuaiKe. All rights reserved.
//

#import "UIView+Tool.h"

@implementation UIView (Tool)
// 通过响应者链条获取VIew所在的控制器
- (UIViewController *)parentController{
    
    UIResponder *responder = [self nextResponder];
    while (responder) {
        
        if ([responder isKindOfClass:[UIViewController class]]) {
            
            return (UIViewController *)responder;
        }
        responder = [responder nextResponder];
    }
    
    return nil;
}

@end
