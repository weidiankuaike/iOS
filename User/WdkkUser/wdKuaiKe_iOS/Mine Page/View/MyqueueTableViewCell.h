//
//  MyqueueTableViewCell.h
//  wdKuaiKe_iOS
//
//  Created by 张森森 on 2017/7/3.
//  Copyright © 2017年 weiDianKuaiKe. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyqueueTableViewCell : UITableViewCell
@property (nonatomic,strong)UILabel * timeLabel;//排队等待时间
@property (nonatomic,strong)UIImageView * storeImage;//店铺图片
@property (nonatomic,strong)UILabel * numberLael;//排队编号
@property (nonatomic,strong)UILabel * storeName;//店铺名称
@property (nonatomic,strong)UIImageView * arrowImage;//箭头
@property (nonatomic,strong)UIView * queueView;//大视图;
@end
