//
//  MyorderTableViewCell.h
//  WDKKtest
//
//  Created by 张森森 on 16/8/7.
//  Copyright © 2016年 weiDianKuaiKe. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Myordermodel.h"
#import "MBProgressHUD+SS.h"
#import "QYXNetTool.h"
typedef void (^delectblock)(NSString * endstr);
@interface MyorderTableViewCell : UITableViewCell

@property (nonatomic,strong)UIImageView * headimage;
@property(nonatomic,strong)UILabel * firstlabel,*secondLabel,*threeLabel,*fourLabel,*fukuanlabel,*querenlabel,* namelabel,* ztlabel,* xinxilabel,* moneylabel,* arrvaltimelabel,* timelabel;
@property (nonatomic,strong)UILabel * endtimelabel;//待支付或待接单时 倒计时label
@property (nonatomic,strong)NSMutableArray * xinxiary,*timeary;
@property (nonatomic,strong)Myordermodel * model;
@property (nonatomic,strong)UIButton * btn;//每个cell都有
@property (nonatomic,strong)UIButton * deletbtn;//有的有
@property (nonatomic,retain)dispatch_source_t timer;
@property (nonatomic,copy)delectblock block;
@property (nonatomic,assign)NSInteger timeterval;
@property (nonatomic,assign)NSInteger index;
@end
