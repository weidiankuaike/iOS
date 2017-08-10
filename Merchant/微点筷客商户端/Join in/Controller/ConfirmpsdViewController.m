//
//  ConfirmpsdViewController.m
//  微点筷客商户端
//
//  Created by 张森森 on 16/10/26.
//  Copyright © 2016年 张森森. All rights reserved.
//

#import "ConfirmpsdViewController.h"
#import "MBProgressHUD+SS.h"
#import "LMPopInputPasswordView.h"
#import "NumberViewController.h"
#import "QYXNetTool.h"
@interface ConfirmpsdViewController ()<LMPopInputPassViewDelegate>
{
    LMPopInputPasswordView *popView;
}
@property (nonatomic,copy)NSString *iddd;
@property (nonatomic,copy)NSString * token;
@end

@implementation ConfirmpsdViewController
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationItem setHidesBackButton:YES];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.titleView.text = @"确认提现密码";
    self.view.backgroundColor = RGB(242, 242, 242);
    
    
    
    CGFloat height = [[UIApplication sharedApplication] statusBarFrame].size.height + self.navigationController.navigationBar.frame.size.height;
    
    
    popView = [[LMPopInputPasswordView alloc]init];
    popView.backgroundColor = RGB(242, 242, 242);
    popView.titleLabel.text = @"请确认新的提现密码：";
    popView.frame = CGRectMake((self.view.frame.size.width - 250)*0.5, autoScaleH(75)+height, 250, 150);
    popView.delegate = self;
    [self.view addSubview:popView];
    _iddd = UserId;
    _token = TOKEN;
    
}
#pragma mark ---LMPopInputPassViewDelegate
-(void)buttonClickedAtIndex:(NSUInteger)index withText:(NSString *)text
{
    
    
    if(index==1){
        if(text.length==0){
//            NSLog(@"密码长度不正确");
        }else if(text.length<6){
//            NSLog(@"密码长度不正确");
        }else{
            
            if ([text isEqualToString:_psdstr]) {
                
                [MBProgressHUD showMessage:@"请稍等"];
                NSString *uploadUrl = [NSString stringWithFormat:@"%@api/merchant/editAlipayPwd?token=%@&userId=%@&newPwd=%@",kBaseURL,_token,_iddd,[ZTMd5Security MD5ForLower32Bate:text]];
                      
                    [[QYXNetTool shareManager] postNetWithUrl:uploadUrl urlBody:nil bodyStyle:QYXBodyString header:nil response:QYXJSON success:^(id result) {
                    [MBProgressHUD showSuccess:@"修改成功"];
                    for (UIViewController *controller in self.navigationController.viewControllers) {
                        
                        if ([controller isKindOfClass:[NumberViewController class]]) {
                            NumberViewController *revise =(NumberViewController *)controller;
                            [self.navigationController popToViewController:revise animated:YES];
                        }
                    }
                    
                } failure:^(NSError *error) {
                    [MBProgressHUD hideHUD];
                }];
               
                
            }
            else
            {
                [MBProgressHUD showError:@"两次密码不一致"];
                [self.navigationController popViewControllerAnimated:YES];
            }
            
        }
    }
    
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
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
