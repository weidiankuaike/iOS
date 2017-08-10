//
//  Shoucangcellmodel.h
//  wdKuaiKe_iOS
//
//  Created by 张森森 on 16/12/22.
//  Copyright © 2016年 weiDianKuaiKe. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Shoucangcellmodel : NSObject
@property (nonatomic,copy) NSString *imagestr,*namestr,*caiid,*moneystr;

- (id)initWithgetsomethingwithdict:(NSDictionary*)dict;
@end
