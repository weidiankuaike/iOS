//
//  StuffInfoCenterVC.m
//  微点筷客商户端
//
//  Created by Skyer God on 17/2/22.
//  Copyright © 2017年 张森森. All rights reserved.
//

#import "StuffInfoCenterVC.h"
#import "StuffCenterCell.h"
#import "ViewController.h"
#import "XGPush.h"
#import "ChangelogincodeViewController.h"
@interface StuffInfoCenterVC ()<UITableViewDelegate, UITableViewDataSource>
/** <#行注释#>   (strong) **/
@property (nonatomic, strong) UITableView *tableV;
@end

@implementation StuffInfoCenterVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.rightBarItem setImage:[UIImage imageNamed:@"设置-(1)"] forState:UIControlStateNormal];
    self.view.backgroundColor = [UIColor whiteColor];
    self.titleView.text = @"个人中心";

    _tableV = [[UITableView alloc] init];
    _tableV.backgroundColor = [UIColor whiteColor];
    _tableV.delegate = self;
    _tableV.dataSource = self;
    _tableV.bounces = NO;
    _tableV.separatorColor = RGB(218, 218, 218);
    [self.view addSubview:_tableV];

    _tableV.sd_layout.spaceToSuperView(UIEdgeInsetsMake(0, 0, 140, 0));
    [_tableV registerClass:[StuffCenterCell class] forCellReuseIdentifier:NSStringFromClass([StuffCenterCell class])];

    ButtonStyle *registerBT = [ButtonStyle buttonWithType:UIButtonTypeCustom];
    [registerBT setTitle:@"注销登录" forState:UIControlStateNormal];
    [registerBT setBackgroundColor:UIColorFromRGB(0xfd7577)];
    [self.view addSubview:registerBT];
    [registerBT addTarget:self action:@selector(registerBTClick:) forControlEvents:UIControlEventTouchUpInside];

    registerBT.sd_layout
    .leftSpaceToView(self.view, 20)
    .rightSpaceToView(self.view, 20)
    .topSpaceToView(_tableV, 30)
    .heightIs(45);
    [registerBT setSd_cornerRadiusFromHeightRatio:@(0.12)];


}
- (void)registerBTClick:(ButtonStyle *)sender{
    //清空登录数据


//    NSString *tempLoginName = LoginName;
    NSUserDefaults *userDefaut = [NSUserDefaults standardUserDefaults];
    [userDefaut setObject:@"error" forKey:@"token"];
    [userDefaut setObject:@"error" forKey:LocationLoginInResultsKey];
    if ([TOKEN isEqualToString:@"error"]) {
        //跳转到登录界面
        [XGPush delAccount:^{
            ViewController *loginVC = [[ViewController alloc] init];
            //        self.modalPresentationStyle = UIModalPresentationCurrentContext;
            //        self.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
            //        [self presentViewController:loginVC animated:YES completion:^{
            //        loginVC.registLogName = tempLoginName;
            //        }];
            [self.navigationController pushViewController:loginVC animated:YES];
        } errorCallback:^{

        }];

    }
}
//解除当前商铺
- (void)uploadLockStatusAndDeleteTheStuff{

    
}

