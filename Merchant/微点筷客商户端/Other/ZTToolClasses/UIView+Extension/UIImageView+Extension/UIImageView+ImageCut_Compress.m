//
//  UIImageView+ImageCut_Compress.m
//  微点筷客商户端
//
//  Created by Skyer God on 16/11/20.
//  Copyright © 2016年 张森森. All rights reserved.
//

#import "UIImageView+ImageCut_Compress.h"

@implementation UIImageView (ImageCut_Compress)
/**
 *  压缩图片
 *  image:将要压缩的图片   size：压缩后的尺寸
 */
-(UIImage*) OriginImage:(UIImage *)image scaleToSize:(CGSize)size
{
    // 下面方法，第一个参数表示区域大小。第二个参数表示是否是非透明的。如果需要显示半透明效果，需要传NO，否则传YES。第三个参数就是屏幕密度了
    UIGraphicsBeginImageContextWithOptions(size, NO, [UIScreen mainScreen].scale);

    [image drawInRect:CGRectMake(0, 0, size.width, size.height)];

    UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();

    UIGraphicsEndImageContext();

    return scaledImage;   //返回的就是已经改变的图片
}
//裁剪图片
- (UIImage *)cutImage:(UIImage*)image withTargetSize:(CGSize )targetSize
{
    //压缩图片
    CGSize newSize;
    CGImageRef imageRef = nil;

    if ((image.size.width / image.size.height) < (targetSize.width / targetSize.height)) {
        newSize.width = image.size.width;
        newSize.height = image.size.width * targetSize.height / targetSize.width;

        imageRef = CGImageCreateWithImageInRect([image CGImage], CGRectMake(0, fabs(image.size.height - newSize.height) / 2, newSize.width, newSize.height));

    } else {
        newSize.height = image.size.height;
        newSize.width = image.size.height * targetSize.width / targetSize.height;

        imageRef = CGImageCreateWithImageInRect([image CGImage], CGRectMake(fabs(image.size.width - newSize.width) / 2, 0, newSize.width, newSize.height));
    }
    return [UIImage imageWithCGImage:imageRef];
}

+ (UIImage *)handleImage:(UIImage *)originalImage withSize:(CGSize)size
{
    CGSize originalsize = [originalImage size];
//    NSLog(@"改变前图片的宽度为%f,图片的高度为%f",originalsize.width,originalsize.height);

    //原图长宽均小于标准长宽的，不作处理返回原图
    if (originalsize.width<size.width && originalsize.height<size.height)
    {
        return originalImage;
    }

    //原图长宽均大于标准长宽的，按比例缩小至最大适应值
    else if(originalsize.width>size.width && originalsize.height>size.height)
    {
        CGFloat rate = 1.0;
        CGFloat widthRate = originalsize.width/size.width;
        CGFloat heightRate = originalsize.height/size.height;

        rate = widthRate>heightRate?heightRate:widthRate;

        CGImageRef imageRef = nil;

        if (heightRate>widthRate)
        {
            imageRef = CGImageCreateWithImageInRect([originalImage CGImage], CGRectMake(0, originalsize.height/2-size.height*rate/2, originalsize.width, size.height*rate));//获取图片整体部分
        }
        else
        {
            imageRef = CGImageCreateWithImageInRect([originalImage CGImage], CGRectMake(originalsize.width/2-size.width*rate/2, 0, size.width*rate, originalsize.height));//获取图片整体部分
        }
        UIGraphicsBeginImageContext(size);//指定要绘画图片的大小
        CGContextRef con = UIGraphicsGetCurrentContext();

        CGContextTranslateCTM(con, 0.0, size.height);
        CGContextScaleCTM(con, 1.0, -1.0);

        CGContextDrawImage(con, CGRectMake(0, 0, size.width, size.height), imageRef);

        UIImage *standardImage = UIGraphicsGetImageFromCurrentImageContext();
//        NSLog(@"改变后图片的宽度为%f,图片的高度为%f",[standardImage size].width,[standardImage size].height);

        UIGraphicsEndImageContext();
        CGImageRelease(imageRef);

        return standardImage;
    }

    //原图长宽有一项大于标准长宽的，对大于标准的那一项进行裁剪，另一项保持不变
    else if(originalsize.height>size.height || originalsize.width>size.width)
    {
        CGImageRef imageRef = nil;

        if(originalsize.height>size.height)
        {
            imageRef = CGImageCreateWithImageInRect([originalImage CGImage], CGRectMake(0, originalsize.height/2-size.height/2, originalsize.width, size.height));//获取图片整体部分
        }
        else if (originalsize.width>size.width)
        {
            imageRef = CGImageCreateWithImageInRect([originalImage CGImage], CGRectMake(originalsize.width/2-size.width/2, 0, size.width, originalsize.height));//获取图片整体部分
        }

        UIGraphicsBeginImageContext(size);//指定要绘画图片的大小
        CGContextRef con = UIGraphicsGetCurrentContext();

        CGContextTranslateCTM(con, 0.0, size.height);
        CGContextScaleCTM(con, 1.0, -1.0);

        CGContextDrawImage(con, CGRectMake(0, 0, size.width, size.height), imageRef);

        UIImage *standardImage = UIGraphicsGetImageFromCurrentImageContext();
//        NSLog(@"改变后图片的宽度为%f,图片的高度为%f",[standardImage size].width,[standardImage size].height);

        UIGraphicsEndImageContext();
        CGImageRelease(imageRef);

        return standardImage;
    }

    //原图为标准长宽的，不做处理
    else
    {
        return originalImage;
    }
}

@end
