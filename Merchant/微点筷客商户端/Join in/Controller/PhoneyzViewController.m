//
//  PhoneyzViewController.m
//  微点筷客商户端
//
//  Created by 张森森 on 16/10/25.
//  Copyright © 2016年 张森森. All rights reserved.
//

#import "PhoneyzViewController.h"
#import "UIBarButtonItem+SSExtension.h"
#import <QuartzCore/QuartzCore.h>
#import "RevisePhoneViewController.h"
#import "ChangeBankViewController.h"
#import "MBProgressHUD+SS.h"
#import "QYXNetTool.h"
#import "FirsttixianViewController.h"
#import "ChangetixianViewController.h"
#import "AlipayViewController.h"
#import "NewpsdViewController.h"
@interface PhoneyzViewController ()<UITextFieldDelegate>
@property (nonatomic,strong)UIButton * mimaBtn;
@property (nonatomic,strong)UITextField*textfild;
@end

@implementation PhoneyzViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.titleView.text = @"手机验证";
    self.view.backgroundColor= RGB(242, 242, 242);
    self.automaticallyAdjustsScrollViewInsets = NO;


    CGFloat height = [[UIApplication sharedApplication] statusBarFrame].size.height + self.navigationController.navigationBar.frame.size.height;
    NSString * str = [_phonestr substringFromIndex:7];
    //    NSLog(@"klk%@",str);
    UILabel * phonelabel = [[UILabel alloc]init];
    phonelabel.text = [NSString stringWithFormat:@"正向%@%@发送验证码:",@"****",str];
    phonelabel.font = [UIFont systemFontOfSize:autoScaleW(13)];
    phonelabel.textColor = [UIColor blackColor];
    [self.view addSubview:phonelabel];
    phonelabel.sd_layout.leftSpaceToView(self.view,autoScaleH(15)).topSpaceToView(self.view,autoScaleH(10)+height).widthIs(kScreenWidth-autoScaleW(30)).heightIs(autoScaleH(15));

    UIView * codeveiw =[[UIView alloc]init];
    codeveiw.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:codeveiw];
    codeveiw.sd_layout.leftSpaceToView(self.view,0).topSpaceToView(phonelabel,autoScaleH(10)).widthIs(kScreenWidth).heightIs(autoScaleH(45));
    UILabel * linlabb =[[UILabel alloc]init];
    linlabb.backgroundColor = UIColorFromRGB(0xeeeeee);
    [codeveiw addSubview:linlabb];
    linlabb.sd_layout.leftSpaceToView(codeveiw,0).rightSpaceToView(codeveiw,0).bottomSpaceToView(codeveiw,0).heightIs(0.5);
    UILabel * linlab =[[UILabel alloc]init];
    linlab.backgroundColor = UIColorFromRGB(0xeeeeee);
    [codeveiw addSubview:linlab];
    linlab.sd_layout.leftSpaceToView(codeveiw,0).rightSpaceToView(codeveiw,0).topSpaceToView(codeveiw,0).heightIs(0.5);

    UILabel* _leftlabel = [[UILabel alloc]init];
    _leftlabel.font = [UIFont systemFontOfSize:autoScaleW(13)];
    _leftlabel.text = @"验证码";
    _leftlabel.textAlignment = NSTextAlignmentLeft;
    [codeveiw addSubview:_leftlabel];
    _leftlabel.sd_layout.leftSpaceToView(self,autoScaleW(15)).topSpaceToView(self,autoScaleH(15)).widthIs(autoScaleW(120)).heightIs(autoScaleH(15));

    _textfild =[[UITextField alloc]init];
    _textfild.placeholder = @"请输入验证码";
    _textfild.delegate = self;
    _textfild.font = [UIFont systemFontOfSize:autoScaleW(13)];
    //    _textfild.clearButtonMode = UITextFieldViewModeWhileEditing;
    _textfild.keyboardType = UIKeyboardTypeNamePhonePad;
    [codeveiw addSubview:_textfild];
    _textfild.sd_layout.leftSpaceToView(_leftlabel,0).topSpaceToView(self,autoScaleH(15)).widthIs(autoScaleW(200)).heightIs(autoScaleH(15));

    _mimaBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _mimaBtn.titleLabel.font = [UIFont systemFontOfSize:autoScaleW(13)];
    [_mimaBtn setTitleColor:UIColorFromRGB(0xfd7577) forState:UIControlStateNormal];
    [_mimaBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
    [_mimaBtn sizeToFit];
    _mimaBtn.layer.borderWidth = 1.0f;
    _mimaBtn.layer.borderColor = [UIColorFromRGB(0xfd7577) CGColor];
    [_mimaBtn addTarget:self action:@selector(Clickcode) forControlEvents:UIControlEventTouchUpInside];
    [codeveiw addSubview:_mimaBtn];
    _mimaBtn.sd_layout.rightSpaceToView(codeveiw,autoScaleW(15)).topSpaceToView(codeveiw,autoScaleH(10)).widthIs(autoScaleW(80)).heightIs(autoScaleH(25));

    [self Regist];

    ButtonStyle * loginbtn = [ButtonStyle buttonWithType:UIButtonTypeCustom];
    [loginbtn setTitle:@"下一步" forState:UIControlStateNormal];
    loginbtn.titleLabel.font = [UIFont systemFontOfSize:autoScaleW(15)];
    [loginbtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    loginbtn.backgroundColor = UIColorFromRGB(0xfd7577);
    [loginbtn addTarget:self action:@selector(Next) forControlEvents:UIControlEventTouchUpInside];
    loginbtn.layer.masksToBounds = YES;
    loginbtn.layer.cornerRadius = autoScaleW(3);
    [self.view addSubview:loginbtn];
    loginbtn.sd_layout.leftSpaceToView(self.view,autoScaleW(15)).rightSpaceToView(self.view,autoScaleW(15)).topSpaceToView(codeveiw,autoScaleH(15)).heightIs(autoScaleH(30));

}
-(void)Next
{
    [MBProgressHUD showMessage:@"请稍等"];
    NSString *uploadUrl = [NSString stringWithFormat:@"%@common/validateSms?code=%@&phone=%@",kBaseURL,_textfild.text,_phonestr];

    [[QYXNetTool shareManager] postNetWithUrl:uploadUrl urlBody:nil bodyStyle:QYXBodyString header:nil response:QYXJSON success:^(id result) {
        NSString * codestr= [NSString stringWithFormat:@"%@",[result objectForKey:@"msgType"]];
        if ([codestr isEqualToString:@"0"]) {
            [MBProgressHUD hideHUD];
            if (_tiaointeger==1) {//修改手机号

                RevisePhoneViewController * revisrview = [[RevisePhoneViewController alloc]init];
                [self.navigationController pushViewController:revisrview animated:YES];
            }
           else if (_tiaointeger==2) {//修改银行卡号
                ChangeBankViewController * changebanview = [[ChangeBankViewController alloc]init];
                changebanview.xianinteger = _xianinteger;
                [self.navigationController pushViewController:changebanview animated:YES];

            }
           else if (_tiaointeger==3)// 绑定银行卡号
            {
                FirsttixianViewController * firstview = [[FirsttixianViewController alloc]init];
                firstview.xianshiint = _xianinteger;
                firstview.pushinter = 2;
                [self.navigationController pushViewController:firstview animated:YES];
            }
           else if (_tiaointeger==4) {//修改，绑定银行卡号

//                ChangetixianViewController * changetixianview = [[ChangetixianViewController alloc]init];
//                changetixianview.tiaointer = 2;
//                [self.navigationController pushViewController:changetixianview animated:YES];
                AlipayViewController * alipayview = [[AlipayViewController alloc]init];
                [self.navigationController pushViewController:alipayview animated:YES];
            }
           else if (_tiaointeger==5){//重新设置提现密码
               
               NewpsdViewController * newPasVC = [[NewpsdViewController alloc]init];
               [self.navigationController pushViewController:newPasVC animated:YES];
           }
        }
        else
        {   [MBProgressHUD hideHUD];
            [MBProgressHUD showError:@"验证码错误"];
        }


    } failure:^(NSError *error)
     {
         [MBProgressHUD hideHUD];
         [MBProgressHUD showError:@"网络错误"];

     }];

}
-(void)textFieldDidBeginEditing:(UITextField *)textField{
    
    [textField bringSubviewToFront:_mimaBtn];
}

-(void)Clickcode
{
    
    [self Regist];
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return autoScaleH(45);
}

-(void)Regist
{
    MessageCodeView *messageView = [[MessageCodeView alloc] initShouldVertifyPhoneNum:NO phoneNumber:nil];
    [messageView showView];

    messageView.complete = ^(NSString *code){

        if (![_phonestr isEqualToString:@""]) {
            [MBProgressHUD showMessage:@"请稍后"];

            NSString *uploadUrl = [NSString stringWithFormat:@"%@common/sendSms?phone=%@&inputCode=%@", kBaseURL, [ZT3DesSecurity encryptWithText:_phonestr], code];
              
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
                _mimaBtn.titleLabel.font = [UIFont systemFontOfSize:autoScaleW(13)];
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
                [_mimaBtn setTitle:[NSString stringWithFormat:@"%@s",strTime] forState:UIControlStateNormal];
                _mimaBtn.titleLabel.font = [UIFont systemFontOfSize:autoScaleW(15)];
                _mimaBtn.titleLabel.adjustsFontSizeToFitWidth = YES;
                [UIView commitAnimations];
                _mimaBtn.userInteractionEnabled = NO;            });
            timeout--;
        }
    });
    dispatch_resume(_timer);



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
