 //
//  QYXNetTool.m
//  OpenYourEyes
//
//  Created by dllo on 16/6/6.
//  Copyright © 2016年 Google AdWords. All rights reserved.
//



#import "QYXNetTool.h"
#import <CommonCrypto/CommonCrypto.h>
#import "SecurityUtil.h"
#import "MBProgressHUD+SS.h"
#import "DeviceSet.h"
#import "ViewController.h"
#import "XGPush.h"
#import "ZT3DesSecurity.h"
#import "NSData+AES.h"
#import "SecurityUtil.h"
#import "ReloadVIew.h"
@implementation QYXNetTool
#pragma mark -- Get数据请求

+(QYXNetTool *)shareManager{
    static QYXNetTool *shareNetworkSingleton = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{

        shareNetworkSingleton = [[self alloc] init];

    });
    return shareNetworkSingleton;
}
- (void)getNetWithUrl:(NSString *)url urlBody:(id)body header:(NSDictionary *)header response:(QYXResponseStyle)response success:(BLOCKOFSuccess)success failure:(BLOCKOFFailure)failure
{
    url = [url deleteTabOrSpaceStr];
    [[ReloadVIew defaultReloadVew] refreshNowNetRequiringViewController];
    //创建网络管理者:
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer.timeoutInterval = netTimeoutInterval;
    //请求头的设置:
    if (header) {
        for (NSString *key in header.allKeys) {
            [manager.requestSerializer setValue:header[key] forHTTPHeaderField:key];
        }
    }
    [manager.requestSerializer setValue:@"application/x-www-form-urlencoded;charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    //设置返回数据的类型:
    switch (response) {
        case QYXJSON:
        {
            manager.responseSerializer = [AFJSONResponseSerializer serializer];
            AFJSONResponseSerializer *jsonResponse = [[AFJSONResponseSerializer alloc] init];
            jsonResponse.removesKeysWithNullValues = YES;
        }
            break;
        case QYXXML:
            manager.responseSerializer = [AFXMLParserResponseSerializer serializer];
            break;
        case QYXDATA:
            manager.responseSerializer = [AFHTTPResponseSerializer serializer];
            break;
        default:
            break;
    }
    //设置响应数据类型:
    [manager.responseSerializer setAcceptableContentTypes:[NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html",@"text/css",@"text/plain", @"application/javascript",@"image/jpeg", @"text/vnd.wap.wml", nil]];
    //转码:iOS9-----新改的

//    url = [url stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];


    NSString *cacheFile = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES).firstObject;

    // MD5
    NSString *theurl = [QYXNetTool cachedFileNameForKey:url];

    NSString *cachePath = [cacheFile stringByAppendingPathComponent:theurl];
    //发送请求:
    [SVProgressHUD setMinimumDismissTimeInterval:1];

    [manager GET:url parameters:body progress:^(NSProgress * _Nonnull downloadProgress) {

    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        //获取cookie
        NSArray *cookies = [[NSHTTPCookieStorage sharedHTTPCookieStorage]cookiesForURL:[NSURL URLWithString:url]];
        for (NSHTTPCookie *tempCookie in cookies)
        {
            //打印cookies
            ZTLog(@"getCookie:%@", tempCookie);
        }
        NSDictionary *Request = [NSHTTPCookie requestHeaderFieldsWithCookies:cookies];

        NSUserDefaults *userCookies = [NSUserDefaults standardUserDefaults];
        [userCookies setObject:[Request objectForKey:@"Cookie"] forKey:@"mUserDefaultsCookie"];
        [userCookies synchronize]; 
        BOOL isCache = [NSKeyedArchiver archiveRootObject:responseObject toFile:cachePath];
        if (isCache) {
            //            NSLog(@"缓存成功");
        }
        if ([responseObject isKindOfClass:[NSData class]]) {
            success(responseObject);
            return ;
        }
        NSString *msgType = responseObject[@"msgType"];
        NSString *msg = responseObject[@"msg"];

        if ([msgType integerValue] !=1 || [url containsString:@"api/merchant/numberQueueManage"]) {
            if ([msgType integerValue] == 2000) {
                [self shouldReturnResponseObject:msgType msg:msg againURL:url againRequire:^(id result) {
                    success(result);
                    [MBProgressHUD hideHUD];
                }];

            } else if ([self shouldReturnResponseObject:msgType msg:msg againURL:url againRequire:nil]){
                success(responseObject);
                [MBProgressHUD hideHUD];
                //                [SVProgressHUD dismiss];
            }
        } else if ([msgType integerValue ] == 1){
            success(responseObject);
            [MBProgressHUD hideHUD];
            //            [MBProgressHUD showMessage:@"操作异常"];
        } else;

    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
        //        NSLog(@"%@", error);

        id data = [NSKeyedUnarchiver unarchiveObjectWithFile:cachePath];
        //        NSLog(@"有缓存!");

        if (![url containsString:@"merchant/login?loginName="]) {
            [[ReloadVIew defaultReloadVew] captureURL:url complete:^(BOOL success) {
                [self reRequireUrl:url againRequire:nil];
            }];
            [[ReloadVIew defaultReloadVew] showView];
        }
        if (data != NULL && ![url containsString:@"merchant/login?loginName="]) {
//            [SVProgressHUD showErrorWithStatus:@"网络异常"];
//            success(data);
        }
    }];
}
//词典转换为字符串

- (NSString*)dictionaryToJson:(NSDictionary *)dic
{

    NSError *parseError = nil;

    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:&parseError];

    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];

}
#pragma mark -- Post数据请求
- (void)postNetWithUrl:(NSString *)url urlBody:(id)body bodyStyle:(QYXRequestStyle)bodyStyle header:(NSDictionary *)header response:(QYXResponseStyle)response success:(BLOCKOFSuccess)success failure:(BLOCKOFFailure)failure {
    //************* #pragma mark －－ 为了本地测试 截取远程访问，改为本地访问 －－－本地 开始－－－ ************//#%<>[\\]^`{|}\"]
    url = [url deleteTabOrSpaceStr];
    NSArray *postArr = [url getUrlTransToPostUrlArray];
    url = [postArr firstObject];
    body = [postArr lastObject];

    if (isLocationConnect) {
        NSArray *tempArr = [url componentsSeparatedByString:@".mobi/"];
        NSString *locationUrl = [NSString stringWithFormat:@"%@%@?%@", LocaltionURL, [tempArr lastObject], body];
        [self getNetWithUrl:locationUrl urlBody:nil header:nil response:QYXJSON success:^(id result) {
            success(result);
        } failure:^(NSError *error) {
            failure(error);
        }];
    } else {
        //************* #pragma mark －－ 为了本地测试 截取远程访问，改为本地访问 －－－本地 结束－－远程开始－ ************//
        //    body = [self dictionaryToJson:body];
        //    body = [SecurityUtil encryptAESData:str];
        //创建网络管理者:
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        manager.requestSerializer.timeoutInterval = netTimeoutInterval;
        //设置body数据类型:
        [manager.requestSerializer setValue:@"application/x-www-form-urlencoded;charset=utf-8" forHTTPHeaderField:@"Content-Type"];
        switch (bodyStyle) {
            case QYXBodyJSON:
                manager.requestSerializer = [AFJSONRequestSerializer serializer];
                break;
            case QYXBodyString:
                manager.responseSerializer = [AFHTTPResponseSerializer serializer];
                [manager.requestSerializer setQueryStringSerializationWithBlock:^NSString * _Nonnull(NSURLRequest * _Nonnull request, id  _Nonnull parameters, NSError * _Nullable * _Nullable error) {
                    return parameters;
                }];
                break;
            default:
                break;
        }
        //请求头的设置:

        if (header) {
            for (NSString *key in header.allKeys) {
                [manager.requestSerializer setValue:header[key] forHTTPHeaderField:key];
            }
        }
        //设置返回数据的类型:
        switch (response) {
            case QYXJSON:
            {
                manager.responseSerializer = [AFJSONResponseSerializer serializer];
                AFJSONResponseSerializer *jsonResponse = [[AFJSONResponseSerializer alloc] init];
                jsonResponse.removesKeysWithNullValues = YES;
            }
                break;
            case QYXXML:
                manager.responseSerializer = [AFXMLParserResponseSerializer serializer];
                break;
            case QYXDATA:
                manager.responseSerializer = [AFHTTPResponseSerializer serializer];
                break;
            default:
                break;
        }
        //设置响应数据类型:
        [manager.responseSerializer setAcceptableContentTypes:[NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html",@"text/css",@"text/plain", @"application/javascript",@"image/jpeg", @"text/vnd.wap.wml",nil]];
        //转码:iOS9-----新改的

        url = [url stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
        NSString *againURL = [NSString stringWithFormat:@"%@?%@", url, body];
        //    NSString *cerPath = [[NSBundle mainBundle] pathForResource:@"api.wdkk.mobi" ofType:@"cer"];
        //    NSData *certData = [NSData dataWithContentsOfFile:cerPath];
        //AFSSLPinningModeNone 这个模式表示不做 SSL pinning，只跟浏览器一样在系统的信任机构列表里验证服务端返回的证书。若证书是信任机构签发的就会通过，若是自己服务器生成的证书，这里是不会通过的。
        //AFSSLPinningModeCertificate 这个模式表示用证书绑定方式验证证书，需要客户端保存有服务端的证书拷贝，这里验证分两步，第一步验证证书的域名/有效期等信息，第二步是对比服务端返回的证书跟客户端返回的是否一致。
        //AFSSLPinningModePublicKey 这个模式同样是用证书绑定方式验证，客户端要有服务端的证书拷贝，只是验证时只验证证书里的公钥，不验证证书的有效期等信息。只要公钥是正确的，就能保证通信不会被窃听，因为中间人没有私钥，无法解开通过公钥加密的数据。
        manager.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeCertificate];
        //    [manager.securityPolicy setValidatesDomainName:YES];
        manager.securityPolicy.allowInvalidCertificates = YES;
        //    [manager.securityPolicy setPinnedCertificates: [NSSet setWithObject:certData]];

        //发送请求:
        //            NSString * urls = [self returnHttpUrlString:url];

        [manager POST:url parameters:body progress:^(NSProgress * _Nonnull downloadProgress) {

        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {


            //                    NSString * string = [[NSString alloc]initWithData:responseObject encoding:4];
            //            //        string  = [SecurityUtil decryptAESData:string];
            //
            //                    NSData * datt = [string dataUsingEncoding:4];
            //                    NSDictionary * dict =[NSJSONSerialization JSONObjectWithData:datt options:NSJSONReadingMutableContainers error:nil];
            NSString *msgType = responseObject[@"msgType"];
            NSString *msg = responseObject[@"msg"];
            if ([msgType integerValue] == 2000) {
                [self shouldReturnResponseObject:msgType msg:msg againURL:againURL againRequire:^(id result) {
                    success(result);
                }];
            } else if ([self shouldReturnResponseObject:msgType msg:msg againURL:againURL againRequire:nil]) {
                success(responseObject);
            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            failure(error);
            ZTLog(@"%@", error);
            [MBProgressHUD hideHUD];
            [SVProgressHUD dismiss];
            if (![url containsString:@"merchant/login?loginName="]) {
                [[ReloadVIew defaultReloadVew] captureURL:url complete:^(BOOL success) {

                }];
                [[ReloadVIew defaultReloadVew] showView];
            }
        }];
    }
}
//判断状态吗
- (BOOL)shouldReturnResponseObject:(NSString *)msgType msg:(NSString *)msg againURL:(NSString *)againURL againRequire:(BLOCKOFSuccess)againSuccess{
    //怪我咯，我特么也不知道一大堆状态吗代表啥
    NSArray *msgTypeStatusArr = @[@"2000", @"1001", @"1002", @"1003", @"1004", @"1005", @"1006", @"1007"];
    if ([msgTypeStatusArr containsObject:msgType] && ![againURL containsString:@"merchant/login"]) {

        if ([msgType integerValue ] == 2000) {
            NSUserDefaults *userD = [NSUserDefaults standardUserDefaults];
            [userD setValue:@"error" forKey:LocationLoginInResultsKey];
            [userD setValue:@"error" forKey:@"token"];
            [SVProgressHUD showInfoWithStatus:@"登录过期，请重新登录"];
            [XGPush delAccount:^{

            } errorCallback:^{

            }];
            ViewController *rootViewController = [[ViewController alloc] init];
            UINavigationController *navi = [[UINavigationController alloc] initWithRootViewController:rootViewController];
            [UIApplication sharedApplication].keyWindow.rootViewController = navi;
            //            [self resetTokenAndRequireTheFailureUrlAgain:againURL againRequire:^(id result) {
            //                againSuccess(result);
            //            }];
        } else {
            [MBProgressHUD showError:msg];
        }
        return NO;
    } else {
        return YES;
    }
}
-(NSString *)returnHttpUrlString:(NSString *)api
{
    NSMutableString *urlStr = [[NSMutableString alloc]initWithString:kBaseURL];
    if (![urlStr hasSuffix:@"/"]) {
        [urlStr appendString:@"/"];
    }
    if (api) {
        [urlStr appendFormat:@"%@?",api];
    }
    return urlStr;
}
+ (NSString *)cachedFileNameForKey:(NSString *)key {
    const char *str = [key UTF8String];
    if (str == NULL) {
        str = "";
    }
    unsigned char r[CC_MD5_DIGEST_LENGTH];
    CC_MD5(str, (CC_LONG)strlen(str), r);
    NSString *filename = [NSString stringWithFormat:@"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
                          r[0], r[1], r[2], r[3], r[4], r[5], r[6], r[7], r[8], r[9], r[10], r[11], r[12], r[13], r[14], r[15]];
    return filename;
}
//重新加载Url
- (void)reRequireUrl:(NSString *)againUrl againRequire:(BLOCKOFSuccess)againSuccess{

#if isLocationConnect

    [[QYXNetTool shareManager] getNetWithUrl:againUrl urlBody:nil header:nil response:QYXJSON success:^(id result) {
#else
    [[QYXNetTool shareManager] postNetWithUrl:againUrl urlBody:nil bodyStyle:QYXBodyString header:nil response:QYXJSON success:^(id result) {
#endif
        } failure:^(NSError *error) {

         }];
    }
@end
