//
//  Dinemodel.h
//  wdKuaiKe_iOS
//
//  Created by 张森森 on 17/1/4.
//  Copyright © 2017年 weiDianKuaiKe. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Dinemodel : NSObject
//订单id
@property (nonatomic,copy)NSString * orderid;
//菜品名称
@property (nonatomic,copy)NSString * productname;
//菜品数量
@property (nonatomic,assign)NSInteger productnumber;
//菜品图片
@property (nonatomic,copy)NSString * imagestr;
//已上菜的数量
@property (nonatomic,assign)NSInteger served;
//未上菜的数量
@property (nonatomic,assign)NSInteger userverd;
//缺货数量
@property (nonatomic,assign)NSInteger islack;
//查看状态是未上还是已上
@property (nonatomic,copy)NSString * foodIndex;

-(id)initWithgetsomethingwithdict:(NSDictionary*)dict;

@end
