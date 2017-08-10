//
//  MyTableBar.m
//  wdKuaiKe_iOS
//
//  Created by Skyer God on 16/8/22.
//  Copyright © 2016年 weiDianKuaiKe. All rights reserved.
//

#import "MyTableBar.h"
#import "QRViewController.h"
#import "LoginViewController.h"
#import <AVFoundation/AVCaptureDevice.h>
#import <AVFoundation/AVMediaFormat.h>
@implementation MyTableBar
-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self createMiddelBarItem];
    }
    return self;
}
- (void)createMiddelBarItem{
    
    _midBarButtonItem = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [_midBarButtonItem setBackgroundImage:[UIImage imageNamed:@"扫码"] forState:UIControlStateNormal];
    _midBarButtonItem.showsTouchWhenHighlighted = YES;
    
    _midBarButtonItem.tag = 2000;
    [_midBarButtonItem addTarget:self action:@selector(midButtonAction) forControlEvents:UIControlEventTouchUpInside];
    self.backgroundColor = [UIColor whiteColor];

    [self addSubview:_midBarButtonItem];
    
}

- (void)midButtonAction{
    
    UIWindow * window = [UIApplication sharedApplication].keyWindow;
    UITabBarController *tabContro = (UITabBarController *)window.rootViewController;
    UINavigationController * nav =(UINavigationController *)[tabContro.viewControllers objectAtIndex:tabContro.selectedIndex];
    
    AVAuthorizationStatus authstatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    
    if (authstatus == AVAuthorizationStatusDenied) {
        
        UIAlertController * alertView = [UIAlertController alertControllerWithTitle:nil message:@"您未开启相机权限，是否开启" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction * cancelAction = [UIAlertAction actionWithTitle:@"偏不" style:UIAlertActionStyleCancel handler:nil];
        UIAlertAction * okAction = [UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            NSURL * url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
            
            if([[UIApplication sharedApplication] canOpenURL:url]) {
                
                NSURL*url =[NSURL URLWithString:UIApplicationOpenSettingsURLString];           [[UIApplication sharedApplication] openURL:url];
                
            }
            
        }];
        
        [alertView addAction:cancelAction];
        [alertView addAction:okAction];
        
        [nav.viewControllers.firstObject presentViewController:alertView animated:YES completion:nil];

        
    }
    else{
        if ([[NSUserDefaults standardUserDefaults]objectForKey:@"token"]==nil) {
            
            LoginViewController * loginView = [[LoginViewController alloc]init];
            [nav pushViewController:loginView animated:YES];
        }
        else{
            
            QRViewController * qrview = [[QRViewController alloc]init];
            
            qrview.orderid = @"";
            qrview.pushint = 1;
            qrview.operation = @"1";
            [nav pushViewController:qrview animated:YES];
    }

 }
    
}

-(void)layoutSubviews{
    [super layoutSubviews];
    
    self.midBarButtonItem.bounds = CGRectMake(0, 0, self.midBarButtonItem.currentBackgroundImage.size.width * 1.6, self.midBarButtonItem.currentBackgroundImage.size.height * 1.6);
    self.midBarButtonItem.center = CGPointMake(self.frame.size.width * 0.5, self.frame.size.height * 0.2);
    [_midBarButtonItem imageRectForContentRect:_midBarButtonItem.frame];
    
    _midBarButtonItem.layer.cornerRadius = _midBarButtonItem.frame.size.height / 8;
    
    _midBarButtonItem.layer.masksToBounds = YES;
    
    CGFloat buttonY = 0;
    CGFloat buttonW = self.frame.size.width / 3;
    CGFloat buttonH = self.frame.size.height;
    NSInteger index = 0;
    
    for (UIView *button in self.subviews) {
        if (![button isKindOfClass:[UIControl class]] || button == self.midBarButtonItem) continue;
        
        CGFloat buttonX = buttonW * ((index == 1) ? (index + 1):index);
        button.frame = CGRectMake(buttonX, buttonY, buttonW, buttonH);
        
        index++;
    }
}
- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event
{
    
    UIView *hitView = nil;
    //NSLog(@"point:%@", NSStringFromCGPoint(point));
    UIButton *roundBtn = (UIButton *)[self viewWithTag:2000];
    UIControl *leftBtn = (UIControl *)[self.subviews objectAtIndex:2];
    UIControl *rightBtn = (UIControl *)[self.subviews objectAtIndex:3];
    BOOL pointInRound = [self touchPointInsideCircle:roundBtn.center radius:30 targetPoint:point];
    if (pointInRound&&!self.isHidden) {
        hitView = roundBtn;
    } else if(CGRectContainsPoint(CGRectMake(0, 0, self.width / 3, self.height), point)&&!self.isHidden) {
        hitView  = leftBtn;
    } else if(CGRectContainsPoint(CGRectMake(self.width / 3 * 2, 0, self.width / 3, self.height), point)&&!self.isHidden) {
        hitView = rightBtn;
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

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
