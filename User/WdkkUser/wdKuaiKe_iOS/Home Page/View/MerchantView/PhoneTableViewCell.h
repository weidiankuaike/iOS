//
//  PhoneTableViewCell.h
//  wdKuaiKe_iOS
//
//  Created by Skyer God on 16/8/8.
//  Copyright © 2016年 weiDianKuaiKe. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MerchantDetailVCModel.h"
@interface PhoneTableViewCell : UITableViewCell
@property (nonatomic, strong) UIButton *timeButton;
@property (nonatomic, strong) UIButton *phoneButton;

@property (nonatomic, strong) MerchantDetailVCModel *model;

@end