- (void)leftBarButtonItemAction{
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)rightBarButtonItemAction:(ButtonStyle *)sender{

}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 3;
    } else if (section == 1) {
        return 5;
    } else {
        return 1;
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return 50;
    } else if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            return 35;
        } else {
            return 50;
        }
    } else {
        return 45;
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return 10;
    } else {
        return 13;
    }
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    static NSString *str = @"operationCell";
    StuffCenterCell *cell = [tableView dequeueReusableCellWithIdentifier:str];
    if (!cell) {
        cell = [[StuffCenterCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:str];
        cell.indexP = indexPath;
    }
    cell.indexP = indexPath;
    cell.textLabel.textColor = [UIColor grayColor];
    cell.detailTextLabel.textColor = [UIColor lightGrayColor];
    cell.detailTextLabel.font = [UIFont systemFontOfSize:15];


    //分区一
    if (indexPath.section == 0) {
        NSArray *titleArr = @[@"姓名", @"手机号", @"供职餐厅"];
        NSArray *textArr = @[_BaseModel.name, LoginName];
        cell.textLabel.text = titleArr[indexPath.row];
        if (indexPath.row < 2) {
            cell.detailTextLabel.text = textArr[indexPath.row];
        } else {
            //单独处理
            cell.lockButton.hidden = NO;
            [cell.lockButton addTarget:self action:@selector(lockClick:) forControlEvents:UIControlEventTouchUpInside];
            cell.detailLB.hidden = NO;
            cell.detailLB.font = cell.detailTextLabel.font;
            cell.detailLB.textColor = cell.detailTextLabel.textColor;
            cell.detailLB.text = _BaseModel.storeBase.name;
        }
    }
    if (indexPath.section == 1) {
        NSArray *titleArr = @[@"操作权限", @"订单管理", @"现场管理", @"排队管理", @"餐厅管理"];
        NSArray *limitArr = @[@"", _BaseModel.isOrderManage, _BaseModel.isServiceManage, _BaseModel.isKitchenManage, _BaseModel.isStoreManage];
        cell.textLabel.text = titleArr[indexPath.row];
        if (indexPath.row == 0) {
            cell.textLabel.textColor = [UIColor lightGrayColor];
            cell.textLabel.font = [UIFont systemFontOfSize:13];
        } else {
            cell.switchBT.hidden = NO;
            cell.switchBT.on = [limitArr[indexPath.row] boolValue];
        }
    }
    //分区二
    if (indexPath.section == 2) {
        cell.textLabel.text = @"登录密码";
        cell.detailTextLabel.text = @"修改";
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
     [self setExtraCellLineHidden:tableView];
    return cell;

}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 2) {
        if (indexPath.row == 0) {
            ChangelogincodeViewController *changePwdVC = [[ChangelogincodeViewController alloc] init];
            [self.navigationController pushViewController:changePwdVC animated:YES];
        }
    }
}
- (void)lockClick:(ButtonStyle *)sender{
     [sender setImage:[UIImage imageNamed:@"lock_on"] forState:UIControlStateNormal];
    UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"确定解绑当前店铺？" message:@"确定后，此操作即视为脱离当前所在店铺。" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        [self dismissViewControllerAnimated:YES completion:^{
            [sender setImage:[UIImage imageNamed:@"lock_off"] forState:UIControlStateNormal];
        }];
    }];
    UIAlertAction *ok = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        //发起解绑请求
        NSString *keyUrl = @"api/merchant/storeStaffManage";
        NSString *operation = @"2";
        NSString *staffType = @"1";

        NSString *uploadUrl = [NSString stringWithFormat:@"%@%@?token=%@&storeId=%@&userId=%@&phone=%@&operation=%@&staffType=%@", kBaseURL, keyUrl, TOKEN, storeID, UserId, LoginName, operation, staffType];
          
        [[QYXNetTool shareManager] postNetWithUrl:uploadUrl urlBody:nil bodyStyle:QYXBodyString header:nil response:QYXJSON success:^(id result) {
            if ([result[@"msgType"] integerValue] == 0) {
                // 解绑成功 重新到登录界面
                [self registerBTClick:nil];
            } else {
                [sender setImage:[UIImage imageNamed:@"lock_off"] forState:UIControlStateNormal];
            }
        } failure:^(NSError *error) {
             [sender setImage:[UIImage imageNamed:@"lock_off"] forState:UIControlStateNormal];
            
        }];

    }];
    [alertC addAction:cancel];
    [alertC addAction:ok];
    [self presentViewController:alertC animated:YES completion:^{

    }];
}
/** 隐藏多余的分割线 **/
-(void)setExtraCellLineHidden: (UITableView *)tableView
{
    UIView *view = [UIView new];

    view.backgroundColor = [UIColor clearColor];

    [tableView setTableFooterView:view];
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
