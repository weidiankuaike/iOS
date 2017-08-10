//
//  DishesIntroductionInfoCell.h
//  wdKuaiKe_iOS
//
//  Created by Skyer God on 16/9/19.
//  Copyright © 2016年 weiDianKuaiKe. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DishesInfoModel;
@interface DishesIntroductionInfoCell : UITableViewCell
@property (nonatomic, retain) UILabel *dishesDetail;

@property (nonatomic, retain) DishesInfoModel *model;
@end
