//
//  MyorderViewController.m
//  微点筷客商户端
//
//  Created by 张森森 on 16/10/10.
//  Copyright © 2016年 张森森. All rights reserved.
//
#define CC_DEGREES_TO_RADIANS(__ANGLE__) ((__ANGLE__) * 0.01745329252f) // PI / 180
// 弧度转角度
#define CC_RADIANS_TO_DEGREES(__ANGLE__) ((__ANGLE__) * 57.29577951f)
#import "MyorderViewController.h"
#import "UIBarButtonItem+SSExtension.h"
#import "BusinessErectViewController.h"
#import "OrderdetailViewController.h"
#import "FinishOrderViewController.h"
#import "CancleOrderViewController.h"
#import "QueueViewController.h"
#import "MyorderTableViewCell.h"
#import "ZTAddOrSubAlertView.h"
#import "MBProgressHUD+SS.h"
#import "OrderModel.h"
#import <arpa/inet.h>
#import <netdb.h>
#import <CocoaAsyncSocket/GCDAsyncSocket.h>

#import <UserNotifications/UserNotifications.h>
#import <UserNotificationsUI/UserNotificationsUI.h>

#import "ZTPrintFormatVC.h"
#import "SEPrinterManager.h"
#import "PrinterModel.h"
#import "OrderPrintDetailModel.h"
#import "NSString+TimeHandle.h"
#import "UIBarButtonItem+badgeNum.h"
#import "ZTPopOverMenu.h"
#import "DeviceSet.h"
#import "ReloadVIew.h"
@interface MyorderViewController ()<UITableViewDelegate,UITableViewDataSource,UIGestureRecognizerDelegate, UIApplicationDelegate, UIApplicationDelegate>
{
    NSArray * chooseTitleArr;
    NSIndexPath *currentIndexP;
    BOOL oldStatus;
    void(^netSuccessBlock)(BOOL);
    UILabel * _moveLineLabel;
    BOOL isBackDishesPop; //判断是否是从退菜界面退回来的，
}

@property (nonatomic,assign)NSInteger orderDetailBackNum;// 1 新订单 2 已预订 3 进行中
@property (nonatomic,strong)ButtonStyle *tempSelectButton; // 选中状态的button
@property (nonatomic,strong)UITableView * orderTableV; //
@property (nonatomic,strong)NSArray * cancelOrCallArr; //已预订 展示：联系 取消
@property (nonatomic,strong)NSArray * receptOrCancelArr; //新订单 展示： 接单 取消
@property (nonatomic,strong)NSArray * consumptionTypeArr; //进行中 展示： 0元 到店消费
@property (nonatomic,strong)ButtonStyle * queueBT; //旧的排队入口，方宏来后关闭。
@property (nonatomic,strong)QueueViewController * queueViewControl; //排队界面，需要保持存在，防止被销毁。 已关闭
@property (nonatomic,copy) NSString * orderType; //0 新订单 1 已预订 2 进行中
@property (nonatomic,assign)NSInteger pagecount; // 网络请求字段，刷新页数
@property (nonatomic,strong)NSMutableArray * dataModelArr; //数据源

/** 展位图   (strong) **/
@property (nonatomic, strong) UIImageView *placeHolderView;
/** model   (strong) **/
@property (nonatomic, strong) PrinterModel *printModel;
/** 只打印一次   (NSInteger) **/
@property (nonatomic, assign) NSInteger oncePrintCount;
/** 顶部选择视图   (strong) **/
@property (nonatomic, strong) UIView *topSelectView;
@end
//
@implementation MyorderViewController
-(UIImageView *)placeHolderView{
    if (!_placeHolderView) {
        _placeHolderView = [[UIImageView alloc] init];
        _placeHolderView.image = [UIImage imageNamed:@"暂无订单"];
        [self.view addSubview:_placeHolderView];
        _placeHolderView.sd_layout
        .centerXEqualToView(self.view)
        .centerYEqualToView(self.view)
        .widthIs(_placeHolderView.image.size.width * 2)
        .heightIs(_placeHolderView.image.size.height * 2);
    }

    [self.view bringSubviewToFront:_placeHolderView];
    [_placeHolderView updateLayout];
    return _placeHolderView;
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [ReloadVIew registerReloadView:self];
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [[SEPrinterManager sharedInstance] autoConnectLastPeripheralTimeout:10 completion:^(CBPeripheral *perpheral, NSError *error) {
            ZTLog(@"%@%@",perpheral, error);
        }];
    });
    self.navigationController.navigationBar.hidden = NO;
    self.tabBarController.tabBar.hidden = NO;
    self.navigationController.navigationBar.barTintColor = UIColorFromRGB(0xfd7577);


    [self searchOrderOpenStatus];

    if (isBackDishesPop) {
        [self Gataf];
        isBackDishesPop = !isBackDishesPop;
    }
}
/* 订单界面流程
    1.界面即将出现， 请求打印机连接（走一次）--> 查询功能和权限（每次进订单就需要查询） -->
 */
