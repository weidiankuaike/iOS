//
//  RestaurantOrderVC.h
//  wdKuaiKe_iOS
//
//  Created by Skyer God on 16/9/18.
//  Copyright © 2016年 weiDianKuaiKe. All rights reserved.
//


typedef void(^buyblock)(NSInteger num,float sum,NSMutableArray * dictary);
@interface RestaurantOrderVC : UIViewController
//@property (nonatomic,strong) ShoppingCartView *shoppcartview;
@property (nonatomic,copy)NSString * storeid;
@property (nonatomic,copy)buyblock block;
@property (nonatomic,assign) float sum;//商品总价
@property (nonatomic,assign) NSInteger number;//总个数
@property (nonatomic,strong) NSMutableArray * dictary;//点菜数组
@property (nonatomic,copy)NSString * isbook;
@end
