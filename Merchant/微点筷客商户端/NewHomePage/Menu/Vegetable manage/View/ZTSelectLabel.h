//
//  ZTSelectLabel.h
//  merchantClient
//
//  Created by Skyer God on 2017/7/17.
//  Copyright © 2017年 张甜. All rights reserved.
//
static NSString *const SSCalendarType = @"SSCalendarType"; //日历选择类型
static NSString *const ZTTouchObject = @"TouchObject";
#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, CalendarType) {
    CalendarTypeNone, //不可用
    CalendarTypeDouble, //双选日期
    CalendarTypeSingle, //单选日期
    CalendarTypeThree, //不可用
};
typedef void(^selectButtonClick)(NSInteger type, NSInteger index, NSArray <NSString *> *timeArr, ButtonStyle *sender);
@interface ZTSelectLabel : UIView

/** button 点击回调 type = 0 第一行 1 第二行  index 按钮下标  sender 点击对象   (strong) **/
@property (nonatomic, copy) selectButtonClick buttonClickBlock;
-(instancetype)initWithTitleArr:(NSArray<NSString *> *)titleArr TopArr:(NSArray<NSString *> *)topArr  BottomArr:(NSArray<NSString *> *)bottomArr formatOptions:(NSDictionary *)formatOptions;
- (void)showSelectButtonView;
- (void)dismissSelectButtonView;
//- (void)selectButtonClick:(selectButtonClick)selectOptions;
@end
