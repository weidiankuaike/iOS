//
//  NewActivityCell.h
//  微点筷客商户端
//
//  Created by Skyer God on 2017/5/22.
//  Copyright © 2017年 张森森. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VoucherViewMedel.h"
@interface NewActivityCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *dicountLabel;
@property (strong, nonatomic) IBOutlet UILabel *conditionLabel;
@property (strong, nonatomic) IBOutlet UILabel *timeLabel;
/** model   (strong) **/
@property (nonatomic, strong) VoucherViewMedel *model;
@property (strong, nonatomic) IBOutlet UILabel *distributeLabel;
/** 判断是卡券或者活动优惠   (NSInteger) **/
@property (nonatomic, assign) BOOL isVoucherCard;
+ (void)isVoucherCard:(BOOL)isVoucherCard;
@end
