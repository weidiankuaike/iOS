//
//  AlipayViewController.m
//  微点筷客商户端
//
//  Created by 张森森 on 16/12/6.
//  Copyright © 2016年 张森森. All rights reserved.
//

#import "AlipayViewController.h"
#import "UIBarButtonItem+SSExtension.h"
#import "NumberViewController.h"
#import "MBProgressHUD+SS.h"
#import "QYXNetTool.h"
@interface AlipayViewController ()
@property (nonatomic,strong)UITextField * textfild;
@property (nonatomic,strong)ButtonStyle * mimaBtn;
@property (nonatomic,copy)NSString * token;
@property (nonatomic,copy)NSString * userid;
@end

@implementation AlipayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.titleView.text = @"提现设置";
    self.view.backgroundColor = UIColorFromRGB(0xffffff);
    
    

    CGFloat height = [[UIApplication sharedApplication] statusBarFrame].size.height + self.navigationController.navigationBar.frame.size.height;
    
    UIView* headlabel = [[UIView alloc]init];
    headlabel.backgroundColor = RGB(242, 242, 242);
    [self.view addSubview:headlabel];
    headlabel.sd_layout.leftEqualToView(self.view).rightEqualToView(self.view).topSpaceToView(self.view,height).heightIs(autoScaleH(20));
    
        UIImageView * tanimage = [[UIImageView alloc]init];
        tanimage.image =[UIImage imageNamed:@"感叹号"];
        [headlabel addSubview:tanimage];
        tanimage.sd_layout.leftSpaceToView(headlabel,autoScaleW(15)).topSpaceToView(headlabel,autoScaleH(5)).widthIs(autoScaleW(10)).heightIs(autoScaleH(10));
    
    
    
        UILabel* headlabell = [[UILabel alloc]init];
        headlabell.text = @"为了您的资金安全，请务必使用本人支付宝账号";
        headlabell.textColor = UIColorFromRGB(0xfd7577);
        headlabell.font = [UIFont systemFontOfSize:autoScaleW(11)];
        [headlabel addSubview:headlabell];
        headlabell.sd_layout.leftSpaceToView(tanimage,autoScaleW(2)).widthIs(kScreenWidth-autoScaleW(30)).topSpaceToView(headlabel,autoScaleH(2)).heightIs(autoScaleH(15));
    
    UIView * codeveiw =[[UIView alloc]init];
    codeveiw.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:codeveiw];
    codeveiw.sd_layout.leftSpaceToView(self.view,0).topSpaceToView(headlabel,autoScaleH(10)).widthIs(kScreenWidth).heightIs(autoScaleH(45));
    
    UILabel* _leftlabel = [[UILabel alloc]init];
    _leftlabel.font = [UIFont systemFontOfSize:autoScaleW(13)];
    _leftlabel.text = @"支付宝账号";
    _leftlabel.textAlignment = NSTextAlignmentLeft;
    [codeveiw addSubview:_leftlabel];
    _leftlabel.sd_layout.leftSpaceToView(self,autoScaleW(15)).topSpaceToView(self,autoScaleH(15)).widthIs(autoScaleW(120)).heightIs(autoScaleH(15));
    
    _textfild =[[UITextField alloc]init];
    _textfild.placeholder = @"请输入您的支付宝账号";
    _textfild.font = [UIFont systemFontOfSize:autoScaleW(13)];
    _textfild.clearButtonMode = UITextFieldViewModeWhileEditing;
    [codeveiw addSubview:_textfild];
    _textfild.sd_layout.leftSpaceToView(_leftlabel,0).topSpaceToView(self,autoScaleH(15)).widthIs(autoScaleW(200)).heightIs(autoScaleH(15));
    
    ButtonStyle * loginbtn = [ButtonStyle buttonWithType:UIButtonTypeCustom];
    [loginbtn setTitle:@"确认" forState:UIControlStateNormal];
    loginbtn.titleLabel.font = [UIFont systemFontOfSize:autoScaleW(15)];
    [loginbtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    loginbtn.backgroundColor = UIColorFromRGB(0xfd7577);
    [loginbtn addTarget:self action:@selector(Next) forControlEvents:UIControlEventTouchUpInside];
    loginbtn.layer.masksToBounds = YES;
    loginbtn.layer.cornerRadius = autoScaleW(3);
    [self.view addSubview:loginbtn];
    loginbtn.sd_layout.leftSpaceToView(self.view,autoScaleW(15)).rightSpaceToView(self.view,autoScaleW(15)).topSpaceToView(codeveiw,autoScaleH(15)).heightIs(autoScaleH(30));
  
    
    _token = TOKEN;
    _userid = UserId;
    
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
-(void)Next
{
    [MBProgressHUD showMessage:@"请稍等"];
    NSString *uploadUrl = [NSString stringWithFormat:@"%@api/merchant/editBankOrAlipay?token=%@&userId=%@&alipay=%@&type=alipay", kBaseURL,_token,_userid,_textfild.text];
      
    [[QYXNetTool shareManager] postNetWithUrl:uploadUrl urlBody:nil bodyStyle:QYXBodyString header:nil response:QYXJSON success:^(id result) {
        [MBProgressHUD hideHUD];
        NSString * codestr = [NSString stringWithFormat:@"%@",[result objectForKey:@"msgType"]];
        if ([codestr isEqualToString:@"0"])
        {
            [MBProgressHUD showSuccess:@"绑定成功"];
            
                for (UIViewController *controller in self.navigationController.viewControllers) {
                    if ([controller isKindOfClass:[NumberViewController class]]) {
                        NumberViewController *revise =(NumberViewController *)controller;
                        [self.navigationController popToViewController:revise animated:YES];
                    }
                }
        }
        else
        {
            [MBProgressHUD showError:@"绑定失败"];
        }
        
        
    } failure:^(NSError *error)
    {
        [MBProgressHUD hideHUD];
        
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
