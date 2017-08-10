//
//  CameraManageTools.m
//  merchantClient
//
//  Created by Skyer God on 2017/7/26.
//  Copyright © 2017年 张甜. All rights reserved.
//

#import "CameraManageTools.h"

@implementation CameraManageTools
+ (void)openCamera:(UIViewController<UIImagePickerControllerDelegate,UINavigationControllerDelegate> *)delegate{
    //资源类型为照相机
    UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
    //判断是否有相机
    if ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera]){
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        //设置拍照后的图片可被编辑
        picker.allowsEditing = YES;
        //资源类型为照相机
        picker.sourceType = sourceType;
        picker.delegate = delegate;
        [delegate presentViewController:picker animated:YES completion:nil];

    }else {
        NSLog(@"该设备无摄像头");

    }
}
+ (void)openImagePickController:(UIViewController<UIImagePickerControllerDelegate,UINavigationControllerDelegate> *)delegate{
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    //资源类型为图片库
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    //设置选择后的图片可被编辑
    picker.allowsEditing = YES;
    picker.delegate = delegate;
    [delegate presentViewController:picker animated:YES completion:nil];
}
@end
