//
//  BusinessTimeModel.h
//  微点筷客商户端
//
//  Created by Skyer God on 17/1/9.
//  Copyright © 2017年 张森森. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BusinessTimeModel : NSObject
/** 周一  (NSString) **/
@property (nonatomic, copy) NSString *businessMonday;
/** 2  (NSString) **/
@property (nonatomic, copy) NSString *businessTuesday;
/** 星期三 (NSString) **/
@property (nonatomic, copy) NSString *businessWednesday;
/** 星期4  (NSString) **/
@property (nonatomic, copy) NSString *businessThursday;
/** 5businessFriday  (NSString) **/
@property (nonatomic, copy) NSString *businessFriday;
/** 6  (NSString) **/
@property (nonatomic, copy) NSString *businessSaturday;
/** 7  (NSString) **/
@property (nonatomic, copy) NSString *businessSunday;
@end
