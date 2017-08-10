//
//  QueueNumberInfoCell.h
//  微点筷客商户端
//
//  Created by Skyer God on 17/1/20.
//  Copyright © 2017年 张森森. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QueueNumberInfoCell : UITableViewCell
/** 信息组   (strong) **/
@property (nonatomic, strong) NSMutableDictionary *infoDic;
/** 出号后回调  (NSString) **/
@property (nonatomic, copy) void(^manualWorkSuccess)(BOOL);
@end
