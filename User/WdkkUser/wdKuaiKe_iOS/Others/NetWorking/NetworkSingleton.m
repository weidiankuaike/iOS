//
//  NetworkSingleton.m
//  wdKuaiKe_iOS
//
//  Created by Skyer God on 16/8/3.
//  Copyright © 2016年 weiDianKuaiKe. All rights reserved.
//

#import "NetworkSingleton.h"

#import "SecurityUtil.h"
#import "GTMBase64.h"
#import "NSData+AES.h"
#import "UserInfoManager.h"
#import "LLHConst.h"

#import "SSHttpTool.h"

#define Iv          @"0392039203920300" //偏移量,可自行修改
#define KEY         @"smkldospdosldaaa" //key，可自行修改

@implementation NetworkSingleton
+(NetworkSingleton *)shareManager{
    static NetworkSingleton *shareNetworkSingleton = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        
        shareNetworkSingleton = [[self alloc] init];
        
    });
    return shareNetworkSingleton;
}

-(AFHTTPSessionManager *)baseHttpRequest{
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager.requestSerializer setTimeoutInterval:TIMEOUT];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    [manager.requestSerializer setValue:@"application/octet-stream" forHTTPHeaderField:@"Content-Type"];
    
    
    //header 设置
//        [manager.requestSerializer setValue:K_PASS_IP forHTTPHeaderField:@"Host"];
//        [manager.requestSerializer setValue:@"max-age=0" forHTTPHeaderField:@"Cache-Control"];
//        [manager.requestSerializer setValue:@"text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8" forHTTPHeaderField:@"Accept"];
//        [manager.requestSerializer setValue:@"zh-cn,zh;q=0.8,en-us;q=0.5,en;q=0.3" forHTTPHeaderField:@"Accept-Language"];
//        [manager.requestSerializer setValue:@"gzip, deflate" forHTTPHeaderField:@"Accept-Encoding"];
//        [manager.requestSerializer setValue:@"keep-alive" forHTTPHeaderField:@"Connection"];
//        [manager.requestSerializer setValue:@"Mozilla/5.0 (Macintosh; Intel Mac OS X 10.10; rv:35.0) Gecko/20100101 Firefox/35.0" forHTTPHeaderField:@"User-Agent"];
    


//    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html",@"text/css",@"text/plain", nil];
    
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/plain", @"text/html", @"application/json", nil];
    
    return manager;
}
-(void)getReq:(NSDictionary *)userInfo url:(NSString *)url encrypted:(BOOL) encrypted successBlock:(SuccessBlock)successBlock failureBlock:(FailureBlock)failureBlock{
    
    if (encrypted) {
        url = [SecurityUtil encryptAESData:url];
        url = [url stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    } else
    {
       url = [url stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];

    };
    
    AFHTTPSessionManager *manager = [self baseHttpRequest];
    
    [manager GET:url parameters:userInfo progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSString *strUTF8 = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSLog(@"%@", strUTF8);
        id JSON =  [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        successBlock(JSON);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSString *errorStr = [error.userInfo objectForKey:@"NSLocalizedDescription"];
        failureBlock(errorStr);
        NSLog(@"%@", errorStr);
        
    }];
    
    
}
//post请求

-(void)postReq:(id )userInfo url:(NSString *)url encryted:(BOOL)encrypted successBlock:(SuccessBlock)successBlock failureBlock:(FailureBlock)failureBlock{

    AFSecurityPolicy *policy = [[AFSecurityPolicy alloc] init];
    
    [policy setAllowInvalidCertificates:YES];
    
    AFHTTPSessionManager *manager = [self baseHttpRequest];
    
    [manager setSecurityPolicy:policy];
    

    
    [self addHeaderTokenWithRequest:manager.requestSerializer andUrlString:url];
    
//    userInfo = [self paramsDiction:userInfo];

    
    NSData * stt =[NSJSONSerialization dataWithJSONObject:userInfo options:NSJSONWritingPrettyPrinted error:nil];
    NSData * data = [stt AES128EncryptWithKey:KEY gIv:Iv];
    
    
    NSLog(@"?????????%@",data);
    
    NSString * urls = [self returnHttpUrlString:url];


    [manager POST:urls parameters:data progress:^(NSProgress * _Nonnull uploadProgress) {
        
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSData *data = responseObject;
        
        id Json = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        


        if (successBlock) {
            successBlock(Json);
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSString *errorStr = [error.userInfo objectForKey:@"NSLocalizedDescription"];
        failureBlock(errorStr);
        
    }];
    
}

//上传文件
-(void)postDataReq:(NSDictionary *)userInfo url:(NSString *)url dataSource:(formatDate *)dataSource encryed:(BOOL)encryed successBlock:(SuccessBlock)successBlock failureBlock:(FailureBlock)failureBlock{
    
    AFHTTPSessionManager *manager = [self baseHttpRequest];
    
    manager.operationQueue.maxConcurrentOperationCount = 3;
    
    userInfo = [self paramsDiction:userInfo];
    
    NSString *thePostString = [self theDicTojson:userInfo];
    
    NSDictionary *objDic = @{@"obj":thePostString};
    
    thePostString = [self theDicTojson:(NSMutableDictionary *)objDic];
    
     NSDictionary *parameter = @{@"data":thePostString};
    
    [manager POST:url parameters:parameter constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
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
        successBlock(JSON);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSString *errorStr = [error.userInfo objectForKey:@"NSLocalizedDescription"];
        failureBlock(errorStr);
    }];
    
    
    
}


-(void)postDataArrReq:(NSDictionary *)userInfo url:(NSString *)url dataArray:(NSArray *)dataArray encryed:(BOOL)encryed successBlock:(SuccessBlock)successBlock failureBlock:(FailureBlock)failureBlock{
    
    AFHTTPSessionManager *manager = [self baseHttpRequest];
    
    manager.operationQueue.maxConcurrentOperationCount = 3;
    
    NSString *thePostString = [self theDicTojson:userInfo];
    
    NSDictionary *objDic = @{@"obj":thePostString};
    
    thePostString = [self theDicTojson:(NSMutableDictionary *)objDic];
    NSString * urls = [self returnHttpUrlString:url];

    
    NSDictionary *parameter = @{@"data":thePostString};
    [manager POST:urls parameters:parameter constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        /**
         *  FileData:要上传的文件的二进制数据
         *  name:上传参数名称
         *  fileName：上传到服务器的文件名称
         *  mimeType：文件类型
         */
        for (int i=0; i<dataArray.count; i++) {
            FormData *dataSource=[dataArray objectAtIndex:i];
            [formData appendPartWithFileData:dataSource.data name:dataSource.name fileName:dataSource.filename mimeType:dataSource.mimeType];
            
        }
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSData *data = responseObject;
        //        JSON 解包
        id JSON =  [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        //        NSLog(@"JSON = %@",JSON);
        
        successBlock(JSON);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
       
        NSString *errorStr = [error.userInfo objectForKey:@"NSLocalizedDescription"];
        failureBlock(errorStr);
        
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
@end
