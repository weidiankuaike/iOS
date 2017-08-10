//
//  AnimationLabel.h
//  wdKuaiKe_iOS
//
//  Created by 张森森 on 2017/7/6.
//  Copyright © 2017年 weiDianKuaiKe. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AnimationLabel : UIView

@property (nonatomic,copy)NSString * text;
@property (nonatomic,strong)UILabel * scrollLabel;
@property (nonatomic,strong)UILabel * secondLabel;
@property (nonatomic,strong)UIImageView * backgrounImage;
- (id)initWithFrame:(CGRect)frame text:(NSString*)text image:(UIImageView*)bacImage;


@end
