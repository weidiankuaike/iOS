//
//  ChangetixianViewController.m
//  微点筷客商户端
//
//  Created by 张森森 on 16/10/26.
//  Copyright © 2016年 张森森. All rights reserved.
//

#import "ChangetixianViewController.h"
#import "UIBarButtonItem+SSExtension.h"
#import "MBProgressHUD+SS.h"
#import "LMPopInputPasswordView.h"
#import "NewpsdViewController.h"
#import "ChangeBankViewController.h"
#import "AlipayViewController.h"
#import "QYXNetTool.h"
#import "NumberViewController.h"
#import "PhoneyzViewController.h"
@interface ChangetixianViewController ()<LMPopInputPassViewDelegate,UITextFieldDelegate>
{
    LMPopInputPasswordView *popView;
}
@property (nonatomic,copy) NSString * paypassword;
@property (nonatomic,copy)NSString * token;
@property (nonatomic,copy)NSString * userid;
@property (nonatomic,assign)NSInteger boolint;
@property (nonatomic,assign)NSInteger a ;
//@property (nonatomic,assign)int timeout;
@end
static int timeout;
@implementation ChangetixianViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.titleView.text = @"提现密码";
    self.view.backgroundColor = RGB(242, 242, 242);
    
    CGFloat height = [[UIApplication sharedApplication] statusBarFrame].size.height + self.navigationController.navigationBar.frame.size.height;
    _a = 0;

    popView = [[LMPopInputPasswordView alloc]init];
    popView.backgroundColor = RGB(242, 242, 242);
    popView.titleLabel.text = @"请输入提现密码：";
    popView.frame = CGRectMake((self.view.frame.size.width - 250)*0.5, autoScaleH(75)+height, 250, 150);
    popView.delegate = self;
    popView.textFiled.delegate = self;
    [self.view addSubview:popView];
    
    _token = TOKEN;
    _userid = UserId;
//    NSLog(@"MMM%ld",(long)timeout);
    
}
- (void)leftBarButtonItemAction {
    [self Back];
}
-(void)Back
{
    for (UIViewController *controller in self.navigationController.viewControllers) {
        if ([controller isKindOfClass:[NumberViewController class]]) {
            NumberViewController *revise =(NumberViewController *)controller;
            [self.navigationController popToViewController:revise animated:YES];
        }
    }
    
}
#pragma mark ---LMPopInputPassViewDelegate
-(void)buttonClickedAtIndex:(NSUInteger)index withText:(NSString *)text
{
     _a+=1;
    if (_a==3) {
        
        NSString *message = NSLocalizedString(@"您已连续3次输入错误，请10分钟后重试或点击忘记密码", nil);
        NSString *cancelButtonTitle = NSLocalizedString(@"确定", nil);
        NSString *otherButtonTitle = NSLocalizedString(@"忘记密码", nil);
        
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:message preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:cancelButtonTitle style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            [alertController dismissViewControllerAnimated:YES completion:^{
                
                [self starttime];

            }];
        }];
        
        UIAlertAction *otherAction = [UIAlertAction actionWithTitle:otherButtonTitle style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            
            PhoneyzViewController * phoneyzView = [[PhoneyzViewController alloc]init];
            phoneyzView.tiaointeger = 5;
            phoneyzView.phonestr = LoginName;
            [self.navigationController pushViewController:phoneyzView animated:YES];
            
        }];
        
        [alertController addAction:cancelAction];
        [alertController addAction:otherAction];
        
        [self presentViewController:alertController animated:YES completion:nil];
    }else
    {

    if(index==1){
        if(text.length==0){
//            NSLog(@"密码长度不正确");
        }else if(text.length<6){
//            NSLog(@"密码长度不正确");
        }else{
            
            [MBProgressHUD showMessage:@"请稍等"];
           NSString *uploadUrl = [NSString stringWithFormat:@"%@api/merchant/editWithdrawPwd?token=%@&userId=%@&withdrawPwd=%@",kBaseURL,_token,_userid,[ZTMd5Security MD5ForLower32Bate:text]];
               
             [[QYXNetTool shareManager] postNetWithUrl:uploadUrl urlBody:nil bodyStyle:QYXBodyString header:nil response:QYXJSON success:^(id result) {
                 [MBProgressHUD hideHUD];
                NSString * codestr = [NSString stringWithFormat:@"%@",[result objectForKey:@"msgType"]];
               
                if (![codestr isEqualToString:@"0"]) {
                    
                    NSString *message = NSLocalizedString(@"密码错误，请重新输入！", nil);
                    NSString *cancelButtonTitle = NSLocalizedString(@"确定", nil);
                    
                    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:message preferredStyle:UIAlertControllerStyleAlert];
                    
                    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:cancelButtonTitle style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
                        [alertController dismissViewControllerAnimated:YES completion:^{
                            
                            
                        }];
                    }];
                    [alertController addAction:cancelAction];
                    
                    [self presentViewController:alertController animated:YES completion:nil];
                }
                else
                {
//                    if (_tiaointer==1)
//                    {
//                        NewpsdViewController * newpsdview = [[NewpsdViewController alloc]init];
//                        [self.navigationController pushViewController:newpsdview animated:YES];
//                        
//                    }
//                    if (_tiaointer==2)
//                    {
//                        AlipayViewController * alipayview = [[AlipayViewController alloc]init];
//                        [self.navigationController pushViewController:alipayview animated:YES];
//                        
//                    }
                    
                    NewpsdViewController * newpsdview = [[NewpsdViewController alloc]init];
                   [self.navigationController pushViewController:newpsdview animated:YES];

                    
                    
                    
                }
                
            } failure:^(NSError *error)
            {
                [MBProgressHUD hideHUD];
                [MBProgressHUD showError:@"网络错误"];
                
            }];
            
           }
    }
    }
}


-(void)starttime
{
     timeout=600; //倒计时时间
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
    dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
    dispatch_source_set_event_handler(_timer, ^{
        if(timeout<=0){ //倒计时结束，关闭
            dispatch_source_cancel(_timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置界面的按钮显示 根据自己需求设置
                popView.textFiled.userInteractionEnabled = YES;
                _a = 0 ;
                _boolint=0;
  
            });
        }else
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置界面的按钮显示 根据自己需求设置

                _boolint=1;
                popView.textFiled.userInteractionEnabled = NO;
                
               
            });
            timeout--;
        }
    });
    dispatch_resume(_timer);
}

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{

    if (timeout!=0)
    {
       
        NSString *message = NSLocalizedString(@"由于您输入三次密码错误，请等待", nil);
        NSString *cancelButtonTitle = NSLocalizedString(@"确定", nil);
        
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:message preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:cancelButtonTitle style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
            [alertController dismissViewControllerAnimated:YES completion:^{
                
                
                
            }];
        }];
        [alertController addAction:cancelAction];
        
        [self presentViewController:alertController animated:YES completion:nil];
        
        return NO;
        
    }
    
    return YES;
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
