//
//  MymoneyTableViewCell.m
//  wdKuaiKe_iOS
//
//  Created by 张森森 on 16/8/23.
//  Copyright © 2016年 weiDianKuaiKe. All rights reserved.
//

#import "MymoneyTableViewCell.h"

@implementation MymoneyTableViewCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.xiaoflabel = [[UILabel alloc]init];
        self.xiaoflabel.font = [UIFont systemFontOfSize:autoScaleW(15)];
        self.xiaoflabel.textColor = UIColorFromRGB(0x717171);
        [self addSubview:self.xiaoflabel];
        self.xiaoflabel.sd_layout.leftSpaceToView(self,autoScaleW(15)).topSpaceToView(self,autoScaleH(15)).heightIs(autoScaleH(15)).widthIs(autoScaleW(110));
        
        self.yuelabel = [[UILabel alloc]init];
        self.yuelabel.font = [UIFont systemFontOfSize:11];
        self.yuelabel.textColor = UIColorFromRGB(0x989898);
        [self addSubview:self.yuelabel];
        self.yuelabel.sd_layout.leftSpaceToView(self,autoScaleW(15)).topSpaceToView(self.xiaoflabel,autoScaleH(8)).heightIs(autoScaleH(12)).widthIs(autoScaleW(96));
        
        self.timelabel = [[UILabel alloc]init];
        self.timelabel.font = [UIFont systemFontOfSize:autoScaleW(9)];
        self.timelabel.textColor = UIColorFromRGB(0x989898);
        self.timelabel.textAlignment = NSTextAlignmentRight;
        [self addSubview:self.timelabel];
        self.timelabel.sd_layout.rightSpaceToView(self,autoScaleW(15)).topSpaceToView(self,autoScaleH(15)).widthIs(autoScaleW(62)).heightIs(autoScaleH(11));
        
        self.jiagelabel = [[UILabel alloc]init];
        self.jiagelabel.font = [UIFont systemFontOfSize:autoScaleW(10)];
        self.jiagelabel.textColor = UIColorFromRGB(0xe77e23);
        self.jiagelabel.textAlignment = NSTextAlignmentRight;
        [self addSubview:self.jiagelabel];
        
        self.jiagelabel.sd_layout.rightSpaceToView(self,autoScaleW(15)).topSpaceToView(self.timelabel,15).heightIs(10).widthIs(60);
        
        
        
        
        
        
        
        
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
