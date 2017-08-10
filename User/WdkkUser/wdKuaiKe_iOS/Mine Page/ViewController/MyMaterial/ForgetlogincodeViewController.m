//
//  ForgetlogincodeViewController.m
//  微点筷客商户端
//
//  Created by 张森森 on 16/10/25.
//  Copyright © 2016年 张森森. All rights reserved.
//

#import "ForgetlogincodeViewController.h"
#import "UIBarButtonItem+SSExtension.h"
#import "LoginTableViewCell.h"
#import "UIBarButtonItem+SSExtension.h"
#import "QYXNetTool.h"
#import "MBProgressHUD+SS.h"
#import "MyMaterialViewController.h"
#import "NSString+Expend.h"
#import "ZT3DesSecurity.h"
#import "MessageCodeView.h"
@interface ForgetlogincodeViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong)NSArray * titleary;
@property (nonatomic,strong)NSArray * placeary;
@property (nonatomic,strong)UITextField * first;
@property (nonatomic,strong)UITextField * secon;
@property (nonatomic,strong)UITextField * three;
@property (nonatomic,strong)UITextField * phonetext;
@property (nonatomic,strong)UIButton * mimaBtn;
@end

@implementation ForgetlogincodeViewController
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = NO;
    [self.navigationController.navigationBar setBarTintColor:UIColorFromRGB(0xfd7577)];

}
- (void)viewDidLoad {
    [super viewDidLoad];
    UILabel * titlabel = [[UILabel alloc]init];
    titlabel.frame = CGRectMake(0, 0, 80, 30);
    titlabel.textAlignment = NSTextAlignmentCenter;
    titlabel.font = [UIFont systemFontOfSize:15];
    titlabel.text = @"忘记密码";
    titlabel.textColor = [UIColor whiteColor];
    self.navigationItem.titleView = titlabel;
    
    self.view.backgroundColor= RGB(242, 242, 242);
    self.automaticallyAdjustsScrollViewInsets = NO;
    UIBarButtonItem * backbtn = [UIBarButtonItem itemWithTarget:self Action:@selector(Back) image:@"left-1" selectImage:nil];
    self.navigationItem.leftBarButtonItem = backbtn;
    
    CGFloat height = [[UIApplication sharedApplication] statusBarFrame].size.height + self.navigationController.navigationBar.frame.size.height;
    NSString * str = [_phonestr substringFromIndex:7];
    NSLog(@"klk%@",str);
    
    _titleary = @[@"手机号",@"验证码",@"新的密码",@"再次确认",];
    _placeary = @[@"请输入手机号",@"请输入验证码",@"请输入新的登录密码",@"请再次输入密码确认",];
    
    UITableView*_yanzhengtableview = [[UITableView alloc]init];
    _yanzhengtableview.scrollEnabled = NO;
    _yanzhengtableview.delegate = self;
    _yanzhengtableview.dataSource = self;
    _yanzhengtableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_yanzhengtableview];
    _yanzhengtableview.sd_layout.leftSpaceToView(self.view,0).topSpaceToView(self.view, height).widthIs(kScreenWith).heightIs(autoScaleH(45*_titleary.count));
    
    UIButton * loginbtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [loginbtn setTitle:@"确认" forState:UIControlStateNormal];
    loginbtn.titleLabel.font = [UIFont systemFontOfSize:autoScaleW(15)];
    [loginbtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    loginbtn.backgroundColor = UIColorFromRGB(0xfd7577);
    [loginbtn addTarget:self action:@selector(Next) forControlEvents:UIControlEventTouchUpInside];
    loginbtn.layer.masksToBounds = YES;
    loginbtn.layer.cornerRadius = autoScaleW(3);
    [self.view addSubview:loginbtn];
    loginbtn.sd_layout.leftSpaceToView(self.view,autoScaleW(15)).rightSpaceToView(self.view, autoScaleW(15)).topSpaceToView(_yanzhengtableview,autoScaleH(30)).heightIs(autoScaleH(40));
    
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 4;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    LoginTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"safe"];
    
    if (!cell) {
        cell = [[LoginTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"safe"];
    }
    UILabel * linlab =[[UILabel alloc]init];
    linlab.backgroundColor = UIColorFromRGB(0xeeeeee);
    [cell addSubview:linlab];
    linlab.sd_layout.leftSpaceToView(cell,0).rightSpaceToView(cell,0).bottomSpaceToView(cell,0).heightIs(0.5);
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    cell.textfild.placeholder = _placeary[indexPath.row];
    cell.leftlabel.text = _titleary[indexPath.row];
    if (indexPath.row==0) {
        _phonetext = cell.textfild;
    }
    if (indexPath.row==1) {
        
        _first = cell.textfild;
        
        _mimaBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_mimaBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
        _mimaBtn.titleLabel.font = [UIFont systemFontOfSize:autoScaleW(13)];
        [_mimaBtn setTitleColor:UIColorFromRGB(0xfd7577) forState:UIControlStateNormal];
        [_mimaBtn sizeToFit];
        _mimaBtn.layer.borderWidth = 1.0f;
        _mimaBtn.layer.borderColor = [UIColorFromRGB(0xfd7577) CGColor];
        [_mimaBtn addTarget:self action:@selector(Clickcode) forControlEvents:UIControlEventTouchUpInside];
        [cell addSubview:_mimaBtn];
        _mimaBtn.sd_layout.rightSpaceToView(cell,autoScaleW(15)).topSpaceToView(cell,autoScaleH(10)).widthIs(autoScaleW(80)).heightIs(autoScaleH(25));
    }
   else if (indexPath.row==2) {
        
        _secon = cell.textfild;
    }
   else if (indexPath.row==3) {
        
        _three = cell.textfild;
    }
    
    return cell;
}
//判断手机号是否注册
- (void)Clickcode{
    
    
    if (_phonetext.text!=nil && ![_phonetext.text isMobileNumber:_phonetext.text]) {
        UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"请输入正确手机号" preferredStyle:UIAlertControllerStyleAlert];
        __weak UIAlertAction * cancel = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:nil];
        
        [alert addAction:cancel];
        
        [self presentViewController:alert animated:YES completion:nil];
    }
    else
    {
        [MBProgressHUD showMessage:@"请稍后"];
        NSString * url = [NSString stringWithFormat:@"%@/userIsDatabase?phone=%@",commonUrl,_phonetext.text];
        NSArray * urlary = [url componentsSeparatedByString:@"?"];
        [[QYXNetTool shareManager]postNetWithUrl:urlary.firstObject urlBody:urlary.lastObject bodyStyle:QYXBodyString header:nil response:QYXJSON success:^(id result) {
           
            [MBProgressHUD hideHUD];
            NSString * msgtype = [NSString stringWithFormat:@"%@",result[@"msgType"]];
            if ([msgtype isEqualToString:@"0"]) {
                
                [self getcode];
            }else{
                [MBProgressHUD showError:@"该手机号尚未注册"];
            }
            
        } failure:^(NSError *error) {
            
            [MBProgressHUD hideHUD];
            [MBProgressHUD showError:@"网络错误"];
        }];
        
    }
    
}
//获取验证码
-(void)getcode
{
    
        MessageCodeView * codeview = [[MessageCodeView alloc]init];
        [codeview showView];
        codeview.complete = ^(NSString * codestr){
            [MBProgressHUD showMessage:@"请稍后"];
            NSString * phonestr = [ZT3DesSecurity encryptWithText:_phonetext.text];
            NSString * url = [NSString stringWithFormat:@"%@/common/sendSms?phone=%@&inputCode=%@",commonUrl,phonestr,codestr];
            url = [url stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet characterSetWithCharactersInString:@"#%<>[\\]^`{|}\"]+"].invertedSet];
            
            NSArray * urlary = [url componentsSeparatedByString:@"?"];
            
            [[QYXNetTool shareManager]postNetWithUrl:urlary.firstObject urlBody:urlary.lastObject bodyStyle:QYXBodyString header:nil response:QYXJSON success:^(id result)
             {
                 [MBProgressHUD hideHUD];
                 
                 NSString * msgtype = [NSString stringWithFormat:@"%@",result[@"msgType"]];
                 if ([msgtype isEqualToString:@"0"]) {
                     
                     [self startTime];
                     
                 }else{
                     [MBProgressHUD showError:@"请求失败"];
                 }
                 
             } failure:^(NSError *error) {
                 [MBProgressHUD hideHUD];
                 [MBProgressHUD showError:@"网络错误"];
             }];

        };
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return autoScaleH(45);
}

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
                _mimaBtn.userInteractionEnabled = NO;
            });
            timeout--;
        }
    });
    dispatch_resume(_timer);

}
-(void)Next
{
    if (_first.text!=nil&&_secon.text!=nil&&_three.text!=nil)
    {
        if ([_three.text isEqualToString:_secon.text]) {
            [MBProgressHUD showMessage:@"请稍等"];
            
            NSString * newPass = [ZTMd5Security MD5ForLower32Bate:_secon.text];
            NSString * url = [NSString stringWithFormat:@"%@/api/user/userInfoManage?token=%@&userId=%@&pwd=%@&operation=6&code=%@&phone=%@",commonUrl,Token,Userid,newPass,_first.text,_phonetext.text];
            NSArray * urlary = [url componentsSeparatedByString:@"?"];
            
            [[QYXNetTool shareManager]postNetWithUrl:urlary.firstObject urlBody:urlary.lastObject bodyStyle:QYXBodyString header:nil response:QYXJSON success:^(id result)
             
             
             {
                 [MBProgressHUD hideHUD];
                 
                 NSLog(@"<><><><%@",result);
                 
                 NSString * codestr = [NSString stringWithFormat:@"%@",[result objectForKey:@"msgType"]];
                 if ([codestr isEqualToString:@"0"]) {
                     [MBProgressHUD showSuccess:@"修改成功"];
                     
                     for (UIViewController *controller in self.navigationController.viewControllers) {
                         if ([controller isKindOfClass:[MyMaterialViewController class]]) {
                             MyMaterialViewController *revise =(MyMaterialViewController *)controller;
                             [self.navigationController popToViewController:revise animated:YES];
                         }
                     }
                     
                     
                 }
                 else
                 {
                     [MBProgressHUD hideHUD];
                     [MBProgressHUD showError:@"修改失败"];
                 }
                 
             } failure:^(NSError *error)
             {
                 [MBProgressHUD hideHUD];
                 [MBProgressHUD showError:@"网络错误"];
                 
             }];
            

            
        }
        else{
            
            [MBProgressHUD showError:@"两次密码不一致"];
        }
        
        
    }
    
}
-(void)Back
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
