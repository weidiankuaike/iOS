//
//  AppDelegate.m
//  wdKuaiKe_iOS
//
//  Created by Skyer God on 16/8/3.
//  Copyright © 2016年 weiDianKuaiKe. All rights reserved.
//
#define kSinaAppKey         @"2429283099"//

#define APPSTOREID @"1226927553"

#import "AppDelegate.h"
#import <TencentOpenAPI/TencentOAuth.h>
#import "MyTableBar.h"
#import  "WeiboSDK.h"

#import "WTThirdPartyLoginManager.h"

#import "WXApi.h"
#import "YindaoView.h"
#import "sys/utsname.h"
#define WeiboKeyId @"2429283099"
#define kRedirectURI @"http://open.weibo.com/apps/2429283099/privilege/oauth"
#define GUIDE @"/guide"

#define AmapKey @"7b20f4e6757f71d684971496bacc4b2c"

#import <AMapFoundationKit/AMapFoundationKit.h>
#import <AMapLocationKit/AMapLocationKit.h>
#import "LoginViewController.h"
#import <AlipaySDK/AlipaySDK.h>
#import "XGPush.h"
#import "XGSetting.h"
#import <UserNotifications/UserNotifications.h>
#import <UserNotificationsUI/UserNotificationsUI.h>
#import "DeviceSet.h"
#import "QRViewController.h"
#import "MBProgressHUD+SS.h"
#import "UIView+Tool.h"
#import "OrderdetailViewController.h"
//获取ip
#import <ifaddrs.h>
#import <arpa/inet.h>
#import <net/if.h>
#define IOS_CELLULAR    @"pdp_ip0"

#define IOS_WIFI        @"en0"

#define IOS_VPN         @"utun0"

#define IP_ADDR_IPv4    @"ipv4"

#define IP_ADDR_IPv6    @"ipv6"
@interface AppDelegate ()<UITabBarControllerDelegate, UITabBarDelegate,UNUserNotificationCenterDelegate,MytabBarDelegate>

@property (nonatomic, retain) UITabBarController *tabController;

//设置中间middleItem
@property (nonatomic, retain) UITabBarItem *middleItem;
//当前屏幕与设计尺寸(iPhone6)宽度比例
@property (nonatomic, assign)CGFloat autoSizeScaleW;

//当前屏幕与设计尺寸(iPhone6)高度比例
@property (nonatomic, assign)CGFloat autoSizeScaleH;
@property (nonatomic, retain)UINavigationController*navigation;
//@property (nonatomic,retain)MyTableBar * myTabBar;
//UINavigationController *navigationController
@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.

    [AMapServices sharedServices].apiKey = AmapKey;


    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    
    self.window.backgroundColor = [UIColor whiteColor];
    
    //初始化tabbarcontroller
    [self initWithTabBarController];
    [self initAutoScaleSize];

    [NSThread sleepForTimeInterval:1];
    [self.window makeKeyAndVisible];
    
    
    //baidu---
  //检测跟新
    [self updateApp];

    //注册微信支付
    [WXApi registerApp:@"wx456660a0c14036a6"];
//信鸽初始化
    [XGPush startApp:XGappid appKey:XGAppkey];
    [[XGSetting getInstance] enableDebug:YES];
    [self registerAPNS];
    [XGPush isPushOn:^(BOOL isPushOn) {
        if (isPushOn==YES) {
            
        }
    }];
//    [self registerXgPushAccount];
    //统计从推送打开的设备
    [XGPush handleLaunching:launchOptions successCallback:^{
        
    } errorCallback:^{
        
    }];
    
    [self addObserver:self forKeyPath:@"userInfoDic" options:NSKeyValueObservingOptionOld | NSKeyValueObservingOptionNew context:nil];
// uuid
    NSString *identifier = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
// 系统版本
  NSString *systemVersion = [UIDevice currentDevice].systemVersion;
