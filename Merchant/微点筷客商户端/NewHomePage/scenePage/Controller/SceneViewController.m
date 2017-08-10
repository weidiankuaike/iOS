//
//  SceneViewController.m
//  微点筷客商户端
//
//  Created by 张森森 on 16/10/13.
//  Copyright © 2016年 张森森. All rights reserved.
//

#import "SceneViewController.h"
#import "UIBarButtonItem+SSExtension.h"
#import "ServeTableViewCell.h"
#import "ServetimeViewController.h"
#import "AssignViewController.h"
#import "SceneScanVC.h"
#import "ZTAddOrSubAlertView.h"
#import "SceneInfoModel.h"
#import "UINavigationController+FDFullscreenPopGesture.h"
#import <AudioToolbox/AudioToolbox.h>
@interface SceneViewController ()<UITableViewDelegate,UITableViewDataSource>

{
    UIImageView * headimage;
    NSInteger tabinteger;
    UILabel * servelabel;
    NSArray *firstArr;
    BOOL isserve ;
    BOOL oldStatus;
    dispatch_source_t _netTimer;
}
/** 展位图   (strong) **/
@property (nonatomic, strong) UIImageView *placeHolderView;
/** 功能开启View   (strong) **/
@property (nonatomic, strong) UIView *wholeView;
/** <#行注释#>   (strong) **/
@property (nonatomic, strong) UITableView *tableV;
/** <#行注释#>   (strong) **/
@property (nonatomic, strong) NSMutableArray *dataArr;
/** 定时器状态   (NSInteger) **/
@property (nonatomic, assign) NSInteger updateStatus;
/** 请求全部数据还是五条数据  (NSString) **/
@property (nonatomic, copy) NSString *topName;
@end

@implementation SceneViewController
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [ReloadVIew registerReloadView:self];

    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _topName = @"0";
    });
    self.navigationController.navigationBar.hidden = NO;
    self.tabBarController.tabBar.hidden = NO;

    [self searchSceneOpenStatus];

}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.titleView.text = @"现场管理";
    _updateStatus = YES;
    [self runNetTimer];
    //    UIBarButtonItem * shezhibtn = [UIBarButtonItem itemWithTarget:self Action:@selector(Shezhi) andTitle:@" 翻台" image:@"scan_white" selectImage:nil];
    //    [shezhibtn setTintColor:[UIColor whiteColor]];
    //    self.navigationItem.rightBarButtonItem = shezhibtn;

    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    delegate.notificationUserInfoBlock = ^(NSDictionary *userInfo){//收到新订单走这里
        ZTLog(@"%@", userInfo);
        NSString *classId = userInfo[@"map"][@"classId"];
        if ([classId isEqualToString:@"m4"] && _updateStatus == NO) {
            _updateStatus = YES;
//            [self runNetTimer];
        }
    };
}
- (void)runNetTimer{
    if (_netTimer == nil) {
        dispatch_queue_t queue = dispatch_queue_create("sceneGetdataQueue", 0);
        _netTimer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    }
    dispatch_source_set_timer(_netTimer, DISPATCH_TIME_NOW, 5.0 * NSEC_PER_SEC, 0 * NSEC_PER_SEC);
    dispatch_source_set_event_handler(_netTimer, ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            if (_updateStatus) {
                if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"token"] isEqualToString:@"error"]) {
                    //推出登录,移除定时器
                    _updateStatus = NO;
                    return ;
                }
                [self getSceneDataSource:_topName];
            } else {
                //不刷新界面
            }
        });
    });
    if (_netTimer && _updateStatus == YES) {
        dispatch_resume(_netTimer);
    }

}
-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:YES];
    //    _updateStatus = NO;

}
-(void)judgeBaseViewControllerStatus:(BOOL)isOut{
    [super judgeBaseViewControllerStatus:isOut];
    if (!isOut) {
        [self searchSceneOpenStatus];
    }
}
-(UIView *)wholeView{
    if (!_wholeView) {
        _wholeView = [[UIView alloc] init];
        _wholeView.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:_wholeView];
        _wholeView.frame = self.view.frame;
        [self createWholeView];
        [self CreatTable];
    }
    return _wholeView;
}
-(UIImageView *)placeHolderView{
    if (!_placeHolderView) {
        _placeHolderView = [[UIImageView alloc] init];
        _placeHolderView.image = [UIImage imageNamed:@"暂无数据"];
        _placeHolderView.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:_placeHolderView];
        _placeHolderView.sd_layout
        .centerXEqualToView(self.view)
        .centerYEqualToView(self.view)
        .widthIs(_placeHolderView.image.size.width * 2)
        .heightIs(_placeHolderView.image.size.height * 2);

    }
    return _placeHolderView;
}

