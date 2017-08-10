//
//  BaseTableViewCell.m
//  WDKKtest
//
//  Created by Skyer God on 16/7/21.
//  Copyright © 2016年 weiDianKuaiKe. All rights reserved.
//

#import "BaseTableViewCell.h"

@implementation BaseTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(void)setFrame:(CGRect)frame{
    
    frame.origin.y += autoScaleH(8);
    frame.size.height -= autoScaleH(8);
    [super setFrame:frame];
    
    self.layer.borderColor = RGB(210, 210, 210).CGColor;
    
    self.layer.borderWidth = 0.5f;
    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
