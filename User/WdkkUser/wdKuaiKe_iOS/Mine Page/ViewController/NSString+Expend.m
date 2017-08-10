//
//  NSString+Expend.m
//  expend
//
//  Created by ZAK on 14-3-26.
//  Copyright (c) 2014年 JKZL. All rights reserved.
//

#import "NSString+Expend.h"
#import <CommonCrypto/CommonDigest.h>
#import <ifaddrs.h>
#import <arpa/inet.h>
@implementation NSString (Expend)



#pragma mark 判断版本号是否需要更新
- (BOOL)needUpDataWithNow:(NSString*)nowVersion WithNew:(NSString*)newVersion
{
    if ([newVersion compare:nowVersion options:NSNumericSearch] == NSOrderedDescending){
        return YES;
    }
    else{
        return NO;
    }
}


+(NSString *)getAppVersion
{
    return [[[NSBundle mainBundle] infoDictionary] objectForKey:(NSString *)kCFBundleVersionKey];
}



//-(CGSize)autoLaoutsize:(UIFont *)fontSize withSize:(CGSize)range {
//    if ([[UIDevice currentDevice].systemVersion floatValue] >= 7.0) {
//        CGRect rect =  [self boundingRectWithSize:range options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:[NSDictionary dictionaryWithObjectsAndKeys:fontSize,NSFontAttributeName, nil] context:nil];
//        return rect.size;
//    }
//    else {
////        CGSize size = [self sizeWithFont:fontSize constrainedToSize:range lineBreakMode:NSLineBreakByWordWrapping];
////        
////        
////       
////        
////        return size;
//    }
//}

//-(CGFloat)getTextWidthfont:(UIFont *)font
//{
//    CGSize size = [self autoLaoutsize:font withSize:CGSizeMake(MAXFLOAT, MAXFLOAT)];
//    return size.width;
//}
//
//-(CGFloat)getTextHeightfont:(UIFont *)font labelWidth:(CGFloat)width
//{
//    CGSize size = [self autoLaoutsize:font withSize:CGSizeMake(width, MAXFLOAT)];
//    return size.height;
//}

