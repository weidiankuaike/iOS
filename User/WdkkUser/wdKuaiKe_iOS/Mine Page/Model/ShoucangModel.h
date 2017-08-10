//
//  ShoucangModel.h
//  wdKuaiKe_iOS
//
//  Created by 张森森 on 16/12/22.
//  Copyright © 2016年 weiDianKuaiKe. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Shoucangcellmodel.h"
@interface ShoucangModel : NSObject
@property (nonatomic,copy) NSString * storeimage,*storenamestr,*imagestr,*namestr,*caiid,*moneystr,*storeid;

@property (nonatomic,strong)NSMutableArray * modelarray;

- (id)initWithgetsomethingwithdict:(NSDictionary*)dictary;
@end
