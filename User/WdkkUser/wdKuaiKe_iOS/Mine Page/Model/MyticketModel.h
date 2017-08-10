//
//  MyticketModel.h
//  wdKuaiKe_iOS
//
//  Created by 张森森 on 16/12/21.
//  Copyright © 2016年 weiDianKuaiKe. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MyticketModel : NSObject
@property (nonatomic,copy)NSString * namestr,*begintime,*endtime,*discount,*cardtype,*consumover,*typestr,*conditions,*cardId;

-(id)initWithGetstrWithdict:(NSDictionary*)dict
;
@end
