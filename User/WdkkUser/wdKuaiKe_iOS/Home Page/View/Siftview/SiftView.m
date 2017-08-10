//
//  SiftView.m
//  wdKuaiKe_iOS
//
//  Created by 张森森 on 17/1/20.
//  Copyright © 2017年 weiDianKuaiKe. All rights reserved.
//

#import "SiftView.h"

@implementation SiftView

-(instancetype)initWithary:(NSArray*)ary
{
    
    self = [super init];
    if (self) {
        
        self.layer.borderColor = [UIColor lightGrayColor].CGColor;
        self.layer.borderWidth = 1;
        [self Creatchoosebtnwithary:ary];
    }
    
    return self;
}
- (void)Creatchoosebtnwithary:(NSArray*)ary
{
    
    for (int i =0; i<ary.count; i++) {
        
        UIButton * choosebtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [choosebtn setTitle:ary[i] forState:UIControlStateNormal];
        [choosebtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        [choosebtn setTitleColor:UIColorFromRGB(0xfd7577) forState:UIControlStateSelected];
        choosebtn.titleLabel.font = [UIFont systemFontOfSize:autoScaleW(15)];
        [choosebtn addTarget:self action:@selector(Choose:) forControlEvents:UIControlEventTouchUpInside];
        choosebtn.backgroundColor = [UIColor whiteColor];
        choosebtn.tag = 500 + i;
//        choosebtn.layer.borderColor = [UIColor lightGrayColor].CGColor;
//        choosebtn.layer.borderWidth = 1;
        [self addSubview:choosebtn];
        choosebtn.sd_layout.leftEqualToView(self).rightEqualToView(self).topSpaceToView(self,i*autoScaleH(35)).heightIs(autoScaleH(35));
        
        UILabel * linelabel = [[UILabel alloc]init];
        linelabel.backgroundColor = [UIColor lightGrayColor];
        [choosebtn addSubview:linelabel];
        linelabel.sd_layout.leftEqualToView(choosebtn).rightEqualToView(choosebtn).bottomEqualToView(choosebtn).heightIs(1);
        
        
    }
    
    
    
    
}
- (void)Choose:(UIButton*)btn
{
    NSLog(@">>>>>%d",btn.tag);
    
    if (self.block) {
        
        self.block(btn.titleLabel.text);
    }
    
}

@end
