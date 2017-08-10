//
//  CarouselHeaderView.m
//  wdKuaiKe_iOS
//
//  Created by Skyer God on 16/8/5.
//  Copyright © 2016年 weiDianKuaiKe. All rights reserved.
//

#import "CarouselHeaderView.h"

@interface CarouselHeaderView ()<UIScrollViewDelegate>

@property (nonatomic, strong) UIScrollView *scrollV;
@property (nonatomic, strong) NSArray *arrImages;

@end
@implementation CarouselHeaderView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {

        _arrImages = @[@"first",@"second",@"turnPlay"];
        self.scrollV = [[UIScrollView alloc]initWithFrame:self.frame];
        //重要属性
        self.scrollV.contentSize = CGSizeMake(self.frame.size.width * _arrImages.count + 2, 0);
        //翻页效果
        self.scrollV.pagingEnabled = YES;
        //偏移 可读写 设置图片开始偏移值
        self.scrollV.contentOffset = CGPointMake(self.frame.size.width * 0, 0);
        //获取图片的位置
        //设置协议代理
        self.scrollV.delegate = self;
        
        for (NSInteger i = 0; i < _arrImages.count + 2; i++) {
            UIScrollView *scrollZoom = [[UIScrollView alloc]initWithFrame:CGRectMake(self.frame.size.width * i, 0, self.frame.size.width, self.frame.size.height)];
            //最大最小缩放比例
            scrollZoom.minimumZoomScale = 1;
            scrollZoom.maximumZoomScale = 5;
            scrollZoom.delegate = self;
            //当前缩放比例
            //       self.scrollV.zoomScale = 1;
            [self.scrollV addSubview:scrollZoom];
            
            UIImageView *imageV = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
            NSString *name = [_arrImages objectAtIndex:i];
            //循环滑动实现原理：额外添加两张图片，第一张图为最后一张，最后为第一张，起始显示为第二张
            if (0 == i) {
                name = [_arrImages lastObject];
            }
            if (_arrImages.count == i) {
                name = [_arrImages firstObject];
            }
            imageV.image = [UIImage imageNamed:name];
            [scrollZoom addSubview:imageV];
            
        }
        [self addSubview:self.scrollV];
        
    
        UIView *bottomView = [[UIView alloc] init];
        
        bottomView.backgroundColor = RGBA(0, 0, 0, 0.4);
        
        [self.scrollV addSubview:bottomView];
        
        bottomView.sd_layout.bottomEqualToView(_scrollV).heightIs(kHeight(32)).widthIs(self.frame.size.width);
        
        
        self.scrollV.showsHorizontalScrollIndicator = NO;
        self.scrollV.showsVerticalScrollIndicator = NO;
        



        
        
        
    }
    return self;
}

- (nullable UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView{
    return scrollView.subviews.firstObject;
    
}
//滑动图片的过程：拖拽将要开始－ 拖拽－拖拽即将结束－拖拽已经结束－ 减速即将开始－减速已经结束；
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    
    if (scrollView == self.scrollV) {
        
        NSInteger currentIndex = scrollView.contentOffset.x / scrollView.frame.size.width;
        if (0 == currentIndex) {
            currentIndex = _arrImages.count;
            scrollView.contentOffset = CGPointMake(scrollView.frame.size.width * currentIndex, 0);
            
        }else if (_arrImages.count == currentIndex) {
            
            currentIndex = 1;
            scrollView.contentOffset = CGPointMake(scrollView.frame.size.width * currentIndex, 0);
            
        }
        //    scrollView.contentOffset = CGPointMake(scrollView.frame.size.width * currentIndex, 0);
        

        //第一页和最后一页的回弹效果
        self.scrollV.bounces = NO;
    }
    
    
    
    
    
}
@end
