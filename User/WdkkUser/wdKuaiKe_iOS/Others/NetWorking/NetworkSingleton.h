//
//  NetworkSingleton.h
//  wdKuaiKe_iOS
//
//  Created by Skyer God on 16/8/3.
//  Copyright © 2016年 weiDianKuaiKe. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface formatDate : NSObject

/**
 *  文件数据
 */
@property(nonatomic,strong)NSData * data;
/**
 *  参数名
 */
@property(nonatomic,copy)NSString * name;
/**
 *  文件名
 */
@property(nonatomic,copy)NSString * filename;
/**
 *  文件类型
 */
@property(nonatomic,copy)NSString * mimeType;

@end
//请求超时
#define TIMEOUT 30
typedef void(^SuccessBlock)(id responseBody);
typedef void(^FailureBlock)(NSString *error);

@interface NetworkSingleton : NSObject

+(NetworkSingleton *)shareManager;

-(AFHTTPSessionManager *)baseHttpRequest;
// 加工请求头
- (void)addHeaderTokenWithRequest:(AFHTTPRequestSerializer *)request andUrlString:(NSString *)urlKey;

//get请求
- (void)getReq:(NSDictionary *)userInfo url:(NSString *)url encrypted:(BOOL) encrypted successBlock: (SuccessBlock)successBlock failureBlock:(FailureBlock)failureBlock;
//post请求
- (void)postReq:(id )userInfo url:(NSString *)url encryted:(BOOL)encrypted successBlock:(SuccessBlock)successBlock failureBlock:(FailureBlock)failureBlock;
//上传文件请求
- (void)postDataReq:(NSDictionary *)userInfo url:(NSString *)url dataSource:(formatDate *)dataSource encryed:(BOOL)encryed successBlock:(SuccessBlock)successBlock failureBlock:(FailureBlock)failureBlock;

- (void)postDataArrReq:(NSDictionary *)userInfo url:(NSString *)url dataArray:(NSArray *)dataArray encryed:(BOOL)encryed successBlock:(SuccessBlock)successBlock failureBlock:(FailureBlock)failureBlock;


@end
