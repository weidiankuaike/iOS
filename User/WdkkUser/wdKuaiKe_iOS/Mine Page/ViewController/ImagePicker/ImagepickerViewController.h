//
//  ImagepickerViewController.h
//  wdKuaiKe_iOS
//
//  Created by 张森森 on 17/1/9.
//  Copyright © 2017年 weiDianKuaiKe. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^judeImageblock)(NSMutableArray * imagearg);
@interface ImagepickerViewController : UIViewController
@property (nonatomic,copy)judeImageblock block;
@property (nonatomic,copy)NSString * storeid;

@end
