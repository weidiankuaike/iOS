//
//  NewVoucherCell.h
//  微点筷客商户端
//
//  Created by Skyer God on 16/12/1.
//  Copyright © 2016年 张森森. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VoucherViewMedel.h"
@interface NewVoucherCell : UITableViewCell
/** 卡券类别   (strong) **/
@property (nonatomic, strong) UILabel *categoryLabel;
/** 使用条件   (strong) **/
@property (nonatomic, strong) UILabel *limitTimeLabel;
/** 折扣情况   (strong) **/
@property (nonatomic, strong) UILabel *discountLabel;
/** 分配条件   (strong) **/
@property (nonatomic, strong) UILabel *allocationLabel;
/** 使用条件   (strong) **/
@property (nonatomic, strong) UILabel *conditionLabel;
/** model   (strong) **/
@property (nonatomic, strong) VoucherViewMedel *model;
@end
