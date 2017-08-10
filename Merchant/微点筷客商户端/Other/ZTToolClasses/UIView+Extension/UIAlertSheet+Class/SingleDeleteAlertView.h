//
//  SingleDeleteAlertView.h
//  微点筷客商户端
//
//  Created by Skyer God on 16/10/27.
//  Copyright © 2016年 张森森. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef  void(^complete)();
@interface SingleDeleteAlertView : UIView
@property(nonatomic, copy) void (^complete)(BOOL);
- (instancetype)initWithParentView:(UIView *)parentView;
- (void)showView;
- (void)dismiss;

/** 标题   (strong) **/
@property (nonatomic, strong)  UILabel *titleLabel;
@end
