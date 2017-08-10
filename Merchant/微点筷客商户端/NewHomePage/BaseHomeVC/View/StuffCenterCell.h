//
//  StuffCenterCell.h
//  微点筷客商户端
//
//  Created by Skyer God on 17/2/23.
//  Copyright © 2017年 张森森. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface StuffCenterCell : UITableViewCell
/** index   (NSInteger) **/
@property (nonatomic, strong) NSIndexPath *indexP;
/** 开关   (strong) **/
@property (nonatomic, strong) UISwitch *switchBT;
/** 供职   (strong) **/
@property (nonatomic, strong) UILabel *detailLB;
/** lock   (strong) **/
@property (nonatomic, strong) ButtonStyle *lockButton;
@end
