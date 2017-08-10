//
//  UIViewClassHandleTools.h
//  merchantClient
//
//  Created by Skyer God on 2017/7/26.
//  Copyright © 2017年 张甜. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UIViewClassHandleTools : NSObject
/**
 *  截取view中某个区域生成一张图片
 *
 *  @param view  view description
 *  @param scope 需要截取的view中的某个区域frame
 *
 *  @return image
 */
+ (UIImage *)shotWithView:(UIView *)view scope:(CGRect)scope;
/**
 *  截取view生成一张图片
 *
 *  @param view view description
 *
 *  @return image
 */
+ (UIImage *)shotWithView:(UIView *)view;

/**
 *  获取图片的主色
 *
 *  @param image image
 *  @param scale 精准度0.1~1
 *
 *  @return 图片的主要颜色
 */
+ (UIColor *)mostColor:(UIImage *)image scale:(CGFloat)scale;
/**
 *  获取图片上一个点的颜色
 *
 *  @param point 点击的点的位置
 *  @param image image
 *  @param rect  点击的区域
 *
 *  @return 返回点击点的颜色
 */
+ (UIColor *)colorAtPixel:(CGPoint)point UIImage:(UIImage *)image CGRect:(CGRect)rect;
// 裁剪图片
+ (UIImage *)imageFromImage:(UIImage *)image inRect:(CGRect)rect;
/**
 *  缩放图片
 *
 *  @param img  image
 *  @param size 缩放后的大小
 *
 *  @return image
 */
+ (UIImage *)scaleToSize:(UIImage *)img size:(CGSize)size;
@end
