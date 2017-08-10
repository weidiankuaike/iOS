//
//  ScanViewController.h
//  wdKuaiKe_iOS
//
//  Created by Skyer God on 16/8/26.
//  Copyright © 2016年 weiDianKuaiKe. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ScanViewController : UIViewController
/** 扫描结果回调，有返回值   (strong) **/
@property (nonatomic, strong) void(^returnScanResult)(NSString *);
@end
