//
//  UIBarButtonItem+SSExtension.h
//  WDKKtest
//
//  Created by 张森森 on 16/8/3.
//  Copyright © 2016年 weiDianKuaiKe. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIBarButtonItem (SSExtension)

/**
 *  创建一个item
 *
 *  @param target      点击item后调用哪个对象的方法
 *  @param action      点击item后调用target
 *  @param image       图片
 *  @param selectImage 高亮图片
 *
 *  @return 返回一个item
 */
+(UIBarButtonItem *)itemWithTarget:(id)target Action:(SEL)action image:(NSString *)image selectImage:(NSString *)selectImage;
/**
 *  创建一个item，带有标题
 *
 *  @param target      点多Item后调用的对象方法
 *  @param action      点击item调用的target
 *  @param title       item的标题
 *  @param image       item的图片
 *  @param selectImage 高亮图片
 *
 *  @return 返回一个Item
 */
+(UIBarButtonItem *)itemWithTarget:(id)target Action:(SEL)action andTitle:(NSString *)title image:(NSString *)image selectImage:(NSString *)selectImage;

+(UIBarButtonItem *)itemWithTarget:(id)target Action:(SEL)action andTitle:(NSString *)title;

@end
