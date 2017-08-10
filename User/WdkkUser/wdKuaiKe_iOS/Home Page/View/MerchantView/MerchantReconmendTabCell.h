//
//  MerchantReconmendTabCell.h
//  wdKuaiKe_iOS
//
//  Created by Skyer God on 16/9/8.
//  Copyright © 2016年 weiDianKuaiKe. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MerchantDetailVCModel.h"
@interface MerchantReconmendTabCell : UITableViewCell
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) MerchantDetailVCModel *model;
@end
