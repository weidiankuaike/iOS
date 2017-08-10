//
//  JudgeTableViewCell.h
//  微点筷客商户端
//
//  Created by 张森森 on 16/10/19.
//  Copyright © 2016年 张森森. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <UIImageView+WebCache.h>
#import "JudgeModel.h"
//@class JudgeModel;
typedef void (^reloadblock)(NSString * str);

@interface JudgeTableViewCell : UITableViewCell
@property (nonatomic,strong)UIImageView * userImageV;
@property (nonatomic,strong)UILabel * nameLabel,*timelabel,*commentLabel;

@property (nonatomic,strong)JudgeModel * model;
@property (nonatomic,assign)CGFloat picContainerTopMargin;
@property (nonatomic,copy)reloadblock block;

//-(void)getsomethingwithblock:(reloadblock)block;

@end
