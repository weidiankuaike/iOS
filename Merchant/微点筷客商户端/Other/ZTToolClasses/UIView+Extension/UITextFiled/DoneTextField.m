//
//  DoneTextField.m
//  微点筷客商户端
//
//  Created by Skyer God on 17/3/30.
//  Copyright © 2017年 张森森. All rights reserved.
//

#import "DoneTextField.h"

@implementation DoneTextField

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    UIToolbar *bar = [[UIToolbar alloc] initWithFrame:CGRectMake(0,0, kScreenWidth,44)];
    ButtonStyle *button = [ButtonStyle buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(kScreenWidth - 60, 7,50, 30);
    [button setTitle:@"完成"forState:UIControlStateNormal];
    [button setTitleColor:UIColorFromRGB(0xfd7577) forState:UIControlStateNormal];
    button.layer.borderColor = UIColorFromRGB(0xfd7577).CGColor;
    button.layer.borderWidth = 1;
    button.layer.cornerRadius = 3;
    [bar addSubview:button];
    self.inputAccessoryView = bar;

    [button addTarget:self action:@selector(print) forControlEvents:UIControlEventTouchUpInside];
}

- (void)print {
    [self resignFirstResponder];
}
@end
