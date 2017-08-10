//
//  NewFeedbackViewController.m
//  wdKuaiKe_iOS
//
//  Created by 张森森 on 16/9/22.
//  Copyright © 2016年 weiDianKuaiKe. All rights reserved.
//

#import "NewFeedbackViewController.h"
#import "UIBarButtonItem+SSExtension.h"
#import "MBProgressHUD+SS.h"
#import "QYXNetTool.h"

@interface NewFeedbackViewController ()<UITextViewDelegate>
@property(nonatomic,strong)UILabel * pllabel;
@property(nonatomic,strong)UITextView * feedbackview;
@end

@implementation NewFeedbackViewController
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = NO;
    self.navigationController.navigationBar.translucent = NO;
    [self.navigationController.navigationBar setBarTintColor:UIColorFromRGB(0xfd7577)];
    self.tabBarController.tabBar.hidden = YES;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = RGB(238, 238, 238);
    UILabel * titlabel = [[UILabel alloc]init];
    titlabel.frame = CGRectMake(0, 0, 80, 30);
    titlabel.textAlignment = NSTextAlignmentCenter;
    titlabel.font = [UIFont systemFontOfSize:15];
    titlabel.text = @"意见反馈";
    titlabel.textColor = [UIColor whiteColor];
    self.navigationItem.titleView = titlabel;
    UIBarButtonItem * backbtn = [UIBarButtonItem itemWithTarget:self Action:@selector(Back) image:@"left-1" selectImage:nil];
    self.navigationItem.leftBarButtonItem = backbtn;
    
    UIView * firstview = [[UIView alloc]init];
    firstview.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:firstview];
    firstview.sd_layout.leftEqualToView(self.view).rightEqualToView(self.view).topSpaceToView(self.view,autoScaleH(15)).heightIs(autoScaleH(160));
    
    UILabel * firstlabel = [[UILabel alloc]init];
    firstlabel.text = @"亲爱的用户您好:";
    firstlabel.font = [UIFont systemFontOfSize:autoScaleW(15)];
    firstlabel.textColor = UIColorFromRGB(0x000000);
    [firstview addSubview:firstlabel];
    firstlabel.sd_layout.leftSpaceToView(firstview,autoScaleW(15)).topSpaceToView(firstview,autoScaleH(15)).widthIs(autoScaleW(150)).heightIs(autoScaleH(20));
    UILabel * detaillabel = [[UILabel alloc]init];
    detaillabel.text = @"我们的产品刚刚上线，产品可能存在很多问题，招待不周的地方还望谅解。同时我们殷切希望能得到您的指点和宝贵意见。谢谢您！\n                                           ———   一只卑微的产品汪";
    detaillabel.font = [UIFont systemFontOfSize:autoScaleW(13)];
    detaillabel.textColor = UIColorFromRGB(0x000000);
    [firstview addSubview:detaillabel];
    detaillabel.sd_layout.leftEqualToView(firstlabel).rightSpaceToView(firstview,autoScaleW(15)).topSpaceToView(firstlabel,autoScaleH(10)).autoHeightRatio(0);
    
    
    _feedbackview = [[UITextView alloc]init];
    _feedbackview.font = [UIFont systemFontOfSize:autoScaleW(13)];
    _feedbackview.delegate = self;
    [self.view addSubview:_feedbackview];
    _feedbackview.sd_layout.leftSpaceToView(self.view,0).rightSpaceToView(self.view,0).topSpaceToView(firstview,autoScaleH(15)).heightIs(autoScaleH(100));
    _pllabel = [[UILabel alloc]init];
    _pllabel.enabled = NO;
    _pllabel.text = @"请留下您的宝贵意见和建议，我们将努力改进";
    _pllabel.font =[UIFont systemFontOfSize:autoScaleW(13)];
    _pllabel.backgroundColor = [UIColor clearColor];
    CGSize size = [_pllabel.text sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:_pllabel.font,NSFontAttributeName, nil]];
    CGFloat wind = size.width;
    [_feedbackview addSubview:_pllabel];
    _pllabel.sd_layout.leftSpaceToView(_feedbackview,10).topSpaceToView(_feedbackview,autoScaleH(10)).widthIs(wind).heightIs(autoScaleH(15));
    
    UIButton * tijiaoBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [tijiaoBtn setTitle:@"点击提交" forState:UIControlStateNormal];
    [tijiaoBtn setBackgroundColor:UIColorFromRGB(0xfd7577)];
    [tijiaoBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    //    tijiaoBtn .titleLabel.font =[UIFont systemFontOfSize:autoScaleW(15)];
    [tijiaoBtn addTarget:self action:@selector(tijiao) forControlEvents:UIControlEventTouchUpInside];
    tijiaoBtn.layer.cornerRadius = 3;
    [self.view addSubview:tijiaoBtn];
    tijiaoBtn.sd_layout.leftSpaceToView(self.view,autoScaleW(15)).rightSpaceToView(self.view,autoScaleW(15)).topSpaceToView(_feedbackview,autoScaleH(44)).heightIs(autoScaleH(43));

    if ([self respondsToSelector:@selector(setAutomaticallyAdjustsScrollViewInsets:)]) {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    
    UITapGestureRecognizer * tap1 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(Remove)];
    [self.view addGestureRecognizer:tap1];
    
}
#pragma mark 判断提示词的消失
-(void)textViewDidChange:(UITextView *)textView
{
    if (textView.text.length ==0) {
        
        _pllabel.text = @"请留下您的宝贵意见和建议，我们将努力改进";
    }
    else
    {
        _pllabel.text = @"";
    }
}
#pragma mark 取消键盘
-(void)Remove
{
    [self.view endEditing:YES];
}
-(void)tijiao
{
    if (_feedbackview.text!=nil) {
        
        [MBProgressHUD showMessage:@"请稍等"];
       
         NSString * url = [NSString stringWithFormat:@"%@/api/user/submitFeedback?token=%@&userId=%@&content=%@",commonUrl,Token,Userid,_feedbackview.text];
         NSArray * urlary = [url componentsSeparatedByString:@"?"];
         
         [[QYXNetTool shareManager]postNetWithUrl:urlary.firstObject urlBody:urlary.lastObject bodyStyle:QYXBodyString header:nil response:QYXJSON success:^(id result)
         
         
         {
             [MBProgressHUD hideHUD];
             NSLog(@"MMMM%@",result);
             NSString * codestr = [NSString stringWithFormat:@"%@",[result objectForKey:@"msgType"]];
             if ([codestr isEqualToString:@"0"]) {
                 
                 [MBProgressHUD showSuccess:@"发送成功"];
                 [self Back];
             }
             else
             {
                 [MBProgressHUD showError:@"提交失败"];
             }
             
             
         } failure:^(NSError *error)
         {
             [MBProgressHUD hideHUD];
             [MBProgressHUD showError:@"网络错误"];
             
         }];

    }
    else
    {
        [MBProgressHUD showError:@"请输入信息"];
    }
    
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
