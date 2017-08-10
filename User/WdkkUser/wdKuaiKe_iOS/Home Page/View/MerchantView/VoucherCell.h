//
//  VoucherCell.h
//  wdKuaiKe_iOS
//
//  Created by Skyer God on 16/9/23.
//  Copyright © 2016年 weiDianKuaiKe. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VoucherCell : UITableViewCell

@property (nonatomic, assign) BOOL isPast;
@property (nonatomic, strong) UIImageView *backImageV;
@property (nonatomic, strong) UILabel *discountLabel;
@property (nonatomic, strong) UILabel *voucherLabel;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *detailLabel;
@property (nonatomic, strong) UILabel *limitDataLabel;
@end
