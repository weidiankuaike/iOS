//
//  KitchenVC.h
//  微点筷客商户端
//
//  Created by Skyer God on 16/11/9.
//  Copyright © 2016年 张森森. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
@interface KitchenVC : BaseViewController
/** 点击外层cell的回调   (strong) **/
@property (nonatomic, copy)  void (^outCellClick)(NSIndexPath *clickIndexPath);
@end
