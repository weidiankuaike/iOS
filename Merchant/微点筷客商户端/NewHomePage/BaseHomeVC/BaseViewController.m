//
//  BaseViewController.m
//  微点筷客商户端
//
//  Created by Skyer God on 16/10/17.
//  Copyright © 2016年 张森森. All rights reserved.
//

#define mainBounds [UIScreen mainScreen].bounds

#import "BaseViewController.h"
#import "LeftViewController.h"


@interface BaseViewController ()


@end

@implementation BaseViewController
{
    UIView *maskView;
    UIView *tabbarMask;
    ButtonStyle *_leftButton;
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self initwithMaskView];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(leftAction) name:LEFT_VC_CANCEL_FLAG object:nil];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
    [self setNeedsStatusBarAppearanceUpdate];
    self.navigationController.navigationBar.barTintColor = UIColorFromRGB(0xfd7577);
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:YES];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:LEFT_VC_CANCEL_FLAG object:nil];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];

    _titleView = [[UILabel alloc]init];
    _titleView.frame = CGRectMake(0, 0, 80, 30);
    _titleView.textAlignment = NSTextAlignmentCenter;
    _titleView.font = [UIFont systemFontOfSize:15];
    _titleView.text = @"";
    _titleView.textColor = [UIColor whiteColor];
    self.navigationItem.titleView = _titleView;
    
    [self initSwipGR];

    _leftButton = [ButtonStyle buttonWithType:UIButtonTypeCustom];
    [_leftButton setTitle:@" 菜单" forState:UIControlStateNormal];
    [_leftButton setImage:[UIImage imageNamed:@"cd"] forState:UIControlStateNormal];
    [_leftButton.titleLabel setFont:[UIFont systemFontOfSize:15]];
    [_leftButton setTitleColor:[UIColor whiteColor] forState: UIControlStateNormal];
    [_leftButton addTarget:self action:@selector(leftAction) forControlEvents:UIControlEventTouchUpInside];
    _leftButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    _leftButton.frame = CGRectMake(0, 7, 110, 30);
    UIBarButtonItem *leftBarItem = [[UIBarButtonItem alloc] initWithCustomView:_leftButton];
    self.navigationItem.leftBarButtonItem = leftBarItem;

}
-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}
-(UIStatusBarAnimation)preferredStatusBarUpdateAnimation{
    return UIStatusBarAnimationSlide;
}

- (void)initSwipGR{
    self.view.backgroundColor = [UIColor whiteColor];

    // 轻扫手势
    UIScreenEdgePanGestureRecognizer *leftswipeGesture = [[UIScreenEdgePanGestureRecognizer alloc] initWithTarget:self action:@selector(leftswipeGestureAction)];

    // 设置清扫手势支持的方向
    leftswipeGesture.edges = UIRectEdgeRight;

    // 添加手势
    [self.view addGestureRecognizer:leftswipeGesture];

    UIScreenEdgePanGestureRecognizer *rightSwipeGesture = [[UIScreenEdgePanGestureRecognizer alloc] initWithTarget:self action:@selector(rightswipeGestureAction)];

    rightSwipeGesture.edges = UIRectEdgeLeft;

    [self.view addGestureRecognizer:rightSwipeGesture];
}

