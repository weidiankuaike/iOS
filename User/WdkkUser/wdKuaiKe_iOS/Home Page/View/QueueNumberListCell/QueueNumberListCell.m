//
//  QueueNumberListCell.m
//  wdKuaiKe_iOS
//
//  Created by Skyer God on 16/8/23.
//  Copyright © 2016年 weiDianKuaiKe. All rights reserved.
//

#import "QueueNumberListCell.h"

#import "CalculateStringTool.h"

@implementation QueueNumberListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.backgroundColor = RGB(241, 241, 241);
        
        //选择按钮
        selectBT = [UIButton buttonWithType:UIButtonTypeCustom];
        [selectBT setImage:[UIImage imageNamed:@"椭圆1"] forState:UIControlStateNormal];
        [selectBT setImage:[UIImage imageNamed:@"椭圆1拷贝"] forState:UIControlStateSelected];
        [selectBT imageRectForContentRect:selectBT.frame];
        
        [self.contentView addSubview:selectBT];
        
        /** 单行 **/
        catagoryLabel = [[UILabel alloc] init];
        catagoryLabel.text= @"小桌";
        catagoryLabel.font = [UIFont systemFontOfSize:autoScaleW(17)];
        catagoryLabel.textColor = RGB(222, 123, 38);
        [self.contentView addSubview:catagoryLabel];
        
        /** 1~2人 **/
        rangeLabel = [[UILabel alloc] init];
        rangeLabel.text= @"1~2人";
        rangeLabel.textColor = [UIColor lightGrayColor];
        rangeLabel.font = [UIFont systemFontOfSize:autoScaleW(12)];
        [self.contentView addSubview:rangeLabel];
        
        
        
        /** 数字 **/
        numLabel = [[UILabel alloc]init];
        numLabel.textColor = catagoryLabel.textColor;
        numLabel.text = @"5";
        
        numLabel.font = [UIFont systemFontOfSize:autoScaleW(20)];
        [self.contentView addSubview:numLabel];
        
        /** 桌标签 **/
        deskLabel = [[UILabel alloc] init];
        deskLabel.textColor = numLabel.textColor;
        deskLabel.text = @"桌";
        deskLabel.font = [UIFont systemFontOfSize:autoScaleW(12)];
        [self.contentView addSubview:deskLabel];
        
        /* 时间*/
        timeLabel = [[UILabel alloc] init];
        timeLabel.text = @">30";
        timeLabel.font = [UIFont systemFontOfSize:autoScaleW(17)];
        timeLabel.textColor = deskLabel.textColor;
        [self.contentView addSubview:timeLabel];
        
        //分钟
        minlabel = [[UILabel alloc] init];
        minlabel.text = @"分钟";
        minlabel.textColor = timeLabel.textColor;
        
        minlabel.font = [UIFont systemFontOfSize:deskLabel.font.pointSize];
        [self.contentView addSubview:minlabel];
        
        
        
        
    }
    return self;
}

-(void)layoutSubviews{
    [super layoutSubviews];
    
    selectBT.sd_layout.leftSpaceToView(self.contentView, autoScaleW(10)).centerYIs(self.contentView.centerY).widthIs(autoScaleW(20)).heightEqualToWidth();
    catagoryLabel.sd_layout.leftSpaceToView(selectBT, autoScaleW(15)).topSpaceToView(self.contentView, autoScaleH(10)).heightIs(autoScaleH(16)).widthIs(autoScaleW(36));
    rangeLabel.sd_layout.bottomSpaceToView(self.contentView, autoScaleH(0)).centerXEqualToView(catagoryLabel).widthRatioToView(catagoryLabel, 0.9).heightIs(autoScaleH(15));
    numLabel.sd_layout.centerXIs(self.contentView.centerX).centerYIs(self.contentView.centerY).widthIs(autoScaleW(12)).heightRatioToView(self.contentView, 0.8);
    deskLabel.sd_layout.leftSpaceToView(numLabel, 1).bottomSpaceToView(self.contentView, autoScaleH(15)).widthIs(autoScaleW(20)).heightIs(10);
    
    CGFloat width = [[CalculateStringTool shareManager] getStringWidthWithString:timeLabel.text fontSize:timeLabel.font];
    
    timeLabel.sd_layout.centerYIs(self.contentView.centerY).leftSpaceToView(deskLabel, autoScaleW(85)).widthIs(width).heightIs(autoScaleH(30));
    
    CGFloat widthh = [[CalculateStringTool shareManager] getStringWidthWithString:minlabel.text fontSize:minlabel.font];
    minlabel.sd_layout.centerYIs(self.contentView.centerY).leftSpaceToView(timeLabel, 1).widthIs(widthh).heightIs(timeLabel.height / 2);
    
    
    
    
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
    
    
    selectBT.selected = selected;
}

@end
