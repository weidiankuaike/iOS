//
//  DeviceSet.m
//  微点筷客商户端
//
//  Created by Skyer God on 17/2/24.
//  Copyright © 2017年 张森森. All rights reserved.
//
/*
 *  System Versioning Preprocessor Macros
 */

#define SYSTEM_VERSION_EQUAL_TO(v)                  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedSame)
#define SYSTEM_VERSION_GREATER_THAN(v)              ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedDescending)
#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN(v)                 ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN_OR_EQUAL_TO(v)     ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedDescending)

/*
 *  Usage
 */
#import "DeviceSet.h"
#import "XGSetting.h"
#import "XGPush.h"
#import <ifaddrs.h>
#import <net/if.h>
#import <SystemConfiguration/CaptiveNetwork.h>
#import <CoreLocation/CoreLocation.h>
@implementation DeviceSet
+(DeviceSet *)shareDevice{
    static DeviceSet *shareDevice = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shareDevice = [[self alloc] init];
    });
    return shareDevice;
}
+ (NSString *)randomUUID {
    if(NSClassFromString(@"NSUUID")) { // only available in iOS >= 6.0
        NSString *uuid = [[NSUUID UUID] UUIDString];
        [self saveKeychainValue:uuid key:@"deviceUID"];
        return uuid;
    }
    CFUUIDRef uuidRef = CFUUIDCreate(kCFAllocatorDefault);
    CFStringRef cfuuid = CFUUIDCreateString(kCFAllocatorDefault, uuidRef);
    CFRelease(uuidRef);
    NSString *uuid = [((__bridge NSString *) cfuuid) copy];
    CFRelease(cfuuid);
    [self saveKeychainValue:uuid key:@"deviceUID"];
    return uuid;
}
+ (NSMutableDictionary *)getKeychainQuery:(NSString *)service{
    return [NSMutableDictionary dictionaryWithObjectsAndKeys:
            (__bridge_transfer id)kSecClassGenericPassword,
            (__bridge_transfer id)kSecClass,service,
            (__bridge_transfer id)kSecAttrService,service,
            (__bridge_transfer id)kSecAttrAccount,
            (__bridge_transfer id)kSecAttrAccessibleAfterFirstUnlock,
            (__bridge_transfer id)kSecAttrAccessible,
            nil];
}

+ (void)saveKeychainValue:(NSString *)sValue key:(NSString *)sKey{
    NSMutableDictionary * keychainQuery = [self getKeychainQuery:sKey];
    SecItemDelete((__bridge_retained CFDictionaryRef)keychainQuery);

    [keychainQuery setObject:[NSKeyedArchiver archivedDataWithRootObject:sValue] forKey:(__bridge_transfer id)kSecValueData];

    SecItemAdd((__bridge_retained CFDictionaryRef)keychainQuery, NULL);

}

