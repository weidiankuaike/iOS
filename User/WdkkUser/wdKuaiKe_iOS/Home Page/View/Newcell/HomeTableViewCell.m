//
//  HomeTableViewCell.m
//  wdKuaiKe_iOS
//
//  Created by 张森森 on 17/1/11.
//  Copyright © 2017年 weiDianKuaiKe. All rights reserved.
//

#import "HomeTableViewCell.h"

@implementation HomeTableViewCell

- (UIImageView *)subtractImage{
    
    if (!_subtractImage) {
        _subtractImage = [[UIImageView alloc]init];
        [self.contentView addSubview: _subtractImage];
    }
    
    return _subtractImage;
}
- (UILabel *)subtractLabel{
    
    if (!_subtractLabel) {
        
        _subtractLabel = [[UILabel alloc]init];
        _subtractLabel.textColor = [UIColor blackColor];
        [self.contentView addSubview:_subtractLabel];
        
    }
    return _subtractLabel;
}
- (UIImageView *)discountimage{
    
    if (!_discountimage) {
        _discountimage = [[UIImageView alloc]init];
        
        [self.contentView addSubview:_discountimage];
    }
    return _discountimage;
}
- (UILabel *)discountLabel{
    if (!_discountLabel) {
        _discountLabel = [[UILabel alloc]init];
        _discountLabel.font = [UIFont systemFontOfSize:13];
        _discountLabel.textColor = [UIColor blackColor];
        [self.contentView addSubview:_discountLabel];
    }
    
    return _discountLabel;
}
-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        _headview = [[UIImageView alloc]init];
        [self.contentView addSubview:_headview];
        _headview.sd_layout.leftSpaceToView(self.contentView,autoScaleW(15)).topSpaceToView(self.contentView,autoScaleH(15)).widthIs(70).heightIs(70);
        
        _namelabel = [[UILabel alloc]init];
        _namelabel.font = [UIFont systemFontOfSize:15];
        _namelabel.textColor = UIColorFromRGB(0x000000);
        [self.contentView addSubview:_namelabel];
        _namelabel.sd_layout.leftSpaceToView(_headview,10).topEqualToView(_headview).heightIs(15);
        [_namelabel setSingleLineAutoResizeWithMaxWidth:300];
        
        
