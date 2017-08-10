//
//  UIButton+UnderlineNone.m
//  merchantClient
//
//  Created by Skyer God on 2017/7/24.
//  Copyright © 2017年 张甜. All rights reserved.
//

#import "UIButton+UnderlineNone.h"

@implementation UIButton (UnderlineNone)
@dynamic underlineNone;

-(void)setUnderlineNone:(BOOL)flag {
    if (flag) {
        NSString *text = self.titleLabel.text;
        NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:text];
        //    [str addAttribute:NSForegroundColorAttributeName value:ColorForGestureButton range:NSMakeRange(0,forgetPasswordText.length)];
        [str addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInt:NSUnderlineStyleNone] range:NSMakeRange(0,text.length)];
        [self setAttributedTitle:str forState:UIControlStateNormal];
    }


}
@end
