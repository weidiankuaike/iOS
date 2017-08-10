//
//  Browmodel.h
//  wdKuaiKe_iOS
//
//  Created by 张森森 on 16/12/24.
//  Copyright © 2016年 weiDianKuaiKe. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Browmodel : NSObject

@property (nonatomic,copy)NSString * distance ,*introduction,*namestr,*pricestr,* storeidstr,*storeidimage;


-(id)initWithgetstrwithdict:(NSDictionary*)dict;

@end
