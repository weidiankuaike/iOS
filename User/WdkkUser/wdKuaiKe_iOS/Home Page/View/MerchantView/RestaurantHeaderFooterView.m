//
//  RestaurantHeaderFooterView.m
//  wdKuaiKe_iOS
//
//  Created by Skyer God on 16/9/23.
//  Copyright © 2016年 weiDianKuaiKe. All rights reserved.
//

#import "RestaurantHeaderFooterView.h"

@implementation RestaurantHeaderFooterView

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

    self.titleLabel = [[UILabel alloc] init];
    self.titleLabel.backgroundColor = [UIColor redColor];
    self.titleLabel.font = [UIFont systemFontOfSize:14];
    self.titleLabel.textColor = [UIColor blackColor];
    self.titleLabel.frame = self.contentView.bounds;
    [self.contentView addSubview:_titleLabel];

}

-(void)layoutSubviews{
    [super layoutSubviews];
    self.titleLabel.sd_layout
    .leftSpaceToView(self.contentView, 13)
    .topEqualToView(self.contentView)
    .bottomEqualToView(self.contentView);
    [self.titleLabel setSingleLineAutoResizeWithMaxWidth:180];
}

@end
