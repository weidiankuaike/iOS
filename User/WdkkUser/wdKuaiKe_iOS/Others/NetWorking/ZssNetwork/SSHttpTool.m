//
//  SSHttpTool.m
//  WDKKtest
//
//  Created by 张森森 on 16/8/3.
//  Copyright © 2016年 weiDianKuaiKe. All rights reserved.
//

#import "SSHttpTool.h"
#import "AFNetworking.h"
#import "LLHConst.h"
#define MaxOperationCountQueue 3
#define RequestTimeOut 8
#import "UserInfoManager.h"
#import "SecurityUtil.h"
#import "GTMBase64.h"
#import "NSData+AES.h"

#define Iv          @"0392039203920300" //偏移量,可自行修改
#define KEY         @"smkldospdosldaaa"
@interface SSHttpTool ()

@end
static SSHttpTool *manager = nil;

@implementation SSHttpTool
+(SSHttpTool *)sharedManager
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (manager == nil) {
            manager = [[self alloc] init];
            
        }
    });
    return manager;
}
+(instancetype)allocWithZone:(struct _NSZone *)zone
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (manager == nil) {
            
            manager = [super allocWithZone:zone];
        }
    });
    return manager;
}
- (void)get:(NSString *)url params:(NSDictionary *)params success:(void (^)(id))success failure:(void (^)(NSError *))failure
{
    [[self class] checkNetWorkStatus];
    
    
    //    NSLog(@"url = %@",[NSString stringWithFormat:@"%@%@",kBaseURL,url]);
    //
    //    NSLog(@"parameter = %@",params);
    AFSecurityPolicy *policy = [[AFSecurityPolicy alloc] init];
    [policy setAllowInvalidCertificates:YES];
    // 1.获得请求管理者
    AFHTTPSessionManager * mgr = [AFHTTPSessionManager manager];
    mgr.responseSerializer.acceptableContentTypes = [NSSet setWithObjects: @"text/html", nil];
    
    mgr.requestSerializer.timeoutInterval = RequestTimeOut;
    mgr.operationQueue.maxConcurrentOperationCount = MaxOperationCountQueue;
    
    // 2.发送GET请求
    [mgr setSecurityPolicy:policy];
    mgr.requestSerializer = [AFHTTPRequestSerializer serializer];
    mgr.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    [self addHeaderTokenWithRequest:mgr.requestSerializer andUrlString:url];
    //    NSLog(@"firstrequest = %@     thePostDic = %@",[mgr.requestSerializer HTTPRequestHeaders],params);
    params = [self paramsDiction:params];
    
    [mgr GET:[self returnHttpUrlString:url] parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSData *data = responseObject;
        
        //        NSString *str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        //        NSLog(@"str = %@",str);
        
        id JSON =  [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        
        if (success) {
            success(JSON);
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure) {
            failure(error);
        }
        
    }];
    
}

- (void)post:(NSString *)url params:(NSDictionary *)params success:(void (^)(id))success failure:(void (^)(NSError *))failure
{
    [[self class] checkNetWorkStatus];
    
    
    //    NSLog(@"url = %@",[NSString stringWithFormat:@"%@%@",kBaseURL,url]);
    //
    //    NSLog(@"parameter = %@",params);
    
    AFSecurityPolicy *policy = [[AFSecurityPolicy alloc] init];

    [policy setAllowInvalidCertificates:YES];
    // 1.获得请求管理者
    AFHTTPSessionManager *mgr = [AFHTTPSessionManager manager];
    mgr.responseSerializer.acceptableContentTypes = [NSSet setWithObjects: @"text/html", nil];
    
    mgr.requestSerializer.timeoutInterval = RequestTimeOut;
    mgr.operationQueue.maxConcurrentOperationCount = MaxOperationCountQueue;
    
    [mgr setSecurityPolicy:policy];
    mgr.requestSerializer = [AFHTTPRequestSerializer serializer];
    mgr.responseSerializer = [AFHTTPResponseSerializer serializer];
    
//    [self addHeaderTokenWithRequest:mgr.requestSerializer andUrlString:url];
    //    NSLog(@"firstrequest = %@     thePostDic = %@",[mgr.requestSerializer HTTPRequestHeaders],params);
//    params = [self paramsDiction:params];
    NSData * stt =[NSJSONSerialization dataWithJSONObject:params options:NSJSONWritingPrettyPrinted error:nil];
     NSData * data = [stt AES128EncryptWithKey:KEY gIv:Iv];
    
//    NSString * string =[[NSString alloc]initWithData:stt encoding:NSUTF8StringEncoding];
//    NSString * sttr = [SecurityUtil encryptAESData:string];
//    NSString * ssss = [SecurityUtil  decryptAESData:sttr];
//    NSLog(@"......%@",ssss);
    // 2.发送POST请求
    
    NSLog(@"nnnnn%@",  [[NSString alloc]initWithData:[data AES128DecryptWithKey:KEY gIv:Iv] encoding:4  ] );
    
    [mgr POST:[self returnHttpUrlString:url] parameters:data progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSData *data = responseObject;
        
        //        NSString *str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        //        NSLog(@"str = %@",str);
        
        id JSON =  [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        if (success) {
            success(JSON);
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure) {
            failure(error);
        }
    }];
    
}
/**
 *  上传文件请求
 */
