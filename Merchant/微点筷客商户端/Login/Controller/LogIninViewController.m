//
//  LogIninViewController.m
//  微点筷客商户端
//
//  Created by 张森森 on 16/9/30.
//  Copyright © 2016年 张森森. All rights reserved.
//

#import "LogIninViewController.h"
#import "UIBarButtonItem+SSExtension.h"
#import "LoginTableViewCell.h"
#import "ForgetViewController.h"
#import "ErectViewController.h"
#import "QYXNetTool.h"
#import "MBProgressHUD+SS.h"
#import "HomeVC.h"
#import "RootViewController.h"
#import "AuthcodeViewController.h"
#import "VerifyViewController.h"
#import "SystemViewController.h"
#import "StuffAccountModel.h"
#import "DeviceSet.h"
#import <ImageIO/ImageIO.h>
#import "ZTMd5Security.h"
#import "UIButton+UnderlineNone.h"
@interface LogIninViewController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>
@property(nonatomic,strong)NSArray * titleary,*placeary;
@property (nonatomic,strong)UIButton * mimaBtn;
@property (nonatomic,strong)UITableView * yanzhengtableview;
@property (nonatomic,strong)ButtonStyle * daitibtn;
@property (nonatomic,strong)UITextField * firsttext;

@end

@implementation LogIninViewController

