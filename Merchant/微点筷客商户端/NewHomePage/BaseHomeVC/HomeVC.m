//
//  HomeVC.m
//  微点筷客商户端
//
//  Created by Skyer God on 16/10/17.
//  Copyright © 2016年 张森森. All rights reserved.
//

#import "HomeVC.h"
#import "RootViewController.h"
#import "LeftViewController.h"

#import "MyorderViewController.h"
#import "SceneViewController.h"

#import "KitchenVC.h"
#import "QueueVC0703.h"
#import "LoginInfoModel.h"
#import "LoginStoreInfoModel.h"
#import "XGPush.h"
#import "XGSetting.h"
#import "DeviceSet.h"
@interface HomeVC ()<UITabBarControllerDelegate>
{
    LoginInfoModel *model;
}
@property (nonatomic, retain) UITabBarController *tabController;
@property (nonatomic, strong) UIWindow *window;
@end

@implementation HomeVC

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:NO];
    [self initWithTabBarController:nil];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(initWithTabBarController:) name:@"initWithTabBarController" object:nil];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    //设置推送帐号
    [self registerXgPushAccount];
    [self uploadBaseInfomationToService];
    [self getOrderTax];

}
- (void)getOrderTax{
    //获取扣出费用比
    NSString *keyUrl = @"/common/getPer";
    NSString *loadUrl = [NSString stringWithFormat:@"%@%@", kBaseURL, keyUrl];
    [[QYXNetTool shareManager] getNetWithUrl:loadUrl urlBody:nil header:nil response:QYXJSON success:^(id result) {
        if ([result[@"msgType"] integerValue] == 0) {
            [[NSUserDefaults standardUserDefaults] setValue:result[@"obj"] forKey:@"wdkkTax"];
        }
    } failure:^(NSError *error) {

    }];
}
//登录成功 必然进此类， 在此把用户帐号和推送关联
//上传 推送token 设备类型device 设备ID deviceId  账户名 account
- (void)uploadBaseInfomationToService{

    NSString *keyUrl = @"operXingeApp";

    /* ＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊ 获取UID ＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊*/

    NSString *deviceId = [DeviceSet readKeychainValue:@"deviceUID"];
    if (deviceId == nil) {
        deviceId = [DeviceSet randomUUID];
    }
    NSString *device = @"ios";
    NSString *token = [DeviceSet readKeychainValue:@"deviceToken"];
    NSString *account = [NSString stringWithFormat:@"m%@", UserId];
    NSString *userId = UserId;
    NSString *isUser = @"1";
    NSString *uploadUrl = [NSString stringWithFormat:@"%@%@?token=%@&device=%@&deviceId=%@&account=%@&userId=%@&isUser=%@", kBaseURL, keyUrl, token, device, deviceId, account, userId, isUser];

    [[QYXNetTool shareManager] postNetWithUrl:uploadUrl urlBody:nil bodyStyle:QYXBodyString header:nil response:QYXJSON success:^(id result) {
        ZTLog(@"HOMEVC--SUCCESS--%@", result);
        if ([result[@"msgType"] integerValue] == 0) {

        } else {

        }
    } failure:^(NSError *error) {
        ZTLog(@"HOMEVC--ERROR--%@", error.userInfo);

    }];

}
- (void)registerXgPushAccount{

    NSString *account = [NSString stringWithFormat:@"m%@", UserId];
    [XGPush setAccount:account successCallback:^{

        ZTLog(@"HOMEVC---SUCCESS--%@", account);

    } errorCallback:^{
        ZTLog(@"HOMEVC---ERROR--%@", account);
    }];

}
//监听 登录权限 状态
- (void)initWithTabBarController:(NSNotification *)notification{

    model = _BaseModel;
    NSArray *allLimitStatus = @[model.isOrderManage, model.isServiceManage, model.isKitchenManage];
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    NSArray *locationLimitChangeArr = [userDefault objectForKey:LocationLimitsChangeKey];
    if (notification != nil) {
        ZTLog(@"权限被修改了");
        allLimitStatus = notification.userInfo[@"powerArr"];
        [userDefault setObject:allLimitStatus forKey:LocationLimitsChangeKey];
        [userDefault synchronize];
        [SVProgressHUD showSuccessWithStatus:@"权限已修改"];
    } else if (locationLimitChangeArr.count != 0 && [model.isChecked isEqualToString:@"3"]) {
        allLimitStatus = locationLimitChangeArr;
    }
    //初始化tablebar个数
    NSMutableArray *arrTitle = [NSMutableArray arrayWithArray:@[@"订单", @"现场", @"排队"]];
    //vc个数
    NSMutableArray *arrClass = [NSMutableArray arrayWithArray:@[@"MyorderViewController", @"SceneViewController",@"QueueVC0703"]];

    //初始化tablebar图标
    NSMutableArray *arrBarIcon = [NSMutableArray arrayWithArray:@[@"订单", @"现场", @"queue_tabbar_icon"]];
    for (NSInteger i = allLimitStatus.count - 1; i > 0; i--) {
        if ([allLimitStatus[i] integerValue] == 0 && i != 0) {
            [arrTitle removeObjectAtIndex:i];
            [arrClass removeObjectAtIndex:i];
            [arrBarIcon removeObjectAtIndex:i];
        }
    }
    [[[UIApplication sharedApplication] keyWindow] resignKeyWindow];

    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyWindow];
    [self.window makeKeyAndVisible];


    //创建tabbar数组
    NSMutableArray *arrNC = [NSMutableArray array];

    for (NSString *classStr in arrClass) {

        Class className = NSClassFromString(classStr);

        if (className) {

            static NSInteger i = 0;

            UIViewController *viewController = [[[className class] alloc]init];
            UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:viewController];

            navigationController.title = [arrTitle objectAtIndex:i];

            [arrNC addObject:navigationController];

            [navigationController.tabBarItem setImage:[UIImage imageNamed:[arrBarIcon objectAtIndex:i]]];

            i++;
            i = i == arrClass.count ? 0 : i;
        }
    }
    LeftViewController *leftVC = [[LeftViewController alloc] init];
    self.tabController = [[UITabBarController alloc] init];

    //    [self.tabController setValue:[[MyTableBar alloc] init] forKey:@"tabBar"];
    self.tabController.tabBar.barTintColor = [UIColor lightTextColor];

    [self.tabController.tabBar setTintColor:RGB(253, 117, 119)];

    self.tabController.viewControllers = [arrNC copy];

    self.tabController.delegate = self;

    //覆盖中间tabbar
    self.window.rootViewController = [[RootViewController alloc] initWithCenterVC:_tabController leftVC:leftVC];


}
-(void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController{

}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation

 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
