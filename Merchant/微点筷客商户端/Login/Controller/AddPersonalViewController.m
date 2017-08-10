//
//  AddPersonalViewController.m
//  微点筷客商户端
//
//  Created by 张森森 on 16/10/9.
//  Copyright © 2016年 张森森. All rights reserved.
//

#import "AddPersonalViewController.h"
#import "UIBarButtonItem+SSExtension.h"
#import "LoginTableViewCell.h"
#import "MyorderViewController.h"
#import "ZTAlertSheetView.h"
#import "ZTAddOrSubAlertView.h"
#import "AddStaffPhoneCodeVC.h"
@interface AddPersonalViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    NSArray * firstary;
    NSArray * threeary;
    NSArray * fourary;
    
    UISwitch * _mySwitch;
    UITableView * MineTableview;
    void (^changeSuccessAndViewDisapper)(BOOL success);
}
@property (nonatomic,strong)UIImageView * headimageview;
@property (nonatomic,strong)ZTAlertSheetView * alertview;
@property (nonatomic,strong)ZTAddOrSubAlertView * addor;
@end

@implementation AddPersonalViewController
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];

    __block typeof(self) weakSelf =self;
        changeSuccessAndViewDisapper = ^(BOOL success){
            if (success&& _model.isBoss) {
                __block NSArray *threePowerArr = @[weakSelf.quanxianary[0], weakSelf.quanxianary[1], weakSelf.quanxianary[2]];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"initWithTabBarController" object:nil userInfo:@{@"powerArr":threePowerArr}];
            }
        };
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [[IQKeyboardManager sharedManager] setShouldHidePreviousNext:YES];
    [[IQKeyboardManager sharedManager] setShouldResignOnTouchOutside:YES];
    if (_boolinteger==1) {
        self.titleView.text = @"修改员工";
    } else {
        self.titleView.text = @"添加员工";
    }
    if (_model.isBoss) {
        self.titleView.text = @"管理员权限";
    }
    self.view.backgroundColor = UIColorFromRGB(0xffffff);

    
    if (_boolinteger==1 && !_model.isBoss) {
        UIBarButtonItem * clectbtn = [UIBarButtonItem itemWithTarget:self Action:@selector(Delect) image:@"more_point" selectImage:nil];
        self.navigationItem.rightBarButtonItem = clectbtn;
    }
    
    
//    CGFloat height = [[UIApplication sharedApplication] statusBarFrame].size.height + self.navigationController.navigationBar.frame.size.height;
    UIView * headview = [[UIView alloc]init];
    headview.frame = CGRectMake(0, 0, kScreenWidth, autoScaleH(145));
    [self.view addSubview:headview];
    
    
    UIImageView * headimag = [[UIImageView alloc]init];
    headimag.image = [UIImage imageNamed:@"背"];
    headimag.frame = headview.frame;
    [headview addSubview:headimag];
    headimag.userInteractionEnabled = YES;
    
    
    _headimageview =[[UIImageView alloc]init];
    _headimageview.userInteractionEnabled = YES;
