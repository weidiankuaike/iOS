//
//  HomeTableViewCell.h
//  wdKuaiKe_iOS
//
//  Created by 张森森 on 17/1/11.
//  Copyright © 2017年 weiDianKuaiKe. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SearchStoreModel.h"
#import "NSObject+JudgeNull.h"
#import "CardModel.h"
@interface HomeTableViewCell : UITableViewCell

@property (nonatomic,strong)SearchStoreModel * model;
@property (nonatomic,strong)UIImageView * headview;
@property (nonatomic,strong)UILabel * namelabel;//店铺名称
@property (nonatomic,strong)UILabel * introductionlabel;//介绍
@property (nonatomic,strong)UILabel * renjunlabel;
@property (nonatomic,strong)UILabel * moneylabel;
@property (nonatomic,strong)UILabel * distancelabel;
@property (nonatomic,strong)UILabel * zhekoulabel;
@property (nonatomic,strong)UILabel * xslabel;//销售量
@property (nonatomic,copy)NSString * xinginteger;
@property (nonatomic,strong)NSMutableArray * mjAry;
@property (nonatomic,strong)NSMutableArray * zkAry;
@property (nonatomic,strong)UIImageView * subtractImage;//满减图片
@property (nonatomic,strong)UILabel * subtractLabel;
@property (nonatomic,strong)UIImageView * discountimage;//折扣
@property (nonatomic,strong)UILabel * discountLabel;
@end
