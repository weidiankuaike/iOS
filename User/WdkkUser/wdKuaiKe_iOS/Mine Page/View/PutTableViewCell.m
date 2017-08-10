//
//  PutTableViewCell.m
//  wdKuaiKe_iOS
//
//  Created by 张森森 on 16/9/18.
//  Copyright © 2016年 weiDianKuaiKe. All rights reserved.
//

#import "PutTableViewCell.h"

@implementation PutTableViewCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        _headimage = [[UIImageView alloc]init];
        _headimage.image = [UIImage imageNamed:@"example"];
        [self addSubview:self.headimage];
        _headimage.sd_layout.leftSpaceToView(self,autoScaleW(15)).topSpaceToView(self,autoScaleH(10)).widthIs(autoScaleW(66)).heightIs(autoScaleH(66));
        
        _namelabel = [[UILabel alloc]init];
        _namelabel.font = [UIFont systemFontOfSize:autoScaleW(12)];
        CGSize size = [_namelabel.text sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:_namelabel.font,NSFontAttributeName, nil]];
        CGFloat wind = size.width;
        [self addSubview:self.namelabel];
        _namelabel.sd_layout.leftSpaceToView(_headimage,autoScaleW(12)).topSpaceToView(self,autoScaleH(10)).widthIs(autoScaleW(200)).heightIs(autoScaleH(12));
        _xqlabel = [[UILabel alloc]init];
        
        _xqlabel.font = [UIFont systemFontOfSize:autoScaleW(10)];
        _xqlabel.textColor = RGB(181, 181, 181);
        _xqlabel.textAlignment = NSTextAlignmentLeft;
        [self addSubview:self.xqlabel];
        _xqlabel.sd_layout.leftSpaceToView(_headimage,autoScaleW(15)).topSpaceToView(_namelabel,autoScaleH(20)).widthIs(autoScaleW(200)).heightIs(autoScaleH(22));
        
        _number = [[UILabel alloc]init];
        _number.font = [UIFont systemFontOfSize:autoScaleW(9)];
        _number.textAlignment = NSTextAlignmentRight;
        _number.textColor = RGB(181, 181, 181);
        [self addSubview:self.number];
        _number.sd_layout.rightSpaceToView(self,autoScaleW(8)).bottomSpaceToView(self,autoScaleH(15)).widthIs(autoScaleW(26)).heightIs(autoScaleH(10));
        
        _xximage = [[UIImageView alloc]init];
        _xximage.image = [UIImage imageNamed:@"evaluate"];
        [self addSubview:self.xximage];
        _xximage.sd_layout.rightSpaceToView(_number,autoScaleW(2)).bottomSpaceToView(self,autoScaleH(15)).widthIs(autoScaleW(14)).heightIs(autoScaleH(12));
        


        
        
    }
    
    
    
    return self;
}
-(void)layoutSubviews{
    [super layoutSubviews];
    self.layer.shadowColor = [UIColor blackColor].CGColor;
    self.layer.shadowOpacity = 0.75f;
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