- (void)viewDidLoad {
    [super viewDidLoad];
    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    delegate.notificationUserInfoBlock = ^(NSDictionary *userInfo){//收到新订单走这里
        ZTLog(@"%@", userInfo);
        NSString *classId = userInfo[@"map"][@"classId"];
        if ([classId isEqualToString:@"m0"]) {

            NSInteger isAutomaticOrder = [userInfo[@"map"][@"isAutomaticOrder"] integerValue];
            NSInteger isReserveOrders = [userInfo[@"map"][@"isReserveOrders"] integerValue];
            NSInteger newOrderType = [userInfo[@"map"][@"newOrderType"] integerValue];
            NSString *orderId = userInfo[@"map"][@"orderId"];
            //newOrderType	新订单状态	String	0未点菜，1点菜，2到店
            [self Choose:[self.view viewWithTag:3000]];//刷新新订单界面
            if (isReserveOrders== 1 && newOrderType == 1) {//线上订单，并且点菜
                [self getOrderInfo:orderId];
            } else if (isAutomaticOrder == 1 && newOrderType == 2) {//到店订单
                [self getOrderInfo:orderId];
            } else {//线上无点菜订单

            }
        } else if ([classId isEqualToString:@"m2"] || [classId isEqualToString:@"m1"]) {
            [self Choose:[self.view viewWithTag:3000]];//自动取消逾期订单，刷新界面
        } else ;
    };
    /* ＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊Wi-Fi状态＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊*/
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (![[DeviceSet shareDevice] isWiFiEnabled]) { //检测Wi-Fi是否打开
            [[DeviceSet shareDevice] showAlertWiFiStatus:@"“微点筷客”检测到Wi-Fi处于关闭状态" subTitle:@"是否前往系统设置打开？" rootUrl:@"WIFI" completionHandler:^(BOOL success){
            }];
        } else {
            if (![[[DeviceSet shareDevice] getNetWorkStates] isEqualToString:@"wifi"]) {
                //c
                [[DeviceSet shareDevice] showAlertWiFiStatus:@"“微点筷客”检测到正在使用本地网络" subTitle:@"是否前往系统设置Wi-Fi？" rootUrl:@"WIFI" completionHandler:^(BOOL success){
                }];
            }
        }
    });
    if (![[DeviceSet shareDevice] isAllowedNotification]) {
        [[DeviceSet shareDevice] showAlertWiFiStatus:@"“微点筷客”检测到推送权限被关闭" subTitle:@"打开通知有助于及时处理新订单，是否前往系统设置打开推送权限？" rootUrl:@"NOTIFICATIONS_ID" completionHandler:^(BOOL success){
        }];
    }
}

- (void)jugeDataModelArrIsNull{
    if (_dataModelArr.count <=0) {
        dispatch_async(dispatch_get_main_queue(), ^{
            self.placeHolderView.hidden = NO;
            [self.view addSubview:_placeHolderView];
            self.view.backgroundColor = [UIColor whiteColor];
            [self.view bringSubviewToFront:_placeHolderView];
        });
    } else {
        _placeHolderView.hidden = YES;
        [_placeHolderView removeFromSuperview];
        _placeHolderView = nil;
    }
    _orderTableV.backgroundColor = self.view.backgroundColor;

}

- (void)judgeBaseViewControllerStatus:(BOOL)isOut{
    [super judgeBaseViewControllerStatus:isOut];
    if (!isOut) {

        [self searchOrderOpenStatus];
    }
}

