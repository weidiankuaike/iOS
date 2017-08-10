//
//  ZTChartView.h
//  merchantClient
//
//  Created by Skyer God on 2017/7/17.
//  Copyright © 2017年 张甜. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "merchantClient-Bridging-Header.h"
@interface ZTChartView : UIView
/** 图标   (strong) **/
@property (nonatomic, strong)  PieChartView *chartView;
//初始化
-(instancetype)initChartViewWithFrame:(CGRect)frame titleArr:(NSArray<NSString *> *)titleArr percentArr:(NSArray<NSString *> *)percentArr;
//更新表
- (void)updateChartViewWithTitleArr:(NSArray<NSString *> *)titleArr percentArr:(NSArray<NSString *> *)percentArr;
@end
