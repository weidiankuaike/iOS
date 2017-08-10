//
//  LoginTableViewCell.h
//  微点筷客商户版
//
//  Created by 张森森 on 16/9/30.
//  Copyright © 2016年 张森森. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoginTableViewCell : UITableViewCell
/** 选中的index   (NSInteger) **/
@property (nonatomic, assign) NSInteger index;
@property(nonatomic,strong)UILabel * leftlabel;
@property (nonatomic,strong)UITextField * textfild;
/** cell标示  (NSString) 不得已添加此标示，别问为什么 **/
@property (nonatomic, copy) NSString *identify;
@end
