//
//  QueueAddNumView.m
//  微点筷客商户端
//
//  Created by Skyer God on 2017/7/3.
//  Copyright © 2017年 张甜. All rights reserved.
//

#import "QueueAddNumView.h"
#import "UIView+DrawLayer.h"
@interface QueueAddNumView ()
@property (strong, nonatomic) IBOutlet UILabel *titleLabeel;



@end
@implementation QueueAddNumView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
-(void)awakeFromNib{
    [super awakeFromNib];
    self.bounds = [UIScreen mainScreen].bounds;

    self.backView.sd_layout
    .topSpaceToView(self, pxSizeH(365))
    .bottomSpaceToView(self, pxSizeH(382))
    .leftSpaceToView(self, pxSizeW(53))
    .rightSpaceToView(self, pxSizeW(53));
    [_backView setSd_cornerRadiusFromHeightRatio:@(0.02)];
    _titleLabeel.sd_layout
    .topSpaceToView(_backView, pxSizeW(37))
    .centerXEqualToView(_backView);

    _cancelButton.sd_layout
    .topSpaceToView(_backView, pxSizeH(20))
    .rightSpaceToView(_backView, pxSizeW(22))
    .widthIs(pxSizeW(30))
    .heightEqualToWidth();
    //虚线
    UILabel *separtorLine = [[UILabel alloc] init];
    [_backView addSubview:separtorLine];

    separtorLine.sd_layout
    .topSpaceToView(_backView, pxSizeH(106))
    .leftSpaceToView(_backView, pxSizeW(45))
    .widthIs(pxSizeW(550))
    .heightIs(1);
    [separtorLine updateLayout];
    [separtorLine drawDashLine:separtorLine lineLength:4 lineSpacing:2.5 lineColor:UIColorFromRGB(0xbfbfbf)];

    //下面两个按钮
    _justQueueBT.sd_layout
    .leftSpaceToView(_backView, pxSizeW(45))
    .bottomSpaceToView(_backView, pxSizeH(63))
    .widthIs(pxSizeW(250))
    .heightIs(pxSizeW(72));
    _justQueueBT.contentMode = UIControlContentHorizontalAlignmentCenter;


    _printBT.sd_layout
    .bottomEqualToView(_justQueueBT)
    .rightSpaceToView(_backView, pxSizeW(45))
    .widthRatioToView(_justQueueBT, 1)
    .heightRatioToView(_justQueueBT, 1);
    _printBT.contentMode = UIControlContentHorizontalAlignmentCenter;


    [_selectArr enumerateObjectsUsingBlock:^(ButtonStyle *button, NSUInteger idx, BOOL * _Nonnull stop) {
        button.sd_layout
        .leftSpaceToView(_backView, pxSizeW(70) + idx * (pxSizeW(54) + pxSizeW(125)))
        .bottomSpaceToView(_justQueueBT, pxSizeH(49))//69
        .widthIs(pxSizeW(125))
        .heightIs(pxSizeH(40));
    }];

    _phoneTextF.sd_layout
    .leftSpaceToView(_backView, pxSizeW(45))
    .rightSpaceToView(_backView, pxSizeW(45))
    .centerYEqualToView(_backView)
    .heightIs(pxSizeH(60));

    _nameTextField.sd_layout
    .bottomSpaceToView(_phoneTextF, pxSizeH(30))
    .leftEqualToView(_phoneTextF)
    .heightRatioToView(_phoneTextF, 1)
    .widthIs(pxSizeW(268));

    _manBT.sd_layout
    .leftSpaceToView(_nameTextField, pxSizeW(33))
    .centerYEqualToView(_nameTextField)
    .widthIs(pxSizeW(125))
    .heightIs(pxSizeH(40));

    _womenBT.sd_layout
    .leftSpaceToView(_manBT, pxSizeW(28))
    .centerYEqualToView(_manBT)
    .widthRatioToView(_manBT, 1)
    .heightRatioToView(_manBT, 1);
}
- (IBAction)cancelButtonClick {
    self.hidden = YES;
}

- (IBAction)manClick:(ButtonStyle *)sender {
    UIImage *selectImage = [UIImage imageNamed:@"queue_circle"];
    UIImage *unSelect = [UIImage imageNamed:@"椭圆-2"];
    if ([sender isEqual:_manBT]) {
        [_manBT setImage:selectImage forState:UIControlStateNormal];
        [_womenBT setImage:unSelect forState:UIControlStateNormal];
    } else {
        [_manBT setImage:unSelect forState:UIControlStateNormal];
        [_womenBT setImage:selectImage forState:UIControlStateNormal];
    }

}
- (IBAction)categoryClick:(ButtonStyle *)sender {
    UIImage *selectImage = [UIImage imageNamed:@"queue_circle"];
    UIImage *unSelect = [UIImage imageNamed:@"椭圆-2"];

    for (ButtonStyle *button in _selectArr) {
        if ([sender isEqual:button]) {
            [button setImage:selectImage forState:UIControlStateNormal];
        } else {
            [button setImage:unSelect forState:UIControlStateNormal];
        }
    }

}

@end
