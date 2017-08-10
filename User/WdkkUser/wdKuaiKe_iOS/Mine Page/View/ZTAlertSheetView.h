//
//  ZTAlertSheetView.h
//  微点筷客商户端
//
//  Created by Skyer God on 16/10/28.
//  Copyright © 2016年 张森森. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZTAlertSheetView : UIView
/** 处理回调  (NSString) **/
@property (nonatomic, copy) void(^alertSheetReturn)(NSInteger count);
        /** 只需调用以下两个方法 **/
- (instancetype)initWithTitleArray:(NSArray *)array;
- (void)showView;
@end
