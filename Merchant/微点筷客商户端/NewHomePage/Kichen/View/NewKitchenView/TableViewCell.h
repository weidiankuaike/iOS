//
//  TableViewCell.h
//  微点筷客商户端
//
//  Created by Skyer God on 16/11/9.
//  Copyright © 2016年 张森森. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OutKitchenModel.h"
typedef void(^longGesturePress)();



@interface TableViewCell : UITableViewCell

/** 切换查看状态   (strong) **/
@property (nonatomic, assign) BOOL isDeskSearch;

@property (nonatomic, copy) longGesturePress longGR;
/** 设置外层右滑手势回调   (strong) **/
@property (nonatomic, copy) void(^swipRightComplete)(BOOL isComplete);


/** 指示箭头   (strong) **/
@property (nonatomic, strong) UIImageView *indicatorImageV;
/** 外层名称   (strong) **/
@property (nonatomic, strong) UILabel *outNameLabel;
/** 份数   (strong) **/
@property (nonatomic, strong) UILabel *outNumLabel;
/** 提示   (strong) **/
@property (nonatomic, strong) UILabel *promptLabel;



/** 内置tablev   (strong) **/
@property (nonatomic, strong) UITableView *innerTabelV;


@property(nonatomic,copy)void (^sendClick)(NSInteger outIndex,NSInteger in_index, BOOL isShowInnerDeleteLine);
@property (nonatomic, copy) void (^click)(NSInteger outIndex);
+(CGFloat)cellHeight;
/** <#行注释#>   (strong) **/
@property (nonatomic, strong) OutKitchenModel *model;
@property(nonatomic,assign)NSInteger index;


//缺货登记上传完成回调
@property (nonatomic, copy) void(^lackFoodUploadCompleted)(BOOL completed);
@end
