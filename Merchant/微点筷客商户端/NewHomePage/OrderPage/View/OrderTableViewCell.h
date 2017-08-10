//
//  OrderTableViewCell.h
//  微点筷客商户端
//
//  Created by 张森森 on 16/10/10.
//  Copyright © 2016年 张森森. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OrderModel.h"
@interface OrderTableViewCell : UITableViewCell

@property (nonatomic,strong)UIImageView* headimage;
@property (nonatomic,strong)UILabel * namelabel,*timelabel,*xinxilabel,*moneylabel,*numberlabel,*ydtimelabel;

@property (nonatomic,assign)NSInteger moneyinteger;
@property (nonatomic,strong)ButtonStyle * shoosebtn,*deletbtn;
@property (nonatomic,strong)OrderModel * model;
@end
