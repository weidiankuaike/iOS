//
//  SceneScanVC.m
//  微点筷客商户端
//
//  Created by Skyer God on 17/1/16.
//  Copyright © 2017年 张森森. All rights reserved.
//

#import "SceneScanVC.h"
#import "LXDScanView.h"
#import "LXDScanCodeController.h"
#import <AVFoundation/AVFoundation.h>
#import "ZT_doublePickerView.h"
#import "ShowQrcodeVC.h"

@interface SceneScanVC ()<LXDScanViewDelegate, LXDScanCodeControllerDelegate>
@property (nonatomic, strong) LXDScanView * scanView;
@end

@implementation SceneScanVC
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
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview: self.scanView];
    [self.scanView start];
    ButtonStyle * btn = [ButtonStyle buttonWithType:UIButtonTypeCustom];
    btn.backgroundColor = [UIColor greenColor];
    [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [btn setTitle:@"打开手电筒"forState:UIControlStateNormal];
    [btn setTitle:@"关闭手电筒"forState:UIControlStateSelected];
    btn.showsTouchWhenHighlighted = YES;
    [self.view addSubview:btn];

    btn.sd_layout
    .centerXEqualToView(self.view)
    .bottomSpaceToView(self.view, 45);
    [btn setupAutoSizeWithHorizontalPadding:3 buttonHeight:autoScaleH(35)];
}
-(void)btnClick:(ButtonStyle *)btn
{
    btn.selected = !btn.selected;
    [self turnTorchOn:btn.selected];
}

-(void)turnTorchOn: (bool) on
{
    Class captureDeviceClass = NSClassFromString(@"AVCaptureDevice");
    if (captureDeviceClass !=nil) {
        AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
        if ([device hasTorch] && [device hasFlash]){
            [device lockForConfiguration:nil];
            if (on) {
                [device setTorchMode:AVCaptureTorchModeOn];
                [device setFlashMode:AVCaptureFlashModeOn];
            } else {
                [device setTorchMode:AVCaptureTorchModeOff];
                [device setFlashMode:AVCaptureFlashModeOff];
            }
            [device unlockForConfiguration];
        }else{
            NSLog(@"初始化失败");
        }
    }else{
        NSLog(@"没有闪光设备");
    }
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
    if (![codeInfo containsString:@"://link.wdkk.mobi?id="]) {
        //未查到ID
        //提示无效ID
        //                ZTLog(@"--");
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"无效二维码" message:@"请核查后重新扫描" preferredStyle:UIAlertControllerStyleAlert];

        UIAlertAction *cancelAlert = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            [self.view addSubview:self.scanView];
            [self.scanView start];
        }];
        [alertController addAction:cancelAlert];
        [self presentViewController:alertController animated:YES completion:nil];
    } else {
        //根据桌号id查找桌号
        NSString *keyUrl = @"api/merchant/findBoardByIdAndStoreId";
        NSString *loadUrl = [NSString stringWithFormat:@"%@%@?token=%@&storeId=%@&boardId=%@", kBaseURL, keyUrl, TOKEN, storeID, codeInfo];
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
          
        [[QYXNetTool shareManager] postNetWithUrl:loadUrl urlBody:nil bodyStyle:QYXBodyString header:nil response:QYXJSON success:^(id result) {
            if ([result[@"msgType"] integerValue] == 0) {
                //查询到id
                if ([result[@"obj"][@"isBind"] integerValue] == 0) {
                    //如果为空，就是未绑定桌号
                    //进行绑定操作
                    if (self.returnScanResult) {
                        [SVProgressHUD showErrorWithStatus:@"该二维码未绑定餐桌"];
                        [self.navigationController popViewControllerAnimated:YES];
                        //                        ZTLog(@"__+++");
                    }
                } else {
                    //不为空，该id已经绑定桌号，弹窗提示
                    //                    ZTLog(@"++");
                    if (_returnScanResult) {

                        NSString *deskNum = result[@"obj"][@"boardNum"];
                        NSString *deskCategory = result[@"obj"][@"boardType"];

                        _returnScanResult(deskCategory, deskNum, codeInfo);
                        [self.navigationController popViewControllerAnimated:YES];
                    }
                }
            } else {
                [SVProgressHUD showErrorWithStatus:@"查询失败"];
            }
            [MBProgressHUD hideHUDForView:self.view animated:YES];
        } failure:^(NSError *error) {
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"警告" message:[NSString stringWithFormat: @"%@:%@", @"无法解析的二维码", codeInfo] preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *cancelAlert = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                [self.view addSubview:self.scanView];
                [self.scanView start];
            }];
            [alert addAction:cancelAlert];
            [self presentViewController:alert animated:YES completion:nil];
        }];
    }
}
- (void)loadLookupQrcodeInfoFromService{



}

#pragma mark - LXDScanCodeControllerDelegate
- (void)scanCodeController:(LXDScanCodeController *)scanCodeController codeInfo:(NSString *)codeInfo
{
    NSURL * url = [NSURL URLWithString: codeInfo];
    if ([[UIApplication sharedApplication] canOpenURL: url]) {
        [[UIApplication sharedApplication] openURL:url options:@{} completionHandler:nil];
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
