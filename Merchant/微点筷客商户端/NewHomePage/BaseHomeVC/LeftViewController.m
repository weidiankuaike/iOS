//
//  LeftViewController.m
//  微点筷客商户端
//
//  Created by Skyer God on 16/10/13.
//  Copyright © 2016年 zt. All rights reserved.
//
#define start_x autoScaleW(23)
#import "LeftViewController.h"
#import <UIImageView+WebCache.h>

#import "FinancialViewController.h"

#import "DishesChangeVC.h"
#import "RestaurantActivityVC.h"
#import "ServiceCategoryVC.h"

#import "JudgeViewController.h"
//#import "VagetableViewController.h"
#import "DishesAnalyzeVC.h"
#import "MoreErectViewController.h"
#import "NewsViewController.h"
#import "ServiceCategoryVC.h"
#import "BaseButton.h"
#import "NewSeatSetVC.h"
#import "ZTAddOrSubAlertView.h"
#import "SystemViewController.h"
#import "LoginInfoModel.h"
#import "StuffInfoCenterVC.h"
#import "ZTAddOrSubAlertView.h"
#import <AVFoundation/AVFoundation.h>
#import "FlowCountViewController.h"
@interface LeftViewController ()<UIScrollViewDelegate>
@property (nonatomic, strong) UIScrollView *scroollView;
@property (nonatomic, strong) UIView *wrapperView;
@property (nonatomic, strong) UIView *lastBottomLine;
@property (nonatomic, strong) UIView *firstBottomLine;
@property (nonatomic, strong) NSMutableArray * xxary;
//营业状态选择
@property (nonatomic,strong) UIView * sheZhiView;
@property (nonatomic,strong) ButtonStyle * daitibtn;
@property (nonatomic,strong) UILabel * tishilabel;
@property (nonatomic,assign) NSInteger chooseinteger;

@property (nonatomic,strong) NSArray * array;
@property (nonatomic,strong) UIView * bigView;
@property (nonatomic,strong) BaseButton *workingBT;
@end

