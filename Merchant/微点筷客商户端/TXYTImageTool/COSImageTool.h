//
//  COSImageTool.h
//  微点筷客商户端
//
//  Created by Skyer God on 17/2/3.
//  Copyright © 2017年 张森森. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "COSClient.h"
#import "COSTask.h"
typedef void(^successCallBack)(COSObjectUploadTaskRsp *rsp);
typedef void(^errorCallBack)(NSInteger retCode);
typedef void(^progressCallBack)( int64_t bytesWritten,
                                int64_t totalBytesWritten,
                                int64_t totalBytesExpectedToWrite);
@interface COSImageTool : NSObject
//管理类方法
+(COSImageTool *)shareManager;

/**
    path            被传文件的路径 （必）
    fileName        被传文件的名字 （必）
    bucket          上传CDN空间名 （必）
    directory       上传CDN文件路径 （必）
    atts            上传文件的描述 （可选）
    上传成功后实例     gz.file.myqcloud.com/files/v2/1252323/bucket/directory/fileName
 */
- (void)uploadImageWithPath:(NSString *)path directory:(NSString *)dir attrs:(NSString *)attrs success:(successCallBack)success progress:(progressCallBack)progress error:(errorCallBack)error;
- (void)deleteFilesWithPath:(NSString *)imagePath;
@end
