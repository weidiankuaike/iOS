//
//  VoucherViewMedel.m
//  微点筷客商户端
//
//  Created by Skyer God on 16/10/24.
//  Copyright © 2016年 张森森. All rights reserved.
//

#import "VoucherViewMedel.h"
#import <MJPropertyKey.h>
@implementation VoucherViewMedel
+ (NSDictionary *)replacedKeyFromPropertyName{
    return @{
             @"voucheID" : @"id",
             };
}
-(void)mj_keyValuesDidFinishConvertingToObject{
    self.discount = [NSString stringWithFormat:@"%.1lf", [self.discount doubleValue]];
}
@end
