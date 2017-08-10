//
//  QueueTableViewCell.h
//  微点筷客商户端
//
//  Created by 张森森 on 16/11/10.
//  Copyright © 2016年 张森森. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QueueModel.h"
 typedef void(^timerblock)(NSString* string);

@interface QueueTableViewCell : UITableViewCell
@property (nonatomic,strong)UIImageView * headImageV,*timeImageV;
@property (nonatomic,strong)UILabel * nameLabel,* timeLabel,*tiShiLabel;

@property (nonatomic,retain)dispatch_source_t timer;
/// 倒计时到0时回调
@property (nonatomic, copy) void(^timeOverOrAbandonedBlock)(BOOL);
/** indes   (NSInteger) **/
@property (nonatomic, assign) NSInteger index;
//确定到店
@property (nonatomic,strong)ButtonStyle * sureBT;

/** model   (strong) **/
@property (nonatomic, strong) QueueModel *model;

/** 点击已到店回调   (strong) **/
@property (nonatomic, copy) void(^sureClickIsArrivedBlock)(BOOL);

/** 正在用餐的回调  (NSString) **/
@property (nonatomic, copy) void(^startEatingBlock)(BOOL);

@end
