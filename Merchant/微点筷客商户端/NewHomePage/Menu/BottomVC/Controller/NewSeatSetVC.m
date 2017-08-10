//
//  NewSeatSetVC.m
//  微点筷客商户端
//
//  Created by Skyer God on 16/12/6.
//  Copyright © 2016年 张森森. All rights reserved.
//

#import "NewSeatSetVC.h"
#import "NewSeatSetCell.h"
#import "ZT_doublePickerView.h"
#import "ZTAlertSheetView.h"
#import "ScanViewController.h"
#import "DeskSetModel.h"
#import <MJExtension/MJExtension.h>
#import <CoreImage/CoreImage.h>
#import "ShowQrcodeVC.h"
#import "MJChiBaoziHeader.h"
#import "BottomRoundView.h"
@interface NewSeatSetVC ()<UITableViewDelegate, UITableViewDataSource, ZTDeskPickerViewDelegate>
/** 二维码表   (strong) **/
@property (nonatomic, strong) UITableView *tableV;
/** 添加餐桌保存的数字典  (strong) **/
@property (nonatomic, strong) NSMutableDictionary *addDeskDic;
/** 数据源   (strong) **/
@property (nonatomic, strong) NSMutableArray *dataArr;


/** 顶部弹出排序视图   (strong) **/
//@property (nonatomic, strong) UIView *sortView;
@end

