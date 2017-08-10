//
//  ScopeViewController.h
//  微点筷客商户端
//
//  Created by 张森森 on 16/10/27.
//  Copyright © 2016年 张森森. All rights reserved.
//

#import "BaseNaviSetVC.h"
typedef void(^sblock) (NSString*sstring);

@interface ScopeViewController : BaseNaviSetVC
@property (nonatomic,copy)sblock block;
@property (nonatomic,strong)NSMutableArray * btnary;
@property (nonatomic,assign)NSInteger ztinteger;
-(void)getstring:(sblock)block;
@end