//型号
    NSString * devicexinghao = [self getDeviceName];
    
    [DeviceSet saveKeychainValue:identifier key:@"UUID"];
    NSUserDefaults * userdef = [NSUserDefaults standardUserDefaults];
    [userdef setObject:identifier forKey:@"uuid"];
    [userdef setObject:systemVersion forKey:@"xtbb"];
    [userdef setObject:devicexinghao forKey:@"xinghao"];
    [userdef synchronize];

    return YES;
}
- (void)postpush{
    
    [[NSNotificationCenter defaultCenter]postNotificationName:@"xgpush" object:nil];
    
    
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
    
        if (_notificationUserInfoBlock) {
            _notificationUserInfoBlock(_userInfoDic);
        }
    
}
//#if (__IPHONE_OS_VERSION_MAX_ALLOWED >= _IPHONE80_  && __IPHONE_OS_VERSION_MAX_ALLOWED < _IPHONE10_)
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
    }
    completionHandler();
}
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    
    NSString *deviceTokenStr = [XGPush registerDevice:deviceToken account:nil successCallback:^{
    } errorCallback:^{
    }];
    
    [DeviceSet saveKeychainValue:deviceTokenStr key:@"deviceToken"];

    
}

//如果deviceToken获取不到会进入此事件
- (void)application:(UIApplication *)app didFailToRegisterForRemoteNotificationsWithError:(NSError *)err {
    
    NSString *str = [NSString stringWithFormat: @"Error: %@",err];
    
    
}

/**
 收到通知的回调
 
 @param application  UIApplication 实例
 @param userInfo 推送时指定的参数
 */
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    [XGPush handleReceiveNotification:userInfo
                      successCallback:^{
                          [self postpush];
                          
                      } errorCallback:^{
                      }];
}
/**
 收到静默推送的回调
 
 @param application  UIApplication 实例
 @param userInfo 推送时指定的参数
 @param completionHandler 完成回调
 */
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    
    [XGPush handleReceiveNotification:userInfo
                      successCallback:^{
                          [self postpush];
                      } errorCallback:^{
                      }];
    
    completionHandler(UIBackgroundFetchResultNewData);
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
    [XGPush handleReceiveNotification:response.notification.request.content.userInfo
                      successCallback:^{
                          
                          NSDictionary * userinfoDict  = response.notification.request.content.userInfo;
                          if ([userinfoDict[@"map"][@"classId"] isEqualToString:@"u2"]) {
                              
                              OrderdetailViewController * orderdetailView = [[OrderdetailViewController alloc]init];
                              orderdetailView.orderId = userinfoDict[@"map"][@"orderId"];
                              [[self currentViewcontroler].navigationController pushViewController:orderdetailView animated:YES];
                              
                          }
                          else{
                          [self postpush];
                          }
                          [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
                      } errorCallback:^{
                      }];
    completionHandler();
}

// App 在前台弹通知需要调用这个接口
- (void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions options))completionHandler {
    
    completionHandler(UNNotificationPresentationOptionBadge | UNNotificationPresentationOptionSound | UNNotificationPresentationOptionAlert);
    self.userInfoDic = notification.request.content.userInfo;
//    [self postpush];
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
}
//- (void)

