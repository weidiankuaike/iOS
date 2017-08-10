//
//  ZTPageControl.m
//  自定义collectionView
//
//  Created by Skyer God on 16/11/3.
//  Copyright © 2016年 weiDianKuaiKe. All rights reserved.
//

#import "ZTPageControl.h"
@interface ZTPageControl(private)  // 声明一个私有方法, 该方法不允许对象直接使用
- (void)updateDots;
@end
@implementation ZTPageControl

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@synthesize imagePageStateNormal;
@synthesize imagePageStateHighlighted;

- (id)initWithFrame:(CGRect)frame { // 初始化
    self = [super initWithFrame:frame];

    [self setValue:[UIImage imageNamed:@"圆角矩形-1-拷贝"] forKeyPath:@"currentPageImage"];
    [self setValue:[UIImage imageNamed:@"圆角矩形-1"] forKeyPath:@"pageImage"];
//    imagePageStateNormal = [UIImage imageNamed:@"圆角矩形-1-拷贝"];
//    imagePageStateHighlighted = [UIImage imageNamed:@"圆角矩形-1"];
    return self;
}
//- (void)updateDots
//{
//    for (int i=0; i<[self.subviews count]; i++) {
//        
//        UIImageView* dot = [self.subviews objectAtIndex:i];
//        
//        CGSize size;
//        
//        size.height = 7;     //自定义圆点的大小
//        
//        size.width = 7;      //自定义圆点的大小
//        [dot setFrame:CGRectMake(dot.frame.origin.x, dot.frame.origin.y, size.width, size.width)];
//        if (i==self.currentPage)dot.image=imagePageStateHighlighted;
//        
//        else dot.image=imagePageStateNormal;
//    }
//    
//    
//    
//}
//- (void)setCurrentPage:(NSInteger)currentPage
//{
//    [super setCurrentPage:currentPage];
//    [self updateDots];
//}



@end
