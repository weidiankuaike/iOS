//
//  RestaurantOrderCell.h
//  wdKuaiKe_iOS
//
//  Created by Skyer God on 16/9/18.
//  Copyright © 2016年 weiDianKuaiKe. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DishesDetailModel.h"
@interface RestaurantOrderCell : UITableViewCell
@property (nonatomic, retain) UIImageView *menuImageV;
@property (nonatomic, retain) UILabel     *titleLabel;
@property (nonatomic, retain) UILabel     *tagLabel;
@property (nonatomic, retain) UIButton    *popularStarBt;//默认点击交互能力关闭 设置为NO；
@property (nonatomic, retain) UILabel     *priceLabel;
//@property (nonatomic, retain) UILabel     *categoryLabel;
@property (nonatomic,strong)UILabel * peolpleLabel;//点过人数
@property (nonatomic, retain) UIButton *evaluateBT;
@property (nonatomic, retain) UIButton *hotBT;
@property (nonatomic, retain) UILabel     *distanceLabel;

@property (nonatomic, retain) UIView *bottomSeparator;

@property (nonatomic, retain) UIButton *addBT;
@property (nonatomic, retain) UIButton *subtractBT;
@property (nonatomic, retain) UILabel *numLabel;
@property (nonatomic,assign) BOOL show;//判断菜品数量是否显示
@property (nonatomic, strong) DishesDetailModel *model;

//增加减少订单数量 需不需要动画效果
@property (copy, nonatomic) void (^plusBlock)(NSInteger count,BOOL animated);
@property (nonatomic, assign) NSUInteger number;
@end
