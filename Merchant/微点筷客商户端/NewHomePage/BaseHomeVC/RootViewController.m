//
//  RootViewController.m
//  微点筷客商户端
//
//  Created by Skyer God on 16/10/13.
//  Copyright © 2016年 ZT. All rights reserved.
//
#define mainBounds [UIScreen mainScreen].bounds
#import "RootViewController.h"
#import "LeftViewController.h"


@interface RootViewController ()
{
    BOOL _isChange;
    BOOL _isH;
}
@property (nonatomic, strong) UIImageView *backimage;

@property (nonatomic, strong) UIView *playView;

@property (nonatomic, retain) UITabBarController *tabController;
@property (nonatomic, strong) UIWindow *window;
@end

@implementation RootViewController
{
    UIView *maskView;
    UIView *tabbarMask;
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];

}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:YES];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
/**
 *  重写init方法
 */
- (id)initWithCenterVC:(UITabBarController *)centerVC leftVC:(LeftViewController *)leftVC {

    if (self = [super init]) {
        self.view.backgroundColor = [UIColor whiteColor];
        UINavigationController *leftNavi = [[UINavigationController alloc] initWithRootViewController:leftVC];
        [self addChildViewController:leftNavi];

//        UINavigationController *centerNC = [[UINavigationController alloc] initWithRootViewController:centerVC];
        [self addChildViewController:centerVC];


        leftNavi.view.frame = CGRectMake(0, 0, LeftWidth, [UIScreen mainScreen].bounds.size.height);

        centerVC.view.frame = [UIScreen mainScreen].bounds;


//        [self.view addSubview:self.backimage];
        [self.view addSubview:leftNavi.view];
        [self.view addSubview:centerVC.view];
    }

    return self;

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
