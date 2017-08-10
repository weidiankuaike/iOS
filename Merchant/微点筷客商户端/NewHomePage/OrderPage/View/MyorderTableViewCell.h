//
//  MyorderTableViewCell.h
//  微点筷客商户端
//
//  Created by 张森森 on 16/11/2.
//  Copyright © 2016年 张森森. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OrderModel.h"
@interface MyorderTableViewCell : UITableViewCell
@property (nonatomic,strong)UIImageView* headimage;
@property (nonatomic,strong)UILabel * namelabel,*timelabel,*xinxilabel,*moneylabel,*numberlabel,*ydtimelabel;
@property (nonatomic,assign)NSInteger moneyinteger;
@property (nonatomic,strong)ButtonStyle * shoosebtn,*deletbtn;
/** 标示订单状态   (NSInteger) **/
@property (nonatomic, assign) NSInteger orderStatus;
/** <#行注释#>   (strong) **/
@property (nonatomic, strong) OrderModel *model;
@end
