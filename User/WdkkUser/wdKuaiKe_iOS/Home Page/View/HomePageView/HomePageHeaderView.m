//
//  HomePageHeaderView.m
//  wdKuaiKe_iOS
//
//  Created by Skyer God on 16/9/23.
//  Copyright © 2016年 weiDianKuaiKe. All rights reserved.
//

#import "HomePageHeaderView.h"

#import "BaseButton.h"
@implementation HomePageHeaderView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithReuseIdentifier:reuseIdentifier]) {
        self.contentView.backgroundColor = [UIColor lightTextColor];

        [self create];



    }
    return self;
}
- (void) create{

    self.imageV = [[UIImageView alloc] init];
    self.imageV.image = [UIImage imageNamed:@"turnPlay"];
    [self.contentView addSubview:self.imageV];

    self.imageV.sd_layout
    .leftEqualToView(self.contentView)
    .topEqualToView(self.contentView)
    .rightEqualToView(self.contentView)
    .heightRatioToView([self superview], 1/3.5);


    NSArray *arrTitles                = @[@"中餐", @"西餐", @"甜点饮品", @"烧烤烤肉", @"自助餐",
                                          @"日韩料理", @"小吃快餐", @"川湘菜"];

    NSArray *arrImages                = @[@"chineseFood", @"westFood", @"drinkDessert",
                                          @"barbucue", @"buffetten", @"korean", @"snack", @"siChuan"];
    for (NSInteger i = 0; i < 8; i++) {



        BaseButton *button = [BaseButton buttonWithType:UIButtonTypeCustom];

        [button setTitle:[arrTitles objectAtIndex:i] forState:UIControlStateNormal];

        [button addTarget:self action:@selector(allButtonAction:) forControlEvents:UIControlEventTouchUpInside];

        [button setTag:1000 + i];

        [button setTitleColor:RGB(153, 153, 153) forState:UIControlStateNormal];


        [button setImage:[UIImage imageNamed:[arrImages objectAtIndex:i]] forState:UIControlStateNormal];

        //        [[_arrButton objectAtIndex:i] setImage:[UIImage imageNamed:[arrImages objectAtIndex:i]] forState:UIControlStateHighlighted];

        button.Image_Y =autoScaleH(10);
        button.Image_X =autoScaleW(12.0f);
        button.Title_Space = autoScaleW(5);

        [self.contentView addSubview:button];

        NSInteger rowIndex = i > 4 ? i - 4 : i;
        NSInteger sectionIndex = i > 4 ? 1 : 0;

        CGFloat start_x = 25;
        CGFloat width  =  (self.contentView.size.width - start_x * 2) / 4;
        CGFloat height = 80;
        button.sd_layout
        .leftSpaceToView(self.contentView, start_x + width * rowIndex)
        .topSpaceToView(_imageV, 0 + height * sectionIndex)
        .widthIs(width)
        .heightIs(height);



    }
    
}
@end