- (NSString *)md5Hash
{
    const char *cStr = [self UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
//    NSData *data = [NSData dataWithBytes:cStr length:self.length];
    CC_MD5(cStr, (unsigned int)strlen(cStr), result); // This is the md5 call
    
    return [NSString stringWithFormat:
            @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
            result[0], result[1], result[2], result[3],
            result[4], result[5], result[6], result[7],
            result[8], result[9], result[10], result[11],
            result[12], result[13], result[14], result[15]
            ];
}

- (NSString *)flattenHTML {
    NSString *htmlStr = [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    NSScanner *theScanner;
    NSString *text = nil;
    theScanner = [NSScanner scannerWithString:htmlStr];
    while ([theScanner isAtEnd] == NO) {
        [theScanner scanUpToString:@"<" intoString:NULL] ;
        [theScanner scanUpToString:@">" intoString:&text] ;
        
        htmlStr = [htmlStr stringByReplacingOccurrencesOfString:
                [ NSString stringWithFormat:@"%@>", text]
                                               withString:@""];
        
    }
    return htmlStr;
    
}
-(NSString *)removeWhitespaceAndNewlinewithboolNewLine:(BOOL)isSure
{
    if (isSure) {
        return [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    }else
    {
        return [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    }
}


-(BOOL)validateNum
{
    return [[NSPredicate predicateWithFormat:@"SELF MATCHES %@",@"^([\\d.])$"] evaluateWithObject:self];
}



//判断用户名不能以数字+_
-(BOOL)validateUserName
{
    return [[NSPredicate predicateWithFormat:@"SELF MATCHES %@",@"/^(?![\\d_]*$)[\\p{L}\\d_]+$/"] evaluateWithObject:self];
    
}
-(BOOL)validateNumAndABC
{
    return [[NSPredicate predicateWithFormat:@"SELF MATCHES %@",@"^([0-9A-Za-z_])$"] evaluateWithObject:self];
}

-(BOOL)validateCode
{
    return [[NSPredicate predicateWithFormat:@"SELF MATCHES %@",@"\\d{6}"] evaluateWithObject:self];
}
-(BOOL)validateAllNumber
{

    NSScanner* scan = [NSScanner scannerWithString:self];
    
    NSInteger val;
    
    return[scan scanInteger:&val] && [scan isAtEnd];
}
//判断是否为浮点形：
- (BOOL)isPureFloat:(NSString*)string{
    
    NSScanner* scan = [NSScanner scannerWithString:string];
    
    float val;
    
    return[scan scanFloat:&val] && [scan isAtEnd];
    
}

- (BOOL)validateMobile
{
    //手机号以13， 15，18开头，八个 \d 数字字符
    NSRange range = [self rangeOfString:@"-"];
    NSString *mobileStr = self;
    if (range.location != NSNotFound) {
        mobileStr = [self stringByReplacingOccurrencesOfString:@"-" withString:@""];
    }
    
    NSString *phoneRegex = @"^1[34578][0-9]{9}$";
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",phoneRegex];
    return [phoneTest evaluateWithObject:mobileStr];
}

-(BOOL)validatePwdRangeMin:(int)min rangeMax:(int)max
{
    NSString *pwdRegex = [NSString stringWithFormat:@"(^[0-9A-Za-z]{%d,%d}$)",min,max] ;
    NSPredicate *pwdTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",pwdRegex];
    
    return [pwdTest evaluateWithObject:self];
}



-(BOOL)validateEmail
{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:self];
}

-(BOOL)validateIdentityCard
{
    BOOL flag;
    if (self.length <= 0) {
        flag = NO;
        return flag;
    }
    NSString *regex2 = @"^(\\d{14}|\\d{17})(\\d|[xX])$";
    NSPredicate *identityCardPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex2];
    return [identityCardPredicate evaluateWithObject:self];
}


- (BOOL) validateUrl: (NSString *) url {
    NSString *theURL =
    @"(http|https)://((\\w)*|([0-9]*)|([-|_])*)+([\\.|/]((\\w)*|([0-9]*)|([-|_])*))+";
    NSPredicate *urlTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", theURL];
    return [urlTest evaluateWithObject:url];
}
// 正则判断手机号码地址格式
- (BOOL)isMobileNumber:(NSString *)mobileNum {
    
    //    电信号段:133/153/180/181/189/177
    //    联通号段:130/131/132/155/156/185/186/145/176
    //    移动号段:134/135/136/137/138/139/150/151/152/157/158/159/182/183/184/187/188/147/178
    //    虚拟运营商:170
    
    NSString *MOBILE = @"^1(3[0-9]|4[57]|5[0-35-9]|8[0-9]|7[06-8])\\d{8}$";
    
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
    
    return [regextestmobile evaluateWithObject:mobileNum];
}
// 正则判断手机号码地址格式
- (BOOL)isMobileNumber {
    
    //    电信号段:133/153/180/181/189/177
    //    联通号段:130/131/132/155/156/185/186/145/176
    //    移动号段:134/135/136/137/138/139/150/151/152/157/158/159/182/183/184/187/188/147/178
    //    虚拟运营商:170
    
    NSString *MOBILE = @"^1(3[0-9]|4[57]|5[0-35-9]|8[0-9]|7[06-8])\\d{8}$";
    
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
    
    return [regextestmobile evaluateWithObject:self];
}

- (BOOL)isChinese
{
    NSString *match = @"(^[u4e00-u9fa5]+$)";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF matches %@", match];
    return [predicate evaluateWithObject:self];
}
- (BOOL)includeChinese
{
    for(int i=0; i< [self length];i++) {
        int a =[self characterAtIndex:i];
        if( a >0x4e00&& a <0x9fff){ return YES;
        }
    }
    return NO;
}
@end
