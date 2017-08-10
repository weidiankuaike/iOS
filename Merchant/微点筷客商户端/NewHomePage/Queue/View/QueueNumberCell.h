//
//  QueueNumberCell.h
//  微点筷客商户端
//
//  Created by Skyer God on 2017/7/3.
//  Copyright © 2017年 张甜. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface QueueNumberCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *queueNumLabel;
@property (strong, nonatomic) IBOutlet UILabel *nameLabel;
@property (strong, nonatomic) IBOutlet UILabel *timeLabel;
@property (strong, nonatomic) IBOutlet UILabel *deskTypeLabel;
@property (strong, nonatomic) IBOutlet ButtonStyle *phoneLabel;
@property (strong, nonatomic) IBOutlet UILabel *sourceLabel;

@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *selectButtonArr;

/** 排号状态 （正常入座，号码作废，用户取消）   (strong) **/
@property (strong, nonatomic) IBOutlet UILabel *queueStatusLB;
/** 状态发生时间   (strong) **/
@property (strong, nonatomic) IBOutlet UILabel *historyTimeLB;
// 0正在排号  1 历史排号
+ (void)cellStatus:(NSInteger )status;
@end
