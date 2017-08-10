//
//  TwoLineLabelButton.m
//  wdKuaiKe_iOS
//
//  Created by Skyer God on 16/8/9.
//  Copyright © 2016年 weiDianKuaiKe. All rights reserved.
//

#import "TwoLineLabelButton.h"

@implementation TwoLineLabelButton

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self create];
    }
    return self;
}
-(void)create{
    
    self.firstLabel = [[UILabel alloc] init];
    
    [self addSubview:_firstLabel];
    
    
    self.secondLabel = [[UILabel alloc] init];
    
    [self addSubview:_secondLabel];
    
    self.firstLabel.font = [UIFont systemFontOfSize:autoScaleW(16)];
    self.secondLabel.font = [UIFont systemFontOfSize:autoScaleW(9)];
    
    self.firstLabel.textAlignment = NSTextAlignmentCenter;
    self.secondLabel.textAlignment = NSTextAlignmentCenter;
    
    
}
- (void)layoutSubviews{
    
    self.firstLabel.frame = CGRectMake(0, 0, self.frame.size.width, _heightFirst);
    

    
    self.secondLabel.frame = CGRectMake(0, _heightFirst + _line_Space, self.frame.size.width, self.frame.size.height - _heightFirst - _line_Space);
}
@end
