//
//  LoginTableViewCell.m
//  微点筷客商户版
//
//  Created by 张森森 on 16/9/30.
//  Copyright © 2016年 张森森. All rights reserved.
//

#import "LoginTableViewCell.h"

@implementation LoginTableViewCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        _leftlabel = [[UILabel alloc]init];
        _leftlabel.font = [UIFont systemFontOfSize:13];
        _leftlabel.textAlignment = NSTextAlignmentLeft;
        [self addSubview:self.leftlabel];
        self.leftlabel.sd_layout.leftSpaceToView(self,autoScaleW(15)).topSpaceToView(self,autoScaleH(15)).widthIs(autoScaleW(120)).heightIs(autoScaleH(15));
        
        _textfild =[[UITextField alloc]init];
        _textfild.font = [UIFont systemFontOfSize:13];
        [self addSubview:self.textfild];
        self.textfild.sd_layout.leftSpaceToView(self.leftlabel,0).topSpaceToView(self,0).widthIs(autoScaleW(200)).heightIs(autoScaleH(45));
        
        _rightlabel = [[UILabel alloc]init];
        _rightlabel.font = [UIFont systemFontOfSize:13];
        _rightlabel.textAlignment = NSTextAlignmentLeft;
        [self addSubview:_rightlabel];
        _rightlabel.sd_layout.rightSpaceToView(self,autoScaleW(15)).topSpaceToView(self,autoScaleH(15)).widthIs(autoScaleW(120)).heightIs(autoScaleH(15));
        
    }
    
    
    
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