#pragma mark --- 查询功能是否开启 －－－
- (void)searchSceneOpenStatus{

    LoginInfoModel *_model = _BaseModel;
    NSString *isBoss = _model.isBoss;
    NSString *userId = _model.id;
    NSString *keyUrl = @"api/merchant/searchFeatures";
    NSString *flag = @"is_service";
    NSString *loadUrl = [NSString stringWithFormat:@"%@%@?token=%@&storeId=%@&flag=%@&isBoss=%@&userId=%@", kBaseURL, keyUrl, TOKEN, storeID, flag, isBoss, userId];
      
    [[QYXNetTool shareManager] postNetWithUrl:loadUrl urlBody:nil bodyStyle:QYXBodyString header:nil response:QYXJSON success:^(id result) {
        if ([result[@"msgType"] integerValue] == 0) {
            //权限/功能 判断 0 没有 1有
            BOOL newStatus = [result[@"obj"][@"is_service"] integerValue] == 0 ? NO : YES;
            BOOL newLimitStatus = [result[@"obj"][@"isServiceManage"] integerValue] == 0 ? NO : YES;

            if (newStatus && newLimitStatus) {
                isserve = YES;
                if (oldStatus == newStatus) {
                    //不创建视图
                } else {
                    //删除旧视图，创建新视图
                    self.wholeView.backgroundColor = [UIColor whiteColor];
                    [self getSceneDataSource:_topName];
                }
            } else {
                self.placeHolderView.backgroundColor = [UIColor whiteColor];
            }
            oldStatus = newStatus;
            [self jugeDataModelArrIsNull];
        }
    } failure:^(NSError *error) {

    }];
}

