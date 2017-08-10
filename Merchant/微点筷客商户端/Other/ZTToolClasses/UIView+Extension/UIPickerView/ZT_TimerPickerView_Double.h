//
//  ZT_TimerPickerView_Double.h
//  微点筷客商户端
//
//  Created by Skyer God on 16/12/2.
//  Copyright © 2016年 张森森. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ZT_TimerPickerView_Double;
@protocol ZT_TimerPickerView_DoubleDelegate <NSObject>
@optional
- (void)ZTselectTimesView:(ZT_TimerPickerView_Double *)deskPicker setYear:(NSInteger)year setMonth:(NSInteger *)month setDay:(NSInteger)day;

@end

@interface ZT_TimerPickerView_Double : UIView;
/** 右边可变提示，编号or数量  (NSString) **/
@property (nonatomic, strong) UILabel *numLabel;
/** 正标题   (strong) **/
@property (nonatomic, strong)  UILabel *titleLabel;
/** 标题提示   (strong) **/
@property (nonatomic, strong) UILabel *littleTitle;
/** 右边类型 or 整数   (strong) **/
@property (nonatomic, strong) UILabel *categortyLabel;
/** 返回按钮   (strong) **/
@property (nonatomic, strong) ButtonStyle *cancelBT;
/** 确定按钮   (strong) **/
@property (nonatomic, strong) ButtonStyle *addBT;
@property (nonatomic, assign) id <ZT_TimerPickerView_DoubleDelegate> delegate;
/** startTime  (NSString) **/

- (instancetype)initWithStartTime:(NSString *)startTime;
- (void)showView;
- (void)dismiss;

@property (nonatomic, strong) void (^returnSelectDate)(NSString *date);
@end
