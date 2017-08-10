//
//  LocationTableViewCell.h
//  wdKuaiKe_iOS
//
//  Created by Skyer God on 16/8/8.
//  Copyright © 2016年 weiDianKuaiKe. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MerchantDetailVCModel.h"

@interface LocationTableViewCell : UITableViewCell

@property (nonatomic, strong) UIButton *locationBT;

@property (nonatomic, strong) UIButton *arrowBT;
@property (nonatomic, strong) MerchantDetailVCModel *model;

@end
