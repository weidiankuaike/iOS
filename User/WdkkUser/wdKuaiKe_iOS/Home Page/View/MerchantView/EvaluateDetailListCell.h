//
//  EvaluateDetailListCell.h
//  wdKuaiKe_iOS
//
//  Created by Skyer God on 16/8/8.
//  Copyright © 2016年 weiDianKuaiKe. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "MerchantDetailVCModel.h"


@interface EvaluateDetailListCell : UITableViewCell

@property (nonatomic, retain) UIButton *userButton;
@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) UILabel *detailLabel;


@property (nonatomic, strong) MerchantDetailVCModel *model;

@end
