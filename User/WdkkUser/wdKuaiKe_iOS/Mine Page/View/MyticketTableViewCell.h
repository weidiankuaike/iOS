//
//  MyticketTableViewCell.h
//  wdKuaiKe_iOS
//
//  Created by 张森森 on 16/12/21.
//  Copyright © 2016年 weiDianKuaiKe. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyticketModel.h"
@interface MyticketTableViewCell : UITableViewCell

@property (nonatomic,strong)UILabel* storeid,*cardtitle,*cardtype,*discout,*consumover,* begintime,*endtime,*type;
@property (nonatomic,copy)NSString * typest;

@property (nonatomic,strong)MyticketModel * model;

@end
