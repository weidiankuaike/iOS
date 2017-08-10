//
//  MywalletTableViewCell.m
//  wdKuaiKe_iOS
//
//  Created by 张森森 on 16/12/22.
//  Copyright © 2016年 weiDianKuaiKe. All rights reserved.
//

#import "MywalletTableViewCell.h"

@implementation MywalletTableViewCell
-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        _typelabel = [[UILabel alloc]init];
        _typelabel.font = [UIFont systemFontOfSize:13];
        _typelabel.textColor = UIColorFromRGB(0x000000);
        [self addSubview:_typelabel];
        _typelabel.sd_layout.leftEqualToView(self).topSpaceToView(self,15).heightIs(15);
        [_typelabel setSingleLineAutoResizeWithMaxWidth:200];
        
        _timelabel = [[UILabel alloc]init];
        _timelabel.font = [UIFont systemFontOfSize:11];
        _timelabel.textColor = UIColorFromRGB(0x000000);
        [self addSubview:_timelabel];
        _timelabel.sd_layout.leftEqualToView(self).topSpaceToView(_typelabel,15).heightIs(15);
        [_timelabel setSingleLineAutoResizeWithMaxWidth:150];
        
        _moneylabel = [[UILabel alloc]init];
        _moneylabel.font = [UIFont systemFontOfSize:13];
        _moneylabel.textColor = UIColorFromRGB(0x000000);
        _moneylabel.textAlignment = NSTextAlignmentRight;
        [self addSubview:_moneylabel];
        _moneylabel.sd_layout.rightEqualToView(self).topEqualToView(_typelabel).heightIs(15);
        [_moneylabel setSingleLineAutoResizeWithMaxWidth:150];
        
        _zhuangtailabel = [[UILabel alloc]init];
        _zhuangtailabel.font = [UIFont systemFontOfSize:11];
        _zhuangtailabel.textColor = UIColorFromRGB(0x000000);
        _zhuangtailabel.textAlignment = NSTextAlignmentRight;
        [self addSubview:_zhuangtailabel];
        _zhuangtailabel.sd_layout.rightEqualToView(self).topEqualToView(_timelabel).heightIs(15).widthIs(50);
        
        
        
        
        
        
    }
    
    
    return self;
}
-(void)setModel:(Mywalletmodel*)model
{
    
    _model = model;
    _typestr = _model.namestr;
    if ([_typestr isEqualToString:@"1"])
    {
        _typelabel.text = @"您发起了提现";
        
    }
    else if ([_typestr isEqualToString:@"2"]) {
        
        _typelabel.text = @"您收到一笔商家退款";
    }
    
    if ([_model.ztstr isEqualToString:@"1"]) {
        
        _zhuangtailabel.text = @"处理中";
    }
    else if ([_model.ztstr isEqualToString:@"2"])
    {
        _zhuangtailabel.text = @"已到账";
    }
    
    if ([_typestr isEqualToString:@"1"])
    {
        _moneylabel.text = [NSString stringWithFormat:@"-%@",_model.moneystr];
        
    }
    else if ([_typestr isEqualToString:@"2"]) {
        
        _moneylabel.text = [NSString stringWithFormat:@"+%@",_model.moneystr];
    }

    
    
    _timelabel.text = _model.timestr;
    
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
