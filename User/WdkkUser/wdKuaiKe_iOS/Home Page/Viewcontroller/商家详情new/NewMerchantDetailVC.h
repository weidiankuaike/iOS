//
//  NewMerchantDetailVC.h
//  wdKuaiKe_iOS
//
//  Created by Skyer God on 16/9/29.
//  Copyright © 2016年 weiDianKuaiKe. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NewMerchantDetailVC : UIViewController

@property (nonatomic,copy)NSString * moneystr;//人均
@property (nonatomic,copy)NSString * ordersales;
@property (nonatomic,copy)NSString * address;
@property (nonatomic,strong)NSDictionary * dict;
@property (nonatomic,copy)NSString * storeid;

@end
