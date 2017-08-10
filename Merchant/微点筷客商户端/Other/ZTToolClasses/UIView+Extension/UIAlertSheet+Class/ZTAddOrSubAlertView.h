//
//  ZTAddOrSubAlertView.h
//  微点筷客商户端
//
//  Created by Skyer God on 16/11/14.
//  Copyright © 2016年 张森森. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, ZTalertSheetStyle){
    //单个显示 只有主标题
    ZTalertSheetStyleTitle,
    //主标题，子标题
    ZTalertSheetStyleSubTitle,
    //中间是左右箭头选择
    ZTalertSheetStyleAddSubSelectTitle,
    //输入框弹出
    ZTalertSheetStyleTextFiled,
    //中间列表选择框
    ZTalertSheetStyleSingleSelectList
};
@interface ZTAddOrSubAlertView : UIView
/** 点击确定后回调  (NSString) **/
@property (nonatomic, copy) void(^complete)(BOOL);
/** 点击加减号后的回调  (NSString) **/
@property (nonatomic, copy) void(^plus)(NSInteger count);
/** style   (NSInteger) **/
/** <#行注释#>   (strong) **/
@property (nonatomic, strong) UILabel *numLabel;
- (instancetype)initWithStyle:(ZTalertSheetStyle)style ;
- (void)showView;
- (void)dismiss;

/** 标题   (strong) **/
@property (nonatomic, strong)  UILabel *titleLabel;
/** 标题下小标题   (strong) **/
@property (nonatomic, strong)  UILabel *littleLabel;
@property (nonatomic,strong)  ButtonStyle *cancelBT;
@property (nonatomic,strong) ButtonStyle *confirmBT;


/** 可选择显示空间，左右选择设置数量   (strong) **/
@property (nonatomic, strong)  UIView *addSubView;
/** leftArrow   (strong) **/
@property (nonatomic, strong) ButtonStyle *leftArrowBT;
/** rightArrow   (strong) **/
@property (nonatomic, strong) ButtonStyle *rightArrowBT;
/** 底部提示   (strong) **/
@property (nonatomic, strong) UILabel *addSubViewBottoLabel;
        /** 设置弹出输入textField **/
/** 弹出输入框   (strong) **/
@property (nonatomic, strong) UITextField *textFild;
/** 输入框完成后回调   (strong) **/
@property (nonatomic, copy) void(^textInputEnd)(NSString *text);


/** 中间列表数组   (strong) **/
@property (nonatomic, strong) NSMutableArray *singleListArr;
/** 列表选定后返回选定index  (NSString) **/ // 取消indx默认为数组个数
@property (nonatomic, copy) void(^singleSelectIndex)(NSInteger index, NSString *text);


/** 点击遮罩是否消失弹窗   (NSInteger) **/
@property (nonatomic, assign) BOOL shouldHiddenMaskView;

@end
