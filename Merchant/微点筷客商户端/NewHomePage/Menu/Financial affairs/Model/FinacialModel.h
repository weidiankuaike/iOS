//
//  FinacialModel.h
//  微点筷客商户端
//
//  Created by 张森森 on 16/12/14.
//  Copyright © 2016年 张森森. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FinacialModel : NSObject
@property (nonatomic,copy)NSString * timestr,*typestr,*moneystr,*statusstr,*markstr,*liushuistr,* trackstr,*balance,*cardstr;

-(id)initWithgetsonthingwithdict:(NSDictionary*)dict;
@end
