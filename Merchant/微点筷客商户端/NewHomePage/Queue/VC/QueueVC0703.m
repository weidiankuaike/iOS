//
//  QueueVC0703.m
//  微点筷客商户端
//
//  Created by Skyer God on 2017/7/3.
//  Copyright © 2017年 张甜. All rights reserved.
//

#import "QueueVC0703.h"
#import <YYKit.h>
#import "QueueNumberCell.h"
#import "QueueAddNumView.h"
#import "QueueStatusSetVC.h"
#import "QueueCurrentOrHistoryVC.h"
#import "ZTPageViewController.h"
@interface QueueVC0703 ()<UITableViewDelegate, UITableViewDataSource>
/** <#行注释#>   (strong) **/
@property (nonatomic, strong) UITableView *tableV;
/** 添加现场排队按钮   (strong) **/
@property (nonatomic, strong) QueueAddNumView *addAlertView;
/** vc   (strong) **/
@property (nonatomic, strong) NSMutableArray *viewControllers;
/** 区分跳转正在排号还是历史排号 0-正在排号  1-历史排号  (NSInteger) **/
@property (nonatomic, assign) NSInteger vcType;
/** 暂未   (strong) **/
@property (nonatomic, strong) UIView *placeHolderView;
@end

@implementation QueueVC0703
-(QueueAddNumView *)addAlertView{
    if (!_addAlertView) {
        _addAlertView = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([QueueAddNumView class]) owner:nil options:nil] lastObject];
        [_addAlertView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithActionBlock:^(UITapGestureRecognizer * tapGR) {
            CGPoint point = [tapGR locationInView:_addAlertView];
            if (!CGRectContainsPoint(_addAlertView.backView.frame, point)) {
                [_addAlertView removeFromSuperview];
                _addAlertView = nil;
            }
        }]];
        [self.navigationController.view addSubview:_addAlertView];
        _addAlertView.sd_layout.spaceToSuperView(UIEdgeInsetsZero);
        [self.navigationController.view bringSubviewToFront:_addAlertView];
    }
    return _addAlertView;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = NO;
    self.tabBarController.tabBar.hidden = NO;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    self.titleView.text = @"排队管理";
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.placeHolderView.hidden = NO;
//    [self setUp];

}
- (void)setUp{
    self.tableV = [[UITableView alloc] initWithFrame:CGRectZero];
    self.tableV.backgroundColor = [UIColor whiteColor];
    _tableV.separatorStyle = 0;
    _tableV.showsVerticalScrollIndicator = NO;
    _tableV.delegate = self;
    _tableV.dataSource = self;
    [self.view addSubview:_tableV];

    _tableV.sd_layout
    .spaceToSuperView(UIEdgeInsetsMake(64, 0, 0, 0));

    [_tableV registerNib:[UINib nibWithNibName:NSStringFromClass([QueueNumberCell class]) bundle:Nil] forCellReuseIdentifier:@"queueCell"];

    ButtonStyle *addButton = [ButtonStyle buttonWithType:UIButtonTypeCustom];
    [addButton setBackgroundImage:[UIImage imageNamed:@"queue_add"] forState:UIControlStateNormal];
    [addButton addTarget:self action:@selector(addButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:addButton];
    [self.view bringSubviewToFront:addButton];
    addButton.sd_layout
    .bottomSpaceToView(self.view, pxSizeH(15) + 49)
    .rightSpaceToView(self.view, pxSizeW(12))
    .widthIs(pxSizeW(100))
    .heightEqualToWidth();

    [addButton setSd_cornerRadiusFromWidthRatio:@(0.5)];

}
//添加现场排号
- (void)addButtonClick:(ButtonStyle *)sender{
    self.addAlertView.hidden = NO;
}

#pragma mark -- tableView delegate --
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return pxSizeH(247);
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 6;//暂时固定显示三个
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0 || indexPath.row == 2 || indexPath.row == 4) {
        return pxSizeH(22);
    }
    return pxSizeH(216);
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{

    UIView *backView = [UIView new];
    backView.backgroundColor = [UIColor whiteColor];
    NSArray *titleArr = @[@"正在排号", @"排号状态", @"历史排号"];
    NSArray *arr = @[@"17", @"open", @"17"];

    for (NSInteger i = 0; i < arr.count; i++) {

        //三个按钮状态
        ButtonStyle *button = [ButtonStyle buttonWithType:UIButtonTypeCustom];
        [button setTitle:arr[i] forState:UIControlStateNormal];
        [button setBackgroundImage:[UIImage imageNamed:@"queue_buttonBackImage_un"] forState:UIControlStateNormal];
        [button setBackgroundImage:[UIImage imageNamed:@"queue_buttonBackImage"] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(queueStatusClick:) forControlEvents:UIControlEventTouchUpInside];
        [backView addSubview:button];

        //三个文字按钮
        YYLabel *titleLabel = [YYLabel new];
        titleLabel.text =  titleArr[i];
        titleLabel.font = [UIFont systemFontOfSize:autoScaleW(16)];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.textVerticalAlignment = YYTextVerticalAlignmentCenter;
        titleLabel.textColor = UIColorFromRGB(0x616161);
        [backView addSubview:titleLabel];

        button.tag = 300 + i;
        titleLabel.tag = 400 + i;


        button.sd_layout
        .leftSpaceToView(backView, pxSizeW(30) + i * (pxSizeW(144) + pxSizeW(136)))
        .topSpaceToView(backView, pxSizeH(20))
        .widthIs(pxSizeW(136))
        .heightEqualToWidth();

        titleLabel.sd_layout
        .leftEqualToView(button)
        .topSpaceToView(button, pxSizeH(22))
        .widthRatioToView(button, 1)
        .heightIs(pxSizeH(38));

        titleLabel.textTapAction = ^(UIView * _Nonnull containerView, NSAttributedString * _Nonnull text, NSRange range, CGRect rect) {

            [self queueStatusClick:[backView viewWithTag:containerView.tag - 100]];
        };
    }
    backView.layer.shadowOffset = CGSizeMake(backView.width_sd, 3);
    backView.layer.shadowColor = [UIColor lightGrayColor].CGColor;
    return backView;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    if (indexPath.row == 0 || indexPath.row == 2 || indexPath.row == 4) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell"];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if (indexPath.row == 0) {
            CAGradientLayer *gradientLayer = [CAGradientLayer layer];
            gradientLayer.colors = @[(__bridge id)RGB(225, 225, 225).CGColor, (__bridge id)UIColorFromRGB(0xf6f6f6).CGColor, (__bridge id)[UIColor whiteColor].CGColor];
            gradientLayer.locations = @[@0, @0.4, @1.0];
            gradientLayer.startPoint = CGPointMake(0, 0);
            gradientLayer.endPoint = CGPointMake(0, 1.0);
            gradientLayer.frame = CGRectMake(0, 0, kScreenWidth, pxSizeH(22));
            [cell.layer insertSublayer:gradientLayer atIndex:0];
//            cell.backgroundColor = [UIColor redColor];
        } else {
            cell.backgroundColor = [UIColor whiteColor];
        }
        return cell;
    }
    static  NSString *identify = @"queueCell";
    [QueueNumberCell cellStatus:0];
    QueueNumberCell *cell = [tableView dequeueReusableCellWithIdentifier:identify];
    if (!cell) {
        cell = [[QueueNumberCell alloc] initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:identify];
    }
    [cell.phoneLabel addTarget:self action:@selector(callPhone:) forControlEvents:UIControlEventTouchUpInside];
    cell.userInteractionEnabled = YES;
    return cell;
}
//-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
//    if (scrollView.contentOffset.y >= 0 && scrollView.contentOffset.y <= pxSizeH(247)) {
//
//        scrollView.contentInset = UIEdgeInsetsMake(-scrollView.contentOffset.y, 0, 0, 0);
//
//    }else if (scrollView.contentOffset.y >= pxSizeH(247)){
//
////        scrollView.contentInset = UIEdgeInsetsMake(-pxSizeH(247), 0, 0, 0);
//        [_tableV sizeToFit];
//    }
//}
//排号状态按钮
- (void)queueStatusClick:(ButtonStyle *)sender{

    if (sender.tag == 300 || sender.tag == 302) {
        NSArray *titleArr = @[];
        if (sender.tag == 300) {
            _vcType = 0;
            titleArr = @[@"2人桌（12）", @"4人桌（18）",@"多人桌（78）"];
        } else {
            _vcType = 1;
            titleArr = @[@"正常入座（20）", @"号码作废（15）", @"用户取消（30）"];
        }
        ZTPageViewController *pageVC = [[ZTPageViewController alloc] initWithTitles:titleArr viewControllers:self.viewControllers];
        [self.navigationController pushViewController:pageVC animated:YES];
    } else if (sender.tag == 301) {
        QueueStatusSetVC *setVC = [[QueueStatusSetVC alloc] initWithNibName:NSStringFromClass([QueueStatusSetVC class]) bundle:[NSBundle mainBundle]];
        [self.navigationController pushViewController:setVC animated:YES];
    } else {

    }
}
- (NSMutableArray *)viewControllers {
    if (!_viewControllers) {
        _viewControllers = [NSMutableArray array];

        for (int i = 1; i <= 3; i++) {
            QueueCurrentOrHistoryVC *vc = [[QueueCurrentOrHistoryVC alloc] init];
            vc.vcType = _vcType;
            vc.selectIndex = i;
            [_viewControllers addObject:vc];
        }
    }
    return _viewControllers;
}
//拨打电话
- (void)callPhone:(ButtonStyle *)sender {
    NSString *phoneNumber = sender.titleLabel.text;
    NSString *message = NSLocalizedString(phoneNumber, nil);
    NSString *cancelButtonTitle = NSLocalizedString(@"取消", nil);
    NSString *otherButtonTitle = NSLocalizedString(@"拨打", nil);

    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:message preferredStyle:UIAlertControllerStyleAlert];

    // Create the actions.
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:cancelButtonTitle style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        [alertController dismissViewControllerAnimated:YES completion:^{


        }];
    }];

    UIAlertAction *otherAction = [UIAlertAction actionWithTitle:otherButtonTitle style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        NSMutableString *str=[[NSMutableString alloc] initWithFormat:@"tel:%@",phoneNumber];
        UIWebView *callWebview = [[UIWebView alloc] init];
        [callWebview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:str]]];


    }];

    // Add the actions.
    [alertController addAction:cancelAction];
    [alertController addAction:otherAction];

    [self presentViewController:alertController animated:YES completion:nil];
}
#pragma  mark ------------------ 后厨功能未开启，或者 暂无订单---------------- lazy load -----------------
/** 如果后厨没有任务或者没有开启排队管理 **/
-(UIView *)placeHolderView{
    if (!_placeHolderView) {
        _placeHolderView = [[UIView alloc] initWithFrame:CGRectZero];
        _placeHolderView.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:_placeHolderView];

        UIImageView *imageView = [[UIImageView alloc] init];
        imageView.image = [UIImage imageNamed:@"排队整改中"];

        [_placeHolderView addSubview:imageView];

        imageView.sd_layout
        .centerXEqualToView(self.view)
        .centerYIs(self.view.center.y - 50)
        .widthIs(imageView.image.size.width * 1.5)
        .heightIs(imageView.image.size.height * 1.5);



        UILabel *titleLabel = [[UILabel alloc] init];
        //        titleLabel.text = @"请到系统设置(菜单－更多设置－系统设置)开启！";
        titleLabel.text = @"暂未开放，敬请期待";
        titleLabel.numberOfLines = 0;
        titleLabel.textColor = [UIColor lightGrayColor];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.font = [UIFont systemFontOfSize:autoScaleW(16)];
        [_placeHolderView addSubview:titleLabel];

        //        if (_dataArr.count == 0) {
        //            imageView.image = [UIImage imageNamed:@"暂无数据"];
        //            titleLabel.hidden = YES;
        //            [_tableV removeFromSuperview];
        //            _tableV = nil;
        //        } else {
        //            titleLabel.hidden = NO;
        //        }
        titleLabel.sd_layout
        .topSpaceToView(imageView, 7)
        .centerXEqualToView(imageView)
        .centerYEqualToView(imageView)
        .heightIs(40);
        [titleLabel setSingleLineAutoResizeWithMaxWidth:300];
        
    }
    return _placeHolderView;
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
