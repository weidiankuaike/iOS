//
//  QRViewController.m
//  QRWeiXinDemo
//
//  Created by lovelydd on 15/4/25.
//  Copyright (c) 2015年 lovelydd. All rights reserved.
//

#import "QRViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "QRView.h"
#import <objc/runtime.h>
#import "DineserveViewController.h"
#import "MBProgressHUD+SS.h"
#import "QYXNetTool.h"
#import "MyMaterialViewController.h"
#import "ZTAddOrSubAlertView.h"
#import "HomePageVC.h"
#import "UIBarButtonItem+SSExtension.h"
#import "AppDelegate.h"
#import "MyorderViewController.h"
#import "LoginViewController.h"
#define qrRectViewWH [UIScreen mainScreen].bounds.size.width * 0.8

@interface QRViewController ()<AVCaptureMetadataOutputObjectsDelegate,QRViewDelegate>
{
    NSString * orderidstr;
}
@property (strong, nonatomic) AVCaptureDevice * device;
@property (strong, nonatomic) AVCaptureDeviceInput * input;
@property (strong, nonatomic) AVCaptureMetadataOutput * output;
@property (strong, nonatomic) AVCaptureSession * session;
@property (strong, nonatomic) AVCaptureVideoPreviewLayer * preview;
@property (nonatomic, strong) UIWebView *webView;
@property (nonatomic, strong) UILabel *label;
@property (nonatomic,weak) QRView *rview;
@property (nonatomic,assign) BOOL isOpenOrClose;

@end

@implementation QRViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.isOpenOrClose = NO;
    
//    [self creatLeftButton:@selector(pop:) image:@"icon-arrow-back" title:@"返回"];
//    
//    self.customTitleLabel.text =
    self.title = @"扫一扫";

    UIBarButtonItem * backbtn = [UIBarButtonItem itemWithTarget:self Action:@selector(Back) image:@"left-1" selectImage:nil];
    self.navigationItem.leftBarButtonItem = backbtn;
    
    _device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    
    
    // Input
    _input = [AVCaptureDeviceInput deviceInputWithDevice:self.device error:nil];
    
    // Output
    _output = [[AVCaptureMetadataOutput alloc]init];
    [_output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
    
    // Session
    _session = [[AVCaptureSession alloc]init];
    [_session setSessionPreset:AVCaptureSessionPresetHigh];
    if ([_session canAddInput:self.input])
    {
        [_session addInput:self.input];
        
   
    }
    
    if ([_session canAddOutput:self.output])
    {
        [_session addOutput:self.output];
    }
    
    
    
    // 条码类型 AVMetadataObjectTypeQRCode
    _output.metadataObjectTypes =@[AVMetadataObjectTypeQRCode,AVMetadataObjectTypeEAN13Code,
                                   AVMetadataObjectTypeEAN8Code,
                                   AVMetadataObjectTypeCode128Code];
    
    _preview =[AVCaptureVideoPreviewLayer layerWithSession:_session];
    _preview.videoGravity =AVLayerVideoGravityResize;
    _preview.frame =self.view.layer.bounds;
    [self.view.layer insertSublayer:_preview atIndex:0];
    
    //添加闪光灯button
    
    
    
    [_session startRunning];
    
    
    CGRect screenRect = [UIScreen mainScreen].bounds;
    QRView *qrRectView = [[QRView alloc] initWithFrame:screenRect];
    _rview = qrRectView;
    qrRectView.transparentArea = CGSizeMake(qrRectViewWH, qrRectViewWH);
    qrRectView.backgroundColor = [UIColor clearColor];
    qrRectView.center = CGPointMake(self.view.frame.size.width / 2, self.view.frame.size.height / 2);
    qrRectView.delegate = self;
    [self.view addSubview:qrRectView];
    
    //修正扫描区域
    CGFloat screenHeight = self.view.frame.size.height;
    CGFloat screenWidth = self.view.frame.size.width;
    CGRect cropRect = CGRectMake((screenWidth - qrRectView.transparentArea.width) / 2,
                                 (screenHeight - qrRectView.transparentArea.height) / 2,
                                 qrRectView.transparentArea.width,
                                 qrRectView.transparentArea.height);

    [_output setRectOfInterest:CGRectMake(cropRect.origin.y / screenHeight,
                                          cropRect.origin.x / screenWidth,
                                          cropRect.size.height / screenHeight,
                                          cropRect.size.width / screenWidth)];
    
    self.label = [[UILabel alloc]initWithFrame:CGRectMake(0 , (self.view.bounds.size.height - qrRectViewWH)/2.f - autoScaleH(60), self.view.bounds.size.width, autoScaleH(60))];
    _label.textAlignment = NSTextAlignmentCenter;
    _label.numberOfLines = 0;
    [_label setText:@"将取景框对准二维码或者条形码\n即可自动扫描"];
    [_label setTintColor:[UIColor yellowColor]];
    [self.view addSubview:_label];
    
    
    [self addTorchButton];
}


