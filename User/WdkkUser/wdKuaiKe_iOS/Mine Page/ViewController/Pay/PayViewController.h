//
//  PayViewController.h
//  wdKuaiKe_iOS
//
//  Created by 张森森 on 16/9/12.
//  Copyright © 2016年 weiDianKuaiKe. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^payblock) (NSString * paystr);
@interface PayViewController : UIViewController
@property (nonatomic,copy)NSString * orderid;
@property (nonatomic,copy)NSString * storeimage;
@property (nonatomic,copy)NSString * storename;
@property (nonatomic,copy)NSString * moneystr;
@property (nonatomic,copy)NSString * storeid;
@property (nonatomic,copy)NSString * ordertype;
@property (nonatomic,copy)payblock block;
@property (nonatomic,assign)NSInteger pushint;
@property (nonatomic,copy)NSString * actId;//优惠券id

-(void)getsomethingwith:(payblock)block;

@end
