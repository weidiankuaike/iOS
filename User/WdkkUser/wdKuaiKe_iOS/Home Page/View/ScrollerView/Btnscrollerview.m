//
//  Btnscrollerview.m
//  wdKuaiKe_iOS
//
//  Created by 张森森 on 17/1/10.
//  Copyright © 2017年 weiDianKuaiKe. All rights reserved.
//

#import "Btnscrollerview.h"

@implementation Btnscrollerview

- (instancetype)initWithint:(NSInteger)btnint
{
    self = [super init];
    if (self) {
        
        _btninteger = btnint;
        [self CreatBtnwith];
        
    }
    
    return self;
}
- (void)CreatBtnwith
{
    NSArray *arrTitles                = @[@"中餐", @"西餐", @"甜点饮品", @"烧烤烤肉", @"自助餐",
                                          @"日韩料理", @"小吃快餐", @"特色炒菜"];
    
    NSArray *arrImages                = @[@"中餐", @"西餐", @"甜品",
                                          @"烧烤", @"自助", @"日韩", @"快餐", @"特色炒菜"];
    
    for (int i=0; i<_btninteger; i++) {
        
        BaseButton * button = [BaseButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(autoScaleW(10)+i*((GetWidth - autoScaleW(50))/4 +10), autoScaleH(10), (GetWidth - autoScaleW(50))/4, autoScaleH(95));
        
        [button setTitle:[arrTitles objectAtIndex:i] forState:UIControlStateNormal];
        
        [button addTarget:self action:@selector(allButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        
        [button setTag:1000 + i];
        
        [button setTitleColor:RGB(153, 153, 153) forState:UIControlStateNormal];
        [button setTitleColor:RGB(237, 125, 123) forState:UIControlStateHighlighted];
        
        [button setImage:[UIImage imageNamed:[arrImages objectAtIndex:i]] forState:UIControlStateNormal];
        
        //        [[_arrButton objectAtIndex:i] setImage:[UIImage imageNamed:[arrImages objectAtIndex:i]] forState:UIControlStateHighlighted];
        
        button.Image_Y =8;
        button.Image_X =8;
        button.Title_Space = autoScaleH(15);
        
        [self addSubview:button];
        
        
    }
 
}
-(void)Getsomethingwithblock:(btnblock)block
{
    self.block = block;
}

- (void)allButtonAction:(UIButton*)btn
{
    if (self.block) {
        
        self.block (btn.tag - 1000);
    }
    
    
}




@end
