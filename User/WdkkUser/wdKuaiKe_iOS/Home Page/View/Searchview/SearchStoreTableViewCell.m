//
//  SearchStoreTableViewCell.m
//  wdKuaiKe_iOS
//
//  Created by 张森森 on 17/1/19.
//  Copyright © 2017年 weiDianKuaiKe. All rights reserved.
//

#import "SearchStoreTableViewCell.h"

@implementation SearchStoreTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        _headimage = [[UIImageView alloc]init];
        [self addSubview:_headimage];
        _headimage.sd_layout.leftSpaceToView(self,autoScaleW(15)).topSpaceToView(self,autoScaleH(7)).widthIs(30).heightIs(30);
        _namelabel = [[UILabel alloc]init];
        _namelabel.font = [UIFont systemFontOfSize:13];
        _namelabel.textColor = [UIColor blackColor];
        [self addSubview:_namelabel];
        _namelabel.sd_layout.leftSpaceToView(_headimage,autoScaleW(15)).topSpaceToView(self,15).heightIs(15);
        [_namelabel setSingleLineAutoResizeWithMaxWidth:200];
        
        UILabel * linelabel = [[UILabel alloc]init];
        linelabel.backgroundColor = UIColorFromRGB(0xeeeeee);
        [self addSubview:linelabel];
        linelabel.sd_layout.leftEqualToView(self).rightEqualToView(self).bottomEqualToView(self).heightIs(1);
        
    }
    
    return self;
}
- (void)setModel:(SearchStoreModel *)model
{
    _model = model;
    [_headimage sd_setImageWithURL:[NSURL URLWithString:_model.storeImage]placeholderImage:[UIImage imageNamed:@"1"]];
    _namelabel.text = _model.storeName;
    
    
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
