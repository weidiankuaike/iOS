//
//  QueueModel.h
//  微点筷客商户端
//
//  Created by 张森森 on 16/11/10.
//  Copyright © 2016年 张森森. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface QueueModel : NSObject
/** 桌号  (NSString) **/
@property (nonatomic, copy) NSString *boardNum;
/** 是否到店  (NSString) **/
@property (nonatomic, copy) NSString *isArrive;
/** 桌型  (NSString) **/
@property (nonatomic, copy) NSString *boardType;
/** 排队时间  (NSString) **/
@property (nonatomic, copy) NSString *queueTime;
/** 用户id  (NSString) **/
@property (nonatomic, copy) NSString *userId;
/** 排队号组合  (NSString) **/
@property (nonatomic, copy) NSString *queue;
/** createTime  (NSString) **/
@property (nonatomic, copy) NSString *createTime;
/** 计时差  (NSString) **/
@property (nonatomic, assign) NSInteger timeGap;
/** 排队号数字  (NSString) **/
@property (nonatomic, copy) NSString *queueNum;
@end
