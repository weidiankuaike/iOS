//
//  AddressSetFromMapVC.h
//  微点筷客商户端
//
//  Created by Skyer God on 16/11/8.
//  Copyright © 2016年 张森森. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
typedef void(^returnMapAddress)(NSString *, CLLocationCoordinate2D);
@interface AddressSetFromMapVC : UIViewController
/** 目的地地址  (NSString) **/
@property (nonatomic, copy) NSString *targetAddress;
/** block属性，返回地址字符串  (NSString) **/
@property (nonatomic, copy) returnMapAddress address;
- (void)returnAddressFromMap:(returnMapAddress)mapAddress;

@end
