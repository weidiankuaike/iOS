//
//  ViewController.m
//  微点筷客商户端
//
//  Created by 张森森 on 16/9/30.
//  Copyright © 2016年 张森森. All rights reserved.
//

#import "ViewController.h"
#import <SDCycleScrollView.h>
#import "LogIninViewController.h"
#import "JoinInViewController.h"
#import "HomeVC.h"
#import "DeviceSet.h"
#import "MBProgressHUD+SS.h"
#import "UINavigationController+FDFullscreenPopGesture.h"

@interface ViewController ()
@property (strong,nonatomic)NSArray *localImages;//本地图片
@property (strong,nonatomic)NSArray *netImages;  //网络图片
@property (strong,nonatomic)SDCycleScrollView *cycleScrollView;//轮播器

@end

@implementation ViewController
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;

    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:YES];
    [self setNeedsStatusBarAppearanceUpdate];

    self.navigationController.fd_fullscreenPopGestureRecognizer.enabled = NO;
}

-(NSArray *)localImages
{
    if (!_localImages) {
        _localImages= @[@"launch_Icon"];
    }
    return _localImages;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor =UIColorFromRGB(0xffffff);
//    [self uploadBaseInfomationToService];
    NSString *acount = [[NSUserDefaults standardUserDefaults] objectForKey:@"loginName"];
//    if (acount == nil) { //删除app后，再次重新装上就会走
//        [DeviceSet saveKeychainValue:@"" key:@"account"];
//        [DeviceSet saveKeychainValue:@"" key:@"pwd"];
//        [self jugeLoginStatusAndJumpViewController];
//    } else {
////        [self lookUpNewestInfoToAutoLogin];
//    }
        if (acount == nil) { //删除app后，再次重新装上就会走
//            [DeviceSet saveKeychainValue:@"" key:@"account"];
//            [DeviceSet saveKeychainValue:@"" key:@"pwd"];
        }
        [self jugeLoginStatusAndJumpViewController];
//    [self handleNotification];

}
//处理远程推送
//- (void)handleNotification{
//    AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
//    NSDictionary *userInfo = app.userInfoDic[@"map"];
//
//}
-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleDefault;
}
-(UIStatusBarAnimation)preferredStatusBarUpdateAnimation{
    return UIStatusBarAnimationFade;
}
//跳转页面 处理
- (void)jugeLoginStatusAndJumpViewController{
    NSString *acount = [[NSUserDefaults standardUserDefaults] objectForKey:@"loginName"];
    NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:LocationLoginInResultsKey];
    if (acount != nil && data != nil && data.length > 10 && [_BaseModel.isChecked integerValue] == 3) {
        HomeVC *homeVC = [[HomeVC alloc] init];
        [self presentViewController:homeVC animated:YES completion:nil];
        self.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    } else {
        //没有入驻完
        [self beforeJohnInSuccess];
    }
}
#pragma mark 等待
//每次启动判断帐号是否被销毁
-(void)lookUpNewestInfoToAutoLogin {
    //通过调用 登录借口，伪登录 判断自动登录

    NSString * url = [NSString stringWithFormat:@"%@merchant/login?loginName=%@&password=%@", kBaseURL, [DeviceSet readKeychainValue:@"account"], [DeviceSet readKeychainValue:@"pwd"]];
        
    [[QYXNetTool shareManager] postNetWithUrl:url urlBody:nil bodyStyle:QYXBodyString header:nil response:QYXJSON success:^(id result){
        [MBProgressHUD hideHUD];
//        ZTLog(@"llll%@",result);
        NSString * codeStatus = [result objectForKey:@"msgType"];

        if ([codeStatus integerValue]==1002) {
            [SVProgressHUD showErrorWithStatus:@"验证码错误😓"];
            LogIninViewController *loginVC = [[LogIninViewController alloc] init];
            [self.navigationController pushViewController:loginVC animated:YES];
            [self beforeJohnInSuccess];
        } else if ([codeStatus integerValue]==1003) {
            [SVProgressHUD showErrorWithStatus:@"密码错误"];
            LogIninViewController *loginVC = [[LogIninViewController alloc] init];
            [self.navigationController pushViewController:loginVC animated:YES];
            [self beforeJohnInSuccess];
        } else if ([codeStatus integerValue]==1001) {
            [self beforeJohnInSuccess];
            NSUserDefaults * userde = [NSUserDefaults standardUserDefaults];
//            NSData *archData = [NSKeyedArchiver  archivedDataWithRootObject:@"error"];
            [userde setObject:@"error" forKey:LocationLoginInResultsKey];
            [userde setObject:@"reset" forKey:@"loginName"];
            [userde setObject:@"error" forKey:@"token"];
        } else if ([codeStatus integerValue]==0) {

            //            NSUserDefaults * userde = [NSUserDefaults standardUserDefaults];
            ////            NSData *archData = [NSKeyedArchiver  archivedDataWithRootObject:result[@"obj"]];
            ////            [userde setObject:archData forKey:LocationLoginInResultsKey];
            //            [userde setObject:result[@"obj"][@"token"] forKey:@"token"];

            [self jugeLoginStatusAndJumpViewController];
        }
    } failure:^(NSError *error)
     {
         [MBProgressHUD showError:@"网络错误"];
         [MBProgressHUD hideHUD];
     }];
}
//入驻前处理
- (void)beforeJohnInSuccess{
    self.automaticallyAdjustsScrollViewInsets = NO;
    NSString *acount = [[NSUserDefaults standardUserDefaults] objectForKey:@"loginName"];
    if (acount == nil) { //第一次进入app 或者 删除app后，再次重新装上就会走
        //只展示一张图片 没有轮播图
    } else {
        
    }

//    CGRect rect = CGRectMake(0, 0, self.view.bounds.size.width, autoScaleH(540));
    self.cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:self.view.frame imageURLStringsGroup:self.localImages];
    self.cycleScrollView.showPageControl = YES;
    self.cycleScrollView.pageControlAliment= SDCycleScrollViewPageContolAlimentCenter;
    self.cycleScrollView.currentPageDotColor = RGB(234, 158, 56);
    self.cycleScrollView.pageDotColor = [UIColor whiteColor];

    [self.view addSubview:self.cycleScrollView];

    NSArray * colorary = @[RGB(234, 158, 56),RGB(85, 153, 208)];
    NSArray * titary = @[@"我要入驻",@"登录系统",];

    for (int i=0; i<2; i++) {

        ButtonStyle * twobtn = [ButtonStyle buttonWithType:UIButtonTypeCustom];
        [twobtn setBackgroundColor:colorary[i]];
        twobtn.tag = 100+i;
        [twobtn setTitle:titary[i] forState:UIControlStateNormal];
        [twobtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        twobtn.titleLabel.font = [UIFont systemFontOfSize:autoScaleW(15)];
        [twobtn addTarget:self action:@selector(GotoNext:) forControlEvents:UIControlEventTouchUpInside];
        twobtn.userInteractionEnabled = YES;
        [self.cycleScrollView addSubview:twobtn];
//        twobtn.sd_layout.leftSpaceToView(self.view,autoScaleW(35)+i*autoScaleW(180)).topSpaceToView(self.cycleScrollView,autoScaleH(30)).widthIs(autoScaleW(130)).heightIs(autoScaleH(38));
        CGFloat width = autoScaleW(140);
        CGFloat space = autoScaleW(20) * 2;
        CGFloat height = autoScaleH(38);
        if (isPadd) {
            width = autoScaleW(180);
            space = autoScaleW(40) * 2;
            height = autoScaleH(45);
        }
        CGFloat start_x = (self.view.size.width - width * 2 - space ) / 2;

        twobtn.sd_layout
        .leftSpaceToView(_cycleScrollView, (start_x) + i*(width + space))
        .bottomSpaceToView(_cycleScrollView, (autoScaleH(80)))
        .widthIs((width))
        .heightIs((height));

    }
}
-(void)GotoNext:(ButtonStyle *)btn
{
    if (btn.tag==100) {
        JoinInViewController * joininview = [[JoinInViewController alloc]init];
        [self.navigationController pushViewController:joininview animated:NO];
    }
    if (btn.tag==101) {

        LogIninViewController * loginView = [[LogIninViewController alloc]init];
        [self.navigationController pushViewController:loginView animated:NO];

    }

}
-(BOOL)prefersStatusBarHidden
{
    return YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
