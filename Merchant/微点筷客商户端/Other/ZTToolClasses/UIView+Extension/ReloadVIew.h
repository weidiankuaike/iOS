//
//  ReloadVIew.h
//  微点筷客商户端
//
//  Created by Skyer God on 2017/5/9.
//  Copyright © 2017年 张森森. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef  void (^ReloadUrlSuccess)(BOOL success);
@interface ReloadVIew : UIView
@property (nonatomic,strong) ButtonStyle *confirmBT;
/** 点击确定后回调  (NSString) **/
@property (nonatomic, copy) void(^reloadSuccess)(BOOL success);


+(ReloadVIew *)defaultReloadVew;
+(void)registerReloadView:(UIViewController *)viewController;
+(void)clearReloadViewSuperClass;
-(void)showView;
-(void)refreshNowNetRequiringViewController;
-(void)captureURL:(NSString *)reloadUrl complete:(ReloadUrlSuccess)complete;
@end
