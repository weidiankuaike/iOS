//
//  GFCalendarScrollView.h
//
//  Created by Mercy on 2016/11/9.
//  Copyright © 2016年 Mercy. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^DidSelectDayHandler)(NSInteger, NSInteger, NSInteger,NSInteger);

@interface GFCalendarScrollView : UIScrollView


@property (nonatomic, strong) DidSelectDayHandler didSelectDayHandler; // 日期点击回调
@property (nonatomic, assign) NSInteger typeint;//分时间段选择还是只选择某一天
- (void)refreshToCurrentMonth; // 刷新 calendar 回到当前日期月份


@end
