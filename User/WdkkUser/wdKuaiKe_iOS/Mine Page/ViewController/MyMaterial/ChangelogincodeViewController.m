//
//  ChangelogincodeViewController.m
//  微点筷客商户端
//
//  Created by 张森森 on 16/10/25.
//  Copyright © 2016年 张森森. All rights reserved.
//

#import "ChangelogincodeViewController.h"
#import "UIBarButtonItem+SSExtension.h"
#import "LoginTableViewCell.h"
#import "ForgetlogincodeViewController.h"
#import "MBProgressHUD+SS.h"
#import "QYXNetTool.h"
@interface ChangelogincodeViewController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>
@property (nonatomic,strong)NSArray * titleary;
@property (nonatomic,strong)NSArray * placeary;
@property (nonatomic,strong)UITextField * first;
@property (nonatomic,strong)UITextField * secon;
@property (nonatomic,strong)UITextField * three;
@property (nonatomic,assign)long iddd;
@property (nonatomic,strong)UITableView*yanzhengtableview;
@property (nonatomic,strong) UIButton * loginbtn;
@end

@implementation ChangelogincodeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UILabel * titlabel = [[UILabel alloc]init];
    titlabel.frame = CGRectMake(0, 0, 80, 30);
    titlabel.textAlignment = NSTextAlignmentCenter;
    titlabel.font = [UIFont systemFontOfSize:15];
    titlabel.text = @"修改密码";
    titlabel.textColor = [UIColor whiteColor];
    self.navigationItem.titleView = titlabel;
    self.view.backgroundColor= RGB(242, 242, 242);
    self.automaticallyAdjustsScrollViewInsets = NO;
    UIBarButtonItem * backbtn = [UIBarButtonItem itemWithTarget:self Action:@selector(Back) image:@"left-1" selectImage:nil];
    self.navigationItem.leftBarButtonItem = backbtn;
    
