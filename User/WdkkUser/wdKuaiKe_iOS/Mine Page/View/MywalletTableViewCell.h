//
//  MywalletTableViewCell.h
//  wdKuaiKe_iOS
//
//  Created by 张森森 on 16/12/22.
//  Copyright © 2016年 weiDianKuaiKe. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Mywalletmodel.h"
@interface MywalletTableViewCell : UITableViewCell

@property (nonatomic,strong)UILabel * typelabel,*timelabel,*moneylabel,*zhuangtailabel;
@property (nonatomic,copy)NSString * typestr;
@property (nonatomic,strong)Mywalletmodel * model;
@end
