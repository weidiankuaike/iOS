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
    return self;
}





@end
