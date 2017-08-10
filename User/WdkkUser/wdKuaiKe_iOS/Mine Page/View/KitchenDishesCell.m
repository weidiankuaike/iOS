//
//  KitchenDishesCell.m
//  微点筷客商户端
//
//  Created by Skyer God on 16/11/3.
//  Copyright © 2016年 张森森. All rights reserved.
//

#import "KitchenDishesCell.h"
#import "UIView+ZTShakes.h"
#import "UIImageView+WebCache.h"
@implementation KitchenDishesCell
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self create];

    }
    return self;
}

- (void)create{
    _imageV = [[UIImageView alloc] init];;
    [self.contentView addSubview:_imageV];

    UIView *maskView = [[UIView alloc] init];
    maskView.backgroundColor = RGBA(0, 0, 0, 0.3);
    [self.contentView addSubview:maskView];

    _titleLabel = [[UILabel alloc] init];
    _titleLabel.font = [UIFont systemFontOfSize:11];
    _titleLabel.textColor = [UIColor blackColor];
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:_titleLabel];

    _numLabel = [[UILabel alloc] init];
    _numLabel.textColor = [UIColor whiteColor];
    _numLabel.font = [UIFont systemFontOfSize:15];
    _numLabel.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:_numLabel];
    
    _quelabel = [[UILabel alloc]init];
    _quelabel.textColor = [UIColor redColor];
    _quelabel.font = [UIFont systemFontOfSize:15];
    _quelabel.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:_quelabel];
    _quelabel.hidden = YES;
    

    UIView *contentView = self.contentView;
    _imageV.sd_layout
    .leftSpaceToView(contentView, 0)
    .topSpaceToView(contentView, 0)
    .rightSpaceToView(contentView, 0)
    .bottomSpaceToView(contentView, 25);

    maskView.sd_layout.leftEqualToView(_imageV).rightEqualToView(_imageV).topEqualToView(_imageV).bottomSpaceToView(contentView,25);

    _titleLabel.sd_layout
    .leftEqualToView(contentView)
    .rightEqualToView(contentView)
    .topSpaceToView(_imageV,5)
    .heightIs(20);

    _numLabel.sd_layout
    .centerXEqualToView(contentView)
    .centerYEqualToView(contentView)
    .widthIs(70).heightIs(15);
    
    _quelabel.sd_layout.bottomSpaceToView(_numLabel,10).leftEqualToView(contentView).rightEqualToView(contentView).heightIs(20);
    
    if (_isSelectAll) {

        for (UIView *view in contentView.subviews) {
            [view shakeWithTimes:1000 speed:0.5 range:8 shakeDirection:ZTDirectionRotation];
        }
    }

}
-(void)setModel:(Dinemodel *)model
{
    _model = model;
    [_imageV sd_setImageWithURL:[NSURL URLWithString:_model.imagestr]placeholderImage:[UIImage imageNamed:@"loadingIcon"]];
    _titleLabel.text = _model.productname;
    _numLabel.text = [NSString stringWithFormat:@"x%ld",_model.served];
    if ([_model.foodIndex isEqualToString:@"1"]) {
        
        if (_model.islack!=0) {
            
            NSInteger index = model.productnumber - model.islack;
            if (index == 0)
            {
                _numLabel.text = @"缺货";
                _numLabel.textColor = [UIColor redColor];
                
            }
            else
            {
                _quelabel.hidden = NO;
                _quelabel.text = [NSString stringWithFormat:@"缺%ld份",_model.islack];
                
            }

        }
        
        
    }
    
    
    
}

@end
