//
//  BrowTableViewCell.m
//  wdKuaiKe_iOS
//
//  Created by 张森森 on 16/12/24.
//  Copyright © 2016年 weiDianKuaiKe. All rights reserved.
//

#import "BrowTableViewCell.h"

@implementation BrowTableViewCell
-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        _headview = [[UIImageView alloc]init];
        [self addSubview:_headview];
        _headview.sd_layout.leftSpaceToView(self,autoScaleW(15)).topSpaceToView(self,autoScaleH(15)).widthIs(70).heightIs(70);
        _namelabel = [[UILabel alloc]init];
        _namelabel.font = [UIFont systemFontOfSize:15];
        _namelabel.textColor = UIColorFromRGB(0x000000);
        [self addSubview:_namelabel];
        _namelabel.sd_layout.leftSpaceToView(_headview,10).topEqualToView(_headview).heightIs(15);
        [_namelabel setSingleLineAutoResizeWithMaxWidth:300];
        
        _introductionlabel = [[UILabel alloc]init];
        _introductionlabel.font = [UIFont systemFontOfSize:11];
        _introductionlabel.numberOfLines = 0;
        _introductionlabel.textColor = UIColorFromRGB(0x838383);
        [self addSubview:_introductionlabel];
        _introductionlabel.sd_layout.leftEqualToView(_namelabel).topSpaceToView(_namelabel,5).widthIs(GetWidth-30-_headview.frame.size.width).heightIs(30);
        
        _renjunlabel = [[UILabel alloc]init];
        _renjunlabel.text = @"人均";
        _renjunlabel.font = [UIFont systemFontOfSize:13];
        _renjunlabel.textColor = UIColorFromRGB(0x838383);
        [self addSubview:_renjunlabel];
        _renjunlabel.sd_layout.leftEqualToView(_namelabel).topSpaceToView(_introductionlabel,10).widthIs(30).heightIs(15);
        
        _moneylabel = [[UILabel alloc]init];
        _moneylabel.font = [UIFont boldSystemFontOfSize:20];
        _moneylabel.textColor = UIColorFromRGB(0xfd7577);
        [self addSubview:_moneylabel];
        _moneylabel.sd_layout.leftSpaceToView(_renjunlabel,8).topSpaceToView(_introductionlabel,10).heightIs(20);
        [_moneylabel setSingleLineAutoResizeWithMaxWidth:200];

        
        _distancelabel = [[UILabel alloc]init];
        _distancelabel.font = [UIFont systemFontOfSize:13];
        _distancelabel.textColor = UIColorFromRGB(0x838383);
        _distancelabel.textAlignment = NSTextAlignmentRight;
        [self addSubview:_distancelabel];
        _distancelabel.sd_layout.rightSpaceToView(self,5).topEqualToView(_moneylabel).heightIs(15);
        [_distancelabel setSingleLineAutoResizeWithMaxWidth:150];
        
    }
    
    
    return self;
}
-(void)setModel:(Browmodel *)model
{
    _model = model;
    
    [_headview sd_setImageWithURL:[NSURL URLWithString:_model.storeidimage]];
    _namelabel.text = _model.namestr;
    _introductionlabel.text = _model.introduction;
    _moneylabel.text = [NSString stringWithFormat:@"￥%@",_model.pricestr];
    _distancelabel.text = _model.distance;
}
- (void)awakeFromNib {
    [super awakeFromNib];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
