//
//  MyorderTableViewCell.m
//  微点筷客商户端
//
//  Created by 张森森 on 16/11/2.
//  Copyright © 2016年 张森森. All rights reserved.
//

#import "MyorderTableViewCell.h"

@implementation MyorderTableViewCell{
    UILabel *tagLabel;
}
-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        _headimage = [[UIImageView alloc]init];
        [self.contentView addSubview:_headimage];
        _headimage.sd_layout.leftSpaceToView(self.contentView,autoScaleH(20)).topSpaceToView(self.contentView,autoScaleH(10)).widthIs(autoScaleW(27)).heightIs(autoScaleH(27));
        [_headimage setSd_cornerRadiusFromHeightRatio:@(0.5)];
        _namelabel = [[UILabel alloc]init];
        _namelabel.textColor = [UIColor lightGrayColor];
        _namelabel.textAlignment = NSTextAlignmentCenter;
        _namelabel.font = [UIFont systemFontOfSize:autoScaleW(11)];
        [self.contentView addSubview:_namelabel];
        _namelabel.sd_layout.centerXEqualToView(_headimage).topSpaceToView(_headimage,autoScaleH(5)).heightIs(autoScaleH(15));
        [_namelabel setSingleLineAutoResizeWithMaxWidth:autoScaleW(80)];



        _numberlabel = [[UILabel alloc]init];
        _numberlabel.textColor = [UIColor lightGrayColor];
        _numberlabel.font = [UIFont systemFontOfSize:autoScaleW(11)];
        _numberlabel.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:_numberlabel];
        _numberlabel.sd_layout.centerXEqualToView(_namelabel).topSpaceToView(_namelabel,autoScaleH(5)).heightIs(autoScaleH(15));
        [_numberlabel setSingleLineAutoResizeWithMaxWidth:autoScaleW(80)];
        _timelabel = [[UILabel alloc]init];
        _timelabel.font = [UIFont systemFontOfSize:autoScaleW(14)];
        _timelabel.textColor = UIColorFromRGB(0x636363);
        [self.contentView addSubview:_timelabel];
        _timelabel.sd_layout.leftSpaceToView(_headimage,autoScaleW(32)).topSpaceToView(self.contentView,autoScaleH(20)).widthIs(autoScaleW(180)).heightIs(autoScaleH(15));

        _xinxilabel = [[UILabel alloc]init];
        _xinxilabel.font = [UIFont systemFontOfSize:autoScaleW(12)];
        _xinxilabel.textColor = UIColorFromRGB(0x636363);
        [self.contentView addSubview:_xinxilabel];
        _xinxilabel.sd_layout.leftSpaceToView(_headimage,autoScaleW(32)).topSpaceToView(_namelabel,autoScaleH(5)).widthIs(autoScaleW(80)).heightIs(autoScaleH(15));

        _moneylabel = [[UILabel alloc]init];
        _moneylabel.textColor = UIColorFromRGB(0xfd7577);
        _moneylabel.textAlignment = NSTextAlignmentCenter;
        _moneylabel.font = [UIFont systemFontOfSize:autoScaleW(15)];
        [self.contentView addSubview:_moneylabel];
        _moneylabel.sd_layout.leftSpaceToView(_xinxilabel,autoScaleW(25)).topSpaceToView(_namelabel,autoScaleH(5)).widthIs(autoScaleW(100)).heightIs(autoScaleH(15));

        _ydtimelabel = [[UILabel alloc]init];
        _ydtimelabel.textAlignment = NSTextAlignmentRight;
        _ydtimelabel.font = [UIFont systemFontOfSize:autoScaleW(11)];
        _ydtimelabel.textColor = [UIColor lightGrayColor];
        [self.contentView addSubview:_ydtimelabel];
        _ydtimelabel.sd_layout.rightSpaceToView(self.contentView,autoScaleW(15)).topSpaceToView(self.contentView,autoScaleH(20)).widthIs(autoScaleW(120)).heightIs(autoScaleH(15));


    }
    return self;
}
-(void)layoutSubviews{
    [super layoutSubviews];
    //    if (_orderStatus == 3) {
    CGFloat tagWidth = self.height_sd * sqrt(2);
    CGFloat tagHeight = autoScaleH(25);
    CGFloat offset = self.height_sd / 6;
    CGFloat start_y = self.height_sd / 2 - tagHeight / 2 - offset;
    CGFloat start_x = self.width_sd - (self.height_sd + (tagWidth - self.height_sd) / 2) + offset;
    tagLabel = [[UILabel alloc] initWithFrame:CGRectMake(start_x, start_y, tagWidth, tagHeight)];

    tagLabel.alpha = 0.5;
    tagLabel.textColor = [UIColor whiteColor];
    tagLabel.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:tagLabel];
    //        tagLabel.frame = ;
    tagLabel.transform = CGAffineTransformMakeRotation(M_PI / 4);
    self.clipsToBounds = YES;
    [self.contentView bringSubviewToFront:tagLabel];

    //    }
}
-(void)setModel:(OrderModel *)model{
    _model = model;
    dispatch_async(dispatch_get_main_queue(), ^{
        if (_orderStatus == 3) {
            tagLabel.text = [NSString stringWithFormat:@"%@桌", _model.boardNum];
            tagLabel.backgroundColor = [UIColorFromRGB(0xfd7577) colorWithAlphaComponent:1];
        } else if (_orderStatus == 1) {
            //1 预订 无桌号 2 到店用餐 也没桌号。
            //            tagLabel.text = [NSString stringWithFormat:@"%@桌", _model.boardNum];
            if ([_model.disOrderType integerValue] == 1) {
                tagLabel.text = @"到店";
                tagLabel.backgroundColor = [UIColorFromRGB(0xf8b551) colorWithAlphaComponent:1];
            } else {
                tagLabel.text = @"预订";
                tagLabel.backgroundColor = [UIColorFromRGB(0x80c269) colorWithAlphaComponent:1];
            }
        } else {
            tagLabel.text = [NSString stringWithFormat:@"%@桌", _model.boardNum];
            //            tagLabel.backgroundColor = [[UIColor cyanColor] colorWithAlphaComponent:0.6];
        }
        NSString *tempStr = [NSString stringWithFormat:@"%@/%@号桌",model.peoplenumstr, _model.boardNum];
        //        if ([_model.peoplenumstr isNull] && ![_model.boardNum isNull]) {//预订订单，无桌号，但一定有人数
        //          tempStr =  [NSString stringWithFormat:@"%@/%@号桌",[_model.boardNum  judgeDeskPeopleNumFromDeskCategory:[_model.boardNum substringToIndex:1]], _model.boardNum];
        //        } else if (![_model.peoplenumstr isNull] && [_model.boardNum isNull]) {//到店用餐订单，无人数，但一定有桌号
        //            tempStr = [NSString stringWithFormat:@"%@/%@号桌",model.peoplenumstr, @"桌号待定"];
        //        } else if ([_model.peoplenumstr isNull] && [_model.boardNum isNull]){
        //            tempStr = @"人数/桌号待定";
        //        } else {
        //            //都不为空
        //        }
        _xinxilabel.text = tempStr;
    });
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
