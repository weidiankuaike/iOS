//
//  ZT_doublePickerView.h
//  微点筷客商户端
//
//  Created by Skyer God on 16/10/20.
//  Copyright © 2016年 张森森. All rights reserved.
//

typedef void(^addBTClick)();
#import <UIKit/UIKit.h>
@class ZT_doublePickerView;
@protocol ZTDeskPickerViewDelegate <NSObject>

- (void)ZTselectTimesView:(ZT_doublePickerView *)deskPicker SetOneLeft:(NSString *)oneLeft andOneRight:(NSString *)oneRight;

@end

@interface ZT_doublePickerView : UIView<UIPickerViewDataSource,UIPickerViewDelegate>
/** 右边可变提示，编号or数量  (NSString) **/
@property (nonatomic, strong) UILabel *numLabel;
/** <#行注释#>   (strong) **/
@property (nonatomic, strong) UILabel * titleLabel;
/** 标题提示   (strong) **/
@property (nonatomic, strong) UILabel *littleTitle;
/** 右边类型 or 整数   (strong) **/
@property (nonatomic, strong) UILabel *categortyLabel;
/** 返回按钮   (strong) **/
@property (nonatomic, strong) ButtonStyle *cancelBT;
/** 确定按钮   (strong) **/
@property (nonatomic, strong) ButtonStyle *addBT;
/** 确定回调   (strong) **/
@property (nonatomic, strong) addBTClick addBTClick;
/** 返回回调   (strong) **/
@property (nonatomic, strong) addBTClick cancelBTClick;
/** 临时传值用   (strong) **/
@property (nonatomic, copy)  NSString *tempStr;
/** <#行注释#>   (strong) **/
@property (nonatomic, strong) UIPickerView *pickerView_left;
@property (nonatomic, assign) id <ZTDeskPickerViewDelegate> delegate;
-(instancetype)initWithLeftArr:(NSArray *)leftArr RightArr:(NSArray *)rightArr;
- (void)showTime;
- (void)setOldShowTimeOneLeft:(NSString *)oneLeft andOneRight:(NSString *)oneRight;
@end
