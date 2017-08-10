//
//  HeaderView.m
//  WDKKtest
//
//  Created by Skyer God on 16/7/22.
//  Copyright © 2016年 weiDianKuaiKe. All rights reserved.
//

#define Button_Width 52      // 宽

#define Width_Space 0         // 2个按钮之间的横间距
#define Height_Space 0      // 竖间距

#import "HeaderView.h"

@interface HeaderView ()

@property (nonatomic, retain)NSArray *arrButton;

@end
@implementation HeaderView

-(void)setFrame:(CGRect)frame{
    frame.size.height -= kHeight(5);
    [super setFrame:frame];
}
-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self createHeaderView];
    }
    return self;
}
- (void)createHeaderView{
    
    
    _homeHeaderImageV                 = [[UIImageView alloc] init];
    
    _homeHeaderImageV.backgroundColor = [UIColor yellowColor];
    
    
    _homeHeaderImageV.image           = [UIImage imageNamed:@"turnPlay"];
    
    
    
    _chineseFoodBT                    = [BaseButton buttonWithType:UIButtonTypeCustom];
    _westFoodBT                       = [BaseButton buttonWithType:UIButtonTypeCustom];
    _drinkDessertBT                   = [BaseButton buttonWithType:UIButtonTypeCustom];
    _barbecueBT                       = [BaseButton buttonWithType:UIButtonTypeCustom];
    _buffettenBT                      = [BaseButton buttonWithType:UIButtonTypeCustom];
    _koreanBT                         = [BaseButton buttonWithType:UIButtonTypeCustom];
    _snackBT                          = [BaseButton buttonWithType:UIButtonTypeCustom];
    _siChuanBT                        = [BaseButton buttonWithType:UIButtonTypeCustom];
    [self addSubview:_homeHeaderImageV];
    
    //添加8个功能模块的button
    _arrButton                        = [NSArray arrayWithObjects:_chineseFoodBT, _westFoodBT, _drinkDessertBT, _barbecueBT, _buffettenBT, _koreanBT, _snackBT, _siChuanBT, nil];
    
    NSArray *arrTitles                = @[@"中餐", @"西餐", @"甜点饮品", @"烧烤烤肉", @"自助餐",
                                          @"日韩料理", @"小吃快餐", @"川湘菜"];
    
    NSArray *arrImages                = @[@"chineseFood", @"westFood", @"drinkDessert",
                                          @"barbucue", @"buffetten", @"korean", @"snack", @"siChuan"];
    
    for (int i = 0 ; i < 8; i++) {
        
        BaseButton *button = [BaseButton buttonWithType:UIButtonTypeCustom];
        
        button = [_arrButton objectAtIndex:i];
        
        [button setTitle:[arrTitles objectAtIndex:i] forState:UIControlStateNormal];
        
        [button addTarget:self action:@selector(allButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        
        [button setTag:1000 + i];
        
        [button setTitleColor:RGB(153, 153, 153) forState:UIControlStateNormal];
        [button setTitleColor:RGB(237, 125, 123) forState:UIControlStateHighlighted];
        
       
        [button setImage:[UIImage imageNamed:[arrImages objectAtIndex:i]] forState:UIControlStateNormal];
        
        //        [[_arrButton objectAtIndex:i] setImage:[UIImage imageNamed:[arrImages objectAtIndex:i]] forState:UIControlStateHighlighted];
        
        button.Image_Y =autoScaleH(10);
        button.Image_X =autoScaleW(12.0f);
        button.Title_Space = autoScaleW(5);
        
        [self addSubview:button];
        self.layer.borderColor = [UIColor colorWithRed:0.7482 green:0.7482 blue:0.7482 alpha:1.0].CGColor;
        self.layer.borderWidth = 0.5f;
    }
    
    
}
- (void)allButtonAction:(UIButton *)sender{
    
    NSLog(@"%ld %@ - _- ", sender.tag, sender.titleLabel.text);
    
    
}
- (void)layoutSubviews{
    
    [super layoutSubviews];
    
    self.homeHeaderImageV.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height / 2);
 
    self.homeHeaderImageV.sd_layout
    .leftEqualToView(self)
    .topEqualToView(self)
    .rightEqualToView(self)
    .heightRatioToView([self superview], 1/4);

    


    for (int i = 0 ; i < 8; i++) {
        BaseButton *button = [_arrButton objectAtIndex:i];
        NSInteger index = i % 4;
        
        NSInteger page = i / 4;
        
        [button setFrame: CGRectMake(_homeHeaderImageV.frame.origin.x + index * (self.frame.size.width / 4 + Height_Space), _homeHeaderImageV.frame.origin.y + _homeHeaderImageV.frame.size.height + page * (self.frame.size.height - _homeHeaderImageV.frame.size.height) / 2, self.frame.size.width / 4, (self.frame.size.height - _homeHeaderImageV.frame.size.height) / 2)];

        button.Image_Y =autoScaleH(10);
        button.Image_X =autoScaleW(12.0f);
        button.Title_Space = autoScaleW(5);


    }
}
@end
