//
//  NewActivityCell.m
//  微点筷客商户端
//
//  Created by Skyer God on 2017/5/22.
//  Copyright © 2017年 张森森. All rights reserved.
//
#define left_space autoScaleW(20)
#import "NewActivityCell.h"
#import "NSString+TimeHandle.h"
#import "UIImage+Tint.h"
static  BOOL isCard;
@implementation NewActivityCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code

    if (isCard) {
        _distributeLabel.hidden = NO;

        _distributeLabel.sd_layout
        .topSpaceToView(self.contentView, autoScaleH(30))
        .leftSpaceToView(_dicountLabel, left_space)
        .rightSpaceToView(self.contentView, 3)
        .heightIs(autoScaleH(25));

        _conditionLabel.sd_layout
        .leftEqualToView(_distributeLabel)
        .topSpaceToView(_distributeLabel, 0)
        .rightEqualToView(_distributeLabel)
        .heightRatioToView(_distributeLabel, 1);

        _timeLabel.sd_layout
        .topSpaceToView(_conditionLabel, 0)
        .leftEqualToView(_conditionLabel)
        .rightEqualToView(_conditionLabel)
        .heightIs(autoScaleH(20));
    } else {
        _distributeLabel.hidden = YES;
        _conditionLabel.sd_layout
        .topSpaceToView(self.contentView, autoScaleH(25))
        .leftSpaceToView(_dicountLabel, left_space)
        .heightIs(autoScaleH(25));
        [_conditionLabel setSingleLineAutoResizeWithMaxWidth:300];

        _timeLabel.sd_layout
        .topSpaceToView(_conditionLabel, 0)
        .leftEqualToView(_conditionLabel)
        .heightIs(autoScaleH(20));
        [_timeLabel setSingleLineAutoResizeWithMaxWidth:200];
    }

    _distributeLabel.font = [UIFont systemFontOfSize:autoScaleW(15)];
    _conditionLabel.font = [UIFont systemFontOfSize:autoScaleW(14)];
    _timeLabel.font = [UIFont systemFontOfSize:autoScaleW(14)];


}
-(void)drawRect:(CGRect)rect{

    UIImage *image = [UIImage imageNamed:@"card_activity"];
    if (_isVoucherCard) {
        image = [UIImage imageNamed:@"card_background"];
    }
    CGRect bound = CGRectMake(0, 0, rect.size.width, rect.size.height);
    [image drawInRect:bound blendMode:kCGBlendModeNormal alpha:1.0];
}
+(void)isVoucherCard:(BOOL)isVoucherCard{
    isCard = isVoucherCard;
}
-(void)setModel:(VoucherViewMedel *)model{

    _model = model;

    if (_isVoucherCard) {
        _distributeLabel.text = [NSString stringWithFormat:@"消费满%@元自动发放此卡券", model.conditions];
    }
    _conditionLabel.text = [NSString stringWithFormat:@"消费满%@元可使用此优惠", model.consumptionOver];
    NSString *beginTime = [model.beginTime getDateTimeFromTimeStrWithOption:TIME_TO_DAY];
    NSString *endTime = [model.endTime getDateTimeFromTimeStrWithOption:TIME_TO_DAY];
    _timeLabel.text = [NSString stringWithFormat:@"%@ 至 %@", beginTime, endTime];
    NSInteger cardType = [model.cardType integerValue];
    NSString *tempStr = nil;
    if (cardType == 2 || cardType == 0) {
        if (cardType == 0) {
            tempStr = [NSString stringWithFormat:@"￥%@\n优惠券",model.discountedPrice];
        } else {
            tempStr = [NSString stringWithFormat:@"￥%@\n立减",model.discountedPrice];
        }
    } else{
        if (cardType == 1) {
            tempStr = [NSString stringWithFormat:@"%@折\n折扣券",model.discount];
        } else {
            tempStr = [NSString stringWithFormat:@"%@折",model.discount];
        }
    }
    NSString *str1 = @"￥";
    NSString *str2 = @"折";
    NSMutableAttributedString *attribute = [[NSMutableAttributedString alloc] initWithString:tempStr];
    if ([tempStr containsString:str1]) {
        [attribute addAttributes:@{NSFontAttributeName: [UIFont boldSystemFontOfSize:autoScaleW(17)]} range:[tempStr rangeOfString:str1]];
        [attribute addAttributes:@{NSBaselineOffsetAttributeName:@1.5} range:[tempStr rangeOfString:str1]];
    } else {
        [attribute addAttributes:@{NSFontAttributeName: [UIFont boldSystemFontOfSize:autoScaleW(17)]} range:[tempStr rangeOfString:str2]];
        [attribute addAttributes:@{NSBaselineOffsetAttributeName:@1.5} range:[tempStr rangeOfString:str2]];
    }
    _dicountLabel.attributedText = attribute;


    if (_isVoucherCard) {
//        [self setupAutoHeightWithBottomViewsArray:@[_timeLabel, _conditionLabel, _dicountLabel] bottomMargin:autoScaleH(25)];
////        [self updateLayout];
        _conditionLabel.sd_layout.centerYEqualToView(self.contentView);
        _distributeLabel.sd_layout.bottomSpaceToView(_conditionLabel, 0);
    } else {
        [self setupAutoHeightWithBottomView:_timeLabel bottomMargin:autoScaleH(37.5)];
    }

}
-(void)layoutSubviews{
    [super layoutSubviews];
    for (UIView *subView in self.subviews){
        if([subView isKindOfClass:NSClassFromString(@"UITableViewCellDeleteConfirmationView")]){
            ButtonStyle * button = (ButtonStyle *)[subView.subviews firstObject];
            //            [button setBackgroundImage:[UIImage imageNamed:@"loadingIcon"] forState:UIControlStateNormal];
            [button setBackgroundColor:[UIColor orangeColor]];

            if ([_model.type isEqualToString:@"0"]) {
                //有效
            } else if ([_model.type isEqualToString:@"1"]) {
                [button setTitle:@"已停用" forState:UIControlStateNormal];
            } else {
                [button setTitle:@"已过期" forState:UIControlStateNormal];
            }
            break;
        }
    }
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
