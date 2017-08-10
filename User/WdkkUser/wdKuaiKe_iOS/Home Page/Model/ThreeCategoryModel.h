//
//  ThreeCategoryModel.h
//  wdKuaiKe_iOS
//
//  Created by Skyer God on 16/9/6.
//  Copyright © 2016年 weiDianKuaiKe. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ThreeCategoryModel : NSObject

@property(nonatomic, strong) NSNumber *id;
@property(nonatomic, strong) NSNumber *index;
@property(nonatomic, strong) NSNumber *parentID;
@property(nonatomic, strong) NSNumber *count;
@property(nonatomic, strong) NSString *name;


@property(nonatomic, strong) NSMutableArray *list;
@end
