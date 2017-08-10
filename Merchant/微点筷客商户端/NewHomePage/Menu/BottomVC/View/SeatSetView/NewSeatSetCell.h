//
//  NewSeatSetCell.h
//  微点筷客商户端
//
//  Created by Skyer God on 16/12/6.
//  Copyright © 2016年 张森森. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DeskSetModel.h"
@interface NewSeatSetCell : UITableViewCell
/** 桌号   (strong) **/
@property (nonatomic, strong) UILabel *numLabel;
/** 类型   (strong) **/
@property (nonatomic, strong) UILabel *deskCategoryLabel;
/** 扫描按钮   (strong) **/
@property (nonatomic, strong) ButtonStyle *scanButton;
/** 删除按钮   (strong) **/
@property (nonatomic, strong) ButtonStyle *deleteButton;
/** id   (strong) **/
@property (nonatomic, copy) NSString *deskId;

/** index   (assign) **/
@property (nonatomic, assign) NSInteger index;
/** model   (strong) **/
@property (nonatomic, strong) DeskSetModel *model;
/** 删除按钮点击回调   (strong) **/
@property (nonatomic, strong) void(^scanOrDeleteClick)(NSInteger count);

@end
