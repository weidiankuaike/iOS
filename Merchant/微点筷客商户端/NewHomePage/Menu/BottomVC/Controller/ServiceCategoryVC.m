//
//  ServiceCategoryVC.m
//  微点筷客商户端
//
//  Created by Skyer God on 16/10/18.
//  Copyright © 2016年 张森森. All rights reserved.
//

#import "ServiceCategoryVC.h"

#import "ServiceCategoryCell.h"
#import "ZTAlertSheetView.h"
#import "ZTAddOrSubAlertView.h"
#import <MBProgressHUD/MBProgressHUD.h>
#import "QYXNetTool.h"
#import "NSObject+JudgeNull.h"
#import "BottomRoundView.h"
//#import "NSArray+Description.h"
@interface ServiceCategoryVC ()<UITableViewDataSource, UITableViewDelegate>
/** 表   (strong) **/
@property (nonatomic, strong) UITableView *tableV;
/** 数据源数组   (strong) **/
@property (nonatomic, strong) NSMutableArray *dataArr;

/** 添加按钮   (strong) **/
@property (nonatomic, strong) ButtonStyle *addBT;


@end

@implementation ServiceCategoryVC
{
    BottomRoundView *bottomView;
    ButtonStyle *_leftBarItem;
    BOOL isDelete;
    NSInteger deleteIndex;
    ButtonStyle *submitBT;
}
-(UITableView *)tableV{
    if (!_tableV) {
        _tableV = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableV.delegate = self;
        _tableV.dataSource = self;
        _tableV.separatorStyle = 0;
        _tableV.editing = NO;
        [self.view addSubview:_tableV];


        _tableV.sd_layout
        .topSpaceToView(self.view, 64)
        .leftEqualToView(self.view)
        .rightEqualToView(self.view)
        .bottomSpaceToView(bottomView, 0);

        [self.view bringSubviewToFront:bottomView];
    }
    return _tableV;
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    self.rightBarItem.hidden = YES;
    self.tabBarController.tabBar.hidden = YES;
    self.navigationController.navigationBar.hidden = NO;
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.tabBarController.tabBar.hidden = NO;

}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [ReloadVIew registerReloadView:self];
    self.titleView.text = @"服务设置";
    // Do any additional setup after loading the view.
    _dataArr = [NSMutableArray array];

    [self getData];
    [self initWithBottomView];
    [self createServiceTableList];

    deleteIndex = 10000;


}
- (void)getData{

    NSString *operatingType = @"1";
    if ([_BaseModel.isChecked integerValue] < 3 && [_BaseModel.isBoss integerValue] == 0) {
        //入住前，什么都不做，只在pop的时候返回数组字符串
        NSArray *array = [@"呼叫,加水,纸巾,清理,加饭,催菜" componentsSeparatedByString:@","];
        self.dataArr = [NSMutableArray arrayWithArray:array];
    } else {
        //入驻后，请求
        NSString *keyUrl = @"/api/merchant/searchServiceType";
        NSString *storeId = storeID;
        operatingType = @"0";
        NSString *token = TOKEN;
        NSString *urlUpload = [NSString stringWithFormat:@"%@%@?token=%@&storeId=%@&operatingType=%@",kBaseURL, keyUrl, token, storeId,operatingType];

           
        [[QYXNetTool shareManager] postNetWithUrl:urlUpload urlBody:nil bodyStyle:QYXBodyString header:nil response:QYXJSON success:^(id result) {
            NSString *str  = result[@"obj"][@"offerService"];
//            ZTLog(@"%@, %@", str, result[@"obj"][@"offerService"]);
            if ([str isNull]) {

            } else {
                NSArray *array = [str componentsSeparatedByString:@","];
                self.dataArr = [NSMutableArray arrayWithArray:array];
                [_tableV reloadData];
            }
        } failure:^(NSError *error) {
            
        }];
    }
}
- (void)uploadDataSource{
    //入驻后，上传更新
    if (!self.presentingViewController) {
        //入住前，什么都不做，只在pop的时候返回数组字符串
    } else {
    NSString *keyUrl = @"/api/merchant/searchServiceType";
    NSString *storeId = storeID;
    NSString *operatingType = @"1";
    NSString *offerService = [_dataArr componentsJoinedByString:@","];
    offerService = [offerService stringByAppendingString:@","];
    NSString *token = TOKEN;
    NSString *urlUpload = [NSString stringWithFormat:@"%@%@?token=%@&storeId=%@&operatingType=%@&offerService=%@",kBaseURL, keyUrl, token, storeId,operatingType, offerService];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];

           
        [[QYXNetTool shareManager] postNetWithUrl:urlUpload urlBody:nil bodyStyle:QYXBodyString header:nil response:QYXJSON success:^(id result) {

        if ([result[@"msgType"] integerValue] == 0) {

        }
        [MBProgressHUD hideHUDForView:self.view animated:YES];

    } failure:^(NSError *error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [[MBProgress_GodSkyer shareManager] showWithLabelWithMessage:@"网络不好" inView:self.view];
    }];
    }
   
}
-(void)initWithBottomView{



    bottomView = [[BottomRoundView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height - 49, self.view.frame.size.width, 49) middleIcon:@"服务管理"];
    bottomView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:bottomView];

    __weak typeof(self) weakSelf = self;
    bottomView.middleButtonClick = ^(ButtonStyle *button) {
        [weakSelf addBTAction:button];
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
- (void)submitBTAction:(ButtonStyle *)sender{
    isDelete = NO;
    submitBT.hidden = !isDelete;
    bottomView.hidden = isDelete;
    [_tableV reloadData];
}
- (void)addBTAction:(ButtonStyle *)sender{

    NSArray *arr = @[@"添加服务",@"删除服务",@"取消"];
    ZTAlertSheetView *alertSheet = [[ZTAlertSheetView alloc] initWithTitleArray:arr];
    [alertSheet showView];

    alertSheet.alertSheetReturn = ^(NSInteger index){

        if (index == 0) {
            ZTAddOrSubAlertView *alertTextField = [[ZTAddOrSubAlertView alloc] initWithStyle:ZTalertSheetStyleTextFiled];
            [alertTextField showView];
            alertTextField.tag = 10000;
            __weak typeof(alertTextField) weakAlert = alertTextField;
            alertTextField.textInputEnd = ^(NSString *text){
                if ([text isNull] || [text isEqualToString:@""]) {
                    [SVProgressHUD setMinimumDismissTimeInterval:1.5];
                    [SVProgressHUD showErrorWithStatus:@"输入为空，请重新输入"];

                } else {
                    if (text.length >4) {
                        [SVProgressHUD setMinimumDismissTimeInterval:1.5];
                        [SVProgressHUD showErrorWithStatus:@"超出范围，最大输入长度为4"];

                    } else if ([_dataArr containsObject:text]) {
                        UIAlertController *alercont = [UIAlertController alertControllerWithTitle:@"命名冲突" message:@"服务列表已经有此服务，请修改！😊" preferredStyle:UIAlertControllerStyleAlert];

                        [self presentViewController:alercont animated:YES completion:^{
                            dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.3/*延迟执行时间*/ * NSEC_PER_SEC));
                            dispatch_after(delayTime, dispatch_get_main_queue(), ^{
                                [alercont dismissViewControllerAnimated:YES completion:nil];
                                [weakAlert.textFild becomeFirstResponder];
                            });
                        }];
                    } else {
                        [weakAlert dismiss];
                        [_dataArr insertObject:text atIndex:_dataArr.count];
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [self uploadDataSource];
                        });
                        [_tableV reloadData];
//                        ZTLog(@"%@", [_dataArr descriptionWithLocale:_dataArr]);
                    }
                }
            };
        } else if (index == 1) {
            isDelete = YES;
            bottomView.hidden = isDelete;
            submitBT.hidden = !isDelete;
            [_tableV reloadData];
            
        } else {

        }
    };



}
- (void)leftBarButtonItemAction{
    [(ZTAddOrSubAlertView *)[[UIApplication sharedApplication].keyWindow viewWithTag:10000] dismiss];

    if (self.presentingViewController) {
        [self dismissViewControllerAnimated:YES completion:nil];
    } else {
        if (_returnJoinInVC) {
            _returnJoinInVC([_dataArr componentsJoinedByString:@","]);
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
}

- (void)createServiceTableList{

    self.tableV.backgroundColor = [UIColor whiteColor];
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataArr.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ServiceCategoryCell *cell = [tableView dequeueReusableCellWithIdentifier:@"service"];
    if (cell == nil) {
        cell = [[ServiceCategoryCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"service"];
    }
    cell.index = indexPath.row;
    cell.titleLabel.text = _dataArr[indexPath.row];
    cell.deleteBT.hidden = !isDelete;
    if (isDelete) {
        cell.deleteClick = ^(NSInteger index){
            if ([cell.titleLabel.text isEqualToString:@"呼叫"] || [cell.titleLabel.text isEqualToString:@"加菜"]) {
                //什么都不做
                [SVProgressHUD setMinimumDismissTimeInterval:1.2];
                [SVProgressHUD showInfoWithStatus:@"固定服务，不可移除"];
            } else {
                deleteIndex = index;
                [self tableView:_tableV commitEditingStyle:UITableViewCellEditingStyleNone forRowAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0]];
                return ;
            }
        };
    }
    return cell;
}
- (UITableViewCellEditingStyle )tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewCellEditingStyleNone;
}
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
//    ZTLog(@"%ld", deleteIndex);

    [_dataArr removeObjectAtIndex:indexPath.row];
    [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];

    if (indexPath.row  < _dataArr.count) {
        for (NSInteger i = indexPath.row; i < _dataArr.count; ++i) {
            NSIndexPath *indexP = [NSIndexPath indexPathForRow:i inSection:0];
            ServiceCategoryCell *cell = [tableView cellForRowAtIndexPath:indexP];
            cell.index = i;
        }
    }
#pragma mark ---上传数组 －－－－－－
//    NSString *uploadStr = [_dataArr componentsJoinedByString:@","];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self uploadDataSource];
    });
//    ZTLog(@"%@", uploadStr);

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
