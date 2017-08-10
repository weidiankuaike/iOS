//
//  SSHttpTool.h
//  WDKKtest
//
//  Created by 张森森 on 16/8/3.
//  Copyright © 2016年 weiDianKuaiKe. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FormData : NSObject
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

@protocol AFNManagerDelegate <NSObject>

@optional
/**
 *  发送请求成功
 *
 *  @param manager AFNManager
 */
-(void)AFNManagerDidSuccess:(id)data;
/**
 *  发送请求失败
 *
 *  @param manager AFNManager
 */
-(void)AFNManagerDidFaild:(NSError *)error;
@end

@interface SSHttpTool : NSObject
@property (nonatomic, weak) id<AFNManagerDelegate> delegate;
/**
 *  AFNManager单利
 */
+(SSHttpTool *)sharedManager;
/**
 *  发送一个GET请求
 *
 *  @param url     请求路径
 *  @param params  请求参数
 *  @param success 请求成功后的回调（请将请求成功后想做的事情写到这个block中）
 *  @param failure 请求失败后的回调（请将请求失败后想做的事情写到这个block中）
 */
- (void)get:(NSString *)url params:(NSDictionary *)params success:(void (^)(id JSON))success failure:(void (^)(NSError *error))failure;
/**
 *  发送一个POST请求
 *
 *  @param url     请求路径
 *  @param params  请求参数
 *  @param success 请求成功后的回调（请将请求成功后想做的事情写到这个block中）
 *  @param failure 请求失败后的回调（请将请求失败后想做的事情写到这个block中）
 */
- (void)post:(NSString *)url params:(NSDictionary *)params success:(void (^)(id JSON))success failure:(void (^)(NSError *error))failure;

/**
 *  发送一个POST请求 上传文件数组(多个)
 *
 *  @param url     请求路径
 *  @param params  请求参数
 *  @param formDataArray 文件参数数组
 *  @param success 请求成功后的回调（请将请求成功后想做的事情写到这个block中）
 *  @param failure 请求失败后的回调（请将请求失败后想做的事情写到这个block中）
 */
- (void)post:(NSString *)url params:(NSDictionary *)params formDataArray:(NSArray *)formDataArray success:(void (^)(id JSON))success failure:(void (^)(NSError *error))failure;


/**
 *  发送一个POST请求  上传文件
 *
 *  @param url        请求路径
 *  @param params     请求参数
 *  @param dataSource 上传文件参数模型
 *  @param success    请求成功后的回调（请将请求成功后想做的事情写到这个block中）
 
 *  @param failure    请求失败后的回调（请将请求失败后想做的事情写到这个block中）
 
 */
- (void)post:(NSString *)url params:(NSDictionary *)params dataSource:(FormData *)dataSource success:(void (^)(id))success failure:(void (^)(NSError *))failure;


@end
