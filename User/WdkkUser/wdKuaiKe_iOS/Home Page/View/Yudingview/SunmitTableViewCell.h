//
//  SunmitTableViewCell.h
//  wdKuaiKe_iOS
//
//  Created by 张森森 on 17/1/16.
//  Copyright © 2017年 weiDianKuaiKe. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SunmitTableViewCell : UITableViewCell

@property (nonatomic,strong)UIButton * addBT;
@property (nonatomic,strong)UIButton * subtractBT;
@property (nonatomic,strong)UILabel * numLabel;
@property (nonatomic,strong)UIImageView * headimage;//头像
@property (nonatomic,strong)UILabel * namelabel;//菜名
@property (nonatomic,strong)UILabel * moneylabel;//价格
@property (copy, nonatomic) void (^plusBlock)(NSMutableDictionary * dishdict,BOOL animated);
@property (nonatomic, assign) NSUInteger number;
@property (nonatomic,copy)NSString * indexstr;
@property (nonatomic,copy)NSString * idstr;

@end

