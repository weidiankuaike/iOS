//
//  NewMerchantVC.h
//  wdKuaiKe_iOS
//
//  Created by Skyer God on 16/9/29.
//  Copyright © 2016年 weiDianKuaiKe. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ShoppingCartView.h"
#import "SearchStoreModel.h"
@interface NewMerchantVC : UIViewController
//@property (nonatomic,strong) ShoppingCartView *shoppcartview;
@property (nonatomic,copy)NSString * namestr;
@property (nonatomic,strong)SearchStoreModel * model;
@property (nonatomic,copy)NSString * idstr;
@property (nonatomic,copy)NSString * titlestr;
@property (nonatomic,copy)NSString * starstr;
@property (nonatomic,assign)NSInteger orderCount;//判断第一次点菜还是加菜，提交订单使用
@property (nonatomic,copy)NSString * storeImage;
@end
