//
//  TableViewCell.h
//  微点筷客商户端
//
//  Created by Skyer God on 17/1/10.
//  Copyright © 2017年 张森森. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StuffAccountModel.h"
@interface StaffInfoCell : UITableViewCell
///** 员工信息model   (strong) **/
//@property (nonatomic, strong) StuffAccountModel *model;
/** 表索引   (strong) **/
@property (nonatomic, assign) NSInteger section;
+(CGFloat)setIndexPath:(NSIndexPath *)indexP withModel:(StuffAccountModel *)model;
@end
