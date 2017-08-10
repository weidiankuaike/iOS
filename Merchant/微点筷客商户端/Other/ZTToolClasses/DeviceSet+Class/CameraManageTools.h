//
//  CameraManageTools.h
//  merchantClient
//
//  Created by Skyer God on 2017/7/26.
//  Copyright © 2017年 张甜. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface CameraManageTools : NSObject<UIImagePickerControllerDelegate>
/**
 *  打开照相机，（**这里面的对象需要自己模态弹出相册，相机的页面）
 *
 *   返回图片库对象
 */
+ (void)openCamera:(id<UIImagePickerControllerDelegate>)delegate;
/**
 *  打开图片库
 *
 *  返回图片库对象
 */
+ (void)openImagePickController:(id<UIImagePickerControllerDelegate>)delegate;
@end
