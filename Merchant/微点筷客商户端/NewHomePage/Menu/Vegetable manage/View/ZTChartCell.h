//
//  ZTChartCell.h
//  merchantClient
//
//  Created by Skyer God on 2017/7/17.
//  Copyright © 2017年 张甜. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DishesAnalyzeModel.h"
@class AnalyzeModel;
@interface ZTChartCell : UITableViewCell
/** <#行注释#>   (strong) **/
@property (nonatomic, strong) DishesAnalyzeModel *model;
/** 查看类型  (NSString) **/
@property (nonatomic, copy) NSString *flowType;
@end
