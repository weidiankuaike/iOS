//
//  InnerKitchenCell.h
//  微点筷客商户端
//
//  Created by Skyer God on 16/11/9.
//  Copyright © 2016年 张森森. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "InnerKitchenModel.h"

typedef void (^swipRightComplete)(BOOL isShowDeleteLine);
@interface InnerKitchenCell : UITableViewCell
/** <#行注释#>   (strong) **/
@property (nonatomic, strong) InnerKitchenModel *model;

/** 图片   (strong) **/
@property (nonatomic, strong) UIImageView *imageV;
/** 名字   (strong) **/
@property (nonatomic, strong) UILabel *nameLabel;
/** 数量   (strong) **/
@property (nonatomic, strong) UILabel *numLabel;

/** 排序方式   (strong) **/
@property (nonatomic, assign) BOOL isDeskSearch;
+ (CGFloat)cellHeight;




/** 提示label   (strong) **/
@property (nonatomic, strong) UILabel *promptLabel;

/** 设置里层cell回调   (copy) **/
@property (nonatomic, copy) swipRightComplete swipRightComplete;

@property (nonatomic, strong) NSIndexPath *innerIndexPath;

/** 删除线   (strong) **/
@property (nonatomic, strong) UILabel *deleteLineLabel;
@end
