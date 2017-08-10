//
//  PayTableViewCell.m
//  wdKuaiKe_iOS
//
//  Created by 张森森 on 16/9/12.
//  Copyright © 2016年 weiDianKuaiKe. All rights reserved.
//

#import "PayTableViewCell.h"

@implementation PayTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        
        _headimage = [[UIImageView alloc]init];
        [self addSubview:self.headimage];
        self.headimage.sd_layout.leftSpaceToView(self,autoScaleW(15)).topSpaceToView(self,autoScaleH(28)).widthIs(autoScaleW(25)).heightIs(autoScaleH(20));
        _namelable = [[UILabel alloc]init];
        _namelable.font = [UIFont systemFontOfSize:autoScaleW(17)];
        [self addSubview:self.namelable];
        self.namelable.sd_layout.leftSpaceToView(self.headimage,autoScaleW(25)).topSpaceToView(self,autoScaleH(15)).widthIs(autoScaleW(100)).heightIs(autoScaleH(17));
        _tuijainlabel = [[UILabel alloc]init];
        
        _tuijainlabel.textColor = [UIColor grayColor];
        _tuijainlabel.font = [UIFont systemFontOfSize:autoScaleW(13)];
        [self addSubview:self.tuijainlabel];
        
        self.tuijainlabel.sd_layout.leftSpaceToView(self.headimage,autoScaleW(25)).topSpaceToView(self.namelable,autoScaleH(10)).widthIs(autoScaleW(240)).heightIs(autoScaleH(13));
        
        
        
        
        
        
    }
    
    
    
    
    return self;
    
}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
