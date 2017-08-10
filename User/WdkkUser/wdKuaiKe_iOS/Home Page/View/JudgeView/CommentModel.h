//
//  CommentModel.h
//  微点筷客商户端
//
//  Created by Skyer God on 17/2/10.
//  Copyright © 2017年 张森森. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CommentModel : NSObject
/** 评论  (NSString) **/
@property (nonatomic, copy) NSString *content;
/** 评论时间  (NSString) **/
@property (nonatomic, copy) NSString *createTime;
/** 第一条评论的id  (NSString) **/
@property (nonatomic, copy) NSString *evalId;
/** 其他评论id  (NSString) **/
@property (nonatomic, copy) NSString *id;
/** 是否是用户  (NSString) **/
@property (nonatomic, copy) NSString *isUser;
/** 店铺id  (NSString) **/
@property (nonatomic, copy) NSString *storeId;
/** 用户id  (NSString) **/
@property (nonatomic, copy) NSString *userId;
/** version  (NSString) **/
@property (nonatomic, copy) NSString *version;
/** 用户名  (NSString) **/
@property (nonatomic, copy) NSString *userName;
/** 回复的名字  (NSString) **/
@property (nonatomic, copy) NSString *firstUserName;
/** 第二个名字  (NSString) **/
@property (nonatomic, copy) NSString *secondUserName;
@end
