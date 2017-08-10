//
//  AppDelegate.m
//  微点筷客商户端
//
//  Created by 张森森 on 16/9/30.
//  Copyright © 2016年 张森森. All rights reserved.
//
#define AmapKey @"e208e1e2c69db06b489974b1a1781c48"
#define XGappId 2200247863
#define XGappKey @"I7E689XCQ3TB"
#import "AppDelegate.h"
#import "ViewController.h"
#import <AMapSearchKit/AMapSearchKit.h>
#import <AMapFoundationKit/AMapFoundationKit.h>
#import <UserNotifications/UserNotifications.h>
#import <UserNotificationsUI/UserNotificationsUI.h>
#import "XGPush.h"
#import "XGSetting.h"

#import <arpa/inet.h>
#import <netinet/in.h>
#import <ifaddrs.h>
#include <Availability.h>
#include <sys/cdefs.h>
#include <SystemConfiguration/SystemConfiguration.h>
#import <NetworkExtension/NetworkExtension.h>
#import "DeviceSet.h"
#import "SceneViewController.h"
#import "ExceptionHandler.h"
#import <AVFoundation/AVFoundation.h>
#import <AudioToolbox/AudioToolbox.h>
@interface AppDelegate ()<UNUserNotificationCenterDelegate>

/** 判断通知模式   (NSInteger) **/
@property (nonatomic, assign) BOOL isBackgroundModel;
@end

