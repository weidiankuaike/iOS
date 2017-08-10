//
//  CanuserTicketViewController.h
//  wdKuaiKe_iOS
//
//  Created by 张森森 on 16/12/30.
//  Copyright © 2016年 weiDianKuaiKe. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^userblock) (NSString * typestr,NSString * moneystr,NSString * idstr);
@interface CanuserTicketViewController : UIViewController
@property (nonatomic,strong)NSArray * listary;
@property (nonatomic,copy)userblock blck;

-(void)getsomethingwithblock:(userblock)block;

@end
