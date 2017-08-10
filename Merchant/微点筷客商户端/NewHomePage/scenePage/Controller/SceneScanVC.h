//
//  SceneScanVC.h
//  微点筷客商户端
//
//  Created by Skyer God on 17/1/16.
//  Copyright © 2017年 张森森. All rights reserved.
//

#import "BaseNaviSetVC.h"

@interface SceneScanVC : BaseNaviSetVC
/** 扫描结果回调，有返回值   (strong) **/
@property (nonatomic, strong) void(^returnScanResult)(NSString *category, NSString *deskNum, NSString *codeInfo);
@end
