//
//  ResviceDetail.h
//  wdKuaiKe_iOS
//
//  Created by 张森森 on 17/2/8.
//  Copyright © 2017年 weiDianKuaiKe. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^dineblock) (NSMutableArray *dictary,BOOL change,NSString*feestr);
@interface ResviceDetail : UIView <UITableViewDelegate,UITableViewDataSource,UIGestureRecognizerDelegate>
@property (nonatomic,strong)NSMutableArray * dictary;
@property (nonatomic, strong) UITableView * detailtable;
@property (nonatomic,assign)BOOL remove;
//@property (nonatomic,retain)NSIndexPath* index;
@property (nonatomic,copy)dineblock  block;
@property (nonatomic,strong)NSDictionary * notdict;
- (id)initWithary:(NSMutableArray*)dictary;

@end
