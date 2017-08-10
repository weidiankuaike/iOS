//
//  RootViewController.h
//  微点筷客商户端
//
//  Created by Skyer God on 16/10/13.
//  Copyright © 2016年 zt. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "LeftViewController.h"

@interface RootViewController : UIViewController
- (id)initWithCenterVC:(UIViewController *)centerVC leftVC:(LeftViewController *)leftVC;
@end
