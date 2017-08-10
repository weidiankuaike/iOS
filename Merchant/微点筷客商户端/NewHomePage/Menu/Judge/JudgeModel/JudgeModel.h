//
//  JudgeModel.h
//  微点筷客商户端
//
//  Created by 张森森 on 16/11/25.
//  Copyright © 2016年 张森森. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CommentModel.h"
/**
 * param urlStr - avatar 头像
 * param content -       评价内容
 * param evalimagestr - evalImage 上传的图片
 * param likeFood -         点赞后的菜
 * param merchantStr - merchantReply 商户返回内容
 * param tagstr - tag   标签
 * param creatime - createTime 创建时间
 * param username - userName 用户名称
 * param scorestr - score 评分
 * param idstr - id 用户ID
 * param likefoodary ＋＋  NSArray  VC转换
 * param tagary
 * param imageary
 */


@interface JudgeModel : NSObject

//@property (nonatomic,copy)NSString * urlstr,*content,*evalimagestr,*likefood,*merchantstr,*tagstr,*creatime,*username,*scorestr,*idstr;
//@property (nonatomic,strong)NSMutableArray * likefoodary,*tagary,*imageary;
//-(id)initWithdict:(NSDictionary*)dict;

/** 头像  (NSString) **/
@property (nonatomic, copy) NSString *avatar;
/** 评价内容  (NSString) **/
@property (nonatomic, copy) NSString *content;
/** 上传的图片  (NSString) **/
@property (nonatomic, copy) NSString *evalImage;
/** 点赞后的菜  (NSString) **/
@property (nonatomic, copy) NSString *likeFood;
/** 商户恢复类容  (NSString) **/
@property (nonatomic, copy) NSMutableArray *merchantReply;
/** 标签  (NSString) **/
@property (nonatomic, copy) NSString *createTime;
/** 用户名称  (NSString) **/
@property (nonatomic, copy) NSString *userName;
/** 评分  (NSString) **/
@property (nonatomic, copy) NSString *score;
/** 用户ID  (NSString) **/
@property (nonatomic, copy) NSString *id;
/** 店铺综合评分  (NSString) **/
@property (nonatomic, copy) NSString *avgScore;
/** 评价个数  (NSString) **/
@property (nonatomic, copy) NSString *cnt;
/** 总标签  (NSString) **/
@property (nonatomic, copy) NSString *tagMap;
/** 评价等级  (NSString) **/
@property (nonatomic, copy) NSString *evalLevel;
/** 标签  (NSString) **/
@property (nonatomic, copy) NSString *tag;
/** 用户评论ID 第一条  (NSString) **/
@property (nonatomic, copy) NSString *evalId;


@end
