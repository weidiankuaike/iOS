//
//  UIView+DrawLayer.h
//  微点筷客商户端
//
//  Created by Skyer God on 2017/5/19.
//  Copyright © 2017年 张森森. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (DrawLayer)
/**
 ** lineView:       需要绘制成虚线的view
 ** lineLength:     虚线的宽度
 ** lineSpacing:    虚线的间距
 ** lineColor:      虚线的颜色
 **/
- (void)drawDashLine:(UIView *)lineView lineLength:(int)lineLength lineSpacing:(int)lineSpacing lineColor:(UIColor *)lineColor;
@end
