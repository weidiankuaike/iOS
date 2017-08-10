//
//  TableViewCell.m
//  微点筷客商户端
//
//  Created by Skyer God on 17/1/10.
//  Copyright © 2017年 张森森. All rights reserved.
//

#import "StaffInfoCell.h"
#import "StuffAccountModel.h"
NSIndexPath *_indexPath;
StuffAccountModel *_model;
static CGFloat firstCellHeight = 80;
@implementation StaffInfoCell
+(CGFloat)setIndexPath:(NSIndexPath *)indexP withModel:(StuffAccountModel *)model{
    _indexPath = indexP;
    if (indexP.section == 0) {
        firstCellHeight = autoScaleH(110);
    } else {
        firstCellHeight = autoScaleH(80);
        _model = model;
    }
    return firstCellHeight;
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self create];
    }
    return self;
}
- (void)create{
    UIView *contentView = self.contentView;
    UIView *  headView = [[UIView alloc]init];

    if (_indexPath.section != 0) {
        headView.backgroundColor = RGB(239, 188, 111);
    } else {
        headView.backgroundColor = RGB(234, 158, 157);
    }
    headView.layer.masksToBounds = YES;
    headView.layer.cornerRadius = autoScaleW(5);
    [contentView addSubview:headView];
    headView.sd_layout
    .leftSpaceToView(contentView,autoScaleW(10))
    .rightSpaceToView(contentView,autoScaleW(10))
    .topSpaceToView(contentView,autoScaleH(0))
    .heightIs(firstCellHeight);//85
    
    UIImageView * headimage = [[UIImageView alloc]init];
    headimage.image = [UIImage imageNamed:@"用户"];
    [headView addSubview:headimage];

    CGFloat photoSpace = (firstCellHeight - firstCellHeight * 0.55 - autoScaleH(20)) / 2;
    headimage.sd_layout
    .leftSpaceToView(headView,autoScaleW(10))
    .topSpaceToView(headView,photoSpace)
    .widthIs(firstCellHeight * 0.55)
    .heightEqualToWidth(0);//50

    UILabel * firstlabel = [[UILabel alloc]init];
    firstlabel.text = _indexPath.section == 0 ? @"店主" : @"店员";
    firstlabel.textColor =[UIColor whiteColor];
    firstlabel.textAlignment = NSTextAlignmentCenter;
    CGFloat fontSize = _indexPath.section == 0 ? 15 : 13;
    firstlabel.font = [UIFont systemFontOfSize:autoScaleW(fontSize)];
    [headView addSubview:firstlabel];

    firstlabel.sd_layout
    .leftEqualToView(headimage)
    .rightEqualToView(headimage)
    .topSpaceToView(headimage, autoScaleH(6))
    .heightIs(autoScaleH(20));

    NSArray * middleArr = nil;//@[@"林玲玲",@"13506905194",];
    if (_indexPath.section == 0) {
//        NSString *loginName = [[NSUserDefaults standardUserDefaults] valueForKey:@"AdministratorPhone"];
//        NSString *name = [[NSUserDefaults standardUserDefaults] valueForKey:@"AdministratorName"];
        middleArr = @[_BaseModel.name, _BaseModel.loginName];
    } else {
        middleArr = @[_model.name, _model.phone];
    };
    UIView *middleView = [[UIView alloc] init];
    middleView.backgroundColor = [UIColor clearColor];
    [headView addSubview:middleView];

    middleView.sd_layout
    .leftSpaceToView(headimage, autoScaleW(50))
    .centerYEqualToView(contentView)
    .widthRatioToView(contentView, 0.25)
    .heightIs(firstCellHeight / 2);
    for (int i=0; i<middleArr.count; i++)
    {
        UILabel * middleInfoLabel = [[UILabel alloc]init];
        middleInfoLabel.text = middleArr[i];
        middleInfoLabel.textColor = [UIColor whiteColor];
        middleInfoLabel.textAlignment = NSTextAlignmentCenter;
        middleInfoLabel.font = [UIFont systemFontOfSize:autoScaleW(11)];
        [middleView addSubview:middleInfoLabel];

        middleInfoLabel.sd_layout
        .leftEqualToView(middleView)
        .topSpaceToView(middleView, 0 + i * middleView.size.height / 2)
        .rightEqualToView(middleView)
        .heightRatioToView(middleView, 0.5);
    }

    UILabel * limitLabel = [[UILabel alloc]init];
    limitLabel.text = @"操作权限";
    limitLabel.font = [UIFont systemFontOfSize:autoScaleW(11)];
    limitLabel.textAlignment = NSTextAlignmentCenter;
    limitLabel.textColor = [UIColor whiteColor];
    [headView addSubview:limitLabel];
    limitLabel.sd_layout
    .topSpaceToView(headView,autoScaleH(10))
    .rightSpaceToView(headView,autoScaleW(20))
    .widthIs(autoScaleW(100))
    .heightIs(15);
    
    NSArray *limitArr = @[@"订单管理",@"现场管理",@"排队管理",@"餐厅管理",@"查看统计",@"账号管理",];
    limitArr = _indexPath.section == 0 ? limitArr : _model.manageArr;
    for (int i = 0; i < limitArr.count; i++) {

        UILabel * limitLabel = [[UILabel alloc]init];
        limitLabel.text = limitArr[i];
        limitLabel.font = [UIFont systemFontOfSize:autoScaleW(11)];
        limitLabel.textAlignment = NSTextAlignmentCenter;
        limitLabel.textColor = [UIColor whiteColor];
        [headView addSubview:limitLabel];
        CGFloat rightSpace = 0;
        if (i == 0 && limitArr.count == 1) {
            rightSpace = autoScaleW(20 + 65);
        } else if (i >= 2 && i % 2 == 0 && limitArr.count % 2 == 1) {
            rightSpace = autoScaleW(20 + 65 * ((i - 1) % 2));
        } else {
            rightSpace = autoScaleW(20 + 65 * (i % 2));
        }
        limitLabel.sd_layout
        .rightSpaceToView(headView,rightSpace)
        .topSpaceToView(limitLabel, 2 + i/2*autoScaleH(12))
        .widthIs(autoScaleW(50))
        .heightIs((15));
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
