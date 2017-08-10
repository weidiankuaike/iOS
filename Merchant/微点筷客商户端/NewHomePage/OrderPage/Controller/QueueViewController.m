//
//  QueueViewController.m
//  微点筷客商户端
//
//  Created by 张森森 on 16/10/31.
//  Copyright © 2016年 张森森. All rights reserved.
//

#import "QueueViewController.h"
#import "UIBarButtonItem+SSExtension.h"
#import "BaseButton.h"
#import "ZTAddOrSubAlertView.h"
#import "QueueTableViewCell.h"
#import "ZTAddOrSubAlertView.h"
#import "QueuepickView.h"
#import "QueueNumberInfoCell.h"
#import "QueueModel.h"
@interface QueueViewController ()<UITableViewDelegate,UITableViewDataSource,TimerPickerViewDelegate>
{
    dispatch_source_t wholeTimer;
    BOOL timerIsStop;
    BOOL cellTimeOver;
}
@property(nonatomic,strong)ButtonStyle * daitibtn;
@property (nonatomic,strong)UIView *  headView;
@property (nonatomic,strong)UIScrollView * chooseScrollV;
@property (nonatomic,strong)ButtonStyle * fbtn;
@property (nonatomic,strong)ButtonStyle * sbtn;

@property (nonatomic,strong)ButtonStyle * rightbtn;
@property (nonatomic,strong)UILabel * lineLabel;
@property (nonatomic,strong)ZTAddOrSubAlertView * queueStatusAlert;
@property (nonatomic,assign) NSInteger waitTime;
@property (nonatomic,strong) UILabel * stopTitleLabel;
@property (nonatomic,strong)ButtonStyle * closeBT;
/** 排队状态 **/
@property (nonatomic,assign) NSInteger queueStatus;
/** 排队按钮   (strong) **/
@property (nonatomic, strong) ButtonStyle *queueBT;
/** 正在叫号数据源数组   (strong) **/
@property (nonatomic, strong) NSMutableArray *firstDataArr;
/** 领号信息数据源  (NSString) **/
@property (nonatomic, copy) NSMutableArray *secondDataArr;
/** 排队信息表的父试图   (strong) **/
@property (nonatomic, strong) UIView *backView;
/** 正在叫号的tableV  (NSString) **/
@property (nonatomic, strong) UITableView *firstTableV;
/** 领号信息   (strong) **/
@property (nonatomic, strong) UITableView *secondTableV;
/** 处理flag＝＝－1  (NSString) **/
@property (nonatomic, copy) NSString *oldQueueStatus;
/** 占位   (strong) **/
@property (nonatomic, strong) UIImageView *placeImageV;

@end
@implementation QueueViewController

-(UIImageView *)placeImageV{
    if (!_placeImageV) {
        _placeImageV = [[UIImageView alloc] init];
        _placeImageV.image = [UIImage imageNamed:@"暂无数据"];
        _placeImageV.backgroundColor = [UIColor whiteColor];
        [_backView addSubview:_placeImageV];
        _placeImageV.sd_layout
        .centerXEqualToView(_backView)
        .topSpaceToView(_backView, 200)
        .widthIs(_placeImageV.image.size.width * 2)
        .heightIs(_placeImageV.image.size.width * 2);
    }
    return _placeImageV;
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [ReloadVIew registerReloadView:self];
    self.tabBarController.tabBar.hidden = YES;
    self.navigationController.navigationBar.barTintColor = UIColorFromRGB(0xfd7577);

    [self getQueueProceingSourceData:@"0"];
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [self createWholeView];
        timerIsStop = YES;
    });
    //    [self getQueueNumberInfoDataArr];
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];

    [self stopWholeTimer];
}
#pragma mark ---------------- 第一个接口 请求状态有 0 1 3 4 5 6 7 8 共8种状态 -----------------
#pragma mark ---------------- 第二个接口 排号作废 单独接口 --------------

#pragma mark ----------------0 1 7 8 传相同参数  3 4 传相同参数  5 6 领号信息参数

#pragma mark --------- 0 0 判断是否开启 1 开启排队状态 2确定到店,分配桌号 3 已到店 4 开始用餐  5 员工领号 6 打印领号 7 暂停 8 关闭排队（系统将不再烦好，已放出的排号过号后，可以关闭排号模式）