@implementation LeftViewController{
    NSInteger storeStatus ;
}
- (UIScrollView *)scroollView
{
    if (!_scroollView) {
        _scroollView = [UIScrollView new];
        _scroollView.delegate = self;
        [self.view addSubview:_scroollView];

        _scroollView.sd_layout.spaceToSuperView(UIEdgeInsetsZero);

        UILabel *topSeparator = [[UILabel alloc] init];
        topSeparator.backgroundColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.6];;
        [self.view addSubview:topSeparator];

        topSeparator.sd_layout
        .leftEqualToView(self.view)
        .topSpaceToView(self.view, 0)
        .rightEqualToView(self.view)
        .heightIs(autoScaleH(1));
    }
    return _scroollView;
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:NO];
    self.navigationController.navigationBar.hidden = YES;
    self.tabBarController.tabBar.hidden = NO;
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:NO];

    [[NSNotificationCenter defaultCenter] postNotificationName:LEFT_VC_CANCEL_FLAG object:nil];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self uploadWorkStatus:@"不用穿" operType:@"0"];//查询营业状态
    self.view.backgroundColor = RGB(238, 238, 238);
    [self initwithScrollView];
    [self initwithCustormView];
    //订单取消会触发此通知回调
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(storeStatusChanged:) name:@"StoreStatusChanged" object:nil];

}
//订单取消会触发此通知回调，如果选择真取消，则走此方法，伪取消，则不走
-(void)storeStatusChanged:(NSNotification *)notification{

    NSArray *titleArr = @[@"休业",@"营业",@"繁忙"];
    NSArray *imagesArr = @[@"休业-1",@"营业",@"忙碌"];
    if (notification.userInfo) {
        NSInteger status = [notification.userInfo[@"isBusy"] integerValue];//1繁忙状态， 0休业状态
        if (status == 0) {
            //休业

            [_workingBT setTitle:titleArr[0] forState:UIControlStateNormal];
            [_workingBT setImage:[UIImage imageNamed:imagesArr[0]] forState:UIControlStateNormal];
            [self orderVoicePlay:@"休业"];
        } else if (status == 1) {
            //繁忙
            [_workingBT setTitle:titleArr[2] forState:UIControlStateNormal];
            [_workingBT setImage:[UIImage imageNamed:imagesArr[2]] forState:UIControlStateNormal];
            [self orderVoicePlay:@"繁忙"];
        } else;

    }
    
}
- (void)orderVoicePlay:(NSString *)type{

    dispatch_async(dispatch_get_main_queue(), ^{
        NSError *error = NULL;
        AVAudioSession *session = [AVAudioSession sharedInstance];
        [session setCategory:AVAudioSessionCategoryPlayback error:&error];
        if(error) {

        }
        [session setActive:YES error:&error];
        if (error) {

        }
        AVSpeechSynthesizer *speechSyn = [[AVSpeechSynthesizer alloc] init];
        AVSpeechUtterance *utterance = [AVSpeechUtterance speechUtteranceWithString:[NSString stringWithFormat:@"您的店铺状态已经更改为:%@状态", type]];
        AVSpeechSynthesisVoice *voice = [AVSpeechSynthesisVoice voiceWithLanguage:@"zh-CN"];
        [utterance setVoice:voice];
        utterance.rate = 0.52;
        [speechSyn speakUtterance:utterance];
    });
    
}
- (void)initwithScrollView{

    _scroollView.backgroundColor = RGB(238, 238, 238);


    self.wrapperView = [UIView new];
    self.wrapperView.backgroundColor = RGB(238, 238, 238);
    [self.scroollView addSubview:self.wrapperView];
    //    [self.scroollView setupAutoContentSizeWithBottomView:self.wrapperView bottomMargin:0];


    //    self.wrapperView.sd_layout.
    //    leftEqualToView(self.scroollView)
    //    .rightEqualToView(self.scroollView)
    //    .topEqualToView(self.scroollView);
    //    [self.wrapperView setupAutoHeightWithBottomView:self.lastBottomLine bottomMargin:10];

    self.wrapperView.sd_layout.spaceToSuperView(UIEdgeInsetsZero);

}
- (void)initwithCustormView{

#pragma mark =-------------------------- 餐厅权限处理  －－－－－－－－－－－－－－－－－－－－
    LoginInfoModel *model = _BaseModel;

#pragma mark =-------------------------- 餐厅无权限处理  －－－－－－－－－－－－－－－－－－－－

    UIView *backView = [[UIView alloc] init];
    backView.backgroundColor = UIColorFromRGB(0xfd7577);
    [_wrapperView addSubview:backView];

    backView.sd_layout
    .leftEqualToView(_wrapperView)
    .topSpaceToView(_wrapperView, -20)
    .rightEqualToView(_wrapperView)
    .heightIs(autoScaleH(170));

    //营业
    _workingBT = [BaseButton buttonWithType:UIButtonTypeCustom];
    [_workingBT setTitle:@"营业" forState:UIControlStateNormal];
    [_workingBT setImage:[UIImage imageNamed:@"营业"] forState:UIControlStateNormal];
    [_workingBT.titleLabel setFont:[UIFont systemFontOfSize:13]];
    [_workingBT addTarget:self action:@selector(Business) forControlEvents:UIControlEventTouchUpInside];
    [backView addSubview:_workingBT];

    //是否老板，是点击，否者否
    _workingBT.userInteractionEnabled = ![_BaseModel.isBoss boolValue];
    //登录的时候判断营业状态设置
    NSArray *titleArr = @[@"休业",@"营业",@"繁忙"];
    NSArray *imagesArr = @[@"休业-1",@"营业",@"忙碌"];
    [_workingBT setTitle:titleArr[[model.storeBase.status integerValue]] forState:UIControlStateNormal];
    [_workingBT setImage:[UIImage imageNamed:imagesArr[[model.storeBase.status integerValue]]] forState:UIControlStateNormal];


    /** 用户图像 **/
    BaseButton *userImageBT = [BaseButton buttonWithType:UIButtonTypeCustom];
    [userImageBT setTitle:@"微点筷客" forState:UIControlStateNormal];
    [userImageBT setImage:[UIImage imageNamed:@"管理员1"] forState:UIControlStateNormal];
    userImageBT.titleLabel.font = [UIFont systemFontOfSize:14];
    [userImageBT setTitleColor:_workingBT.titleLabel.textColor forState:UIControlStateNormal];
    [userImageBT addTarget:self action:@selector(userImageClick:) forControlEvents:UIControlEventTouchUpInside];
    [backView addSubview:userImageBT];



    _xxary = [NSMutableArray arrayWithObjects:@"2",@"3",@"4",@"5",@"6",@"7", nil];

    BaseButton *messageBT = [BaseButton buttonWithType:UIButtonTypeCustom];
    [messageBT setTitle:@"消息" forState:UIControlStateNormal];
    [messageBT setTitleColor:_workingBT.titleLabel.textColor forState:UIControlStateNormal];
    messageBT.titleLabel.font = _workingBT.titleLabel.font;
    [messageBT setImage:[UIImage imageNamed:@"铃"] forState:UIControlStateNormal];
    [backView addSubview:messageBT];
    [messageBT addTarget:self action:@selector(getMessageAction:) forControlEvents:UIControlEventTouchUpInside];
    UILabel *redPointLabel = [[UILabel alloc] init];
//    redPointLabel.text = [NSString stringWithFormat:@"%ld", _xxary.count];
    redPointLabel.text = @"无";
    redPointLabel.hidden = YES;
    redPointLabel.textColor = [UIColor whiteColor];
    redPointLabel.backgroundColor = [UIColor redColor];
    redPointLabel.textAlignment = NSTextAlignmentCenter;
    redPointLabel.font = [UIFont systemFontOfSize:9];
    [messageBT addSubview:redPointLabel];





    CGFloat start_y = autoScaleH(90);

    _workingBT.sd_layout
    .centerXIs(autoScaleW(150 + 15))
    .topSpaceToView(backView, start_y)
    .widthIs(autoScaleW(50))
    .heightEqualToWidth(0);
    _workingBT.Image_Y = 3;
    _workingBT.Image_X = 9.5;
    _workingBT.Title_Space = 10;



    userImageBT.sd_layout
    .centerYEqualToView(_workingBT)
    .leftSpaceToView(backView, start_x - 5)
    .widthRatioToView(_workingBT, 1.4)
    .heightRatioToView(_workingBT, 1.4);
    userImageBT.Image_Y = _workingBT.Image_Y;
    userImageBT.Image_X = _workingBT.Image_X;
    userImageBT.Title_Space = _workingBT.Title_Space;

    messageBT.sd_layout
    .rightSpaceToView(backView, start_x)
    .topEqualToView(_workingBT)
    .widthRatioToView(_workingBT, 1)
    .heightRatioToView(_workingBT, 1);
    messageBT.Image_Y = _workingBT.Image_Y;
    messageBT.Image_X = _workingBT.Image_X;
    messageBT.Title_Space = _workingBT.Title_Space;


    redPointLabel.sd_layout
    .topSpaceToView(messageBT, _workingBT.Image_Y)
    .rightSpaceToView(messageBT, _workingBT.Image_X)
    .widthIs(12)
    .heightEqualToWidth(0);

    [redPointLabel setSd_cornerRadiusFromHeightRatio:@(0.5)];

    redPointLabel.layer.borderColor = [UIColor whiteColor].CGColor;
    redPointLabel.layer.borderWidth = 0.8;


    //    self.lastBottomLine = [self addSeparatorLineBellowView:backView margin:start_x];



    //    UIView *blackView = [[UIView alloc] init];
    //    blackView.backgroundColor = [UIColor lightGrayColor];
    //    [_wrapperView insertSubview:blackView aboveSubview:_wrapperView];
    //
    //    blackView.sd_layout
    //    .topEqualToView(_wrapperView)
    //    .leftEqualToView(_wrapperView)
    //    .rightEqualToView(_wrapperView)
    //    .bottomEqualToView(_lastBottomLine);

    /** 统计信息 **/

    if ([model.isBoss integerValue] == 1) {
        //关闭权限，不受影响
        /** 餐厅管理 **/
        UIImageView *restaurantManagerImageV = [[UIImageView alloc] init];
        restaurantManagerImageV.image = [UIImage imageNamed:@"管理"];
        [self.wrapperView addSubview:restaurantManagerImageV];

        UILabel *restaurantLabel = [[UILabel alloc] init];
        restaurantLabel.text =  @"餐厅管理";
        restaurantLabel.textColor = RGB(0, 0, 0);
        restaurantLabel.font = [UIFont systemFontOfSize:18];
        [self.wrapperView addSubview:restaurantLabel];

        restaurantManagerImageV.sd_layout
        .leftEqualToView(userImageBT)
        .topSpaceToView(backView, autoScaleH(18 + 8))
        .widthIs(autoScaleW(30 - 8 * 2))
        .heightEqualToWidth(0);

        restaurantLabel.sd_layout
        .leftSpaceToView(restaurantManagerImageV, autoScaleW(6))
        .topSpaceToView(backView, autoScaleH(18))
        .heightIs(autoScaleH(30));
        [restaurantLabel setSingleLineAutoResizeWithMaxWidth:100];


        NSArray *rastaurantDataArr = @[@"菜品管理",@"餐桌设置",@"餐厅活动",@"服务管理"];
        for (NSInteger i = 0; i < rastaurantDataArr.count; i++) {

            ButtonStyle *button = [ButtonStyle buttonWithType:UIButtonTypeCustom];
            [button setTitle:rastaurantDataArr[i] forState:UIControlStateNormal];
            [button setTitleColor:RGB(0, 0, 8) forState:UIControlStateNormal];
            [button.titleLabel setFont:[UIFont systemFontOfSize:17]];
            [self.wrapperView addSubview:button];
            button.tag = 2000 + i;
            [button addTarget:self action:@selector(restaurantClick:) forControlEvents:UIControlEventTouchUpInside];

            CGFloat button_y = autoScaleH(12);
            CGFloat button_height = autoScaleH(20);
            button.sd_layout
            .leftSpaceToView(_wrapperView, start_x * 3)
            .topSpaceToView(restaurantLabel, button_y + (button_height + button_y) * i);
            [button setupAutoSizeWithHorizontalPadding:0 buttonHeight:button_height];
            if (i == rastaurantDataArr.count - 1) {
                self.lastBottomLine = [self addSeparatorLineBellowView:button margin:25];
            }
        }

    } else {
#pragma mark =-------------------------- 餐厅有权限处理  －－－－－－－－－－－－－－－－－－－－
        UIImageView *analyzeInfoImageV = [[UIImageView alloc] init];
        analyzeInfoImageV.image = [UIImage imageNamed:@"统计-(2)"];
        [self.wrapperView addSubview:analyzeInfoImageV];

        UILabel *analyzeInfoLabel = [[UILabel alloc] init];
        analyzeInfoLabel.text =  @"统计信息";
        analyzeInfoLabel.textColor = RGB(0, 0, 0);
        analyzeInfoLabel.font = [UIFont systemFontOfSize:18];
        [self.wrapperView addSubview:analyzeInfoLabel];

        analyzeInfoImageV.sd_layout
        .leftEqualToView(userImageBT)
        .topSpaceToView(backView, autoScaleH(18 + 8))
        .widthIs(autoScaleW(30 - 8 * 2))
        .heightEqualToWidth(0);

        analyzeInfoLabel.sd_layout
        .leftSpaceToView(analyzeInfoImageV, autoScaleW(6))
        .topSpaceToView(backView, autoScaleH(18))
        .heightIs(autoScaleH(30));
        [analyzeInfoLabel setSingleLineAutoResizeWithMaxWidth:100];


        NSArray *analyzeDataArr = @[@"财务管理",@"流量统计",@"菜品分析",@"评价反馈"];
        for (NSInteger i = 0; i < analyzeDataArr.count; i++) {

            ButtonStyle *button = [ButtonStyle buttonWithType:UIButtonTypeCustom];
            [button setTitle:analyzeDataArr[i] forState:UIControlStateNormal];
            [button setTitleColor:RGB(0, 0, 8) forState:UIControlStateNormal];
            [button.titleLabel setFont:[UIFont systemFontOfSize:17]];
            [self.wrapperView addSubview:button];
            button.tag = 1000 + i;
            [button addTarget:self action:@selector(analyzeClick:) forControlEvents:UIControlEventTouchUpInside];

            CGFloat button_y = autoScaleH(12);
            CGFloat button_height = autoScaleH(20);
            button.sd_layout
            .leftSpaceToView(_wrapperView, start_x * 3)
            .topSpaceToView(analyzeInfoLabel, button_y + (button_height + button_y) * i);
            [button setupAutoSizeWithHorizontalPadding:0 buttonHeight:button_height];

            if (i == analyzeDataArr.count - 1) {
                self.lastBottomLine = [self addSeparatorLineBellowView:button margin:25];
            }
        }
        /** 餐厅管理 **/
        UIImageView *restaurantManagerImageV = [[UIImageView alloc] init];
        restaurantManagerImageV.image = [UIImage imageNamed:@"管理"];
        [self.wrapperView addSubview:restaurantManagerImageV];

        UILabel *restaurantLabel = [[UILabel alloc] init];
        restaurantLabel.text =  @"餐厅管理";
        restaurantLabel.textColor = RGB(0, 0, 0);
        restaurantLabel.font = [UIFont systemFontOfSize:18];
        [self.wrapperView addSubview:restaurantLabel];

        restaurantManagerImageV.sd_layout
        .leftEqualToView(userImageBT)
        .topSpaceToView(_lastBottomLine, 18 + 8)
        .widthIs(autoScaleW(30 - 8 * 2))
        .heightEqualToWidth(0);

        restaurantLabel.sd_layout
        .leftSpaceToView(restaurantManagerImageV, autoScaleW(8))
        .topSpaceToView(_lastBottomLine, autoScaleH(18))
        .heightIs(autoScaleH(30));
        [restaurantLabel setSingleLineAutoResizeWithMaxWidth:100];


        NSArray *rastaurantDataArr = @[@"菜品管理",@"餐桌设置",@"餐厅活动",@"服务管理"];
        for (NSInteger i = 0; i < rastaurantDataArr.count; i++) {

            ButtonStyle *button = [ButtonStyle buttonWithType:UIButtonTypeCustom];
            [button setTitle:rastaurantDataArr[i] forState:UIControlStateNormal];
            [button setTitleColor:RGB(0, 0, 8) forState:UIControlStateNormal];
            [button.titleLabel setFont:[UIFont systemFontOfSize:17]];
            [self.wrapperView addSubview:button];
            button.tag = 2000 + i;
            [button addTarget:self action:@selector(restaurantClick:) forControlEvents:UIControlEventTouchUpInside];

            CGFloat button_y = autoScaleH(12);
            CGFloat button_height = autoScaleH(20);
            button.sd_layout
            .leftSpaceToView(_wrapperView, start_x * 3)
            .topSpaceToView(restaurantLabel, button_y + (button_height + button_y) * i);
            [button setupAutoSizeWithHorizontalPadding:0 buttonHeight:button_height];

            //        if (i == rastaurantDataArr.count - 1) {
            //            self.lastBottomLine = [self addSeparatorLineBellowView:button margin:185];
            //        }

        }

        ButtonStyle *setButton = [ButtonStyle buttonWithType:UIButtonTypeCustom];
        [setButton setImage:[UIImage imageNamed:@"设置-(1)"] forState:UIControlStateNormal];
        [setButton setTitle:@"   设置" forState:UIControlStateNormal];
        [setButton setTitleColor:RGB(0, 0, 8) forState:UIControlStateNormal];
        [setButton.titleLabel setFont:[UIFont systemFontOfSize:15]];
        [self.wrapperView addSubview:setButton];
        setButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft ;
        [setButton addTarget:self action:@selector(setButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        setButton.sd_layout
        .leftEqualToView(userImageBT)
        .bottomSpaceToView(_wrapperView, autoScaleH(20));
        [setButton setupAutoSizeWithHorizontalPadding:5 buttonHeight:49];
    }

    ButtonStyle *cancelButton = [ButtonStyle buttonWithType:UIButtonTypeCustom];
    [cancelButton setImage:[UIImage imageNamed:@"收起-(1)"] forState:UIControlStateNormal];
    [cancelButton setTitle:@"   收起" forState:UIControlStateNormal];
    [cancelButton setTitleColor:RGB(0, 0, 8) forState:UIControlStateNormal];
    [cancelButton.titleLabel setFont:[UIFont systemFontOfSize:15]];
    [self.wrapperView addSubview:cancelButton];
    [cancelButton addTarget:self action:@selector(cancelButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    cancelButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;

    cancelButton.sd_layout
    .bottomSpaceToView(_wrapperView, autoScaleH(20))
    .rightSpaceToView(self.wrapperView, start_x);
    [cancelButton setupAutoSizeWithHorizontalPadding:5 buttonHeight:(49)];

    self.lastBottomLine = [self addSeparatorLineBeforeView:cancelButton margin:autoScaleH(0)];
}
//点击员工头像 响应
- (void)userImageClick:(BaseButton *)sender{
    if ([_BaseModel.isBoss boolValue]) {
        //员工
        StuffInfoCenterVC *systemVC = [[StuffInfoCenterVC alloc] init];
        [self translationPresentViewController:systemVC];
    } else {
        //老板
    }
}
- (void)cancelButtonClick:(ButtonStyle *)sender{
//    NSLog(@"%@", sender.titleLabel.text);

    [[NSNotificationCenter defaultCenter] postNotificationName:LEFT_VC_CANCEL_FLAG object:nil];


}
- (void)setButtonClick:(ButtonStyle *)sender{
//    NSLog(@"%@", sender.titleLabel.text);
    MoreErectViewController * moreview = [[MoreErectViewController alloc]init];
    [self translationPresentViewController:moreview];
}
- (void)translationPresentViewController:(UIViewController *)viewController{
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:viewController];
    viewController.view.backgroundColor = [UIColor whiteColor];
    nav.modalPresentationStyle = UIModalPresentationCustom;
    nav.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [self showDetailViewController:nav sender:self];
}
- (void)analyzeClick:(ButtonStyle *)sender{
//    NSLog(@"%@, %ld", sender.titleLabel.text, sender.tag);
    if (sender.tag==1000)
    {
        FinancialViewController * finaView = [[FinancialViewController alloc]init];
        [self translationPresentViewController:finaView];
    }
    if (sender.tag==1001) {

        FlowCountViewController *flowview = [[FlowCountViewController alloc]init];
        [self translationPresentViewController:flowview];
    }
    if (sender.tag==1002) {

        DishesAnalyzeVC * vagetableView = [[DishesAnalyzeVC alloc]init];
        [self translationPresentViewController:vagetableView];

    }
    if (sender.tag==1003) {

        JudgeViewController * judeview =[[JudgeViewController alloc]init];
        [self translationPresentViewController:judeview];

    }

    self.tabBarController.tabBar.hidden = YES;
}
- (void)restaurantClick:(ButtonStyle *)sender{
//    NSLog(@"%@, %ld", sender.titleLabel.text, sender.tag);

    if (sender.tag == 2000) {
        DishesChangeVC *dishesVC = [[DishesChangeVC alloc] init];
        [self translationPresentViewController:dishesVC];
    } else if (sender.tag == 2001) {
        NewSeatSetVC *dishesVC = [[NewSeatSetVC alloc] init];
        [self translationPresentViewController:dishesVC];
    } else if (sender.tag == 2002) {
        RestaurantActivityVC *dishesVC = [[RestaurantActivityVC alloc] init];
        [self translationPresentViewController:dishesVC];
    } else {
        ServiceCategoryVC *dishesVC = [[ServiceCategoryVC alloc] init];
        [self translationPresentViewController:dishesVC];
    }

}
- (UIView *)addSeparatorLineBeforeView:(UIView *)view margin:(CGFloat)margin
{
    UIView *line = [UIView new];
    line.backgroundColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.6];
    [self.wrapperView addSubview:line];

    line.sd_layout
    .leftSpaceToView(self.wrapperView, 5)
    .rightSpaceToView(self.wrapperView, 5)
    .heightIs(autoScaleH(1))
    .bottomSpaceToView(view, margin);

    return line;
}

- (UIView *)addSeparatorLineBellowView:(UIView *)view margin:(CGFloat)margin
{
    UIView *line = [UIView new];
    line.backgroundColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.6];
    [self.wrapperView addSubview:line];

    line.sd_layout
    .leftSpaceToView(self.wrapperView, 5)
    .rightSpaceToView(self.wrapperView, 5)
    .heightIs(autoScaleH(1))
    .topSpaceToView(view, margin);

    return line;
}
#pragma mark 消息按钮
-(void)getMessageAction:(BaseButton *)sender
{
    //开启后用一下代码
//    NewsViewController * newsview = [[NewsViewController alloc]init];
//    newsview.newsarray = _xxary;
//    [self translationPresentViewController:newsview];
    //一版 不能开启
    [SVProgressHUD showInfoWithStatus:@"功能尚未开启"];

}
#pragma mark 营业
- (void)dismissBigView:(UITapGestureRecognizer *)tap{
    CGPoint point = [tap locationInView:_bigView];
    if (!CGRectContainsPoint(_sheZhiView.frame, point)) {
        [_bigView removeFromSuperview];
    }
}
-(void)Business
{
    //    [[NSNotificationCenter defaultCenter] postNotificationName:LEFT_VC_CANCEL_FLAG object:nil];

    UIWindow * window = [UIApplication sharedApplication].keyWindow;

    _bigView = [[UIView alloc]init];
    _bigView.backgroundColor = RGBA(0, 0, 0, 0.3);
    _bigView.alpha = 0;
    _bigView.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
    [window addSubview:_bigView];

    UITapGestureRecognizer *tapGR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissBigView:)];
    [_bigView addGestureRecognizer:tapGR];

    _sheZhiView = [[UIView alloc]init];
    //    _sheZhiView.frame = CGRectMake(autoScaleW(45), kScreenHeight/2, kScreenWidth-autoScaleW(90), autoScaleH(105));
    _sheZhiView.backgroundColor = [UIColor whiteColor];
    [_bigView addSubview:_sheZhiView];

    _sheZhiView.sd_layout
    .leftSpaceToView(_bigView,autoScaleW(45))
    .rightSpaceToView(_bigView,autoScaleW(45))
    .centerYEqualToView(self.view)
    .heightIs(autoScaleH(150));
    [_sheZhiView setSd_cornerRadiusFromHeightRatio:@(0.06)];
    _sheZhiView.userInteractionEnabled = YES;

    ButtonStyle * quxiaobtn = [ButtonStyle buttonWithType:UIButtonTypeCustom];
    [quxiaobtn setTitleColor:UIColorFromRGB(0xfd7577) forState:UIControlStateNormal];
    quxiaobtn.titleLabel.font = [UIFont systemFontOfSize:autoScaleW(15)];
    [quxiaobtn setTitle:@"取消" forState:UIControlStateNormal];
    [quxiaobtn addTarget:self action:@selector(Quxiao) forControlEvents:UIControlEventTouchUpInside];
    [_sheZhiView addSubview:quxiaobtn];

    quxiaobtn.sd_layout
    .leftSpaceToView(_sheZhiView,autoScaleW(10))
    .topSpaceToView(_sheZhiView,autoScaleH(10))
    .widthIs(autoScaleW(50))
    .heightIs(autoScaleH(30));

    ButtonStyle * quedingbtn = [ButtonStyle buttonWithType:UIButtonTypeCustom];
    [quedingbtn setTitleColor:UIColorFromRGB(0xfd7577) forState:UIControlStateNormal];
    quedingbtn.titleLabel.font = [UIFont systemFontOfSize:autoScaleW(15)];
    [quedingbtn setTitle:@"确定" forState:UIControlStateNormal];
    [quedingbtn addTarget:self action:@selector(Ture) forControlEvents:UIControlEventTouchUpInside];
    [_sheZhiView addSubview:quedingbtn];

    quedingbtn.sd_layout
    .rightSpaceToView(_sheZhiView,autoScaleW(10))
    .topSpaceToView(_sheZhiView,autoScaleH(10))
    .widthRatioToView(quxiaobtn, 1)
    .heightRatioToView(quxiaobtn, 1);

    UILabel * linelabel = [[UILabel alloc]init];
    linelabel.backgroundColor = RGB(195, 195, 195);
    [_sheZhiView addSubview:linelabel];

    linelabel.sd_layout
    .leftSpaceToView(_sheZhiView,0)
    .rightSpaceToView(_sheZhiView,0)
    .heightIs(autoScaleH(0.5))
    .topSpaceToView(quxiaobtn,autoScaleH(0));

    NSArray * titleary = @[@"营业",@"繁忙",@"休业",];
    for (int i=0; i<3; i++) {

        ButtonStyle * zhuangtasibtn = [ButtonStyle buttonWithType:UIButtonTypeCustom];
        [zhuangtasibtn setTitle:titleary[i] forState:UIControlStateNormal];
        zhuangtasibtn.titleLabel.font = [UIFont systemFontOfSize:autoScaleW(15)];
        [zhuangtasibtn setTitleColor:UIColorFromRGB(0xfd7577) forState:UIControlStateSelected];
        [zhuangtasibtn setTitleColor:RGB(196, 196, 197) forState:UIControlStateNormal];
        zhuangtasibtn.layer.masksToBounds = YES;
        zhuangtasibtn.layer.cornerRadius = autoScaleW(5);
        zhuangtasibtn.layer.borderWidth = 1;
        zhuangtasibtn.layer.borderColor = RGB(196, 196, 197).CGColor;
        zhuangtasibtn.tag = 700 +i;
        if (i==0) {
            zhuangtasibtn.selected = YES;
            [self chooseWorkStatus:zhuangtasibtn];
            zhuangtasibtn.layer.borderColor = UIColorFromRGB(0xfd7577).CGColor;
            _daitibtn = zhuangtasibtn;
        }

        [zhuangtasibtn addTarget:self action:@selector(chooseWorkStatus:) forControlEvents:UIControlEventTouchUpInside];
        [_sheZhiView addSubview:zhuangtasibtn];
        zhuangtasibtn.sd_layout
        .leftSpaceToView( _sheZhiView,autoScaleW(20)+i*autoScaleW(85))
        .centerYEqualToView(_sheZhiView)
        .widthIs(autoScaleW(60))
        .heightIs(autoScaleH(30));
    }

    _tishilabel = [[UILabel alloc]init];
    _tishilabel.text = @"因为您设置了可预订，在营业状态下将正常接收预订";
    _tishilabel.textColor = RGB(201, 201, 201);
    _tishilabel.font = [UIFont systemFontOfSize:autoScaleW(13)];
    [_sheZhiView addSubview:_tishilabel];

    [_tishilabel setNumberOfLines:2];
    _tishilabel.textAlignment = NSTextAlignmentCenter;
    _tishilabel.sd_layout
    .leftSpaceToView(_sheZhiView,autoScaleW(20))
    .rightSpaceToView(_sheZhiView,autoScaleW(20))
    .bottomSpaceToView(_sheZhiView, 5)
    .heightIs(autoScaleH(40));

    [UIView animateWithDuration:0.5 animations:^{

        _bigView.alpha=1;

        _bigView.frame =window.bounds;
    }];

}
#pragma mark 营业状态按钮
-(void)chooseWorkStatus:(ButtonStyle *)btn
{
    _daitibtn.selected= NO;
    _daitibtn.layer.borderColor = RGB(196, 196, 197).CGColor;
    btn.selected=YES;
    btn.layer.borderColor =  UIColorFromRGB(0xfd7577).CGColor;
    _daitibtn = btn;

    if (btn.tag==700) {
        _tishilabel.text = @"因为您设置了可预订，在营业状态下将正常接收预订";
        _chooseinteger = 0;
    }

    if (btn.tag==701) {

        _tishilabel.text = @"所选的时段将不再接受预定";
        _chooseinteger = 1;
    }
    if (btn.tag==702) {
        _chooseinteger = 2;

        _tishilabel.text = @"所选的时段将不再接受用餐";
    }
}
#pragma mark 营业状态取消按钮
-(void)Quxiao
{
    [_bigView removeFromSuperview];

}
#pragma  mark 营业状态确定按钮
- (void)uploadWorkStatus:(NSString *)type operType:(NSString *)operType

