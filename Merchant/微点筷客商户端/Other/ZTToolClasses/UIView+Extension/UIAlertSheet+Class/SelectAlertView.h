//
//  SelectAlertView.h
//  微点筷客商户端
//
//  Created by Skyer God on 16/10/27.
//  Copyright © 2016年 张森森. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SelectAlertView : UIView
/** 点击确定后回调  (NSString) **/
@property (nonatomic, copy) void(^complete)(BOOL);
- (instancetype)initWithParentView:(UIView *)parentView;
- (void)showView;
- (void)dismiss;

/** 标题   (strong) **/
@property (nonatomic, strong)  UILabel *titleLabel;
/** 标题下小标题   (strong) **/
@property (nonatomic, strong)  UILabel *littleLabel;
@property (nonatomic,strong)  ButtonStyle *cancelBT;
@property (nonatomic,strong) ButtonStyle *confirmBT;
@end
