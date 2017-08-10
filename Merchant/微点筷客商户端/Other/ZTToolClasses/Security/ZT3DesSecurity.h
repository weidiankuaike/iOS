//
//  ZT3DesSecurity.h
//  微点筷客商户端
//
//  Created by Skyer God on 2017/4/26.
//  Copyright © 2017年 张森森. All rights reserved.
//

#import <Foundation/Foundation.h>
@interface ZT3DesSecurity : NSObject
//加密
+ (NSString *)encryptWithText:(NSString *)sText;
//解密
+ (NSString *)decryptWithText:(NSString *)sText;
@end