#pragma mark --------- 返回数据中，flag有三种状态 分别是 -1 失败 0 排队关闭 1 排队状态开启 2 排队暂停 ----

#pragma mark --------- 返回数据中，msgType有三种状态 分别是 0 成功 1 失败 2 排队暂停 -----------

#pragma mark --------- 返回数据中，每个表信息中，isArrive有三种状态， 1 领号  2 已到店 3 正在用餐（状态3：移动端不予处理）4 叫号作废 、 未到店  －－。

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor whiteColor];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(6 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        //主线程走
        dispatch_async(dispatch_get_main_queue(), ^{

            dispatch_queue_t firstQueue = dispatch_queue_create("firstQueue", DISPATCH_QUEUE_CONCURRENT);
            wholeTimer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, firstQueue);
            dispatch_source_set_timer(wholeTimer, DISPATCH_TIME_NOW, 5.0 * NSEC_PER_SEC, 0 * NSEC_PER_SEC);
            dispatch_source_set_event_handler(wholeTimer, ^{
                //正在叫号
                if (_chooseScrollV.contentOffset.x == 0) {
                    [self getQueueProceingSourceData:@"0"];
                }
                //领号信息
                if (_chooseScrollV.contentOffset.x == kScreenWidth ){
                    [self getQueueNumberInfoDataArr];
                }
            });
            [self runWholerTimer];
        });
    });
}
- (void)stopWholeTimer{
    if (wholeTimer && !timerIsStop) {
        dispatch_suspend(wholeTimer);
        timerIsStop = YES;
    }
}
- (void)runWholerTimer{
    if (wholeTimer && timerIsStop) {
        dispatch_resume(wholeTimer);
        timerIsStop = NO;
    }
}
#pragma mark  //进行中数据源加载
- (void)getQueueProceingSourceData:(NSString *)type{

    NSString *keyUrl = @"api/merchant/numberQueueManage";
    NSString *storeId = storeID;
    NSString *userId = _BaseModel.id;
    NSString *operation = type;//0 判断是否开启 1 开启排队状态 2确定到店,分配桌号 3 已到店 4 开始用餐  5 员工领号 6 打印领号 7 暂停 8 关闭排队（系统将不再烦好，已放出的排号过号后，可以关闭排号模式）

    NSString *loadUrl = [NSString stringWithFormat:@"%@%@?token=%@&storeId=%@&userId=%@&operation=%@", kBaseURL, keyUrl, TOKEN, storeId, userId, operation];
//    ZTLog(@"%@", type);
      
    [[QYXNetTool shareManager] postNetWithUrl:loadUrl urlBody:nil bodyStyle:QYXBodyString header:nil response:QYXJSON success:^(id result) {
//        if ([type isEqualToString:@"7"]) {
//            ZTLog(@"%@", result);
//        }
        if (_placeImageV) {
            [_placeImageV removeFromSuperview];
            _placeImageV = nil;
        }
        _queueStatus = [result[@"flag"] integerValue];
        NSInteger msgType = [result[@"msgType"] integerValue];
        if ((msgType == 0 || msgType == 3) && (_queueStatus ==1 ||_queueStatus == 2 ||_queueStatus == 0)) {
            _firstDataArr = [NSMutableArray array];
            id obj = result[@"obj"];
            if (obj && [obj isKindOfClass:[NSString class]]) {
                self.placeImageV.backgroundColor = [UIColor whiteColor];
                if (_queueStatus == 0) {
                    //不处理
                } else if (msgType == 3) {
//                    [SVProgressHUD showInfoWithStatus:@"已全部过号"];
                } else {
//                    [SVProgressHUD showInfoWithStatus:@"暂无数据"];
                }
            } else {
                if (_queueStatus == 0) {
                    [SVProgressHUD showInfoWithStatus:@"排队未开启"];
                }
                [result[@"obj"] enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    QueueModel *model = [QueueModel mj_objectWithKeyValues:obj];
                    [_firstDataArr addObject:model];
//                    ZTLog(@"%ld", model.timeGap);
                }];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self stopWholeTimer];
                    [_firstTableV reloadData];
                    [_firstTableV layoutIfNeeded];
                    [self runWholerTimer];
                });
            }
            if ([type isEqualToString:@"8"]) {
                [self stopWholeTimer];
            } else {
                [self runWholerTimer];
            }
        } else if ([result[@"msgType"] integerValue] == 1 && _queueStatus == -1){
            if (([type isEqualToString:@"0"] || [type isEqualToString:@"1"])) {
                _queueStatus = 0;
            } else if ([type isEqualToString:@"7"]) {
                _queueStatus = 1;
            } else if ([type isEqualToString:@"8"]) {
                _queueStatus = 2;
            }
            [SVProgressHUD showErrorWithStatus:@"参数错误"];
        } else  {
//            ZTLog(@"%@", result);
        };
            [self judgeQueueStatus:msgType];
    } failure:^(NSError *error) {

    }];
}
#pragma mark  //领号信息数据源
- (void)getQueueNumberInfoDataArr{

    NSString *keyUrl = @"api/merchant/numberQueueManage";
    NSString *storeId = storeID;
    NSString *userId = _BaseModel.id;
    NSString *operation = @"5";//0 判断是否开启 1 开启排队状态 2确定到店,分配桌号 3 已到店 4 开始用餐  5 员工领号 6 打印领号 7 暂停 8 关闭排队（系统将不再烦好，已放出的排号过号后，可以关闭排号模式）

    NSString *loadUrl = [NSString stringWithFormat:@"%@%@?token=%@&storeId=%@&userId=%@&operation=%@", kBaseURL, keyUrl, TOKEN, storeId, userId, operation];

      
    [[QYXNetTool shareManager] postNetWithUrl:loadUrl urlBody:nil bodyStyle:QYXBodyString header:nil response:QYXJSON success:^(id result) {
        NSInteger msgType = [result[@"msgType"] integerValue];
        id obj = result[@"obj"];
        if ([result[@"msgType"] integerValue] == 0) {
            if ([obj isNull] && [obj isKindOfClass:[NSString class]]) {
                //暂时不予处理
            } else {
                _queueStatus = [result[@"flag"] integerValue];

                if (_queueStatus == 0) {
                    [SVProgressHUD showInfoWithStatus:@"排队未开启"];
                }
                [self judgeQueueStatus:msgType];
                _secondDataArr = [NSMutableArray arrayWithArray:result[@"obj"]];
                [_secondTableV reloadData];
            }
        }
    } failure:^(NSError *error) {

    }];
}
#pragma mark  // 排号作废 单独接口
- (void)uploadAbandonedQueueWithCallNum:(NSString *)callNum boardType:(NSString *)queueType selectedIndexPath:(NSIndexPath *)indexPath{

    NSString *keyUrl = @"api/merchant/rowNumObsolete";
    NSString *storeId = storeID;
    NSString *userId = _BaseModel.id;
    NSString *queueNum = callNum;
    NSString *boardType = queueType;

    NSString *loadUrl = [NSString stringWithFormat:@"%@%@?token=%@&storeId=%@&userId=%@&queueNum=%@&boardType=%@", kBaseURL, keyUrl, TOKEN, storeId, userId, queueNum, boardType];
      
    [[QYXNetTool shareManager] postNetWithUrl:loadUrl urlBody:nil bodyStyle:QYXBodyString header:nil response:QYXJSON success:^(id result) {
        if ([result[@"msgType"] integerValue] == 0) {
            //排号作废
            [_firstDataArr removeObjectAtIndex:indexPath.row];
            [_firstTableV deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
            [_firstTableV reloadData];
        } else {
            //操作无效

        }

    } failure:^(NSError *error) {

    }];
}
#pragma mark  //修改倒计时时限
- (void)uploadQueueMaxTimerWaitTime:(NSString *)limitTimerNum{

    NSString *keyUrl = @"api/merchant/editRowNum";
    NSString *waitTime = limitTimerNum;
    NSString *storeId = storeID;
    NSString *userId = _BaseModel.id;

    NSString *loadUrl = [NSString stringWithFormat:@"%@%@?token=%@&storeId=%@&userId=%@&waitTime=%@", kBaseURL, keyUrl, TOKEN, storeId, userId, waitTime];
      
    [[QYXNetTool shareManager] postNetWithUrl:loadUrl urlBody:nil bodyStyle:QYXBodyString header:nil response:QYXJSON success:^(id result) {
        if ([result[@"msgType"] integerValue] == 0) {
            //设置等待时间
            [SVProgressHUD showSuccessWithStatus:@"设置成功"];
            [self getQueueProceingSourceData:@"0"];
        } else {
            //操作无效
            [SVProgressHUD showErrorWithStatus:@"设置失败"];
        }

    } failure:^(NSError *error) {
        
        
    }];

}
- (void)createWholeView{
    //设置导航栏

    self.titleView.text = @"排队领号";


    self.view.backgroundColor = RGB(242, 242, 242);
    
    _rightbtn = [ButtonStyle buttonWithType:UIButtonTypeCustom];
    UIBarButtonItem * moreBT = [UIBarButtonItem itemWithTarget:self Action:@selector(setWaitTime) image:@"白色设置" selectImage:nil];
    self.navigationItem.rightBarButtonItem = moreBT;

    //设置排队模式的透视图
    _headView = [[UIView alloc]init];
    _headView.backgroundColor = RGB(233, 141, 141);
    [self.view addSubview:_headView];

    _headView.sd_layout
    .leftEqualToView(self.view)
    .rightEqualToView(self.view)
    .topSpaceToView(self.view,64)
    .heightIs(autoScaleH(40));

//    NSString * queueStasus = [NSString stringWithFormat:@"%ld", _queueStatus];//[[NSUserDefaults standardUserDefaults]objectForKey:@"queue"];
//    NSLog(@"nsuser=%@",queueStasus);

    _queueBT = [ButtonStyle buttonWithType:UIButtonTypeCustom];
    [_queueBT addTarget:self action:@selector(queueStatusClick:) forControlEvents:UIControlEventTouchUpInside];
    [_headView addSubview:_queueBT];
    _queueBT.sd_layout
    .leftSpaceToView(_headView,autoScaleW(15))
    .topSpaceToView(_headView,autoScaleH(5))
    .heightIs(autoScaleH(30))
    .widthIs(autoScaleW(30));

    _closeBT = [ButtonStyle buttonWithType:UIButtonTypeCustom];
    [_closeBT setImage:[UIImage imageNamed:@"暂停黑"] forState:UIControlStateNormal];
    [_closeBT addTarget:self action:@selector(queueStatusCloseClick:) forControlEvents:UIControlEventTouchUpInside];
    [_headView addSubview:_closeBT];
    _closeBT.sd_layout
    .leftSpaceToView(_queueBT,autoScaleW(10))
    .topEqualToView(_queueBT)
    .widthIs(autoScaleW(30))
    .heightIs(autoScaleH(30));
    _closeBT.hidden = YES;

    _stopTitleLabel = [[UILabel alloc] init];    _stopTitleLabel.font = [UIFont systemFontOfSize:autoScaleW(13)];
    _stopTitleLabel.textColor = [UIColor whiteColor];
    [_headView addSubview:_stopTitleLabel];

    [self judgeQueueStatus:0];
    [self changeFrameOfQueueStatus];


    [self createQueueStatusOpenView];

}
- (void)changeFrameOfQueueStatus{
    if (_queueStatus == 0 || _queueStatus == 1) {
        _closeBT.hidden = YES;
        _stopTitleLabel.sd_layout
        .leftSpaceToView(_queueBT,autoScaleW(10))
        .topSpaceToView(_headView,autoScaleH(12))
        .heightIs(autoScaleH(15));
        [_stopTitleLabel setSingleLineAutoResizeWithMaxWidth:200];
    } else {
        _closeBT.hidden = NO;
        _stopTitleLabel.sd_layout
        .leftSpaceToView(_closeBT,autoScaleW(10))
        .topSpaceToView(_headView,autoScaleH(12))
        .heightIs(autoScaleH(15));
        [_stopTitleLabel setSingleLineAutoResizeWithMaxWidth:200];
    }
}
- (void)judgeQueueStatus:(NSInteger )msgType{
    if (_queueStatus== 0) {
        [_queueBT setImage:[UIImage imageNamed:@"排队开"] forState:UIControlStateNormal];
        //        _queueStatus = 0;
        _stopTitleLabel.text = @"点击左边按钮开启排号模式";
    } else if (_queueStatus == 1) {
        [_queueBT setImage:[UIImage imageNamed:@"组"] forState:UIControlStateNormal];
        //        _queueStatus = 1;
        _stopTitleLabel.text = @"排队进行中，点击暂停放号";
    } else if (_queueStatus == 2) {
        [_queueBT setImage:[UIImage imageNamed:@"开始"] forState:UIControlStateNormal];
        _stopTitleLabel.text = @"已暂停放号，点击继续放号";
        if (msgType == 3) {
            _closeBT.userInteractionEnabled = YES;
            [_closeBT setImage:[UIImage imageNamed:@"暂停开"] forState:UIControlStateNormal];
        } else {
            _closeBT.userInteractionEnabled = NO;
            [_closeBT setImage:[UIImage imageNamed:@"暂停黑"] forState:UIControlStateNormal];
        }
    } else ;
    [self changeFrameOfQueueStatus];
}
#pragma mark 排队按钮
-(void)queueStatusClick:(ButtonStyle * )btn
{
    __weak __typeof (self)weakSelf = self;
    weakSelf.queueStatusAlert = [[ZTAddOrSubAlertView alloc]initWithStyle:ZTalertSheetStyleSubTitle];
    [weakSelf.queueStatusAlert.confirmBT setTitleColor:UIColorFromRGB(0xfd7577) forState:UIControlStateNormal];
    switch (_queueStatus) {
        case 0:
        {
            weakSelf.queueStatusAlert.titleLabel.text = @"是否开启排队模式";
            weakSelf.queueStatusAlert.littleLabel.text = @"开启后，餐厅将自动进入繁忙状态，客人需领号才能扫码用餐";
            [weakSelf.queueStatusAlert showView];

            weakSelf.queueStatusAlert.complete = ^(BOOL choose)
            {
                if (choose==YES) {
                    [weakSelf.queueStatusAlert removeFromSuperview];
                    [btn setImage:[UIImage imageNamed:@"组"] forState:UIControlStateNormal];
                    weakSelf.stopTitleLabel.text = @"排队进行中，点击暂停放号";
                    weakSelf.queueStatus= 1;
                    [self getQueueProceingSourceData:@"1"];
                }
            };

        }
            break;

        case 1:
        {
            weakSelf.queueStatusAlert.titleLabel.text = @"是否暂停放号？";
            weakSelf.queueStatusAlert.littleLabel.text = @"系统将不再放号，已放出的排号过号后，可以关闭排号模式。";

            [_queueStatusAlert showView];

            weakSelf.queueStatusAlert.complete = ^(BOOL choose)
            {
                if (choose==YES) {

                    [weakSelf.queueStatusAlert removeFromSuperview];
                    [btn setImage:[UIImage imageNamed:@"开始"] forState:UIControlStateNormal];
                    weakSelf.stopTitleLabel.text = @"已暂停放号，点击继续放号";
                    weakSelf.queueStatus= 2;
                    _closeBT.hidden = NO;
                    [self getQueueProceingSourceData:@"7"];
                }
            };
        }
            break;
        case 2:
        {
            weakSelf.queueStatusAlert.titleLabel.text = @"继续放号？";
            weakSelf.queueStatusAlert.littleLabel.text = @"系统将继续放出号牌";

            [_queueStatusAlert showView];

            weakSelf.queueStatusAlert.complete = ^(BOOL choose)
            {
                if (choose==YES) {
                    [weakSelf.queueStatusAlert removeFromSuperview];
                    [btn setImage:[UIImage imageNamed:@"组"] forState:UIControlStateNormal];
                    weakSelf.stopTitleLabel.text = @"排队进行中，点击暂停放号";
                    weakSelf.queueStatus= 1;
                    _closeBT.hidden= YES;

                    [self getQueueProceingSourceData:@"1"];
                }

            };
        }
            break;

        default:
            break;
    }
}
#pragma mark 结束按钮
-(void)queueStatusCloseClick:(ButtonStyle *)sender{
    __weak __typeof (self)weakSelf = self;
    _queueStatusAlert = [[ZTAddOrSubAlertView alloc]initWithStyle:ZTalertSheetStyleSubTitle];
    _queueStatusAlert.titleLabel.text = @"是否停止发号";
    _queueStatusAlert.littleLabel.text = @"系统将不再放号，已经放出的排号过号后，排队模式将自动关闭";

    [_queueStatusAlert showView];

    _queueStatusAlert.complete = ^(BOOL choose) {
        if (choose==YES) {
            [weakSelf getQueueProceingSourceData:@"8"];
        }
    };
}
- (void)createQueueStatusOpenView{
    //当排队状态开启后，展示 正在叫号 喝 领号信息 界面
    _backView = [[UIView alloc] init];
    _backView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_backView];

    _backView.sd_layout
    .leftEqualToView(self.view)
    .topSpaceToView(_headView, 0)
    .rightEqualToView(self.view)
    .bottomEqualToView(self.view);
    NSArray * chooseArr = @[@"正在叫号",@"领号信息"];
    UIView *selectView = [[UIView alloc] init];
    selectView.backgroundColor = [UIColor whiteColor];
    [_backView addSubview:selectView];

    selectView.sd_layout
    .leftEqualToView(_backView)
    .rightEqualToView(_backView)
    .topEqualToView(_backView)
    .heightIs(autoScaleH(30));
    for (int i=0; i<2; i++) {
        ButtonStyle * chooseBT = [[ButtonStyle alloc]init];
        chooseBT.titleLabel.font = [UIFont systemFontOfSize:autoScaleW(13)];
        [chooseBT setTitle:chooseArr[i] forState:UIControlStateNormal];
        [chooseBT setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        [chooseBT setTitleColor:UIColorFromRGB(0xfd7577) forState:UIControlStateSelected];
        [chooseBT setBackgroundColor:[UIColor clearColor]];
        chooseBT.tag = 300+i;
        [chooseBT addTarget:self action:@selector(Choose:) forControlEvents:UIControlEventTouchUpInside];
        [selectView addSubview:chooseBT];
        chooseBT.sd_layout
        .leftSpaceToView(selectView,i*(kScreenWidth/2))
        .centerYEqualToView(selectView)
        .widthIs(kScreenWidth/2)
        .heightIs(autoScaleH(35));

        UILabel * lineLabel = [[UILabel alloc]init];
        lineLabel.backgroundColor = UIColorFromRGB(0xeeeeee);
        [chooseBT addSubview:lineLabel];
        lineLabel.sd_layout
        .leftSpaceToView(chooseBT,0)
        .bottomEqualToView(chooseBT)
        .widthIs(kScreenWidth/2)
        .heightIs(1);

        if (i==0||i==1) {

            UILabel * lineLabel = [[UILabel alloc]init];
            lineLabel.backgroundColor = UIColorFromRGB(0xeeeeee);
            [chooseBT addSubview:lineLabel];

            lineLabel.sd_layout
            .rightSpaceToView(chooseBT,0)
            .topSpaceToView(chooseBT,autoScaleH(2))
            .widthIs(1)
            .heightIs(26);
        }
        if (i==0) {
            chooseBT.selected = YES;
            _daitibtn = chooseBT;
        }
    }

    _lineLabel = [[UILabel alloc]init];
    _lineLabel.backgroundColor = UIColorFromRGB(0xfd7577);
    [selectView addSubview:_lineLabel];
    _lineLabel.sd_layout
    .centerXIs(self.view.center.x / 2)
    .bottomEqualToView(selectView)
    .widthIs(70)
    .heightIs(1.5);


    UIView *componmentView = [[UIView alloc] init];
    componmentView.backgroundColor = RGB(238, 238, 238);
    [_backView addSubview:componmentView];

    componmentView.sd_layout
    .leftEqualToView(_backView)
    .rightEqualToView(_backView)
    .topSpaceToView(selectView, 0)
    .heightIs(autoScaleH(25));
    NSArray * choosetitle = @[@"号码",@"倒计时",@"操作",];
    for (int i=0; i<3; i++) {
        ButtonStyle * choosebtn = [ButtonStyle buttonWithType:UIButtonTypeCustom];
        choosebtn.titleLabel.font = [UIFont systemFontOfSize:autoScaleW(13)];
        [choosebtn setTitle:choosetitle[i] forState:UIControlStateNormal];
        [choosebtn setTitleColor:UIColorFromRGB(0xfd7577) forState:UIControlStateNormal];
        choosebtn.backgroundColor = RGB(238, 238, 238);
        choosebtn.userInteractionEnabled = NO;
        if (i==0) {
            _fbtn = choosebtn;
        }
        if (i==1) {
            _sbtn = choosebtn;
        }
        [componmentView addSubview:choosebtn];
        choosebtn.sd_layout
        .leftSpaceToView(componmentView,i*(kScreenWidth/3))
        .topSpaceToView(componmentView,0)
        .widthIs(kScreenWidth/3-1)
        .heightIs(autoScaleH(25));
    }



    _chooseScrollV = [[UIScrollView alloc]init];
    //    _chooseScrollV.scrollEnabled = YES;
    _chooseScrollV.showsVerticalScrollIndicator = NO;
    _chooseScrollV.pagingEnabled = YES;
    _chooseScrollV.bounces = NO;
    _chooseScrollV.scrollsToTop = NO;
    _chooseScrollV.scrollEnabled = NO;
    _chooseScrollV.contentSize = CGSizeMake(kScreenWidth*2, 0);
    _chooseScrollV.backgroundColor = [UIColor whiteColor];
    [_backView addSubview:_chooseScrollV];

    _chooseScrollV.sd_layout
    .leftSpaceToView(_backView,0)
    .topSpaceToView(componmentView, 0)
    .bottomEqualToView(_backView)
    .widthIs(kScreenWidth * 2);

    _firstTableV = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
    _firstTableV.delegate = self;
    _firstTableV.dataSource = self;
    _firstTableV.multipleTouchEnabled = NO;
    _firstTableV.separatorStyle = UITableViewCellSeparatorStyleNone;
    _firstTableV.backgroundColor = [UIColor whiteColor];
    [_chooseScrollV addSubview:_firstTableV];
    [_firstTableV registerClass:[QueueTableViewCell class] forCellReuseIdentifier:@"123"];
    _firstTableV.sd_layout
    .leftEqualToView(_chooseScrollV)
    .topEqualToView(_chooseScrollV)
    .bottomEqualToView(_chooseScrollV)
    .widthIs(kScreenWidth);

    _secondTableV = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
    _secondTableV.delegate = self;
    _secondTableV.dataSource = self;
    _secondTableV.separatorStyle = UITableViewCellSeparatorStyleNone;
    _secondTableV.backgroundColor = [UIColor whiteColor];
    [_chooseScrollV addSubview:_secondTableV];

    _secondTableV.sd_layout
    .rightEqualToView(_chooseScrollV)
    .topEqualToView(_chooseScrollV)
    .bottomEqualToView(_chooseScrollV)
    .widthIs(kScreenWidth);

}
#pragma mark 表的数据源方法
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == _firstTableV) {
        return _firstDataArr.count;
    } else {
        return _secondDataArr.count;
    }

}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == _firstTableV) {
        NSString *str = @"123";//[NSString stringWithFormat:@"queueCell%ld", indexPath.row];
        QueueTableViewCell * firstCell = [_firstTableV dequeueReusableCellWithIdentifier:str forIndexPath:indexPath];
        //        if (!firstCell) {
        //            firstCell = [[QueueTableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:str];
        //        }
        firstCell.index = indexPath.row;
        firstCell.model = _firstDataArr[indexPath.row];
        //已到店点击回调
        firstCell.sureClickIsArrivedBlock = ^(BOOL complete){
            if (complete) {
                [self getQueueProceingSourceData:@"0"];
            }
        };
        //时间倒计时完毕回调
        firstCell.timeOverOrAbandonedBlock = ^(BOOL timerOver){
            if (timerOver) {
//                ZTLog(@"%ld",  indexPath.row);
                cellTimeOver = YES;
                [self tableView:_firstTableV didSelectRowAtIndexPath:indexPath];
            }
        };



        return firstCell;
    } else {

        NSString *str = [NSString stringWithFormat:@"queueSecCell%ld", (long)indexPath.row];
        QueueNumberInfoCell *secCell = [_secondTableV dequeueReusableCellWithIdentifier:str];
        if (!secCell) {
            secCell = [[QueueNumberInfoCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:str];
        }
        secCell.infoDic = _secondDataArr[indexPath.row];
        secCell.manualWorkSuccess = ^(BOOL success){
            if (success) {
                [self runWholerTimer];
                [self getQueueNumberInfoDataArr];
            } else {
                [self stopWholeTimer];
            }
        };
        return secCell;
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self stopWholeTimer];
    if (tableView == _firstTableV) {
        QueueModel *model = _firstDataArr[indexPath.row];
        NSInteger cellStatus = [model.isArrive integerValue];
        QueueTableViewCell *firstCell = [_firstTableV cellForRowAtIndexPath:indexPath];
        //已到店状态， 并且点击了cell的回调
        firstCell.startEatingBlock = ^(BOOL success){
            if (success) {
                if (cellStatus == 2) {
                    [UIView animateWithDuration:2.0 animations:^{
                        [_firstDataArr removeObjectAtIndex:indexPath.row];
                        [_firstTableV deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationMiddle];
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [_firstTableV reloadData];
                            [_firstTableV layoutIfNeeded];
                        });
                    } completion:^(BOOL finished) {
                        [self runWholerTimer];
                    }];
                }
            }
        };
        //倒计时结束
        if (cellStatus == 1 && cellTimeOver) {
            [UIView animateWithDuration:1.0 animations:^{
                [_firstDataArr removeObjectAtIndex:indexPath.row];
                [_firstTableV deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationMiddle];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [_firstTableV reloadData];
                    [_firstTableV layoutIfNeeded];
                });
//                ZTLog(@"__+_++_+_+%ld", indexPath.row);
            } completion:^(BOOL finished) {
                if (finished) {
                    [self runWholerTimer];
                    cellTimeOver = NO;
                }
            }];
        }

    } else {

    }

}
-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == _firstTableV) {
        return YES;
    } else {
        return NO;
    }
}
- (UITableViewCellEditingStyle )tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == _firstTableV) {
        return UITableViewCellEditingStyleDelete;
    } else {
        return UITableViewCellEditingStyleNone;
    }
}
-(void)tableView:(UITableView *)tableView willBeginEditingRowAtIndexPath:(NSIndexPath *)indexPath{
    [self stopWholeTimer];
}
- (void)tableView:(UITableView *)tableView didEndEditingRowAtIndexPath:(NSIndexPath *)indexPath{
    [self runWholerTimer];
}
- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath{
    return @"排号作废";
}
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == _firstTableV) {
        if (editingStyle == UITableViewCellEditingStyleDelete) {
            QueueTableViewCell *firstCell = [_firstTableV cellForRowAtIndexPath:indexPath];
            QueueModel *model = firstCell.model;
            [self uploadAbandonedQueueWithCallNum:model.queueNum boardType:model.boardType selectedIndexPath:indexPath];
        }
    } else {

    }
}
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    [self stopWholeTimer];
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    [self runWholerTimer];
}
#pragma mark 设置
-(void)setWaitTime
{
    QueuepickView * queueview = [[QueuepickView alloc]init];
    queueview.delegate = self;
    [queueview showTime];
}
-(void)ZTselectTimesViewSetOneLeft:(NSString *)oneLeft
{

    NSString * waitTime = [oneLeft substringToIndex:oneLeft.length - 1];
    [self uploadQueueMaxTimerWaitTime:waitTime];
}

-(void)Choose:(ButtonStyle * )btn
{
    _daitibtn.selected = NO;
    btn.selected = YES;
    _daitibtn = btn;
    [UIView animateWithDuration:.35 animations:^{
        _lineLabel.center = CGPointMake(btn.center.x, _lineLabel.center.y);
    }];
    if (btn.tag==301) {
        _chooseScrollV.contentOffset = CGPointMake(kScreenWidth, 0);
        [_fbtn setTitle:@"桌型" forState:UIControlStateNormal];
        [_sbtn setTitle:@"最新领号" forState:UIControlStateNormal];
        [self getQueueNumberInfoDataArr];
    }
    if (btn.tag==300) {
        _chooseScrollV.contentOffset = CGPointMake(0, 0);
        [_fbtn setTitle:@"号码" forState:UIControlStateNormal];
        [_sbtn setTitle:@"倒计时" forState:UIControlStateNormal];
    }

}
-(void)leftBarButtonItemAction
{
    
    [self.navigationController popViewControllerAnimated:YES];
    
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
