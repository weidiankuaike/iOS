//
//  ShouCangTableViewCell.m
//  wdKuaiKe_iOS
//
//  Created by 张森森 on 16/9/19.
//  Copyright © 2016年 weiDianKuaiKe. All rights reserved.
//

#import "ShouCangTableViewCell.h"

@implementation ShouCangTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
}
-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        _headimage = [[UIImageView alloc]init];
        [self addSubview:self.headimage];
        _headimage.sd_layout.leftSpaceToView(self,autoScaleW(15)).topSpaceToView(self,autoScaleH(10)).widthIs(autoScaleW(66)).heightIs(autoScaleW(66));
        
        
        _xqlabel = [[UILabel alloc]init];
        _xqlabel.font = [UIFont systemFontOfSize:autoScaleW(15)];
        _xqlabel.textColor = UIColorFromRGB(0x000000);
        _xqlabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:self.xqlabel];
        _xqlabel.sd_layout.centerXEqualToView(self).centerYEqualToView(self).widthIs(autoScaleW(260)).heightIs(autoScaleH(22));
        
        _number = [[UILabel alloc]init];
        _number.font = [UIFont systemFontOfSize:autoScaleW(15)];
        _number.textAlignment = NSTextAlignmentRight;
        _number.textColor = UIColorFromRGB(0x000000);
        [self addSubview:self.number];
        _number.sd_layout.rightSpaceToView(self,autoScaleW(15)).centerYEqualToView(self).widthIs(autoScaleW(100)).heightIs(autoScaleH(20));
        
        
    }
    
    
    
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
