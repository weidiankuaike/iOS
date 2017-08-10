//
//  AppDelegate.h
//  微点筷客商户端
//
//  Created by 张森森 on 16/9/30.
//  Copyright © 2016年 张森森. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;


/** 保存通知信息   (strong) **/
@property (nonatomic, strong) NSDictionary *userInfoDic;
/** <#行注释#>   (strong) **/
@property (nonatomic, strong) void (^notificationUserInfoBlock)(NSDictionary *userInfo);
@end

