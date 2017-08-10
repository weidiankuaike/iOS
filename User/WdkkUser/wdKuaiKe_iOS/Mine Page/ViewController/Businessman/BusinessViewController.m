//
//  BusinessViewController.m
//  wdKuaiKe_iOS
//
//  Created by 张森森 on 17/1/13.
//  Copyright © 2017年 weiDianKuaiKe. All rights reserved.
//

#import "BusinessViewController.h"
#import "UIBarButtonItem+SSExtension.h"
#import "MBProgressHUD+SS.h"
@interface BusinessViewController ()<UIWebViewDelegate>

@end

@implementation BusinessViewController
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
    titlabel.text = @"商家入驻";
    titlabel.textColor = [UIColor whiteColor];
    self.navigationItem.titleView = titlabel;
    UIBarButtonItem * backbtn = [UIBarButtonItem itemWithTarget:self Action:@selector(Back) image:@"left-1" selectImage:nil];
    self.navigationItem.leftBarButtonItem = backbtn;
    
    UIWebView * servewebview = [[UIWebView alloc]initWithFrame:self.view.bounds];
    NSString * urlstr = @"http://www.wdkk.mobi/h5/MerchantsEnter";
    servewebview.delegate =self;
    NSURL * url = [NSURL URLWithString:urlstr];
    NSURLRequest * request = [NSURLRequest requestWithURL:url];
    [servewebview loadRequest:request];
    [self.view addSubview:servewebview];
    
    
}
- (void)webViewDidStartLoad:(UIWebView *)webView{
    [MBProgressHUD showMessage:@"请稍等"];
}
- (void)webViewDidFinishLoad:(UIWebView *)webView{
    [MBProgressHUD hideHUD];
}
- (void)Back
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
