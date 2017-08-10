//
//  JudgeModel.h
//  wdKuaiKe_iOS
//
//  Created by 张森森 on 17/3/8.
//  Copyright © 2017年 weiDianKuaiKe. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JudgeModel : NSObject
@property (nonatomic,copy)NSString * avatar;//头想
@property (nonatomic,copy)NSString * content;//评价内容
@property (nonatomic,copy)NSString * createTime;
@property (nonatomic,copy)NSString * likeFood;
@property (nonatomic,strong)NSArray * merchantReply;
@property (nonatomic,copy)NSString * score;
@property (nonatomic,copy)NSString * tag;
@property (nonatomic,copy)NSString * userName;
@property (nonatomic,copy)NSString * evalImage;


@end