- (void)initwithMaskView{
    maskView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, mainBounds.size.width, mainBounds.size.height)];
    maskView.backgroundColor = RGBA(0, 0, 0, 0.5);

    maskView.hidden = YES;

    UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePanGesture:)];
    [maskView addGestureRecognizer:panGesture];

    UITapGestureRecognizer *tapGR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
    [maskView addGestureRecognizer:tapGR];


    [self.tabBarController.view addSubview:maskView];


}
- (void)tapAction:(UITapGestureRecognizer *)tapGR{

    [UIView animateWithDuration:.35 animations:^{
        self.tabBarController.view.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, mainBounds.size.height);
        [self dismissMaskView];
    }];

}
- (void)leftAction{
    maskView.alpha = 0;
    [UIView animateWithDuration:0.35 animations:^{
        maskView.alpha = 1;
        /*       if ([self respondsToSelector:@selector(setNeedsStatusBarAppearanceUpdate)]) {
         // iOS 7
         [self prefersStatusBarHidden];
         [self performSelector:@selector(setNeedsStatusBarAppearanceUpdate)];
         }
         */
        if ( self.tabBarController.view.center.x != self.view.center.x ) {
//            NSLog(@"root收起");
            [self judgeBaseViewControllerStatus:NO];
            self.tabBarController.view.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, mainBounds.size.height);
            [self dismissMaskView];
            return;
        } else {

            [self judgeBaseViewControllerStatus:YES];
            self.tabBarController.view.frame = CGRectMake(LeftWidth, 0, [UIScreen mainScreen].bounds.size.width, mainBounds.size.height);
            [self showMaskView];
//            NSLog(@"root摊开");
        }
    }];

}
- (void)judgeBaseViewControllerStatus:(BOOL)isOut{
    _isOut = isOut;
}
- (void)showMaskView{

    maskView.hidden = NO;
    tabbarMask.hidden = NO;
}
- (void)dismissMaskView{
    [self judgeBaseViewControllerStatus:NO];
    maskView.hidden = YES;
    maskView.alpha = 1;
    maskView.frame = CGRectMake(0, 0, mainBounds.size.width, mainBounds.size.height);
    

}
- (void)handlePanGesture:(UIPanGestureRecognizer *)panGesture{
    CGPoint point = [panGesture translationInView:panGesture.view];
    self.tabBarController.view.frame = CGRectMake(self.tabBarController.view.frame.origin.x + point.x, 0, [UIScreen mainScreen].bounds.size.width, mainBounds.size.height);
    [panGesture setTranslation:CGPointZero inView:panGesture.view];
    CGPoint centerOrigin = self.tabBarController.view.frame.origin;
//    ZTLog(@"%@", NSStringFromCGPoint(centerOrigin));
    if (centerOrigin.x > LeftWidth) {

        self.tabBarController.view.frame = CGRectMake(LeftWidth, 0, [UIScreen mainScreen].bounds.size.width, mainBounds.size.height);
    } else if (centerOrigin.x <= 0) {
        self.tabBarController.view.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, mainBounds.size.height);
    } else;
    maskView.alpha = centerOrigin.x /( mainBounds.size.width / 1.6);
    tabbarMask.alpha = maskView.alpha;

    if (panGesture.state == UIGestureRecognizerStateEnded || panGesture.state == UIGestureRecognizerStateCancelled) {
        if (centerOrigin.x > mainBounds.size.width / 2) {

            self.tabBarController.view.frame = CGRectMake(LeftWidth, 0, [UIScreen mainScreen].bounds.size.width, mainBounds.size.height);
        } else {

            self.tabBarController.view.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, mainBounds.size.height);
            [self dismissMaskView];
        }
    }
}


/**
 *  左轻扫
 */
- (void)leftswipeGestureAction{


    [UIView animateWithDuration:0.35 animations:^{

        
        if ( self.tabBarController.view.center.x != mainBounds.size.width / 2.0 ) {

//            ZTLog(@"base 左轻扫 收起");

            self.tabBarController.view.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, mainBounds.size.height);
            [self dismissMaskView];
        }else {
            //什么都不做
        }
    }];
}
/**
 *  右轻扫
 */
- (void)rightswipeGestureAction{

    [UIView animateWithDuration:0.35 animations:^{

        if ( self.tabBarController.view.center.x != self.view.center.x ) {
            //什么都不做

        }else{

            self.tabBarController.view.frame = CGRectMake(LeftWidth, 0, [UIScreen mainScreen].bounds.size.width, mainBounds.size.height);
            [self showMaskView];
//            ZTLog(@"base  右轻扫  弹开");
        }
    }];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
