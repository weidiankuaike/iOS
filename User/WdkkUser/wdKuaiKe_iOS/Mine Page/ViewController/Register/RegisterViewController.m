//
//  RegisterViewController.m
//  WDKKtest
//
//  Created by 张森森 on 16/8/4.
//  Copyright © 2016年 weiDianKuaiKe. All rights reserved.
//

#import "RegisterViewController.h"
#import "LLHConst.h"
#import "NSString+Expend.h"
#import "MBProgressHUD+SS.h"
#import "NetworkSingleton.h"
#import "SecurityUtil.h"
#import "SSHttpTool.h"
#import "QYXNetTool.h"
#import "AgreementVC.h"
#import "ZT3DesSecurity.h"
#import "MessageCodeView.h"
@interface RegisterViewController ()<UITextFieldDelegate>
{
    UITextField * phonetext;
}
@property(nonatomic,strong)UIButton * mimaBtn;
@property(nonatomic,strong)UIButton * chooseBtn;
@property (nonatomic,retain)dispatch_source_t timer;
@end
@implementation RegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //设置背景图片
    UIImageView * backgroundImag =[[UIImageView alloc]init];
    backgroundImag.image = [UIImage imageNamed:@"矩形-1"];
    
    backgroundImag.frame = CGRectMake(0, 0, GetWidth, GetHeight);
    [self.view addSubview:backgroundImag];
    //返回按钮
    UIButton * backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [backBtn setImage:[UIImage imageNamed:@"形状-1"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(Back) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backBtn];
    backBtn.sd_layout.leftSpaceToView(self.view,kWidth(15)).topSpaceToView(self.view,kHeight(20)).widthIs(kWidth(30)).heightIs(kHeight(20));
    
    // 设置输入框
    NSArray * placeary = @[@"请输入手机号",@"请输入短信验证码",@"请输入密码",@"确认密码",];
    NSArray * imageary = @[@"手机-(1)",@"验证码",@"密码",@"密码",];
    
    for (int i =0; i<4; i++) {
        phonetext = [[UITextField alloc]init];
        phonetext.backgroundColor = [UIColor clearColor];
        phonetext.tag = 100+i;
        phonetext.placeholder = placeary[i];
        phonetext.font = [UIFont systemFontOfSize:autoScaleW(12)];
        [phonetext setValue:UIColorFromRGB(0xB9B9B9) forKeyPath:@"_placeholderLabel.textColor"];
        phonetext.textColor = UIColorFromRGB(0xFFFFFF);
        phonetext.textAlignment = NSTextAlignmentCenter;
        phonetext.delegate = self;
        phonetext.clearsOnBeginEditing = YES;
        if (phonetext.tag==100||phonetext.tag==101) {
            
            [phonetext setKeyboardType:UIKeyboardTypeNumberPad];
        }
        if (phonetext.tag==102||phonetext.tag==103) {
            
            [phonetext setKeyboardType:UIKeyboardTypeASCIICapable];
        }
        

        [self.view addSubview:phonetext];
        phonetext.sd_layout.leftSpaceToView (self.view,kWidth(39)).topSpaceToView(self.view,kHeight(128)+i*kHeight(45)).rightSpaceToView(self.view,kWidth(39)).heightIs(kHeight(30));
        UIImageView * loginImage = [[UIImageView alloc]init];
        loginImage.image  = [UIImage imageNamed:imageary[i]];
        [phonetext addSubview:loginImage];
        loginImage.sd_layout.leftSpaceToView(phonetext,kWidth(10)).topSpaceToView(phonetext,0).heightIs(kHeight(23)).widthIs(kWidth(14));
        
        UILabel * linelabel =[[UILabel alloc]init];
        linelabel.backgroundColor = UIColorFromRGB(0xFFFFFF);
        [phonetext addSubview:linelabel];
        linelabel.sd_layout.leftSpaceToView(phonetext,0).bottomSpaceToView(phonetext,0).heightIs(1).widthIs((GetWidth-kWidth(39*2)) );
        
        
        if (phonetext.tag==101) {
            
            _mimaBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            _mimaBtn.titleLabel.font = [UIFont systemFontOfSize:autoScaleW(12)];
            [_mimaBtn setTitleColor:UIColorFromRGB(0xFFFFFF) forState:UIControlStateNormal];
            [_mimaBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
            [_mimaBtn sizeToFit];
            _mimaBtn.layer.borderWidth = 1.0f;
            _mimaBtn.layer.borderColor = [UIColorFromRGB(0xFFFFFF)CGColor];
            [_mimaBtn addTarget:self action:@selector(startTime) forControlEvents:UIControlEventTouchUpInside];
            [phonetext addSubview:_mimaBtn];
            _mimaBtn.sd_layout.rightSpaceToView(phonetext,0).bottomSpaceToView(phonetext,kHeight(5)).widthIs(kWidth(65)).heightIs(kHeight(20));
            
        }
        
    }
    //设置勾选按钮
    
    
    _chooseBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_chooseBtn setBackgroundImage:[UIImage imageNamed:@"矩形-5"] forState:UIControlStateNormal];
    [_chooseBtn setBackgroundImage:[UIImage imageNamed:@"形状-4"] forState:UIControlStateSelected];
    [_chooseBtn addTarget:self action:@selector(Choose:) forControlEvents:UIControlEventTouchUpInside];
    _chooseBtn.selected = YES;
    [self.view addSubview:_chooseBtn];
    _chooseBtn.sd_layout.leftSpaceToView(self.view,kWidth(40)).topSpaceToView(phonetext,kHeight(10)).widthIs(kWidth(15)).heightIs(kHeight(15));
    
    UILabel * xieyiLabel = [[UILabel alloc]init];
    xieyiLabel.font = [UIFont systemFontOfSize:autoScaleW(12)];
    xieyiLabel.textColor = UIColorFromRGB(0xFFFFFF);
    xieyiLabel.text = @"我已同意并阅读";
    CGSize size = [xieyiLabel.text sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:xieyiLabel.font,NSFontAttributeName, nil]];
    CGFloat wind = size.width;

    [self.view addSubview:xieyiLabel];
    xieyiLabel.sd_layout.leftSpaceToView(_chooseBtn,kWidth(5)).topSpaceToView(phonetext,kHeight(12)).widthIs(wind).heightIs(kHeight(12));
    
    UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button addTarget:self action:@selector(Clickxy) forControlEvents:UIControlEventTouchUpInside];
    [button setTitle:@"微点筷客注册协议" forState:UIControlStateNormal];
    button .titleLabel.font = [UIFont systemFontOfSize:autoScaleW(12)];
    [button setTitleColor:RGB(136, 205, 245) forState:UIControlStateNormal];
    button.titleLabel.textAlignment = NSTextAlignmentLeft;
    [self.view addSubview:button];
    button.sd_layout.leftSpaceToView(xieyiLabel,0).topSpaceToView(phonetext,kHeight(12)).widthIs(kWidth(105)).heightIs(kHeight(12));
    
    UIButton * longinBtn =[UIButton buttonWithType:UIButtonTypeCustom];
    longinBtn.backgroundColor= UIColorFromRGB(0xFD7577);
    [longinBtn setTitle:@"注册" forState:UIControlStateNormal];
    longinBtn.titleLabel.font = [UIFont systemFontOfSize:autoScaleW(20)];
    [longinBtn setTitleColor:UIColorFromRGB(0xFFFFFF) forState:UIControlStateNormal];
    [longinBtn addTarget:self action:@selector(register) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:longinBtn];
    longinBtn.sd_layout.topSpaceToView(xieyiLabel,kHeight(40)).leftSpaceToView(self.view,kWidth(39)).rightSpaceToView(self.view,kWidth(39)).heightIs(kHeight(44));
    
    
    UITapGestureRecognizer * tap1 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(Tapped:)];
    
    tap1.cancelsTouchesInView = NO;

    
    [self.view addGestureRecognizer:tap1];
    
    
}
#pragma mark 验证码
-(void)startTime{
    UITextField * duanxintxt = (UITextField *)[self.view viewWithTag:100];
    if (![duanxintxt.text isMobileNumber:duanxintxt.text]) {
        UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"请输入正确手机号" preferredStyle:UIAlertControllerStyleAlert];
        __weak UIAlertAction * cancel = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:nil];
        
        [alert addAction:cancel];
        
        [self presentViewController:alert animated:YES completion:nil];
    }
    else
    {
        
        if (![duanxintxt.text isEqualToString:@""]&& [duanxintxt.text isMobileNumber:duanxintxt.text])
        {
            MessageCodeView * codeview = [[MessageCodeView alloc]init];
            [codeview showView];
            codeview.complete = ^(NSString * codestr){
                [MBProgressHUD showMessage:@"请稍后"];
                NSString * phonestr = [ZT3DesSecurity encryptWithText:duanxintxt.text];
                NSString * url = [NSString stringWithFormat:@"%@/common/sendSms?phone=%@&inputCode= %@", commonUrl,phonestr,codestr];
                
                
                NSArray * urlary = [url componentsSeparatedByString:@"?"];
                [[QYXNetTool shareManager]postNetWithUrl:urlary.firstObject urlBody:urlary.lastObject bodyStyle:QYXBodyString header:nil response:QYXJSON success:^(id result)
                 {
                     [MBProgressHUD hideHUD];
                     NSString * msg = [NSString stringWithFormat:@"%@",result[@"msgType"]];
                     if ([msg isEqualToString:@"0"]) {
                         [self startTime];
                     }else{
                         [MBProgressHUD showError:@"发送失败"];
                     }
                     
                 } failure:^(NSError *error) {
                     [MBProgressHUD hideHUD];
                     
                 }];
                
                
                
            };
        }
        else
        {
            [MBProgressHUD showError:@"手机号不能为空！"];
            
        }
        
        
    }
}
#pragma mark 倒计时
-(void)daojishi
{
    UIApplication*   app = [UIApplication sharedApplication];
    __block    UIBackgroundTaskIdentifier bgTask;
    bgTask = [app beginBackgroundTaskWithExpirationHandler:^{
        dispatch_async(dispatch_get_main_queue(), ^{
            if (bgTask != UIBackgroundTaskInvalid)
            {
                bgTask = UIBackgroundTaskInvalid;
            }
        });
    }];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            if (bgTask != UIBackgroundTaskInvalid)
            {
                bgTask = UIBackgroundTaskInvalid;
            }
        });
    });

    __block int timeout=60; //倒计时时间
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
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
#pragma mark 注册
-(void)register
{
    UITextField * text1 = (UITextField*)[self.view viewWithTag:100];
    UITextField*text2 = (UITextField*)[self.view viewWithTag:101];
    UITextField *text3 = (UITextField*)[self.view viewWithTag:102];
    UITextField * text4 = (UITextField*)[self.view viewWithTag:103];
    
    
    NSString * urlstr = [NSString stringWithFormat:@"%@/common/validateSms?phone=%@&code=%@",commonUrl,text1.text,text2.text];
    
    NSArray * urlary = [urlstr componentsSeparatedByString:@"?"];
   
    NSString * urlString = [NSString stringWithFormat:@"%@/user/register?mobile=%@&password=%@&code=%@",commonUrl,text1.text,text3.text,text2.text];
    
    NSArray * urlArray = [urlString componentsSeparatedByString:@"?"];
    
    if(_chooseBtn.selected==YES)
    {
        if(![text1.text isEqualToString:@""]&&![text2.text isEqualToString:@""]&&![text3.text isEqualToString:@""]&&![text4.text isEqualToString:@""])
            
        {
            [MBProgressHUD showMessage:@"请稍后"];
                 if ([text3.text isEqualToString:text4.text])
                 {
                     [[QYXNetTool shareManager]postNetWithUrl:urlArray.firstObject urlBody:urlArray.lastObject bodyStyle:QYXBodyString header:nil response:QYXJSON success:^(id result)
                      {
                          [MBProgressHUD hideHUD];
                          if (_timer!=nil) {
                              
                                                   dispatch_source_cancel(_timer);
                                                   _timer = nil;
                                                   [_mimaBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
                                                   _mimaBtn.userInteractionEnabled = YES;
                                               }

                          NSString * codestring  = [result objectForKey:@"msgType"];
                          if([codestring integerValue]==1002)
                          {
                              [MBProgressHUD showError:@"验证码错误😲"];
                              
                              
                          }
                          if([codestring integerValue]==1001)
                          {
                              [MBProgressHUD showError:@"该用户已注册过😥"];
                             
                          }
                          if([codestring integerValue]==0)
                          {
                              
                              [MBProgressHUD showSuccess:@"注册成功👏"];
                              [self Back];
                          }
                          
                          
                          NSLog(@"LLLLLL%@",result);
                      } failure:^(NSError *error) {
                          
                           [MBProgressHUD hideHUD];
                          if (_timer!=nil) {
                              
                            dispatch_source_cancel(_timer);
                            _timer = nil;
                            [_mimaBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
                            _mimaBtn.userInteractionEnabled = YES;
                        }
                          [MBProgressHUD showError:[NSString stringWithFormat:@"%@",error]];
                         
                      }];
                     
                 }
                 else
                 {
                     [MBProgressHUD hideHUD];
                     UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"密码不一致" preferredStyle:UIAlertControllerStyleAlert];
                     __weak UIAlertAction * cancel = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:nil];
                     
                     [alert addAction:cancel];
                     
                     [self presentViewController:alert animated:YES completion:nil];
                     
                 }
        }
        else
        {
            
            UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"信息不能为空" preferredStyle:UIAlertControllerStyleAlert];
            __weak UIAlertAction * cancel = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:nil];
            
            [alert addAction:cancel];
            
            [self presentViewController:alert animated:YES completion:nil];
            
        }
        
    }
    else
    {
        
        UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"需要同意协议才能继续注册" preferredStyle:UIAlertControllerStyleAlert];
        __weak UIAlertAction * cancel = [UIAlertAction actionWithTitle:@"好" style:UIAlertActionStyleCancel handler:nil];
        [alert addAction:cancel];
        
        [self presentViewController:alert animated:YES completion:nil];
        
        
        
    }

}
#pragma mark 点击协议回调
-(void)Clickxy
{
    
    AgreementVC * agreeVc = [[AgreementVC alloc]init];
    [self.navigationController pushViewController:agreeVc animated:YES];
    
}
#pragma mark 勾选回调
-(void)Choose:(UIButton*)chooseBtn
{
    chooseBtn.selected =!chooseBtn.selected;
    
    
}
-(void)Back
{
    [self.navigationController popViewControllerAnimated:YES];
    
    
}
#pragma mark 收回键盘
-(void)Tapped:(UITapGestureRecognizer*)tap1
{
    [self.view endEditing:YES];
}
#pragma mark 输入框数据源方法
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSString * phonestring = [textField.text stringByReplacingCharactersInRange:range withString:string];
    UITextField * photext = (UITextField *)[self.view viewWithTag:100];

   //判断手机号
    if (photext==textField) {
        
//

        if (phonestring.length>11) {
            
            textField.text = [phonestring substringToIndex:11];
            UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"请输入正确手机号" preferredStyle:UIAlertControllerStyleAlert];
                __weak UIAlertAction * cancel = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:nil];
                
                [alert addAction:cancel];
                
                [self presentViewController:alert animated:YES completion:nil];
            return NO;

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
