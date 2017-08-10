//
//  NSString+Expend.h
//  expend
//
//  Created by ZAK on 14-3-26.
//  Copyright (c) 2014年 JKZL. All rights reserved.
//
#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@interface NSString (Expend)
/**
 *  获取版本号
 */
+(NSString *)getAppVersion;


/**
 *  获取文本的高度
 *
 *  @param fontSize 多大字体
 *  @param str 内容
 *  @param range  在多大的范围内
 *
 *  @return
 */
//-(CGSize)autoLaoutsize:(UIFont *)fontSize withSize:(CGSize)range;

/**
 *  获取到文本的宽度
 *
 *  @param text
 *  @param font
 *
 *  @return
 */
//-(CGFloat)getTextWidthfont:(UIFont *)font;
/**
 *  获取文本的高度
 *
 *  @param text
 *  @param font
 *  @param width
 *
 *  @return 
 */
//-(CGFloat)getTextHeightfont:(UIFont *)font labelWidth:(CGFloat)width;
/**
 *  去掉HTML标签
 *
 *  @param html 字符串
 *
 *  @return 返回字符串
 */
-(NSString *)flattenHTML;
/**
 *  去掉内容前面的空格和回车 或者去掉空格
 *
 *  @param str
 *
 *  @return
 */
-(NSString *)removeWhitespaceAndNewlinewithboolNewLine:(BOOL)isSure;

/**
 *  md5加密
 *
 *  @param str 密码串
 *
 *  @return NSString
 */
-(NSString *)md5Hash;


/**
 *  判断是否是电话号码
 *
 *  @param mobile 字符串
 *
 *  @return Bool
 */
-(BOOL)validateMobile;
/**
 *  判断是否是数字
 *
 *  @param num 数字
 *
 *  @return bool
 */
- (BOOL)validateNum;
-(BOOL)validateCode;
-(BOOL)validateNumAndABC;
-(BOOL)validateAllNumber;

/**
 *  判断是否是数字密码
 *
 *  @param pwd
 *  @param min 个数范围
 *  @param max
 *
 *  @return 
 */

-(BOOL)validatePwdRangeMin:(int)min rangeMax:(int)max;

/**
 *  判断是否是邮箱
 *
 *  @param email
 *
 *  @return
 */
- (BOOL) validateEmail;
/**
 *  判断身份证
 *
 *  @param identityCard
 *
 *  @return 
 */
- (BOOL) validateIdentityCard;


- (BOOL)isMobileNumber:(NSString *)mobileNum;
-(BOOL)isChinese;//判断是否是纯汉字
-(BOOL)includeChinese;//判断是否含有汉字
- (BOOL)isMobileNumber;
@end