#pragma mark AVCaptureMetadataOutputObjectsDelegate
- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection
{
    
    NSString *stringValue;
    
    if ([metadataObjects count] > 0){
        //停止扫描
        [_session stopRunning];
        AVMetadataMachineReadableCodeObject * metadataObject = [metadataObjects objectAtIndex:0];
        stringValue = metadataObject.stringValue;
        _stringValue = stringValue;
        
        
        NSData *data = [_stringValue dataUsingEncoding:NSUTF8StringEncoding];
        NSLog(@"%@",data.description);
        
        NSURL * url = [NSURL URLWithString:stringValue];
//        if ([[UIApplication sharedApplication] canOpenURL: url]) {
//            [[UIApplication sharedApplication] openURL: url];
//        } else {
        if (![stringValue isEqualToString:@""]) {
            NSArray * idary = [stringValue componentsSeparatedByString:@"?"];
            NSString * idstr = idary.lastObject;
            NSArray * idarray = [idstr componentsSeparatedByString:@"="];
            NSString * idstring = idarray.lastObject;
           
//            dispatch_async(dispatch_get_main_queue(), ^{
            
                [MBProgressHUD showMessage:@"请稍等"];
                NSString * urlstr = [NSString stringWithFormat:@"%@/api/user/scanCodeManage",commonUrl];
                NSString * urlbody = [NSString stringWithFormat:@"token=%@&userId=%@&operation=%@&boardId=%@&orderId=%@",Token,Userid,_operation,stringValue,_orderid];
//                NSArray * urlary = [urlstr componentsSeparatedByString:@"?"];
                dispatch_async(dispatch_get_main_queue(), ^{
                [[QYXNetTool shareManager]postNetWithUrl:urlstr urlBody:urlbody bodyStyle:QYXBodyString header:nil response:QYXJSON success:^(id result) {
                    [MBProgressHUD hideHUD];
//                    [self pop:nil];
                    
                    NSString * msgtypestr = [NSString stringWithFormat:@"%@",result[@"msgType"]];
                    if ([msgtypestr isEqualToString:@"2000"]) {
                        LoginViewController * loginView = [[LoginViewController alloc]init];
                        [self.navigationController pushViewController:loginView animated:YES];
                        
                    }
                    else{
                        id obj = result[@"obj"];
                        if (![obj isNull]&& ![obj isKindOfClass:[NSString class]]) {
                            
                            NSDictionary * obkdict = result[@"obj"];
                            _storeId = [NSString stringWithFormat:@"%@",obkdict[@"storeId"]];
                            orderidstr = [NSString stringWithFormat:@"%@",obkdict[@"orderId"]];
                            
                        }
                        if (_pushint ==2) {
                            
                            if ([msgtypestr isEqualToString:@"6"]) {
                                
                                
                                DineserveViewController * dineserveview = [[DineserveViewController alloc]init];
                                dineserveview.orderid = _orderid;
                                dineserveview.operint = [NSString stringWithFormat:@"%ld",_pushint];
                                dineserveview.boradid = stringValue;
                                dineserveview.storeid = _storeId;
                                [self.navigationController pushViewController:dineserveview animated:YES];
                            }else if ([msgtypestr isEqualToString:@"0"]){
                                ZTAddOrSubAlertView * ztview = [[ZTAddOrSubAlertView alloc]initWithStyle:ZTalertSheetStyleTitle];
                                ztview.titleLabel.text = @"今天未在本店预定，是否马上用餐";
                                ztview.complete = ^(BOOL choose)
                                {
                                    if (choose==YES) {
                                        [ztview removeFromSuperview];
                                        [self creatOrderwithboardid:stringValue];
                                        
                                    }else{
                                        
                                        [self.navigationController popViewControllerAnimated:YES];
                                    }
                                    
                                };
                                
                            }else if ([msgtypestr isEqualToString:@"2"]){
                                [MBProgressHUD showError:@"您当前正在用餐"];
                                [self pop:nil];
                            }else if ([msgtypestr isEqualToString:@"3"]){
                                [MBProgressHUD showError:@"未知操作"];
                                [self pop:nil];
                            }else if ([msgtypestr isEqualToString:@"4"]){
                                [MBProgressHUD showError:@"请到对应店铺扫码"];
                                [self pop:nil];
                            }else if ([msgtypestr isEqualToString:@"7"]){
                                [MBProgressHUD showError:@"未知操作"];
                                [self pop:nil];
                            }else if ([msgtypestr isEqualToString:@"5"]){
                                [MBProgressHUD showError:@"网络参数错误"];
                                [self pop:nil];
                            }else if ([msgtypestr isEqualToString:@"1"]){
                                [MBProgressHUD showError:@"请求失败"];
                                [self pop:nil];
                            }else if ([msgtypestr isEqualToString:@"8"]){
                                [MBProgressHUD showError:@"请绑定手机"];
                                MyMaterialViewController * materialview = [[MyMaterialViewController alloc]init];
                                [self.navigationController pushViewController:materialview animated:YES];
                            }else if ([msgtypestr isEqualToString:@"12"]){
                                
                                ZTAddOrSubAlertView * ztview = [[ZTAddOrSubAlertView alloc]initWithStyle:ZTalertSheetStyleTitle];
                                ztview.titleLabel.text = @"该餐桌在使用中，是否继续";
                                ztview.complete = ^(BOOL choose)
                                {
                                    if (choose==YES) {
                                        [self creatOrderWithordeid:_orderid bodarid:stringValue];
                                          
                                        
                                    }else{
                                        
                                        [self Back];
                                    }
                                    
                                };
                                
                            }
                            
                        }else{
                            if ([msgtypestr isEqualToString:@"6"]||[msgtypestr isEqualToString:@"9"]) {
                                
                                
                                DineserveViewController * dineserveview = [[DineserveViewController alloc]init];
                                dineserveview.orderid = orderidstr;
                                dineserveview.operint = [NSString stringWithFormat:@"%ld",_pushint];
                                dineserveview.boradid = stringValue;
                                dineserveview.storeid = _storeId;
                                [self.navigationController pushViewController:dineserveview animated:YES];
                                
                            }else if ([msgtypestr isEqualToString:@"0"]){
                                ZTAddOrSubAlertView * ztview = [[ZTAddOrSubAlertView alloc]initWithStyle:ZTalertSheetStyleTitle];
                                ztview.titleLabel.text = @"今天未在本店预定，是否马上用餐";
                                ztview.complete = ^(BOOL choose)
                                {
                                    if (choose==YES) {
                                        [ztview removeFromSuperview];
                                        [self creatOrderwithboardid:stringValue];
                                        
                                    }else{
                                        
                                        [self Back];
                                    }
                                    
                                };
                                
                            }else if ([msgtypestr isEqualToString:@"2"]){
                                
                                
                                [MBProgressHUD showError:@"您在本店有多笔订单，请选这一笔"];
                                MyorderViewController * myorderview = [[MyorderViewController alloc]init];
                                self.tabBarController.selectedIndex = 1;
                                [self.navigationController pushViewController:myorderview animated:YES];
                                
                                
                            }
                            else if ([msgtypestr isEqualToString:@"5"]){
                                [MBProgressHUD showError:@"您当前正在用餐"];
                                DineserveViewController * dineserveview = [[DineserveViewController alloc]init];
                                dineserveview.orderid = orderidstr;
                                dineserveview.operint = [NSString stringWithFormat:@"%ld",_pushint];
                                dineserveview.boradid = stringValue;
                                dineserveview.storeid = _storeId;
                                [self.navigationController pushViewController:dineserveview animated:YES];
                                
                            }else if ([msgtypestr isEqualToString:@"3"]){
                                [MBProgressHUD showError:@"扫码异常，请稍后再试"];
                                [self pop:nil];
                            }else if ([msgtypestr isEqualToString:@"4"]){
                                [MBProgressHUD showError:@"无效订单"];
                                [self pop:nil];
                            }else if ([msgtypestr isEqualToString:@"7"]){
                                [MBProgressHUD showError:@"未知操作"];
                                [self pop:nil];
                            }else if ([msgtypestr isEqualToString:@"5"]){
                                [MBProgressHUD showError:@"网络参数错误"];
                                [self pop:nil];
                            }else if ([msgtypestr isEqualToString:@"1"]){
                                [MBProgressHUD showError:@"请求失败"];
                                [self pop: nil];
                            }else if ([msgtypestr isEqualToString:@"8"]){
                                [MBProgressHUD showError:@"请绑定手机"];
                                MyMaterialViewController * materialview = [[MyMaterialViewController alloc]init];
                                [self.navigationController pushViewController:materialview animated:YES];
                            }else if ([msgtypestr isEqualToString:@"10"]){
                                [MBProgressHUD showError:@"请到对应店铺扫码"];
                                [self pop:nil];
                            }else if ([msgtypestr isEqualToString:@"11"]){
                                
                                ZTAddOrSubAlertView * ztview = [[ZTAddOrSubAlertView alloc]initWithStyle:ZTalertSheetStyleTitle];
                                ztview.titleLabel.text = @"该餐桌在使用中，是否继续";
                                ztview.complete = ^(BOOL choose)
                                {
                                    if (choose==YES) {
                                        [ztview removeFromSuperview];
                                        [self creatOrderwithboardid:stringValue];
                                        
                                    }else{
                                        
                                        [self Back];
                                    }
                                    
                                };
                                
                            }else if ([msgtypestr isEqualToString:@"12"]){
                                
                                ZTAddOrSubAlertView * ztview = [[ZTAddOrSubAlertView alloc]initWithStyle:ZTalertSheetStyleTitle];
                                ztview.titleLabel.text = @"该餐桌在使用中，是否继续";
                                ztview.complete = ^(BOOL choose)
                                {
                                    if (choose==YES) {
                                        [self creatOrderWithordeid:orderidstr bodarid:stringValue];
                                        
                                    }else{
                                        
                                        [self Back];
                                    }
                                    
                                };
                                
                            }
                            
                            
                        }
                    }
                
                } failure:^(NSError *error) {
                    
                    [MBProgressHUD hideHUD];
                }];
                
               
            });
            
            
            
            } else {
            UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"提示" message:[NSString stringWithFormat: @"%@:%@", @"无法解析的二维码", stringValue] preferredStyle:UIAlertControllerStyleAlert];
            
            __weak UIAlertAction * cancel = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                
               
            }];
            
            
            [alert addAction:cancel];
            
            [self presentViewController:alert animated:YES completion:nil];
        }
    }
    
   