- (void)post:(NSString *)url params:(NSDictionary *)params dataSource:(FormData *)dataSource success:(void (^)(id))success failure:(void (^)(NSError *))failure{
    [[self class] checkNetWorkStatus];
    
    //
    //    NSLog(@"url = %@",[NSString stringWithFormat:@"%@%@",kBaseURL,url]);
    //
    //    NSLog(@"parameter = %@",params);
    
    
    // 1.获得请求管理者
    AFHTTPSessionManager * mgr = [AFHTTPSessionManager manager];
    //    让manager对象 不要帮我们解析数据
    mgr.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    mgr.requestSerializer.timeoutInterval = RequestTimeOut;
    mgr.operationQueue.maxConcurrentOperationCount = MaxOperationCountQueue;
    //    1、  NSString url
    params =[self paramsDiction:params];
    NSString *thePostString = [self theDicTojson:params];
    
    NSDictionary *objDic = @{@"obj":thePostString};
    
    thePostString = [self theDicTojson:(NSMutableDictionary *)objDic];
    
    NSDictionary *parameter = @{@"data":thePostString};
    [mgr POST:[self returnHttpUrlString:url] parameters:parameter constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        /**
         *  FileData:要上传的文件的二进制数据
         *  name:上传参数名称
         *  fileName：上传到服务器的文件名称
         *  mimeType：文件类型
         */
        [formData appendPartWithFileData:dataSource.data name:dataSource.name fileName:dataSource.filename mimeType:dataSource.mimeType];
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSData *data = responseObject;
        //        JSON 解包
        id JSON =  [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        //    NSLog(@"json = %@",JSON);
        
        if (success) {
            success(JSON);
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure) {
            failure(error);
        }
    }];
    
}
-(void)post:(NSString *)url params:(NSDictionary *)params formDataArray:(NSArray *)formDataArray success:(void (^)(id))success failure:(void (^)(NSError *))failure
{
    [[self class] checkNetWorkStatus];
    
    //
    //    NSLog(@"url = %@",[NSString stringWithFormat:@"%@%@",kBaseURL,url]);
    //
    //    NSLog(@"parameter = %@",params);
    
    
    // 1.获得请求管理者
    AFHTTPSessionManager * mgr = [AFHTTPSessionManager manager];
    mgr.requestSerializer.timeoutInterval = RequestTimeOut;
    mgr.operationQueue.maxConcurrentOperationCount = MaxOperationCountQueue;
    //    让manager对象 不要帮我们解析数据
    mgr.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    //    1、  NSString url
    
    NSString *thePostString = [self theDicTojson:params];
    
    NSDictionary *objDic = @{@"obj":thePostString};
    
    thePostString = [self theDicTojson:(NSMutableDictionary *)objDic];
    
    NSDictionary *parameter = @{@"data":thePostString};
    [mgr POST:[self returnHttpUrlString:url] parameters:parameter constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        /**
         *  FileData:要上传的文件的二进制数据
         *  name:上传参数名称
         *  fileName：上传到服务器的文件名称
         *  mimeType：文件类型
         */
        for (int i=0; i<formDataArray.count; i++) {
            FormData *dataSource=[formDataArray objectAtIndex:i];
            [formData appendPartWithFileData:dataSource.data name:dataSource.name fileName:dataSource.filename mimeType:dataSource.mimeType];
            
        }
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSData *data = responseObject;
        //        JSON 解包
        id JSON =  [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        //        NSLog(@"JSON = %@",JSON);
        
        if (success) {
            success(JSON);
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure) {
            failure(error);
        }
    }];
    
}
#pragma mark 地址初始化
-(NSString *)returnHttpUrlString:(NSString *)api
{
    NSMutableString *urlStr = [[NSMutableString alloc]initWithString:kBaseURL];
    if (![urlStr hasSuffix:@"/"]) {
        [urlStr appendString:@"/"];
    }
    if (api) {
        [urlStr appendFormat:@"%@?",api];
    }
        DEBUG_Log(@"%@",urlStr);
    return urlStr;
}

