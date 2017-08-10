//
//  QueueStatusSetVC.m
//  微点筷客商户端
//
//  Created by Skyer God on 2017/7/5.
//  Copyright © 2017年 张甜. All rights reserved.
//

#import "QueueStatusSetVC.h"

@interface QueueStatusSetVC ()
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *statusArr;
@property (strong, nonatomic) IBOutlet UIView *separatorLine;
@property (strong, nonatomic) IBOutlet UILabel *distanceLabel;
@property (strong, nonatomic) IBOutlet UILabel *numberLabel;
@property (strong, nonatomic) IBOutlet UITextField *inputTextF;
@property (strong, nonatomic) IBOutlet ButtonStyle *submitBT;
@property (strong, nonatomic) IBOutlet UILabel *noticeLabel;
@property (strong, nonatomic) IBOutlet UILabel *unitLabel;


@end

@implementation QueueStatusSetVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.titleView.text = @"排号设置";
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self layountSubViews];
}
-(void)layountSubViews{
    [_statusArr enumerateObjectsUsingBlock:^(ButtonStyle *button, NSUInteger idx, BOOL * _Nonnull stop) {
        [button setTitleColor:UIColorFromRGB(0x737373) forState:UIControlStateNormal];
        button.sd_layout
        .leftSpaceToView(self.view, pxSizeW(32) + idx * (pxSizeW(136) + pxSizeW(146)))
        .topSpaceToView(self.view, pxSizeH(44) + 64)
        .widthIs(pxSizeW(136))
        .heightIs(pxSizeW(136));
    }];

    _separatorLine.sd_layout
    .topSpaceToView(self.view, 64 + pxSizeH(210))
    .leftSpaceToView(self.view, pxSizeW(20))
    .rightSpaceToView(self.view, pxSizeW(20))
    .heightIs(1);

    _distanceLabel.sd_layout
    .leftSpaceToView(self.view, pxSizeW(34))
    .topSpaceToView(_separatorLine, pxSizeH(40))
    .heightIs(pxSizeH(32));
    [_distanceLabel setSingleLineAutoResizeWithMaxWidth:autoScaleW(120)];

    _numberLabel.sd_layout
    .leftSpaceToView(_distanceLabel, 1)
    .centerYEqualToView(_distanceLabel)
    .heightRatioToView(_distanceLabel, 1);
    [_numberLabel setSingleLineAutoResizeWithMaxWidth:autoScaleW(50)];

    _inputTextF.sd_layout
    .leftEqualToView(_distanceLabel)
    .rightSpaceToView(self.view, pxSizeW(102))
    .topSpaceToView(_distanceLabel, pxSizeH(14))
    .heightIs(pxSizeH(70));

    _unitLabel.sd_layout
    .leftSpaceToView(_inputTextF, pxSizeW(24))
    .centerYEqualToView(_inputTextF)
    .heightIs(pxSizeH(35));
    [_unitLabel setSingleLineAutoResizeWithMaxWidth:70];

    _submitBT.sd_layout
    .centerXEqualToView(self.view)
    .topSpaceToView(_inputTextF, pxSizeH(82))
    .widthIs(pxSizeW(689))
    .heightIs(pxSizeH(77));
    [_submitBT setBackgroundColor:UIColorFromRGB(0xf97178)];
    [_submitBT setSd_cornerRadiusFromHeightRatio:@(0.1)];

    _noticeLabel.sd_layout
    .topSpaceToView(_submitBT, pxSizeH(67))
    .centerXEqualToView(self.view)
    .widthIs(pxSizeW(689))
    .heightIs(pxSizeH(140));

    //添加阴影效果
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.colors = @[(__bridge id)RGB(225, 225, 225).CGColor, (__bridge id)UIColorFromRGB(0xf6f6f6).CGColor, (__bridge id)[UIColor whiteColor].CGColor];
    gradientLayer.locations = @[@0, @0.4, @1.0];
    gradientLayer.startPoint = CGPointMake(0, 0);
    gradientLayer.endPoint = CGPointMake(0, 1.0);
    gradientLayer.frame = CGRectMake(0, pxSizeH(398) + 64, kScreenWidth, pxSizeH(22));
    [self.view.layer insertSublayer:gradientLayer atIndex:0];

}
- (IBAction)statusButtonArr:(ButtonStyle *)sender {
    [_statusArr enumerateObjectsUsingBlock:^(ButtonStyle *button, NSUInteger idx, BOOL * _Nonnull stop) {
        UIImage *selectImage = [UIImage imageNamed:@"queue_buttonBackImage"];
        UIImage *unImage = [UIImage imageNamed:@"queue_buttonBackImage_un"];
        if (button == sender) {
            [button setBackgroundImage:selectImage forState:UIControlStateNormal];
            [button setTitleColor:UIColorFromRGB(0xf97178) forState:UIControlStateNormal];
        } else {
            [button setBackgroundImage:unImage forState:UIControlStateNormal];
            [button setTitleColor:UIColorFromRGB(0x737373) forState:UIControlStateNormal];
        }
    }];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
