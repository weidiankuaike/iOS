//
//  OrderTableViewCell.m
//  微点筷客商户端
//
//  Created by 张森森 on 16/10/10.
//  Copyright © 2016年 张森森. All rights reserved.
//

#import "OrderTableViewCell.h"

@implementation OrderTableViewCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        _headimage = [[UIImageView alloc]init];
        [self addSubview:_headimage];
        _headimage.sd_layout.leftSpaceToView(self,autoScaleH(20)).topSpaceToView(self,autoScaleH(10)).widthIs(autoScaleW(27)).heightIs(autoScaleH(27));
        _namelabel = [[UILabel alloc]init];
        _namelabel.textColor = [UIColor lightGrayColor];
        _namelabel.textAlignment = NSTextAlignmentCenter;
        _namelabel.font = [UIFont systemFontOfSize:autoScaleW(11)];
        [self addSubview:_namelabel];
        _namelabel.sd_layout.leftSpaceToView(self,autoScaleW(10)).topSpaceToView(_headimage,autoScaleH(5)).widthIs(autoScaleW(48)).heightIs(autoScaleH(15));
        
        
        
        _numberlabel = [[UILabel alloc]init];
        _numberlabel.textColor = [UIColor lightGrayColor];
        _numberlabel.font = [UIFont systemFontOfSize:autoScaleW(11)];
        _numberlabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_numberlabel];
        _numberlabel.sd_layout.leftSpaceToView(self,autoScaleW(5)).topSpaceToView(_namelabel,autoScaleH(5)).widthIs(autoScaleW(70)).heightIs(autoScaleH(15));
        
        _timelabel = [[UILabel alloc]init];
        _timelabel.font = [UIFont systemFontOfSize:autoScaleW(14)];
        _timelabel.textColor = UIColorFromRGB(0x636363);
        [self addSubview:_timelabel];
        _timelabel.sd_layout.leftSpaceToView(_headimage,autoScaleW(32)).topSpaceToView(self,autoScaleH(20)).widthIs(autoScaleW(180)).heightIs(autoScaleH(15));
        
        _xinxilabel = [[UILabel alloc]init];
        _xinxilabel.font = [UIFont systemFontOfSize:autoScaleW(12)];
        _xinxilabel.textColor = UIColorFromRGB(0x636363);
        [self addSubview:_xinxilabel];
        _xinxilabel.sd_layout.leftSpaceToView(_headimage,autoScaleW(32)).topSpaceToView(_namelabel,autoScaleH(5)).heightIs(autoScaleH(15));
        [_xinxilabel setSingleLineAutoResizeWithMaxWidth:autoScaleW(120)];
        _moneylabel = [[UILabel alloc]init];
        _moneylabel.textColor = UIColorFromRGB(0xfd7577);
        _moneylabel.textAlignment = NSTextAlignmentCenter;
        _moneylabel.font = [UIFont systemFontOfSize:autoScaleW(15)];
        [self addSubview:_moneylabel];
        _moneylabel.sd_layout.leftSpaceToView(_xinxilabel,autoScaleW(25)).topSpaceToView(_namelabel,autoScaleH(5)).widthIs(autoScaleW(100)).heightIs(autoScaleH(15));
        
        _ydtimelabel = [[UILabel alloc]init];
        _ydtimelabel.textAlignment = NSTextAlignmentRight;
        _ydtimelabel.font = [UIFont systemFontOfSize:autoScaleW(11)];
        _ydtimelabel.textColor = [UIColor lightGrayColor];
        [self addSubview:_ydtimelabel];
        _ydtimelabel.sd_layout.rightSpaceToView(self,autoScaleW(15)).topSpaceToView(self,autoScaleH(20)).widthIs(autoScaleW(120)).heightIs(autoScaleH(15));
        
        
    }
    
    
    return self;
     
}

- (void)setModel:(OrderModel *)model{
    
    NSString *url = [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:model.imagestr]] ? model.imagestr : [model.imagestr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [self.headimage sd_setImageWithURL:[NSURL URLWithString:url]placeholderImage:[UIImage imageNamed:@"loadingIcon"]];
    self.namelabel.text = model.namestr;
    self.timelabel.text = @"订单已结束";
    self.numberlabel.text = [NSString stringWithFormat:@"第%@次到店",model.severalStore];
    self.ydtimelabel.text = model.creattime;
    self.xinxilabel.text = [NSString stringWithFormat:@"%@/桌位待定",model.peoplenumstr];
    NSMutableAttributedString * str = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"定金￥%@",model.totalmoney]];
    [str addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:13] range:NSMakeRange(0,2)];
    [str addAttribute:NSForegroundColorAttributeName value:[UIColor lightGrayColor] range:NSMakeRange(0, 2)];
    self.moneylabel.attributedText = str;

    
}



- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