{
    //operType 0 查询 1 修改
    //修改营业状态0为暂停营业，1为营业中,2为餐厅繁忙
    NSString *keyUrl = @"api/merchant/modifyStatus";
    NSString *status = type;
    NSString *loadUrl = [NSString stringWithFormat:@"%@%@?token=%@&storeId=%@&status=%@&operType=%@", kBaseURL, keyUrl, TOKEN, storeID, status, operType];
    if ([operType integerValue] == 0) {
        loadUrl = [NSString stringWithFormat:@"%@%@?token=%@&storeId=%@&operType=%@", kBaseURL, keyUrl, TOKEN, storeID, operType];
    }
      
    [[QYXNetTool shareManager] postNetWithUrl:loadUrl urlBody:nil bodyStyle:QYXBodyString header:nil response:QYXJSON success:^(id result) {
        if ([result[@"msgType"] isEqualToString:@"0"]) {
            NSArray *titleArr = @[@"休业",@"营业",@"繁忙"];
            NSArray *imagesArr = @[@"休业-1",@"营业",@"忙碌"];
            if ([operType integerValue] == 0) {//查询
                //
                [_workingBT setTitle:titleArr[[result[@"obj"] integerValue]] forState:UIControlStateNormal];
                [_workingBT setImage:[UIImage imageNamed:imagesArr[[result[@"obj"] integerValue]]] forState:UIControlStateNormal];
            } else {
                //修改
                [_bigView removeFromSuperview];
                [SVProgressHUD showSuccessWithStatus:@"修改成功"];

                dispatch_async(dispatch_get_main_queue(), ^{
                    [_workingBT setTitle:titleArr[[type integerValue]] forState:UIControlStateNormal];
                    [_workingBT setImage:[UIImage imageNamed:imagesArr[[type integerValue]]] forState:UIControlStateNormal];
                });
            }
        } else {
            [SVProgressHUD showErrorWithStatus:@"操作失败"];
        }
    } failure:^(NSError *error) {


    }];
}
-(void)Ture
{
    ButtonStyle * yingyebtn = (ButtonStyle *)[_sheZhiView viewWithTag:700];
    ButtonStyle * fmbtn = (ButtonStyle *)[_sheZhiView viewWithTag:701];
    ButtonStyle * xybtn = (ButtonStyle *)[_sheZhiView viewWithTag:702];
    _sheZhiView.hidden = YES;
    if (yingyebtn.selected ==YES) {
        [self uploadWorkStatus:@"1" operType:@"1"];
    }
    if (fmbtn.selected ==YES) {
        [self Tanchuan];
    }
    if (xybtn.selected ==YES) {
        [self Tanchuan];
    }

}
#pragma mark 营业状态弹窗
-(void)Tanchuan
{
    ZTAddOrSubAlertView * _alertV;
    _alertV=[[ZTAddOrSubAlertView alloc]initWithStyle:ZTalertSheetStyleSubTitle];
    [_alertV showView];
    _alertV.shouldHiddenMaskView = NO;
    if (_chooseinteger==1) {
        _array = @[@"是否设置该时段为繁忙状态",@"客人将无法进行该时段的用餐预定",];
    }
    if (_chooseinteger==2) {

        _array = @[@"是否设置该时段为休业状态",@"该时段餐厅将不显示在用户端首页",];
    }
    _alertV.titleLabel.text = _array[0];
    _alertV.littleLabel.text = _array[1];
    __weak typeof(self) weakSelf = self;
    _alertV.complete = ^(BOOL complete){
        if (complete) {
            if (_chooseinteger==0) {
                [weakSelf uploadWorkStatus:@"1" operType:@"1"];
            }
            if (_chooseinteger==1) {
                [weakSelf uploadWorkStatus:@"2" operType:@"1"];
            }
            if (_chooseinteger==2) {
                [weakSelf uploadWorkStatus:@"0" operType:@"1"];
            }
        } else {
            _bigView.hidden = YES;
        }
    };
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
