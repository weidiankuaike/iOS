//
//  MJChiBaoziHeader.m
//  微点筷客商户端
//
//  Created by Skyer God on 16/12/27.
//  Copyright © 2016年 张森森. All rights reserved.
//

#import "MJChiBaoziHeader.h"

@implementation MJChiBaoziHeader

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
#pragma mark - 重写方法
#pragma mark 基本设置
- (void)prepare
{
    [super prepare];

    // 设置普通状态的动画图片
    NSMutableArray *idleImages = [NSMutableArray array];
    for (NSUInteger i = 1; i<=60; i++) {
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"dropdown_anim__000%zd", i]];
        [idleImages addObject:image];
    }
    [self setImages:idleImages forState:MJRefreshStateIdle];

    // 设置即将刷新状态的动画图片（一松开就会刷新的状态）
    NSMutableArray *refreshingImages = [NSMutableArray array];
    for (NSUInteger i = 1; i<=3; i++) {
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"dropdown_loading_0%zd", i]];
        [refreshingImages addObject:image];
    }
    [self setImages:refreshingImages forState:MJRefreshStatePulling];

    // 设置正在刷新状态的动画图片
    [self setImages:refreshingImages forState:MJRefreshStateRefreshing];
}
@end
