//
//  StartView.h
//  wdKuaiKe_iOS
//
//  Created by 张森森 on 17/1/10.
//  Copyright © 2017年 weiDianKuaiKe. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface StartView : UIView
@property (nonatomic, assign)CGFloat scorePercent;//0到1,评分
- (instancetype)initWithFrame:(CGRect)frame numberOfStars:(NSInteger)numberOfStar;


@end
