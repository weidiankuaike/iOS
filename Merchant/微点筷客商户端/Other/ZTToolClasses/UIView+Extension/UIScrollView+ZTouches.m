//
//  UIScrollView+ZTouches.m
//  微点筷客商户端
//
//  Created by Skyer God on 16/11/2.
//  Copyright © 2016年 张森森. All rights reserved.
//

#import "UIScrollView+ZTouches.h"

@implementation UIScrollView (ZTouches)

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [[self nextResponder] touchesBegan:touches withEvent:event];
    [super touchesBegan:touches withEvent:event];
//    self.scrollEnabled = NO;
}

-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    [[self nextResponder] touchesMoved:touches withEvent:event];
    [super touchesMoved:touches withEvent:event];

}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    [[self nextResponder] touchesEnded:touches withEvent:event];
    [super touchesEnded:touches withEvent:event];

//    self.scrollEnabled = YES;
}

@end
