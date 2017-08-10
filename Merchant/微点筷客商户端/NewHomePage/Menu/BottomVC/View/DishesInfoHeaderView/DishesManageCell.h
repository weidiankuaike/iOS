//
//  DishesManageCell.h
//  微点筷客商户端
//
//  Created by Skyer God on 16/10/19.
//  Copyright © 2016年 张森森. All rights reserved.
//

#import <UIKit/UIKit.h>
@class DishesInfoModel;
@interface DishesManageCell : UICollectionViewCell
/** 图片   (strong) **/
@property (nonatomic, strong) UIImageView *imageV;
/** 下架Label   (strong) **/
@property (nonatomic, strong) UILabel *downStairLabel;
/** 菜名   (strong) **/
@property (nonatomic, strong) UILabel *dishesNameLabel;
/** 菜价   (strong) **/
@property (nonatomic, strong) UILabel *dishesPriceLabel;
/** 下架状态   (BOOL) **/
@property (nonatomic, assign) BOOL isDownStair;
/** 菜品描述  (NSString) **/
@property (nonatomic, copy) NSString *descrpt;

/** 删除button   (strong) **/
@property (nonatomic, strong) ButtonStyle *deleteBT;

@property (nonatomic, strong) DishesInfoModel *model;

@property (nonatomic,assign)BOOL isSelected;

-(void)UpdateCellWithState:(BOOL)select;


/** index   (NSInteger) **/
@property (nonatomic, strong) NSIndexPath *indexP;

/** <#注释#>  (NSString) **/
@property (nonatomic, copy) void(^deleteClick)(NSIndexPath *indexP);
@end
