//
//  Btnscrollerview.h
//  wdKuaiKe_iOS
//
//  Created by 张森森 on 17/1/10.
//  Copyright © 2017年 weiDianKuaiKe. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseButton.h"

typedef void(^btnblock)(NSInteger btnint);

@interface Btnscrollerview : UIScrollView

@property (nonatomic,assign)NSInteger btninteger;
@property (nonatomic,copy)btnblock block;

- (instancetype)initWithint:(NSInteger)btnint;
- (void)Getsomethingwithblock:(btnblock)block;


@end
