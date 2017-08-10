//
//  NewpsdViewController.m
//  微点筷客商户端
//
//  Created by 张森森 on 16/10/26.
//  Copyright © 2016年 张森森. All rights reserved.
//

#import "NewpsdViewController.h"
#import "LMPopInputPasswordView.h"
#import "UIBarButtonItem+SSExtension.h"
#import "MBProgressHUD+SS.h"
#import "ConfirmpsdViewController.h"
#import "NumberViewController.h"
@interface NewpsdViewController ()<LMPopInputPassViewDelegate>
{
    LMPopInputPasswordView *popView;
    NSString * daititext;
}
@end

@implementation NewpsdViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.titleView.text = @"新提现密码";
    self.view.backgroundColor = RGB(242, 242, 242);
    
    

    CGFloat height = [[UIApplication sharedApplication] statusBarFrame].size.height + self.navigationController.navigationBar.frame.size.height;
    
    
    popView = [[LMPopInputPasswordView alloc]init];
    popView.backgroundColor = RGB(242, 242, 242);
    popView.titleLabel.text = @"请输入新的提现密码：";
    popView.frame = CGRectMake((self.view.frame.size.width - 250)*0.5, autoScaleH(75)+height, 250, 150);
    popView.delegate = self;
    [self.view addSubview:popView];
    
    
    
    
}
-(void)leftBarButtonItemAction{
    [self Back];
}
#pragma mark ---LMPopInputPassViewDelegate
-(void)buttonClickedAtIndex:(NSUInteger)index withText:(NSString *)text
{
   
    
        if(index==1){
            if(text.length==0){
//                NSLog(@"密码长度不正确");
            }else if(text.length<6){
//                NSLog(@"密码长度不正确");
            }else{
                
                ConfirmpsdViewController * confirview =[[ConfirmpsdViewController alloc]init];
                
                
                confirview.psdstr = text;
                [self.navigationController pushViewController:confirview animated:YES];
                
            }
        }
        

    
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
