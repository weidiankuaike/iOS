//
//  RevisePhoneViewController.m
//  微点筷客商户端
//
//  Created by 张森森 on 16/10/25.
//  Copyright © 2016年 张森森. All rights reserved.
//

#import "RevisePhoneViewController.h"
#import "UIBarButtonItem+SSExtension.h"
#import "LoginTableViewCell.h"
#import "MBProgressHUD+SS.h"
#import "QYXNetTool.h"
#import "NumberViewController.h"
@interface RevisePhoneViewController ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)NSArray * titleary,*placeary;
@property (nonatomic,strong)UIButton * mimaBtn;
@property (nonatomic,strong)UITableView * yanzhengtableview;
@property (nonatomic,strong)ButtonStyle * daitibtn;
@property (nonatomic,assign)long iddd;
@property (nonatomic,copy)NSString * tokenstr;
@end

@implementation RevisePhoneViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    self.titleView.text = @"手机验证";
    self.view.backgroundColor = RGB(242, 242, 242);

    
    CGFloat height = [[UIApplication sharedApplication] statusBarFrame].size.height + self.navigationController.navigationBar.frame.size.height;
    
    _yanzhengtableview = [[UITableView alloc]init];
    //    yanzhengtableview.scrollEnabled = NO
    _yanzhengtableview.delegate = self;
    _yanzhengtableview.dataSource = self;
    _yanzhengtableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_yanzhengtableview];
    _yanzhengtableview.sd_layout.leftSpaceToView(self.view,0).topSpaceToView(self.view,autoScaleH(15)+height).widthIs(kScreenWidth).heightIs(autoScaleH(90));
    
    _titleary = @[@"手机号",@"验证码",];
    _placeary = @[@"请输入新手机号",@"请输入验证码",];
    
    ButtonStyle * loginbtn = [ButtonStyle buttonWithType:UIButtonTypeCustom];
    [loginbtn setTitle:@"确认" forState:UIControlStateNormal];
    loginbtn.titleLabel.font = [UIFont systemFontOfSize:autoScaleW(15)];
    [loginbtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    loginbtn.backgroundColor = UIColorFromRGB(0xfd7577);
    [loginbtn addTarget:self action:@selector(Login) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:loginbtn];
    loginbtn.sd_layout.leftSpaceToView(self.view,autoScaleW(20)).rightSpaceToView(self.view,autoScaleW(20)).topSpaceToView(_yanzhengtableview,autoScaleH(15)).heightIs(autoScaleH(30));
    
    NSString * idd = UserId;
    _iddd = [idd integerValue];
    
    _tokenstr = TOKEN;
    
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
    
    if (indexPath.row==1)
    {
        _mimaBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _mimaBtn.titleLabel.font = [UIFont systemFontOfSize:autoScaleW(12)];
        [_mimaBtn setTitleColor:UIColorFromRGB(0xfd7577) forState:UIControlStateNormal];
        [_mimaBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
        [_mimaBtn sizeToFit];
        _mimaBtn.layer.borderWidth = 1.0f;
        _mimaBtn.layer.borderColor = [UIColorFromRGB(0xfd7577) CGColor];
        [_mimaBtn addTarget:self action:@selector(Regist) forControlEvents:UIControlEventTouchUpInside];
        [cell addSubview:_mimaBtn];
        _mimaBtn.sd_layout.rightSpaceToView(cell,autoScaleW(15)).topSpaceToView(cell,autoScaleH(10)).widthIs(autoScaleW(80)).heightIs(autoScaleH(25));
        
        cell.textfild.secureTextEntry = YES;
    }
    cell.leftlabel.text = _titleary[indexPath.row];
    cell.textfild.placeholder = _placeary[indexPath.row];
    return cell;
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

        NSIndexPath * index1 = [NSIndexPath indexPathForRow:0 inSection:0];
        LoginTableViewCell * cell1 = [_yanzhengtableview cellForRowAtIndexPath:index1];

        if (![cell1.textfild.text isEqualToString:@""]) {
            [MBProgressHUD showMessage:@"请稍后"];

            NSString *uploadUrl = [NSString stringWithFormat:@"%@common/sendSms?phone=%@&inputCode=%@", kBaseURL, [ZT3DesSecurity encryptWithText:cell1.textfild.text], code];
              
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


-(void)Login
{
    NSIndexPath * index1 = [NSIndexPath indexPathForRow:0 inSection:0];
    LoginTableViewCell * cell1 = [_yanzhengtableview cellForRowAtIndexPath:index1];
    NSIndexPath * index2 = [NSIndexPath indexPathForRow:1 inSection:0];
    LoginTableViewCell * cell2 = [_yanzhengtableview cellForRowAtIndexPath:index2];
    
    if (cell1.textfild.text!=nil&&cell2.textfild.text!=nil) {
        
        [MBProgressHUD showMessage:@"请稍等"];
        NSString *uploadUrl = [NSString stringWithFormat:@"%@api/common/validateSms?code=%@&phone=%@",kBaseURL,cell2.textfild.text,cell1.textfild.text];
           
         [[QYXNetTool shareManager] postNetWithUrl:uploadUrl urlBody:nil bodyStyle:QYXBodyString header:nil response:QYXJSON success:^(id result) {
             
             NSString *secondUrl = [NSString stringWithFormat:@"%@api/merchant/editPhone?token=%@&id=%ld&phone=%@",kBaseURL,_tokenstr,_iddd,cell1.textfild.text];
              NSArray *secPostArr = [secondUrl getUrlTransToPostUrlArray];
              [[QYXNetTool shareManager] postNetWithUrl:[secPostArr firstObject] urlBody:[secPostArr lastObject] bodyStyle:QYXBodyString header:nil response:QYXJSON success:^(id result) {
                  [MBProgressHUD hideHUD];
                  
                  NSLog(@"<><><><%@",result);
                  
                  NSString * codestr = [NSString stringWithFormat:@"%@",[result objectForKey:@"msgType"]];
                  if ([codestr isEqualToString:@"0"]) {
                      [MBProgressHUD showSuccess:@"修改成功"];
                      for (UIViewController *controller in self.navigationController.viewControllers) {
                          if ([controller isKindOfClass:[NumberViewController class]]) {
                              NumberViewController *revise =(NumberViewController *)controller;
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
             
             
             
             
             
         } failure:^(NSError *error)
         {
             [MBProgressHUD hideHUD];
             [MBProgressHUD showError:@"验证码错误"];
             
         }];

    }
    
    
  
}
-(void)leftBarButtonItemAction
{   
    for (UIViewController *controller in self.navigationController.viewControllers) {
        if ([controller isKindOfClass:[NumberViewController class]]) {
            NumberViewController *revise =(NumberViewController *)controller;
            [self.navigationController popToViewController:revise animated:YES];
        }
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
