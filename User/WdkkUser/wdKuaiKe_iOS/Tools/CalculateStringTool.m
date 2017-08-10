//
//  CalculateStringTool.m
//  wdKuaiKe_iOS
//
//  Created by Skyer God on 16/8/8.
//  Copyright © 2016年 weiDianKuaiKe. All rights reserved.
//

#import "CalculateStringTool.h"

@implementation CalculateStringTool
+(CalculateStringTool *)shareManager{
    static CalculateStringTool *calculateTool = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        
        calculateTool = [[self alloc] init];
        
    });
    return calculateTool;
}

-(CGFloat)getStringWidthWithString:(NSString *)str fontSize:(UIFont*)font{
    
    CGRect rect = [str boundingRectWithSize:CGSizeMake(10000, 200) options:NSStringDrawingUsesLineFragmentOrigin attributes:[NSDictionary dictionaryWithObject:[UIFont systemFontOfSize:font.pointSize] forKey:NSFontAttributeName] context:nil];
    
    return rect.size.width;
}
-(CGFloat)getStringHeightWithString:(NSString *)str fontSize:(UIFont *)font{
    CGRect rect = [str boundingRectWithSize:CGSizeMake(200, 10000) options:NSStringDrawingUsesLineFragmentOrigin attributes:[NSDictionary dictionaryWithObject:[UIFont systemFontOfSize:font.pointSize] forKey:NSFontAttributeName] context:nil];
    
    return rect.size.height;
}


@end
