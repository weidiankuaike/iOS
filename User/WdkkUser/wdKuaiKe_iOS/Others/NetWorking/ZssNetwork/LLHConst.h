#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
//#import "UIView+SSExtension.h"
#import "UserInfoManager.h"

#define WenZhangDianZan @"WenZhangDianZan_key"
#define WenZhangShouCang @"WenZhangShouCang_key"
#define ShangPinShouCang @"ShangPinShouCang_key"


#define BiJiDianZan @"BiJiDianZan_key"

#define HuatiDianZan @"HuatiDianZan_key"

#define LikesStateKey @"LikesStateKey_key"

#define CollectStateKey @"CollectStateKey"

// 1.判断是否为4寸屏幕
#define Screen4INCH ([UIScreen mainScreen].bounds.size.height == 480)
#define IOS_VERSION [[[UIDevice currentDevice] systemVersion] floatValue]

// 2.屏幕宽高
#define GetHeight [UIScreen mainScreen].bounds.size.height //获取屏幕高度
#define GetWidth [UIScreen mainScreen].bounds.size.width  //获取屏幕宽度

//调试抛出异常
#if 0//DEBUG
#define DEBUG_NSAssert1(condition, desc, arg1) NSAssert((condition), (desc), (arg1))
#else
#define DEBUG_NSAssert1(condition, desc, arg1)
#endif

//#define DEBUG_Log //NSLog(@"#%s##%d#",strrchr(__FILE__,'/'),__LINE__); NSLog
#if DEBUG
#define DEBUG_Log(x, ...) NSLog(x, ## __VA_ARGS__)
#else
#define DEBUG_Log(x, ...)
#endif


#define IsNull(x) ![(x) isKindOfClass:[NSNull class]] && (x) != nil
#define IsNullData(x) [(x) isKindOfClass:[NSNull class]]?@"":((x) == nil ? @"":(x))

#define WIDTH self.view.frame.size.width

// 3.获得RGB颜色
#define kColor(r, g, b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1]
#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((CGFloat)((rgbValue & 0xFF0000) >> 16))/255.0 green:((CGFloat)((rgbValue & 0xFF00) >> 8))/255.0 blue:((CGFloat)(rgbValue & 0xFF))/255.0 alpha:1.0]
#define RGBACOLOR(r,g,b,a) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:(a)]

#define View_Color kColor(236, 235, 230)
#define NavigationColor [UIColor whiteColor]
#define FontColor1 UIColorFromRGB(0xff573a)
#define FontColor2 UIColorFromRGB(0xf2f2f2)
#define FontColor3 UIColorFromRGB(0x727272)
#define FontColor4 UIColorFromRGB(0x808080)

#define NAVCOLOR [UIColor colorWithRed:0.9843 green:0.1686 blue:0.2431 alpha:1.0]

//[UIColor colorWithRed:255/255 green:19/255 blue:203/255 alpha:1]

#define HeadCatViewHeight 100

//随机色 //0到1随机色调
//arc4random_uniform(256)/255.0
#define RamdomColor [UIColor colorWithRed:arc4random_uniform(256)/255.0 green:   arc4random_uniform(256)/255.0 blue:arc4random_uniform(256)/255.0 alpha:1.0];

/**
 *  控制器背景颜色
 *
 */
#define KGlobel  UIColorFromRGB(0xf8f8f8)
/**
 *  按钮背景颜色 -->金
 */
#define JinColor UIColorFromRGB(0xb39851)
/**
 *  cell 中间行颜色
 */
#define CellHuiColor UIColorFromRGB(0xf8f8f8)

// 4.基URL
//服务器地址
//#if DEBUG
//#define kBaseURL @""
//#define kShareUrl @"http://m.dev.yizheyoupin.com/"
//#else

#define kBaseURL @"http://192.168.31.173:8081/"

#define kShareUrl @
//#endif

#define appleappleID @"1119397421"
//2.版本参数

#define app_Version [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]


// 5.登录注册加密密钥



/**
 *  首页cell顶部固定的距离
 */
UIKIT_EXTERN CGFloat const LLHHomeCellTextY;


/**
 首页cell中 赞 评论 收藏 按钮
 */
typedef enum {
    LLHCellTypeBtnZan =0,
    LLHCellTypeBtnPingLun =1,
    LLHCellTypeBtnSave =2
}LLHCellTypeBtn;


#pragma mark 支付宝相关帐号信息
 // 商户PID
#define PARTNER @
  // 商户收款账号
#define SELLER @
 //商户私钥，pkcs8格式
#define PRIVATEKEY @
// 支付宝公钥
#define RSA_PUBLIC  @

#pragma mark 友盟相关信息
#define  UMSocialAppKey  @"574e39d567e58ed3110018fb"

//友盟推送
#define UMPushAppKey  @"574e39d567e58ed3110018fb"
#define UMPushSecret @"yvizcaa2vm94sczbqsfdz1xivsc4vkas"



#define SaoYiSaoAlarmData @"SaoYiSaoAlarmData_Act"

#define USERPHOTODATA @"USERPHOTODATA_Data"


#define QQQQ @"2851152893"
#define PhonePhone @"0592-5935072"




