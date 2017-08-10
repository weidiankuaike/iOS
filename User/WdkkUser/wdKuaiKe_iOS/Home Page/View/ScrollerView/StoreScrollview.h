//
//  StoreScrollview.h
//  wdKuaiKe_iOS
//
//  Created by 张森森 on 17/1/10.
//  Copyright © 2017年 weiDianKuaiKe. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface StoreScrollview : UIScrollView
@property (nonatomic,strong)NSArray * imageary;
- (instancetype)initWithary:(NSArray*)imageary;
@end
