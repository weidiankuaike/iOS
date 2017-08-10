//
//  ButtonStyle.h
//  merchantClient
//
//  Created by Skyer God on 2017/7/20.
//  Copyright © 2017年 张甜. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ButtonStyle : UIButton
typedef NS_ENUM(NSUInteger, ZTButtonStyle) {
    ZTButtonStyleNormal,
    ZTButtonStyleTextLeftImageRight,
    ZTButtonStyleTextBottomImageTopNormal,
    ZTButtonStyletextBottomIamgeTopCircle,
};
/** 图片显示位置   (NSInteger) **/
@property (nonatomic, assign) NSUInteger ztButtonStyle;
/** 图右字左 图字间距   (cgfloat) **/
@property (nonatomic, assign) CGFloat textToImageSapce;
@end
