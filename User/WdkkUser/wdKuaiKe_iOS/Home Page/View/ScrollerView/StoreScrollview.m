//
//  StoreScrollview.m
//  wdKuaiKe_iOS
//
//  Created by 张森森 on 17/1/10.
//  Copyright © 2017年 weiDianKuaiKe. All rights reserved.
//

#import "StoreScrollview.h"

@implementation StoreScrollview

- (instancetype)initWithary:(NSArray*)imageary
{
    self = [super init];
    if (self)
    {
        _imageary = imageary;
        [self Creatstorescrolleview];
        
    }
    
    return self;
}

- (void)Creatstorescrolleview
{
    
    for (int i=0; i<_imageary.count; i++) {
        
        UIButton * imagebtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [imagebtn setImage:[UIImage imageNamed:_imageary[i]] forState:UIControlStateNormal];
        imagebtn.layer.masksToBounds = YES;
        imagebtn.layer.cornerRadius = 5;
        [self addSubview:imagebtn];
        imagebtn.sd_layout.leftSpaceToView(self,autoScaleW(10)+i*((GetWidth - autoScaleW(40))/2 + autoScaleW(20))).topSpaceToView(self,autoScaleH(10)).widthIs((GetWidth - autoScaleW(40))/2).heightIs(autoScaleH(90));
        
        
    }
    
    
    
    
    
}



@end
