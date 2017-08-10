//
//  MyWithdrawViewController.m
//  wdKuaiKe_iOS
//
//  Created by 张森森 on 16/12/22.
//  Copyright © 2016年 weiDianKuaiKe. All rights reserved.
//

#import "MyWithdrawViewController.h"
#import "UIBarButtonItem+SSExtension.h"
#import "MBProgressHUD+SS.h"
#import "QYXNetTool.h"
@interface MyWithdrawViewController ()
@property (nonatomic,strong)UITextField* mimatext;
@end

@implementation MyWithdrawViewController
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = NO;
    self.navigationController.navigationBar.translucent = NO;
    [self.navigationController.navigationBar setBarTintColor:UIColorFromRGB(0xfd7577)];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = RGB(238, 238, 238);
    UILabel * titlabel = [[UILabel alloc]init];
    titlabel.frame = CGRectMake(0, 0, 80, 30);
    titlabel.textAlignment = NSTextAlignmentCenter;
    titlabel.font = [UIFont systemFontOfSize:15];
    titlabel.text = @"我的钱包";
    titlabel.textColor = [UIColor whiteColor];
    self.navigationItem.titleView = titlabel;
    UIBarButtonItem * backbtn = [UIBarButtonItem itemWithTarget:self Action:@selector(Back) image:@"left-1" selectImage:nil];
    self.navigationItem.leftBarButtonItem = backbtn;
    
    UIView * headview = [[UIView alloc]init];
    headview.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:headview];
    headview.sd_layout.leftEqualToView(self.view).rightEqualToView(self.view).topSpaceToView(self.view,autoScaleH(10)).heightIs(autoScaleH(160));
    
    UILabel * firstlabel = [[UILabel alloc]init];
    firstlabel.text = @"账户余额";
    firstlabel.font = [UIFont systemFontOfSize:autoScaleW(15)];
    firstlabel.textColor = UIColorFromRGB(0x737373);
    [headview addSubview:firstlabel];
    firstlabel.sd_layout.leftSpaceToView(headview,autoScaleW(90)).centerYEqualToView(headview).widthIs(autoScaleW(70)).heightIs(15);
    
    UILabel * moneylabel = [[UILabel alloc]init];
    moneylabel.font = [UIFont systemFontOfSize:autoScaleW(20)];
    moneylabel.text = _moneystr;
    moneylabel.textColor = UIColorFromRGB(0x000000);
    [headview addSubview:moneylabel];
    moneylabel.sd_layout.leftSpaceToView(firstlabel,autoScaleW(15)).centerYEqualToView(headview).heightIs(autoScaleH(20));
    
    _mimatext = [[UITextField alloc]init];
    _mimatext.placeholder = @"请输入提现金额";
    _mimatext.layer.borderColor = [UIColor lightGrayColor].CGColor;
    _mimatext.layer.borderWidth = 1;
    _mimatext.textAlignment = NSTextAlignmentCenter;
    _mimatext.keyboardType = UIKeyboardTypeNumberPad;
    _mimatext.font = [UIFont systemFontOfSize:autoScaleW(13)];
    [headview addSubview:_mimatext];
    _mimatext.sd_layout.leftSpaceToView(headview ,autoScaleW(15)).topSpaceToView(moneylabel,autoScaleH(17)).widthIs(GetWidth - autoScaleW(30)).heightIs(autoScaleH(40));
    
    UILabel * tishilabel = [[UILabel alloc]init];
    tishilabel.text= @"人民币/元";
    tishilabel.textAlignment = NSTextAlignmentRight;
    tishilabel.font = [UIFont systemFontOfSize:autoScaleW(15)];
    tishilabel.textColor = [UIColor lightGrayColor];
    [_mimatext addSubview:tishilabel];
    tishilabel.sd_layout.rightSpaceToView(_mimatext,autoScaleW(3)).topSpaceToView(_mimatext,autoScaleH(12.5)).widthIs(autoScaleW(120)).heightIs(autoScaleH(15));
    
    UIView * promptview = [[UIView alloc]init];
    promptview.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:promptview];
    promptview.sd_layout.leftEqualToView(self.view).rightEqualToView(self.view).topSpaceToView(headview,autoScaleH(15)).heightIs(autoScaleH(170));
    
    
    UILabel * secondptview = [[UILabel alloc]init];
    secondptview.text = @"温馨提醒：\n1.您每日只有一次提现申请机会\n2.您如果有任何疑问可拨打我们的客服电话：4000865552\n3.我们将在3-5个工作日内联系您进行提现信息核对";
    secondptview.numberOfLines = 0;
    secondptview.textColor = [UIColor blackColor];
    secondptview.font = [UIFont systemFontOfSize:autoScaleW(15)];
    [promptview addSubview:secondptview];
    secondptview.sd_layout.leftSpaceToView(promptview,autoScaleW(15)).rightSpaceToView(promptview,autoScaleW(15)).topSpaceToView(promptview,autoScaleH(15)).autoHeightRatio(0);
    
    UIButton * tixianbtn = [UIButton buttonWithType:UIButtonTypeCustom];
    tixianbtn.backgroundColor = UIColorFromRGB(0xfd7577);
    [tixianbtn setTitle:@"确定" forState:UIControlStateNormal];
    tixianbtn.layer.masksToBounds = YES;
    tixianbtn.layer.cornerRadius = 3;
    tixianbtn.titleLabel.font = [UIFont systemFontOfSize:autoScaleW(15)];
    [tixianbtn addTarget:self action:@selector(Withdraw) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:tixianbtn];
    tixianbtn.sd_layout.leftSpaceToView(self.view,autoScaleW(15)).rightSpaceToView(self.view,autoScaleW(15)).heightIs(autoScaleH(40)).topSpaceToView(promptview,autoScaleH(30));
    
    
}

-(void)Withdraw
{
    if (![_mimatext.text isEqualToString:@""]) {
        
//        NSString * token = [[NSUserDefaults standardUserDefaults]objectForKey:@"token"];
//        NSString * userid = [[NSUserDefaults standardUserDefaults]objectForKey:@"idd"];
        [MBProgressHUD showMessage:@"请稍等"];
        
         NSString * url = [NSString stringWithFormat:@"%@/api/user/AccountManage?token=%@&userId=%@&op=1&payAmount=%@",commonUrl,Token,Userid,_mimatext.text];
         NSArray * urlary = [url componentsSeparatedByString:@"?"];
         
         [[QYXNetTool shareManager]postNetWithUrl:urlary.firstObject urlBody:urlary.lastObject bodyStyle:QYXBodyString header:nil response:QYXJSON success:^(id result)
         
         {
             [MBProgressHUD hideHUD];
             NSLog(@",,,,%@",result);
             
             NSString * typestr = result[@"msgType"];
             if ([typestr isEqualToString:@"0"]) {
                 [MBProgressHUD showSuccess:@"体现成功"];
                 [self Back];
                 
             }
             
             
         } failure:^(NSError *error)
         {
             [MBProgressHUD showError:@"网络错误，提现失败"];
             
         }];

    }
    else
    {
        [MBProgressHUD hideHUD];
        [MBProgressHUD showError:@"请输入金额"];
    }
    
    
    
}

-(void)Back
{
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