//    CGFloat height = [[UIApplication sharedApplication] statusBarFrame].size.height + self.navigationController.navigationBar.frame.size.height;
    _titleary = @[@"旧的密码",@"新的密码",@"再次确认",];
    _placeary = @[@"请输入旧的登录密码",@"请输入新的登录密码",@"请再次输入密码确认",];
    
    
    _yanzhengtableview = [[UITableView alloc]init];
    _yanzhengtableview.scrollEnabled = NO;
    _yanzhengtableview.delegate = self;
    _yanzhengtableview.dataSource = self;
    _yanzhengtableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_yanzhengtableview];
    _yanzhengtableview.sd_layout.leftSpaceToView(self.view,0).topSpaceToView(self.view,autoScaleH(15)).widthIs(kScreenWith).heightIs(autoScaleH(45*_titleary.count));
    
    UIButton * forgetbtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [forgetbtn setTitle:@"忘记密码？" forState:UIControlStateNormal];
    [forgetbtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    forgetbtn.titleLabel.font = [UIFont systemFontOfSize:autoScaleW(15)];
    [forgetbtn addTarget:self action:@selector(Forget) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:forgetbtn];
    forgetbtn.sd_layout.rightSpaceToView(self.view,autoScaleW(30)).topSpaceToView(_yanzhengtableview,autoScaleH(10)).widthIs(autoScaleW(80)).heightIs(autoScaleH(20));
    
    
    _loginbtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_loginbtn setTitle:@"确认" forState:UIControlStateNormal];
    _loginbtn.titleLabel.font = [UIFont systemFontOfSize:autoScaleW(15)];
    [_loginbtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _loginbtn.backgroundColor = UIColorFromRGB(0xfd7577);
    [_loginbtn addTarget:self action:@selector(Next) forControlEvents:UIControlEventTouchUpInside];
    _loginbtn.layer.masksToBounds = YES;
    _loginbtn.layer.cornerRadius = autoScaleW(3);
    _loginbtn.userInteractionEnabled = NO;
    [self.view addSubview:_loginbtn];
    _loginbtn.sd_layout.leftSpaceToView(self.view,autoScaleW(15)).rightSpaceToView(self.view,autoScaleW(15)).topSpaceToView(_yanzhengtableview,autoScaleH(50)).heightIs(autoScaleH(40));
    
    NSString * idd = [[NSUserDefaults standardUserDefaults]objectForKey:@"id"];
    _iddd = [idd integerValue];
    
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
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
    cell.textfild.delegate = self;
    cell.leftlabel.text = _titleary[indexPath.row];
    if (indexPath.row==0) {
        
        _first = cell.textfild;
    }
    if (indexPath.row==1) {
        
        _secon = cell.textfild;
    }
    if (indexPath.row==2) {
        
        _three = cell.textfild;
    }
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return  autoScaleH(45);
}
-(void) textFieldDidEndEditing:(UITextField *)textField
{
    if (textField==_first&&_first.text!=nil) {
        
        NSString * oldPass = [ZTMd5Security MD5ForLower32Bate:_first.text];
         NSString * url = [NSString stringWithFormat:@"%@/api/user/userInfoManage?token=%@&userId=%@&oldPwd=%@&operation=3",commonUrl,Token,Userid,oldPass];
         NSArray * urlary = [url componentsSeparatedByString:@"?"];
         
         [[QYXNetTool shareManager]postNetWithUrl:urlary.firstObject urlBody:urlary.lastObject bodyStyle:QYXBodyString header:nil response:QYXJSON success:^(id result)
         {
             NSLog(@">>>%@",result);
             NSString * str = [NSString stringWithFormat:@"%@",[result objectForKey:@"msgType"]];
             if ([str isEqualToString:@"1"])
             {
                 [MBProgressHUD showError:@"原密码错误"];
             }
             else if ([str isEqualToString:@"0"])
             {
                 _loginbtn.userInteractionEnabled = YES;
                 _loginbtn.backgroundColor = UIColorFromRGB(0xfd7577);
             }
             
         } failure:^(NSError *error) {
             [MBProgressHUD hideHUD];
             [MBProgressHUD showError:@"请求失败"];
         }];

        
    }
}
-(void)Next
{
    
    if (_first.text!=nil&&_secon.text!=nil&&_three.text!=nil)
    {
        if ([_secon.text isEqualToString:_three.text]) {
            
            [MBProgressHUD showMessage:@"请稍等"];
            
            NSString * oldPass = [ZTMd5Security MD5ForLower32Bate:_first.text];
            NSString * newPass = [ZTMd5Security MD5ForLower32Bate:_secon.text];
            
             NSString * url = [NSString stringWithFormat:@"%@/api/user/userInfoManage?token=%@&userId=%@&pwd=%@&oldPwd=%@&operation=2",commonUrl,Token,Userid,newPass,oldPass];
             NSArray * urlary = [url componentsSeparatedByString:@"?"];
             
             [[QYXNetTool shareManager]postNetWithUrl:urlary.firstObject urlBody:urlary.lastObject bodyStyle:QYXBodyString header:nil response:QYXJSON success:^(id result)
            {
                [MBProgressHUD hideHUD];
                NSString * str = [result objectForKey:@"msgType"];
                if ([str integerValue]==0) {
                    
                    [MBProgressHUD showSuccess:@"修改成功"];
                    
                    [self.navigationController popViewControllerAnimated:YES];
                    
                    
                }
                if ([str integerValue]==1001) {
                    
                    [MBProgressHUD showError:@"旧密码错误"];
                }
                
            } failure:^(NSError *error) {
                
                [MBProgressHUD hideHUD];
                [MBProgressHUD showError:@"请求失败"];
            }];
            
            
            
        }
        else
        {
            [MBProgressHUD showError:@"两次密码不一致"];
        }
     }
    else
    {
        [MBProgressHUD showError:@"信息不能为空"];
    
    }
 }
-(void)Forget
{
    ForgetlogincodeViewController * forgetcodeView = [[ForgetlogincodeViewController alloc]init];
    
    [self.navigationController pushViewController:forgetcodeView animated:YES];
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
