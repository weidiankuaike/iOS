//
//  CardModel.h
//  wdKuaiKe_iOS
//
//  Created by 张森森 on 17/5/26.
//  Copyright © 2017年 weiDianKuaiKe. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CardModel : NSObject
@property (nonatomic,copy)NSString * cardType;//活动类型 0.1 卡券  2.满减 3.折扣
@property (nonatomic,copy)NSString * consumptionOver;//满足条件
@property (nonatomic,copy)NSString * discountedPrice;// 优惠金额
@property (nonatomic,copy)NSString * discount;//优惠折扣
@end
