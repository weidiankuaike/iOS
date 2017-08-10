//
//  DishesCollectionReusableView.h
//  微点筷客商户端
//
//  Created by Skyer God on 16/10/19.
//  Copyright © 2016年 张森森. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DishesCollectionReusableView : UICollectionReusableView
/** 头视图title   (strong) **/
@property (nonatomic, strong) UILabel *titleLabel;
/** 全选删除   (strong) **/
@property (nonatomic, strong) ButtonStyle *selectAllBT;
/** index   (NSInteger) **/
@property (nonatomic, strong) NSIndexPath *indexP;

/** <#注释#>  (NSString) **/
@property (nonatomic, copy) void(^deleteClick)(NSIndexPath *indexP);
@end
