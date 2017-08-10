//
//  EvaluateDetailListCell.m
//  wdKuaiKe_iOS
//
//  Created by Skyer God on 16/8/8.
//  Copyright © 2016年 weiDianKuaiKe. All rights reserved.
//

#import "EvaluateDetailListCell.h"

@implementation EvaluateDetailListCell
{
    UILabel *bottomSeparator;
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    if (self) {
        [self create];
    }
    return self;
}
- (void)create{
    
    self.userButton= [UIButton buttonWithType:UIButtonTypeCustom];
    [self.userButton setImage:[UIImage imageNamed:@"tian"] forState:UIControlStateNormal];
    [self.userButton setTitle:@"微点筷客" forState:UIControlStateNormal];
    [self.userButton setTitleColor:RGB(48, 48, 48) forState:UIControlStateNormal];

    [self.userButton.titleLabel setFont:[UIFont systemFontOfSize:autoScaleW(9)]];
    
    [self.contentView addSubview:_userButton];
    
    
    self.timeLabel = [[UILabel alloc]init];
    self.timeLabel.text = @"2016-08-08";
    self.timeLabel.textColor = RGB(132, 132, 132);
    self.timeLabel.font = [UIFont systemFontOfSize:autoScaleW(9)];
    self.timeLabel.textAlignment = NSTextAlignmentRight;
    
    [self.contentView addSubview:self.timeLabel];
    
    
    self.detailLabel = [[UILabel alloc]init];
//    self.detailLabel.text = _model.evaluateDetail;
    self.detailLabel.textColor = RGB(132,132,132);
    self.detailLabel.font = [UIFont systemFontOfSize:10];
    self.detailLabel.numberOfLines = 0;
    
    [self.contentView addSubview:self.detailLabel];
    
    
    CGRect rect = [_userButton.titleLabel.text boundingRectWithSize:CGSizeMake(10000, _userButton.titleLabel.size.height) options:NSStringDrawingUsesLineFragmentOrigin attributes:[NSDictionary dictionaryWithObject:[UIFont systemFontOfSize:autoScaleW(9)] forKey:NSFontAttributeName] context:nil];
    
    self.userButton.sd_layout.leftSpaceToView(self.contentView, 19).topSpaceToView(self.contentView, 12).widthIs(28 + rect.size.width + 7).heightIs(28);
    
    [self.userButton setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, rect.size.width)];
    [self.userButton setTitleEdgeInsets:UIEdgeInsetsMake(5, 7, 13, 0)];
    
    self.userButton.imageView.layer.cornerRadius = self.userButton.imageView.frame.size.height / 2;
    
    self.userButton.imageView.clipsToBounds = YES;
    
    
    self.timeLabel.sd_layout
    .topSpaceToView(self.contentView, autoScaleH(18))
    .rightSpaceToView(self.contentView, 14)
    .widthIs([[CalculateStringTool shareManager] getStringWidthWithString:_timeLabel.text fontSize:_timeLabel.font]).heightIs(autoScaleH(8));
    
    
    self.detailLabel.sd_layout
    .leftSpaceToView(self.contentView, 57)
    .topSpaceToView(_userButton, 2)
    .rightSpaceToView(self.contentView, 16)
    .autoHeightRatio(0);
    

    
    bottomSeparator = [[UILabel alloc] init];
    bottomSeparator.backgroundColor = UIColorFromRGB(0xeeeeee);
    [self.contentView addSubview:bottomSeparator];

    bottomSeparator.sd_layout
    .leftEqualToView(self.contentView)
    .topSpaceToView(_detailLabel, autoScaleH(15))
    .rightEqualToView(self.contentView)
    .heightIs(1);



    [self setupAutoHeightWithBottomView:bottomSeparator bottomMargin:0];




    
    
    
    
    
}


-(void)setModel:(MerchantDetailVCModel *)model{

    
    _model = model;
    _detailLabel.text = model.evaluateDetail;

    
  
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
