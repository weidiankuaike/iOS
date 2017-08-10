//
//  BusinessErectViewController.h
//  微点筷客商户端
//
//  Created by 张森森 on 16/10/10.
//  Copyright © 2016年 张森森. All rights reserved.
//

#import "BaseNaviSetVC.h"
typedef void(^xblock) (NSString*sstring);

@interface BusinessErectViewController : BaseNaviSetVC
@property (nonatomic,copy)xblock block;

-(void)getstring:(xblock)block;
@end
