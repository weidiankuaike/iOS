//
//  BaseNaviSetVC.m
//  微点筷客商户端
//
//  Created by Skyer God on 16/10/21.
//  Copyright © 2016年 张森森. All rights reserved.
//

#import "BaseNaviSetVC.h"
#import "DeviceSet.h"
@interface BaseNaviSetVC ()<UIPopoverPresentationControllerDelegate>

@end

@implementation BaseNaviSetVC
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
    [self setNeedsStatusBarAppearanceUpdate];
    self.navigationController.navigationBar.barTintColor = UIColorFromRGB(0xfd7577);
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setNavigationView];
}

-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleDefault;
}
-(UIStatusBarAnimation)preferredStatusBarUpdateAnimation{
    return UIStatusBarAnimationFade;
}
/** 设置导航啦 **/
- (void)setNavigationView{

    _titleView = [[UILabel alloc]init];
    _titleView.frame = CGRectMake(0, 0, 80, 30);
    _titleView.textAlignment = NSTextAlignmentCenter;
    _titleView.font = [UIFont systemFontOfSize:17];
    _titleView.text = @"";
    _titleView.textColor = [UIColor whiteColor];
    _titleView.adjustsFontSizeToFitWidth = YES;
    self.navigationItem.titleView = _titleView;

    self.navigationController.navigationBar.hidden = NO;
    self.tabBarController.tabBar.hidden = YES;
    _leftBarItem = [UIButton buttonWithType:UIButtonTypeCustom];
    [_leftBarItem setImage:[UIImage imageNamed:@"left-1"] forState:UIControlStateNormal];
    _leftBarItem.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [_leftBarItem addTarget:self action:@selector(leftBarButtonItemAction) forControlEvents:UIControlEventTouchUpInside];
    _leftBarItem.frame = CGRectMake(0, 7, 30, 30);

    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:_leftBarItem];

    _rightBarItem = [UIButton buttonWithType:UIButtonTypeCustom];
    [_rightBarItem setImage:[UIImage imageNamed:@"排序"] forState:UIControlStateNormal];
    _rightBarItem.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [_rightBarItem addTarget:self action:@selector(rightBarButtonItemAction:) forControlEvents:UIControlEventTouchUpInside];
    _rightBarItem.hidden = YES;
    _rightBarItem.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    _rightBarItem.frame = CGRectMake(0, 7, 110, 30);

    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:_rightBarItem];

}
- (void)leftBarButtonItemAction{
    


        [self.navigationController popToRootViewControllerAnimated:YES];



}
- (void)rightBarButtonItemAction:(UIButton *)sender{

}
//-    adaptivePresentationStyleForPresentationControlle
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//-(UIModalPresentationStyle)adaptivePresentationStyleForPresentationController:(UIPresentationController *)controller traitCollection:(UITraitCollection *)traitCollection{
//    return UIModalPresentationNone;
//}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
