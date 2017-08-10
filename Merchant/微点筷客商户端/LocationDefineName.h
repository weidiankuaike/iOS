//
//  LocationDefineName.h
//  微点筷客商户端
//
//  Created by Skyer God on 2017/5/11.
//  Copyright © 2017年 张森森. All rights reserved.
//

#ifndef LocationDefineName_h
#define LocationDefineName_h

/********************************************************************************************************/
/**************＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊    快捷方法定义    ＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊**************/
/********************************************************************************************************/
#ifdef DEBUG
#define NULLSAFE_ENABLED 1
#endif

#ifdef kScreenWidth
#endif
#ifndef kScreenWidth
#define kScreenWidth [UIScreen mainScreen].bounds.size.width
#endif

#ifdef kScreenHeight
#endif
#ifndef kScreenHeight
#define kScreenHeight  [UIScreen mainScreen].bounds.size.height
#endif
#define autoScaleW(width) (kScreenWidth / 375 * width)
#define autoScaleH(height)  (kScreenHeight / 667 * height)

//#define autoScaleW(w) w * CGRectGetWidth([UIScreen mainScreen].bounds) / 375
//#define autoScaleH(h) h * CGRectGetHeight([UIScreen mainScreen].bounds) / 667


#define IsNull(x) ![(x) isKindOfClass:[NSNull class]] && (x) != nil
#define IsNullData(x) [(x) isKindOfClass:[NSNull class]]?@"":((x) == nil ? @"":(x))

//RGB颜色
#define RGBA(r, g, b, a)                    [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:a]

#define RGB(r, g, b)                        RGBA(r, g, b, 1.0f)

#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((CGFloat)((rgbValue & 0xFF0000) >> 16))/255.0 green:((CGFloat)((rgbValue & 0xFF00) >> 8))/255.0 blue:((CGFloat)(rgbValue & 0xFF))/255.0 alpha:1.0]

#define isPadd (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)

#define pxFontSize(fontSize)  autoScaleW((floor((fontSize) / 2.0f)) + 2)//autoScaleW((floor(fonSize)) / 96.0f * 72.0f)
#define pxSizeW(width) autoScaleW((floor((width) / 2.0f)))
#define pxSizeH(height) autoScaleW((floor((height) / 2.0f)))
/********************************************************************************************************/
/**************＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊    网络环境配置    ＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊**************/
/********************************************************************************************************/

//判断是否是本地访问  0 程服务器 1 本地局域网
#define isLocationConnect 0
#define netTimeoutInterval 10.0f
//本地测试地址
#define LocaltionURL @"http://192.168.31.2:8083/" //LHJ
//#define LocaltionURL @"http://192.168.31.3:8083/" //ZK
//#define LocaltionURL @"http://192.168.31.4:8082/" //ST
//#define tempURL @"http://192.168.31.3:8083/" //ZK

//远程访问地址
#define kBaseURL @"https://api.wdkk.mobi/"

/********************************************************************************************************/
/**************＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊     三方API／SDK配置   ＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊*************/
/********************************************************************************************************/
#define godKey @"9058bbd5b4494c9ab4d76f9ce81d1190"
#define TXYTBucket @"imgshop"   
#define TXYTAppid @"1252398168"

/********************************************************************************************************/
/**************＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊     抽屉页面默宽    ＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊**************/
/********************************************************************************************************/

#define LeftWidth autoScaleW(280)
/********************************************************************************************************/
/**************＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊    项目共用参数宏定义   ＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊**************/
/********************************************************************************************************/

//注：验证码登录，密码登录，入驻完成，查看审核进度。这四个借口如若请求，均重置下面四个宏定义
#define wdkkVersion [NSString stringWithFormat:@"微点筷客 V%@", [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"]]
#define _loginInfoDic  [NSKeyedUnarchiver unarchiveObjectWithData:[[NSUserDefaults standardUserDefaults] objectForKey:LocationLoginInResultsKey]]
#define _BaseModel  [LoginInfoModel mj_objectWithKeyValues:_loginInfoDic]
#define LoginName [[NSUserDefaults standardUserDefaults] objectForKey:@"loginName"]
#define TOKEN [[NSUserDefaults standardUserDefaults] objectForKey:@"token"]
#define TAX [[NSUserDefaults standardUserDefaults] objectForKey:@"wdkkTax"]
#define storeID _BaseModel.storeBase.id
#define UserId _BaseModel.id
#define tempStoreID storeID
#define tempUserID userId
#define TempKitchStatus @"1"  //应老板要求，一版强制关闭后厨。 如若开启，修改为1


#ifdef DEBUG
#define ZTString [NSString stringWithFormat:@"%s", __FILE__].lastPathComponent
#define ZTLog(...) printf("%s 第%d行: %s\n\n", [ZTString UTF8String] ,__LINE__, [[NSString stringWithFormat:__VA_ARGS__] UTF8String]);

#else
#define ZTLog(...)
#endif
#endif /* PrefixHeader_pch */

//强弱引用转换
#ifndef weakify
#if DEBUG
#if __has_feature(objc_arc)
#define weakify(object) autoreleasepool{} __weak __typeof__(object) weak##_##object = object;
#else
#define weakify(object) autoreleasepool{} __block __typeof__(object) block##_##object = object;
#endif
#else
#if __has_feature(objc_arc)
#define weakify(object) try{} @finally{} {} __weak __typeof__(object) weak##_##object = object;
#else
#define weakify(object) try{} @finally{} {} __block __typeof__(object) block##_##object = object;
#endif
#endif
#endif

#ifndef strongify
#if DEBUG
#if __has_feature(objc_arc)
#define strongify(object) autoreleasepool{} __typeof__(object) object = weak##_##object;
#else
#define strongify(object) autoreleasepool{} __typeof__(object) object = block##_##object;
#endif
#else
#if __has_feature(objc_arc)
#define strongify(object) try{} @finally{} __typeof__(object) object = weak##_##object;
#else
#define strongify(object) try{} @finally{} __typeof__(object) object = block##_##object;
#endif
#endif



#endif /* LocationDefineName_h */
