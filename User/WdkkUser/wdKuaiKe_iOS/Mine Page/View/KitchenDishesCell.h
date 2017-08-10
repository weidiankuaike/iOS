//
//  KitchenDishesCell.h
//  微点筷客商户端
//
//  Created by Skyer God on 16/11/3.
//  Copyright © 2016年 张森森. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Dinemodel.h"
@interface KitchenDishesCell : UICollectionViewCell
/** 图片   (strong) **/
@property (nonatomic, strong) UIImageView *imageV;
/** name   (strong) **/
@property (nonatomic, strong) UILabel *titleLabel;
/** 数量   (strong) **/
@property (nonatomic, strong) UILabel *numLabel;

/** 判断是否开启颤抖动画   (NSString) **/
@property (nonatomic, assign) BOOL isSelectAll;
//数据源model
@property (nonatomic, strong)Dinemodel * model;
//缺几份
@property (nonatomic,strong)UILabel * quelabel;
@end
