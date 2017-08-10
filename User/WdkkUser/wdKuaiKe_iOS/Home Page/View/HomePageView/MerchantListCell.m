//
//  TableViewCell.m
//  WDKKtest
//
//  Created by Skyer God on 16/7/20.
//  Copyright © 2016年 weiDianKuaiKe. All rights reserved.
//
#define Start_X 15.0f
#define Start_Y 10.f
#define Row_Space 15.0f

#define ImageWidth [UIScreen mainScreen].bounds.size.height / 8
#import "MerchantListCell.h"
#import "LLHConst.h"
@interface MerchantListCell ()

@property (nonatomic, retain) NSMutableArray *arrButton;
@property (nonatomic, retain) NSArray *arrTempB;
@property (nonatomic, retain) UIView *bottomSeparator;

@end
@implementation MerchantListCell


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self create];

    }
    return self;
}
- (void)create{

    //设置商家列表图片
    self.menuImageV = [[UIImageView alloc] init];
    self.menuImageV.backgroundColor = [UIColor blueColor];
    self.menuImageV.image = [UIImage imageNamed:@"example"];
    [self.contentView addSubview:_menuImageV];


    //设置顶部label
    self.bottomSeparator = [[UIView alloc] init];
    self.bottomSeparator.backgroundColor = UIColorFromRGB(0xEEEEEE);
    [self.contentView addSubview:_bottomSeparator];

    //设置商家名
    self.titleLabel = [[UILabel alloc] init];
    
    self.titleLabel.text = @"远洋私厨(软件园店)";
    self.titleLabel.font = [UIFont systemFontOfSize:autoScaleW(14)];
    
    self.titleLabel.textAlignment = NSTextAlignmentLeft;
    
    [self.contentView addSubview:_titleLabel];
     //设置商家名字后标签
    
    self.tagLabel = [[UILabel alloc] init];
    
    self.tagLabel.text = @"排";
    
    self.tagLabel.textAlignment = NSTextAlignmentCenter;
    
    self.tagLabel.textColor = [UIColor whiteColor];
    
    self.tagLabel.font = [UIFont systemFontOfSize:autoScaleW(12)];
    
    self.tagLabel.backgroundColor = [UIColor colorWithRed:0.0 green:0.7803 blue:0.0016 alpha:1.0];
    
    [self.contentView addSubview:_tagLabel];
    //设置上架受欢迎程度button， 默认为NO
    for (NSInteger i = 0; i < 5; i++) {
        UIButton *starButton = [UIButton buttonWithType:UIButtonTypeCustom];

        //        starButton.backgroundColor = [UIColor cyanColor];

        [starButton setBackgroundImage:[UIImage imageNamed:@"starIcon"] forState:UIControlStateNormal];


        starButton.userInteractionEnabled = NO;

        [starButton addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];

        starButton.tag = 11000 + i;

        
        
        [self.contentView addSubview:starButton];
        
    }
    
    _arrTempB = _arrButton;
   
    //设置单价／人
    
    self.priceLabel = [[UILabel alloc] init];
    
    _priceLabel.text = @"¥28/人";
    
    _priceLabel.textAlignment = NSTextAlignmentCenter;
    
    _priceLabel.font = [UIFont systemFontOfSize:autoScaleW(12)];
    
    _priceLabel.textColor = [UIColor colorWithRed:0.3013 green:0.3013 blue:0.3013 alpha:1.0];
    [self.contentView addSubview:_priceLabel];
    //设置分类标签
    
    self.categoryLabel = [[UILabel alloc] init];
    
    _categoryLabel.textColor = [UIColor colorWithRed:0.7183 green:0.7183 blue:0.7183 alpha:1.0];
    
    _categoryLabel.text = @"中餐";
    
    _categoryLabel.textAlignment = NSTextAlignmentLeft;
    
    _categoryLabel.font = _priceLabel.font;
    
    [self.contentView addSubview:_categoryLabel];
    
    
    //设置地理位置距离
    
    self.distanceLabel = [[UILabel alloc] init];
    
    _distanceLabel.text = @"会展中心1.3Km";
    
    _distanceLabel.textColor = _categoryLabel.textColor;
    
    _distanceLabel.font = _categoryLabel.font;
    
    [self.contentView addSubview:_distanceLabel];

    




    self.menuImageV.sd_layout
    .leftSpaceToView(self.contentView, Start_X)
    .topSpaceToView(self.contentView, Start_Y)
    .widthIs(ImageWidth)
    .heightIs(ImageWidth);

    self.bottomSeparator.sd_layout.leftEqualToView(self.contentView).topSpaceToView(_menuImageV, Start_Y).rightEqualToView(self.contentView).heightIs(3);


    self.titleLabel.sd_layout
    .leftSpaceToView(_menuImageV, Start_X)
    .topSpaceToView(self.contentView, Start_Y - 3)
    .heightIs(ImageWidth / 4);
    [self.titleLabel setSingleLineAutoResizeWithMaxWidth:350];


    self.tagLabel.sd_layout
    .leftSpaceToView(_titleLabel, 3)
    .centerYEqualToView(_titleLabel)
    .heightIs(ImageWidth/5.5);
    [_tagLabel setSingleLineAutoResizeWithMaxWidth:100];


    CGFloat width = autoScaleW(15);
    CGFloat col_space = 2;
    for (NSInteger i = 0; i < 5; i++) {
        UIButton *button = [self.contentView viewWithTag:11000 + i];

        button.sd_layout
        .leftSpaceToView(_menuImageV, Start_X + (col_space + width) * i)
        .topSpaceToView(_titleLabel, 1)
        .widthIs(width)
        .heightIs(width);

    }

    self.priceLabel.sd_layout
    .leftSpaceToView(_menuImageV, Start_X + (col_space + width) * 5 + 10)
    .topSpaceToView(_titleLabel, 1)
    .heightIs(width);
    [self.priceLabel setSingleLineAutoResizeWithMaxWidth:100];


    self.categoryLabel.sd_layout
    .leftEqualToView(_titleLabel)
    .bottomEqualToView(_menuImageV)
    .heightIs(width);
    [self.categoryLabel setSingleLineAutoResizeWithMaxWidth:100];


    self.distanceLabel.sd_layout
    .rightSpaceToView(self.contentView, 20)
    .topEqualToView(_categoryLabel)
    .heightIs(width);
    [self.distanceLabel setSingleLineAutoResizeWithMaxWidth:180];

    [self setupAutoHeightWithBottomView:_bottomSeparator bottomMargin:0];


    
}
- (void)buttonAction:(UIButton *)sender{
    
    NSLog(@"star %ld", sender.tag);
}
- (void)setModel:(MerchantDetailVCModel *)model{
    _model = model;

    self.titleLabel.text = _model.name;
    [self.menuImageV sd_setImageWithURL:[NSURL URLWithString:_model.storeImage] placeholderImage:[UIImage imageNamed:@"turnPlay"]];


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