+ (NSString *)readKeychainValue:(NSString *)sKey
{
    NSString *ret = nil;
    NSMutableDictionary *keychainQuery = [self getKeychainQuery:sKey];
    [keychainQuery setObject:(id)kCFBooleanTrue forKey:(__bridge_transfer id)kSecReturnData];
    [keychainQuery setObject:(__bridge_transfer id)kSecMatchLimitOne forKey:(__bridge_transfer id)kSecMatchLimit];
    CFDataRef keyData = NULL;
    if (SecItemCopyMatching((__bridge CFDictionaryRef)keychainQuery, (CFTypeRef *)&keyData) == noErr) {
        @try {
            ret = (NSString *)[NSKeyedUnarchiver unarchiveObjectWithData:(__bridge NSData *)keyData];
        } @catch (NSException *e) {
            //            NSLog(@"Unarchive of %@ failed: %@", sKey, e);
        } @finally {
        }
    }
    if (keyData)
        CFRelease(keyData);
    return ret;
}
+ (void)deleteKeychainValue:(NSString *)sKey {
    NSMutableDictionary *keychainQuery = [self getKeychainQuery:sKey];
    SecItemDelete((__bridge CFDictionaryRef)keychainQuery);
}
//获取网络状态
- (NSString *)getNetWorkStates{
    UIApplication *app = [UIApplication sharedApplication];
    NSArray *children = [[[app valueForKeyPath:@"statusBar"]valueForKeyPath:@"foregroundView"]subviews];
    NSString *state = [[NSString alloc]init];
    int netType = 0;
    //获取到网络返回码
    for (id child in children) {
        if ([child isKindOfClass:NSClassFromString(@"UIStatusBarDataNetworkItemView")]) {
            //获取到状态栏
            netType = [[child valueForKeyPath:@"dataNetworkType"]intValue];

            switch (netType) {
                case 0:
                    state = @"无网络";
                    //无网模式
                    break;
                case 1:
                    state =  @"2G";
                    break;
                case 2:
                    state =  @"3G";
                    break;
                case 3:
                    state =   @"4G";
                    break;
                case 5:
                {
                    state =  @"wifi";
                    break;
                default:
                    break;
                }
            }
        }
        //根据状态选择
    }
    return state;

}
//判断Wi-Fi是否打开
- (BOOL)isWiFiEnabled{

    NSCountedSet * cset = [NSCountedSet new];

    struct ifaddrs *interfaces;

    if( ! getifaddrs(&interfaces) ) {
        for( struct ifaddrs *interface = interfaces; interface; interface = interface->ifa_next) {
            if ( (interface->ifa_flags & IFF_UP) == IFF_UP ) {
                [cset addObject:[NSString stringWithUTF8String:interface->ifa_name]];
            }
        }
    }

    return [cset countForObject:@"awdl0"] > 1 ? YES : NO;
}
//判断定位是否打开
- (BOOL)isLocationServiceOpen {
    if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusDenied) {
        return NO;
    } else
        return YES;
}
//判断通知是否打开
//判断推送是否开启
- (BOOL)isAllowedNotification
{
    UIUserNotificationSettings *setting = [[UIApplication sharedApplication] currentUserNotificationSettings];

    if(UIUserNotificationTypeNone != setting.types) {
        return YES;
    }else{
        return NO;
    }

}
- (BOOL)isMessageNotificationServiceOpen {
    if (SYSTEM_VERSION_GREATER_THAN(@"8.0")) {
        return [[UIApplication sharedApplication] isRegisteredForRemoteNotifications];
    } else {
        return UIRemoteNotificationTypeNone != [[UIApplication sharedApplication] enabledRemoteNotificationTypes];
    }
}
////获取版本更新
//- (void)updateNewVersion{
//
//    NSDictionary *infoDict = [[NSBundle mainBundle] infoDictionary];
//    NSString *oldVersion = infoDict[@"CFBundleShortVersionString"];//CFBundleShortVersionString   //CFBundleVersion
//    NSString *url = [[NSString alloc] initWithFormat:@"http://itunes.apple.com/cn/lookup?id=%@", @"1209904810"];
//
//    [[QYXNetTool shareManager] getNetWithUrl:url urlBody:nil header:nil response:QYXJSON success:^(id result) {
//        NSNumber *number = result[@"resultCount"];
//        if (number.intValue == 1) {
//            NSString *newVersion = result[@"results"][0][@"version"];
//            NSString *trackViewUrl = [result[@"results"][0] objectForKey:@"trackViewUrl"];
//            if ([self compareVersionsFormAppStore:newVersion WithAppVersion:oldVersion]) {
//                UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"检测到最新版本" message:@"是否前往App Store更新？" preferredStyle:UIAlertControllerStyleAlert];
//                UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"更新" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
//
//                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:trackViewUrl] options:@{} completionHandler:^(BOOL success) {
//
//                    }];
//
//                }];
//                UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
//                    
//                }];
//                [alertController addAction:okAction];
//                [alertController addAction:cancelAction];
//                id controller = [UIApplication sharedApplication].keyWindow.rootViewController;
//                if ([controller isKindOfClass:[UITabBarController class]]) {
//                    UITabBarController *tabC = (UITabBarController *)controller;
//                    UIViewController *vc = (UIViewController *)[tabC.viewControllers firstObject];
//                    [vc presentViewController:alertController animated:YES completion:^{
//
//                    }];
//                } else {
//                    UIViewController *vc = (UIViewController *)controller;
//                    [vc presentViewController:alertController animated:YES completion:^{
//                    }];
//
//                }
//
//            }
//        }
//    } failure:^(NSError *error) {
//
//
//    }];
//}

//比较版本的方法，在这里我用的是Version来比较的
- (BOOL)compareVersionsFormAppStore:(NSString*)AppStoreVersion WithAppVersion:(NSString*)AppVersion{

    BOOL littleSunResult = false;

    NSMutableArray* a = (NSMutableArray*) [AppStoreVersion componentsSeparatedByString: @"."];
    NSMutableArray* b = (NSMutableArray*) [AppVersion componentsSeparatedByString: @"."];

    while (a.count < b.count) { [a addObject: @"0"]; }
    while (b.count < a.count) { [b addObject: @"0"]; }

    for (int j = 0; j<a.count; j++) {
        if ([[a objectAtIndex:j] integerValue] > [[b objectAtIndex:j] integerValue]) {
            littleSunResult = true;
            break;
        }else if([[a objectAtIndex:j] integerValue] < [[b objectAtIndex:j] integerValue]){
            littleSunResult = false;
            break;
        }else{
            littleSunResult = false;
        }
    }
    return littleSunResult;//true就是有新版本，false就是没有新版本
    
}
- (void)showAlertWiFiStatus:(NSString *)title subTitle:(NSString *)subTitle rootUrl:(NSString *)rootUrl completionHandler:(completionHandler)completionHandler{

    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:subTitle preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"打开" style:(UIAlertActionStyleDestructive) handler:^(UIAlertAction * _Nonnull action) {
        if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:[NSString stringWithFormat:@"prefs:root=%@", rootUrl]]]) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"prefs:root=%@", rootUrl]] options:@{} completionHandler:^(BOOL success) {
                completionHandler(YES);
            }];
        } else {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"App-Prefs:root=%@", rootUrl]] options:@{} completionHandler:^(BOOL success) {
                completionHandler(YES);
            }];
        }

    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
        completionHandler(NO);
    }];
    [alertController addAction:okAction];
    [alertController addAction:cancelAction];

    id controller = [UIApplication sharedApplication].keyWindow.rootViewController;
    if ([controller isKindOfClass:[UITabBarController class]]) {
        UITabBarController *tabC = (UITabBarController *)controller;
        UIViewController *vc = (UIViewController *)[tabC.viewControllers firstObject];
        [vc presentViewController:alertController animated:YES completion:^{

        }];
    } else {
        UIViewController *vc = (UIViewController *)controller;
        [vc presentViewController:alertController animated:YES completion:^{
        }];

    }

}
@end
