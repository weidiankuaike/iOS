//
//  UIImageView+ImageCut_Compress.h
//  微点筷客商户端
//
//  Created by Skyer God on 16/11/20.
//  Copyright © 2016年 张森森. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImageView (ImageCut_Compress)
-(UIImage*) OriginImage:(UIImage *)image scaleToSize:(CGSize)size;
- (UIImage *)cutImage:(UIImage*)image withTargetSize:(CGSize )targetSize;
+ (UIImage *)handleImage:(UIImage *)originalImage withSize:(CGSize)size;
@end