@implementation AppDelegate{

}


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [self SVProgressSet];
    /* ＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊检测版本更新＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊*/
    [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        if ([AFStringFromNetworkReachabilityStatus(status) isEqualToString:@"Reachable via WiFi"]) {
            [[DeviceSet shareDevice] updateNewVersion];
        }
    }];

    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
    /* ＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊设置根视图控制器＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊*/
    self.window = [[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
    [self.window makeKeyAndVisible];
    ViewController *oneView = [[ViewController alloc]init];
    UINavigationController *navc = [[UINavigationController alloc]initWithRootViewController:oneView];
    self.window.rootViewController = navc;

    /* ＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊高德地图＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊*/
    //高德地图
    [AMapServices sharedServices].apiKey = AmapKey;
    /* ＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊信鸽推送＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊*/
    [XGPush startApp:XGappId appKey:XGappKey];
    [[XGSetting getInstance] enableDebug:YES];
    //收到远程推送，但是app未启动，此时launchOptions 为推送信息
    self.userInfoDic = launchOptions;

    [XGPush isPushOn:^(BOOL isPushOn) {
        ZTLog(@"[XGDemo] Push Is %@", isPushOn ? @"ON" : @"OFF");
    }];
    [self registerAPNS];
    //统计从推送打开的设备
    [XGPush handleLaunching:launchOptions successCallback:^{

    } errorCallback:^{

    }];
    /* ＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊Wi-Fi状态＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊*/
    [[DeviceSet shareDevice] getNetWorkStates];

    NSSetUncaughtExceptionHandler(&UncaughtExceptionHandler);
//        InstallUncaughtExceptionHandler();

    [self addObserver:self forKeyPath:@"userInfoDic" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil];
    return YES;
}
- (void)SVProgressSet{
//    [SVProgressHUD setMinimumDismissTimeInterval:1];
    [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
//    [SVProgressHUD setForegroundColor:[UIColor redColor]];

    [IQKeyboardManager sharedManager].toolbarDoneBarButtonItemText = @"完成";
}
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
    ZTLog(@"_userInfo:%@", _userInfoDic);

    if ([_userInfoDic[@"map"][@"classId"] isEqualToString:@"m0"] || [_userInfoDic[@"map"][@"classId"] isEqualToString:@"m1"]) {
        [self orderVoicePlay];
    }

    if (_userInfoDic!=nil) {
        if (_isBackgroundModel) {
            //
            _isBackgroundModel = NO;
        } else {
            [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
        }
        NSDictionary *oldDic = [change objectForKey:NSKeyValueChangeOldKey];
        NSDictionary *newDic = [change objectForKey:NSKeyValueChangeNewKey];
        if (![oldDic isNull] && ![newDic isNull] && [oldDic isEqualToDictionary:newDic]) {
            return ;
        }
        NSString *classId = _userInfoDic[@"map"][@"classId"];
        UITabBarController *tabC = (UITabBarController *)[[UIApplication sharedApplication].keyWindow.rootViewController.childViewControllers lastObject];
        if ([classId isEqualToString:@"m4"]) {
            if (tabC.selectedIndex != 1) {
                tabC.selectedIndex = 1;
                [self playSound];
            }
        } else {
            if (tabC.selectedIndex != 0) {
                tabC.selectedIndex = 0;
            }
        }
        if (_notificationUserInfoBlock) {
            _notificationUserInfoBlock(_userInfoDic);
        }
    }
}

- (void)orderVoicePlay{

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if ([_userInfoDic[@"map"][@"isArriveRmd"] integerValue] == 1 || [_userInfoDic[@"map"][@"isNewOrderRmd"] integerValue] == 1) {
            NSError *error = NULL;
            AVAudioSession *session = [AVAudioSession sharedInstance];
            [session setCategory:AVAudioSessionCategoryPlayback withOptions:AVAudioSessionCategoryOptionMixWithOthers | AVAudioSessionCategoryOptionDuckOthers error:&error];
            if(error) {

            }
            [session setActive:YES error:&error];
            if (error) {

            }
            AVSpeechSynthesizer *speechSyn = [[AVSpeechSynthesizer alloc] init];
            NSString *tempStr = @"微点筷客提示,您有一笔新订单";
            NSMutableArray *arr = [NSMutableArray array];
            if ([_userInfoDic[@"map"][@"classId"] isEqualToString:@"m1"]) {//用户取消订单
                tempStr = _userInfoDic[@"map"][@"userPhone"];
                tempStr = [tempStr substringFromIndex:tempStr.length - 4];
                for (NSInteger i = 0; i < tempStr.length; i++) {
                    [arr addObject:[NSString stringWithFormat:@"%@", [tempStr substringWithRange:NSMakeRange(i, 1)]]];
                }
                tempStr = [arr componentsJoinedByString:@" "];
                tempStr = [NSString stringWithFormat:@"手机尾号为:%@的订单,已被取消", tempStr];
            }
            AVSpeechUtterance *utterance = [[AVSpeechUtterance alloc] initWithString:tempStr];
            AVSpeechSynthesisVoice *voice = [AVSpeechSynthesisVoice voiceWithLanguage:@"zh-CN"];
            [utterance setVoice:voice];
            utterance.rate = 0.5;
            [speechSyn speakUtterance:utterance];
        }
    });
}
- (void)playSound{
    NSString *path = [[NSBundle mainBundle] pathForResource:@"scene" ofType:@"wav"];
    SystemSoundID soundId ;

    OSStatus error = AudioServicesCreateSystemSoundID((__bridge CFURLRef _Nonnull)([NSURL fileURLWithPath:path]), &soundId);
    if (error != kAudioServicesNoError) {
        //            NSLog(@"%d",(int)error);
    }


    AudioServicesPlaySystemSoundWithCompletion(soundId, ^{


    });
}
#if (__IPHONE_OS_VERSION_MAX_ALLOWED >= _IPHONE80_  && __IPHONE_OS_VERSION_MAX_ALLOWED < _IPHONE10_)
-(void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification{
    //notification是发送推送时传入的字典信息
    [XGPush localNotificationAtFrontEnd:notification userInfoKey:@"clockID" userInfoValue:@"myid"];

    //删除推送列表中的这一条
    [XGPush delLocalNotification:notification];
    //[XGPush delLocalNotification:@"clockID" userInfoValue:@"myid"];

    //清空推送列表
    //[XGPush clearLocalNotifications];
}
//注册UserNotification成功的回调
- (void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings
{
    //用户已经允许接收以下类型的推送
    //UIUserNotificationType allowedTypes = [notificationSettings types];

}

//按钮点击事件回调
- (void)application:(UIApplication *)application handleActionWithIdentifier:(NSString *)identifier forRemoteNotification:(NSDictionary *)userInfo completionHandler:(void (^)())completionHandler{
    if([identifier isEqualToString:@"ACCEPT_IDENTIFIER"]){
        //        ZTLog(@"ACCEPT_IDENTIFIER is clicked");
    }
    completionHandler();
}
#endif
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {


    NSString *deviceTokenStr = [XGPush registerDevice:deviceToken account:nil successCallback:^{
        //        ZTLog(@"[XGDemo] register push success");
    } errorCallback:^{
        //        ZTLog(@"[XGDemo] register push error");
    }];
    ZTLog(@"[XGDemo] device token is %@", deviceTokenStr);

    [DeviceSet saveKeychainValue:deviceTokenStr key:@"deviceToken"];

    ZTLog(@"[XGPush Demo] deviceTokenStr is %@",deviceTokenStr);
}

//如果deviceToken获取不到会进入此事件
- (void)application:(UIApplication *)app didFailToRegisterForRemoteNotificationsWithError:(NSError *)err {

    //    NSString *str = [NSString stringWithFormat: @"Error: %@",err];

    //    ZTLog(@"[XGPush Demo]%@",str);

}
/**
 收到通知的回调

 @param application  UIApplication 实例
 @param userInfo 推送时指定的参数
 */
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    //    ZTLog(@"[XGDemo] receive Notification");
    self.userInfoDic = userInfo;
    [XGPush handleReceiveNotification:userInfo
                      successCallback:^{
                          //                          ZTLog(@"[XGDemo] Handle receive success");
                      } errorCallback:^{
                          //                          ZTLog(@"[XGDemo] Handle receive error");
                      }];
}
/**
 收到静默推送的回调
 9.0 都走这个
 @param application  UIApplication 实例
 @param userInfo 推送时指定的参数
 @param completionHandler 完成回调
 */
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    //    ZTLog(@"[XGDemo] receive slient Notification");
    //    ZTLog(@"[XGDemo] userinfo %@", userInfo);
    _isBackgroundModel = YES;
    completionHandler(UIBackgroundFetchResultNewData);
    [XGPush handleReceiveNotification:userInfo
                      successCallback:^{
                          self.userInfoDic = userInfo;
                          //                          ZTLog(@"[XGDemo] Handle receive success");
                      } errorCallback:^{
                          //                          ZTLog(@"[XGDemo] Handle receive error");
                      }];
    //    if ([userInfo[@"map"][@"classId"] isEqualToString:@"m0"] || [userInfo[@"map"][@"classId"] isEqualToString:@"m1"]) {
    //        [self orderVoicePlay];
    //    }

}

