//
//  ServiceCategoryVC.h
//  微点筷客商户端
//
//  Created by Skyer God on 16/10/18.
//  Copyright © 2016年 张森森. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseNaviSetVC.h"
@interface ServiceCategoryVC : BaseNaviSetVC
/** 入驻页面回调  (NSString) **/
@property (nonatomic, copy) void(^returnJoinInVC)(NSString *arrStr);
@end
