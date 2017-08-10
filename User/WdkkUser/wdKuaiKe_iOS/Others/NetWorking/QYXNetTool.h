//
//  QYXNetTool.h
//  OpenYourEyes
//
//  Created by dllo on 16/6/6.
//  Copyright © 2016年 Google AdWords. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, QYXResponseStyle){
    QYXJSON,
    QYXDATA,
    QYXXML,
};
typedef void(^BLOCKOFSuccess)(id result);
typedef void(^BLOCKOFFailure)(NSError *error);
typedef NS_ENUM(NSUInteger, QYXRequestStyle){
    QYXBodyJSON,
    QYXBodyString,
};

@interface QYXNetTool : NSObject

+(QYXNetTool *)shareManager;
//url-->网址, body-->body体, response-->返回值, header-->请求头
- (void)getNetWithUrl:(NSString *)url urlBody:(id)body header:(NSDictionary *)header response:(QYXResponseStyle)response success:(BLOCKOFSuccess)success failure:(BLOCKOFFailure)failure;

- (void)postNetWithUrl:(NSString *)url urlBody:(id)body bodyStyle:(QYXRequestStyle)bodyStyle header:(NSDictionary *)header response:(QYXResponseStyle)response success:(BLOCKOFSuccess)success failure:(BLOCKOFFailure)failure;


@end