//         
//        _introductionlabel = [[UILabel alloc]init];
//        _introductionlabel.font = [UIFont systemFontOfSize:11];
//        _introductionlabel.numberOfLines = 0;
//        _introductionlabel.textColor = UIColorFromRGB(0x838383);
//        [self addSubview:_introductionlabel];
//        _introductionlabel.sd_layout.leftEqualToView(_namelabel).topSpaceToView(_namelabel,5).widthIs(GetWidth-30-_headview.frame.size.width).heightIs(30);
        
        
        
        
        
        _renjunlabel = [[UILabel alloc]init];
        _renjunlabel.text = @"人均";
        _renjunlabel.font = [UIFont systemFontOfSize:13];
        _renjunlabel.textColor = UIColorFromRGB(0x838383);
        [self.contentView addSubview:_renjunlabel];
        _renjunlabel.sd_layout.leftEqualToView(_namelabel).topSpaceToView(_namelabel,35).widthIs(30).heightIs(15);
        
        _moneylabel = [[UILabel alloc]init];
        _moneylabel.font = [UIFont boldSystemFontOfSize:20];
        _moneylabel.textColor = UIColorFromRGB(0xfd7577);
        [self.contentView addSubview:_moneylabel];
        _moneylabel.sd_layout.leftSpaceToView(_renjunlabel,8).topSpaceToView(_namelabel,35).heightIs(20);
        [_moneylabel setSingleLineAutoResizeWithMaxWidth:200];
        
        
        _xslabel = [[UILabel alloc]init];
        _xslabel.font = [UIFont systemFontOfSize:13];
        _xslabel.textColor = UIColorFromRGB(0x838383);
        _xslabel.textAlignment = NSTextAlignmentRight;
        [self.contentView addSubview:_xslabel];
        _xslabel.sd_layout.rightSpaceToView(self.contentView,5).topSpaceToView(self.namelabel,5).heightIs(15);
        [_xslabel setSingleLineAutoResizeWithMaxWidth:100];

        _distancelabel = [[UILabel alloc]init];
        _distancelabel.font = [UIFont systemFontOfSize:13];
        _distancelabel.textColor = UIColorFromRGB(0x838383);
        _distancelabel.textAlignment = NSTextAlignmentRight;
        [self.contentView addSubview:_distancelabel];
        _distancelabel.sd_layout.rightSpaceToView(self.contentView,5).topEqualToView(_moneylabel).heightIs(15);
        [_distancelabel setSingleLineAutoResizeWithMaxWidth:100];
        
        
        
    }
    
    return self;
}
-(void)setModel:(SearchStoreModel *)model
{
    
    _model = model;
    
    [_headview sd_setImageWithURL:[NSURL URLWithString:_model.storeImage] placeholderImage:[UIImage imageNamed:@"店铺占位图"]];
    _namelabel.text = _model.storeName;
//    _introductionlabel.text = _model.introduction;
    
    self.xinginteger = _model.avgScore;
    
    if ([_xinginteger rangeOfString:@"."].location!=NSNotFound)
    {
        
        
        float x = [_xinginteger floatValue];
        int v = ceilf(x);
        if ([[_xinginteger substringWithRange:NSMakeRange(2, 1)] integerValue]<=5)
        {
            for (int i=0; i<v; i++) {
                
                UIImageView * xingimage = [[UIImageView alloc]init];
                if (i!=(v-1)) {
                    xingimage.image = [UIImage imageNamed:@"x"];
                }
                else
                {
                    xingimage.image = [UIImage imageNamed:@"半"];
                }
                [self.contentView addSubview:xingimage];
                
                xingimage.sd_layout.leftSpaceToView(_headview,autoScaleW(15)+i*autoScaleW(15)).topSpaceToView(_namelabel,autoScaleH(10)).widthIs(autoScaleW(15)).heightIs(autoScaleH(15));
            }
            
        }
        else
        {
            for (int i=0; i<v; i++) {
                
                UIImageView * xingimage = [[UIImageView alloc]init];
                
                xingimage.image = [UIImage imageNamed:@"x"];
                [self.contentView addSubview:xingimage];
                
                xingimage.sd_layout.leftSpaceToView(_headview,autoScaleW(15)+i*autoScaleW(15)).topSpaceToView(_namelabel,autoScaleH(10)).widthIs(autoScaleW(15)).heightIs(autoScaleH(15));
            }
            
        }
        
        
    }
    else
    {
        
        for (int i=0; i<[_xinginteger integerValue]; i++)
        {
            
            UIImageView * xingimage = [[UIImageView alloc]init];
            xingimage.image = [UIImage imageNamed:@"x"];
            [self.contentView addSubview:xingimage];
            
            xingimage.sd_layout.leftSpaceToView(_headview,autoScaleW(15)+i*autoScaleW(15)).topSpaceToView(_namelabel,autoScaleH(10)).widthIs(autoScaleW(15)).heightIs(autoScaleH(15));
        }
    }

    
    _moneylabel.text = [NSString stringWithFormat:@"￥%@",_model.perCapitaPrice];
    
    float dist = [_model.distance floatValue];
    if (dist>1000) {
        
        _distancelabel.text = [NSString stringWithFormat:@"%.2fkm",dist/1000];
    }
    else
    {
        _distancelabel.text = [NSString stringWithFormat:@"%.2fm",dist];
    }
    
    if ([_model.orderSales isNull]||_model.orderSales==nil) {
        
        _model.orderSales = @"0";
    }
    _xslabel.text = [NSString stringWithFormat:@"已成单%@",_model.orderSales];
    
    [self cardTitle];


}
- (void)cardTitle{
    
    if (_model.activList.count!=0) {
        
        _mjAry = [NSMutableArray array];
        _zkAry = [NSMutableArray array];
        for (NSDictionary * cardDict in _model.activList) {
            
            if ([cardDict[@"cardType"] integerValue]==2) {
                
                NSString * cardStr = [NSString stringWithFormat:@"满%@元减%@元",cardDict[@"consumptionOver"],cardDict[@"discountedPrice"]];
                
                [_mjAry addObject:cardStr];
            }else if ([cardDict[@"cardType"] integerValue]==3){
                
                NSString * discountStr = [NSString stringWithFormat:@"%@",cardDict[@"discount"]];
                double discout = [discountStr doubleValue];
                NSString * disStr = [NSString stringWithFormat:@"%.f",discout];
                NSString * zkStr = [NSString stringWithFormat:@"满%@元打%@折",cardDict[@"consumptionOver"],disStr];
                [_zkAry addObject:zkStr];
            }
            
        }
        
    }
    if (_mjAry.count!=0) {
        self.subtractImage.image = [UIImage imageNamed:@"减"];
        
        self.subtractImage.sd_layout.leftEqualToView(_namelabel).topSpaceToView(_moneylabel,10).widthIs(15).heightIs(15);
        
        NSString * mjstr = [_mjAry componentsJoinedByString:@","];
        self.subtractLabel.text = mjstr;
        self.subtractLabel.font = [UIFont systemFontOfSize:13];
        self.subtractLabel.sd_layout.leftSpaceToView(_subtractImage,5).topEqualToView(_subtractImage).widthIs(GetWidth-15-15-15-5-_headview.width_sd-_distancelabel.width_sd-_subtractImage.width_sd).autoHeightRatio(0);
        
    }
    if (_zkAry.count!=0) {
        
         self.discountimage.image = [UIImage imageNamed:@"折"];
        self.discountimage.sd_layout.leftEqualToView(_namelabel).widthIs(15).heightIs(15);
        if (_mjAry.count!=0) {
            
            self.discountimage.sd_layout.topSpaceToView(self.subtractLabel,5);
        }
        else{
            self.discountimage.sd_layout.topSpaceToView(_moneylabel,10);
        }
        
        NSString * zkstr = [_zkAry componentsJoinedByString:@","];
        self.discountLabel.text = zkstr;
        self.discountLabel.font = [UIFont systemFontOfSize:13];
        self.discountLabel.sd_layout.leftSpaceToView(_discountimage,5).topEqualToView(_discountimage).widthIs(GetWidth-15-15-15-5-_headview.width_sd-_distancelabel.width_sd-_discountimage.width_sd).autoHeightRatio(0);
        [_discountLabel updateLayout];
        
    }
    
    
    [self setupAutoHeightWithBottomViewsArray:@[self.moneylabel,self.distancelabel,self.discountLabel,self.subtractLabel] bottomMargin:20];
    
    
    
}
- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
