//
//  UIBarButtonItem+SSExtension.m
//  WDKKtest
//
//  Created by 张森森 on 16/8/3.
//  Copyright © 2016年 weiDianKuaiKe. All rights reserved.
//

#import "UIBarButtonItem+SSExtension.h"
#import "UIView+SSExtension.h"
#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((CGFloat)((rgbValue & 0xFF0000) >> 16))/255.0 green:((CGFloat)((rgbValue & 0xFF00) >> 8))/255.0 blue:((CGFloat)(rgbValue & 0xFF))/255.0 alpha:1.0]
@implementation UIBarButtonItem (SSExtension)
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
+(UIBarButtonItem *)itemWithTarget:(id)target Action:(SEL)action image:(NSString *)image selectImage:(NSString *)selectImage
{
    ButtonStyle  *btn=[ButtonStyle buttonWithType:UIButtonTypeCustom];
    [btn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    //设置图片
    [btn setImage:[UIImage imageNamed:image] forState:UIControlStateNormal];
    [btn setImage:[UIImage imageNamed:selectImage] forState:UIControlStateHighlighted];
    //设置尺寸
    btn.size=CGSizeMake(btn.currentImage.size.width * 1.6, btn.currentImage.size.height);
    return [[UIBarButtonItem alloc]initWithCustomView:btn];
}
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
+(UIBarButtonItem *)itemWithTarget:(id)target Action:(SEL)action andTitle:(NSString *)title image :(NSString *)image selectImage:(NSString *)selectImage
{
    ButtonStyle  *btn=[ButtonStyle buttonWithType:UIButtonTypeCustom];
    [btn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    
    //设置图片
    [btn setImage:[UIImage imageNamed:image] forState:UIControlStateNormal];
    [btn setImage:[UIImage imageNamed:selectImage] forState:UIControlStateHighlighted];
    btn.titleLabel.font =[UIFont systemFontOfSize:autoScaleW(15)];
    [btn setTitle:title forState:UIControlStateNormal];
//    [btn setTitleColor:[UIColor redColor] forState:UIControlStateHighlighted];
//    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    //设置尺寸
    btn.size=CGSizeMake(70,40);
    //设置按钮居左
//    btn.contentHorizontalAlignment=UIControlContentHorizontalAlignmentLeft;
    btn.contentEdgeInsets=UIEdgeInsetsMake(0, -10, 0, 0);
    
    return [[UIBarButtonItem alloc]initWithCustomView:btn];
    
}
+(UIBarButtonItem *)itemWithTarget:(id)target Action:(SEL)action andTitle:(NSString *)title
{
    ButtonStyle  *btn=[ButtonStyle buttonWithType:UIButtonTypeCustom];
    [btn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    
    [[btn titleLabel] setFont:[UIFont systemFontOfSize:autoScaleW(13)]];
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    //    CGRect buttonFrame = [btn frame];
    CGSize textSize=[title boundingRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16]} context:nil].size;
    //    buttonFrame.size.width = textSize.width + 24.0;
    //    buttonFrame.size.height = 30.0;
    btn.size = CGSizeMake(textSize.width+10, 30);
    [btn setTitle:title forState:UIControlStateNormal];
    
    return [[UIBarButtonItem alloc]initWithCustomView:btn];
}
@end