@implementation NewSeatSetVC
{
    BottomRoundView *bottomView;
    ButtonStyle *_addBT;
    ButtonStyle *submitBT;
    BOOL showCellDeleteBT;
    NSDictionary *leftDic;
}
-(UITableView *)tableV{
    if (!_tableV) {
        self.automaticallyAdjustsScrollViewInsets = NO;
        _tableV = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableV.delegate = self;
        _tableV.dataSource = self;
        _tableV.separatorStyle = 0;
        _tableV.showsVerticalScrollIndicator = NO;
        _tableV.editing = NO;
        [self.view addSubview:_tableV];

        _tableV.mj_header = [MJChiBaoziHeader headerWithRefreshingTarget:self refreshingAction:@selector(getData)];
        [_tableV.mj_header beginRefreshing];

        _tableV.sd_layout
        .topSpaceToView(self.view, 64)
        .leftSpaceToView(self.view, 10)
        .rightSpaceToView(self.view, 10)
        .bottomSpaceToView(self.view, 49);
    }
    return _tableV;
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];

    self.tabBarController.tabBar.hidden = YES;
    self.navigationController.navigationBar.hidden = NO;
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.tabBarController.tabBar.hidden = NO;

    //    [_sortView removeFromSuperview];


}
- (void)viewDidLoad {
    [super viewDidLoad];
    [ReloadVIew registerReloadView:self];
    self.rightBarItem.hidden = YES;
    self.view.backgroundColor = [UIColor whiteColor];
    leftDic = @{@"双人":@"A", @"四人":@"B", @"多人":@"C"};
    _addDeskDic = [NSMutableDictionary dictionary];
    self.titleView.text = @"餐桌设置";

    // Do any additional setup after loading the view.
    [self createTableList];
    [self createPlaceholderView];
    [self initWithBottomView];

}
//设置数据源
- (void)getData{
    _dataArr = [NSMutableArray array];
    NSString *keyUrl = @"api/merchant/findBoardAll";

    NSString *loadUrl = [NSString stringWithFormat:@"%@%@?token=%@&storeId=%@", kBaseURL, keyUrl, TOKEN, storeID];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
      
    [[QYXNetTool shareManager] postNetWithUrl:loadUrl urlBody:nil bodyStyle:QYXBodyString header:nil response:QYXJSON success:^(id result) {
        if ([result[@"msgType"] integerValue] == 0) {
            //请求成功
            id obj = result[@"obj"];
            if ([obj isNull]) {
                //数据为空
                [SVProgressHUD showInfoWithStatus:@"暂无数据"];
            } else {
                [result[@"obj"] enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    DeskSetModel *model= [DeskSetModel mj_objectWithKeyValues:obj];
                    model.leftDic = leftDic;
                    [_dataArr addObject:model];
                }];
                //                ZTLog(@"%@", result[@"obj"]);
                [_tableV reloadData];
            }
        } else {
            //请求异常
            [SVProgressHUD showErrorWithStatus:@"操作异常"];
        }
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [_tableV.mj_header endRefreshing];
    } failure:^(NSError *error) {
        //失败
    }];
}
#pragma mark -- 上传绑定桌号 －－
- (void)uploadDeskInfoToService{
    NSString *keyUrl = @"api/merchant/addBoard";
    NSString *boardId = [_addDeskDic objectForKey:@"boardId"];//桌号ID
    NSString *boardNum = [_addDeskDic objectForKey:@"boardNum"];//桌号
    NSString *type = [_addDeskDic objectForKey:@"type"];//桌号类型

    NSString *loadUrl = [NSString stringWithFormat:@"%@%@?token=%@&storeId=%@&boardId=%@&boardNum=%@&type=%@", kBaseURL, keyUrl, TOKEN, storeID, boardId, boardNum, type];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
      
    [[QYXNetTool shareManager] postNetWithUrl:loadUrl urlBody:nil bodyStyle:QYXBodyString header:nil response:QYXJSON success:^(id result) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if ([result[@"msgType"] integerValue] == 1 || [result[@"msgType"] integerValue] == 2) {
            [SVProgressHUD showInfoWithStatus:result[@"msg"]];
        } else {
            [self getData];
        }
    } failure:^(NSError *error) {


    }];
}
#pragma mark -- 批量上传 --
- (void)uploadMoreDeskInfoAndServiceAutoNum{
    NSString *keyUrl = @"api/merchant/batchAddBoard";
    NSString *boardType = [_addDeskDic objectForKey:@"boardType"];
    NSString *batchAddNum = [_addDeskDic objectForKey:@"batchAddNum"];

    NSString *loadUrl = [NSString stringWithFormat:@"%@%@?token=%@&storeId=%@&boardType=%@&batchAddNum=%@", kBaseURL, keyUrl, TOKEN, storeID, boardType, batchAddNum];

    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
      
    [[QYXNetTool shareManager] postNetWithUrl:loadUrl urlBody:nil bodyStyle:QYXBodyString header:nil response:QYXJSON success:^(id result) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if ([result[@"msgType"] integerValue] == 0) {
            [self getData];
        }
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];

    }];
}
#pragma mark -- 删除上传 只传值桌号
- (void)uploadDeleteDeskInfoToService{
    NSString *keyUrl = @"api/merchant/deleteBoard";

    NSString *boardNum = [_addDeskDic objectForKey:@"boardNum"];//桌号

    NSString *loadUrl = [NSString stringWithFormat:@"%@%@?token=%@&storeId=%@&boardNum=%@", kBaseURL, keyUrl, TOKEN, storeID, boardNum];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
      
    [[QYXNetTool shareManager] postNetWithUrl:loadUrl urlBody:nil bodyStyle:QYXBodyString header:nil response:QYXJSON success:^(id result) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if ([result[@"msgType"] integerValue] == 0) {
            [self getData];
        }
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }];
}
//创建表
- (void)createTableList{
    self.tableV.backgroundColor = [UIColor whiteColor];
    [self.tableV registerClass:[NewSeatSetCell class] forCellReuseIdentifier:NSStringFromClass([NewSeatSetCell class])];

}
//创建展位图
- (void)createPlaceholderView{

}
//设置底部添加栏
-(void)initWithBottomView{

    bottomView = [[BottomRoundView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height - 49, self.view.frame.size.width, 49) middleIcon:@"餐桌设置"];
    bottomView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:bottomView];

    __weak typeof(self) weakSelf = self;
    bottomView.middleButtonClick = ^(ButtonStyle *button) {
        NSArray *arr = @[@"扫码添加", @"批量添加", @"取消"];
        if (_dataArr.count >0) {
            arr = @[@"扫码添加", @"批量添加", @"删除餐桌", @"取消"];
        }
        ZTAlertSheetView *alerView = [[ZTAlertSheetView alloc] initWithTitleArray:arr];
        [alerView showView];
        alerView.alertSheetReturn = ^(NSInteger count){
            if (count == arr.count) {
                //什么都不做
            } else {
                [weakSelf clickAddDesk:count];
            }
        };
    };


    submitBT = [ButtonStyle buttonWithType:UIButtonTypeCustom];
    [submitBT setTitle:@"完成" forState:UIControlStateNormal];
    [submitBT setBackgroundColor:UIColorFromRGB(0xfd7577)];
    [submitBT addTarget:self action:@selector(submitBTAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:submitBT];
    submitBT.hidden = YES;

    submitBT.sd_layout
    .leftSpaceToView(self.view, 12)
    .rightSpaceToView(self.view, 12)
    .bottomSpaceToView(self.view, 8)
    .heightIs(50);
    [submitBT setSd_cornerRadiusFromHeightRatio:@(0.1)];
}

#pragma mark -- 创建 添加 餐桌 弹窗

