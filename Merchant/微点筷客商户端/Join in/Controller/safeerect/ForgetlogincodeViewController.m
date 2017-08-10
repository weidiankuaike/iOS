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
#import "MBProgressHUD+SS.h"
#import "QYXNetTool.h"
@interface ForgetlogincodeViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong)NSArray * titleary;
@property (nonatomic,strong)NSArray * placeary;
@property (nonatomic,strong)UITextField * first;
@property (nonatomic,strong)UITextField * secon;
@property (nonatomic,strong)UITextField * three;
@property (nonatomic,strong)UIButton * mimaBtn;
@property (nonatomic,strong)UITableView*yanzhengtableview;
@end

@implementation ForgetlogincodeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.titleView.text = @"忘记登录密码";
    self.view.backgroundColor= RGB(242, 242, 242);
    self.automaticallyAdjustsScrollViewInsets = NO;

    
    CGFloat height = [[UIApplication sharedApplication] statusBarFrame].size.height + self.navigationController.navigationBar.frame.size.height;
    NSString * str = [_phonestr substringFromIndex:7];
//    NSLog(@"klk%@",str);
    UILabel * phonelabel = [[UILabel alloc]init];
    phonelabel.text = [NSString stringWithFormat:@"正向%@%@发送验证码:",@"****",str];
    phonelabel.font = [UIFont systemFontOfSize:autoScaleW(13)];
    phonelabel.textColor = [UIColor blackColor];
    [self.view addSubview:phonelabel];
    phonelabel.sd_layout.leftSpaceToView(self.view,autoScaleH(15)).topSpaceToView(self.view,autoScaleH(10)+height).widthIs(kScreenWidth-autoScaleW(30)).heightIs(autoScaleH(15));
    
    _titleary = @[@"验证码",@"新的密码",@"再次确认",];
    _placeary = @[@"请输入验证码",@"请输入新的登录密码",@"请再次输入密码确认",];
    
    
    _yanzhengtableview = [[UITableView alloc]init];
    _yanzhengtableview.scrollEnabled = NO;
    _yanzhengtableview.delegate = self;
    _yanzhengtableview.dataSource = self;
    _yanzhengtableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_yanzhengtableview];
    _yanzhengtableview.sd_layout.leftSpaceToView(self.view,0).topSpaceToView(phonelabel,autoScaleH(15)).widthIs(kScreenWidth).heightIs(autoScaleH(45*_titleary.count));
    
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
    cell.leftlabel.text = _titleary[indexPath.row];
    if (indexPath.row==0) {
        
        _first = cell.textfild;
        
        _mimaBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _mimaBtn.titleLabel.font = [UIFont systemFontOfSize:autoScaleW(13)];
        [_mimaBtn setTitleColor:UIColorFromRGB(0xfd7577) forState:UIControlStateNormal];
        [_mimaBtn sizeToFit];
        _mimaBtn.layer.borderWidth = 1.0f;
        _mimaBtn.layer.borderColor = [UIColorFromRGB(0xfd7577) CGColor];
        [_mimaBtn addTarget:self action:@selector(Clickcode) forControlEvents:UIControlEventTouchUpInside];
        [_mimaBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
        [cell addSubview:_mimaBtn];
        _mimaBtn.sd_layout.rightSpaceToView(cell,autoScaleW(15)).topSpaceToView(cell,autoScaleH(10)).widthIs(autoScaleW(80)).heightIs(autoScaleH(25));

        
        
        
    }
    if (indexPath.row==1) {
        
        _secon = cell.textfild;
    }
    if (indexPath.row==2) {
        
        _three = cell.textfild;
    }
    return cell;
}
-(void)Clickcode
{
    MessageCodeView *messageView = [[MessageCodeView alloc] initShouldVertifyPhoneNum:YES phoneNumber:[ZT3DesSecurity encryptWithText:_phonestr]];
    [messageView showView];

    messageView.complete = ^(NSString *code){

        if (![_phonestr isEqualToString:@""]) {
            [MBProgressHUD showMessage:@"请稍后"];

            NSString *uploadUrl = [NSString stringWithFormat:@"%@common/sendSms?phone=%@&inputCode=%@", kBaseURL, [ZT3DesSecurity encryptWithText:_phonestr], code];
              
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
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return autoScaleH(45);
}

-(void)startTime
{
    __block int timeout=30; //倒计时时间
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
    NSArray * array = self.navigationController.viewControllers;
    [self.navigationController popToViewController:array[2] animated:YES];
    
}
-(void)leftBarButtonItemAction
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
