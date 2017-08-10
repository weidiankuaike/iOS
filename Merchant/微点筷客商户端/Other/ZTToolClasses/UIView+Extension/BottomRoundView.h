//
//  BottomRoundView.h
//  tabbar
//
//  Created by Skyer God on 2017/5/4.
//  Copyright © 2017年 weiDianKuaiKe. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^middleButtonClick)(ButtonStyle *button);
@interface BottomRoundView : UIView
/** 中间按钮点击响应   (strong) **/
@property (nonatomic, strong) middleButtonClick middleButtonClick;
/** button边距   (NSInteger) **/
@property (nonatomic, assign) NSInteger middlePadding;

- (instancetype)initWithFrame:(CGRect)frame middleIcon:(NSString *)imageIcon;
@end