//    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(Changebig)];
//    [_headimageview addGestureRecognizer:tap];
    
    _headimageview.image = [UIImage imageNamed:@"用户"];
    [headimag addSubview:_headimageview];
    _headimageview.sd_layout.centerXEqualToView(headview).centerYEqualToView(headview).widthIs(autoScaleW(53)).heightIs(autoScaleH(53));
    
    //表
    ButtonStyle * loginbtn = [ButtonStyle buttonWithType:UIButtonTypeCustom];
    [loginbtn setTitle:@"保存" forState:UIControlStateNormal];
    loginbtn.titleLabel.font = [UIFont systemFontOfSize:autoScaleW(15)];
    [loginbtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    loginbtn.backgroundColor = UIColorFromRGB(0xfd7577);
    [loginbtn addTarget:self action:@selector(Finish) forControlEvents:UIControlEventTouchUpInside];
    loginbtn.layer.masksToBounds = YES;
    loginbtn.layer.cornerRadius = autoScaleW(5);
    [self.view addSubview:loginbtn];
    loginbtn.sd_layout.leftSpaceToView(self.view,autoScaleW(15)).rightSpaceToView(self.view,autoScaleW(15)).bottomSpaceToView(self.view, 8).heightIs(autoScaleH(30));

    MineTableview = [[UITableView alloc]init];
    MineTableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    MineTableview.delegate =self;
    MineTableview.dataSource= self;
    MineTableview.bounces = NO;
    MineTableview.tableHeaderView = headview;
    [self.view addSubview:MineTableview];
    MineTableview.sd_layout.leftSpaceToView(self.view,0).topSpaceToView(self.view,64).widthIs(kScreenWidth).bottomSpaceToView(loginbtn, 6);
    

    firstary = @[@"员工姓名",@"联系电话",];
    fourary = @[@"请输入姓名",@"请输入联系电话",];
    if (_boolinteger == 1) {
        if (_model.isBoss) {
            //修改店主权限

            threeary = @[@"订单(对预定排号进行操作)",@"现场(对服务呼叫进行应答)",@"排队(排号、领号)",@"统计(营业额、流量、提现操作等)",@"餐厅管理(菜品、餐桌、服务、活动)",@"设置(账号管理、功能设置等)",];
            NSDictionary *dic =_loginInfoDic;
            _model = [StuffAccountModel mj_objectWithKeyValues:dic];
            _xinxiary = @[_model.name, dic[@"loginName"]];
            _model.isBoss = YES;
            if ([_BaseModel.isChecked integerValue] == 2 && [_BaseModel.storeBase.isEdit intValue] == 0) {
                _quanxianary =[NSMutableArray arrayWithArray:@[@"1", @"1", @"1", @"1", @"1",@"1"]];
            } else {
                _quanxianary =[NSMutableArray arrayWithArray:@[_model.isOrderManage, _model.isServiceManage, _model.isKitchenManage, @"1", @"1",@"1"]];
            }
            [self searchStaffPower];
        } else {
            //修改员工权限
            //此数组不要轻易更动，如果更动，则上传接口字段数组也要对应改变
            //对应如下：NSArray *limitKeyArr =  @[@"isOrderManage", @"isServiceManage", @"isStoreManage", @"isKitchenManage"];
            threeary = @[@"订单(对预定排号进行操作)",@"现场(对服务呼叫进行应答)",@"排队(排号、领号)",@"餐厅(菜品、餐桌、服务、活动)",];
            _xinxiary = @[_model.name, _model.phone];
            _quanxianary = [NSMutableArray arrayWithArray:@[_model.isOrderManage, _model.isServiceManage, _model.isKitchenManage ,_model.isStoreManage,]];
        }
    } else if (_boolinteger == 0) {
        threeary = @[@"订单(对预定排号进行操作)",@"现场(对服务呼叫进行应答)", @"排队(排号、领号)",@"餐厅(菜品、餐桌、服务、活动)",];
        _xinxiary = @[@"员工姓名", @"员工手机号"];
        _quanxianary = [NSMutableArray arrayWithArray:@[@"1", @"1", @"1", TempKitchStatus]];

    }

}
-(void)leftBarButtonItemAction{
    [self Back];
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section==0) {
        
        return 3;
    }
    return threeary.count;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    LoginTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"add"];

        if (!cell) {
        cell = [[LoginTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"add"];
    }
    cell.index = indexPath.row;
    UILabel*linlab =[[UILabel alloc]init];
    linlab.backgroundColor = UIColorFromRGB(0xeeeeee);
    [cell addSubview:linlab];
    linlab.sd_layout.leftSpaceToView(cell,0).rightSpaceToView(cell,0).bottomSpaceToView(cell,0).heightIs(0.5);
    if (indexPath.section==0) {
        
        if (indexPath.row==2) {
            
            cell.backgroundColor =RGB(238, 238, 238);
        } else {
            cell.leftlabel.text = firstary[indexPath.row];
            if (indexPath.row == 1 && [self.titleView.text isEqualToString:@"管理员权限"]) {
                cell.textfild.enabled = NO;
            }
            if (_boolinteger==1) {
                cell.textfild.text = _xinxiary[indexPath.row];
            } else {
            cell.textfild.placeholder = fourary[indexPath.row];
            }
        }
    }
    if (indexPath.section==1) {
        cell.leftlabel.text = threeary[indexPath.row];
        cell.textfild.hidden = YES;
        _mySwitch = [self.view viewWithTag:300 + indexPath.row];
        if (_mySwitch == nil) {
            _mySwitch = [[UISwitch alloc]init];
        }
        if (_boolinteger==1 || _boolinteger == 0) {
            _mySwitch.on = [_quanxianary[indexPath.row] integerValue];
        } else {
            _mySwitch.on = YES;
        }
        _mySwitch.tag = 300 + indexPath.row;
        [_mySwitch setOnTintColor:UIColorFromRGB(0xfd7577)];
        [_mySwitch addTarget:self action:@selector(swChange:) forControlEvents:UIControlEventValueChanged];
        [cell addSubview:_mySwitch];
        _mySwitch.sd_layout.rightSpaceToView(cell,autoScaleW(15)).topSpaceToView(cell,autoScaleH(8)).widthIs(autoScaleW(8)).heightIs(autoScaleH(11));
        if (indexPath.section == 1 && _boolinteger == 1) {
            if (indexPath.row == 0) {
                cell.textfild.userInteractionEnabled = NO;
            }
        }
        if (indexPath.row > 2 && _model.isBoss && indexPath.section == 1) {
            //老板权限修改，前三种可修改，后三种不可修改
            _mySwitch.userInteractionEnabled = NO;
        } else {
            _mySwitch.userInteractionEnabled = YES;
        }
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView * view =  [[UIView alloc]init];
    UILabel * leftlabel = [[UILabel alloc]init];
    leftlabel.frame = CGRectMake(autoScaleW(15), autoScaleH(3), autoScaleW(50), autoScaleH(15));
    leftlabel.font = [UIFont systemFontOfSize:autoScaleW(11)];
    leftlabel.textColor = [UIColor lightGrayColor];
    if (section==0) {
        leftlabel.text = @"员工资料";
    }
    if (section==1) {
        
        leftlabel.text= @"操作权限";
    }
       [view addSubview:leftlabel];
    
    UILabel *linlab =[[UILabel alloc]init];
    linlab.backgroundColor = UIColorFromRGB(0xeeeeee);
    [view addSubview:linlab];
    linlab.sd_layout.leftSpaceToView(view,0).rightSpaceToView(view,0).bottomSpaceToView(view,0).heightIs(0.5);
    
    
    return view;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0) {
        
        if (indexPath.row==2) {
            
            return autoScaleH(10);
        }
    }
    
    return autoScaleH(45);
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return autoScaleH(20);
}
-(void)Back
{
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark 删除
-(void)Delect
{
    if (![self.titleView.text isEqualToString:@"管理员权限"]) {
        NSArray * chooseary = @[@"删除该员工",@"取消"];
        @weakify(self);
        self.alertview = [[ZTAlertSheetView alloc]initWithTitleArray:chooseary];
        [_alertview showView];
        _alertview.alertSheetReturn = ^(NSInteger count)
        {
            @strongify(self);
            if (count==0) {
                [self.alertview removeFromSuperview];
                self.addor = [[ZTAddOrSubAlertView alloc]initWithStyle:ZTalertSheetStyleTitle];
                self.addor.titleLabel.text = @"确认删除该员工";
                [self.addor showView];
                @weakify(self);
                self.addor.complete = ^(BOOL btn) {
                    if (btn == YES) {
                        @strongify(self);
                        [self uploadStaffInfoToService:@"2"];
                    }
                };
            }
        };
    }
}
#pragma mark 开关
-(void)swChange:(UISwitch*)sw {
    NSInteger index = sw.tag - 300;
    NSString *changeValue = sw.isOn == YES ? @"1" : @"0";
    [_quanxianary replaceObjectAtIndex:index withObject:changeValue];
//    ZTLog(@"%@", _quanxianary);

}
#pragma mark 保存


-(void)Finish
{
//    MyorderViewController * myorderview = [[MyorderViewController alloc]init];
//    [self.navigationController pushViewController:myorderview animated:YES];
//    [self uploadStaffInfoToService:@"3"];

    LoginTableViewCell *nameCell = [MineTableview cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    LoginTableViewCell *phoneCell = [MineTableview cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
    NSString *name = nameCell.textfild.text;
    NSString *phone = phoneCell.textfild.text;
    if (_model.isBoss) {
        [self uploadStaffInfoToService:@"3"];
//        [self leftBarButtonItemAction];
        return;
    }
    if ([phone isEqualToString:_xinxiary[1]] && _boolinteger == 1) {
        //不需要验证码
        [self uploadStaffInfoToService:@"3"];
    } else {
        //需要验证码
        if ([name isNull] || [phone isNull] || ![phone isMobileNumber]) {
            if (![phone isMobileNumber]) {
                [SVProgressHUD showInfoWithStatus:@"请输入正确的手机号码"];
                return;
            }
            UIAlertController *alerController = [UIAlertController alertControllerWithTitle:@"信息为空" message:@"请补全信息！" preferredStyle:UIAlertControllerStyleAlert];
            [self presentViewController:alerController animated:YES completion:^{
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [self dismissViewControllerAnimated:YES completion:nil];
                });
            }];
            return;
        }
        [self vertifyStaffPhoneNumber];
    }


}
#pragma mark -- 验证员工手机号码接口－－－－
- (void)vertifyStaffPhoneNumber{
    LoginTableViewCell *nameCell = [MineTableview cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    LoginTableViewCell *phoneCell = [MineTableview cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
    NSString *keyURl = @"/api/merchant/checkStaffPhoneIsExist";
    NSString *phone = phoneCell.textfild.text;
    NSString *name =  nameCell.textfild.text;

    NSString *uploadUrl = [NSString stringWithFormat:@"%@%@?token=%@&storeId=%@&phone=%@", kBaseURL, keyURl, TOKEN, storeID, phone];
    [[QYXNetTool shareManager] postNetWithUrl:uploadUrl urlBody:nil bodyStyle:QYXBodyString header:nil response:QYXJSON success:^(id result) {
        NSInteger msgType = [result[@"msgType"] integerValue];

        switch (msgType) {
            case 0:
            {
                AddStaffPhoneCodeVC *code = [[AddStaffPhoneCodeVC alloc] init];
                code.phoneNum = phone;
                code.staffName = name;
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.navigationController pushViewController:code animated:YES];
                });
                code.vertiftSuccess = ^(BOOL success){
                    [self uploadStaffInfoToService:@"1"];
                };
            }
                break;
            case 1:
                [SVProgressHUD showErrorWithStatus:@"操作异常"];
                break;
            case 2:
                [SVProgressHUD showErrorWithStatus:@"该号码已经被注册"];
                break;
            case 3:
                [SVProgressHUD showErrorWithStatus:@"您是店主，无法添加自己"];
                break;
            case 4:
                [SVProgressHUD showErrorWithStatus:@"本店已有员工使用此号码"];
                break;

            default:
                break;
        }


    } failure:^(NSError *error) {


    }];

}
#pragma mark --3 修改员工信息 --  2删除员工信息 －－
- (void)uploadStaffInfoToService:(NSString *)type{
    LoginTableViewCell *nameCell = [MineTableview cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    LoginTableViewCell *phoneCell = [MineTableview cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
    NSArray *limitKeyArr =  @[@"isOrderManage", @"isServiceManage", @"isKitchenManage", @"isStoreManage"];
    NSString *keyUrl = @"api/merchant/storeStaffManage";
    __block NSString *limitAppendStr = @"";
    [limitKeyArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSString *tempStr = [NSString stringWithFormat:@"%@=%@&", obj, _quanxianary[idx]];
        limitAppendStr = [limitAppendStr stringByAppendingString:tempStr];
    }];
    NSString *operation = type;//0:查询 1：添加 2：删除 3：修改
    NSString *staffType = _model.isBoss == YES ? @"0" : @"1";//修改员工时，0：店主 1：员工
    NSString *name = nameCell.textfild.text;
    NSString *phone = phoneCell.textfild.text;
    NSString *uploadUrl = @"";
    if (_boolinteger == 1) {
        if ([type integerValue] == 2) {//删除url
            uploadUrl = [NSString stringWithFormat:@"%@%@?token=%@&storeId=%@&phone=%@&operation=%@", kBaseURL, keyUrl, TOKEN, storeID, phone, operation];
        } else { //修改url
            uploadUrl = [NSString stringWithFormat:@"%@%@?token=%@&storeId=%@&%@name=%@&phone=%@&operation=%@&staffType=%@", kBaseURL, keyUrl, TOKEN, storeID, limitAppendStr, name, phone, operation, staffType];
        }
    } else if (_boolinteger == 0){  //添加员工
        staffType = @"0";//只有老板才可以添加
        operation = @"1";
        if ([name isNull] || [phone isNull]) {
            UIAlertController *alerController = [UIAlertController alertControllerWithTitle:@"信息为空" message:@"请补全信息！" preferredStyle:UIAlertControllerStyleAlert];
            [self presentViewController:alerController animated:YES completion:^{
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [self dismissViewControllerAnimated:YES completion:nil];
                });
            }];
            return;
        }
        uploadUrl = [NSString stringWithFormat:@"%@%@?token=%@&storeId=%@&%@name=%@&phone=%@&operation=%@&staffType=%@", kBaseURL, keyUrl, TOKEN, storeID, limitAppendStr, name, phone, operation, staffType];
    } else;
      
    [[QYXNetTool shareManager] postNetWithUrl:uploadUrl urlBody:nil bodyStyle:QYXBodyString header:nil response:QYXJSON success:^(id result) {
            NSInteger msgType = [result[@"msgType"] integerValue];

            switch (msgType) {
                case 0:
                    [SVProgressHUD showSuccessWithStatus:@"修改成功"];
                    changeSuccessAndViewDisapper(YES);
                    [self.navigationController popViewControllerAnimated:YES];
                    if (_changStaffInfoSccess) {
                        _changStaffInfoSccess(YES);
                    }break;
                case 1:
                    [SVProgressHUD showErrorWithStatus:@"操作异常"];
                    break;
                case 2:
                    [SVProgressHUD showErrorWithStatus:@"该号码已经被注册"];
                    break;
                case 3:
                    [SVProgressHUD showErrorWithStatus:@"您是店主，无法添加自己"];
                    break;
                case 4:
                    [SVProgressHUD showErrorWithStatus:@"本店已有员工使用此号码"];
                    break;

                default:
                    break;
            }
    } failure:^(NSError *error) {

    }];
}
#pragma mark -----  查询老板权限  入驻前后？老板？员工？---
- (void)searchStaffPower{

    NSDictionary *dic = [NSKeyedUnarchiver unarchiveObjectWithData:[[NSUserDefaults standardUserDefaults] objectForKey:LocationLoginInResultsKey]];

    LoginInfoModel *model = [LoginInfoModel mj_objectWithKeyValues:dic];
    NSString *isBoss = [model.isBoss isNull] ? [NSString stringWithFormat:@"%d", _model.isBoss] : model.isBoss;
    NSString *userId = model.id;
    NSString *keyUrl = @"api/merchant/searchFeatures";
    NSString *flag = @"is_kitchen_man                                                                                                                                                                                 age";
    NSString *loadUrl = [NSString stringWithFormat:@"%@%@?token=%@&storeId=%@&flag=%@&isBoss=%@&userId=%@", kBaseURL, keyUrl, TOKEN, storeID, flag, isBoss, userId];
//
//    NSString *keyUrl = @"api/merchant/searchFeatures";
//    NSString *flag = @"is_order_manage";
//    NSString *isBoss = _model.isBoss == YES ? @"0" : @"1";
//    NSString *loadUrl = [NSString stringWithFormat:@"%@%@?token=%@&storeId=%@&flag=%@&isBoss=%@", kBaseURL, keyUrl, TOKEN, storeID, flag, isBoss];

      
    [[QYXNetTool shareManager] postNetWithUrl:loadUrl urlBody:nil bodyStyle:QYXBodyString header:nil response:QYXJSON success:^(id result) {
        if ([result[@"msgType"] integerValue] == 0) {
            //权限判断 0 有权限 1无权限 2失败
            StuffAccountModel *model = [StuffAccountModel mj_objectWithKeyValues:result[@"obj"]];
                _quanxianary =[NSMutableArray arrayWithArray:@[model.isOrderManage, model.isServiceManage, model.isKitchenManage, @"1", @"1",@"1"]];
                [MineTableview reloadData];
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
