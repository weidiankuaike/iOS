//
//  NewsTableViewCell.m
//  微点筷客商户端
//
//  Created by 张森森 on 16/10/26.
//  Copyright © 2016年 张森森. All rights reserved.
//

#import "NewsTableViewCell.h"

@implementation NewsTableViewCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self)
    {
       
        _headimage = [[UIImageView alloc]init];
        
        [self addSubview:_headimage];
        _headimage.sd_layout.leftSpaceToView(self,autoScaleW(15)).topSpaceToView(self,autoScaleH(15)).widthIs(autoScaleW(15)).heightIs(autoScaleH(15));
        _timelabel = [[UILabel alloc]init];
        _timelabel.font = [UIFont systemFontOfSize:13];
        _timelabel.textColor = [UIColor blackColor];
        [self addSubview:_timelabel];
        _timelabel.sd_layout.leftSpaceToView(_headimage,autoScaleW(10)).topSpaceToView(self,autoScaleH(15)).widthIs(autoScaleW(90)).heightIs(autoScaleH(15));
        
        _detailabel = [[UILabel alloc]init];
        _detailabel.font = [UIFont systemFontOfSize:11];
        _detailabel.textColor = [UIColor blackColor];
        [self addSubview:_detailabel];
        _detailabel.sd_layout.leftSpaceToView(_timelabel,autoScaleW(5)).topSpaceToView(self,autoScaleH(15)).widthIs(autoScaleW(190)).heightIs(autoScaleH(15));
        
        
        
    }
    
    
    
    
    return self;
    
    
}





- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
