//
//  ServeTableViewCell.h
//  微点筷客商户端
//
//  Created by 张森森 on 16/10/13.
//  Copyright © 2016年 张森森. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SceneInfoModel.h"
@interface ServeTableViewCell : UITableViewCell
@property (nonatomic,strong)UILabel * firstlabel,*secondlabel,* timelabel;
@property (nonatomic, strong) ButtonStyle * responseBt;
@property (nonatomic, strong) dispatch_source_t timer;//定时器开始执行的延时时间
/** 计时总数   (NSInteger) **/
@property (nonatomic, assign) NSInteger beginTime;
/** 应答回调  (NSString) **/
@property (nonatomic, copy) void(^responseBlock)(SceneInfoModel *model);
/** model(strong) **/
@property (nonatomic, strong) SceneInfoModel *model;
/** index   (NSInteger) **/
@property (nonatomic, assign) NSInteger index;
@end
