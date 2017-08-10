//
//  SunmitTableViewCell.m
//  wdKuaiKe_iOS
//
//  Created by 张森森 on 17/1/16.
//  Copyright © 2017年 weiDianKuaiKe. All rights reserved.
//

#import "SunmitTableViewCell.h"

@implementation SunmitTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        _headimage = [[UIImageView alloc]init];
        [self addSubview:_headimage];
        _headimage.sd_layout.leftSpaceToView(self,autoScaleW(15)).topSpaceToView(self,autoScaleH(10)).widthIs(autoScaleW(30)).heightIs(autoScaleW(30));
        
        _namelabel = [[UILabel alloc]init];
        _namelabel.textColor = [UIColor blackColor];
        _namelabel.font = [UIFont systemFontOfSize:autoScaleW(13)];
        [self addSubview:_namelabel];
        _namelabel.sd_layout.leftSpaceToView(_headimage,autoScaleW(15)).centerYEqualToView(self).heightIs(autoScaleH(15)).widthIs(autoScaleW(130));
        
        _moneylabel = [[UILabel alloc]init];
        _moneylabel.font = [UIFont boldSystemFontOfSize:autoScaleW(13)];
        _moneylabel.textColor = UIColorFromRGB(0xfd7577);
        [self addSubview:_moneylabel];
        _moneylabel.sd_layout.leftSpaceToView(_namelabel,autoScaleW(15)).topEqualToView(_namelabel).widthIs(autoScaleW(100)).heightIs(autoScaleH(15));
        
        _addBT = [UIButton buttonWithType:UIButtonTypeCustom];
        [_addBT setBackgroundImage:[UIImage imageNamed:@"加号"] forState:UIControlStateNormal];
        [self.contentView addSubview:_addBT];
        
        
        self.numLabel = [[UILabel alloc] init];
        self.numLabel.textColor = [UIColor blackColor];
        self.numLabel.font = [UIFont systemFontOfSize:14];
        self.numLabel.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:_numLabel];
        
        
        self.subtractBT = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.subtractBT setBackgroundImage:[UIImage imageNamed:@"减号"] forState:UIControlStateNormal];
        [self.contentView addSubview:_subtractBT];
        
        
        
        [self.addBT addTarget:self action:@selector(clickAddBT:) forControlEvents:UIControlEventTouchUpInside];
        [self.subtractBT addTarget:self action:@selector(clickSubBT:) forControlEvents:UIControlEventTouchUpInside];

        CGFloat buttonWidth = 25;
        CGFloat right_space = 15;
        
        
        self.addBT.sd_layout.centerYEqualToView(self.contentView ) .widthIs(buttonWidth).heightIs(buttonWidth).rightSpaceToView(self.contentView, 15);
        
        self.numLabel.sd_layout
        .rightSpaceToView(_addBT, 3)
        .topEqualToView(_addBT)
        .heightIs(buttonWidth);
        [self.numLabel setSingleLineAutoResizeWithMaxWidth:40];
        
        self.subtractBT.sd_layout
        .rightSpaceToView(_numLabel, 3)
        .topEqualToView(_numLabel)
        .heightIs(buttonWidth)
        .widthIs(buttonWidth);
        
    }
    
    return self;
}
- (void)clickAddBT:(UIButton *)sender{
    
    self.number = [self.numLabel.text intValue];
    self.number += 1;
    NSMutableDictionary * dict = [NSMutableDictionary dictionary];
    [dict setObject:self.namelabel.text forKey:@"name"];
    NSString *feestr = [self.moneylabel.text substringFromIndex:1];
    [dict setObject:feestr forKey:@"fee"];
    //    NSString * indexstr = [NSString stringWithFormat:@"%ld",sender.tag-300];
    [dict setObject:_indexstr forKey:@"index"];
    [dict setObject:_idstr forKey:@"id"];
    [dict setObject:[NSString stringWithFormat:@"%ld",self.number] forKey:@"number"];
    
    
    self.plusBlock(dict, YES);
    [self showOrderNumbers:self.number];
    
    
}
- (void)clickSubBT:(UIButton *)sender{
    
    self.number = [self.numLabel.text intValue];
    self.number -=1;
    NSMutableDictionary * dict = [NSMutableDictionary dictionary];
    [dict setObject:self.namelabel.text forKey:@"name"];
    NSString *feestr = [self.moneylabel.text substringFromIndex:1];
    [dict setObject:feestr forKey:@"fee"];
    //    NSString * indexstr = [NSString stringWithFormat:@"%ld",sender.tag-500];
    [dict setObject:_indexstr forKey:@"index"];
    [dict setObject:_idstr forKey:@"id"];

    [dict setObject:[NSString stringWithFormat:@"%ld",self.number] forKey:@"number"];
    self.plusBlock(dict, NO);
    [self showOrderNumbers:self.number];
}

-(void)showOrderNumbers:(NSUInteger)count
{
    self.numLabel.text = [NSString stringWithFormat:@"%lu",(unsigned long)self.number];
    if (self.number > 0)
    {
        [self.subtractBT setHidden:NO];
        [self.numLabel setHidden:NO];
        
        
    }
    else
    {
        [self.subtractBT setHidden:YES];
        [self.numLabel setHidden:YES];
    }
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