#endif
- (void)registerAPNS {
    float sysVer = [[[UIDevice currentDevice] systemVersion] floatValue];
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_10_0
    if (sysVer >= 10) {
        // iOS 10
        [self registerPush10];
    } else if (sysVer >= 8) {
        // iOS 8-9
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
#if (__IPHONE_OS_VERSION_MAX_ALLOWED >= _IPHONE80_  && __IPHONE_OS_VERSION_MAX_ALLOWED < _IPHONE10_)
    UIUserNotificationType types = UIUserNotificationTypeBadge | UIUserNotificationTypeSound | UIUserNotificationTypeAlert;
    UIUserNotificationSettings *mySettings = [UIUserNotificationSettings settingsForTypes:types categories:nil];
    [[UIApplication sharedApplication] registerUserNotificationSettings:mySettings];
    [[UIApplication sharedApplication] registerForRemoteNotifications];
#endif
}


- (void)registerPushBefore8{
#if __IPHONE_OS_VERSION_MAX_ALLOWED <= _IPHONE80_
    [[UIApplication sharedApplication] registerForRemoteNotificationTypes:(UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound)];
#endif
}
- (void)registerRemoteNotificationForIOS10{
    [[UNUserNotificationCenter currentNotificationCenter] requestAuthorizationWithOptions:UNAuthorizationOptionBadge | UNAuthorizationOptionSound | UNAuthorizationOptionAlert completionHandler:^(BOOL granted, NSError * _Nullable error) {
        
        if (granted) {
            [UNUserNotificationCenter currentNotificationCenter].delegate = self;
        }
    }];
    
    //通知内容类
    UNMutableNotificationContent *content = [UNMutableNotificationContent new];
    //设置通知请求发送时，app图标上显示的数字
    content.badge = @2;
    //通知内容
    content.body = @"普通通知内容";
    //默认的提示音
    content.sound = [UNNotificationSound defaultSound];
    //通知的副标题
    content.subtitle = @"通知副标题";
    //通知标题
    content.title = @"正标题";
    //设置从通知激活app时的launchImage图片
    content.launchImageName = @"q1";
    //设置5s后执行
    UNTimeIntervalNotificationTrigger * trigger = [UNTimeIntervalNotificationTrigger triggerWithTimeInterval:5.0f repeats:NO];
    UNNotificationRequest *requset = [UNNotificationRequest requestWithIdentifier:@"XGNotification" content:content trigger:trigger];
    [[UNUserNotificationCenter currentNotificationCenter] addNotificationRequest:requset withCompletionHandler:nil];
    
    [[UIApplication sharedApplication] registerForRemoteNotifications];
    
}
- (void)registerUNAuthorNotifacation{
    
    [[UNUserNotificationCenter currentNotificationCenter] requestAuthorizationWithOptions:UNAuthorizationOptionAlert | UNAuthorizationOptionBadge | UNAuthorizationOptionSound | UNAuthorizationOptionCarPlay completionHandler:^(BOOL granted, NSError * _Nullable error) {
        if (granted) {
            //如果用户权限申请成功，设置通知中心的代理
            [UNUserNotificationCenter currentNotificationCenter].delegate = self;
        }
    }];
    
    //通知内容类
    UNMutableNotificationContent *content = [UNMutableNotificationContent new];
    //设置通知请求发送时，app图标上显示的数字
    content.badge = @2;
    //通知内容
    content.body = @"普通通知内容";
    //默认的提示音
    content.sound = [UNNotificationSound defaultSound];
    //通知的副标题
    content.subtitle = @"通知副标题";
    //通知标题
    content.title = @"正标题";
    //设置从通知激活app时的launchImage图片
    content.launchImageName = @"q1";
    //设置5s后执行
    UNTimeIntervalNotificationTrigger * trigger = [UNTimeIntervalNotificationTrigger triggerWithTimeInterval:5.0f repeats:NO];
    UNNotificationRequest *request = [UNNotificationRequest requestWithIdentifier:@"NotificationDefault" content:content trigger:trigger];
    //添加通知请求
    [[UNUserNotificationCenter currentNotificationCenter] addNotificationRequest:request withCompletionHandler:^(NSError * _Nullable error) {
        
    }];
}

//- (void)registerXgPushAccount{
//    
//    NSString *account = [NSString stringWithFormat:@"u%@",Userid];
//    [XGPush setAccount:account successCallback:^{
//        
//        NSLog(@"HOMEVC---SUCCESS--%@", account);
//        
//    } errorCallback:^{
//        NSLog(@"HOMEVC---ERROR--%@", account);
//        
//    }];
//}

//获取 设备信息
- (NSString *)getDeviceName
{
    // 需要#import "sys/utsname.h"
   struct utsname systemInfo;
    uname(&systemInfo);
    NSString *deviceString = [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
    
    if ([deviceString isEqualToString:@"iPhone3,1"])    return @"iPhone 4";
    if ([deviceString isEqualToString:@"iPhone3,2"])    return @"iPhone 4";
    if ([deviceString isEqualToString:@"iPhone3,3"])    return @"iPhone 4";
    if ([deviceString isEqualToString:@"iPhone4,1"])    return @"iPhone 4S";
    if ([deviceString isEqualToString:@"iPhone5,1"])    return @"iPhone 5";
    if ([deviceString isEqualToString:@"iPhone5,2"])    return @"iPhone 5 (GSM+CDMA)";
    if ([deviceString isEqualToString:@"iPhone5,3"])    return @"iPhone 5c (GSM)";
    if ([deviceString isEqualToString:@"iPhone5,4"])    return @"iPhone 5c (GSM+CDMA)";
    if ([deviceString isEqualToString:@"iPhone6,1"])    return @"iPhone 5s (GSM)";
    if ([deviceString isEqualToString:@"iPhone6,2"])    return @"iPhone 5s (GSM+CDMA)";
    if ([deviceString isEqualToString:@"iPhone7,1"])    return @"iPhone 6 Plus";
    if ([deviceString isEqualToString:@"iPhone7,2"])    return @"iPhone 6";
    if ([deviceString isEqualToString:@"iPhone8,1"])    return @"iPhone 6s";
    if ([deviceString isEqualToString:@"iPhone8,2"])    return @"iPhone 6s Plus";
    if ([deviceString isEqualToString:@"iPhone8,4"])    return @"iPhone SE";
    
    if ([deviceString isEqualToString:@"iPod1,1"])      return @"iPod Touch 1G";
    if ([deviceString isEqualToString:@"iPod2,1"])      return @"iPod Touch 2G";
    if ([deviceString isEqualToString:@"iPod3,1"])      return @"iPod Touch 3G";
    if ([deviceString isEqualToString:@"iPod4,1"])      return @"iPod Touch 4G";
    if ([deviceString isEqualToString:@"iPod5,1"])      return @"iPod Touch (5 Gen)";
    
    if ([deviceString isEqualToString:@"iPad1,1"])      return @"iPad";
    if ([deviceString isEqualToString:@"iPad1,2"])      return @"iPad 3G";
    if ([deviceString isEqualToString:@"iPad2,1"])      return @"iPad 2 (WiFi)";
    if ([deviceString isEqualToString:@"iPad2,2"])      return @"iPad 2";
    if ([deviceString isEqualToString:@"iPad2,3"])      return @"iPad 2 (CDMA)";
    if ([deviceString isEqualToString:@"iPad2,4"])      return @"iPad 2";
    if ([deviceString isEqualToString:@"iPad2,5"])      return @"iPad Mini (WiFi)";
    if ([deviceString isEqualToString:@"iPad2,6"])      return @"iPad Mini";
    if ([deviceString isEqualToString:@"iPad2,7"])      return @"iPad Mini (GSM+CDMA)";
    if ([deviceString isEqualToString:@"iPad3,1"])      return @"iPad 3 (WiFi)";
    if ([deviceString isEqualToString:@"iPad3,2"])      return @"iPad 3 (GSM+CDMA)";
    if ([deviceString isEqualToString:@"iPad3,3"])      return @"iPad 3";
    if ([deviceString isEqualToString:@"iPad3,4"])      return @"iPad 4 (WiFi)";
    if ([deviceString isEqualToString:@"iPad3,5"])      return @"iPad 4";
    if ([deviceString isEqualToString:@"iPad3,6"])      return @"iPad 4 (GSM+CDMA)";
    if ([deviceString isEqualToString:@"iPad4,1"])      return @"iPad Air (WiFi)";
    if ([deviceString isEqualToString:@"iPad4,2"])      return @"iPad Air (Cellular)";
    if ([deviceString isEqualToString:@"iPad4,4"])      return @"iPad Mini 2 (WiFi)";
    if ([deviceString isEqualToString:@"iPad4,5"])      return @"iPad Mini 2 (Cellular)";
    if ([deviceString isEqualToString:@"iPad4,6"])      return @"iPad Mini 2";
    if ([deviceString isEqualToString:@"iPad4,7"])      return @"iPad Mini 3";
    if ([deviceString isEqualToString:@"iPad4,8"])      return @"iPad Mini 3";
    if ([deviceString isEqualToString:@"iPad4,9"])      return @"iPad Mini 3";
    if ([deviceString isEqualToString:@"iPad5,1"])      return @"iPad Mini 4 (WiFi)";
    if ([deviceString isEqualToString:@"iPad5,2"])      return @"iPad Mini 4 (LTE)";
    if ([deviceString isEqualToString:@"iPad5,3"])      return @"iPad Air 2";
    if ([deviceString isEqualToString:@"iPad5,4"])      return @"iPad Air 2";
    if ([deviceString isEqualToString:@"iPad6,3"])      return @"iPad Pro 9.7";
    if ([deviceString isEqualToString:@"iPad6,4"])      return @"iPad Pro 9.7";
    if ([deviceString isEqualToString:@"iPad6,7"])      return @"iPad Pro 12.9";
    if ([deviceString isEqualToString:@"iPad6,8"])      return @"iPad Pro 12.9";
    
    if ([deviceString isEqualToString:@"i386"])         return @"Simulator";
    if ([deviceString isEqualToString:@"x86_64"])       return @"Simulator";
    
    return deviceString;
}


- (void)initAutoScaleSize{
    
    if (kScreenHeight == 480) {
        //4s
        _autoSizeScaleW = kScreenWith / 375;
        _autoSizeScaleH = kScreenHeight / 667;
    }else if (kScreenHeight == 568) {
        //5
        _autoSizeScaleW = kScreenWith / 375;
        _autoSizeScaleH = kScreenHeight / 667;
    }else if (kScreenHeight ==667){
        //6
        _autoSizeScaleW = kScreenWith / 375;
        _autoSizeScaleH = kScreenHeight / 667;
    }else if(kScreenHeight == 736){
        //6p
        _autoSizeScaleW = kScreenWith / 375;
        _autoSizeScaleH = kScreenHeight / 667;
    }
    else if (kScreenHeight ==1136)
    {
        _autoSizeScaleW = kScreenWith / 375;
        _autoSizeScaleH = kScreenHeight / 667;
    }
    //ipad air2
    else if (kScreenHeight == 1024 )
    {
        _autoSizeScaleW = kScreenWith / 768;
        _autoSizeScaleH = kScreenHeight / 1024;
    }
     else{
        _autoSizeScaleW = 1;
        _autoSizeScaleH = 1;
    }
    
}
- (CGFloat)autoScaleW:(CGFloat)w{
    
    return w * self.autoSizeScaleW;
    
}

- (CGFloat)autoScaleH:(CGFloat)h{
    
    return h * self.autoSizeScaleH;
    
}
#pragma mark -- ／／ 设置自定义navigationBar
- (void)initWithTabBarController{
    //初始化tablebar个数
    NSArray *arrTitle         = @[@"首页", @"订单"];
    
    //vc个数
    NSArray *arrClass         = @[@"HomePageVC", @"MyorderViewController"];
    
    //初始化tablebar图标
    NSArray *arrBarIcon       = @[@"首页", @"订单"];
    
    //创建tabbar数组
    NSMutableArray *arrNC     = [NSMutableArray array];
    
    for (NSString *classStr in arrClass) {
        
        Class className = NSClassFromString(classStr);
        
        if (className) {
            
            static NSInteger i = 0;
            
            UIViewController *viewController = [[[className class] alloc]init];
            
            self.navigation = [[UINavigationController alloc] initWithRootViewController:viewController];
            
            _navigation.title = [arrTitle objectAtIndex:i];
            
            [arrNC addObject:_navigation];
            
            [_navigation.tabBarItem setImage:[UIImage imageNamed:[arrBarIcon objectAtIndex:i]]];
            
            i++;
        }
    }
    MyTableBar*myTabBar = [[MyTableBar alloc]init];
    myTabBar.myDelegate = self;
    
    self.tabController = [[UITabBarController alloc] init];
    
    [self.tabController setValue:myTabBar forKey:@"tabBar"];
    self.tabController.tabBar.barTintColor = [UIColor lightTextColor];
    
    [self.tabController.tabBar setTintColor:RGB(253, 117, 119)];
    
    self.tabController.viewControllers = [arrNC copy];
    self.tabController.delegate = self;
   
    //覆盖中间tabbar
    self.window.rootViewController = self.tabController;
    
}

- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController
{
    if (tabBarController.selectedIndex==0) {

        [(UINavigationController *)viewController popToRootViewControllerAnimated:YES];
    }
    

}
//通过控制器的布局视图可以获取控制器实例对象
- (UIViewController*)currentViewcontroler{
    
    UIWindow * keyWindow = [UIApplication sharedApplication].keyWindow;
    //取第一层 去到的是 uitransitionview 通过这个VIew拿不到控制器
    
    UIView * firstView = [keyWindow.subviews firstObject];
    UIView * secondView = [firstView.subviews firstObject];
    UIViewController * vc = [secondView parentController];
    
    if ([vc isKindOfClass:[UITabBarController class]]) {
        
        UITabBarController * tab = (UITabBarController*)vc;
        
        if ([tab.selectedViewController isKindOfClass:[UINavigationController class]]) {
            
            UINavigationController  * nav = (UINavigationController *)tab.selectedViewController;
            return [nav.viewControllers lastObject];
        }
        else{
            
            return tab.selectedViewController;
        }
        
        
    }else if ([vc isKindOfClass:[UINavigationController class]]){
        
        UINavigationController * nav = (UINavigationController *)vc;
        return [nav.viewControllers lastObject];
        
    }else{
        
        return vc;
    }
    
    return nil;
    
}

#pragma mark 获取ip
- (NSString *)getIPAddress:(BOOL)preferIPv4

{
    
    NSArray *searchArray = preferIPv4 ?
    
    @[ IOS_VPN @"/" IP_ADDR_IPv4, IOS_VPN @"/" IP_ADDR_IPv6, IOS_WIFI @"/" IP_ADDR_IPv4, IOS_WIFI @"/" IP_ADDR_IPv6, IOS_CELLULAR @"/" IP_ADDR_IPv4, IOS_CELLULAR @"/" IP_ADDR_IPv6 ] :
    
    @[ IOS_VPN @"/" IP_ADDR_IPv6, IOS_VPN @"/" IP_ADDR_IPv4, IOS_WIFI @"/" IP_ADDR_IPv6, IOS_WIFI @"/" IP_ADDR_IPv4, IOS_CELLULAR @"/" IP_ADDR_IPv6, IOS_CELLULAR @"/" IP_ADDR_IPv4 ] ;
    
    
    
    NSDictionary *addresses = [self getIPAddresses];
    
//    NSLog(@"addresses: %@", addresses);
//    
//    
//    
//    __block NSString *address;
//    
//    [searchArray enumerateObjectsUsingBlock:^(NSString *key, NSUInteger idx, BOOL *stop)
//     
//     {
//         
//         address = addresses[key];
//         
//         if(address) *stop = YES;
//         
//     } ];
    
//    ? address : @"0.0.0.0";
    return addresses[@"en0/ipv4"];
    
}

- (NSDictionary *)getIPAddresses

{
    
    NSMutableDictionary *addresses = [NSMutableDictionary dictionaryWithCapacity:8];
    
    // retrieve the current interfaces - returns 0 on success
    struct ifaddrs *interfaces;
    if(!getifaddrs(&interfaces)) {
        // Loop through linked list of interfaces
        struct ifaddrs *interface;
        for(interface=interfaces; interface; interface=interface->ifa_next) {
            if(!(interface->ifa_flags & IFF_UP) /* || (interface->ifa_flags & IFF_LOOPBACK) */ ) {
                continue; // deeply nested code harder to read
            }
            const struct sockaddr_in *addr = (const struct sockaddr_in*)interface->ifa_addr;
            char addrBuf[ MAX(INET_ADDRSTRLEN, INET6_ADDRSTRLEN) ];
            if(addr && (addr->sin_family==AF_INET || addr->sin_family==AF_INET6)) {
                NSString *name = [NSString stringWithUTF8String:interface->ifa_name];
                NSString *type;
                if(addr->sin_family == AF_INET) {
                    if(inet_ntop(AF_INET, &addr->sin_addr, addrBuf, INET_ADDRSTRLEN)) {
                        type = IP_ADDR_IPv4;
                    }
                } else {
                    const struct sockaddr_in6 *addr6 = (const struct sockaddr_in6*)interface->ifa_addr;
                    if(inet_ntop(AF_INET6, &addr6->sin6_addr, addrBuf, INET6_ADDRSTRLEN)) {
                        type = IP_ADDR_IPv6;
                    }
                }
                if(type) {
                    NSString *key = [NSString stringWithFormat:@"%@/%@", name, type];
                    addresses[key] = [NSString stringWithUTF8String:addrBuf];
                }
            }
        }
        // Free memory
        freeifaddrs(interfaces);
    }
    return [addresses count] ? addresses : nil;
    
}
 -(BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    WTThirdPartyLoginManager *wtf = [[WTThirdPartyLoginManager alloc] init];
    
    return [WeiboSDK handleOpenURL:url delegate:wtf]|| [TencentOAuth HandleOpenURL:url]||[WXApi handleOpenURL:url delegate:wtf];
    
    
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{

    
      WTThirdPartyLoginManager * main = [[WTThirdPartyLoginManager alloc]init];
    return [WeiboSDK handleOpenURL:url delegate:main]||[TencentOAuth HandleOpenURL:url]||[WXApi handleOpenURL:url delegate:main];





}

//退出登录
-(void)showWindowHome:(NSString *)windowType{
    
    if([windowType isEqualToString:@"loginOut"]){
    
        self.window.rootViewController = _tabController;
        
    }
   
}
- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString*, id> *)options
{
    if ([url.host isEqualToString:@"safepay"]) {
        // 支付跳转支付宝钱包进行支付，处理支付结果
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
            
            NSString * resultstr = [resultDic objectForKey:@"resultStatus"];
            if ([resultstr integerValue]==9000) {
                
                [MBProgressHUD showSuccess:@"支付成功"];
                
                [[NSNotificationCenter defaultCenter]postNotificationName:@"success" object:nil];
                
                
            }
            else if ([resultstr integerValue]==4000)
            {
                [MBProgressHUD showError:@"支付失败"];
            }
            else if ([resultstr integerValue]==6001)
            {
                [MBProgressHUD showError:@"用户取消"];
            }else
            {
                [MBProgressHUD showError:@"网络错误"];
            }
            

        }];
        
        // 授权跳转支付宝钱包进行支付，处理支付结果
        [[AlipaySDK defaultService] processAuth_V2Result:url standbyCallback:^(NSDictionary *resultDic) {
            // 解析 auth code
            NSString *result = resultDic[@"result"];
            NSString *authCode = nil;
            if (result.length>0) {
                NSArray *resultArr = [result componentsSeparatedByString:@"&"];
                for (NSString *subResult in resultArr) {
                    if (subResult.length > 10 && [subResult hasPrefix:@"auth_code="]) {
                        authCode = [subResult substringFromIndex:10];
                        break;
                    }
                }
            }
            NSLog(@"授权结果 authCode = %@", authCode?:@"");
        }];
        return YES;
    }else if ([url.host isEqualToString:@"pay"]){
        return [WXApi handleOpenURL:url delegate:[WXApiManager sharedManager]];
    }
    else if ([url.host isEqualToString:@"oauth"])
    {
         WTThirdPartyLoginManager *wtf = [[WTThirdPartyLoginManager alloc] init];
        return [WXApi handleOpenURL:url delegate:wtf];
    }
    else if ([url.host isEqualToString:@"qzapp"]){
        
        return [TencentOAuth HandleOpenURL:url];
    }
    
    return NO;
}
#pragma mark 检测更新
- (void)updateApp{
    
//    //获取当前工程版本号
//    NSDictionary * infoDic = [[NSBundle mainBundle] infoDictionary];
//    NSString * version = infoDic[@"CFBundleShortVersionString"];
//    //获取appstore版本号
//    NSError * error;
//    NSDate * response = [NSURLConnection sendSynchronousRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://itunes.apple.com/cn/lookup?id=%@",APPSTOREID]]] returningResponse:nil error:nil];
//    if (response==nil) {
//        
//        return;
//    }
//    
//    NSDictionary * appinfoDic = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableLeaves error:&error];
//    if (error) {
//        
//        NSLog(@"errrror:%@",error);
//        return;
//    }
//    
//    NSArray * array = appinfoDic[@"results"];
//    NSDictionary * dic = array[0];
//    NSString * appStoreVersion = dic[@"version"];
//    
//    if ([appStoreVersion floatValue]>[version floatValue]) {
//        
//        UIAlertController * alertView = [UIAlertController alertControllerWithTitle:nil message:@"检测到新版本，是否更新" preferredStyle:UIAlertControllerStyleAlert];
//        UIAlertAction * cancelAction = [UIAlertAction actionWithTitle:@"偏不" style:UIAlertActionStyleCancel handler:nil];
//        UIAlertAction * okAction = [UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//            
//            //6此处加入应用在app store的地址，方便用户去更新，一种实现方式如下：
//            NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"https://itunes.apple.com/us/app/id%@?ls=1&mt=8", APPSTOREID]];
//            [[UIApplication sharedApplication] openURL:url];
//            
//        }];
//        
//        [alertView addAction:cancelAction];
//        [alertView addAction:okAction];
//        
//        id controller = [UIApplication sharedApplication].keyWindow.rootViewController;
//        if ([controller isKindOfClass:[UITabBarController class]]) {
//            
//            UITabBarController * tabC = (UITabBarController *)controller;
//            UIViewController * vc = (UIViewController*)[tabC.viewControllers firstObject];
//            [vc presentViewController:alertView animated:YES completion:nil];
//
//            
//        }
//        else{
//            
//            UIViewController * vc = (UIViewController*)controller;
//            [vc presentViewController:alertView animated:YES completion:nil];
//
//        }
//
//    }
    
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}
// 启动程序 角标归零
- (void)applicationDidBecomeActive:(UIApplication *)application {

    application.applicationIconBadgeNumber = 0;
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