//    [self pop:nil];
//    
//    if (self.qrUrlBlock) {
//        self.qrUrlBlock(stringValue);
//    }
}
- (void)creatOrderwithboardid:(NSString*)boardid{
    
    [MBProgressHUD showMessage:@"请稍等"];
     NSString * urlstr = [NSString stringWithFormat:@"%@/api/user/createArrivalOrder",commonUrl];
    NSString * urlbody = [NSString stringWithFormat:@"token=%@&userId=%@&storeId=%@&boardId=%@",Token,Userid,_storeId,boardid];
    [[QYXNetTool shareManager]postNetWithUrl:urlstr urlBody:urlbody bodyStyle:QYXBodyString header:nil response:QYXJSON success:^(id result) {
        [MBProgressHUD hideHUD];
        NSLog(@"saomiao%@%@",result,result[@"msg"]);
        NSString * magtype = [NSString stringWithFormat:@"%@",result[@"msgType"]];
        if ([magtype isEqualToString:@"0"]) {
            NSDictionary * objdict = result[@"obj"];
            DineserveViewController * dineserveview = [[DineserveViewController alloc]init];
            dineserveview.orderid = objdict[@"orderId"];
           dineserveview.operint = [NSString stringWithFormat:@"%ld",_pushint];        dineserveview.boradid = boardid;
            dineserveview.storeid = _storeId;
            [self.navigationController pushViewController:dineserveview animated:YES];
        }
        
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUD];
    }];
    
    
}
- (void)creatOrderWithordeid:(NSString*)orderid bodarid:(NSString*)bodarid {
    
    NSString * urlstr = [NSString stringWithFormat:@"%@/api/user/insertStoreKitchenMsg",commonUrl];
    NSString * urlbody = [NSString stringWithFormat:@"token=%@&orderId=%@&boardId=%@",Token,orderid,bodarid];
    
    [MBProgressHUD showMessage:@"请稍等"];
    [[QYXNetTool shareManager]postNetWithUrl:urlstr urlBody:urlbody bodyStyle:QYXBodyString header:nil response:QYXJSON success:^(id result) {
        [MBProgressHUD hideHUD];
        NSLog(@",.,.%@",result);
        NSString * magtype = [NSString stringWithFormat:@"%@",result[@"msgType"]];
        if ([magtype isEqualToString:@"0"]) {
            NSString * objdict = result[@"obj"];
            DineserveViewController * dineserveview = [[DineserveViewController alloc]init];
            dineserveview.orderid = objdict;
            dineserveview.operint = [NSString stringWithFormat:@"%ld",_pushint];        dineserveview.boradid = bodarid;
            dineserveview.storeid = _storeId;
            [self.navigationController pushViewController:dineserveview animated:YES];
        }
        
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUD];
    }];
    
}
- (void)pop:(UIButton *)button
{
    if (_pushint==1) {
        
          [_session startRunning];
       
        
    }else{
        [self.navigationController popViewControllerAnimated:NO];
    }
    
    
}
- (void)Back
{
        [self.navigationController popViewControllerAnimated:NO];

    
}
-(void)viewWillAppear:(BOOL)animated
{

    [super viewWillAppear: animated];
    self.navigationController.navigationBar.hidden = NO;
    [self.navigationController.navigationBar setBarTintColor:UIColorFromRGB(0xfd7577)];
    self.tabBarController.tabBar.hidden = YES;
    [_rview addTimer];
    
   

}
-(void)viewWillDisappear:(BOOL)animated{

    [super viewWillDisappear: animated];
    self.tabBarController.tabBar.hidden = NO;

    [_rview pauseTiemr];
}
-(void)addTorchButton{

    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [button addTarget:self action:@selector(onOrOff:) forControlEvents:UIControlEventTouchUpInside];
    
    [button setTitle:@"开灯" forState:UIControlStateNormal];
    
    button.backgroundColor = [UIColor grayColor];
    
    [self.view addSubview:button];
    
    button.frame = CGRectMake([UIScreen mainScreen].bounds.size.width-10-50,[UIScreen mainScreen].bounds.size.height-50, 50, 30);


}
-(void)onOrOff:(UIButton *)button{

    if (!_isOpenOrClose) {
        
        [_device lockForConfiguration:nil];
        
        _device.torchMode = AVCaptureTorchModeOn;
        
        [_device unlockForConfiguration];
        
        [button setTitle:@"关闭" forState:UIControlStateNormal];
        
        _isOpenOrClose = YES;
    }else{
    
        [_device lockForConfiguration:nil];
        
        _device.torchMode = AVCaptureTorchModeOff;
        
        [_device unlockForConfiguration];
    
        [button setTitle:@"开灯" forState:UIControlStateNormal];
        
        _isOpenOrClose = NO;
    }


}
@end





