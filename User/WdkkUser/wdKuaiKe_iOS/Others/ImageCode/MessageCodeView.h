//
//  MessageCodeView.h
//  微点筷客商户端
//
//  Created by Skyer God on 2017/5/6.
//  Copyright © 2017年 张森森. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MessageCodeView : UIView

/** 点击确定后回调  (NSString) **/
@property (nonatomic, copy) void(^complete)(NSString *code);
@property (nonatomic,strong)  UIButton *cancelBT;
@property (nonatomic,strong) UIButton *confirmBT;
- (void)showView;
@end