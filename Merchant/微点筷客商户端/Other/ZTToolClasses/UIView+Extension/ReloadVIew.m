//
//  ReloadVIew.m
//  微点筷客商户端
//
//  Created by Skyer God on 2017/5/9.
//  Copyright © 2017年 张森森. All rights reserved.
//

#import "ReloadVIew.h"
#import "RootViewController.h"
static const NSMutableArray *arrVC;
@implementation ReloadVIew{
    UIView *maskView;
    UIImageView *imageV;
    UIViewController *oldVC;
    UIViewController *topVC;
    NSString *reloadURL;

}

+(ReloadVIew *)defaultReloadVew{
    static ReloadVIew *reloadView = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        reloadView = [[self alloc] init];
    });
    return reloadView;
}
+(void)registerReloadView:(UIViewController *)viewController{
    if (!arrVC) {
        arrVC = [NSMutableArray array];
    }
    if (![arrVC containsObject:viewController]) {
        [arrVC addObject:viewController];
    }
}
+(void)clearReloadViewSuperClass{
    [arrVC removeAllObjects];
}
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.backgroundColor = UIColorFromRGB(0xf5f5f5);
        [self create];
        oldVC = nil;
    }
    return self;
}
- (void)create{

    maskView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    maskView.backgroundColor = RGBA(0, 0, 0, 0);
    //    [maskView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(maskViewTapClick:)]];
    [[UIApplication sharedApplication].keyWindow addSubview:maskView];
    [maskView addSubview:self];
    self.sd_layout.spaceToSuperView(UIEdgeInsetsMake(0, 0, 0, 0));

    imageV = [[UIImageView alloc] init];
    imageV.backgroundColor = [UIColor lightGrayColor];
    imageV.image = [UIImage imageNamed:@"reload_icon"];
    [self addSubview: imageV];
    imageV.userInteractionEnabled = YES;

    UILabel *_titleLabel = [[UILabel alloc] init];
    _titleLabel.text = @"当前网络状态不好 ~T_T~ 请点击按钮重新加载";
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    _titleLabel.font = [UIFont systemFontOfSize:14];
    [self addSubview:_titleLabel];;

    _titleLabel.sd_layout
    .centerXEqualToView(self)
    .centerYEqualToView(self)
    .heightIs(autoScaleH(45));

    [_titleLabel setSingleLineAutoResizeWithMaxWidth:350];
    CGFloat space = autoScaleH(45);
    imageV.sd_layout
    .bottomSpaceToView(_titleLabel, space)
    .centerXEqualToView(self)
    .heightIs(autoScaleH(imageV.image.size.height))
    .widthIs(autoScaleW(imageV.image.size.width));


    _confirmBT = [ButtonStyle buttonWithType:UIButtonTypeCustom];
    [_confirmBT setTitle:@"重新加载" forState:UIControlStateNormal];
    [_confirmBT setBackgroundColor:[UIColor whiteColor]];
    [_confirmBT setTitleColor:UIColorFromRGB(0x606570) forState:UIControlStateNormal];
    [_confirmBT addTarget:self action:@selector(confirmAction) forControlEvents:UIControlEventTouchUpInside];
    [_confirmBT.titleLabel setFont:[UIFont systemFontOfSize:autoScaleW(20)]];
    [self addSubview:_confirmBT];
    _confirmBT.layer.borderColor = UIColorFromRGB(0xbfbfbf).CGColor;
    _confirmBT.layer.borderWidth = 0.5;
    _confirmBT.sd_cornerRadiusFromHeightRatio = @(0.1);

    _confirmBT.sd_layout
    .centerXEqualToView(_titleLabel)
    .topSpaceToView(_titleLabel, space + 15);
    [_confirmBT setupAutoSizeWithHorizontalPadding:40 buttonHeight:45];

    [_confirmBT updateLayout];
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.colors = @[(__bridge id)UIColorFromRGB(0xf1f1f1).CGColor, (__bridge id)UIColorFromRGB(0xf6f6f6).CGColor, (__bridge id)UIColorFromRGB(0xfbfbfb).CGColor];
    gradientLayer.locations = @[@0.1, @0.4, @1.0];
    gradientLayer.startPoint = CGPointMake(0, 0);
    gradientLayer.endPoint = CGPointMake(0, 1.0);
    gradientLayer.frame = CGRectMake(0, 0, _confirmBT.width_sd, _confirmBT.height_sd);
    [_confirmBT.layer insertSublayer:gradientLayer atIndex:0];
    [_confirmBT setTitleColor:UIColorFromRGB(0x606570) forState:UIControlStateNormal];
    [self updateLayout];

    maskView.hidden = YES;
    self.hidden = maskView.hidden;
}
- (void)captureURL:(NSString *)reloadUrl complete:(ReloadUrlSuccess)complete{
    reloadURL = reloadUrl;
}
//获取当前正在显示的VC
- (void)refreshNowNetRequiringViewController{
    topVC = [self topViewController];
    if ([arrVC containsObject:topVC]) {
        if (oldVC && topVC && ![topVC isKindOfClass:[oldVC class]] && maskView.isHidden == NO) {
            [self dismiss];
        }
        //        [topVC.view addSubview:maskView];
        //        maskView.sd_layout.spaceToSuperView(UIEdgeInsetsMake(topVC.navigationController.navigationBar.isHidden ? 0 : 64, 0, topVC.tabBarController.tabBar.isHidden ? 0 : 49, 0));
        //        [maskView updateLayout];
    }
}
- (void)confirmAction{
    [self dismiss];
    [SVProgressHUD showWithStatus:@"加载中...."];
    dispatch_async(dispatch_get_main_queue(), ^{
        [topVC viewWillAppear:NO];
        [topVC viewDidLoad];
    });
}
- (void)showView{
    [SVProgressHUD dismiss];
    [SVProgressHUD dismiss];
    [MBProgressHUD hideHUDForView:topVC.view animated:YES];
    topVC = [self topViewController];
    if ([arrVC containsObject:topVC]) {
        if (topVC) {
            [topVC.view addSubview:maskView];
            maskView.sd_layout.spaceToSuperView(UIEdgeInsetsMake(topVC.navigationController.navigationBar.isHidden ? 0 : 64, 0, topVC.tabBarController.tabBar.isHidden || topVC.tabBarController.tabBar == nil ? 0 : 49, 0));
            [maskView updateLayout];
            oldVC = topVC;
            //    maskView.alpha = 0;
            //    self.transform = CGAffineTransformMakeScale(1, 1);
            [UIView animateWithDuration:.0 animations:^{
                maskView.alpha = 1;
                maskView.hidden = NO;
                self.hidden = maskView.hidden;
                //        self.transform = CGAffineTransformMakeScale(1, 1);
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [topVC.view bringSubviewToFront:maskView];
                });
            }];
        }
    }

}
- (void)maskViewTapClick:(UITapGestureRecognizer *)tapGR{
    [self dismiss];
}
- (void)dismiss{
    [UIView animateWithDuration:0 animations:^{
        maskView.hidden = YES;
        [maskView sd_clearAutoLayoutSettings];
    }];
    [SVProgressHUD showWithStatus:@"加载中..."];
    [topVC.navigationItem.rightBarButtonItems enumerateObjectsUsingBlock:^(UIBarButtonItem * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        obj.enabled = YES;
    }];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(netTimeoutInterval * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [SVProgressHUD dismiss];
    });
}
- (UIViewController *)topViewController {
    UIViewController *resultVC;
    resultVC = [self _topViewController:[[UIApplication sharedApplication].keyWindow rootViewController]];
    while (resultVC.presentedViewController) {
        resultVC = [self _topViewController:resultVC.presentedViewController];
    }

    if (resultVC.childViewControllers.count > 0 && [resultVC isKindOfClass:[RootViewController class]]) {
        resultVC = [self _topViewController:resultVC.childViewControllers[1]];
    }
    return resultVC;
}

- (UIViewController *)_topViewController:(UIViewController *)vc {
    if ([vc isKindOfClass:[UINavigationController class]]) {
        return [self _topViewController:[(UINavigationController *)vc topViewController]];
    } else if ([vc isKindOfClass:[UITabBarController class]]) {
        return [self _topViewController:[(UITabBarController *)vc selectedViewController]];
    } else {
        return vc;
    }
    return nil;
}
@end
