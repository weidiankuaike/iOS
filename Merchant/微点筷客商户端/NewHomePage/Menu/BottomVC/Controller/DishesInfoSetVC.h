//
//  DishesInfoSetVC.h
//  微点筷客商户端
//
//  Created by Skyer God on 16/10/18.
//  Copyright © 2016年 张森森. All rights reserved.
//

#import "BaseNaviSetVC.h"
typedef void(^dishesSetInfoDic)(NSMutableDictionary *dishesInfoDic);

@class DishesInfoModel;
@interface DishesInfoSetVC : BaseNaviSetVC
/** 图片   (strong) **/
@property (nonatomic, strong) UIImage *image;
/** block属性  (NSString) **/
@property (nonatomic, copy) dishesSetInfoDic dishesInfoDic;
/** 菜品管理Model **/
@property (nonatomic, strong) DishesInfoModel *model;

/** 保存填写信息  字典   (strong) **/
@property (nonatomic, strong) NSMutableDictionary *saveInfoDic;

/** 接受上个页面请求下来的分类信息，用以创建分类选择弹窗  (NSString) **/
@property (nonatomic, strong) NSMutableArray *getKeyArray;
/** 所有菜品信息字典   (strong) **/
@property (nonatomic, strong) NSMutableDictionary *allDishesInfoDic;
- (void)saveClick:(dishesSetInfoDic)dishesInfoDic;

/** 图片路径  (NSString) **/
@property (nonatomic, copy) NSString *filePath;
@end
