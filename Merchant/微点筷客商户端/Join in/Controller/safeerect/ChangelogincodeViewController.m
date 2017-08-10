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
#import "NumberViewController.h"
#import "XGPush.h"
#import "ViewController.h"
@interface ChangelogincodeViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong)NSArray * titleary;
@property (nonatomic,strong)NSArray * placeary;
@property (nonatomic,strong)UITextField * first;
@property (nonatomic,strong)UITextField * secon;
@property (nonatomic,strong)UITextField * three;
@property (nonatomic,assign)long iddd;
@property (nonatomic,strong)UITableView*yanzhengtableview;
@end

@implementation ChangelogincodeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.titleView.text = @"修改登录密码";
    self.view.backgroundColor= RGB(242, 242, 242);
    self.automaticallyAdjustsScrollViewInsets = NO;

    
    CGFloat height = [[UIApplication sharedApplication] statusBarFrame].size.height + self.navigationController.navigationBar.frame.size.height;
    _titleary = @[@"旧的密码",@"新的密码",@"再次确认",];
    _placeary = @[@"请输入旧的登录密码",@"请输入新的登录密码",@"请再次输入密码确认",];
    
    
    _yanzhengtableview = [[UITableView alloc]init];
    _yanzhengtableview.scrollEnabled = NO;
    _yanzhengtableview.delegate = self;
    _yanzhengtableview.dataSource = self;
    _yanzhengtableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_yanzhengtableview];
    _yanzhengtableview.sd_layout.leftSpaceToView(self.view,0).topSpaceToView(self.view,autoScaleH(15)+height).widthIs(kScreenWidth).heightIs(autoScaleH(45*_titleary.count));
    
    ButtonStyle * forgetbtn = [ButtonStyle buttonWithType:UIButtonTypeCustom];
    [forgetbtn setTitle:@"忘记密码？" forState:UIControlStateNormal];
    [forgetbtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    forgetbtn.titleLabel.font = [UIFont systemFontOfSize:autoScaleW(11)];
    [forgetbtn addTarget:self action:@selector(Forget) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:forgetbtn];
    forgetbtn.sd_layout.rightSpaceToView(self.view,autoScaleW(30)).topSpaceToView(_yanzhengtableview,autoScaleH(5)).widthIs(autoScaleW(80)).heightIs(autoScaleH(15));
    
    
    ButtonStyle * loginbtn = [ButtonStyle buttonWithType:UIButtonTypeCustom];
    [loginbtn setTitle:@"确认" forState:UIControlStateNormal];
    loginbtn.titleLabel.font = [UIFont systemFontOfSize:autoScaleW(15)];
    [loginbtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    loginbtn.backgroundColor = UIColorFromRGB(0xfd7577);
    [loginbtn addTarget:self action:@selector(Next) forControlEvents:UIControlEventTouchUpInside];
    loginbtn.layer.masksToBounds = YES;
    loginbtn.layer.cornerRadius = autoScaleW(3);
    [self.view addSubview:loginbtn];
    loginbtn.sd_layout.leftSpaceToView(self.view,autoScaleW(15)).rightSpaceToView(self.view,autoScaleW(15)).topSpaceToView(_yanzhengtableview,autoScaleH(30)).heightIs(autoScaleH(30));
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
    
    cell.textfild.secureTextEntry = YES;
    cell.textfild.placeholder = _placeary[indexPath.row];
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


-(void)Next
{
    NSIndexPath * index1 = [NSIndexPath indexPathForRow:0 inSection:0];
    LoginTableViewCell * cell1 = [_yanzhengtableview cellForRowAtIndexPath:index1];
    NSIndexPath * index2 = [NSIndexPath indexPathForRow:1 inSection:0];
    LoginTableViewCell * cell2 = [_yanzhengtableview cellForRowAtIndexPath:index2];
    if (_first.text!=nil&_secon.text!=nil&_three.text!=nil)
    {
        if ([_secon.text isEqualToString:_three.text]) {
            if (![_secon.text isValidWithMinLenth:6 maxLenth:16 containChinese:NO containDigtal:YES containLetter:YES containOtherCharacter:@"" firstCannotBeDigtal:YES]) {
                [SVProgressHUD showInfoWithStatus:@"密码包含违法符号，请重新输入"];
                return;
            }
            [MBProgressHUD showMessage:@"请稍等"];
            NSString *uploadUrl = [NSString stringWithFormat:@"%@api/merchant/editPassword?userId=%@&newPwd=%@&oldPwd=%@&token=%@", kBaseURL,UserId,[ZTMd5Security MD5ForLower32Bate:cell2.textfild.text],[ZTMd5Security MD5ForLower32Bate:cell1.textfild.text], TOKEN];
               
             [[QYXNetTool shareManager] postNetWithUrl:uploadUrl urlBody:nil bodyStyle:QYXBodyString header:nil response:QYXJSON success:^(id result) {
                NSString * str = [result objectForKey:@"msgType"];
                if ([str integerValue]==0) {
                    
                    [MBProgressHUD showSuccess:@"修改成功，请重新登录"];
                    [self registerBTClick];
//                    for (UIViewController *controller in self.navigationController.viewControllers) {
//                        if ([controller isKindOfClass:[NumberViewController class]]) {
//                            NumberViewController *revise =(NumberViewController *)controller;
//                            [self.navigationController popToViewController:revise animated:YES];
//                        }
//                    }

                }
                if ([str integerValue]==1001) {
                    
                    [MBProgressHUD showError:@"旧密码错误"];
                }
                
            } failure:^(NSError *error) {
                
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
    forgetcodeView.phonestr = LoginName;
    [self.navigationController pushViewController:forgetcodeView animated:YES];
}
-(void)leftBarButtonItemAction
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)registerBTClick{
    //清空登录数据
    //    NSString *tempLoginName = LoginName;
    NSUserDefaults *userDefaut = [NSUserDefaults standardUserDefaults];
    [userDefaut setObject:@"error" forKey:@"token"];
    [userDefaut setObject:@"error" forKey:LocationLoginInResultsKey];
    [XGPush delAccount:^{
        if ([TOKEN isEqualToString:@"error"]) {
            //跳转到登录界面
            ViewController *loginVC = [[ViewController alloc] init];
            [self.navigationController pushViewController:loginVC animated:YES];
        }
    } errorCallback:^{
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
