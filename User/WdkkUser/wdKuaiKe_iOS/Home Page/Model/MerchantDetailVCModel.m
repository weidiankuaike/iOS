//
//  MerchantDetailVCModel.m
//  wdKuaiKe_iOS
//
//  Created by Skyer God on 16/8/15.
//  Copyright © 2016年 weiDianKuaiKe. All rights reserved.
//

#import "MerchantDetailVCModel.h"
#import "MJExtension.h"
@implementation MerchantDetailVCModel
+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{
             @"merchantID" : @"id"
             };
}
@end