- (void)clickAddDesk:(NSInteger )count{
    NSMutableArray *rightArr = [NSMutableArray array];
    int i = 1;
    while (i < 101) {
        [rightArr addObject:[NSString stringWithFormat:@"%d", i]];
        i++;
    }
    ZT_doublePickerView *timePicker = [[ZT_doublePickerView alloc] initWithLeftArr:leftDic.allKeys RightArr:rightArr];
    timePicker.delegate = self;
    if (count == 0) {
        //        NSLog(@"扫码添加");
#pragma mark --  扫描跳转 －－
        ScanViewController *scan = [[ScanViewController alloc] init];
        [self.navigationController pushViewController:scan animated:YES];
        [scan setReturnScanResult:^void(NSString *result) {
            if (result) {
                timePicker.numLabel.text = @"编号";
                timePicker.littleTitle.hidden = YES;
                [timePicker showTime];
                timePicker.tempStr = result;
            }
        }];


    } else if( count == 1){
        timePicker.numLabel.text = @"数量";
        timePicker.littleTitle.hidden = NO;
        [timePicker showTime];
        //        NSLog(@"批量添加");
    } else {
        //        NSLog(@"删除");
        showCellDeleteBT = YES;
        submitBT.hidden = NO;
        bottomView.hidden = YES;
        [_tableV reloadData];
    }
}
- (void)submitBTAction:(ButtonStyle *)sender{
    sender.hidden = YES;
    showCellDeleteBT = NO;
    [_tableV reloadData];
    bottomView.hidden = !sender.hidden;
}
/** ztDelegate **/
-(void)ZTselectTimesView:(ZT_doublePickerView *)deskPicker SetOneLeft:(NSString *)oneLeft andOneRight:(NSString *)oneRight{

    if (deskPicker.littleTitle.hidden) {
        [_addDeskDic setObject:[leftDic objectForKey:oneLeft] forKey:@"type"];
        [_addDeskDic setObject:oneRight forKey:@"boardNum"];
        [_addDeskDic setObject:deskPicker.tempStr forKey:@"boardId"];
        //二维码扫描无误，选择桌号类型和桌号好上传
        [self uploadDeskInfoToService];
    } else {
        //        for (NSInteger i = 0; i < [oneRight integerValue]; i++) {
        //            [_addDeskDic setObject:oneLeft forKey:[NSString stringWithFormat:@"%@-%ld" ,oneRight,i]];
        //        }
        [_addDeskDic setObject:oneRight forKey:@"batchAddNum"];
        [_addDeskDic setObject:[leftDic objectForKey:oneLeft] forKey:@"boardType"];
        [self uploadMoreDeskInfoAndServiceAutoNum];
    }
    //    [_tableV reloadData];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return _dataArr.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return autoScaleH(10);
}
-(UIView  *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return [[UIView alloc] init];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return autoScaleH(45);
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    NewSeatSetCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([NewSeatSetCell  class])];
    if (!cell) {
        cell = [[NewSeatSetCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:NSStringFromClass([NewSeatSetCell  class])];
    }

    cell.index = indexPath.section;
    DeskSetModel *model = _dataArr[indexPath.section];
    cell.model = model;
    if (showCellDeleteBT) {
        cell.deleteButton.hidden = !showCellDeleteBT;
        cell.scanButton.hidden = showCellDeleteBT;
    } else {
        cell.deleteButton.hidden = !showCellDeleteBT;
        cell.scanButton.hidden = showCellDeleteBT;
    }
    [cell setScanOrDeleteClick:^(NSInteger count) {
        if (count == 0) {
            //点击scan
            if ([model.isBind integerValue] == 1) {
                ShowQrcodeVC *showQrVC = [[ShowQrcodeVC alloc] init];
                showQrVC.model = model;

                [self.navigationController pushViewController:showQrVC animated:YES];
            } else {
                ScanViewController *scan = [[ScanViewController alloc] init];
                [self.navigationController pushViewController:scan animated:YES];
                [scan setReturnScanResult:^void(NSString *result) {
                    if (result) {
                        //上传绑定
                        [_addDeskDic setObject:model.boardType forKey:@"type"];
                        [_addDeskDic setObject:model.boardNum forKey:@"boardNum"];
                        [_addDeskDic setObject:result forKey:@"boardId"];
                        [self uploadDeskInfoToService];
                    }
                }];
            }
        } else {
            [_addDeskDic setObject:model.boardNum forKey:@"boardNum"];
            [self uploadDeleteDeskInfoToService];
            //点击删除
            //            [_tableV deleteSections:[NSIndexSet indexSetWithIndex:indexPath.section] withRowAnimation:UITableViewRowAnimationAutomatic];
            //            [self deleteSection:indexPath];
        }
    }];
    return cell;
}

- (void)deleteSection:(NSIndexPath *)indexP{
#pragma mark --- 删除分类更新 --


    //         [_addDeskDic remove];
    //         [_showCollectV deleteSections:[NSIndexSet indexSetWithIndex:indexP.section]];
    //         if (indexP.section  < _addDeskDic.count) {
    //             for (NSInteger section = indexP.section; section < _dataArr.count; ++section) {
    //
    //                 NSInteger sectionCount = [_tableV numberOfSections];
    //                 for (NSInteger item = 0; item < sectionCount; item++) {
    //                     NewSeatSetCell *cell = (NewSeatSetCell *)[_tableV cellfor:[NSIndexPath indexPathForItem:item inSection:section]];
    //                     cell.index = section;
    //                 }
    //             }
    //         }
}
-(void)leftBarButtonItemAction{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    //    if (!_sortView.hidden) {
    //        [self dismissTopSortView];
    //    }

    UITouch *touche = [touches anyObject];

    if ([touche.view isDescendantOfView:bottomView]) {
//        CGPoint point = [touche locationInView:self.view];
//        ZTLog(@"%@", NSStringFromCGPoint(point));

        //        NSArray *arrRowIndexPaths = [_tableV indexPathsForVisibleRows];

    }
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
