//
//  VageTableViewCell.m
//  微点筷客商户端
//
//  Created by 张森森 on 16/10/20.
//  Copyright © 2016年 张森森. All rights reserved.
//

#import "VageTableViewCell.h"

@implementation VageTableViewCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
    
        _pmlabel =[[UILabel alloc]init];
        _pmlabel.textAlignment = NSTextAlignmentCenter;
        _pmlabel.font = [UIFont systemFontOfSize:13];
        _pmlabel.textColor = [UIColor blackColor];
        [self addSubview:_pmlabel];
        _pmlabel.sd_layout.leftSpaceToView(self,autoScaleW(25)).topSpaceToView(self,autoScaleH(15)).widthIs(autoScaleW(30)).heightIs(autoScaleH(15));
        _namelabel  =[[UILabel alloc]init];

        _namelabel.font =[UIFont systemFontOfSize:13];
        _namelabel.textColor = [UIColor blackColor];
        [self addSubview:_namelabel];
        _namelabel.sd_layout.leftSpaceToView(_pmlabel,autoScaleW(40)).topSpaceToView(self,autoScaleH(15)).heightIs(autoScaleH(15)).widthIs(autoScaleW(90));
        
        
        _xslabel = [[UILabel alloc]init];
        _xslabel.textAlignment = NSTextAlignmentCenter;

        _xslabel.font = [UIFont systemFontOfSize:13];
        _xslabel.textColor = [UIColor blackColor];
        [self addSubview:_xslabel];
        _xslabel.sd_layout.leftSpaceToView(_namelabel,autoScaleW(20)).topSpaceToView(self,autoScaleH(15)).heightIs(autoScaleH(15)).widthIs(autoScaleW(80));
        
        
        _zblabel = [[UILabel alloc]init];
        _zblabel.textAlignment = NSTextAlignmentCenter;

        _zblabel.font = [UIFont systemFontOfSize:13];
        _zblabel.textColor = [UIColor blackColor];
        [self addSubview:_zblabel];
        _zblabel.sd_layout.leftSpaceToView(_xslabel,autoScaleW(20)).topSpaceToView(self,autoScaleH(15)).heightIs(autoScaleH(15)).widthIs(autoScaleW(60));
        
        
        
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
