//
//  UIViewClassHandleTools.m
//  merchantClient
//
//  Created by Skyer God on 2017/7/26.
//  Copyright © 2017年 张甜. All rights reserved.
//

#import "UIViewClassHandleTools.h"

@implementation UIViewClassHandleTools
/**
 *  截取view中某个区域生成一张图片
 *
 *  @param view  view description
 *  @param scope 需要截取的view中的某个区域frame
 *
 *  @return image
 */
+ (UIImage *)shotWithView:(UIView *)view scope:(CGRect)scope{
    CGImageRef imageRef = CGImageCreateWithImageInRect([self shotWithView:view].CGImage, scope);
    UIGraphicsBeginImageContext(scope.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGRect rect = CGRectMake(0, 0, scope.size.width, scope.size.height);
    CGContextTranslateCTM(context, 0, rect.size.height);//下移
    CGContextScaleCTM(context, 1.0f, -1.0f);//上翻
    CGContextDrawImage(context, rect, imageRef);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    CGImageRelease(imageRef);
//    CGContextRelease(context);
    return image;
}

/**
 *  截取view生成一张图片
 *
 *  @param view view description
 *
 *  @return image
 */
+ (UIImage *)shotWithView:(UIView *)view{
    UIGraphicsBeginImageContext(view.bounds.size);
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}
/**
 *  获取图片的主色
 *
 *  @param image image
 *  @param scale 精准度0.1~1
 *
 *  @return 图片的主要颜色
 */
+ (UIColor *)mostColor:(UIImage *)image scale:(CGFloat)scale{


#if __IPHONE_OS_VERSION_MAX_ALLOWED > __IPHONE_6_1
    int bitmapInfo = kCGBitmapByteOrderDefault | kCGImageAlphaPremultipliedLast;
#else
    int bitmapInfo = kCGImageAlphaPremultipliedLast;
#endif
    if (scale <= 0.1) {
        scale = 0.1;
    }else if(scale >= 1){
        scale = 1;
    }

    //第一步 先把图片缩小 加快计算速度. 但越小结果误差可能越大
    CGSize thumbSize=CGSizeMake([image size].width * scale, [image size].height * scale);
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = CGBitmapContextCreate(NULL,
                                                 thumbSize.width,
                                                 thumbSize.height,
                                                 8,//bits per component
                                                 thumbSize.width*4,
                                                 colorSpace,
                                                 bitmapInfo);

    CGRect drawRect = CGRectMake(0, 0, thumbSize.width, thumbSize.height);
    CGContextDrawImage(context, drawRect, image.CGImage);
    CGColorSpaceRelease(colorSpace);



    //第二步 取每个点的像素值
    unsigned char* data = CGBitmapContextGetData (context);

    if (data == NULL){
        CGContextRelease(context);
        return nil;
    }

    NSCountedSet *cls=[NSCountedSet setWithCapacity:thumbSize.width*thumbSize.height];

    for (int x=0; x<thumbSize.height; x++) {
        for (int y=0; y<thumbSize.width; y++) {

            int offset = 4*(x*thumbSize.width + y);
            int red = data[offset];
            int green = data[offset+1];
            int blue = data[offset+2];
            int alpha =  data[offset+3];

            NSArray *clr=@[@(red),@(green),@(blue),@(alpha)];
            [cls addObject:clr];

        }
    }
    CGContextRelease(context);


    //第三步 找到出现次数最多的那个颜色
    NSEnumerator *enumerator = [cls objectEnumerator];
    NSArray *curColor = nil;

    NSArray *MaxColor=nil;
    NSUInteger MaxCount=0;

    while ( (curColor = [enumerator nextObject]) != nil )
    {
        NSUInteger tmpCount = [cls countForObject:curColor];

        if ( tmpCount < MaxCount ) continue;

        MaxCount=tmpCount;
        MaxColor=curColor;

    }
    //返回三原色色值
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithCapacity:0];
    [dic setValue:@([MaxColor[0] intValue]/255.0f) forKey:@"red"];
    [dic setValue:@([MaxColor[1] intValue]/255.0f) forKey:@"green"];
    [dic setValue:@([MaxColor[2] intValue]/255.0f) forKey:@"blue"];
    NSInteger tempNum = 0;

    tempNum = [MaxColor[0] intValue] + [MaxColor[1] intValue] + [MaxColor[2] intValue];
    if (tempNum > 382) {
        return [UIColor blackColor];
    } else {
        return [UIColor whiteColor];
    }
    return [UIColor colorWithRed:0.3 + [dic.allValues[0] doubleValue] green:0.3 + [dic.allValues[1] doubleValue] blue:0.3 + [dic.allValues[2] doubleValue] alpha:1];
}
/**
 *  获取图片上一个点的颜色
 *
 *  @param point 点击的点的位置
 *  @param image image
 *
 *  @return 返回点击点的颜色
 */
