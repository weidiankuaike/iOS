//
//  MySearchBar.m
//  WDKKtest
//
//  Created by Skyer God on 16/7/28.
//  Copyright © 2016年 weiDianKuaiKe. All rights reserved.
//

#import "MySearchBar.h"



@implementation MySearchBar
- (void)layoutSubviews {
    UITextField *searchField;
    NSUInteger numViews = [self.subviews count];
    for(int i = 0; i < numViews; i++) {
        if([[self.subviews objectAtIndex:i] isKindOfClass:[UITextField class]]) { //conform?
            searchField = [self.subviews objectAtIndex:i];
        }
    }
    
    if(!(searchField == nil)) {
        searchField.textColor = [UIColor redColor];
        [searchField setBorderStyle:UITextBorderStyleRoundedRect];
        UIImage *image = [UIImage imageNamed: @"出发位置.png"];
        UIImageView *iView = [[UIImageView alloc] initWithImage:image];
        searchField.leftView = iView;
    }
    [super layoutSubviews];
}
@end

