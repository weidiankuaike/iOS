//
//  QueueNumberCell.m
//  微点筷客商户端
//
//  Created by Skyer God on 2017/7/3.
//  Copyright © 2017年 张甜. All rights reserved.
//

#import "QueueNumberCell.h"
#import "UIImage+Tint.h"
@interface QueueNumberCell()

@property (strong, nonatomic) IBOutlet UILabel *verticalLine;

@end
static NSInteger _status;
@implementation QueueNumberCell
+(void)cellStatus:(NSInteger)status{
    _status = status;
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code


    self.queueNumLabel.sd_layout
    .leftSpaceToView(self.contentView, pxSizeW(30))
    .topSpaceToView(self.contentView, pxSizeH(24))
    .heightIs(pxSizeH(40))
    .minWidthIs(pxSizeW(110));


    self.nameLabel.sd_layout
    .centerXEqualToView(self.contentView)
    .topEqualToView(_queueNumLabel)
    .heightRatioToView(_queueNumLabel, 1);
    [_nameLabel setSingleLineAutoResizeWithMaxWidth:100];

    self.timeLabel.sd_layout
    .topEqualToView(_queueNumLabel)
    .rightSpaceToView(self.contentView, pxSizeW(30))
    .heightRatioToView(_queueNumLabel, 1);
    [_timeLabel setSingleLineAutoResizeWithMaxWidth:120];

    self.deskTypeLabel.sd_layout
    .leftEqualToView(_queueNumLabel)
    .topSpaceToView(_queueNumLabel, pxSizeH(22))
    .heightRatioToView(_queueNumLabel, 1);
    [_deskTypeLabel setSingleLineAutoResizeWithMaxWidth:60];

    self.phoneLabel.sd_layout
    .centerXEqualToView(self.contentView)
    .topEqualToView(_deskTypeLabel)
    .heightRatioToView(_deskTypeLabel, 1)
    .minWidthIs(80);

    self.sourceLabel.sd_layout
    .topEqualToView(_deskTypeLabel)
    .rightEqualToView(_timeLabel)
    .heightRatioToView(_deskTypeLabel, 1);
    [_sourceLabel setSingleLineAutoResizeWithMaxWidth:100];


    _verticalLine.sd_layout
    .leftSpaceToView(self.contentView, pxSizeW(210))
    .widthIs(1)
    .heightIs(pxSizeH(87))
    .topSpaceToView(self.contentView, pxSizeH(32));

    for (NSInteger i = 0; i < _selectButtonArr.count; i++) {
        ButtonStyle *button = _selectButtonArr[i];
        if (_status == 0) {
            button.hidden = NO;
        } else {
            button.hidden = YES;
        }
//        button.backgroundColor = [UIColor cyanColor];
//        [button setTintColor:[UIColor redColor]];
        button.sd_layout
        .leftSpaceToView(self.contentView, pxSizeW(36) + i *(pxSizeW(142) + pxSizeW(36)))
        .bottomSpaceToView(self.contentView, pxSizeH(16))
        .widthIs(pxSizeW(142))
        .heightIs(pxSizeH(52));

        CAShapeLayer *borderLayer = [CAShapeLayer layer];
        borderLayer.bounds = CGRectMake(0, 0, button.width_sd, button.height_sd);
        borderLayer.position = CGPointMake(CGRectGetMidX(button.bounds), CGRectGetMidY(button.bounds));
        borderLayer.path = [UIBezierPath bezierPathWithRoundedRect:borderLayer.bounds cornerRadius:0].CGPath;
        borderLayer.lineWidth = 1. / [[UIScreen mainScreen] scale];
        //虚线边框
        borderLayer.lineDashPattern = @[@3, @1.5];
        //实线边框
        //    borderLayer.lineDashPattern = nil;
        borderLayer.fillColor = [UIColor clearColor].CGColor;
        borderLayer.strokeColor = button.titleLabel.textColor.CGColor;
        [button.layer addSublayer:borderLayer];
    }

    if (_status == 1) {
        _queueStatusLB.hidden = NO;
        _historyTimeLB.hidden = NO;
        _verticalLine.hidden = NO;
        _queueStatusLB.font = [UIFont systemFontOfSize:pxFontSize(25)];
        _historyTimeLB.font = _queueStatusLB.font;
        _queueStatusLB.textColor = UIColorFromRGB(0xffb21c);
        _historyTimeLB.textColor = UIColorFromRGB(0xffb21c);

        _queueStatusLB.sd_layout
        .leftEqualToView(_queueNumLabel)
        .bottomSpaceToView(self.contentView, pxSizeH(16))
        .heightIs(pxSizeH(40));
        [_queueStatusLB setSingleLineAutoResizeWithMaxWidth:120];

        _historyTimeLB.sd_layout
        .rightSpaceToView(self.contentView, pxSizeW(30))
        .bottomEqualToView(_queueStatusLB)
        .heightRatioToView(_queueStatusLB, 1);
        [_historyTimeLB setSingleLineAutoResizeWithMaxWidth:120];
    }
}

-(void)drawRect:(CGRect)rect{
    UIImage *image = [UIImage imageNamed:@"queue_cell_backImage"];
    CGRect bound = CGRectMake(pxSizeW(15), 0, rect.size.width - pxSizeH(15 * 2), rect.size.height);
    [image drawInRect:bound blendMode:kCGBlendModeNormal alpha:1.0];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
