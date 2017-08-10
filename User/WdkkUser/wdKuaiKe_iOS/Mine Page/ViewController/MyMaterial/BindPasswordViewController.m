//
//  BindPasswordViewController.m
//  wdKuaiKe_iOS
//
//  Created by 张森森 on 17/4/1.
//  Copyright © 2017年 weiDianKuaiKe. All rights reserved.
//

#import "BindPasswordViewController.h"
#import "UIBarButtonItem+SSExtension.h"
#import "LoginTableViewCell.h"
#import "MBProgressHUD+SS.h"
#import "QYXNetTool.h"
#import "HomePageVC.h"
@interface BindPasswordViewController ()
@property (nonatomic,strong)UITextField * firstText;
@property (nonatomic,strong)UITextField * againText;
@end

@implementation BindPasswordViewController
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = NO;
    [self.navigationController.navigationBar setBarTintColor:UIColorFromRGB(0xfd7577)];
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    self.view.backgroundColor = RGB(238, 238, 238);
    UILabel * titlabel = [[UILabel alloc]init];
    titlabel.frame = CGRectMake(0, 0, 80, 30);
    titlabel.textAlignment = NSTextAlignmentCenter;
    titlabel.font = [UIFont systemFontOfSize:15];
    titlabel.text = @"绑定密码";
    titlabel.textColor = [UIColor whiteColor];
    self.navigationItem.titleView = titlabel;
    
    UIBarButtonItem * backbtn = [UIBarButtonItem itemWithTarget:self Action:@selector(Back) image:@"left-1" selectImage:nil];
    self.navigationItem.leftBarButtonItem = backbtn;
    
    CGFloat height = [[UIApplication sharedApplication] statusBarFrame].size.height + self.navigationController.navigationBar.frame.size.height;
    
    UITableView *passwordTableview = [[UITableView alloc]init];
    //    yanzhengtableview.scrollEnabled = NO
    passwordTableview.delegate = self;
    passwordTableview.dataSource = self;
    passwordTableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:passwordTableview];
    passwordTableview.sd_layout.leftSpaceToView(self.view,0).topSpaceToView(self.view,height).widthIs(kScreenWith).heightIs(autoScaleH(90));
    
    
    UIButton * loginbtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [loginbtn setTitle:@"确认" forState:UIControlStateNormal];
    loginbtn.titleLabel.font = [UIFont systemFontOfSize:autoScaleW(15)];
    [loginbtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    loginbtn.backgroundColor = UIColorFromRGB(0xfd7577);
    [loginbtn addTarget:self action:@selector(Login) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:loginbtn];
    loginbtn.sd_layout.leftSpaceToView(self.view,autoScaleW(20)).rightSpaceToView(self.view,autoScaleW(20)).topSpaceToView(passwordTableview,autoScaleH(15)).heightIs(autoScaleH(40));

}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    LoginTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"revise"];
    if (!cell) {
        
        cell =[[LoginTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"revise"];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    UILabel * linlab =[[UILabel alloc]init];
    linlab.backgroundColor = UIColorFromRGB(0xeeeeee);
    [cell addSubview:linlab];
    linlab.sd_layout.leftSpaceToView(cell,0).rightSpaceToView(cell,0).bottomSpaceToView(cell,0).heightIs(0.5);
    
    cell.selectionStyle= UITableViewCellSelectionStyleNone;
    NSArray * titleary = @[@"密码",@"确认密码",];
    NSArray * placeary = @[@"请输入密码",@"请再次输入密码",];
    cell.leftlabel.text = titleary[indexPath.row];
    cell.textfild.placeholder = placeary[indexPath.row];
    if (indexPath.row==0) {
        
        _firstText = cell.textfild;
    }
    else if (indexPath.row==1){
        _againText = cell.textfild;
    }
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return autoScaleH(45);
}
- (void)Login{
    if (_firstText.text !=nil&&_againText.text!=nil) {
        
        if ([_firstText.text isEqualToString:_againText.text]) {
            
            NSString * passWord = [ZTMd5Security MD5ForLower32Bate:_firstText.text];
            NSString * url = [NSString stringWithFormat:@"%@/initialPassword?token=%@&userId=%@&password=%@",commonUrl,Token,Userid,passWord];
            NSArray * urlary = [url componentsSeparatedByString:@"?"];
            [MBProgressHUD showMessage:@"请稍等"];
            [[QYXNetTool shareManager]postNetWithUrl:urlary.firstObject urlBody:urlary.lastObject bodyStyle:QYXBodyString header:nil response:QYXJSON success:^(id result) {
                [MBProgressHUD hideHUD];
                NSString * msg = [NSString stringWithFormat:@"%@",result[@"msgType"]];
                if ([msg isEqualToString:@"0"]) {
                    
                    [MBProgressHUD showSuccess:@"绑定成功"];
                    HomePageVC * homevc = [[HomePageVC alloc]init];
                    [self.navigationController pushViewController:homevc animated:YES];
                }
                else{
                    [MBProgressHUD showError:@"绑定失败"];
                }
                
            } failure:^(NSError *error) {
                [MBProgressHUD hideHUD];
                [MBProgressHUD showError:@"请求失败"];
            }];
        }
        else{
            [MBProgressHUD showError:@"两次密码不一致"];
        }
        
        
    }else{
        
        [MBProgressHUD showError:@"内容不能为空"];
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