#pragma mark - JSONDeal
- (NSString *)theDicTojson:(id )theDic
{
    //NSMutableDictionary ----------- 》json
    NSData *thePostData = [NSJSONSerialization dataWithJSONObject:theDic options:NSJSONWritingPrettyPrinted error:nil];
    
    
    //NSData    ------- >  NSString
    NSString *thePostString = @"";
    if (thePostData != nil) {
        thePostString = [[NSString alloc] initWithData:thePostData encoding:NSUTF8StringEncoding];
    }
    return thePostString;
    
}

#pragma mark - HeaderDeal

// 加工请求头
- (void)addHeaderTokenWithRequest:(AFHTTPRequestSerializer *)request andUrlString:(NSString *)urlKey;
{
    // 除去URI的干扰
    NSRange rang = [urlKey rangeOfString:@"?"];
    if (rang.location != NSNotFound) {
        urlKey = [urlKey substringToIndex:rang.location];
    }
    NSString *timeString = [NSString stringWithFormat:@"%.0f",[[NSDate date] timeIntervalSince1970]*1000];
    //    NSLog(@"%@",[NSString stringWithFormat:@"%@%@%@%@%@",ApiId,urlKey,timeString,[UserManager sharedInstance].token,AFPrivateKey]);
    [request setValue:@"APP" forHTTPHeaderField:@"Api-Id"];
    [request setValue:timeString forHTTPHeaderField:@"Api-Timestamp"];
    [request setValue:@"iOS" forHTTPHeaderField:@"platform"];
    [request setValue:app_Version forHTTPHeaderField:@"version"];
    //    [request setValue:[NSString sha256:[NSString stringWithFormat:@"%@%@%@%@",ApiId,urlKey,timeString,AFPrivateKey]] forHTTPHeaderField:@"Api-Sign"];
    //    [request setValue:[UserManager sharedInstance].token forHTTPHeaderField:@"token"];
}
#pragma mark 取消网络请求

- (void)cancelRequest{
    
    NSLog(@"cancelRequest");
    
    
    
}
//网络监听（用于检测网络是否可以链接。此方法最好放于AppDelegate中，可以使程序打开便开始检测网络）
+ (void)checkNetWorkStatus
{
    AFHTTPSessionManager *mgr = [AFHTTPSessionManager manager];
    //打开网络监听
    [mgr.reachabilityManager startMonitoring];
    
    //监听网络变化
    [mgr.reachabilityManager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        switch (status) {
                
                //当网络不可用（无网络或请求延时）
            case AFNetworkReachabilityStatusNotReachable:
                break;
                
                //当为手机WiFi时
            case AFNetworkReachabilityStatusReachableViaWiFi:
                break;
                
                //当为手机蜂窝数据网
            case AFNetworkReachabilityStatusReachableViaWWAN:
                break;
                
                //其它情况
            default:
                break;
        }
    }];
    
    //    //停止网络监听（若需要一直检测网络状态，可以不停止，使其一直运行）
    //        [mgr.reachabilityManager stopMonitoring];
}


-(void)dealloc {
    DEBUG_Log(@"*******释放==%s==*********",object_getClassName(self));
}
-(NSDictionary *)paramsDiction:(NSDictionary *)dict
{
    NSString *token = @"";
    
    token = [UserInfoManager userInfoObjectForKey:UserDeviceToken];
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc]initWithObjectsAndKeys:@"iOS",@"platform",app_Version,@"version",nil];
    if (token) {
        [params setObject:token forKey:@"device_token"];
    }
    //    [params setObject:@"1" forKey:@"useful"];
    if (dict) {
        for (NSString *key in dict.allKeys) {
            [params setObject:IsNullData([dict objectForKey:key]) forKey:key];
            //            if ([key isEqualToString:@"page"]) {
            //                NSInteger page = [[dict objectForKey:key] integerValue];
            //                if (page > 1) {
            //                    [params setObject:@"0" forKey:@"useful"];
            //                }
            //            }
        }
    }
    return params;
}

@end
/**
 *  用来封装文件数据的模型
 */
@implementation FormData


@end
