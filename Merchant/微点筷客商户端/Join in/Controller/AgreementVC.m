//
//  AgreementVC.m
//  微点筷客商户端
//
//  Created by Skyer God on 17/3/1.
//  Copyright © 2017年 张森森. All rights reserved.
//

#import "AgreementVC.h"

@interface AgreementVC ()<UIWebViewDelegate>
/** <#行注释#>   (strong) **/
@property (nonatomic, strong) UIWebView *agreementView;
@end

@implementation AgreementVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];


    self.titleView.text = _tempTitle;

    self.rightBarItem.hidden = YES;
    self.agreementView.backgroundColor = RGB(238, 238, 238);


    UIScrollView  *scrollView = _agreementView.scrollView;

    for (int i = 0; i < scrollView.subviews.count ; i++) {

            UIView *view = [scrollView.subviews objectAtIndex:i];

            if ([view isKindOfClass:[UIImageView class]]) {
                
                view.hidden  = YES ;
            }
        }

}
-(void)leftBarButtonItemAction{
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark -- 懒加载， 最后一个  餐厅活动
-(UIWebView *)agreementView{
    if (!_agreementView) {
        _agreementView = [[UIWebView alloc] init];
        _agreementView.backgroundColor = [UIColor cyanColor];
        [self.view addSubview:_agreementView];
//        NSString *path = [[NSBundle mainBundle] pathForResource:@"财务20160930" ofType:@"pdf"];
//        NSURL *url = [NSURL fileURLWithPath:path];
//        NSURLRequest *request = [NSURLRequest requestWithURL:url];
//        [_agreementView loadRequest:request];
        NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:_tempURL]];
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
#pragma mark -- UIWebView delegate ---
-(void)webViewDidStartLoad:(UIWebView *)webView{
    [SVProgressHUD showWithStatus:@"正在加载中..."];
}
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{

    return YES;
}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    [SVProgressHUD showSuccessWithStatus:@"加载失败"];
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"网络加载失败" message:@"请稍后再试" preferredStyle:UIAlertControllerStyleAlert];
    [self presentViewController:alertController animated:YES completion:^{

        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self dismissViewControllerAnimated:YES completion:^{

            }];
        });
    }];
}
-(void)webViewDidFinishLoad:(UIWebView *)webView{
    [SVProgressHUD dismiss];
    [webView stringByEvaluatingJavaScriptFromString:@"document.getElementsByTagName(‘body‘)[0].style.webkitTextSizeAdjust= ‘12%‘"];
    [webView stringByEvaluatingJavaScriptFromString:@"document.getElementsByTagName(‘body‘)[0].style.webkitTextFillColor= ‘green‘"];
    [webView stringByEvaluatingJavaScriptFromString:@"document.getElementsByTagName(‘body‘)[0].style.background=‘#F6F7F3‘"];
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
