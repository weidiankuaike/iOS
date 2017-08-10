//
//  BrowTableViewCell.h
//  wdKuaiKe_iOS
//
//  Created by 张森森 on 16/12/24.
//  Copyright © 2016年 weiDianKuaiKe. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Browmodel.h"
#import <UIImageView+WebCache.h>
@interface BrowTableViewCell : UITableViewCell
@property (nonatomic,strong)UIImageView * headview;
@property (nonatomic,strong)UILabel * namelabel;//店铺名称
@property (nonatomic,strong)UILabel * introductionlabel;//介绍
@property (nonatomic,strong)UILabel * renjunlabel;
@property (nonatomic,strong)UILabel * moneylabel;
@property (nonatomic,strong)UILabel * distancelabel;
@property (nonatomic,strong)UILabel * zhekoulabel;
@property (nonatomic,strong)Browmodel * model;
@end
