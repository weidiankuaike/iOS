//
//  AuthcodeViewController.m
//  微点筷客商户端
//
//  Created by 张森森 on 16/10/9.
//  Copyright © 2016年 张森森. All rights reserved.
//

#import "AuthcodeViewController.h"
#import "AuthcodeView.h"
@interface AuthcodeViewController ()
{
    AuthcodeView * authcodeView;
    UITextField * _input;
}

@end

@implementation AuthcodeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = RGBA(0, 0, 0, 0.3);
    
    UIView * codeView = [[UIView alloc]init];
    codeView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:codeView];
    codeView.sd_layout.centerXEqualToView(self.view).centerYEqualToView(self.view).widthIs(autoScaleW(300)).heightIs(autoScaleH(250));
    
    
    ButtonStyle * quxiaobtn = [ButtonStyle buttonWithType:UIButtonTypeCustom];
    [quxiaobtn setImage:[UIImage imageNamed:@"形状-1"] forState:UIControlStateNormal];
    [quxiaobtn addTarget:self action:@selector(Quxiao) forControlEvents:UIControlEventTouchUpInside];
    [codeView addSubview:quxiaobtn];
    quxiaobtn.sd_layout.rightSpaceToView(codeView,0).topSpaceToView(codeView,0).widthIs(autoScaleW(25)).heightIs(autoScaleH(25));
    
    authcodeView = [[AuthcodeView alloc]initWithFrame:CGRectMake(autoScaleW(30),autoScaleH(20), codeView.frame.size.width-autoScaleW(60), autoScaleH(40))];
    [codeView addSubview:authcodeView];
    
    UILabel * firstlabel = [[UILabel alloc]init];
    firstlabel.text = @"点击图片切换验证码";
    firstlabel.font = [UIFont systemFontOfSize:autoScaleW(11)];
    firstlabel.textColor = [UIColor blueColor];
    firstlabel.textAlignment = NSTextAlignmentCenter;
    [codeView addSubview:firstlabel];
    firstlabel.sd_layout.centerXEqualToView(codeView).topSpaceToView(authcodeView,autoScaleH(10)).widthIs(autoScaleW(200)).heightIs(autoScaleH(15));
    
    _input = [[UITextField alloc] initWithFrame:CGRectMake(autoScaleW(30), autoScaleH(100), codeView.frame.size.width-autoScaleW(60), autoScaleH(40))];
    _input.layer.borderColor = [UIColor lightGrayColor].CGColor;
    _input.layer.borderWidth = 2.0;
    _input.layer.cornerRadius = 5.0;
    _input.font = [UIFont systemFontOfSize:autoScaleW(15)];
    _input.placeholder = @"请输入验证码!";
    _input.clearButtonMode = UITextFieldViewModeWhileEditing;
    _input.backgroundColor = [UIColor clearColor];
    _input.textAlignment = NSTextAlignmentCenter;
    _input.returnKeyType = UIReturnKeyDone;
    [codeView addSubview:_input];
    
    UILabel * tishilabel = [[UILabel alloc]init];
    tishilabel.text = @"操作太频繁，请验证后重试";
    tishilabel.textAlignment = NSTextAlignmentCenter;
    tishilabel.textColor = [UIColor redColor];
    tishilabel.font = [UIFont systemFontOfSize:autoScaleW(9)];
    [codeView addSubview:tishilabel];
    tishilabel.sd_layout.centerXEqualToView(codeView).topSpaceToView(_input,autoScaleH(10)).widthIs(autoScaleW(200)).heightIs(autoScaleH(15));
    
    ButtonStyle * loginbtn = [ButtonStyle buttonWithType:UIButtonTypeCustom];
    [loginbtn setTitle:@"验证" forState:UIControlStateNormal];
    loginbtn.titleLabel.font = [UIFont systemFontOfSize:autoScaleW(15)];
    [loginbtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    loginbtn.backgroundColor = UIColorFromRGB(0xfd7577);
    [loginbtn addTarget:self action:@selector(Login) forControlEvents:UIControlEventTouchUpInside];
    loginbtn.layer.masksToBounds = YES;
    loginbtn.layer.cornerRadius = autoScaleW(3);
    [codeView addSubview:loginbtn];
    loginbtn.sd_layout.leftSpaceToView(codeView,autoScaleW(30)).rightSpaceToView(codeView,autoScaleW(30)).topSpaceToView(tishilabel,autoScaleH(10)).heightIs(autoScaleH(30));
    
    
}
-(void)Quxiao
{
    [self dismissViewControllerAnimated:YES completion:^{
        
        
        
    }];
}
-(void)Login
{
    if ([_input.text isEqualToString:authcodeView.authCodeStr])
    {
        //正确弹出警告款提示正确
        
        [self dismissViewControllerAnimated:YES completion:^{
            
        
            
        }];
        
        
    }
    else
    {
        //验证不匹配，验证码和输入框抖动
        CAKeyframeAnimation *anim = [CAKeyframeAnimation animationWithKeyPath:@"transform.translation.x"];
        anim.repeatCount = 1;
        anim.values = @[@-20,@20,@-20];
        //        [authCodeView.layer addAnimation:anim forKey:nil];
        [_input.layer addAnimation:anim forKey:nil];
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
