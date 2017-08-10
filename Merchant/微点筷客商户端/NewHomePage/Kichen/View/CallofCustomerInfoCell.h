//
//  CallofCustomerInfoCell.h
//  微点筷客商户端
//
//  Created by Skyer God on 16/10/14.
//  Copyright © 2016年 张森森. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CallofCustomerInfoCell : UITableViewCell
/** 喇叭   (strong) **/
@property (nonatomic, strong) UIImageView *imageV;
/** 27号桌客人叫餐   (strong) **/
@property (nonatomic, strong) UILabel *callInfoLabel;
/** 查看button   (strong) **/
@property (nonatomic, strong) ButtonStyle *checkBT;
/** 上菜button   (strong) **/
@property (nonatomic, strong) ButtonStyle *recivBT;
@end
