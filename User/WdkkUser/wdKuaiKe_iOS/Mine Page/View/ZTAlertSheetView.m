//
//  ZTAlertSheetView.m
//  微点筷客商户端
//
//  Created by Skyer God on 16/10/28.
//  Copyright © 2016年 张森森. All rights reserved.
//

#import "ZTAlertSheetView.h"

#define mainScreen [UIScreen mainScreen].bounds
//RGB颜色
#define RGBA(r, g, b, a)                    [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:a]

#define RGB(r, g, b)                        RGBA(r, g, b, 1.0f)

#define UIColorFromRGBA(rgbValue, a) [UIColor colorWithRed:((CGFloat)((rgbValue & 0xFF0000) >> 16))/255.0 green:((CGFloat)((rgbValue & 0xFF00) >> 8))/255.0 blue:((CGFloat)(rgbValue & 0xFF))/255.0 alpha:a]
@implementation ZTAlertSheetView

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */
{
    NSInteger arrCount;

    UIView *maskView;

    UIView *topBackView;
}

- (instancetype)initWithTitleArray:(NSArray *)array
{
    self = [super init];
    if (self) {
        self.frame = CGRectMake(0, 1000, mainScreen.size.width, mainScreen.size.height);
        arrCount = array.count;
        [self create:array];
    }
    return self;
}
- (void)create:(NSArray *)array{

    maskView = [[UIView alloc] initWithFrame:mainScreen];
    maskView.backgroundColor = RGBA(0, 0, 0, 0.3);


    self.backgroundColor = [UIColor clearColor];
    [maskView addSubview:self];
    
    CGFloat start_x = 8;
    CGFloat width = mainScreen.size.width - start_x * 2;
    CGFloat height = 60;
    CGFloat start_y = mainScreen.size.height - height - start_x;

    UIButton *bottomBT = [UIButton buttonWithType:UIButtonTypeCustom];
    bottomBT.frame = CGRectMake(start_x,  start_y , width, height);
    [bottomBT setTitle:[array lastObject] forState:UIControlStateNormal];
    [bottomBT setTitleColor:UIColorFromRGBA(0xfd7577, 0.9) forState:UIControlStateNormal];
    [bottomBT addTarget:self action:@selector(bottomAction:) forControlEvents:UIControlEventTouchUpInside];
    [bottomBT setBackgroundColor:[UIColor whiteColor]];
    [self addSubview:bottomBT];

    CGFloat separator_height = 0.8;
    CGFloat top_Y = start_y - (array.count - 1) * height + (array.count - 1) * separator_height - start_x * 1.73;
    CGFloat top_height = height * (array.count - 1) + (array.count - 2) * separator_height;

    topBackView = [[UIView alloc] initWithFrame:CGRectMake(start_x, top_Y, width, top_height)];
    topBackView.backgroundColor = [UIColor whiteColor];
    [self addSubview:topBackView];




    for (NSInteger i = 0; i < array.count - 1; i++) {

        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(0, 0 + (height + separator_height) * i, width, height);
        [button setTitleColor:bottomBT.titleLabel.textColor forState:UIControlStateNormal];
        [button setTitle:array[i] forState:UIControlStateNormal];
        [button setBackgroundColor:[UIColor whiteColor]];
        button.tag = 40000 + i;
        [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        [topBackView addSubview:button];

        if (i < array.count - 2) {
            UILabel *separatorLine = [[UILabel alloc] initWithFrame:CGRectMake(0, height + (separator_height +height) * i, width, separator_height)];
            separatorLine.backgroundColor = [UIColor lightGrayColor];
            [topBackView addSubview:separatorLine];
        }

    }

    topBackView.layer.cornerRadius = height / 8;
    topBackView.layer.masksToBounds  = YES;

    bottomBT.layer.cornerRadius = topBackView.layer.cornerRadius;
    bottomBT.layer.masksToBounds = YES;
}

- (void)showView{

    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    [window addSubview:maskView];
    maskView.alpha = 0;
    self.frame = CGRectMake(0, topBackView.origin.y, mainScreen.size.width, mainScreen.size.height);
    [UIView animateWithDuration:.25 delay:0 options:UIViewAnimationOptionTransitionFlipFromLeft animations:^{
        maskView.alpha = 1;
        self.frame = CGRectMake(0, 0, mainScreen.size.width, mainScreen.size.height);

    } completion:^(BOOL finished) {


    }];

}


- (void)dismiss{

    maskView.alpha = 1;

    [UIView animateWithDuration:.35 animations:^{
        self.frame = CGRectMake(0, topBackView.frame.origin.y, mainScreen.size.width, mainScreen.size.height);
        maskView.alpha = 0.0;
    } completion:^(BOOL finished) {
        if (finished) {
            [maskView removeFromSuperview];
        }

    }];

}
- (void)buttonAction:(UIButton *)sender{
    [self dismiss];
    self.alertSheetReturn(sender.tag - 40000);
}
- (void)bottomAction:(UIButton *)sender{
    [self dismiss];
    self.alertSheetReturn(arrCount);
}
@end
