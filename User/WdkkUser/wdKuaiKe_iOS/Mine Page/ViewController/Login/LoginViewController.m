//
//  LoginViewController.m
//  WDKKtest
//
//  Created by 张森森 on 16/8/3.
//  Copyright © 2016年 weiDianKuaiKe. All rights reserved.
//

#import "LoginViewController.h"
#import "LLHConst.h"
#import "RegisterViewController.h"
#import "QYXNetTool.h"
#import "MBProgressHUD+SS.h"
#import <TencentOpenAPI/TencentOAuth.h>
#import "WTThirdPartyLoginManager.h"
#import <WeiboSDK/WeiboSDK.h>
#import "WXApi.h"
#import "MinePageVC.h"
#import "HomePageVC.h"
#import <TencentOpenAPI/QQApiInterface.h>
#import "ForgetlogincodeViewController.h"
#import "BindPasswordViewController.h"
#import "ZT3DesSecurity.h"
#import "MessageCodeView.h"
#import "AppDelegate.h"
#import "ZTMd5Security.h"
@interface LoginViewController ()<UITextFieldDelegate>
@property(nonatomic,strong)TencentOAuth * tenoath;
@property (nonatomic,strong)UIButton * daitibtn;
@property (nonatomic,strong)UIButton * mimaBtn;
@property (nonatomic,assign)NSInteger loginType;//登录方法
@end

