//
//  NSMutableDictionary+Observer.h
//  微点筷客商户端
//
//  Created by Skyer God on 2017/5/23.
//  Copyright © 2017年 张森森. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UIView (Observer)
/** setObjectForKey之后的回调block */
@property (nonatomic, copy) void(^didAddsubView)();
@end