// iOS 10 新增 API
// iOS 10 会走新 API, iOS 10 以前会走到老 API
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_10_0
// App 用户点击通知的回调
// 无论本地推送还是远程推送都会走这个回调
/*
 这个方法当接收到通知后，用户点击通知激活app时被调用，无论前台还是后台
 */
- (void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void(^)())completionHandler {
    //    ZTLog(@"[XGDemo] click notification");

    [XGPush handleReceiveNotification:response.notification.request.content.userInfo
                      successCallback:^{
                          self.userInfoDic = response.notification.request.content.userInfo;
                          //                          ZTLog(@"[XGDemo] Handle receive success");
                          [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
                      } errorCallback:^{
                          //                          ZTLog(@"[XGDemo] Handle receive error");
                      }];
    completionHandler();
}

// App 在前台弹通知需要调用这个接口
- (void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions options))completionHandler {

    completionHandler(UNNotificationPresentationOptionBadge | UNNotificationPresentationOptionSound | UNNotificationPresentationOptionAlert);
    //判断是否是新订单
    //    if ([notification.request.content.userInfo[@"map"][@"classId"] isEqualToString:@"m0"]) {
    //        [self orderVoicePlay];
    //    }
    self.userInfoDic = notification.request.content.userInfo;
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
}
#endif
- (void)registerAPNS {
    float sysVer = [[[UIDevice currentDevice] systemVersion] floatValue];
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_10_0
    if (sysVer >= 10) {
        // iOS 10
        [self registerPush10];
    } else if (sysVer >= 8) {
        //iOS 8-9
        [self registerPush8to9];
    } else {
        // before iOS 8
        [self registerPushBefore8];
    }
#else
    if (sysVer < 8) {
        // before iOS 8
        [self registerPushBefore8];
    } else {
        // iOS 8-9
        [self registerPush8to9];
    }
#endif
}

