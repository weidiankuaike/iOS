//
//  Mywalletmodel.h
//  wdKuaiKe_iOS
//
//  Created by 张森森 on 16/12/22.
//  Copyright © 2016年 weiDianKuaiKe. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Mywalletmodel : NSObject
@property (nonatomic,copy)NSString * namestr, *timestr ,*moneystr,*ztstr,*iswithdraw;

-(id)initWithgetstrWithdict:(NSDictionary*)dict;
@end
