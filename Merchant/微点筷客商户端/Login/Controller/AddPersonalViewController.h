//
//  AddPersonalViewController.h
//  微点筷客商户端
//
//  Created by 张森森 on 16/10/9.
//  Copyright © 2016年 张森森. All rights reserved.
//

#import "BaseNaviSetVC.h"
#import "StuffAccountModel.h"
@interface AddPersonalViewController : BaseNaviSetVC

@property (nonatomic,assign)NSInteger boolinteger; // 0 添加  1修改
@property (nonatomic,strong)NSArray * xinxiary;
@property (nonatomic,strong)NSMutableArray * quanxianary;

/** cell model   (strong) **/
@property (nonatomic, strong) StuffAccountModel *model;
/** 修改成功回调   (strong) **/
@property (nonatomic, strong) void(^changStaffInfoSccess)(BOOL success);
@end
