//
//  AppDelegate.h
//  wdKuaiKe_iOS
//
//  Created by Skyer God on 16/8/3.
//  Copyright © 2016年 weiDianKuaiKe. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

- (CGFloat)autoScaleW:(CGFloat)w;

- (CGFloat)autoScaleH:(CGFloat)h;
/** 保存通知信息   (strong) **/
@property (nonatomic, strong) NSDictionary *userInfoDic;
/** <#行注释#>   (strong) **/
@property (nonatomic, strong) void (^notificationUserInfoBlock)(NSDictionary *userInfo) ;

- (NSString *)getIPAddress:(BOOL)preferIPv4;
-(void)showWindowHome:(NSString *)windowType;
@end