@implementation LoginViewController

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
    self.tabBarController.tabBar.hidden = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _loginType = 0;
    UIImageView * backgroundImag =[[UIImageView alloc]init];
    backgroundImag.image = [UIImage imageNamed:@"矩形-1"];
  
    backgroundImag.frame = CGRectMake(0, 0, GetWidth, GetHeight);
    [self.view addSubview:backgroundImag];
   
    UIButton * backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [backBtn setImage:[UIImage imageNamed:@"形状-1"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(Back) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backBtn];
    backBtn.sd_layout.leftSpaceToView(self.view,autoScaleW(15)).topSpaceToView(self.view,autoScaleH(20)).widthIs(autoScaleW(30)).heightIs(autoScaleH(20));
    
    
    UIImageView * headview = [[UIImageView alloc]init];
    headview.image = [UIImage imageNamed:@"个人"];
    [self.view addSubview:headview];
    headview.sd_layout.topSpaceToView(self.view,autoScaleH(20)).centerXIs(self.view.centerX).widthIs(autoScaleW(88)).heightIs(autoScaleH(88));
    
 //    _titleary = @[@"手机号",@"验证码",];
//    _placeary = @[@"请输入手机号",@"请输入验证码",];
    
    NSArray * placeary = @[@"请输入手机号",@"请输入验证码",];
    NSArray * imageary = @[@"手机-(1)",@"密码",];
    
    for (int i =0; i<2; i++) {
        UITextField * phonetext = [[UITextField alloc]init];
        phonetext.backgroundColor = [UIColor clearColor];
        phonetext.tag = 100+i;
        phonetext.delegate = self;
        phonetext.placeholder = placeary[i];
        phonetext.font = [UIFont systemFontOfSize:12];
        [phonetext setValue:UIColorFromRGB(0xB9B9B9) forKeyPath:@"_placeholderLabel.textColor"];
        phonetext.textColor = UIColorFromRGB(0xFFFFFF);
        phonetext.textAlignment = NSTextAlignmentCenter;
        if (phonetext.tag==100) {
            
            phonetext.keyboardType = UIKeyboardTypeNumberPad;
        }
        if (phonetext.tag==101) {
            
            phonetext.keyboardType = UIKeyboardTypeASCIICapable;
        }
        
        [self.view addSubview:phonetext];
        phonetext.sd_layout.leftSpaceToView (self.view,kWidth(39)).topSpaceToView(headview,autoScaleH(45)+i*autoScaleH(45)).rightSpaceToView(self.view,kWidth(39)).heightIs(autoScaleH(30));
        UIImageView * loginImage = [[UIImageView alloc]init];
        loginImage.image  = [UIImage imageNamed:imageary[i]];
        [phonetext addSubview:loginImage];
        loginImage.sd_layout.leftSpaceToView(phonetext,autoScaleW(10)).topSpaceToView(phonetext,0).heightIs(autoScaleH(23)).widthIs(autoScaleW(14));
        
        UILabel * linelabel =[[UILabel alloc]init];
        linelabel.backgroundColor = UIColorFromRGB(0xFFFFFF);
        [phonetext addSubview:linelabel];
        linelabel.sd_layout.leftSpaceToView(phonetext,0).bottomSpaceToView(phonetext,0).heightIs(1).widthIs(GetWidth-autoScaleW(39*2));
        
        if (phonetext.tag==101) {
            
            _mimaBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            _mimaBtn.titleLabel.font = [UIFont systemFontOfSize:autoScaleW(12)];
            [_mimaBtn setTitleColor:UIColorFromRGB(0xfd7577) forState:UIControlStateNormal];
            [_mimaBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
            [_mimaBtn sizeToFit];
            _mimaBtn.tag = 5000;
            _mimaBtn.layer.borderWidth = 1.0f;
            _mimaBtn.layer.borderColor = [UIColorFromRGB(0xfd7577) CGColor];
            [_mimaBtn addTarget:self action:@selector(getCode) forControlEvents:UIControlEventTouchUpInside];
            [phonetext addSubview:_mimaBtn];
            _mimaBtn.sd_layout.rightSpaceToView(phonetext,0).topSpaceToView(phonetext,0).widthIs(autoScaleW(80)).autoHeightRatio;
            _mimaBtn.hidden = NO;
            phonetext.secureTextEntry = YES;
        }
        
    }
    
    UIButton * loginbtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [loginbtn setTitle:@"登录" forState:UIControlStateNormal];
    loginbtn.titleLabel.font = [UIFont systemFontOfSize:autoScaleW(15)];
    [loginbtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    loginbtn.backgroundColor = UIColorFromRGB(0xfd7577);
    [loginbtn addTarget:self action:@selector(Login) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:loginbtn];
    loginbtn.sd_layout.leftSpaceToView(self.view,autoScaleW(20)).rightSpaceToView(self.view,autoScaleW(20)).topSpaceToView(headview,autoScaleH(15)+autoScaleW(45)+autoScaleH(90)).heightIs(autoScaleH(40));
    
    NSArray * btntitleary = @[@"验证码登录",@"密码登录",];
    
    for (int i=0; i<2; i++) {
        
        UIButton * choosebtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [choosebtn setTitle:btntitleary[i] forState:UIControlStateNormal];
        [choosebtn setTitleColor:UIColorFromRGB(0xfd7577) forState:UIControlStateSelected];
        [choosebtn  setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        choosebtn.titleLabel.font = [UIFont systemFontOfSize:autoScaleW(15)];
        choosebtn.tag = 1000 +i;
        if (i==0) {
            
            choosebtn.selected = YES;
            _daitibtn = choosebtn;
        }
        [choosebtn addTarget:self action:@selector(Choose:) forControlEvents:  UIControlEventTouchUpInside];
        [self.view addSubview:choosebtn];
        choosebtn.sd_layout.leftSpaceToView(self.view,autoScaleW(60)+i*autoScaleW(115+53)).topSpaceToView(loginbtn,autoScaleH(20)).widthIs(autoScaleW(100)).heightIs(autoScaleH(30));
    }
    UILabel *linlabel = [[UILabel alloc]init];
    linlabel.backgroundColor =[UIColor lightGrayColor];
    [self.view addSubview:linlabel];
    linlabel.sd_layout.centerXEqualToView(self.view).topSpaceToView(loginbtn,autoScaleH(20)).widthIs(1).heightIs(autoScaleH(20));
     UIButton * registerBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    registerBtn.backgroundColor = UIColorFromRGB(0x272E3D);
    [registerBtn setTitle:@"忘记密码?" forState:UIControlStateNormal];
    [registerBtn setTitleColor:UIColorFromRGB(0xFFFFFF) forState:UIControlStateNormal];
    registerBtn.titleLabel.font = [UIFont systemFontOfSize:autoScaleW(12)];
    registerBtn.layer.masksToBounds = YES;
    registerBtn.layer.cornerRadius = 8;
    [registerBtn addTarget:self action:@selector(Register) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:registerBtn];
    registerBtn.sd_layout.rightSpaceToView(self.view,autoScaleW(39)).topSpaceToView(loginbtn,autoScaleH(18)+autoScaleH(50)).widthIs(autoScaleW(64)).heightIs(autoScaleH(22));
    
//    UIButton * wangjibtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    [wangjibtn setTitle:@"忘记密码?" forState:UIControlStateNormal];
//    [wangjibtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
//    wangjibtn .titleLabel.font = [UIFont systemFontOfSize:autoScaleW(12)];
//    [wangjibtn addTarget:self action:@selector(Wangji) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:wangjibtn];
//    wangjibtn.sd_layout.rightEqualToView(loginbtn).topSpaceToView(registerBtn,autoScaleH(25)).widthIs(autoScaleW(70)).heightIs(autoScaleH(15));
    
     UILabel * threelabel = [[UILabel alloc]init];
    threelabel.text = @"第三方登录";
    threelabel.font = [UIFont systemFontOfSize:autoScaleW(11)];
    threelabel.textColor = UIColorFromRGB(0xFFFFFF);
    [self.view addSubview:threelabel];
    threelabel.sd_layout.centerXIs(self.view.frame.size.width/2).topSpaceToView(loginbtn,autoScaleH(123)).widthIs(autoScaleW(61)).heightIs(autoScaleH(13));
    
    UILabel * leftlabel = [[UILabel alloc]init];
    
    leftlabel.backgroundColor = UIColorFromRGB(0xD2D2D2);
    [self.view addSubview:leftlabel];
    leftlabel.sd_layout.leftSpaceToView(self.view,autoScaleW(39)).topSpaceToView(loginbtn,autoScaleH(128)).rightSpaceToView(threelabel,autoScaleW(15)).heightIs(1);
    
    UILabel * rightlabel = [[UILabel alloc]init];
    rightlabel.backgroundColor = UIColorFromRGB(0xD2D2D2);
    [self.view addSubview:rightlabel];
    rightlabel.sd_layout.rightSpaceToView(self.view,autoScaleW(39)).topSpaceToView(loginbtn,autoScaleH(128)).leftSpaceToView(threelabel,autoScaleW(15)).heightIs(1);
    
    
    NSArray * threeImageary = @[@"QQ",@"微信",];
    NSArray * threeLabelary = @[@"QQ",@"微信",];
    
    for (int i =0; i<threeImageary.count; i++) {
        
        UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.tag = 500+i;
        [button addTarget:self action:@selector(ThreeLogin:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:button];
        
        button.sd_layout.leftSpaceToView(self.view,(GetWidth-autoScaleW(45)*threeImageary.count)/(threeImageary.count+1)+i*((GetWidth-autoScaleW(45)*threeImageary.count)/(threeImageary.count+1)+autoScaleW(45))).topSpaceToView(leftlabel,autoScaleH(37)).widthIs(autoScaleW(45)).heightIs(autoScaleH(75));
        
        UIImageView * threeimageview = [[UIImageView alloc]init];
        threeimageview.image = [UIImage imageNamed:threeImageary[i]];
        [button addSubview:threeimageview];
        threeimageview.sd_layout.leftSpaceToView (button,0).topSpaceToView(button,0).widthIs(autoScaleW(45)).heightIs(autoScaleH(45));
        
        UILabel * threelabel = [[UILabel alloc]init];
        threelabel.text = threeLabelary [i];
        threelabel.font = [UIFont systemFontOfSize:autoScaleW(12)];
        threelabel.textColor = UIColorFromRGB(0xFFFFFF);
        [button addSubview:threelabel];
        threelabel.sd_layout.leftSpaceToView(button,autoScaleW(10)).bottomSpaceToView(button,0).widthIs(autoScaleW(40)).heightIs(autoScaleH(12));
    }
    
////    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(Remove)];
////    tap.cancelsTouchesInView = NO;
////    [self.view addGestureRecognizer:tap];
    [self isHidenThirdBtn];
    
}
-(void)textFieldDidBeginEditing:(UITextField *)textField{

    [textField bringSubviewToFront:_mimaBtn];
}

#pragma mark 选择登录方式
-(void)Choose:(UIButton*)btn
{
    _daitibtn.selected = NO;
    btn.selected = YES;
    _daitibtn = btn;
    if (btn.tag==1001) {
        
        UITextField * phonetext = (UITextField*)[self.view viewWithTag:101];
        phonetext.placeholder = @"请输入密码";//根据选择登录方式更换提示词
        _mimaBtn.hidden = YES;
        _loginType = 1;
    }
    if (btn.tag==1000)
    {
        UITextField * phonetext = (UITextField*)[self.view viewWithTag:101];
        phonetext.placeholder = @"请输入验证码";
        _loginType = 0;
        _mimaBtn.hidden = NO;
        
    }
    
}
#pragma mark 获取验证码
-(void)getCode
{
    
    UITextField * phonetext = (UITextField*)[self.view viewWithTag:100];
        if (![phonetext.text isEqualToString:@""]&& [phonetext.text isMobileNumber:phonetext.text])
    {
        MessageCodeView * codeview = [[MessageCodeView alloc]init];
        [codeview showView];
        codeview.complete = ^(NSString * codestr){
            [MBProgressHUD showMessage:@"请稍后"];
            NSString * phonestr = [ZT3DesSecurity encryptWithText:phonetext.text];
            NSString * url = [NSString stringWithFormat:@"%@/common/sendSms?phone=%@&inputCode=%@", commonUrl,phonestr,codestr];
            
            url = [url stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet characterSetWithCharactersInString:@"#%<>[\\]^`{|}\"]+"].invertedSet];
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
#pragma mark 倒计时
-(void)startTime
{
    UIApplication* app = [UIApplication sharedApplication];
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

//-(void)Remove
//{
//    [self.view endEditing:YES];
//    
//}
#pragma mark 判断第三方登录按钮是否隐藏
-(void)isHidenThirdBtn
{
    BOOL Wxinstaller = [WXApi isWXAppInstalled];
    
    UIButton * wxbtn = (UIButton* )[self.view viewWithTag:501];
    
    if (!Wxinstaller) {
        
        wxbtn.hidden = YES;
    }
    if (![QQApiInterface isQQInstalled]) {
        UIButton * qqbtn = (UIButton*)[self.view viewWithTag:500];
        qqbtn.hidden = YES;
        
    }
//    if (![[UIApplication sharedApplication]canOpenURL:[NSURL URLWithString:@"wdKuaiKe-iOS.sky.weiDianKuaiKe.com://wb765026295"]]) {
//        UIButton * wbbtn = (UIButton*)[self.view viewWithTag:500];
//        wbbtn.hidden = YES;
//        
//    }
    
}
#pragma mark 登录
-(void)Login
{
    
    UITextField * phonetext = (UITextField*)[self.view viewWithTag:100];
    UITextField * passwordtext = (UITextField*)[self.view viewWithTag:101];
    __weak NSString *url = nil;
//    NSDictionary * pam = @{@"loginName":phonetext.text,@"password":passwordtext.text};
    
    if (![phonetext.text isEqualToString:@""]&&![passwordtext.text isEqualToString:@""]) {
   
        [MBProgressHUD showMessage:@"请稍等"];
        if (_loginType==1) {
            
            NSString * passwordstr = [ZTMd5Security MD5ForLower32Bate:passwordtext.text];
            
            url = [NSString stringWithFormat:@"%@/user/login?password=%@&loginName=%@",commonUrl,passwordstr,phonetext.text];
            
        }else{
            url = [NSString stringWithFormat:@"%@/user/login?code=%@&loginName=%@",commonUrl,passwordtext.text,phonetext.text];
        }
        
        NSArray * urlary = [url componentsSeparatedByString:@"?"];
        
        [[QYXNetTool shareManager]postNetWithUrl:urlary.firstObject urlBody:urlary.lastObject bodyStyle:QYXBodyString header:nil response:QYXJSON success:^(id result)
        {
            [MBProgressHUD hideHUD];
            NSString * strr = [result objectForKey:@"msgType"];
            
                   if ([strr integerValue]==1002) {
                   [MBProgressHUD showError:@"无此用户😓"];
                             }
                    else if ([strr integerValue]==1001) {
                
                
                     [MBProgressHUD showError:@"密码错误😨"];
                
                    }else if ([strr integerValue]==1000||[strr integerValue]==0){
                        
                        NSDictionary * dict = [result objectForKey:@"obj"];
                        NSString * idd  =[dict objectForKey:@"id"];
                        NSString * token = [dict objectForKey:@"token"];
                        NSString * image = [dict objectForKey:@"avatar"];
                        NSUserDefaults * userde = [NSUserDefaults standardUserDefaults];
                        
                        if (IsNull(idd)) {
                            
                            [userde setObject:idd forKey:@"idd"];
                            
                        }
                        if (IsNull(token)) {
                            
                            [userde setObject:token forKey:@"token"];
                        }
                        if (IsNull(image)) {
                            
                            [userde setObject:image forKey:@"headimage"];
                        }
                        
                        [userde setObject:@"common" forKey:@"loginType"];
                        [userde synchronize];
                        if ([strr integerValue]==1000) {
                            [MBProgressHUD showSuccess:@"登陆成功，先绑定一下密码吧"];
                            BindPasswordViewController * bindview = [[BindPasswordViewController alloc]init];
                            [self.navigationController pushViewController:bindview animated:YES];
                        }else if ([strr integerValue]==0){
                            [MBProgressHUD showSuccess:@"登陆成功😁"];
                            [self Back];
                        }

                    }else if ([strr integerValue]==1){
                        
                        [MBProgressHUD showError:@"登录失败"];
                    }
                } failure:^(NSError *error) {
                    [MBProgressHUD hideHUD];
                    [MBProgressHUD showError:@"网络错误"];
        }];
    }
    else
    {
        
        UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"信息不能为空" preferredStyle:UIAlertControllerStyleAlert];
        __weak UIAlertAction * cancel = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:nil];
        
        [alert addAction:cancel];
        
        [self presentViewController:alert animated:YES completion:nil];

    }
}

-(void)Back
{
//    if (_putInt==1) {
        [self.navigationController popToRootViewControllerAnimated:YES];
//         self.tabBarController.selectedIndex = 0;
//    }else{
//        [self.navigationController popViewControllerAnimated:YES];
//
//    }

}
#pragma mark 注册回调
-(void)Register
{
    
//    RegisterViewController * registerView = [[RegisterViewController alloc]init];
//    [self.navigationController pushViewController:registerView animated:YES];
    ForgetlogincodeViewController * forgetview = [[ForgetlogincodeViewController alloc]init];
    [self.navigationController pushViewController:forgetview animated:YES];
    
    
}
#pragma mark 第三方登录回调
-(void)ThreeLogin:(UIButton* )loginBtn
{
    WTLoginType loginType;

    if (loginBtn.tag-500==WTLoginTypeWeiBo)
    {
        loginType = WTLoginTypeWeiBo;
        
       
    }
    else if (loginBtn.tag -500 ==  WTLoginTypeTencent)
    {
        loginType =  WTLoginTypeTencent;
        
    }
    else if (loginBtn.tag-500 == WTLoginTypeWeiXin)
    {
        if ([WXApi isWXAppSupportApi]) {
            loginType =WTLoginTypeWeiXin;

        }
        
    }
    
    if (loginType== WTLoginTypeWeiBo) {
        
        [MBProgressHUD showError:@"功能暂未开放"];
    }
    else{
   [WTThirdPartyLoginManager getUserInfoWithWTLoginType:loginType result:^(NSDictionary *LoginResult, NSString *error)
    {
        NSLog(@",.,.,.,.,.,,,.,.%@",LoginResult);

        if (LoginResult) {
            
            __weak NSString * urlstr = nil;
            NSString * openidstr = [LoginResult objectForKey:@"third_id"];
            NSString * imagestr = [LoginResult objectForKey:@"third_image"];
            NSString * namestr = [LoginResult objectForKey:@"third_name"];
            if (loginType == WTLoginTypeTencent) {
                urlstr =  [NSString stringWithFormat:@"%@/user/qqLogin?openId=%@&avatar=%@&nickName=%@",commonUrl,openidstr,imagestr,namestr];
                
            }
            else if (loginType==WTLoginTypeWeiXin)
            {
                urlstr = [NSString stringWithFormat:@"%@/user/wxLogin?unionId=%@&avatar=%@&nickName=%@",commonUrl,openidstr,imagestr,namestr];
                
            }
            else if (loginType == WTLoginTypeWeiBo)
            {
                urlstr = [NSString stringWithFormat:@"%@/user/wbLogin?unionId=%@&avatar=%@&nickName=%@",commonUrl,openidstr,imagestr,namestr];
            }
            
            NSArray * urlary = [urlstr componentsSeparatedByString:@"?"];
            [MBProgressHUD showMessage:@"请稍等"];
            [[QYXNetTool shareManager]postNetWithUrl:urlary.firstObject urlBody:urlary.lastObject bodyStyle:QYXBodyString header:nil response:QYXJSON success:^(id result)
             
            {
                [MBProgressHUD hideHUD];                
                NSString * msgtype = [NSString stringWithFormat:@"%@",[result objectForKey:@"msgType"]];
                if ([msgtype isEqualToString:@"0"]) {
                    
                    [MBProgressHUD showSuccess:@"登录成功"];
                    NSDictionary * dict = [result objectForKey:@"obj"];
                    NSString * idd  =[dict objectForKey:@"userId"];
                    NSString * token = [dict objectForKey:@"token"];
                    NSString * image = [dict objectForKey:@"avatar"];
                    NSUserDefaults * userde = [NSUserDefaults standardUserDefaults];
                    if (IsNull(idd)) {
                        
                        [userde setObject:idd forKey:@"idd"];
                        
                    }
                    if (IsNull(token)) {
                        
                        [userde setObject:token forKey:@"token"];
                    }
                    [userde setObject:image forKey:@"headimage"];
                    [userde setObject:namestr forKey:@"name"];
                    [userde setObject:@"Three" forKey:@"loginType"];
                    [userde synchronize];
                    
                    [self Back];
                }
                else
                {
                    [MBProgressHUD showError:@"登录失败"];
                }
                
                
            } failure:^(NSError *error)
            {
                [MBProgressHUD hideHUD];
                
            }];
        }
   }];
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
