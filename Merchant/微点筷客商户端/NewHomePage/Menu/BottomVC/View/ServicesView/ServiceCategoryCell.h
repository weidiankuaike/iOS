//
//  ServiceCategoryCell.h
//  微点筷客商户端
//
//  Created by Skyer God on 16/11/22.
//  Copyright © 2016年 张森森. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^deleteClick)(NSInteger index);
@interface ServiceCategoryCell : UITableViewCell
/** 主标题   (strong) **/
@property (nonatomic, strong) UILabel *titleLabel;
/** 删除按钮   (strong) **/
@property (nonatomic, strong) ButtonStyle *deleteBT;

/** 删除点击按钮回调  (NSString) **/
@property (nonatomic, copy) deleteClick deleteClick;
@property (nonatomic, assign) NSInteger index;
@end
