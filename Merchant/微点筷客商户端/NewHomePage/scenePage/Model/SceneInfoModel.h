//
//  SceneInfoModel.h
//  微点筷客商户端
//
//  Created by Skyer God on 17/1/17.
//  Copyright © 2017年 张森森. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SceneInfoModel : NSObject
/** 服务id  (NSString) **/
@property (nonatomic, copy) NSString *id;
/** 桌号  (NSString) **/
@property (nonatomic, copy) NSString *boardNum;
/** 提供的服务  (NSString) **/
@property (nonatomic, copy) NSString *service;
/** 请求的类型  (NSString) **/
@property (nonatomic, copy) NSString *type;
/** 时间差  (NSString) **/
@property (nonatomic, copy) NSString *timeGap;
/** 创建时间  (NSString) **/
@property (nonatomic, copy) NSString *createTime;
/** 员工ID  (NSString) **/
@property (nonatomic, copy) NSString *staffId;
/** 用户Id  (NSString) **/
@property (nonatomic, copy) NSString *userId;

@end
