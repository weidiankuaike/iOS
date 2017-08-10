//
//  COSImageTool.m
//  微点筷客商户端
//
//  Created by Skyer God on 17/2/3.
//  Copyright © 2017年 张森森. All rights reserved.
//

#import "COSImageTool.h"
#import "COSClient.h"
#import "COSTask.h"
typedef void(^signSuccess)(NSString *sign);

@interface COSImageTool ()

/** cosClient   (strong) **/
@property (nonatomic, strong) COSClient *myClient;
@end

@implementation COSImageTool
+(COSImageTool *)shareManager{
    static COSImageTool *shareImageManager = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{

        shareImageManager = [[self alloc] init];

    });
    return shareImageManager;
}
/*
 签名类型：

 类型	含义
 多次有效	有效时间内多次始终有效
 单次有效	与资源URL绑定，一次有效
 

dir	NSString *	是	目录路径（相对于bucket的路径）
bucket	NSString *	是	目录所属 bucket 名称
sign	NSString *	是	签名
attrs	NSString *	否	用户自定义属性
 
 
 返回结果说明

 通过COSCreatDirTaskRsp 的对象返回结果

 属性名称	类型	说明
 retCode	int	任务描述代码
 descMsg	NSString *	任务描述信息
 */

#define COSBucket @"imgshop"
#define region @"gz"
- (void)uploadImageWithPath:(NSString *)path directory:(NSString *)dir attrs:(NSString *)attrs success:(successCallBack)success progress:(progressCallBack)progress error:(errorCallBack)error{

    if ([dir containsString:@"vertify"]) {
        //不处理路径
    } else {
        dir = [NSString stringWithFormat:@"%@/%@", storeID, dir];
        [SVProgressHUD showWithStatus:@"上传中"];
    }
    [self getDownloadSignInfoFromLocationServiceWithStyle:@"0" directory:dir success:^(NSString *sign) {

        COSObjectPutTask *task = [[COSObjectPutTask alloc] init];

        task.filePath = path;

        NSDate* date = [NSDate dateWithTimeIntervalSinceNow:0];
        NSTimeInterval a=[date timeIntervalSince1970]*1000; // *1000 是精确到毫秒，不乘就是精确到秒
        NSString *timeString = [NSString stringWithFormat:@"%@-%.0f.png", UserId, a]; //转为字符型

        task.fileName = timeString;
        task.bucket = COSBucket;
        task.directory = dir;
        task.attrs = attrs;
        task.insertOnly = YES;
        task.sign = sign;
        _myClient = [[COSClient alloc] initWithAppId:TXYTAppid withRegion:region];

        /** 成功后，后台返回文件的 CDN url */
//        @property (nonatomic, strong)    NSString               *acessURL;
//        /** 成功后，后台返回文件的 源站 url */
//        @property (nonatomic, strong)    NSString               *sourceURL;
        _myClient.completionHandler = ^(COSTaskRsp *resp, NSDictionary *context) {
            COSObjectUploadTaskRsp *rsp = (COSObjectUploadTaskRsp *)resp;
            if (rsp.retCode == 0) {
//                [SVProgressHUD showSuccessWithStatus:@"成功"];
                NSString *cutURL = [rsp.sourceURL subStringFromString:@".com"];
                NSString *tempHTTPS = @"https://image.webshop.wdkk.mobi";
                NSString *targetURL = [NSString stringWithFormat:@"%@%@", tempHTTPS, cutURL ];
                [rsp setSourceURL:targetURL];
                ZTLog(@"%@", rsp.sourceURL);
                [SVProgressHUD showSuccessWithStatus:@"上传成功"];
                success(rsp);
            } else {
                [SVProgressHUD showErrorWithStatus:[NSString stringWithFormat:@"%d\n%@", rsp.retCode, rsp.descMsg]];
                error(rsp.retCode);
            }
        };
        _myClient.progressHandler = ^(int64_t bytesWritten,
                                       int64_t totalBytesWritten,
                                       int64_t totalBytesExpectedToWrite){
            progress(bytesWritten, totalBytesWritten, totalBytesExpectedToWrite);
            ZTLog(@"%lld--%lld--%lld", bytesWritten, totalBytesWritten, totalBytesExpectedToWrite);
        };
        //    http://192.168.31.247:8083/common/getQcloudSign?token=aaed2a82e94a482687fd16ae021a21e6
        [_myClient putObject:task];

    }];

}
/*
 参数说明

 参数名称       类型           是否必填        说明
 filename	NSString        *	是
 bucket     NSString        *	是	文件所属 Bucket 名称
 directory	NSString        *	是	目录路径（相对于bucket的路径）
 sign       NSString        *	是	签名
 objectType	TXYObjectType	是	业务类型，文件删除时设置为：TXYObjectFile
 返回结果说明

 通过COSObjectDeleteTaskRsp的对象返回结果信息

 属性名称       类型          说明
 retCode       int         任务描述代码，为retCode >= 0时标示成功，为负数表示为失败
 descMsg       NSString    任务描述信息
 */
- (void)deleteFilesWithPath:(NSString *)imagePath{

    NSArray *strArr = [imagePath componentsSeparatedByString:@"/"];

    NSString *fileName = [strArr lastObject];
    NSString *path = [imagePath subStringFrom:@".com" to:fileName];
    NSString *directory = [imagePath subStringFrom:@".com/" to:[NSString stringWithFormat:@"/%@", fileName]];

    [self getDownloadSignInfoFromLocationServiceWithStyle:@"1" directory:path success:^(NSString *sign) {
        COSObjectDeleteCommand *cm = [COSObjectDeleteCommand new];
        cm.fileName = fileName;// directory／123.png
        cm.bucket = COSBucket;
        cm.directory = directory;//[NSString stringWithFormat:@"/%@/", directroy];
        cm.sign = sign;

        if (!_myClient) {
            _myClient = [[COSClient alloc] initWithAppId:TXYTAppid withRegion:region];
        }
        _myClient.completionHandler = ^(COSTaskRsp *resp, NSDictionary *context){
            if (resp.retCode == 0) {
                //删除成功

            } else {
                //失败
            }
        };
        [_myClient deleteObject:cm];
    }];
}
#pragma mark -- 签名 ---
// type 0 多次签名  1单次签名  2下载签名
- (void)getDownloadSignInfoFromLocationServiceWithStyle: (NSString *)type directory:(NSString *)directory  success:(signSuccess)signSuccess {
    NSString *keyUrl = @"common/getQcloudSign";
    NSString *urlSign = [NSString stringWithFormat:@"%@%@?token=%@&bucket=%@&cos_path=/%@/&diff=%@", kBaseURL, keyUrl, TOKEN, COSBucket, directory, type];
    [[QYXNetTool shareManager] postNetWithUrl:urlSign urlBody:nil bodyStyle:QYXBodyString header:nil response:QYXJSON success:^(id result) {
        //        ZTLog(@"%@", result);
        NSString *sign = result[@"obj"];
        signSuccess(sign);


    } failure:^(NSError *error) {
        
        
    }];
    
    
}

@end