#pragma mark ---------------- 获取现场数据源 -------------------
- (void)getSceneDataSource:(NSString *)topName{

    NSString *keyUrl = @"api/fieldService/getService";

    NSString *loadUrl = [NSString stringWithFormat:@"%@%@?token=%@&storeId=%@&topName=%@", kBaseURL, keyUrl, TOKEN, storeID, topName];

      
    [[QYXNetTool shareManager] postNetWithUrl:loadUrl urlBody:nil bodyStyle:QYXBodyString header:nil response:QYXJSON success:^(id result) {
        if ([result[@"msgType"] integerValue] == 0) {
            id obj = result[@"obj"];
            _dataArr = [NSMutableArray array];
            if (![obj isNull] && ![obj isKindOfClass:[NSString class]]) {

                //                    if (_placeHolderView) {
                //                        [_placeHolderView removeFromSuperview];
                //                        _placeHolderView = nil;
                //                    }
                //                    self.wholeView.hidden = NO;
                [result[@"obj"] enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    SceneInfoModel *model = [SceneInfoModel mj_objectWithKeyValues:obj];
                    if ([obj[@"isSeviceRmd"] integerValue] == 1) {
                        if ([model.timeGap integerValue] > 53) {
                            [self playSound];
                        }
                    }
                    if (idx == 0) {
                        firstArr = @[model];
                        servelabel.text = [NSString stringWithFormat:@"%@号桌呼叫%@",model.boardNum,model.service];
                        NSArray *iconArr = @[@"后厨",@"呼叫",@"加水",@"其他",@"清理",@"上菜",@"纸巾"];
                        NSArray *arr = @[model.boardNum,model.service,@"应答"];
                        if ([iconArr containsObject:model.service]) {
                            headimage.image = [UIImage imageNamed:model.service];
                        } else {
                            headimage.image = [UIImage imageNamed:@"其他"];
                        }

                        for (NSInteger i = 0; i< 3; i++) {
                            ButtonStyle *button = [self.view viewWithTag:200 + i];
                            [button setTitle:arr[i] forState:UIControlStateNormal];
                            if (i == 2) {
                                [button setUserInteractionEnabled:YES];
                            }
                        }
                    } else {
                        [_dataArr addObject:model];
                    }
                }];
            } else {
                //删除旧视图，创建新视图
                firstArr = @[];
                _updateStatus = NO;
            }
            [self jugeDataModelArrIsNull];
        }
    } failure:^(NSError *error) {
        _updateStatus = NO;
        dispatch_suspend(_netTimer);
    }];
}
- (void)jugeDataModelArrIsNull{
    dispatch_async(dispatch_get_main_queue(), ^{
        if (_dataArr.count == 0) {
            if (firstArr.count == 1) {
                self.view.backgroundColor = RGB(242, 242, 242);
                self.wholeView.hidden = NO;
                _placeHolderView.hidden = YES;
            } else {
                self.placeHolderView.hidden = NO;
                self.view.backgroundColor = [UIColor whiteColor];
                _wholeView.hidden = YES;
            }
        } else {
            self.view.backgroundColor = RGB(242, 242, 242);
            self.wholeView.hidden = NO;
            _placeHolderView.hidden = YES;
            
        }
        [_tableV reloadData];
    });
}
#pragma mark ---------------- 点击应答后的接口 -------------------
- (void)uploadResponseServiceToService:(SceneInfoModel *)model{
    NSString *keyUrl = @"api/fieldService/updateService";
    if ([model isKindOfClass:([ButtonStyle class])]) {
        model = firstArr[0];
    } else {

    }
    NSString *serverId = model.id;
    NSString *uplaodUrl = [NSString stringWithFormat:@"%@%@?token=%@&storeId=%@&serverId=%@", kBaseURL, keyUrl, TOKEN, storeID, serverId];
    //    __block SceneInfoModel *tempModel = model;
    [[QYXNetTool shareManager] postNetWithUrl:uplaodUrl urlBody:nil bodyStyle:QYXBodyString header:nil response:QYXJSON success:^(id result) {
        if ([result[@"msgType"] integerValue] == 0) {
            ServetimeViewController * servetimeview =[[ServetimeViewController alloc]init];
            servetimeview.model = model;
            [self.navigationController pushViewController:servetimeview animated:YES];
            [self getSceneDataSource:_topName];
        }
    } failure:^(NSError *error) {

    }];

}
- (void)createWholeView{

    _wholeView.backgroundColor = UIColorFromRGB(0xffffff);



    CGFloat height = [[UIApplication sharedApplication] statusBarFrame].size.height + self.navigationController.navigationBar.frame.size.height;

    headimage = [[UIImageView alloc]init];
    if (isserve==YES) {
        headimage.image = [UIImage imageNamed:@"纸巾"];
    } else {
        headimage.image = [UIImage imageNamed:@"暂无订单"];

    }
    [_wholeView addSubview:headimage];
    headimage.sd_layout.leftSpaceToView(_wholeView,autoScaleW(54)).topSpaceToView(_wholeView,autoScaleH(43)+height).widthIs(autoScaleW(68)).heightIs(autoScaleH(68));

    servelabel = [[UILabel alloc]init];
    if (isserve==YES) {
        servelabel.text = [NSString stringWithFormat:@"%d号桌呼叫%@",5,@"清理"];
    } else {
        servelabel.text = @"暂无呼叫服务";
    }
    servelabel.font = [UIFont systemFontOfSize:autoScaleW(20)];
    servelabel.textColor = RGB(171, 171, 171);
    [_wholeView addSubview:servelabel];
    servelabel.sd_layout.rightSpaceToView(_wholeView,autoScaleW(58)).topSpaceToView(_wholeView,autoScaleH(54)+height).widthIs(autoScaleW(150)).heightIs(autoScaleH(22));

    UILabel * tservelabel = [[UILabel alloc]init];
    if (isserve==YES) {
        tservelabel.text = @"等待应答...";
    } else {
        tservelabel.text = @"等待呼叫...";
    }
    tservelabel.textAlignment =NSTextAlignmentCenter;
    tservelabel.font = [UIFont systemFontOfSize:autoScaleW(11)];
    if (isserve==YES) {
        tservelabel.textColor = UIColorFromRGB(0xfd7577);
    } else {
        tservelabel.textColor = RGB(171, 171, 171);
    }
    [_wholeView addSubview:tservelabel];
    tservelabel.sd_layout.rightSpaceToView(_wholeView,autoScaleW(58)).topSpaceToView(servelabel,autoScaleH(12)).widthIs(autoScaleW(150)).heightIs(autoScaleH(15));

    for (int i=0; i<2; i++) {

        UILabel * linlabel = [[UILabel alloc]init];
        linlabel.backgroundColor = RGB(171, 171, 171);
        [_wholeView addSubview:linlabel];
        linlabel.sd_layout.leftSpaceToView(_wholeView,autoScaleW(32)+i*autoScaleW(198)).topSpaceToView(headimage,autoScaleH(58)).widthIs(autoScaleW(115)).heightIs(autoScaleH(1));

    }
    NSArray * serary = @[@"5号",@"清理",@"应答",];
    for (int i=0; i<3; i++) {

        ButtonStyle * servebtn = [ButtonStyle buttonWithType:UIButtonTypeCustom];
        if (isserve==YES) {
            [servebtn setTitle:serary[i] forState:UIControlStateNormal];
        } else {
            [servebtn setTitle:@"暂无" forState:UIControlStateNormal];
            [servebtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
            servebtn.userInteractionEnabled = NO;
        }
        [servebtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];

        if (i==0||i==1) {

            servebtn.userInteractionEnabled = NO;
            UILabel * sulabel = [[UILabel alloc]init];
            sulabel.backgroundColor = RGB(171, 171, 171);
            [servebtn addSubview:sulabel];
            sulabel.sd_layout.rightEqualToView(servebtn).topEqualToView(servebtn).heightIs(autoScaleH(50)).widthIs(autoScaleW(1));

        } else {
            servebtn.backgroundColor = RGB(242, 242, 242);
            [servebtn setTitleColor:UIColorFromRGB(0xfd7577) forState:UIControlStateNormal];

        }
        servebtn.tag = 200 +i;
        if (i == 2) {
            [servebtn addTarget:self action:@selector(uploadResponseServiceToService:) forControlEvents:UIControlEventTouchUpInside];
        }
        [_wholeView addSubview:servebtn];
        servebtn.sd_layout.leftSpaceToView(_wholeView,autoScaleW(32)+i*((kScreenWidth-autoScaleW(64))/3)).topSpaceToView(headimage,autoScaleH(59)).widthIs((kScreenWidth-autoScaleW(64))/3).heightIs(autoScaleH(50));
    }

    UILabel * titlelabel = [[UILabel alloc]init];
    titlelabel.text = @"服务列表";
    titlelabel.textAlignment = NSTextAlignmentCenter;
    titlelabel.font = [UIFont systemFontOfSize:autoScaleW(17)];
    if (isserve==YES) {
        titlelabel.textColor = RGB(171, 171, 171);
    } else {
        titlelabel.textColor  = UIColorFromRGB(0xfd7577);
    }
    [_wholeView addSubview:titlelabel];
    titlelabel.sd_layout.topSpaceToView(headimage,autoScaleH(51)).centerXEqualToView(_wholeView).widthIs(autoScaleW(85)).heightIs(autoScaleH(20));

    UILabel * slabel = [[UILabel alloc]init];
    slabel.backgroundColor = RGB(171, 171, 171);
    [_wholeView addSubview:slabel];
    slabel.sd_layout.leftSpaceToView(_wholeView,autoScaleW(32)).topSpaceToView(headimage,autoScaleH(110)).widthIs(kScreenWidth-autoScaleW(64)).heightIs(autoScaleH(0.5));


    if (isserve==YES) {
        [self CreatTable];
    }

}
-(void)CreatTable
{
    self.automaticallyAdjustsScrollViewInsets = NO;

    _tableV = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
    _tableV.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableV.delegate = self;
    _tableV.dataSource = self;
    [_wholeView addSubview:_tableV];

    _tableV.sd_layout.leftSpaceToView(_wholeView,autoScaleW(32)).rightSpaceToView(_wholeView,autoScaleW(32)).topSpaceToView(headimage,autoScaleH(130)).heightIs(autoScaleH(35)*(5+1));

    ButtonStyle * lookbtn = [ButtonStyle buttonWithType:UIButtonTypeCustom];
    [lookbtn setTitle:@"查看全部" forState:UIControlStateNormal];
    [lookbtn  setTitleColor:RGB(171, 171, 171) forState:UIControlStateNormal];
    lookbtn.titleLabel.font = [UIFont systemFontOfSize:autoScaleW(11)];
    [_wholeView addSubview:lookbtn];
    [lookbtn addTarget:self action:@selector(searchAllData:) forControlEvents:UIControlEventTouchUpInside];
    lookbtn.sd_layout.centerXEqualToView(_wholeView).topSpaceToView(_tableV,autoScaleH(10)).widthIs(autoScaleW(50)).heightIs(autoScaleH(15));

}
//查看全部
- (void)searchAllData:(ButtonStyle *)sender{
    [self getSceneDataSource:@"1"];
    _topName = @"1";
    sender.hidden = YES;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArr.count;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SceneInfoModel *model = _dataArr[indexPath.row];
    NSString *str = [NSString stringWithFormat:@"scene%ld", (long)indexPath.row];
    ServeTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:str];
    if (!cell) {
        cell = [[ServeTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:str];
    }
    //点击应答
    cell.model = model;
    cell.index = indexPath.row;
    cell.responseBlock = ^(SceneInfoModel  *sceneModel){
        if (sceneModel) {
            [self uploadResponseServiceToService:sceneModel];
        }
    };
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    UILabel * linlab =[[UILabel alloc]init];
    linlab.backgroundColor = UIColorFromRGB(0xeeeeee);
    [cell addSubview:linlab];
    linlab.sd_layout.leftSpaceToView(cell,0).rightSpaceToView(cell,0).bottomSpaceToView(cell,0).heightIs(0.5);

    UILabel* linlab1 =[[UILabel alloc]init];
    linlab1.backgroundColor = UIColorFromRGB(0xeeeeee);
    [cell addSubview:linlab1];
    linlab1.sd_layout.leftSpaceToView(cell,0).rightSpaceToView(cell,0).topSpaceToView(cell,0).heightIs(0.5);

    cell.firstlabel.text = [NSString stringWithFormat:@"%@号", model.boardNum];
    cell.secondlabel.text = model.service;
    //    cell.timelabel.text = [NSString stringWithFormat:@"已等待%@",threeary[indexPath.row]];

    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{

    return  autoScaleH(35);
}
-(void)Caidan
{

}
-(void)Shezhi
{
    //    AssignViewController * assignview = [[AssignViewController alloc]init];
    //    assignview.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    //    self.tabBarController.tabBar.hidden = YES;
    //    assignview.block = ^(NSString *string)
    //    {
    //        if ([string isEqualToString:@"xian"]) {
    //
    //            self.tabBarController.tabBar.hidden = NO;
    //
    //        }
    //    };
    SceneScanVC *sceneVC = [[SceneScanVC alloc] init];
    sceneVC.returnScanResult = ^(NSString *category, NSString *deskNum, NSString *codeInfo){
        ZTAddOrSubAlertView *alert = [[ZTAddOrSubAlertView alloc] initWithStyle:ZTalertSheetStyleSubTitle];
        alert.titleLabel.text = @"翻台";
        NSString *deskNumber = [NSString stringWithFormat:@"%@%@号", category, deskNum];
        alert.littleLabel.text = [NSString stringWithFormat:@"确认%@桌的客人用餐结束？", deskNumber];
        [alert.cancelBT setTitle:@"暂不翻台" forState:UIControlStateNormal];
        [alert.confirmBT setTitle:@"确定" forState:UIControlStateNormal];
        [alert.confirmBT setTitleColor:UIColorFromRGB(0xfd7577) forState:UIControlStateNormal];
        [alert showView];
        alert.complete = ^(BOOL complete){
            if (complete) {
                [self uploadDeskNumToService:category boardNum:codeInfo];
            }
        };
    };
    [self.navigationController pushViewController:sceneVC animated:YES];


    //    [self presentViewController:assignview animated:YES completion:^{
    //
    //    }];
}
#pragma mark  --------   上传 确定翻台，结束用餐 -----------
- (void)uploadDeskNumToService:(NSString *)boardType boardNum:(NSString *)boardId{
    NSString *keyUrl = @"api/fieldService/endMeal";
    NSString *uploadUrl = [NSString stringWithFormat:@"%@%@?token=%@&boardId=%@&storeId=%@", kBaseURL, keyUrl, TOKEN, boardId, storeID];
    [SVProgressHUD showWithStatus:@"正在处理"];
      
    [[QYXNetTool shareManager] postNetWithUrl:uploadUrl urlBody:nil bodyStyle:QYXBodyString header:nil response:QYXJSON success:^(id result) {
        if ([result[@"msgType"] integerValue] == 0) {
            [SVProgressHUD showSuccessWithStatus:@"处理成功"];
        } else {
            [SVProgressHUD showErrorWithStatus:@"处理失败"];
        }
    } failure:^(NSError *error) {

    }];
}
- (void)playSound{
    NSString *path = [[NSBundle mainBundle] pathForResource:@"scene" ofType:@"wav"];
    SystemSoundID soundId ;

    OSStatus error = AudioServicesCreateSystemSoundID((__bridge CFURLRef _Nonnull)([NSURL fileURLWithPath:path]), &soundId);
    if (error != kAudioServicesNoError) {
        //            NSLog(@"%d",(int)error);
    }


    AudioServicesPlaySystemSoundWithCompletion(soundId, ^{


    });
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
