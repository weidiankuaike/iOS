//
//  DishesInfoCell.h
//  wdKuaiKe_iOS
//
//  Created by Skyer God on 16/9/19.
//  Copyright © 2016年 weiDianKuaiKe. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DishesInfoModel;
@interface DishesInfoCell : UITableViewCell
@property (nonatomic, retain) UIImageView *imageV;
@property (nonatomic, retain) UILabel *titleLabel;
@property (nonatomic, retain) UILabel *saleMth;
@property (nonatomic, retain) UILabel *discountPrice;
@property (nonatomic, retain) UILabel *originalPrice;
@property (nonatomic, retain) UIButton *shoppingCart;
@property (nonatomic, strong) DishesInfoModel *model;
@end
