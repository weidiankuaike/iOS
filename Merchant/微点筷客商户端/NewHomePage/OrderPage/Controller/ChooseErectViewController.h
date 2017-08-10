//
//  ChooseErectViewController.h
//  微点筷客商户端
//
//  Created by 张森森 on 16/10/17.
//  Copyright © 2016年 张森森. All rights reserved.
//

#import "BaseNaviSetVC.h"
typedef void(^cleblock) (NSString*sstring,NSString*boolstr);

@interface ChooseErectViewController : BaseNaviSetVC
@property (nonatomic,strong)NSArray * array;
@property (nonatomic,assign)NSInteger chooseinteger;
@property (nonatomic,copy)cleblock block;
-(void)getstring:(cleblock)block;
@end
