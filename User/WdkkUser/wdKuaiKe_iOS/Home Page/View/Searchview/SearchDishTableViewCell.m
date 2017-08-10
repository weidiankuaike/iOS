//
//  SearchDishTableViewCell.m
//  wdKuaiKe_iOS
//
//  Created by 张森森 on 17/1/19.
//  Copyright © 2017年 weiDianKuaiKe. All rights reserved.
//

#import "SearchDishTableViewCell.h"

@implementation SearchDishTableViewCell
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        _headimage = [[UIImageView alloc]init];
        [self addSubview:_headimage];
        _headimage.sd_layout.leftSpaceToView(self,autoScaleW(15)).topSpaceToView(self,autoScaleH(7)).widthIs(45).heightIs(45);
        _namelabel = [[UILabel alloc]init];
        _namelabel.font = [UIFont systemFontOfSize:13];
        _namelabel.textColor = [UIColor blackColor];
        [self addSubview:_namelabel];
        _namelabel.sd_layout.leftSpaceToView(_headimage,autoScaleW(15)).topSpaceToView(self,15).heightIs(15);
        [_namelabel setSingleLineAutoResizeWithMaxWidth:200];
        
        _pricelabel = [[UILabel alloc]init];
        _pricelabel.font = [UIFont systemFontOfSize:15];
        _pricelabel.textColor = UIColorFromRGB(0xfd7577);
        [self addSubview:_pricelabel];
        _pricelabel.sd_layout.rightSpaceToView(self,15).topEqualToView(_namelabel).heightIs(15);
       [_pricelabel setSingleLineAutoResizeWithMaxWidth:200];
        
        _salelabel = [[UILabel alloc]init];
        _salelabel.font = [UIFont systemFontOfSize:13];
        _salelabel.textColor = [UIColor lightGrayColor];
        [self addSubview:_salelabel];
        _salelabel.sd_layout.leftEqualToView(_namelabel).topSpaceToView(_pricelabel,10).heightIs(15);
        [_salelabel setSingleLineAutoResizeWithMaxWidth:150];
        
        UILabel * linelabel = [[UILabel alloc]init];
        linelabel.backgroundColor = UIColorFromRGB(0xeeeeee);
        [self addSubview:linelabel];
        linelabel.sd_layout.leftEqualToView(self).rightEqualToView(self).bottomEqualToView(self).heightIs(1);
        
    }
    
    return self;
}
- (void)setModel:(SearchdishModel *)model
{
    _model = model;
    [_headimage sd_setImageWithURL:[NSURL URLWithString:_model.images]placeholderImage:[UIImage imageNamed:@"1"]];
    _namelabel.text = _model.productName;
    _pricelabel.text = [NSString stringWithFormat:@"￥%@",_model.fee];
    _salelabel.text = [NSString stringWithFormat:@"已售%@单",_model.sales];
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
