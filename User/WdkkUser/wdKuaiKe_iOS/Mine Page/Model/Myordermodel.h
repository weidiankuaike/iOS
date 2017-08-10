//
//  Myordermodel.h
//  wdKuaiKe_iOS
//
//  Created by 张森森 on 16/12/27.
//  Copyright © 2016年 weiDianKuaiKe. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSObject+JudgeNull.h"
@interface Myordermodel : NSObject
@property (nonatomic,copy)NSString * storename,*storeimage,*mealsno,*ordertype,*arrivaltime,*creattime,*moneystr,*orderid,*remaekstr,*ordername,*addresstr,*storephone,*storeid;
@property (nonatomic,strong)NSDate *creatimedata;
@property (nonatomic,strong)NSDate * arrivedate;
@property (nonatomic,strong)NSArray * caiary;//菜品数组
@property (nonatomic,strong)NSString * timers;//倒计时剩余时间
@property (nonatomic,copy)NSString * disorderType;//到店用餐，预定区分
-(id)initWithgetsomethingwithdict:(NSDictionary*)dict;

@end
