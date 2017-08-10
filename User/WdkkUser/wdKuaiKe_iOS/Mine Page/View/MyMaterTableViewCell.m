//
//  MyMaterTableViewCell.m
//  wdKuaiKe_iOS
//
//  Created by 张森森 on 16/9/30.
//  Copyright © 2016年 weiDianKuaiKe. All rights reserved.
//

#import "MyMaterTableViewCell.h"

@implementation MyMaterTableViewCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        
        _titlelabel = [[UILabel alloc]init];
        CGSize size = [_titlelabel.text sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:_titlelabel.font,NSFontAttributeName, nil]];
        CGFloat wind = size.width;
        _titlelabel.font = [UIFont systemFontOfSize:autoScaleW(15)];
        [self addSubview:_titlelabel];
        
      _titlelabel.sd_layout.leftSpaceToView(self,autoScaleW(15)).topSpaceToView(self,autoScaleH(15)).widthIs(autoScaleW(200)).heightIs(autoScaleH(15));
        _rightimage = [[UIImageView alloc]init];
        _rightimage.image = [UIImage imageNamed:@"arrow-1-拷贝"];
        [self addSubview:_rightimage];
        _rightimage.sd_layout.rightSpaceToView(self,autoScaleW(15)).topSpaceToView(self,15).widthIs(10).heightIs(15);
        _rightlabel = [[UILabel alloc]init];
        _rightlabel.font = [UIFont systemFontOfSize:15];
        _rightlabel.textAlignment = NSTextAlignmentRight;
        [self addSubview:_rightlabel];
        _rightlabel.sd_layout.rightSpaceToView(_rightimage,15).topSpaceToView(self,15).widthIs(260).heightIs(15);
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