#pragma mark --- 查询订单功能是否开启 －－－
- (void)searchOrderOpenStatus{

    LoginInfoModel *_model = _BaseModel;
    NSString *isBoss = _model.isBoss;
    NSString *userId = _model.id;
    NSString *keyUrl = @"api/merchant/searchFeatures";
    NSString *flag = @"is_book";
    NSString *loadUrl = [NSString stringWithFormat:@"%@%@?token=%@&storeId=%@&flag=%@&isBoss=%@&userId=%@", kBaseURL, keyUrl, TOKEN, storeID, flag, isBoss, userId];


    [[QYXNetTool shareManager] postNetWithUrl:loadUrl urlBody:nil bodyStyle:QYXBodyString header:nil response:QYXJSON success:^(id result) {
        if ([result[@"msgType"] integerValue] == 0) {
            //权限/功能 判断 0 没有 1有
            BOOL newStatus = [result[@"obj"][@"is_book"] integerValue] == 0 ? NO : YES;
            BOOL newLimitStatus = [result[@"obj"][@"isOrderManage"] integerValue] == 0 ? NO : YES;
            if (newStatus && newLimitStatus) {
                if (oldStatus == newStatus) {
                    //不创建视图
                } else {
                    //删除旧视图，创建新视图
                    [_topSelectView removeAllSubviews];
                    [_placeHolderView removeFromSuperview];
                    _placeHolderView = nil;
                    chooseTitleArr = @[@"新订单",@"已预订",@"进行中"];
                    [self createWholeView];
                }
            } else {
                //删除旧视图，创建新视图
                [_topSelectView removeAllSubviews];
                [_placeHolderView removeFromSuperview];
                _placeHolderView = nil;
                chooseTitleArr = @[@"进行中"];
                [self createWholeView];
            }
            oldStatus = newStatus;
        }
    } failure:^(NSError *error) {

    }];
}
#pragma mark --- 查询订单功能是否开启 －－－
- (void)searchQueueStatus{

    LoginInfoModel *_model = _BaseModel;
    NSString *isBoss = _model.isBoss;
    NSString *userId = _model.id;
    NSString *keyUrl = @"api/merchant/searchFeatures";
    NSString *flag = @"is_line";
    NSString *loadUrl = [NSString stringWithFormat:@"%@%@?token=%@&storeId=%@&flag=%@&isBoss=%@&userId=%@", kBaseURL, keyUrl, TOKEN, storeID, flag, isBoss, userId];


    [[QYXNetTool shareManager] postNetWithUrl:loadUrl urlBody:nil bodyStyle:QYXBodyString header:nil response:QYXJSON success:^(id result) {
        if ([result[@"msgType"] integerValue] == 0) {
            //权限/功能 判断 0 没有 1有
            BOOL newQueueStatus = [result[@"obj"][@"is_line"] integerValue] == 0 ? NO : YES;
            BOOL newOrderStatus = [result[@"obj"][@"isOrderManage"] integerValue] == 0 ? NO : YES;
            if (newOrderStatus && newQueueStatus) {
                if (netSuccessBlock) {
                    netSuccessBlock(YES);
                }
            }
            [self Gataf];
        }
    } failure:^(NSError *error) {

    }];
}
#pragma mark 网络请求
-(void)Gataf
{

    [SVProgressHUD showWithStatus:@"请稍等"];

    NSString *loadUrl = [NSString stringWithFormat:@"%@api/merchant/searchOrder?token=%@&storeId=%@&searchYear=&searchMonth=&orderType=%@&offset=%ld&rows=%d",kBaseURL,TOKEN,tempStoreID,_orderType,(long)_pagecount,8];

    [[QYXNetTool shareManager] postNetWithUrl:loadUrl urlBody:nil bodyStyle:QYXBodyString header:nil response:QYXJSON success:^(id result) {
        [SVProgressHUD dismiss];
        _dataModelArr = [NSMutableArray array];
        id obj = result[@"obj"];

        if ([result[@"msgType"] integerValue] == 0) {
            if (![obj isNull] && ![obj isKindOfClass:[NSString class]]) {
                NSArray * objvalue = [result objectForKey:@"obj"];
                for (int i=0; i<objvalue.count; i++) {
                    OrderModel * model = [[OrderModel alloc]initWithgetsomethingwithdict:objvalue[i]];
                    [_dataModelArr addObject:model];
                }
            }
        } else {
            [SVProgressHUD showErrorWithStatus:@"操作异常"];
        }
        [_orderTableV.mj_header endRefreshing];
        dispatch_async(dispatch_get_main_queue(), ^{
            [_orderTableV reloadData];
            [self jugeDataModelArrIsNull];
        });
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUD];
        [SVProgressHUD dismiss];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.002 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [SVProgressHUD showErrorWithStatus:@"网络参数错误"];
        });
    }];

}
- (void)createTopSelectViewWithTitleArr:(NSArray *)titleArr{

    if (_topSelectView == nil) {
        _topSelectView = [[UIView alloc] init];
        _topSelectView.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:_topSelectView];
    }
    _topSelectView.sd_layout
    .leftEqualToView(self.view)
    .rightEqualToView(self.view)
    .topSpaceToView(self.view, 64)
    .heightIs(50);


    UILabel *topLine = [[UILabel alloc] init];
    topLine.backgroundColor = UIColorFromRGB(0xeeeeee);
    [_topSelectView addSubview:topLine];
    topLine.sd_layout
    .leftEqualToView(_topSelectView)
    .rightEqualToView(_topSelectView)
    .topSpaceToView(_topSelectView, 0)
    .heightIs(1);
    //创建三个导航栏标签
    for (int i=0; i<chooseTitleArr.count; i++) {
        ButtonStyle * chooseBT = [ButtonStyle  buttonWithType:UIButtonTypeCustom];
        chooseBT.titleLabel.font = [UIFont systemFontOfSize:autoScaleW(13)];
        [chooseBT setTitle:chooseTitleArr[i] forState:UIControlStateNormal];
        [chooseBT setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        [chooseBT setTitleColor:UIColorFromRGB(0xfd7577) forState:UIControlStateSelected];
        [chooseBT setBackgroundColor:[UIColor clearColor]];
        chooseBT.tag = chooseTitleArr.count == 1 ? 3002 : (3000+i);
        [chooseBT addTarget:self action:@selector(Choose:) forControlEvents:UIControlEventTouchUpInside];
        [_topSelectView addSubview:chooseBT];

        if (chooseTitleArr.count == 1) {
            chooseBT.sd_layout
            .centerXEqualToView(_topSelectView)
            .topSpaceToView(topLine, 0)
            .widthIs(kScreenWidth/3)
            .heightIs(autoScaleH(35));

        } else {
            chooseBT.sd_layout
            .leftSpaceToView(_topSelectView,+i*(kScreenWidth/3))
            .topSpaceToView(topLine, 0)
            .widthIs(kScreenWidth/3)
            .heightIs(autoScaleH(40));
        }

        if ((i == 0 && chooseTitleArr.count == 1) || (chooseTitleArr.count > 1  && i ==1)) {
            for (NSInteger i = 0; i < 2; i++) {

                UILabel * midSeparaLabel = [[UILabel alloc]init];
                midSeparaLabel.backgroundColor = RGB(234, 234, 234);
                [chooseBT addSubview:midSeparaLabel];
                midSeparaLabel.sd_layout
                .centerYEqualToView(chooseBT)
                .widthIs(1)
                .heightIs(26);
                if (i==0) {
                    midSeparaLabel.sd_layout.leftSpaceToView(chooseBT,0);
                } else {
                    midSeparaLabel.sd_layout.rightSpaceToView(chooseBT,0);
                }
            }
        }
        if (i==0) {
            _moveLineLabel = [[UILabel alloc]init];
            _moveLineLabel.backgroundColor = UIColorFromRGB(0xfd7577);
            [_topSelectView addSubview:_moveLineLabel];
            _moveLineLabel.sd_layout
            .centerXEqualToView(chooseBT)
            .bottomEqualToView(chooseBT)
            .widthIs(kScreenWidth/3-autoScaleW(30))
            .heightIs(2);

            chooseBT.selected = YES;
            _tempSelectButton = chooseBT;
        }
    }
    UILabel *bottomLine = [[UILabel alloc]init];
    bottomLine.backgroundColor = topLine.backgroundColor;
    [_topSelectView addSubview:bottomLine];
    bottomLine.sd_layout
    .leftEqualToView(_topSelectView)
    .rightEqualToView(_topSelectView)
    .topSpaceToView([self.view viewWithTag:3002], 0)
    .heightIs(1.3);
    [_topSelectView setupAutoHeightWithBottomView:bottomLine bottomMargin:0];
    [_topSelectView updateLayout];
}
- (void)createWholeView{
    self.titleView.text = @"订单管理";


    self.leftButton = [ButtonStyle buttonWithType:UIButtonTypeCustom];
    self.leftButton.frame = CGRectMake(0, 7, 100, 30);
    [self.leftButton setTitle:@"菜单" forState:UIControlStateNormal];
    self.leftButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    self.leftButton.titleLabel.font =[UIFont systemFontOfSize:15];
    [self.leftButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.leftButton setImage:[UIImage imageNamed:@"cd"] forState:UIControlStateNormal];
    [self.leftButton addTarget:self action:@selector(Clickbtn) forControlEvents:UIControlEventTouchUpInside];
    self.leftButton.adjustsImageWhenHighlighted = NO;
    UIBarButtonItem *leftBarItem = [[UIBarButtonItem alloc] initWithCustomView:self. leftButton];
    self.navigationItem.leftBarButtonItem = leftBarItem;

    _orderDetailBackNum = 1;

    self.automaticallyAdjustsScrollViewInsets = NO;


    UIBarButtonItem * morebtn = [UIBarButtonItem itemWithTarget:self Action:@selector(Shezhi:) image:@"白加" selectImage:nil];
    self.navigationItem.rightBarButtonItems.firstObject.badgeValue = @"19";
    //    _queueBT = [ButtonStyle buttonWithType:UIButtonTypeCustom];
    //    _queueBT.frame = CGRectMake(0, 7, 50, 30);
    //    _queueBT.contentMode = UIViewContentModeLeft;
    //    [_queueBT setImage:[UIImage imageNamed:@"排队开"] forState:UIControlStateNormal];
    //    [_queueBT addTarget:self action:@selector(Queue) forControlEvents:UIControlEventTouchUpInside];
    //    UIBarButtonItem * btn = [[UIBarButtonItem alloc]initWithCustomView:_queueBT];
    self.navigationItem.rightBarButtonItems = @[morebtn];

    [self createTopSelectViewWithTitleArr:chooseTitleArr];

    _orderType = @"0";
    _pagecount = 0;
    [self Choose:_tempSelectButton];
    _dataModelArr = [NSMutableArray array];
    _receptOrCancelArr = @[@"接单",@"取消"];
    _cancelOrCallArr = @[@"联系",@"取消",];
    _consumptionTypeArr = @[@"￥0元",@"到店消费"];


    if (_orderTableV == nil) {
        _orderTableV = [[UITableView alloc]init];
        _orderTableV.separatorStyle = UITableViewCellSeparatorStyleNone;
        _orderTableV.showsVerticalScrollIndicator = NO;
        _orderTableV.delegate = self;
        _orderTableV.dataSource = self;
        [self.view addSubview:_orderTableV];
        MJChiBaoziHeader *header = [MJChiBaoziHeader headerWithRefreshingTarget:self refreshingAction:@selector(Gataf)];
        _orderTableV.mj_header = header;
        //    [_orderTableV.mj_header beginRefreshing];

    }
    _orderTableV.sd_layout
    .leftSpaceToView(self.view,0)
    .topSpaceToView(_topSelectView, 0)
    .rightSpaceToView(self.view,0)
    .bottomSpaceToView(self.view, 49);
}
-(void)Clickbtn
{
    [[NSNotificationCenter defaultCenter]postNotificationName:LEFT_VC_CANCEL_FLAG object:nil];
}
#pragma mark 排队大按钮
-(void)Queue
{
    [self searchQueueStatus];
    __weak typeof(self)weakSelf = self;
    netSuccessBlock = ^(BOOL success) {
        __strong typeof(weakSelf)strongSelf = weakSelf;
        if (success) {
            if (!strongSelf.queueViewControl) {
                strongSelf.queueViewControl = [[QueueViewController alloc]init];
                //                QueueViewController *queueVC = [[QueueViewController alloc] init];
            }
            [strongSelf.navigationController pushViewController:strongSelf.queueViewControl animated:YES];
        }
    };


}
-(void)Choose:(ButtonStyle * )btn
{
    _tempSelectButton.selected = NO;
    btn.selected = YES;


    _tempSelectButton = btn;


    if (btn.tag==3000 ) {
        _orderDetailBackNum=1;
        _orderType = @"0";
    }
    if (btn.tag==3001) {
        _orderDetailBackNum=2;
        _orderType = @"1";
    }
    if (btn.tag==3002) {
        _orderDetailBackNum = 3;
        _orderType = @"2";
    }
    [self Gataf];

    [UIView animateWithDuration:.35 animations:^{
        _moveLineLabel.center = CGPointMake(btn.center.x, _moveLineLabel.center.y);
        _moveLineLabel.sd_layout
        .centerXEqualToView(btn);
        [_moveLineLabel updateLayout];
    }];

}
#pragma mark 判断手势跟cell方法是否冲突
-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    if ([NSStringFromClass([touch.view class]) isEqualToString:@"UITableViewCellContentView"]) {
        //返回为NO则屏蔽手势事件
        return NO;
    }
    return YES;


}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _dataModelArr.count;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *tabstr = @"order";
    MyorderTableViewCell * cell = [tableView cellForRowAtIndexPath:indexPath];

    if (!cell) {

        cell = [[MyorderTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:tabstr];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.layer.borderWidth = 1;
    cell.layer.borderColor = UIColorFromRGB(0xeeeeee).CGColor;

    OrderModel * model = _dataModelArr[indexPath.section];
    cell.orderStatus = _orderDetailBackNum;
    cell.model = model;
    NSString *url = [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:model.imagestr]] ? model.imagestr : [model.imagestr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [cell.headimage sd_setImageWithURL:[NSURL URLWithString:url]];
    cell.namelabel.text = model.namestr;
    cell.numberlabel.text = [NSString stringWithFormat:@"第%@次到店",model.severalStore] ;
    cell.ydtimelabel.text = model.creattime;


    if ([model.disOrderType integerValue] == 1) {
        cell.timelabel.text = @"客人已到店，等待接单";
    } else {
        cell.timelabel.text = [NSString stringWithFormat:@"预定%@到店",model.arrivaltime];
    }

    NSMutableAttributedString * str = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"定金￥%@",model.totalmoney]];
    [str addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:13] range:NSMakeRange(0,2)];
    [str addAttribute:NSForegroundColorAttributeName value:[UIColor lightGrayColor] range:NSMakeRange(0, 2)];
    cell.moneylabel.attributedText = str;

    if (_orderDetailBackNum==1) {

        ButtonStyle * fbtn = (ButtonStyle *)[cell viewWithTag:300];
        ButtonStyle * sbtn = (ButtonStyle *)[cell viewWithTag:301];
        ButtonStyle * tbtn = (ButtonStyle *)[cell viewWithTag:400];

        if (fbtn) {
            [fbtn removeFromSuperview];
        }

        if (sbtn) {
            [sbtn removeFromSuperview];
        }
        if (tbtn) {

            [tbtn removeFromSuperview];
        }

        for (int a=0; a<2; a++) {
            ButtonStyle * shoosebtn = [ButtonStyle buttonWithType:UIButtonTypeCustom];
            [shoosebtn setTitle:_receptOrCancelArr[a] forState:UIControlStateNormal];
            if (a==0) {
                [shoosebtn setTitleColor:UIColorFromRGB(0xfd7577) forState:UIControlStateNormal];

                shoosebtn.titleLabel.adjustsFontSizeToFitWidth = YES;

            } else {
                [shoosebtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];

            }
            [shoosebtn addTarget:self action:@selector(clickShooseBT:event:) forControlEvents:UIControlEventTouchUpInside];
            shoosebtn.tag = 200+a;
            shoosebtn.titleLabel.font = [UIFont systemFontOfSize:autoScaleW(13)];
            [cell addSubview:shoosebtn];
            shoosebtn.sd_layout.rightSpaceToView(cell,autoScaleW(20)+a*autoScaleW(35)).topSpaceToView(cell,autoScaleH(40)).widthIs(autoScaleW(30)).heightIs(autoScaleH(35));
        }

    }
    if (_orderDetailBackNum==2) {

        NSDateComponents *components = [NSString getDateSubFromNowTime:nil endTime:model.arrivalTime];
        if(components.second < 0) {
            //没迟到
        } else {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (components.hour == 0 && components.day == 0) {
                    cell.timelabel.text = [NSString stringWithFormat:@"客人已迟到%ld分钟", (long)components.minute];
                } else if (components.day > 0) {
                    cell.timelabel.text = [NSString stringWithFormat:@"客人已迟到%ld天%ld小时%ld分钟", (long)components.day, (long)components.hour, (long)components.minute];
                    cell.timelabel.adjustsFontSizeToFitWidth = YES;
                } else {
                    cell.timelabel.text = [NSString stringWithFormat:@"客人已迟到%ld小时%ld分钟", (long)components.hour, (long)components.minute];
                }

                cell.timelabel.textColor = UIColorFromRGB(0xfd7577);

            });
        }

        ButtonStyle * fbtn = (ButtonStyle *)[cell viewWithTag:200];
        ButtonStyle * sbtn = (ButtonStyle *)[cell viewWithTag:201];
        ButtonStyle * tbtn = (ButtonStyle *)[cell viewWithTag:400];
        if (fbtn) {
            [fbtn removeFromSuperview];
        }

        if (sbtn) {
            [sbtn removeFromSuperview];
        }
        if (tbtn) {

            [tbtn removeFromSuperview];
        }

        for (int a=0; a<2; a++) {

            ButtonStyle * shoosebtn = [ButtonStyle buttonWithType:UIButtonTypeCustom];
            [shoosebtn setTitle:_cancelOrCallArr[a] forState:UIControlStateNormal];
            if (a==1)
            {
                [shoosebtn setTitleColor:UIColorFromRGB(0xfd7577) forState:UIControlStateNormal];
                NSDateComponents *components = [NSString getDateSubFromNowTime:nil endTime:model.arrivalTime];
                if (components.second < 0) {
                    //没迟到，不能取消订单
                    [shoosebtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
                }
            }
            else
            {
                [shoosebtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            }
            shoosebtn.tag = 300+a;
            [shoosebtn addTarget:self action:@selector(Late:event:) forControlEvents:UIControlEventTouchUpInside];
            shoosebtn.titleLabel.font = [UIFont systemFontOfSize:autoScaleW(13)];
            [cell addSubview:shoosebtn];
            shoosebtn.sd_layout.rightSpaceToView(cell,autoScaleW(20)+a*autoScaleW(35)).topSpaceToView(cell,autoScaleH(40)).widthIs(autoScaleW(35)).heightIs(autoScaleH(20));;

        }
    }
    if (_orderDetailBackNum==3) {
        cell.orderStatus = 3;
        cell.timelabel.text = @"客人正在用餐";

        ButtonStyle * fbtn = (ButtonStyle *)[cell viewWithTag:300];
        ButtonStyle * sbtn = (ButtonStyle *)[cell viewWithTag:301];
        ButtonStyle * tbtn = (ButtonStyle *)[cell viewWithTag:200];
        ButtonStyle * zbtn = (ButtonStyle *)[cell viewWithTag:201];

        if (fbtn) {
            [fbtn removeFromSuperview];
        }
        if (sbtn) {
            [sbtn removeFromSuperview];
        }
        if (tbtn) {

            [tbtn removeFromSuperview];
        }
        if (zbtn) {
            [zbtn removeFromSuperview];
        }
        for (int i =0; i<2; i++) {

            UILabel * moneylabel = [[UILabel alloc]init];

            moneylabel.text = _consumptionTypeArr[i];
            if (![model.extraFee isNull] && i == 0) {
                moneylabel.text = model.extraFee;
            }
            moneylabel.font = [UIFont systemFontOfSize:autoScaleW(13)];
            moneylabel.textAlignment = NSTextAlignmentCenter;
            moneylabel.textColor = [UIColor lightGrayColor];
            [cell addSubview:moneylabel];
            moneylabel.sd_layout.rightSpaceToView(cell,autoScaleW(15)).topSpaceToView(cell,autoScaleH(40)+i*autoScaleH(23)).widthIs(autoScaleW(100)).heightIs(autoScaleH(15));
        }

    }
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return autoScaleH(90);
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    currentIndexP = indexPath;

    OrderModel * model = _dataModelArr[indexPath.section];
    OrderdetailViewController * orderdetailview = [[OrderdetailViewController alloc]init];
    orderdetailview.model = model;
    if (_orderDetailBackNum == 1) {
        orderdetailview.ztingeger = 0;
    } else if (_orderDetailBackNum == 2) {
        orderdetailview.ztingeger = 1;
    } else {
        orderdetailview.ztingeger = 2;
    }
    orderdetailview.clickReceiveOrderBT = ^(BOOL receive){
        if (receive) {
            //接受订单
            [self uploadReceiveOrder];
        } else {
            //不接受订单
            dispatch_async(dispatch_get_main_queue(), ^{
                [self Gataf];
            });
        }
    };
    [self.navigationController pushViewController:orderdetailview animated:YES];
    isBackDishesPop = YES;

}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 5;
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat sectionHeaderHeight = 5;
    if (scrollView.contentOffset.y<=sectionHeaderHeight&&scrollView.contentOffset.y>=0) {
        scrollView.contentInset = UIEdgeInsetsMake(-scrollView.contentOffset.y, 0, 0, 0);
    } else if (scrollView.contentOffset.y>=sectionHeaderHeight) {
        scrollView.contentInset = UIEdgeInsetsMake(-sectionHeaderHeight, 0, 0, 0);
    }
}
/** cell 接单 **/
- (void)clickShooseBT:(ButtonStyle *)btn event:(id)event
{
    NSSet * touches = [event allTouches];
    UITouch *touch = [touches anyObject];
    CGPoint cureentTouchPosition=[touch locationInView:_orderTableV];
    NSIndexPath * index = [_orderTableV indexPathForRowAtPoint:cureentTouchPosition];
    currentIndexP = index;
    OrderModel * model = _dataModelArr[index.section];


    if (btn.tag==200) {
        ZTAddOrSubAlertView * addsub = [[ZTAddOrSubAlertView alloc]initWithStyle:ZTalertSheetStyleSubTitle];
        addsub.titleLabel.font = [UIFont systemFontOfSize:autoScaleW(15)];
        addsub.titleLabel.text = @"确定接单";
        addsub.littleLabel.text = @"请务必在该时段为用户预留桌位";
        [addsub.cancelBT setTitle:@"考虑一下" forState:UIControlStateNormal];
        [addsub.confirmBT setTitle:@"立刻接单" forState:UIControlStateNormal];
        addsub.complete = ^(BOOL click)
        {
            if (click==YES) {
                //接单的同时，打印订单信息
                [self uploadReceiveOrder];
            }
        };

    }
    if (btn.tag==201) {

        CancleOrderViewController * cancleview = [[CancleOrderViewController alloc]init];
        cancleview.orderid = model.orderid;
        cancleview.phoneNum = model.phonestr;
        cancleview.NetUploadSuccess = ^(BOOL success){
            if (success) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self Gataf];
                    [_orderTableV reloadData];
                });
            }
        };
        [self.navigationController pushViewController:cancleview animated:YES];
    }
}
- (void)uploadReceiveOrder{
    OrderModel * model = _dataModelArr[currentIndexP.section];
    [MBProgressHUD showMessage:@"请稍等"];
    NSString *uploadUrl = [NSString stringWithFormat:@"%@api/merchant/orderManage?token=%@&storeId=%@&orderId=%@&remark=&status=&operType=%@&userId=%@",kBaseURL,TOKEN,storeID,model.orderid,@"0", UserId];

    [[QYXNetTool shareManager] postNetWithUrl:uploadUrl urlBody:nil bodyStyle:QYXBodyString header:nil response:QYXJSON success:^(id result) {
        [MBProgressHUD hideHUD];
        //         NSLog(@"mmmm%@%@",result,[result objectForKey:@"msgType"]);
        NSString * msgstr = [result objectForKey:@"msgType"];
        if ([msgstr isEqualToString:@"0"]) {
            [SVProgressHUD showSuccessWithStatus:@"操作成功"];
            //获取打印信息，并打印
            [self getOrderInfo:model.orderid];
            [self Gataf];
        } else {
            [SVProgressHUD showSuccessWithStatus:result[@"msg"]];
            [self Gataf];
        }
    } failure:^(NSError *error) {
    }];
}
//获取当前打印订单信息
- (void)getOrderInfo:(NSString *)orderId{
    //    /api/order/orderData
    _oncePrintCount = 0;
    NSString *keyUrl = @"api/order/orderData";
    NSString *storeId = storeID;
    NSString *loadUrl = [NSString stringWithFormat:@"%@%@?token=%@&storeId=%@&orderId=%@", kBaseURL, keyUrl, TOKEN, storeId, orderId];

    [[QYXNetTool shareManager] postNetWithUrl:loadUrl urlBody:nil bodyStyle:QYXBodyString header:nil response:QYXJSON success:^(id result) {
        //        ZTLog(@"%@", result);
        if ([result[@"msgType"] integerValue] == 0) {
            _printModel = [PrinterModel mj_objectWithKeyValues:result[@"obj"]];
            //初始化打印配置

            //打印相关数据
            //判断是否连接打印机
            if ([SEPrinterManager sharedInstance].isConnected == NO) {
                //未连接打印机
                ZTPrintFormatVC *printVC = [[ZTPrintFormatVC alloc] init];
                printVC.orderId = orderId;
                [self.navigationController pushViewController:printVC animated:YES];

            } else {
                //自动重新连接上次保存的打印机
                //只打印一次
                [[SEPrinterManager sharedInstance] fullOptionPeripheral:[SEPrinterManager sharedInstance].connectedPerpheral completion:^(SEOptionStage stage, CBPeripheral *perpheral, NSError *error) {
                    if (stage == SEOptionStageSeekCharacteristics) {
                        HLPrinter *printer = [self getPrinter:orderId];
                        NSData *mainData = [printer getFinalData];
                        if (_oncePrintCount == 0) {
                            for (NSInteger i = 0; i < [_printModel.printPage integerValue]; i++) {
                                [[SEPrinterManager sharedInstance] sendPrintData:mainData completion:^(CBPeripheral *connectPerpheral, BOOL completion, NSString *error) {
                                    if (completion) {
                                        [self.navigationController popViewControllerAnimated:YES];
                                    }
                                }];
                            }
                        }
                        _oncePrintCount++;
                    }
                }];
            }
        }
    } failure:^(NSError *error) {

    }];
}
- (HLPrinter *)getPrinter:(NSString *)orderId{
    HLPrinter *printer = [[HLPrinter alloc] init];
    NSString *title = _BaseModel.storeBase.name;

    [printer appendText:title alignment:HLTextAlignmentCenter fontSize:HLFontSizeTitleMiddle];
    NSString *orderNum = [NSString stringWithFormat:@"订单号:%@", orderId];
    [printer appendText:orderNum alignment:HLTextAlignmentCenter fontSize:0x07];
    NSString *orderDate = [NSString getDateFromNow:TIME_TO_SEC]; //@"2017-01-03-10:00";
    [printer appendText:orderDate alignment:HLTextAlignmentCenter fontSize:HLFontSizeTitleSmalle];
    //    NSString *oneseparatorLine = @"--------------";
    [printer appendSeperatorLine];

    [printer appendTitle:@"订单状态:" value:[self judgeOrderType:_printModel.orderType] valueOffset:150];
    NSString *arriveTimeNum = [NSString stringWithFormat:@"%@(第%@次到店)", _printModel.orderName, _printModel.severalStore];
    [printer appendTitle:@"用户昵称:" value:arriveTimeNum valueOffset:150];
    [printer appendTitle:@"用餐人数:" value:[_printModel.mealsNo isNull] ? @"待定" : _printModel.mealsNo valueOffset:150];

    NSString *boardNum = [NSString stringWithFormat:@"%@", _printModel.boardNum];
    [printer appendTitle:@"桌号:" value:boardNum valueOffset:150];
    NSString *createTime = [[_printModel.createTime getDateTimeFromTimeStrWithOption:TIME_TO_SEC] substringFromIndex:5];
    [printer appendTitle:@"预定时间" value:createTime valueOffset:150];
    [printer appendTitle:@"预留时间:" value:@"30分钟以上" valueOffset:150];
    [printer appendTitle:@"联系方式:" value:_printModel.userPhone valueOffset:150];
    //    NSString *twoSeparatorLine = @"----------------";
    [printer appendSeperatorLine];

    NSString *remark = [_printModel.remark isNull] ? @"无" :_printModel.remark;
    [printer appendTitle:@"备注信息:" value:remark valueOffset:150];

    //    NSString *threeSeparatorLine = @"-----------------";
    [printer appendSeperatorLine];


    NSString *dishesInfo = @"菜品信息";
    [printer appendText:dishesInfo alignment:HLTextAlignmentCenter];
    __block CGFloat total = 0.0;
    //    NSMutableArray *dishesArr = [NSMutableArray array];
    [printer appendLeftText:@"菜名" middleText:@"数量" rightText:@"单价" isTitle:NO];
    [_printModel.orderDets enumerateObjectsUsingBlock:^(OrderPrintDetailModel  * orderModel, NSUInteger idx, BOOL * _Nonnull stop) {

        [printer appendLeftText:orderModel.productName middleText:[NSString stringWithFormat:@" x %@", orderModel.quantity] rightText:orderModel.fee isTitle:NO];
        total += [orderModel.fee floatValue] * [orderModel.quantity intValue];

    }];
    //    NSDictionary *dict1 = @{@"name":@"老王",@"amount":@"5",@"price":@"2.0"};
    //    NSDictionary *dict2 = @{@"name":@"老王八",@"amount":@"1",@"price":@"1.0"};
    //    NSDictionary *dict3 = @{@"name":@"老王八吧",@"amount":@"3",@"price":@"3.0"};
    //    NSArray *goodsArray = @[dict1, dict2, dict3];
    //    for (NSDictionary *dict in goodsArray) {
    //        [printer appendLeftText:dict[@"name"] middleText:dict[@"amount"] rightText:dict[@"price"] isTitle:NO];
    //        total += [dict[@"price"] floatValue] * [dict[@"amount"] intValue];
    //    }
    [printer appendSeperatorLine];

    NSString *totalStr = [NSString stringWithFormat:@"￥%.2lf", total];
    [printer appendTitle:@"菜品总额:" value:totalStr];
    NSString *disCategory = [_printModel.cardTitle isNull] ? @"优惠金额:": _printModel.cardTitle;
    NSString *discountNum = [NSString stringWithFormat:@"￥%.2lf", [_printModel.discountedPrice floatValue]];
    [printer appendTitle:disCategory value:discountNum];
    CGFloat orderMoney = [_printModel.realTotalFee doubleValue];
    CGFloat backMoney = [_printModel.retreatPrice doubleValue];

    NSString *orderOrBack = [NSString stringWithFormat:@"%.2lf/%.2lf", orderMoney, backMoney];
    [printer appendTitle:@"订金/退款:" value:orderOrBack];
    NSString *realPay = [NSString stringWithFormat:@"￥ %.2f", [_printModel.realTotalFee doubleValue]];
    [printer appendTitle:@"共计:" value:realPay fontSize:0x09];

    [printer appendFooter:nil];

    return printer;
}
- (NSString *)judgeOrderType:(NSString *)orderType{

    NSInteger orderStatus = [orderType integerValue];
    NSArray *cancelStatus = @[@2 ,@3, @5, @6, @7, @8, @9, @10, @13 ,@15, @16, @17, @20, @22, @23];
    NSArray *preStatus = @[@0, @1, @11, @12];//2 等待接单
    //    NSArray *recStatus = @[@4 , @14,@18, @19, @21];

    NSString *tempType = @"已取消";
    if ([cancelStatus containsObject:@(orderStatus)]) {
        tempType = @"已取消";
    } else if ([preStatus containsObject:@(orderStatus)]){
        tempType = @"已预订";
    } else {
        tempType = @"已接单";
    }

    return tempType;
}
-(void)Late:(ButtonStyle *)btn event:(id)event
{
    NSSet * touches = [event allTouches];
    UITouch *touch = [touches anyObject];
    CGPoint cureentTouchPosition=[touch locationInView:_orderTableV];
    NSIndexPath * index = [_orderTableV indexPathForRowAtPoint:cureentTouchPosition];
    OrderModel * model = _dataModelArr[index.section];

    if (btn.tag==301) {

        NSDateComponents *components = [NSString getDateSubFromNowTime:nil endTime:model.arrivalTime];
        if (components.second < 0) {
            //没迟到，不能取消订单
            [SVProgressHUD showInfoWithStatus:@"客人尚未迟到，暂不能取消该订单"];
            return;
        }

        ZTAddOrSubAlertView *alert = [[ZTAddOrSubAlertView alloc] initWithStyle:ZTalertSheetStyleSubTitle];
        alert.titleLabel.text = @"超时取消订单？";
        //        alert.littleLabel.text = [NSString stringWithFormat:@"退款说明：扣除用户实付金额%@的手续费", TAX];
        alert.littleLabel.text = [NSString stringWithFormat:@"退款说明：迟到预留时间最大为30分钟，超出后系统自动取消此订单，并扣除用户实付金额%@的手续费。", TAX];
        [alert.cancelBT setTitle:@"否" forState:UIControlStateNormal];
        [alert.confirmBT setTitle:@"是" forState:UIControlStateNormal];
        [alert showView];
        alert.complete = ^(BOOL complete){
            if (complete) {
                NSString *cancelReason = @"逾时过久，商家已取消此订单";
                [SVProgressHUD showWithStatus:@"加载中..."];
                NSString *uploadUrl = [NSString stringWithFormat:@"%@api/merchant/orderManage?token=%@&storeId=%@&orderId=%@&remark=%@&status=&operType=2&userId=%@&androidOrIos=ios&account=m%@",kBaseURL, TOKEN,storeID, model.orderid, cancelReason, _BaseModel.id, LoginName];

                [[QYXNetTool shareManager] postNetWithUrl:uploadUrl urlBody:nil bodyStyle:QYXBodyString header:nil response:QYXJSON success:^(id result) {
                    if ([result[@"msgType"] integerValue] == 0) {

                        [SVProgressHUD showSuccessWithStatus:@"取消成功"];
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [self Gataf];
                            [_orderTableV reloadData];
                        });
                    } else {
                        [SVProgressHUD showInfoWithStatus:@"操作失败"];
                    }
                } failure:^(NSError *error) {
                    [SVProgressHUD showErrorWithStatus:@"网络异常"];
                }];
            }
        };
    }
    if (btn.tag==300) {

        NSString *message = NSLocalizedString(model.phonestr, nil);
        NSString *cancelButtonTitle = NSLocalizedString(@"取消", nil);
        NSString *otherButtonTitle = NSLocalizedString(@"拨打", nil);

        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:message preferredStyle:UIAlertControllerStyleAlert];

        // Create the actions.
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:cancelButtonTitle style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
            [alertController dismissViewControllerAnimated:YES completion:^{


            }];
        }];

        UIAlertAction *otherAction = [UIAlertAction actionWithTitle:otherButtonTitle style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            NSMutableString *str=[[NSMutableString alloc] initWithFormat:@"tel:%@",model.phonestr];
            UIWebView *callWebview = [[UIWebView alloc] init];
            [callWebview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:str]]];
            [self.view addSubview:callWebview];
        }];

        // Add the actions.
        [alertController addAction:cancelAction];
        [alertController addAction:otherAction];

        [self presentViewController:alertController animated:YES completion:nil];

    }

}
#pragma mark 设置
-(void)Shezhi:(ButtonStyle *)btn
{

    self.navigationItem.rightBarButtonItem.badge.hidden = YES;
    ZTPopOverMenuConfiguration *config = [ZTPopOverMenuConfiguration defaultConfiguration];
    config.menuWidth = autoScaleW(110);
    config.menuIconMargin = autoScaleW(10);
    config.tintColor = [UIColor whiteColor];
    config.textColor = [UIColor blackColor];

    [ZTPopOverMenu showForSender:btn
                   withMenuArray:@[@"历史订单", @"相关设置"]
                      imageArray:@[@"搜索", @"设置-(1)"]
                       doneBlock:^(NSInteger selectedIndex) {
                           if (selectedIndex == 0) {

                               FinishOrderViewController * finishorderView = [[FinishOrderViewController alloc]init];
                               [self.navigationController pushViewController:finishorderView animated:YES];
                           } else if (selectedIndex == 1) {
                               BusinessErectViewController * busiView = [[BusinessErectViewController alloc]init];
                               busiView.modalPresentationStyle = UIModalPresentationCustom;
                               busiView.block = ^(NSString *string) {
                                   [self uploadOrderTime:string];
                               };
                               [self presentViewController:busiView animated:YES completion:^{

                               }];
                           } else;
                       } dismissBlock:^{
                           self.navigationItem.rightBarButtonItem.badge.hidden = NO;
                       }];


}

- (void)uploadOrderTime:(NSString *)time{

    NSString *keyUrl = @"api/merchant/bookDays";
    NSString *days = time;
    NSString *uploadUrl = [NSString stringWithFormat:@"%@%@?token=%@&storeId=%@&userId=%@&days=%@", kBaseURL, keyUrl,TOKEN, storeID, UserId, days];

    [[QYXNetTool shareManager] postNetWithUrl:uploadUrl urlBody:nil bodyStyle:QYXBodyString header:nil response:QYXJSON success:^(id result) {
        if ([result[@"msgType"] integerValue] == 0) {
            [SVProgressHUD showSuccessWithStatus:@"修改成功"];
        }
    } failure:^(NSError *error) {

    }];
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