+ (UIColor *)colorAtPixel:(CGPoint)point UIImage:(UIImage *)image CGRect:(CGRect)rect{
    // Cancel if point is outside image coordinates
    if (!CGRectContainsPoint(CGRectMake(0.0f, 0.0f,rect.size.width, rect.size.height), point)) {
        return nil;
    }

    NSInteger pointX = trunc(point.x);
    NSInteger pointY = trunc(point.y);
    CGImageRef cgImage = image.CGImage;
    NSUInteger width = image.size.width;
    NSUInteger height = image.size.height;
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    int bytesPerPixel = 4;
    int bytesPerRow = bytesPerPixel * 1;
    NSUInteger bitsPerComponent = 8;
    unsigned char pixelData[4] = { 0, 0, 0, 0 };
    CGContextRef context = CGBitmapContextCreate(pixelData,
                                                 1,
                                                 1,
                                                 bitsPerComponent,
                                                 bytesPerRow,
                                                 colorSpace,
                                                 kCGImageAlphaPremultipliedLast | kCGBitmapByteOrder32Big);
    CGColorSpaceRelease(colorSpace);
    CGContextSetBlendMode(context, kCGBlendModeCopy);

    // Draw the pixel we are interested in onto the bitmap context
    CGContextTranslateCTM(context, -pointX, pointY-(CGFloat)height);
    CGContextDrawImage(context, CGRectMake(0.0f, 0.0f, (CGFloat)width, (CGFloat)height), cgImage);
    CGContextRelease(context);

    // Convert color values [0..255] to floats [0.0..1.0]
    CGFloat red   = (CGFloat)pixelData[0] / 255.0f;
    CGFloat green = (CGFloat)pixelData[1] / 255.0f;
    CGFloat blue  = (CGFloat)pixelData[2] / 255.0f;
    CGFloat alpha = (CGFloat)pixelData[3] / 255.0f;
    return [UIColor colorWithRed:red green:green blue:blue alpha:alpha];
}
// 裁剪图片
+ (UIImage *)imageFromImage:(UIImage *)image inRect:(CGRect)rect {
    CGImageRef sourceImageRef = [image CGImage];
    CGImageRef newImageRef = CGImageCreateWithImageInRect(sourceImageRef, rect);
    UIImage *newImage = [UIImage imageWithCGImage:newImageRef];
    CGImageRelease(newImageRef);
    return newImage;
}
/**
 *  缩放图片
 *
 *  @param img  image
 *  @param size 缩放后的大小
 *
 *  @return image
 */
+ (UIImage *)scaleToSize:(UIImage *)img size:(CGSize)size{
    // 创建一个bitmap的context
    CGFloat width = CGImageGetWidth(img.CGImage);
    CGFloat height = CGImageGetHeight(img.CGImage);

    CGFloat max = width >= height ? width:height;
    CGSize originSize;
    if (max <= 0) {
        return nil;
    }
    //    if (max < (size.width >= size.height ? size.width : size.height)) {
    //        originSize = CGSizeMake(width, height);
    //    }else{
    //    }
    if (width >= height) {
        originSize = CGSizeMake(size.width, (size.width * height)/width);
    }else{
        originSize = CGSizeMake((size.height * width)/height, size.height);
    }


    // 并把它设置成为当前正在使用的context
    UIGraphicsBeginImageContext(size);
    // 绘制改变大小的图片
    [img drawInRect:CGRectMake((size.width - originSize.width)/2, (size.height - originSize.height)/2, originSize.width, originSize.height)];
    // 从当前context中创建一个改变大小后的图片
    UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    // 使当前的context出堆栈
    UIGraphicsEndImageContext();
    // 返回新的改变大小后的图片
    return scaledImage;
}
@end
