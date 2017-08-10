//
//  YindaoView.m
//  wdKuaiKe_iOS
//
//  Created by 张森森 on 16/9/1.
//  Copyright © 2016年 weiDianKuaiKe. All rights reserved.
//

#import "YindaoView.h"
#define GUIDE @"/guide"


@implementation YindaoView
+(void)ShowgudieView:(NSArray *)imageAry
{
    if (imageAry&&imageAry.count>0) {
        
        NSFileManager  *fileman = [NSFileManager defaultManager];
        NSArray * paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString * docDir = [NSString stringWithFormat:@"%@/%@",[paths objectAtIndex:0],GUIDE];
        BOOL isHasfile = [fileman fileExistsAtPath:docDir];
        if (!isHasfile) {
            
            YindaoView * yindaoview = [[YindaoView alloc]init:imageAry];
            [[UIApplication sharedApplication].delegate.window addSubview:yindaoview];
            [fileman createFileAtPath:docDir contents:nil attributes:nil];
        }
    }

}
+(void)Skipguide
{
    NSFileManager * fileman = [NSFileManager defaultManager];
    NSArray * paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString * docDir = [NSString stringWithFormat:@"%@/%@",[paths objectAtIndex:0],GUIDE];
    
    [fileman createFileAtPath:docDir contents:nil attributes:nil];
    
    
    
}
-(instancetype)init:(NSArray *)imageAry
{
    self = [super init];
    if (self)
    {
        [self initThisView:imageAry];
        
    }
    
    return self;
    
    
}
-(void)initThisView:(NSArray*)imageAry
{
    _imageAry = imageAry;
    screen_hight = [UIScreen mainScreen].bounds.size.height;
    screen_width = [UIScreen mainScreen].bounds.size.width;
    self.frame = CGRectMake(0, 0, screen_width, screen_hight);
    
    _scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, screen_width, screen_hight)];
    _scrollView.contentSize = CGSizeMake(screen_width * (_imageAry.count+1), screen_hight);
    _scrollView.pagingEnabled = YES;
    _scrollView.bounces = YES;
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.tag = 7000;
    _scrollView.delegate = self;
    
    for (int i =0; i <imageAry.count; i ++) {
        
        CGRect fram =CGRectMake(i *screen_width, 0, screen_width, screen_hight);
        UIImageView * imge = [[UIImageView alloc]initWithFrame:fram];
        imge.image = [UIImage imageNamed:imageAry[i]];
        [_scrollView addSubview:imge];
        
        CGRect skiprect = CGRectMake((i+1)*screen_width- autoScaleW(70), autoScaleH(25), autoScaleW(45), autoScaleH(26));
        UIButton * passBtn = [[UIButton alloc]initWithFrame:skiprect];
        
        [passBtn addTarget:self action:@selector(dismissGuide) forControlEvents:UIControlEventTouchUpInside];
        passBtn.backgroundColor= [UIColor clearColor];
        [passBtn.titleLabel setFont:[UIFont systemFontOfSize:autoScaleW(13)]];
        NSString * title = i==imageAry.count-1?@"进入": @"跳过";
        
        [passBtn setTitle:title forState:UIControlStateNormal];
        [_scrollView addSubview:passBtn];
        
        
        
        
    }
    [self addSubview:_scrollView];
}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView.contentOffset.x >=4 * screen_width) {
        [self dismissGuide];
    }
    
    
}
-(void)dismissGuide
{
    [UIView animateWithDuration:0.6f animations:^{
        self.transform = CGAffineTransformMakeScale(1.5, 1.5);
        self.backgroundColor = [UIColor clearColor];
        self.alpha = 0;
        
    } completion:^(BOOL finished) {
        
        [self removeFromSuperview];
        
    }];
    
    
    
}
@end
