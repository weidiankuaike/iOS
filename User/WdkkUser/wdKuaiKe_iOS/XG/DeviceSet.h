//
//  DeviceSet.h
//  微点筷客商户端
//
//  Created by Skyer God on 17/2/24.
//  Copyright © 2017年 张森森. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef void(^completionHandler)(BOOL success);
@interface DeviceSet : NSObject
+(DeviceSet *)shareDevice;
+ (NSString *)randomUUID ;
/**
 *  储存字符串到🔑钥匙串
 *
 *  @param sValue 对应的Value
 *  @param sKey   对应的Key
 */
+ (void)saveKeychainValue:(NSString *)sValue key:(NSString *)sKey;


/**
 *  从🔑钥匙串获取字符串
 *
 *  @param sKey 对应的Key
 *
 *  @return 返回储存的Value
 */
+ (NSString *)readKeychainValue:(NSString *)sKey;


/**
 *  从🔑钥匙串删除字符串
 *
 *  @param sKey 对应的Key
 */
+ (void)deleteKeychainValue:(NSString *)sKey;


//判断网络状态
- (NSString *)getNetWorkStates;
//判断Wi-Fi开关是否打开
- (BOOL)isWiFiEnabled;
//版本更新
//- (void)updateNewVersion;

//判断通知是否打开
- (BOOL)isAllowedNotification;
- (BOOL)isMessageNotificationServiceOpen;
//判断定位是否打开
- (BOOL)isLocationServiceOpen;
- (void)showAlertWiFiStatus:(NSString *)title subTitle:(NSString *)subTitle rootUrl:(NSString *)rootUrl completionHandler:(completionHandler)completionHandler;
@end
