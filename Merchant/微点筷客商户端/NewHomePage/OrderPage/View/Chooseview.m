//
//  Chooseview.m
//  微点筷客商户端
//
//  Created by 张森森 on 16/11/9.
//  Copyright © 2016年 张森森. All rights reserved.
//

#import "Chooseview.h"

@implementation Chooseview

-(instancetype)initWitharray:(NSArray*)chooseary
{
    self = [super init];
    if (self)
    {
     
        
        
        
    }
    
    
    return self;
    
}
-(void)GetviewWitharray:(NSArray*)ary
{
    UIWindow * window = [UIApplication sharedApplication].keyWindow;
    
    UIView * chooseview = [[UIView alloc]init];
    chooseview.frame = CGRectMake(_orx, _ory, autoScaleW(40), autoScaleH(20)*ary.count);
    chooseview.backgroundColor = [UIColor whiteColor];
    [window addSubview:chooseview];
    
    for (int i=0; i<ary.count; i++)
    {
        ButtonStyle * choosebtn = [ButtonStyle buttonWithType:UIButtonTypeCustom];
        [choosebtn setTitle:ary[i] forState:UIControlStateNormal];
        choosebtn.titleLabel.font = [UIFont systemFontOfSize:autoScaleW(13)];
        choosebtn.frame = CGRectMake(0, i*autoScaleH(20), autoScaleW(40), autoScaleH(20));
        [choosebtn addTarget:self action:@selector(Clickbtn:) forControlEvents:UIControlEventTouchUpInside];
        [chooseview addSubview:choosebtn];
        
        
        
    }
}

-(void)Clickbtn:(ButtonStyle *)btn
{
    
    
    
    
    
}





@end
