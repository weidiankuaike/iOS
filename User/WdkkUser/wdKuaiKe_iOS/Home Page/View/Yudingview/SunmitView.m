//
//  SunmitView.m
//  wdKuaiKe_iOS
//
//  Created by 张森森 on 17/1/16.
//  Copyright © 2017年 weiDianKuaiKe. All rights reserved.
//

#import "SunmitView.h"

@implementation SunmitView

- (id)initWithdict:(NSDictionary*)dcit
{
    self = [super init];
    if (self) {
        
        
        
    }
    
    return self;
}

- (void)Creatviewwithdict:(NSDictionary*)dcit
{
    
    UIImageView * headimage = [[UIImageView alloc]init];
    [headimage sd_setImageWithURL:[NSURL URLWithString:dcit[@"image"]]];
    [self addSubview:headimage];
    headimage.sd_layout.leftSpaceToView(self,autoScaleW(15)).topSpaceToView(self,autoScaleH(10)).widthIs(autoScaleW(30)).heightIs(autoScaleW(30));
    
    UILabel * namelabel = [[UILabel alloc]init];
    namelabel.text = dcit[@"name"];
    namelabel.textColor = [UIColor blackColor];
    namelabel.font = [UIFont systemFontOfSize:autoScaleW(13)];
    [self addSubview:namelabel];
    namelabel.sd_layout.leftSpaceToView(headimage,autoScaleW(15)).topSpaceToView(self,autoScaleH(25)).heightIs(autoScaleH(15)).widthIs(autoScaleW(130));
    
    UILabel * moneylabel = [[UILabel alloc]init];
    moneylabel.text = [NSString stringWithFormat:@"￥%@",dcit[@"money"]];
    moneylabel.font = [UIFont boldSystemFontOfSize:autoScaleW(13)];
    moneylabel.textColor = UIColorFromRGB(0xfd7577);
    [self addSubview:moneylabel];
    moneylabel.sd_layout.leftSpaceToView(namelabel,autoScaleW(15)).topEqualToView(namelabel).widthIs(autoScaleW(100)).heightIs(autoScaleH(15));
    
    
    
    
    
    
    
    
}





@end
