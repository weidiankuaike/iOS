//
//  AddStaffPhoneCodeVC.m
//  微点筷客商户端
//
//  Created by Skyer God on 17/1/11.
//  Copyright © 2017年 张森森. All rights reserved.
//

#import "AddStaffPhoneCodeVC.h"
#import "PersonalViewController.h"
#import "MBProgressHUD+SS.h"
@interface AddStaffPhoneCodeVC ()<UITextFieldDelegate>
{
    UITextField *_textField;
    UIButton *timeBT;
}
@end

@implementation AddStaffPhoneCodeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.titleView.text = @"手机验证";
    self.rightBarItem.hidden = YES;
    self.view.backgroundColor =RGB(238, 238, 238);

    [self createView];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self timeBTClick:timeBT];
    });


}
-(void)leftBarButtonItemAction{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)createView{
    UILabel *titileLabel = [[UILabel alloc] init];
    NSString *cutStr = [_phoneNum substringFromIndex:7];
    titileLabel.text = [NSString stringWithFormat:@"正向员工手机号*******%@发送验证码:", cutStr];
    titileLabel.font = [UIFont systemFontOfSize:15];
    titileLabel.textColor = [UIColor grayColor];
    [self.view addSubview:titileLabel];

    titileLabel.sd_layout
    .leftSpaceToView(self.view, 15)
    .topSpaceToView(self.view, 20 + 64)
    .heightIs(30);
    [titileLabel setSingleLineAutoResizeWithMaxWidth:300];

    UIView *backView = [[UIView alloc] init];
    backView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:backView];
    backView.sd_layout
    .leftEqualToView(self.view)
    .topSpaceToView(titileLabel, 2)
    .rightEqualToView(self.view)
    .heightIs(40);

    backView.layer.borderWidth = 0.4;
    backView.layer.borderColor = [[UIColor blackColor] colorWithAlphaComponent:0.5].CGColor;


    UILabel *vertifityLabel = [[UILabel alloc] init];
    vertifityLabel.textColor = titileLabel.textColor;
    vertifityLabel.font = [UIFont systemFontOfSize:16];
    vertifityLabel.text = @"验证码:";
    [backView addSubview:vertifityLabel];

    vertifityLabel.sd_layout
    .leftSpaceToView(backView, 15)
    .centerYEqualToView(backView)
    .heightRatioToView(backView, 1);
    [vertifityLabel setSingleLineAutoResizeWithMaxWidth:100];

    _textField = [[UITextField alloc] init];
    _textField.textColor = [UIColor lightGrayColor];
    _textField.font = [UIFont systemFontOfSize:14];
    //    textField.enabled = NO;
    _textField.placeholder = @"请输入验证码";
    _textField.delegate = self;
    [backView addSubview:_textField];
    _textField.sd_layout
    .leftSpaceToView(vertifityLabel, 5)
    .centerYEqualToView(vertifityLabel)
    .widthRatioToView(self.view, 0.4)
    .heightRatioToView(vertifityLabel, 1);

    timeBT = [UIButton buttonWithType:UIButtonTypeCustom];
    [timeBT setTitle:@"获取验证码" forState:UIControlStateNormal];
    [timeBT.titleLabel setFont:[UIFont systemFontOfSize:14]];
    [timeBT setTitleColor:UIColorFromRGB(0xfd7577) forState:UIControlStateNormal];
    [timeBT addTarget:self action:@selector(timeBTClick:) forControlEvents:UIControlEventTouchUpInside];
    [backView addSubview:timeBT];

    timeBT.sd_layout
    .rightSpaceToView(backView, 15)
    .centerYEqualToView(backView);
    [timeBT setupAutoSizeWithHorizontalPadding:10 buttonHeight:30];
    [timeBT setSd_cornerRadiusFromHeightRatio:@(0.1)];
    timeBT.layer.borderWidth = 0.5;
    timeBT.layer.borderColor = [UIColor blackColor].CGColor;

    UIButton *saveBT = [UIButton buttonWithType:UIButtonTypeCustom];
    [saveBT setBackgroundColor:UIColorFromRGB(0xfd7577)];
    [saveBT setTitle:@"完成" forState:UIControlStateNormal];
    [saveBT addTarget:self action:@selector(saveBTClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:saveBT];

    saveBT.sd_layout
    .leftSpaceToView(self.view, 8)
    .rightSpaceToView(self.view, 8)
    .topSpaceToView(backView, 50)
    .heightIs(45);

}
- (void)timeBTClick:(UIButton *)sender{
    if ([sender.titleLabel.text containsString:@"s"]) {
        return;
    }

    [sender setTitle:@"获取验证码" forState:UIControlStateNormal];
    MessageCodeView *messageView = [[MessageCodeView alloc] initShouldVertifyPhoneNum:NO phoneNumber:nil];
    [messageView showView];

    messageView.complete = ^(NSString *code){

        if (_phoneNum) {
            [MBProgressHUD showMessage:@"请稍后"];

            NSString *keyUrl = @"sendSmsStaffCode";
            NSString *phone = _phoneNum;
            NSString *staffName = _staffName;
            NSString *storeName = _BaseModel.storeBase.storeManager;//dic[@"storeBase"][@"storeManager"];
            NSString *name = _BaseModel.name;

            NSString *uploadUrl = [NSString stringWithFormat:@"%@%@?token=%@&storeId=%@&phone=%@&staffName=%@&storeName=%@&name=%@&inputCode=%@", kBaseURL, keyUrl, TOKEN, storeID, [ZT3DesSecurity encryptWithText:phone], staffName, storeName, name, code];

            [[QYXNetTool shareManager] postNetWithUrl:uploadUrl urlBody:nil bodyStyle:QYXBodyString header:nil response:QYXJSON success:^(id result) {
                [MBProgressHUD hideHUD];
                if ([result[@"msgType"] integerValue] == 0) {
                    [MBProgressHUD showMessage:@"短信已发送"];
                    [MBProgressHUD hideHUD];
                    __block NSInteger timeOut = 60; //倒计时时间
                    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
                    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
                    dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
                    dispatch_source_set_event_handler(_timer, ^{
                        if(timeOut <= 0 ){ //倒计时结束，关闭
                            dispatch_source_cancel(_timer);
                            dispatch_async(dispatch_get_main_queue(), ^{
                                //设置界面的按钮显示 根据自己需求设置
                                [sender setTitle:@"获取验证码" forState:UIControlStateNormal];
                            });
                        } else {
                            dispatch_async(dispatch_get_main_queue(), ^{
                                //设置界面的按钮显示 根据自己需求设置
                                [sender setTitle:[NSString stringWithFormat:@"%lds后重新发送", (long)timeOut] forState:UIControlStateNormal];
                                
                            });
                            timeOut --;
                        }
                    });
                    dispatch_resume(_timer);
                    [sender setupAutoSizeWithHorizontalPadding:10 buttonHeight:30];
                } else {
                    [MBProgressHUD showError:@"发送失败" toView:self.view];
                }
            } failure:^(NSError *error) {
                [MBProgressHUD hideHUD];
            }];
        } else {
            [MBProgressHUD showError:@"手机号不能为空！"];
        }
    };

}
- (void)saveBTClick:(ButtonStyle *)sender{
    if ([_textField.text isNull]) {
        UIAlertController *alerController = [UIAlertController alertControllerWithTitle:@"信息为空" message:@"请补全信息！" preferredStyle:UIAlertControllerStyleAlert];
        [self presentViewController:alerController animated:YES completion:^{
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self dismissViewControllerAnimated:YES completion:nil];
            });
        }];
        return;
    }
    [self uploadCodeToservice];
}
//获取验证码
- (void)uploadData:(NSString *)code{
    NSString *keyUrl = @"sendSmsStaffCode";
    NSString *phone = _phoneNum;
    NSString *staffName = _staffName;
    NSString *storeName = _BaseModel.storeBase.storeManager;//dic[@"storeBase"][@"storeManager"];
    NSString *name = _BaseModel.name;

    NSString *uploadUrl = [NSString stringWithFormat:@"%@%@?token=%@&storeId=%@&phone=%@&staffName=%@&storeName=%@&name=%@&inputCode=%@", kBaseURL, keyUrl, TOKEN, storeID, phone, staffName, storeName, name, code];

      
    [[QYXNetTool shareManager] postNetWithUrl:uploadUrl urlBody:nil bodyStyle:QYXBodyString header:nil response:QYXJSON success:^(id result) {
        if ([result[@"msgType"] integerValue] == 0) {
            [SVProgressHUD showSuccessWithStatus:@"短信已发送"];
        }
    } failure:^(NSError *error) {


    }];

}
- (void)uploadCodeToservice{
    NSString *keyUrl = @"common/validateSms";
    NSString *phone = _phoneNum;
    NSString *code = _textField.text;
    NSString *uploadUrl = [NSString stringWithFormat:@"%@%@?token=%@&storeId=%@&phone=%@&code=%@", kBaseURL, keyUrl, TOKEN, storeID, phone, code];

      
    [SVProgressHUD showInfoWithStatus:@"加载中..."];
    [[QYXNetTool shareManager] postNetWithUrl:uploadUrl urlBody:nil bodyStyle:QYXBodyString header:nil response:QYXJSON success:^(id result) {
        if ([result[@"msgType"] integerValue] == 0) {
            [SVProgressHUD showSuccessWithStatus:@"验证成功"];
           [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:([self.navigationController.viewControllers count] -2)] animated:YES];
            if (_vertiftSuccess) {
                _vertiftSuccess(YES);
            }
        } else {
            [SVProgressHUD showErrorWithStatus:@"验证码错误"];
        }
    } failure:^(NSError *error) {
        
        
    }];

}
#pragma mark -- utiextfiled delegate ------
- (void)textFieldDidBeginEditing:(UITextField *)textField{

}
- (void)textFieldDidEndEditing:(UITextField *)textField{

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
