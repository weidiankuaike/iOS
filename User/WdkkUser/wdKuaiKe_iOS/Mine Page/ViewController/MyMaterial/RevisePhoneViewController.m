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
#import "NSString+Expend.h"
#import "ZT3DesSecurity.h"
#import "MessageCodeView.h"
@interface RevisePhoneViewController ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)NSArray * titleary,*placeary;
@property (nonatomic,strong)UIButton* mimaBtn;
@property (nonatomic,strong)UITableView * yanzhengtableview;
@property (nonatomic,strong)UIButton * daitibtn;
@property (nonatomic,assign)long iddd;
@property (nonatomic,copy)NSString * tokenstr;
@end

@implementation RevisePhoneViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    self.view.backgroundColor = RGB(238, 238, 238);
    UILabel * titlabel = [[UILabel alloc]init];
    titlabel.frame = CGRectMake(0, 0, 80, 30);
    titlabel.textAlignment = NSTextAlignmentCenter;
    titlabel.font = [UIFont systemFontOfSize:15];
    if (_pushint==1) {
        
        titlabel.text = @"手机验证";

    }else{
        titlabel.text = @"手机绑定";

    }
    titlabel.textColor = [UIColor whiteColor];
    self.navigationItem.titleView = titlabel;
    
    UIBarButtonItem * backbtn = [UIBarButtonItem itemWithTarget:self Action:@selector(Back) image:@"left-1" selectImage:nil];
    self.navigationItem.leftBarButtonItem = backbtn;
    
    CGFloat height = [[UIApplication sharedApplication] statusBarFrame].size.height + self.navigationController.navigationBar.frame.size.height;
    
    _yanzhengtableview = [[UITableView alloc]init];
    //    yanzhengtableview.scrollEnabled = NO
    _yanzhengtableview.delegate = self;
    _yanzhengtableview.dataSource = self;
    _yanzhengtableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_yanzhengtableview];
    _yanzhengtableview.sd_layout.leftSpaceToView(self.view,0).topSpaceToView(self.view,autoScaleH(15)).widthIs(kScreenWith).heightIs(autoScaleH(90));
    
    _titleary = @[@"手机号",@"验证码",];
    _placeary = @[@"请输入新手机号",@"请输入验证码",];
    
    UIButton * loginbtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [loginbtn setTitle:@"确认" forState:UIControlStateNormal];
    loginbtn.titleLabel.font = [UIFont systemFontOfSize:autoScaleW(15)];
    [loginbtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    loginbtn.backgroundColor = UIColorFromRGB(0xfd7577);
    [loginbtn addTarget:self action:@selector(Login) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:loginbtn];
    loginbtn.sd_layout.leftSpaceToView(self.view,autoScaleW(20)).rightSpaceToView(self.view,autoScaleW(20)).topSpaceToView(_yanzhengtableview,autoScaleH(15)).heightIs(autoScaleH(30));
    
    NSString * idd = [[NSUserDefaults standardUserDefaults]objectForKey:@"userid"];
    _iddd = [idd integerValue];
    
    _tokenstr = [[NSUserDefaults standardUserDefaults]objectForKey:@"token"];
    
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
        
//        cell.textfild.secureTextEntry = YES;
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
    NSIndexPath * index1 = [NSIndexPath indexPathForRow:0 inSection:0];
    LoginTableViewCell * cell1 = [_yanzhengtableview cellForRowAtIndexPath:index1];

    
    
    if (cell1.textfild.text!=nil&&[cell1.textfild.text isMobileNumber:cell1.textfild.text]) {
        if (_pushint==2) {
            
            
            MessageCodeView * codeview = [[MessageCodeView alloc]init];
            [codeview showView];
            codeview.complete = ^(NSString * codestr){
                [MBProgressHUD showMessage:@"请稍后"];
                NSString * phonestr = [ZT3DesSecurity encryptWithText:cell1.textfild.text];
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
        [MBProgressHUD showMessage:@"请稍后"];
        NSString * url = [NSString stringWithFormat:@"%@/api/user/userInfoManage?token=%@&userId=%@&phone=%@&operation=5",commonUrl,Token,Userid,cell1.textfild.text];
        NSArray * urlary = [url componentsSeparatedByString:@"?"];
        
        [[QYXNetTool shareManager]postNetWithUrl:urlary.firstObject urlBody:urlary.lastObject bodyStyle:QYXBodyString header:nil response:QYXJSON success:^(id result)
         
         {
             [MBProgressHUD hideHUD];
             
             NSString *codestr= [NSString stringWithFormat:@"%@",[result objectForKey:@"msgType"]];
             if ([codestr isEqualToString:@"0"]) {
                 
                 MessageCodeView * codeview = [[MessageCodeView alloc]init];
                 [codeview showView];
                 codeview.complete = ^(NSString * codestr){
                     [MBProgressHUD showMessage:@"请稍后"];
                     NSString * phonestr = [ZT3DesSecurity encryptWithText:cell1.textfild.text];
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
                 [MBProgressHUD showError:@"该手机已被使用"];
             }
            
         } failure:^(NSError *error) {
             [MBProgressHUD hideHUD];
             [MBProgressHUD showError:@"发送失败"];
             
         }];
    }
        }
    
    else
    {
        [MBProgressHUD showError:@"请输入正确手机号"];
    }

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
-(void)text:(reviseBlock)block
{
    self.block = block;
}

-(void)Login
{
    NSIndexPath * index1 = [NSIndexPath indexPathForRow:0 inSection:0];
    LoginTableViewCell * cell1 = [_yanzhengtableview cellForRowAtIndexPath:index1];
    NSIndexPath * index2 = [NSIndexPath indexPathForRow:1 inSection:0];
    LoginTableViewCell * cell2 = [_yanzhengtableview cellForRowAtIndexPath:index2];
    
    if (cell1.textfild.text!=nil&&cell2.textfild.text!=nil) {
        if (_pushint==2) {//判断是从订单页面还是个人资料页面过来的
            [MBProgressHUD showMessage:@"请稍等"];
            
            NSString * urlstr = [NSString stringWithFormat:@"%@/api/user/bindingPhone?token=%@&userId=%@&mobile=%@&code=%@",commonUrl,Token,Userid,cell1.textfild.text,cell2.textfild.text];
            
            NSArray * urlary = [urlstr componentsSeparatedByString:@"?"];
            
            [[QYXNetTool shareManager]postNetWithUrl:urlary.firstObject urlBody:urlary.lastObject bodyStyle:QYXBodyString header:nil response:QYXJSON success:^(id result) {
              
              [MBProgressHUD hideHUD];
                NSLog(@">>>>%@",result);
                NSString * msgstr = [NSString stringWithFormat:@"%@",result[@"msgType"]];
                if ([msgstr isEqualToString:@"0"]) {
                    
                    [MBProgressHUD showSuccess:@"绑定成功"];
                    NSString * userid = [NSString stringWithFormat:@"%@",result[@"obj"]];
                    [[NSUserDefaults standardUserDefaults]setObject:userid forKey:@"idd"];
                    [[NSUserDefaults standardUserDefaults] synchronize];
                    [self.navigationController popViewControllerAnimated:YES];
                }else if([msgstr isEqualToString:@"2"]){
                    [MBProgressHUD showError:@"验证码错误"];
                }else{
                    [MBProgressHUD showError:@"网络参数错误"];
                }
           } failure:^(NSError *error) {
              
              [MBProgressHUD hideHUD];
          }];
         }
        else
        {
            [MBProgressHUD showMessage:@"请稍等"];
           
            NSString * url = [NSString stringWithFormat:@"%@/api/common/validateSms?code=%@&phone=%@",commonUrl,cell2.textfild.text,cell1.textfild.text];
             NSArray * urlary = [url componentsSeparatedByString:@"?"];
             
             [[QYXNetTool shareManager]postNetWithUrl:urlary.firstObject urlBody:urlary.lastObject bodyStyle:QYXBodyString header:nil response:QYXJSON success:^(id result)
             {
                
                  
                  NSString * url = [NSString stringWithFormat:@"%@/api/user/userInfoManage?token=%@&userId=%@&phone=%@&operation=4",commonUrl,Token,Userid,cell1.textfild.text];
                  NSArray * urlary = [url componentsSeparatedByString:@"?"];
                  
                  [[QYXNetTool shareManager]postNetWithUrl:urlary.firstObject urlBody:urlary.lastObject bodyStyle:QYXBodyString header:nil response:QYXJSON success:^(id result)
                  
                  {
                      [MBProgressHUD hideHUD];
                      
                      NSLog(@"<><><><%@",result);
                      
                      NSString * codestr = [NSString stringWithFormat:@"%@",[result objectForKey:@"msgType"]];
                      if ([codestr isEqualToString:@"0"]) {
                          [MBProgressHUD showSuccess:@"修改成功"];
                          
                          if (self.block!=nil) {
                              
                              self.block (cell1.textfild.text);
                          }
                          [self.navigationController popViewControllerAnimated:NO];
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
}
-(void)Back
{   
    if (self.block!=nil) {
        
        self.block (@"0");
    }
    [self.navigationController popViewControllerAnimated:NO];
    
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
