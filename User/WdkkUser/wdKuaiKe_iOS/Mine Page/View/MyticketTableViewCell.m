//
//  MyticketTableViewCell.m
//  wdKuaiKe_iOS
//
//  Created by 张森森 on 16/12/21.
//  Copyright © 2016年 weiDianKuaiKe. All rights reserved.
//

#import "MyticketTableViewCell.h"
@implementation MyticketTableViewCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self)
    {
        _cardtitle = [[UILabel alloc]init];
        if ([_typest isEqualToString:@"0"]) {
            
            _cardtitle.textColor = UIColorFromRGB(0xfd7577);
            
        }
        if ([_typest isEqualToString:@"2"]) {
            
            _cardtitle.textColor = UIColorFromRGB(0xa6a6a6);
        }
        _cardtitle.font = [UIFont systemFontOfSize:15];
        [self addSubview:_cardtitle];
        _cardtitle.sd_layout.leftSpaceToView(self,15).topSpaceToView(self,15).autoHeightRatio(0);
        [_cardtitle setSingleLineAutoResizeWithMaxWidth:200];
        
        _discout = [[UILabel alloc]init];
        if ([_typest isEqualToString:@"0"]) {
            
            _discout.textColor = UIColorFromRGB(0xfd7577);
            
        }
        if ([_typest isEqualToString:@"2"]) {
            
            _discout.textColor = UIColorFromRGB(0xa6a6a6);
        }

        _discout.font = [UIFont boldSystemFontOfSize:20];
        [self addSubview:_discout];
        _discout.sd_layout.leftSpaceToView(self,15).topSpaceToView(_cardtitle,20).heightIs(20);
        [_discout setSingleLineAutoResizeWithMaxWidth:200];
        
        
        _consumover = [[UILabel alloc]init];
        if ([_typest isEqualToString:@"0"]) {
            
            _consumover.textColor = UIColorFromRGB(0x696969);
            
        }
        if ([_typest isEqualToString:@"2"]) {
            
            _consumover.textColor = UIColorFromRGB(0xa6a6a6);
        }

        _consumover.font = [UIFont systemFontOfSize:13];
        [self addSubview:_consumover];
        _consumover.sd_layout.leftSpaceToView(_discout,15).topSpaceToView(_cardtitle,25).heightIs(15);
        [_consumover setSingleLineAutoResizeWithMaxWidth:200];
        
        
        _begintime = [[UILabel alloc]init];
        if ([_typest isEqualToString:@"0"]) {
            
            _begintime.textColor = UIColorFromRGB(0x727272);
            
        }
        if ([_typest isEqualToString:@"2"]) {
            
            _begintime.textColor = UIColorFromRGB(0xa6a6a6);
        }

        _begintime.font = [UIFont systemFontOfSize:13];
        _begintime.textAlignment = NSTextAlignmentRight;
        [self addSubview:_begintime];
        _begintime.sd_layout.rightSpaceToView(self,15).topSpaceToView(self,15).heightIs(15).widthIs(200);
        
        _cardtype = [[UILabel alloc]init];
        if ([_typest isEqualToString:@"0"]) {
            
            _cardtype.textColor = UIColorFromRGB(0x000000);
            _cardtype.text = @"马上使用";
        }
        if ([_typest isEqualToString:@"2"]) {
            
            _cardtype.textColor = UIColorFromRGB(0xa6a6a6);
            _cardtype.text = @"已失效";
        }

        _cardtype.font = [UIFont systemFontOfSize:15];
        _cardtype.textAlignment = NSTextAlignmentRight;
        [self addSubview:_cardtype];
        _cardtype.sd_layout.rightSpaceToView(self,15).topEqualToView(_consumover).heightIs(15).widthIs(70);
        
        
    }
    
    
    return self;
}
-(void)setModel:(MyticketModel*)model
{
    _model = model;
    _cardtitle.text = _model.namestr;
    _typest = _model.typestr;
    
    
    if ([_typest isEqualToString:@"0"])
    {
        _cardtitle.textColor = UIColorFromRGB(0xfd7577);
        _discout.textColor = UIColorFromRGB(0xfd7577);
        _consumover.textColor = UIColorFromRGB(0x696969);
        _begintime.textColor = UIColorFromRGB(0x727272);
        _cardtype.textColor = UIColorFromRGB(0x000000);
        _cardtype.text = @"马上使用";
    }
    
    if ([_typest isEqualToString:@"2"]||[_typest isEqualToString:@"1"]) {
        
        _cardtitle.textColor = UIColorFromRGB(0xa6a6a6);
        _discout.textColor = UIColorFromRGB(0xa6a6a6);
        _consumover.textColor = UIColorFromRGB(0xa6a6a6);
        _begintime.textColor = UIColorFromRGB(0xa6a6a6);
        _cardtype.textColor = UIColorFromRGB(0xa6a6a6);
        _cardtype.text = @"已失效";
    }
    if ([_model.cardtype isEqualToString:@"1"]) {
        
        _discout.text = [NSString stringWithFormat:@"%.1f折",[_model.discount floatValue]*10];
        
    }
    if ([_model.cardtype isEqualToString:@"0"]) {
        
        _discout.text = [NSString stringWithFormat:@"%@元",_model.discount];
    }
    
    _consumover.text = [NSString stringWithFormat:@"消费满%@元可使用此券",_model.consumover];
    _begintime.text = [NSString stringWithFormat:@"%@至%@",_model.begintime,_model.endtime];
    
    
    
}


-(void)layoutSubviews{
    [super layoutSubviews];
    self.layer.shadowColor = [UIColor blackColor].CGColor;
    self.layer.shadowOpacity = 1.75f;
    self.layer.shadowRadius = 4.0;
    self.layer.shouldRasterize = YES;
    self.layer.rasterizationScale = [UIScreen mainScreen].scale;
    CGPathRef path = [UIBezierPath bezierPathWithRect:CGRectMake(0, self.bounds.size.height, [UIScreen mainScreen].bounds.size.width,2)].CGPath;
    [self.layer setShadowPath:path];
    
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
