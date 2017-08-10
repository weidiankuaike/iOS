//
//  DishesInfoModel.m
//  微点筷客商户端
//
//  Created by Skyer God on 16/10/19.
//  Copyright © 2016年 张森森. All rights reserved.
//

#import "DishesInfoModel.h"

@implementation DishesInfoModel
+ (NSDictionary *)replacedKeyFromPropertyName{
    return @{
             @"dishesID" : @"pid",
             @"dishesName" : @"pname",
             @"img" : @"images",
             @"price" : @"pfee",
             @"downStair" : @"offFood",
             @"descrpt" : @"note",
             @"category" : @"cname",
             @"categoryId" : @"cid"
             };
}

@end
