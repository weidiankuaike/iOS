//
//  SearchDishTableViewCell.h
//  wdKuaiKe_iOS
//
//  Created by 张森森 on 17/1/19.
//  Copyright © 2017年 weiDianKuaiKe. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SearchdishModel.h"
@interface SearchDishTableViewCell : UITableViewCell
@property (nonatomic,strong)UIImageView * headimage;
@property (nonatomic,strong)UILabel * namelabel;
@property (nonatomic,strong)UILabel * pricelabel;
@property (nonatomic,strong)UILabel * salelabel;
@property (nonatomic,strong)SearchdishModel * model;
@end
