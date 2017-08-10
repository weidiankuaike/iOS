//
//  TableViewCell.h
//  WDKKtest
//
//  Created by Skyer God on 16/7/20.
//  Copyright © 2016年 weiDianKuaiKe. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MerchantDetailVCModel.h"
@interface MerchantListCell : UITableViewCell
@property (nonatomic, retain) UIImageView *menuImageV;
@property (nonatomic, retain) UILabel     *titleLabel;
@property (nonatomic, retain) UILabel     *tagLabel;
@property (nonatomic, retain) UIButton    *popularStarBt;//默认点击交互能力关闭 设置为NO；
@property (nonatomic, retain) UILabel     *priceLabel;
@property (nonatomic, retain) UILabel     *categoryLabel;
@property (nonatomic, retain) UILabel     *distanceLabel;

@property (nonatomic, retain) MerchantDetailVCModel *model;



@end
