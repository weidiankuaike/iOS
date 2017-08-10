//
//  ScanViewController.m
//  wdKuaiKe_iOS
//
//  Created by Skyer God on 16/8/26.
//  Copyright © 2016年 weiDianKuaiKe. All rights reserved.
//

#import "ScanViewController.h"
#import "LXDScanView.h"
#import "LXDScanCodeController.h"
#import <AVFoundation/AVFoundation.h>
@interface ScanViewController ()<LXDScanViewDelegate, LXDScanCodeControllerDelegate>
@property (nonatomic, strong) LXDScanView * scanView;
@end

@implementation ScanViewController
- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear: animated];
    [self.scanView stop];
    
    [self.scanView removeFromSuperview];
    LXDScanCodeController * scanCodeController = [LXDScanCodeController scanCodeController];
    scanCodeController.scanDelegate = self;
    [self.navigationController pushViewController: scanCodeController animated: NO];
    self.navigationController.navigationBar.hidden = YES;
}
- (void)viewWillAppear:(BOOL)animated{
    self.navigationController.navigationBar.hidden = NO;
    [super viewWillAppear:NO];
}

- (void)dealloc
{
    [self.scanView stop];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.view addSubview: self.scanView];
    [self.scanView start];
}
#pragma mark - getter
/**
 *  懒加载扫描view
 */
- (LXDScanView *)scanView
{
    if (!_scanView) {
        _scanView = [LXDScanView scanViewShowInController: self];
    }
    return _scanView;
}


#pragma mark - LXDScanViewDelegate
/**
 *  返回扫描结果
 */
- (void)scanView:(LXDScanView *)scanView codeInfo:(NSString *)codeInfo
{
    NSURL * url = [NSURL URLWithString: codeInfo];
    if ([[UIApplication sharedApplication] canOpenURL: url]) {
        [[UIApplication sharedApplication] openURL: url];
    } else {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"警告" message:[NSString stringWithFormat: @"%@:%@", @"无法解析的二维码", codeInfo] preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancelAlert = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                [self.view addSubview: self.scanView];
                [self.scanView start];
            
        }];
        [alert addAction:cancelAlert];
        [self presentViewController:alert animated:YES completion:nil];
    }
}


#pragma mark - LXDScanCodeControllerDelegate
- (void)scanCodeController:(LXDScanCodeController *)scanCodeController codeInfo:(NSString *)codeInfo
{
    NSURL * url = [NSURL URLWithString: codeInfo];
    if ([[UIApplication sharedApplication] canOpenURL: url]) {
        [[UIApplication sharedApplication] openURL: url];
    } else {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"警告" message:[NSString stringWithFormat: @"%@:%@", @"无法解析的二维码", codeInfo] preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancelAlert = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:nil];
        [alert addAction:cancelAlert];
        [self presentViewController:alert animated:YES completion:nil];
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
