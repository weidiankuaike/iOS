//
//  LoginViewController.h
//  WDKKtest
//
//  Created by 张森森 on 16/8/3.
//  Copyright © 2016年 weiDianKuaiKe. All rights reserved.
//

#import <UIKit/UIKit.h>
//typedef void(^secBlock)(NSString*phonestring,NSString*namestring,NSString*imagestring);

@interface LoginViewController : UIViewController
@property(nonatomic,strong)NSString * namestring;
@property (nonatomic,strong)NSString * imagestring;
@property (nonatomic,strong)NSString * phonestring;
@property (nonatomic,copy)NSString * logintype;
@property (nonatomic,assign)NSInteger putInt;
//@property (nonatomic,copy)secBlock block;
//-(void)text:(secBlock)block;

@end