static int i=0;
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden =NO;
    //    if (_registLogName != nil) {
    //        [self.navigationItem setHidesBackButton:YES];
    //    }
    _registLogName = [DeviceSet readKeychainValue:@"account"];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.automaticallyAdjustsScrollViewInsets = NO;

    self.titleView.text = @"手机验证";
    self.view.backgroundColor = RGB(242, 242, 242);
    //    self.leftBarItem.hidden = YES;
    //注销后，自动填写上次登录帐号
    //    if (_registLogName == nil) {
    //        self.leftBarItem.hidden = NO;
    //    }
    CGFloat height = [[UIApplication sharedApplication] statusBarFrame].size.height + self.navigationController.navigationBar.frame.size.height;

    _yanzhengtableview = [[UITableView alloc]init];
    //    yanzhengtableview.scrollEnabled = NO
    _yanzhengtableview.delegate = self;
    _yanzhengtableview.dataSource = self;
    _yanzhengtableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_yanzhengtableview];
    _yanzhengtableview.sd_layout.leftSpaceToView(self.view,0).topSpaceToView(self.view,autoScaleH(15)+height).widthIs(kScreenWidth).heightIs(autoScaleH(90));

    _titleary = @[@"手机号",@"验证码",];
    _placeary = @[@"请输入手机号",@"请输入验证码",];

    ButtonStyle * loginbtn = [ButtonStyle buttonWithType:UIButtonTypeCustom];
    [loginbtn setTitle:@"登录系统" forState:UIControlStateNormal];
    loginbtn.titleLabel.font = [UIFont systemFontOfSize:autoScaleW(15)];
    [loginbtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    loginbtn.backgroundColor = UIColorFromRGB(0xfd7577);
    [loginbtn addTarget:self action:@selector(Login) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:loginbtn];
    loginbtn.sd_layout.leftSpaceToView(self.view,autoScaleW(20)).rightSpaceToView(self.view,autoScaleW(20)).topSpaceToView(_yanzhengtableview,autoScaleH(15)).heightIs(autoScaleH(40));

    NSArray * btntitleary = @[@"验证码登录",@"密码登录",];

    for (int i=0; i<2; i++) {

        ButtonStyle * choosebtn = [ButtonStyle buttonWithType:UIButtonTypeCustom];
        [choosebtn setTitle:btntitleary[i] forState:UIControlStateNormal];
        [choosebtn setTitleColor:UIColorFromRGB(0xfd7577) forState:UIControlStateSelected];
        [choosebtn  setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        choosebtn.titleLabel.font = [UIFont systemFontOfSize:autoScaleW(13)];
        choosebtn.tag = 100 +i;
        if (i==0) {
            choosebtn.selected = YES;
            _daitibtn = choosebtn;
        }
        [choosebtn addTarget:self action:@selector(Choose:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:choosebtn];
        CGFloat width = 140;
        CGFloat space = 20 * 2;
        CGFloat height = 15;
        if (isPadd) {
            width = 180;
            space = 40 * 2;
            height = 45;
        }
        CGFloat start_x = (self.view.size.width - width * 2 - space ) / 2;

        choosebtn.sd_layout
        .leftSpaceToView(self.view,(start_x)+i*(width + space))
        .topSpaceToView(loginbtn,(20))
        .widthIs((width))
        .heightIs((height));
    }
    UILabel *linlabel = [[UILabel alloc]init];
    linlabel.backgroundColor =[UIColor lightGrayColor];
    [self.view addSubview:linlabel];
    linlabel.sd_layout.centerXEqualToView(self.view).centerYEqualToView([self.view viewWithTag:100]).widthIs(1).heightIs(autoScaleH(20));


    ButtonStyle * wangjibtn = [ButtonStyle buttonWithType:UIButtonTypeCustom];
    [wangjibtn setTitle:@"忘记密码?" forState:UIControlStateNormal];
    [wangjibtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    wangjibtn .titleLabel.font = [UIFont systemFontOfSize:autoScaleW(12)];
    [wangjibtn addTarget:self action:@selector(Wangji) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:wangjibtn];
    wangjibtn.sd_layout.rightEqualToView(loginbtn).topSpaceToView(linlabel,autoScaleH(25)).widthIs(autoScaleW(70)).heightIs(autoScaleH(15));

    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(Down)];
    [self.view addGestureRecognizer:tap];

}
-(void)setLeftBarItem:(ButtonStyle *)leftBarItem{
    [super setLeftBarItem:leftBarItem];
}
-(void)Down
{
    [self.view endEditing:YES];
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    LoginTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"login"];
    if (!cell) {
        cell =[[LoginTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"login"];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    UILabel * linlab =[[UILabel alloc]init];
    linlab.backgroundColor = UIColorFromRGB(0xeeeeee);
    [cell addSubview:linlab];
    linlab.sd_layout.leftSpaceToView(cell,0).rightSpaceToView(cell,0).bottomSpaceToView(cell,0).heightIs(0.5);

//    cell.textfild.delegate = self;
    if (indexPath.row==1)
    {
        _mimaBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _mimaBtn.titleLabel.font = [UIFont systemFontOfSize:autoScaleW(12)];
        [_mimaBtn setTitleColor:UIColorFromRGB(0xfd7577) forState:UIControlStateNormal];
        [_mimaBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
        [_mimaBtn sizeToFit];
        _mimaBtn.layer.borderWidth = 1.0f;
        _mimaBtn.layer.borderColor = [UIColorFromRGB(0xfd7577) CGColor];
        [_mimaBtn addTarget:self action:@selector(Regist) forControlEvents:UIControlEventTouchUpInside];
        [cell addSubview:_mimaBtn];
        _mimaBtn.sd_layout.rightSpaceToView(cell,autoScaleW(15)).topSpaceToView(cell,autoScaleH(10)).widthIs(autoScaleW(80)).heightIs(autoScaleH(25));

        cell.textfild.secureTextEntry = YES;
    }
    cell.leftlabel.text = _titleary[indexPath.row];
    if (indexPath.row==0) {

        cell.textfild.keyboardType = UIKeyboardTypeNumberPad;
        _firsttext = cell.textfild;
    }
    cell.textfild.placeholder = _placeary[indexPath.row];
    //注销后，自动填写上次登录帐号
    if (_registLogName != nil && indexPath.row == 0 && [cell.textfild.text isNull]) {
        cell.textfild.text = _registLogName;
    }
    if (indexPath.row == 0) {
        cell.textfild.text = [DeviceSet readKeychainValue:@"account"];
    }

    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return autoScaleH(45);
}
#pragma mark 选择登录方式
-(void)Choose:(ButtonStyle *)btn
{
    _daitibtn.selected = NO;
    btn.selected = YES;
    _daitibtn = btn;

    NSIndexPath * index = [NSIndexPath indexPathForRow:1 inSection:0];

    LoginTableViewCell * cell = [_yanzhengtableview cellForRowAtIndexPath:index];

    if (btn.tag==100) {

        cell.leftlabel.text = @"验证码";
        cell.textfild.placeholder = @"请输入验证码";

        _mimaBtn.hidden = NO;
        cell.textfild.text = @"";
        cell.textfild.keyboardType = UIKeyboardTypeNumberPad;
    }
    if (btn.tag==101)
    {
        cell.leftlabel.text = @"密码";
        cell.textfild.placeholder = @"请输入登录密码";
        _mimaBtn.hidden = YES;
        cell.textfild.keyboardType = UIKeyboardTypeDefault;
        cell.textfild.text = [DeviceSet readKeychainValue:@"pwd"];

    }
}
#pragma mark 忘记密码
-(void)Wangji
{
    ForgetViewController * forgetview = [[ForgetViewController alloc]init];
    [self.navigationController pushViewController:forgetview animated:YES];
}
#pragma mark 返回
-(void)leftBarButtonItemAction
{
    [self.navigationController popViewControllerAnimated:YES];

}
//获取验证码
-(void)Regist
{
    MessageCodeView *messageView = [[MessageCodeView alloc] initShouldVertifyPhoneNum:NO phoneNumber:nil];
    [messageView showView];

    messageView.complete = ^(NSString *code){

        NSIndexPath * index1 = [NSIndexPath indexPathForRow:0 inSection:0];
        LoginTableViewCell * cell1 = [_yanzhengtableview cellForRowAtIndexPath:index1];

        if (![cell1.textfild.text isEqualToString:@""]) {
            [MBProgressHUD showMessage:@"请稍后"];

            NSString *uploadUrl = [NSString stringWithFormat:@"%@common/sendSms?phone=%@&inputCode=%@", kBaseURL, [ZT3DesSecurity encryptWithText:cell1.textfild.text], code];
              
            [[QYXNetTool shareManager] postNetWithUrl:uploadUrl urlBody:nil bodyStyle:QYXBodyString header:nil response:QYXJSON success:^(id result) {
                [MBProgressHUD hideHUD];
                if ([result[@"msgType"] integerValue] == 0) {
                    [self startTime];
                } else {
                    [MBProgressHUD showError:@"发送失败" toView:self.view];
                }

            } failure:^(NSError *error) {
                [MBProgressHUD hideHUD];
            }];

        }
        else
        {
            [MBProgressHUD showError:@"手机号不能为空！"];
            
        }

    };

}
#pragma mark 倒计时
-(void)startTime
{
    __block int timeout=60; //倒计时时间
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
    dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
    dispatch_source_set_event_handler(_timer, ^{
        if(timeout<=0){ //倒计时结束，关闭
            dispatch_source_cancel(_timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置界面的按钮显示 根据自己需求设置
                [_mimaBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
                _mimaBtn.userInteractionEnabled = YES;
            });
        }else
        {
            int seconds = timeout % 60;
            NSString *strTime = [NSString stringWithFormat:@"%.2d", seconds];
            if ([strTime isEqualToString:@"00"]) {
                
                strTime = @"60";
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置界面的按钮显示 根据自己需求设置
                [UIView beginAnimations:nil context:nil];
                [UIView setAnimationDuration:1];
                [_mimaBtn setTitle:[NSString stringWithFormat:@"%@秒后重新发送",strTime] forState:UIControlStateNormal];
                _mimaBtn.titleLabel.font = [UIFont systemFontOfSize:autoScaleW(12)];
                _mimaBtn.titleLabel.adjustsFontSizeToFitWidth = YES;
                [UIView commitAnimations];
                _mimaBtn.userInteractionEnabled = NO;
            });
            timeout--;
        }
    });
    dispatch_resume(_timer);



}
#pragma mark 登录
-(void)Login
{

    //    HomeVC * homeview = [[HomeVC alloc]init];
    //    [self.navigationController pushViewController:homeview animated:YES];

    ButtonStyle * mimabtn = (ButtonStyle *)[self.view viewWithTag:101];
    ButtonStyle * codebtn = (ButtonStyle *)[self.view viewWithTag:100];
    NSIndexPath * index = [NSIndexPath indexPathForRow:0 inSection:0];

    LoginTableViewCell * cell = [_yanzhengtableview cellForRowAtIndexPath:index];
    NSIndexPath * index1 = [NSIndexPath indexPathForRow:1 inSection:0];

    LoginTableViewCell * cell1 = [_yanzhengtableview cellForRowAtIndexPath:index1];

    if (![cell.textfild.text isEqualToString:@""]&&![cell1.textfild.text isEqualToString:@""]) {
        if (mimabtn.selected==YES) {

            NSString * url = [NSString stringWithFormat:@"%@merchant/login?loginName=%@&password=%@", kBaseURL, cell.textfild.text,[ZTMd5Security MD5ForLower32Bate:cell1.textfild.text]];

            [MBProgressHUD showMessage:@"请稍后"];
            [[QYXNetTool shareManager] postNetWithUrl:url urlBody:nil bodyStyle:QYXBodyString header:nil response:QYXJSON success:^(id result){
                [MBProgressHUD hideHUD];
                ZTLog(@"llll%@",result);
                NSString * codeStatus = [result objectForKey:@"msgType"];

                if ([codeStatus integerValue]==1002) {
                    [MBProgressHUD showError:@"验证码错误😓"];

                } else if ([codeStatus integerValue]==1003) {
                    [MBProgressHUD showError:@"密码错误"];
                } else if ([codeStatus integerValue]==1001) {
                    [MBProgressHUD showError:@"无此用户😓"];
                } else if ([codeStatus integerValue]==0) {
                    //                  [MBProgressHUD showMessage:@"登陆成功😁"];
                    [MBProgressHUD hideHUD];
                    //登录成功马上保存到钥匙串
                    [DeviceSet saveKeychainValue:cell.textfild.text key:@"account"];
                    [DeviceSet saveKeychainValue:cell1.textfild.text key:@"pwd"];
                    NSUserDefaults * userde = [NSUserDefaults standardUserDefaults];
                    NSData *archData = [NSKeyedArchiver  archivedDataWithRootObject:result[@"obj"]];
                    [userde setObject:archData forKey:LocationLoginInResultsKey];
                    [userde setObject:cell.textfild.text forKey:@"loginName"];
                    [userde setObject:result[@"obj"][@"token"] forKey:@"token"];
                    //                    NSDictionary * dict = result[@"obj"];

                    NSString * outIsChecked = _BaseModel.isChecked;

                    if (outIsChecked==nil) {
                        ZTLog(@"%@", result);
                        HomeVC *homeVC = [[HomeVC alloc] init];
                        [self presentViewController:homeVC animated:YES completion:nil];
                        self.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;

                    } else {
                        if ([outIsChecked integerValue]==-1) {
                            VerifyViewController * verifyview = [[VerifyViewController alloc]init];
                            [self.navigationController pushViewController:verifyview animated:YES];
                            verifyview.pageOffset = 0;
                            verifyview.isJohnedStatus = 1;
                        } else if ([outIsChecked integerValue]==0) {

                            VerifyViewController * verifyview = [[VerifyViewController alloc]init];
                            verifyview.pageOffset = 1;
                            verifyview.isJohnedStatus = 1;

                            [self.navigationController pushViewController:verifyview animated:YES];

                        } else if ([outIsChecked integerValue]==1) {

                            VerifyViewController * verifyview = [[VerifyViewController alloc]init];
                            verifyview.pageOffset = 2;
                            verifyview.isJohnedStatus = 1;

                            [self.navigationController pushViewController:verifyview animated:YES];
                        } else if ([outIsChecked integerValue]==2) {
                            ErectViewController * systemview = [[ErectViewController alloc]init];
                            [self.navigationController pushViewController:systemview animated:YES];
                        } else {
                            HomeVC *homeVC = [[HomeVC alloc] init];
                            [self presentViewController:homeVC animated:YES completion:nil];
                            self.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;

                        };
                    }
                }
            } failure:^(NSError *error)
             {
                 [MBProgressHUD showError:@"网络错误"];
                 [MBProgressHUD hideHUD];
             }];


        }

        if (codebtn.selected==YES) {

            NSString * url = [NSString stringWithFormat: @"%@merchant/login?loginName=%@&code=%@", kBaseURL,cell.textfild.text,cell1.textfild.text];
            [MBProgressHUD showMessage:@"请稍后"];

                
            [[QYXNetTool shareManager] postNetWithUrl:url urlBody:nil bodyStyle:QYXBodyString header:nil response:QYXJSON success:^(id result) {
                [MBProgressHUD hideHUD];
                                NSLog(@"llll%@",result);
                NSString * strr = [result objectForKey:@"msgType"];

                if ([strr integerValue]==1002) {
                    [MBProgressHUD showError:@"验证码错误😓"];
                } else if ([strr integerValue]==1003) {
                    [MBProgressHUD showError:@"密码错误"];
                } else if ([strr integerValue]==1001) {
                    [MBProgressHUD showError:@"无此用户😓"];
                } else if ([strr integerValue] == 1005){
                    [MBProgressHUD showError:@"异常错误，登录失败"];
                } else;
                //
                if ([strr integerValue]==0) {
                    NSUserDefaults * userde = [NSUserDefaults standardUserDefaults];
                    NSData *archData = [NSKeyedArchiver  archivedDataWithRootObject:result[@"obj"]];
                    [userde setObject:archData forKey:LocationLoginInResultsKey];
                    [userde setObject:cell.textfild.text forKey:@"loginName"];
                    [userde setObject:result[@"obj"][@"token"] forKey:@"token"];

                    NSString * tstr = _BaseModel.isChecked;
                    [MBProgressHUD showMessage:@"登陆成功😁"];
                    [MBProgressHUD hideHUD];

                    if (tstr == nil) {
                        ZTLog(@"%@", result);
                        HomeVC *homeVC = [[HomeVC alloc] init];
                        [self presentViewController:homeVC animated:YES completion:nil];
                        self.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;

                    } else {

                        if ([tstr integerValue]==-1) {
                            VerifyViewController * verifyview = [[VerifyViewController alloc]init];
                            verifyview.pageOffset = 0;
                            verifyview.isJohnedStatus = 1;

                            [self.navigationController pushViewController:verifyview animated:YES];

                        } else if ([tstr integerValue]==0) {

                            VerifyViewController * verifyview = [[VerifyViewController alloc]init];
                            verifyview.pageOffset = 1;
                            verifyview.isJohnedStatus = 1;

                            [self.navigationController pushViewController:verifyview animated:YES];

                        } else if ([tstr integerValue]==1) {

                            VerifyViewController * verifyview = [[VerifyViewController alloc]init];
                            verifyview.pageOffset = 2;
                            verifyview.isJohnedStatus = 1;

                            [self.navigationController pushViewController:verifyview animated:YES];
                        } else if ([tstr integerValue]==2) {
                            ErectViewController * systemview = [[ErectViewController alloc]init];
                            [self.navigationController pushViewController:systemview animated:YES];

                        } else if ([tstr integerValue]==3) {
                            HomeVC *homeVC = [[HomeVC alloc] init];
                            [self presentViewController:homeVC animated:YES completion:nil];
                            self.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
                        } else;

                    }
                }
                [MBProgressHUD hideHUD];

            } failure:^(NSError *error)
             {
                 [MBProgressHUD hideHUD];
                 [MBProgressHUD showError:@"网络错误"];

             }];
        }
    } else {
        if (i==3) {
            __weak typeof(self) weakSelf = self;

            AuthcodeViewController * authcodeView = [[AuthcodeViewController alloc]init];
            authcodeView.modalPresentationStyle = UIModalPresentationOverCurrentContext ;
            [weakSelf presentViewController:authcodeView animated:YES completion:^{

                i=0;

            }];
        }
        UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"信息不能为空" preferredStyle:UIAlertControllerStyleAlert];
        __weak UIAlertAction * cancel = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:nil];

        [alert addAction:cancel];

        [self presentViewController:alert animated:YES completion:nil];
    }



}


-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSString * tobestring = [textField.text stringByReplacingCharactersInRange:range withString:string];
    if (_firsttext == textField) {
        if ([tobestring length]>11) {

            textField.text = [tobestring substringToIndex:11];
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"超过最大字数不能输入了" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil] ;
            [alert show];

            return NO;

        }

        if ([tobestring length]==11) {


            NSString * MOBILE = @"^1(3[0-9]|5[0-35-9]|8[025-9])\\d{8}$";
            NSString * CM = @"^1(34[0-8]|(3[5-9]|5[017-9]|8[278])\\d)\\d{7}$";
            NSString * CU = @"^1(3[0-2]|5[256]|8[56])\\d{8}$";
            NSString * CT = @"^1((33|53|8[09])[0-9]|349)\\d{7}$";
            NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
            NSPredicate *regextestcm = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM];
            NSPredicate *regextestcu = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU];
            NSPredicate *regextestct = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT];

            if (([regextestmobile evaluateWithObject:tobestring] == YES)
                || ([regextestcm evaluateWithObject:tobestring] == YES)
                || ([regextestct evaluateWithObject:tobestring] == YES)
                || ([regextestcu evaluateWithObject:tobestring] == YES))
            {
                return YES;
            }
            else
            {
                UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请输入正确的手机号码" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                
                [alert show];
                return NO;
            }
            
            
        }
        
        
        
    }
    return YES;
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
