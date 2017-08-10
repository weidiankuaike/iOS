//
//  ChangemimaViewController.m
//  wdKuaiKe_iOS
//
//  Created by 张森森 on 16/12/27.
//  Copyright © 2016年 weiDianKuaiKe. All rights reserved.
//

#import "ChangemimaViewController.h"
#import "UIBarButtonItem+SSExtension.h"
#import "LoginTableViewCell.h"
#import "MBProgressHUD+SS.h"
#import "QYXNetTool.h"
@interface ChangemimaViewController ()
@property (nonatomic,strong)NSArray * titleary;
@property (nonatomic,strong)NSArray * placeary;
@property (nonatomic,strong)UITextField * first;
@property (nonatomic,strong)UITextField * secon;
@property (nonatomic,strong)UITextField * three;
@property (nonatomic,strong)UITableView*yanzhengtableview;
@property (nonatomic,strong) UIButton * loginbtn;
@end

@implementation ChangemimaViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UILabel * titlabel = [[UILabel alloc]init];
    titlabel.frame = CGRectMake(0, 0, 80, 30);
    titlabel.textAlignment = NSTextAlignmentCenter;
    titlabel.font = [UIFont systemFontOfSize:15];
    titlabel.text = @"我的资料";
    titlabel.textColor = [UIColor whiteColor];
    self.navigationItem.titleView = titlabel;
    UIBarButtonItem * backbtn = [UIBarButtonItem itemWithTarget:self Action:@selector(Back) image:@"left-1" selectImage:nil];
    self.navigationItem.leftBarButtonItem = backbtn;
    
    _titleary = @[@"新的密码",@"再次确认",];
    _placeary = @[@"请输入新的登录密码",@"请再次输入密码确认",];
    
    
    _yanzhengtableview = [[UITableView alloc]init];
    _yanzhengtableview.scrollEnabled = NO;
    _yanzhengtableview.delegate = self;
    _yanzhengtableview.dataSource = self;
    _yanzhengtableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_yanzhengtableview];
    _yanzhengtableview.sd_layout.leftSpaceToView(self.view,0).topSpaceToView(self.view,autoScaleH(15)).widthIs(kScreenWith).heightIs(autoScaleH(45*_titleary.count));
    

    
    
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
    _loginbtn.sd_layout.leftSpaceToView(self.view,autoScaleW(15)).rightSpaceToView(self.view,autoScaleW(15)).topSpaceToView(_yanzhengtableview,autoScaleH(50)).heightIs(autoScaleH(30));

    
    
    
    
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
        if ([_secon.text isEqualToString:_first.text]) {
            
            [MBProgressHUD showMessage:@"请稍等"];
             
             NSString * url = [NSString stringWithFormat:@"%@/api/user/userInfoManage?token=%@userId=%@&pwd=%@&opreation=2",commonUrl,Token,Userid,cell1.textfild.text];
             NSArray * urlary = [url componentsSeparatedByString:@"?"];
             
             [[QYXNetTool shareManager]postNetWithUrl:urlary.firstObject urlBody:urlary.lastObject bodyStyle:QYXBodyString header:nil response:QYXJSON success:^(id result)
             
             {
                 NSString * str = [result objectForKey:@"code"];
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
