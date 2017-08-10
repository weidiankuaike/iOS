//
//  JoinInViewController.m
//  微点筷客商户端
//
//  Created by 张森森 on 16/10/8.
//  Copyright © 2016年 张森森. All rights reserved.
//

#import "JoinInViewController.h"
#import "LoginTableViewCell.h"
#import "MBProgressHUD+SS.h"
#import "QYXNetTool.h"
#import "UIBarButtonItem+SSExtension.h"
#import "VerifyViewController.h"
#import "AuthcodeViewController.h"
#import "RestaurantViewController.h"
#import "AgreementVC.h"
#import "NSString+RegexCategory.h"
@interface JoinInViewController ()<UITableViewDelegate,UITableViewDataSource>{
    BOOL isSelected;
    ButtonStyle * loginbtn;
}
@property(nonatomic,strong)NSArray * titleary,*placeary;
@property (nonatomic,strong)UITableView * yanzhengtableview;
@property (nonatomic,strong)UIButton * mimaBtn;
@property(nonatomic,strong)ButtonStyle * chooseBtn;


@end
static int i=0;
@implementation JoinInViewController

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = NO;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    isSelected = YES;
    self.titleView.text = @"手机验证";
    self.view.backgroundColor = RGB(242, 242, 242);
    self.automaticallyAdjustsScrollViewInsets = NO;

    _titleary = @[@"手机号",@"验证码",@"登录密码"];
    _placeary = @[@"请输入手机号",@"请输入验证码",@"请输入登录密码"];
    
     CGFloat height = [[UIApplication sharedApplication] statusBarFrame].size.height + self.navigationController.navigationBar.frame.size.height;
    
    _yanzhengtableview = [[UITableView alloc]init];
    _yanzhengtableview.scrollEnabled = NO;
    _yanzhengtableview.delegate = self;
    _yanzhengtableview.dataSource = self;
    _yanzhengtableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_yanzhengtableview];
    _yanzhengtableview.sd_layout.leftSpaceToView(self.view,0).topSpaceToView(self.view,autoScaleH(15)+height).widthIs(kScreenWidth).heightIs(autoScaleH(45)*_titleary.count);
    
    loginbtn = [ButtonStyle buttonWithType:UIButtonTypeCustom];
    [loginbtn setTitle:@"我要入驻" forState:UIControlStateNormal];
    loginbtn.titleLabel.font = [UIFont systemFontOfSize:autoScaleW(15)];
    [loginbtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    loginbtn.backgroundColor = UIColorFromRGB(0xfd7577);
    [loginbtn addTarget:self action:@selector(Login) forControlEvents:UIControlEventTouchUpInside];
    loginbtn.layer.masksToBounds = YES;
    loginbtn.layer.cornerRadius = autoScaleW(3);
    [self.view addSubview:loginbtn];
    loginbtn.sd_layout.leftSpaceToView(self.view,autoScaleW(20)).rightSpaceToView(self.view,autoScaleW(20)).topSpaceToView(_yanzhengtableview,autoScaleH(15)).heightIs(autoScaleH(30));
    
    _chooseBtn = [ButtonStyle buttonWithType:UIButtonTypeCustom];
    [_chooseBtn setBackgroundImage:[UIImage imageNamed:@"椭圆-2"] forState:UIControlStateNormal];
    [_chooseBtn setBackgroundImage:[UIImage imageNamed:@"打勾"] forState:UIControlStateSelected];
    [_chooseBtn addTarget:self action:@selector(Choose:) forControlEvents:UIControlEventTouchUpInside];
    _chooseBtn.selected = YES;
    [self.view addSubview:_chooseBtn];
    _chooseBtn.sd_layout.leftSpaceToView(self.view,autoScaleW(107)).topSpaceToView(loginbtn,autoScaleH(17)).widthIs(autoScaleW(10)).heightIs(autoScaleH(10));
    
    UILabel * xieyiLabel = [[UILabel alloc]init];
    xieyiLabel.font = [UIFont systemFontOfSize:autoScaleW(10)];
    xieyiLabel.textColor = RGB(178, 178, 178);
    xieyiLabel.text = @"默认同意";
    CGSize size = [xieyiLabel.text sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:xieyiLabel.font,NSFontAttributeName, nil]];
    CGFloat wind = size.width;
    
    [self.view addSubview:xieyiLabel];
    xieyiLabel.sd_layout.leftSpaceToView(_chooseBtn,autoScaleW(3)).topSpaceToView(loginbtn,autoScaleH(15)).widthIs(wind).heightIs(autoScaleH(12));

    ButtonStyle * agreementBT = [ButtonStyle buttonWithType:UIButtonTypeCustom];
    [agreementBT setTitle:@"《微点筷客商家端服务协议》" forState:UIControlStateNormal];
    agreementBT.font = [UIFont systemFontOfSize:autoScaleW(10)];
    [agreementBT setTitleColor:UIColorFromRGB(0xfd7577) forState:UIControlStateNormal];
    [agreementBT addTarget:self action:@selector(Clickxy) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:agreementBT];
    agreementBT.sd_layout.leftSpaceToView(xieyiLabel,0).topSpaceToView(loginbtn,autoScaleH(15));
    [agreementBT setupAutoSizeWithHorizontalPadding:5 buttonHeight:autoScaleH(12)];
    
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(Down)];
    [self.view addGestureRecognizer:tap];

}
-(void)Down
{
    [self.view endEditing:YES];
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    LoginTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"login"];
    if (!cell) {
        cell =[[LoginTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"login"];
    }
    UILabel * linlab =[[UILabel alloc]init];
    linlab.backgroundColor = UIColorFromRGB(0xeeeeee);
    [cell addSubview:linlab];
    linlab.sd_layout.leftSpaceToView(cell,0).rightSpaceToView(cell,0).bottomSpaceToView(cell,0).heightIs(0.5);
    
    cell.selectionStyle= UITableViewCellSelectionStyleNone;
    
    if (indexPath.row==1)
    {
        _mimaBtn = [ButtonStyle buttonWithType:UIButtonTypeCustom];
        _mimaBtn.titleLabel.font = [UIFont systemFontOfSize:autoScaleW(12)];
        [_mimaBtn setTitleColor:UIColorFromRGB(0xfd7577) forState:UIControlStateNormal];
        [_mimaBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
        [_mimaBtn sizeToFit];
        _mimaBtn.layer.borderWidth = 1.0f;
        _mimaBtn.layer.borderColor = [UIColorFromRGB(0xfd7577) CGColor];
        [_mimaBtn addTarget:self action:@selector(Regist) forControlEvents:UIControlEventTouchUpInside];
        [cell addSubview:_mimaBtn];
        _mimaBtn.sd_layout.rightSpaceToView(cell,autoScaleW(15)).topSpaceToView(cell,autoScaleH(10)).widthIs(autoScaleW(80)).heightIs(autoScaleH(25));
    }
    
    cell.leftlabel.text = _titleary[indexPath.row];
    
    if (indexPath.row==1) {
        
        cell.textfild.keyboardType = UIKeyboardTypeNumberPad;
    }
    if (indexPath.row == 2) {
        cell.textfild.secureTextEntry = YES;
    }
    cell.textfild.placeholder = _placeary[indexPath.row];
    if (indexPath.row==0||indexPath.row==2) {
        cell.textfild.clearButtonMode = UITextFieldViewModeWhileEditing;

    }
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return autoScaleH(45);
}
-(void)Regist
{
    NSIndexPath * index1 = [NSIndexPath indexPathForRow:0 inSection:0];
    LoginTableViewCell * cell1 = [_yanzhengtableview cellForRowAtIndexPath:index1];
    NSString *phone = [cell1.textfild.text deleteTabOrSpaceStr];
    if ([phone isEqualToString:@""] || [phone isNull] || ![phone isMobileNumber]) {
        [SVProgressHUD showInfoWithStatus:@"请输入正确的手机号"];
        [cell1.textfild becomeFirstResponder];
        return;
    }
    MessageCodeView *messageView = [[MessageCodeView alloc] initShouldVertifyPhoneNum:NO phoneNumber:nil];
    [messageView showView];

    messageView.complete = ^(NSString *code){



        if (![cell1.textfild.text isEqualToString:@""]) {
            [MBProgressHUD showMessage:@"请稍后"];

            NSString *uploadUrl = [NSString stringWithFormat:@"%@sendSms?phone=%@&inputCode=%@", kBaseURL, [ZT3DesSecurity encryptWithText:phone], code];

            [[QYXNetTool shareManager] postNetWithUrl:uploadUrl urlBody:nil bodyStyle:QYXBodyString header:nil response:QYXJSON success:^(id result) {
                [MBProgressHUD hideHUD];
                [MBProgressHUD hideHUD];

                NSLog(@"lll%@",[result objectForKey:@"msg"]);

                if ([[result objectForKey:@"msgType"] integerValue]==1001) {

                    [MBProgressHUD showError:@"该手机号已注册过"];
                }
                if ([[result objectForKey:@"msg"] isEqualToString:@"发送失败"]) {
                    [MBProgressHUD showError:@"发送失败"];
                }
                if ([[result objectForKey:@"msg"] isEqualToString:@"发送成功"]) {
                    [MBProgressHUD showSuccess:@"发送成功"];
                    [self startTime];
                }
            } failure:^(NSError *error) {
                [MBProgressHUD hideHUD];
            }];
        } else {
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

#pragma mark 勾选
-(void)Choose:(UIButton *)btn
{
    btn.selected = !btn.selected;
    static NSInteger j = 0;
     j +=1;
    if (j % 2 == 0 ) {
        isSelected = YES;
    } else {
        isSelected = NO;
    }
}
#pragma mark 入驻
-(void)Login
{
    
    i+=1;
    

//    VerifyViewController * veriView = [[VerifyViewController alloc]init];
//
//    veriView.veriinter = 1;
//    [self.navigationController pushViewController:veriView animated:YES];

    
////    NSLog(@"...%d",i);
////    
    NSIndexPath * index = [NSIndexPath indexPathForRow:0 inSection:0];
    LoginTableViewCell * cell = [_yanzhengtableview cellForRowAtIndexPath:index];
    NSIndexPath * index1 = [NSIndexPath indexPathForRow:1 inSection:0];
    
    LoginTableViewCell * cell1 = [_yanzhengtableview cellForRowAtIndexPath:index1];
    NSIndexPath * index2 = [NSIndexPath indexPathForRow:2 inSection:0];
    LoginTableViewCell * cell2 = [_yanzhengtableview cellForRowAtIndexPath:index2];

    
    
    
    
    if (![cell.textfild.text isEqualToString:@""]&&![cell1.textfild.text isEqualToString:@""]&&![cell2.textfild.text isEqualToString:@""] && isSelected)
    {
        if (![cell2.textfild.text isValidWithMinLenth:6 maxLenth:16 containChinese:NO containDigtal:YES containLetter:YES containOtherCharacter:nil firstCannotBeDigtal:YES]) {
            [SVProgressHUD showInfoWithStatus:@"密码长度错误或包含违法符号，请重新设置密码"];
            return;
        }
        NSString * url = [NSString stringWithFormat: @"%@ruzhuFirst?code=%@&phone=%@&pwd=%@",kBaseURL,cell1.textfild.text,cell.textfild.text,[ZTMd5Security MD5ForLower32Bate:cell2.textfild.text]];
        
        [MBProgressHUD showMessage:@"请稍后"];
        
            
        [[QYXNetTool shareManager] postNetWithUrl:url urlBody:nil bodyStyle:QYXBodyString header:nil response:QYXJSON success:^(id result) {
             [MBProgressHUD hideHUD];
             NSLog(@"llll%@",result);
             NSString * strr = [result objectForKey:@"msgType"];
             
             if ([strr integerValue]==1002) {
                 [MBProgressHUD showError:@"验证码错误😓"];
                 
             }
             if ([strr integerValue]==1001) {
                 
                 
                 [MBProgressHUD showError:@"该手机号已注册过😨登录即可！"];
                 
             }
             if ([strr integerValue]==1000)
             {
                 [MBProgressHUD showMessage:@"注册成功😁"];
                 [MBProgressHUD hideHUD];
                 i = 0;
                 
                 NSUserDefaults * userde = [NSUserDefaults standardUserDefaults];
                 NSData *archData = [NSKeyedArchiver  archivedDataWithRootObject:result[@"obj"]];
                 [userde setObject:archData forKey:LocationLoginInResultsKey];
                 [userde setObject:cell.textfild.text forKey:@"loginName"];
                 [userde setObject:result[@"obj"][@"token"] forKey:@"token"];
                 VerifyViewController * veriView = [[VerifyViewController alloc]init];
                 veriView.isJohnedStatus = 1;

                 [self.navigationController pushViewController:veriView animated:YES];
             }
         } failure:^(NSError *error)
         {
             [MBProgressHUD hideHUD];
             [MBProgressHUD showError:@"网络错误"];
             
         }];
     }
    else
    {
        if (i==3)
        {
            __weak typeof(self) weakSelf = self;
            
                AuthcodeViewController * authcodeView = [[AuthcodeViewController alloc]init];
                authcodeView.modalPresentationStyle = UIModalPresentationOverCurrentContext ;
                [weakSelf presentViewController:authcodeView animated:YES completion:^{
                    
                    i=0;
                    
                }];
        }
        NSString *title = @"信息不能为空";
        if (isSelected == NO && ![cell.textfild.text isEqualToString:@""]&&![cell1.textfild.text isEqualToString:@""]&&![cell2.textfild.text isEqualToString:@""]) {
            title = @"请同意入驻协议";
        }
        UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"提示" message:title preferredStyle:UIAlertControllerStyleAlert];
        __weak UIAlertAction * cancel = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:nil];
        
        [alert addAction:cancel];
        
        [self presentViewController:alert animated:YES completion:nil];
    }
   
    
}
#pragma mark 协议按钮
-(void)Clickxy {

    AgreementVC *agreementVC = [[AgreementVC alloc] init];
    agreementVC.tempTitle = @"服务协议";
    agreementVC.tempURL = @"https://shop.wdkk.mobi/h5/agreement";
    [self.navigationController pushViewController:agreementVC animated:YES];

}
-(void)leftBarButtonItemAction
{
    [self.navigationController popViewControllerAnimated:NO];

}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)dealloc{

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
