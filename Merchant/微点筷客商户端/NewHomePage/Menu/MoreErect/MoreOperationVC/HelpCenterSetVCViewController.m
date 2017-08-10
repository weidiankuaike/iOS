//
//  HelpCenterSetVCViewController.m
//  微点筷客商户端
//
//  Created by Skyer God on 17/1/13.
//  Copyright © 2017年 张森森. All rights reserved.
//

#import "HelpCenterSetVCViewController.h"

@interface HelpCenterSetVCViewController ()<UIWebViewDelegate>
/** <#行注释#>   (strong) **/
@property (nonatomic, strong) UIWebView *agreementView;
@end

@implementation HelpCenterSetVCViewController
-(UIWebView *)agreementView{
    if (!_agreementView) {
        _agreementView = [[UIWebView alloc] init];
        _agreementView.backgroundColor = [UIColor clearColor];
        _agreementView.opaque = NO;
        [self.view addSubview:_agreementView];
        //        NSString *path = [[NSBundle mainBundle] pathForResource:@"财务20160930" ofType:@"pdf"];
        //        NSURL *url = [NSURL fileURLWithPath:path];
        //        NSURLRequest *request = [NSURLRequest requestWithURL:url];
        //        [_agreementView loadRequest:request];
         [SVProgressHUD showWithStatus:@"正在加载中..."];
        NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:@"https://shop.wdkk.mobi/h5/help"]];
        [_agreementView loadRequest:request];
        _agreementView.delegate = self;
        _agreementView.scalesPageToFit = YES;
        _agreementView.scrollView.bounces = NO;
        _agreementView.scrollView.showsVerticalScrollIndicator = NO;
        _agreementView.suppressesIncrementalRendering = YES;

        self.agreementView.sd_layout
        .spaceToSuperView(UIEdgeInsetsMake(64, 0, 0, 0));
    }
    return _agreementView;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    self.titleView.text = @"帮助中心";
    self.rightBarItem.hidden = YES;
    self.agreementView.backgroundColor = RGB(238, 238, 238);
    UIScrollView  *scrollView = _agreementView.scrollView;

    for (int i = 0; i < scrollView.subviews.count ; i++) {

        UIView *view = [scrollView.subviews objectAtIndex:i];

        if ([view isKindOfClass:[UIImageView class]]) {

            view.hidden  = YES ;
        }
    }
//    https://shop.wdkk.mobi/h5/help
}
#pragma mark -- UIWebView delegate ---
-(void)webViewDidStartLoad:(UIWebView *)webView{

}
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{

    return YES;
}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    [SVProgressHUD showErrorWithStatus:@"加载失败"];
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"网络加载失败" message:@"请稍后再试" preferredStyle:UIAlertControllerStyleAlert];
    [self presentViewController:alertController animated:YES completion:^{

        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self dismissViewControllerAnimated:YES completion:^{

            }];
        });
    }];
}
-(void)webViewDidFinishLoad:(UIWebView *)webView{
    [SVProgressHUD showSuccessWithStatus:@"加载完毕"];
}

-(void)leftBarButtonItemAction{
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
