//
//  MyqueueTableViewCell.m
//  wdKuaiKe_iOS
//
//  Created by 张森森 on 2017/7/3.
//  Copyright © 2017年 weiDianKuaiKe. All rights reserved.
//

#import "MyqueueTableViewCell.h"

@implementation MyqueueTableViewCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
       
        _timeLabel = [[UILabel alloc]init];
        _timeLabel.text = @"15\n分\n钟";
        _timeLabel.numberOfLines = [_timeLabel.text length];
        _timeLabel.textColor = [UIColor whiteColor];
        _timeLabel.textAlignment = NSTextAlignmentCenter;
        _timeLabel.font = [UIFont systemFontOfSize:autoScaleW(16)];
        _timeLabel.backgroundColor = RGB(255, 179, 92);
        _timeLabel.layer.masksToBounds = YES;
        _timeLabel.layer.cornerRadius = 3;
        [self addSubview:self.timeLabel];
        self.timeLabel.sd_layout.leftSpaceToView(self,5).topSpaceToView(self,5).widthIs(50).bottomSpaceToView(self, 5);
        
        _queueView = [[UIView alloc]init];
        _queueView.backgroundColor = [UIColor whiteColor];
        _queueView.layer.borderWidth = 1;
        _queueView.layer.borderColor = RGB(255, 179, 92).CGColor;
        [self addSubview:_queueView];
        _queueView.sd_layout.leftSpaceToView(_timeLabel, -1).topSpaceToView(self, 0).widthIs(GetWidth-60).bottomEqualToView(self);
        
        self.storeImage = [[UIImageView alloc]init];
        self.storeImage.image = [UIImage imageNamed:@"1"];
        [_queueView addSubview:self.storeImage];
        self.storeImage.sd_layout.leftSpaceToView(_queueView,21).topSpaceToView(_queueView, 17).widthIs(90).heightIs(65);
        
        self.numberLael = [[UILabel alloc]init];
        self.numberLael.text = @"A0001";
        self.numberLael.textColor = [UIColor blackColor];
        self.numberLael.font = [UIFont systemFontOfSize:16];
        [_queueView addSubview:self.numberLael];
        self.numberLael.sd_layout.leftSpaceToView(self.storeImage,10).topSpaceToView(_queueView,28).heightIs(25);
        [self.numberLael setSingleLineAutoResizeWithMaxWidth:100];
        
        self.storeName = [[UILabel alloc]init];
        self.storeName.text = @"大丰收鱼庄万达店";
        self.storeName.textColor = UIColorFromRGB(0x585858);
        self.storeName.font = [UIFont systemFontOfSize:13];
        
        [_queueView addSubview:self.storeName];
        self.storeName.sd_layout.leftEqualToView(self.numberLael).topSpaceToView(_queueView, 55).heightIs(30);
        [self.storeName setSingleLineAutoResizeWithMaxWidth:200];
        
        self.arrowImage = [[UIImageView alloc]init];
        self.arrowImage.image = [UIImage imageNamed:@")黄箭头"];
        [_queueView addSubview:self.arrowImage];
        self.arrowImage.sd_layout.rightSpaceToView(_queueView,10).topSpaceToView(_queueView, 44).widthIs(11).heightIs(13);
        
    }
    
    return self;
}

- (void)layoutSubviews{
    
    [super layoutSubviews];
    self.layer.shadowColor = [UIColor blackColor].CGColor;
    self.layer.shadowOpacity = 1.75f;
    self.layer.shadowRadius = 4.0;
    self.layer.shouldRasterize = YES;
    self.layer.rasterizationScale = [UIScreen mainScreen].scale;
    CGPathRef path = [UIBezierPath bezierPathWithRect:CGRectMake(0, self.bounds.size.height, [UIScreen mainScreen].bounds.size.width,2)].CGPath;
    [self.layer setShadowPath:path];

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
