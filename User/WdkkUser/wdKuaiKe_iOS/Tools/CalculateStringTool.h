//
//  CalculateStringTool.h
//  wdKuaiKe_iOS
//
//  Created by Skyer God on 16/8/8.
//  Copyright © 2016年 weiDianKuaiKe. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <UIKit/UIKit.h>
@interface CalculateStringTool : NSObject
+(CalculateStringTool *)shareManager;

- (CGFloat)getStringWidthWithString:(NSString *)str fontSize:(UIFont *)font;
- (CGFloat)getStringHeightWithString:(NSString *)str fontSize:(UIFont *)font;


@end
