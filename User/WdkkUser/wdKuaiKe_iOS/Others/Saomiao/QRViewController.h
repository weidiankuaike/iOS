//
//  QRViewController.h
//  QRWeiXinDemo
//
//  Created by lovelydd on 15/4/25.
//  Copyright (c) 2015年 lovelydd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ViewController.h"

typedef void(^QRUrlBlock)(NSString *url);
@interface QRViewController : UIViewController


@property (nonatomic, copy) QRUrlBlock qrUrlBlock;
@property (nonatomic, assign) BOOL newAge;
@property (nonatomic, copy) NSString *stringValue;
@property (nonatomic,assign)int singleNum;
@property (nonatomic,copy)NSString * orderid;
@property (nonatomic,copy)NSString * storeId;
@property (nonatomic,assign)NSInteger pushint;//首页1 列表2
@property (nonatomic,copy)NSString * operation;//首页1 列表0
@end
