//
//  DeskSetModel.h
//  微点筷客商户端
//
//  Created by Skyer God on 16/12/16.
//  Copyright © 2016年 张森森. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DeskSetModel : NSObject
/** 桌号ID  (NSString) **/
@property (nonatomic, copy) NSString *boardId;
/** 桌号  (NSString) **/
@property (nonatomic, copy) NSString *boardNum;
/** 桌号类型  (NSString) **/
@property (nonatomic, copy) NSString *boardType;
/** 判断是否绑定  (NSString) **/
@property (nonatomic, copy) NSString *isBind;
/** 添加桌号的左边pickerView数据源,用作上传判断类型   (strong) **/
@property (nonatomic, strong) NSDictionary *leftDic;
@end
