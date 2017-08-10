//
//  SiftView.h
//  wdKuaiKe_iOS
//
//  Created by 张森森 on 17/1/20.
//  Copyright © 2017年 weiDianKuaiKe. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^choosebtnblock) (NSString * choosestr);

@interface SiftView : UIView

@property (nonatomic,copy)choosebtnblock block;

-(instancetype)initWithary:(NSArray*)ary;


@end