- (void)registerPush10{
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_10_0
    UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
    center.delegate = self;

    [center requestAuthorizationWithOptions:UNAuthorizationOptionBadge | UNAuthorizationOptionSound | UNAuthorizationOptionAlert completionHandler:^(BOOL granted, NSError * _Nullable error) {
        if (granted) {
        }
    }];
    [[UIApplication sharedApplication] registerForRemoteNotifications];
#endif
}
- (void)registerPush8to9{

    UIUserNotificationType types = UIUserNotificationTypeBadge | UIUserNotificationTypeSound | UIUserNotificationTypeAlert;
    UIUserNotificationSettings *mySettings = [UIUserNotificationSettings settingsForTypes:types categories:nil];
    [[UIApplication sharedApplication] registerUserNotificationSettings:mySettings];
    [[UIApplication sharedApplication] registerForRemoteNotifications];

}

- (void)registerPushBefore8{

    [[UIApplication sharedApplication] registerForRemoteNotificationTypes:(UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound)];

}

void UncaughtExceptionHandler(NSException *exception) {
    /**
     *  获取异常崩溃信息
     */
    NSUserDefaults *userDefaut = [NSUserDefaults standardUserDefaults];
    [userDefaut setObject:@"error" forKey:@"token"];
    [userDefaut setObject:@"error" forKey:LocationLoginInResultsKey];

    NSArray *callStack = [exception callStackSymbols];
    NSString *reason = [exception reason];
    NSString *name = [exception name];
    NSString *content = [NSString stringWithFormat:@"========异常错误报告========\nname:%@\nreason:\n%@\ncallStackSymbols:\n%@",name,reason,[callStack componentsJoinedByString:@"\n"]];

    /**
     *  把异常崩溃信息发送至开发者邮件
     */
    NSMutableString *mailUrl = [NSMutableString string];
    [mailUrl appendString:@"mailto:18042691912@163.com"];
    [mailUrl appendString:@"?subject=程序异常崩溃，请配合发送异常报告，谢谢合作！"];
    [mailUrl appendFormat:@"&body=%@", content];


    // 打开地址
    NSString *mailPath = [mailUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:mailPath] options:@{} completionHandler:^(BOOL success) {
        if (success) {
//                exit(0);
        }
    }];

}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.

    UIApplication*   app = [UIApplication sharedApplication];
    __block    UIBackgroundTaskIdentifier bgTask;
    bgTask = [app beginBackgroundTaskWithExpirationHandler:^{
        dispatch_async(dispatch_get_main_queue(), ^{
            if (bgTask != UIBackgroundTaskInvalid) {
                bgTask = UIBackgroundTaskInvalid;
            }
        });
    }];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            if (bgTask != UIBackgroundTaskInvalid)
            {
                bgTask = UIBackgroundTaskInvalid;
            }
        });
    });
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.

}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
}

- (void)applicationWillTerminate:(UIApplication *)application {
    [ReloadVIew clearReloadViewSuperClass];
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
