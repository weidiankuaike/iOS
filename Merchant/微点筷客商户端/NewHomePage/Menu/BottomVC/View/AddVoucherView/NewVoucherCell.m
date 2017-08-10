//
//  NewVoucherCell.m
//  微点筷客商户端
//
//  Created by Skyer God on 16/12/1.
//  Copyright © 2016年 张森森. All rights reserved.
//

#import "NewVoucherCell.h"

@implementation NewVoucherCell{
    UIView *contentView;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier ];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self create];
    }
    return self;
}

- (void)create{

    contentView =  self.contentView;
//    [self.contentView addSubview:contentView];
    contentView.sd_layout.spaceToSuperView(UIEdgeInsetsMake(0, 0, 0, 0));
    contentView.sd_cornerRadiusFromHeightRatio = @(0.1);
    contentView.layer.borderColor = [UIColorFromRGB(0xffc369) colorWithAlphaComponent:0.5].CGColor;
    contentView.layer.borderWidth = 0.7;

    _categoryLabel = [[UILabel alloc] init];
    _categoryLabel.text = @"category";
    _categoryLabel.textColor = [UIColor whiteColor];
    _categoryLabel.font = [UIFont systemFontOfSize:12];
    [contentView addSubview:_categoryLabel];

    _limitTimeLabel = [[UILabel alloc] init];
    _limitTimeLabel.text = @"time";
    _limitTimeLabel.textColor = _categoryLabel.textColor;
    _limitTimeLabel.font = _categoryLabel.font;
    [contentView addSubview:_limitTimeLabel];

    _discountLabel = [[UILabel alloc] init];
    _discountLabel.text = @"category";
    _discountLabel.textColor = _categoryLabel.textColor;
    _discountLabel.font = [UIFont systemFontOfSize:20 weight:10];
    [contentView addSubview:_discountLabel];

    _allocationLabel = [[UILabel alloc] init];
    _allocationLabel.text = @"allocation";
    _allocationLabel.textColor = _categoryLabel.textColor;
    _allocationLabel.font = _categoryLabel.font;
    [contentView addSubview:_allocationLabel];

    _conditionLabel = [[UILabel alloc] init];
    _conditionLabel.text = @"condition";
    _conditionLabel.textColor = _categoryLabel.textColor;
    _conditionLabel.font = _categoryLabel.font;
    [contentView addSubview:_conditionLabel];


    CGFloat start_x = 7;



    //cell 子视图 frme
    _categoryLabel.sd_layout
    .leftSpaceToView(contentView, start_x)
    .topSpaceToView(contentView, 10)
    .heightIs(20);
    [_categoryLabel setSingleLineAutoResizeWithMaxWidth:100];

    _limitTimeLabel.sd_layout
    .topEqualToView(_categoryLabel)
    .rightSpaceToView(contentView, start_x)
    .heightIs(20);
    [_limitTimeLabel setSingleLineAutoResizeWithMaxWidth:200];

    _discountLabel.sd_layout
    .topSpaceToView(_categoryLabel, 20)
    .leftEqualToView(_categoryLabel)
    .heightIs(40);
    [_discountLabel setSingleLineAutoResizeWithMaxWidth:100];

    _allocationLabel.sd_layout
    .topEqualToView(_discountLabel)
    .rightEqualToView(_limitTimeLabel)
    .heightIs(20);
    [_allocationLabel setSingleLineAutoResizeWithMaxWidth:200];

    _conditionLabel.sd_layout
    .topSpaceToView(_allocationLabel, 0)
    .rightEqualToView(_allocationLabel)
    .heightIs(20);
    [_conditionLabel setSingleLineAutoResizeWithMaxWidth:200];

    [contentView setupAutoHeightWithBottomView:_discountLabel bottomMargin:0];
    [self setupAutoHeightWithBottomViewsArray:@[contentView, _discountLabel] bottomMargin:0];




}
- (void)setModel:(VoucherViewMedel *)model{
    _model = model;


    if ([_model.type isEqualToString:@"0"]) {
        //有效
        contentView.backgroundColor = UIColorFromRGB(0xffc369);
    } else if ([_model.type isEqualToString:@"1"]) {
        contentView.backgroundColor = UIColorFromRGB(0xffe2b6);
    } else {
        contentView.backgroundColor = UIColorFromRGB(0xdcdcdc);
    }

    if ([model.cardType integerValue] == 0) {
        _categoryLabel.text =  @"代金券";
        _discountLabel.text = [NSString stringWithFormat:@"%@元", model.discountedPrice];
    } else {
        _categoryLabel.text = @"折扣券";
        _discountLabel.text = [NSString stringWithFormat:@"%.1lf折", [model.discount doubleValue] * 10];
    }
    NSString *beginTime = [self timeWithTimeIntervalString:model.beginTime];
    NSString *endTime = [self timeWithTimeIntervalString:model.endTime];
    _limitTimeLabel.text = [NSString stringWithFormat:@"%@ 至 %@", beginTime, endTime];



    if ([model.issuingOpportunity integerValue] == 0) {
        _allocationLabel.text = [NSString stringWithFormat:@"消费满额%@元发放", model.consumptionOver];
    } else if ([model.issuingOpportunity integerValue] == 1) {
        _allocationLabel.text = @"新用户进店";
    } else {
        _allocationLabel.text = @"订单取消";
    }
    _conditionLabel.text = [NSString stringWithFormat:@"满%@元可使用", model.conditions];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
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
- (NSString *)timeWithTimeIntervalString:(NSString *)timeString
{
    // 格式化时间
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    formatter.timeZone = [NSTimeZone timeZoneWithName:@"beijing"];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"yyyy-MM-dd"];

    // 毫秒值转化为秒
    NSDate* date = [NSDate dateWithTimeIntervalSince1970:[timeString doubleValue]/ 1000.0];
    NSString* dateString = [formatter stringFromDate:date];
    return dateString;
}
@end
