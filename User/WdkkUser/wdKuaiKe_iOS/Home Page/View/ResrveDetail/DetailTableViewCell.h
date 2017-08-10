//
//  DetailTableViewCell.h
//  wdKuaiKe_iOS
//
//  Created by 张森森 on 17/2/9.
//  Copyright © 2017年 weiDianKuaiKe. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailTableViewCell : UITableViewCell

@property (nonatomic,strong) UILabel * namelabel;
@property (nonatomic,strong) UILabel * pricelabel;
@property (nonatomic,strong)UIButton * addBT;
@property (nonatomic,strong)UIButton * subtractBT;
@property (nonatomic,strong)UILabel * numLabel;
@property (nonatomic,copy)NSString * indexstr;
@property (nonatomic,copy)NSString * idstr;
//增加减少订单数量 需不需要动画效果
@property (copy, nonatomic) void (^plusBlock)(NSMutableDictionary * dishdict,BOOL animated);
@property (nonatomic, assign) NSUInteger number;
@end
