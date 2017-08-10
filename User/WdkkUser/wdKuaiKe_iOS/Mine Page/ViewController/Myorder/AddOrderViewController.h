//
//  AddOrderViewController.h
//  wdKuaiKe_iOS
//
//  Created by 张森森 on 17/2/28.
//  Copyright © 2017年 weiDianKuaiKe. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^addorderblock)(NSString * result);

@interface AddOrderViewController : UIViewController
@property (nonatomic,copy)NSString * storeid;
@property (nonatomic,copy)NSString * orderid;
@property (nonatomic,copy)addorderblock block;
@end
