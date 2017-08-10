//
//  NSString+ZTExtension.h
//  微点筷客商户端
//
//  Created by Skyer God on 17/2/7.
//  Copyright © 2017年 张森森. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (ZTExtension)
- (NSString *)deleteTabOrSpaceStr;
//拼接body字典
- (NSArray *)getUrlTransToPostUrlArray;
//截取字符串
- (NSString *)subStringFrom:(NSString *)startString to:(NSString *)endString;
- (NSString *)subStringFromString:(NSString *)startString;
- (NSString *)subStringToString:(NSString *)endString;
/**
 *返回值是该字符串所占的大小(width, height)
 *font : 该字符串所用的字体(字体大小不一样,显示出来的面积也不同)
 *maxSize : 为限制改字体的最大宽和高(如果显示一行,则宽高都设置为MAXFLOAT, 如果显示为多行,只需将宽设置一个有限定长值,高设置为MAXFLOAT)
 */
- (CGSize)sizeWithFontSize:(CGFloat )fontSize maxSize:(CGSize)maxSize;
- (CGSize )calculateStringWithFontSize:(CGFloat )fontSize;
//约束宽度 计算高度
- (CGSize)sizeWithFont:(UIFont *)font constrainedToWidth:(CGFloat)width;
@end
