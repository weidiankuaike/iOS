//
//  NSObject+JudgeNull.h
//  微点筷客商户端
//
//  Created by Skyer God on 16/12/6.
//  Copyright © 2016年 张森森. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (JudgeNull)
- (BOOL)isNull;
//餐桌与桌号设置
- (NSString *)judgeDeskPeopleNumFromDeskCategory:(NSString *)category;
- (NSString *)judgeDeskCategoryFromString:(NSString *)category;
@end
