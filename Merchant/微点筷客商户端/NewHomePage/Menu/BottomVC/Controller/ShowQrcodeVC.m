//
//  ShowQrcodeVC.m
//  微点筷客商户端
//
//  Created by Skyer God on 16/12/19.
//  Copyright © 2016年 张森森. All rights reserved.
//

#import "ShowQrcodeVC.h"
#import <AudioToolbox/AudioToolbox.h>
@interface ShowQrcodeVC ()
@property (nonatomic, strong) UIImageView *imageV;
@end

@implementation ShowQrcodeVC
{
    ButtonStyle *saveBT;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.rightBarItem.hidden = YES;
    self.titleView.text = @"二维码";
    self.view.backgroundColor = [UIColor whiteColor];
    [self createQrcodeView];
    UIImage *img = [self creatNonInterpolatedUIImageFormCIImage:[self creatCIQRCodeImage] withSize:self.view.size.width * 0.65];
    _imageV.image = img;
}
- (void)createQrcodeView{

    UILabel *deskNumLabel = [[UILabel alloc] init];
    deskNumLabel.text = [NSString stringWithFormat:@"%@%@号桌", _model.boardType, _model.boardNum];
    deskNumLabel.font = [UIFont systemFontOfSize:20 weight:20];
    deskNumLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:deskNumLabel];


    _imageV = [[UIImageView alloc] init];
    _imageV.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_imageV];


    saveBT = [ButtonStyle buttonWithType:UIButtonTypeCustom];
    [saveBT setTitle:@"保存到本地" forState:UIControlStateNormal];
    [saveBT setImage:[UIImage imageNamed:@"保存本地"] forState:UIControlStateNormal];
    [saveBT setTitleColor:[[UIColor blackColor] colorWithAlphaComponent:0.7] forState:UIControlStateNormal];
    [saveBT addTarget:self action:@selector(saveBTClick:) forControlEvents:UIControlEventTouchUpInside];
    [saveBT.titleLabel setFont:[UIFont systemFontOfSize:16]];
    [self.view addSubview:saveBT];

    self.automaticallyAdjustsScrollViewInsets = NO;

    deskNumLabel.sd_layout
    .centerXEqualToView(self.view)
    .topSpaceToView(self.view, 64)
    .heightIs(70);
    [deskNumLabel setSingleLineAutoResizeWithMaxWidth:160];

    _imageV.sd_layout
    .centerXEqualToView(self.view)
    .topSpaceToView(deskNumLabel, 0)
    .widthRatioToView(self.view, 0.65)
    .heightEqualToWidth(0);

    CGRect rect = [saveBT.titleLabel.text boundingRectWithSize:CGSizeMake(10000, 200) options:NSStringDrawingUsesLineFragmentOrigin attributes:[NSDictionary dictionaryWithObject:[UIFont systemFontOfSize:saveBT.titleLabel.font.pointSize] forKey:NSFontAttributeName] context:nil];
    saveBT.sd_layout
    .centerXEqualToView(self.view)
    .topSpaceToView(_imageV, 50)
    .widthIs(rect.size.width * 1.4 + 50)
    .heightIs(30);

    saveBT.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 50);
    saveBT.imageEdgeInsets = UIEdgeInsetsMake(0, rect.size.width * 1.3, 0, 0);



}

- (void)saveBTClick:(ButtonStyle *)sender{

    saveBT.hidden = YES;
    UIGraphicsBeginImageContext(self.view.bounds.size); //currentView 当前的view

    [self.view.layer renderInContext:UIGraphicsGetCurrentContext()];


    UIImage *viewImage = UIGraphicsGetImageFromCurrentImageContext();

    UIGraphicsEndImageContext();

    UIImageWriteToSavedPhotosAlbum(viewImage, nil, nil, nil);  //保存到相册中

    if (viewImage) {
        [self playSound];
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"截图完成" message:@"请在相册中查看截图" preferredStyle:UIAlertControllerStyleAlert];

        UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        }];
        [alertController addAction:cancel];
        [self presentViewController:alertController animated:YES completion:nil];
    }
    saveBT.hidden = NO;
}
- (void)playSound{
    NSString *path = [NSString stringWithFormat:@"/System/Library/Audio/UISounds/photoShutter.caf"];
    SystemSoundID soundId ;

    OSStatus error = AudioServicesCreateSystemSoundID((__bridge CFURLRef _Nonnull)([NSURL fileURLWithPath:path]), &soundId);
    if (error != kAudioServicesNoError) {
        //            NSLog(@"%d",(int)error);
    }

    AudioServicesPlaySystemSoundWithCompletion(soundId, ^{


    });
}
/**
 *  生成二维码
 */
- (CIImage *)creatCIQRCodeImage
{
    // 1.创建过滤器，这里的@"CIQRCodeGenerator"是固定的
    CIFilter *filter = [CIFilter filterWithName:@"CIQRCodeGenerator"];

    // 2.恢复默认设置
    [filter setDefaults];

    // 3. 给过滤器添加数据
    NSString *dataString = _model.boardId;
    NSData *data = [dataString dataUsingEncoding:NSUTF8StringEncoding];
    // 注意，这里的value必须是NSData类型
    [filter setValue:data forKeyPath:@"inputMessage"];

    // 4. 生成二维码
    CIImage *outputImage = [filter outputImage];

    // 5. 显示二维码
    _imageV.image = [UIImage imageWithCIImage:outputImage];

    return outputImage;
}
/**
 *  根据CIImage生成指定大小的UIImage
 *
 *  @param image CIImage
 *  @param size  图片宽度
 *
 *  @return 生成高清的UIImage
 */
- (UIImage *)creatNonInterpolatedUIImageFormCIImage:(CIImage *)image withSize:(CGFloat)size
{
    CGRect extent = CGRectIntegral(image.extent);
    CGFloat scale = MIN(size/CGRectGetWidth(extent), size/CGRectGetHeight(extent));

    // 1. 创建bitmap
    size_t width = CGRectGetWidth(extent) * scale;
    size_t height = CGRectGetHeight(extent) * scale;
    CGColorSpaceRef cs = CGColorSpaceCreateDeviceGray();
    CGContextRef bitmapRef = CGBitmapContextCreate(nil, width, height, 8, 0, cs, (CGBitmapInfo)kCGImageAlphaNone);
    CIContext *context = [CIContext contextWithOptions:nil];
    CGImageRef bitmapImage = [context createCGImage:image fromRect:extent];
    CGContextSetInterpolationQuality(bitmapRef, kCGInterpolationNone);
    CGContextScaleCTM(bitmapRef, scale, scale);
    CGContextDrawImage(bitmapRef, extent, bitmapImage);

    // 2.保存bitmap图片
    CGImageRef scaledImage = CGBitmapContextCreateImage(bitmapRef);
    CGContextRelease(bitmapRef);
    CGImageRelease(bitmapImage);
    return [UIImage imageWithCGImage:scaledImage];
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
