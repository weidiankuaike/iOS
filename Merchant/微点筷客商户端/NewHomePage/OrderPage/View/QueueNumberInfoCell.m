//
//  QueueNumberInfoCell.m
//  微点筷客商户端
//
//  Created by Skyer God on 17/1/20.
//  Copyright © 2017年 张森森. All rights reserved.
//

#import "QueueNumberInfoCell.h"
#import "ZTAddOrSubAlertView.h"
@interface QueueNumberInfoCell()
{
    UILabel *_categoryLabel;
    UILabel *_deskCategory;
    UILabel *_queueNumLabel;
    ButtonStyle *_manualWorkBT;
}

@end
@implementation QueueNumberInfoCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {

        self.selectionStyle = UITableViewCellSelectionStyleNone;

        CGFloat start_x = autoScaleW(15);
        CGFloat topSpace = autoScaleH(15);
        CGFloat sumHeight = (80 - topSpace * 2) / 2;
        _categoryLabel = [[UILabel alloc] init];
        _categoryLabel.text = @"A类";
        _categoryLabel.textAlignment = NSTextAlignmentCenter;
        _categoryLabel.font = [UIFont systemFontOfSize:18];
        [self.contentView addSubview:_categoryLabel];

        _categoryLabel.sd_layout
        .topSpaceToView(self.contentView, topSpace)
        .leftSpaceToView(self.contentView, start_x)
        .widthIs(100)
        .heightIs(sumHeight);
        _deskCategory = [[UILabel alloc] init];
        _deskCategory.text = @"2人桌";
        _deskCategory.font = [UIFont systemFontOfSize:14];
        _deskCategory.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:_deskCategory];

        _deskCategory.sd_layout
        .topSpaceToView(_categoryLabel, 0)
        .centerXEqualToView(_categoryLabel)
        .widthIs(100)
        .heightIs(sumHeight);

        _queueNumLabel = [[UILabel alloc] init];
        _queueNumLabel.text = @"A45";
        _queueNumLabel.font = [UIFont systemFontOfSize:16];
        _queueNumLabel.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:_queueNumLabel];

        _queueNumLabel.sd_layout
        .centerYEqualToView(self.contentView)
        .centerXEqualToView(self.contentView)
        .widthIs(50)
        .heightIs(30);

        _manualWorkBT = [ButtonStyle buttonWithType:UIButtonTypeCustom];
        [_manualWorkBT setTitle:@"人工出号" forState:UIControlStateNormal];
        [_manualWorkBT setTitleColor:UIColorFromRGB(0xfd7577) forState:UIControlStateNormal];
        [_manualWorkBT addTarget:self action:@selector(manualWorkClick:) forControlEvents:UIControlEventTouchUpInside];
        [_manualWorkBT.titleLabel setFont:[UIFont systemFontOfSize:17]];
        [self.contentView addSubview:_manualWorkBT];

        _manualWorkBT.sd_layout
        .rightSpaceToView(self.contentView, start_x)
        .centerYEqualToView(self.contentView)
        .widthIs(100)
        .heightIs(30);



    }
    return self;
}
- (void)setInfoDic:(NSMutableDictionary *)infoDic{
    _infoDic = infoDic;

    NSString *category = infoDic[@"boardType"];
    NSString *queueNum = infoDic[@"queueNum"];
    NSString *deskPeopleNum = [category judgeDeskPeopleNumFromDeskCategory:category];
    _categoryLabel.text = category;
    _deskCategory.text = [NSString stringWithFormat:@"%@桌", deskPeopleNum];
    _queueNumLabel.text = [NSString stringWithFormat:@"%@%@", category, queueNum];


}
- (void)manualWorkClick:(ButtonStyle *)sender{

    NSString *keyUrl = @"api/merchant/numberQueueManage";
    NSString *storeId = storeID;
    NSString *userId = _BaseModel.id;
    NSString *operation = @"6";//0 判断是否开启 1 开启排队状态 2确定到店,分配桌号 3 已到店 4 开始用餐  5 员工领号 6 打印领号 7 暂停 8 关闭排队（系统将不再烦好，已放出的排号过号后，可以关闭排号模式）
    NSString *boardType = _categoryLabel.text;

    NSString *loadUrl = [NSString stringWithFormat:@"%@%@?token=%@&storeId=%@&userId=%@&operation=%@&boardType=%@", kBaseURL, keyUrl, TOKEN, storeId, userId, operation, boardType];

      
    [[QYXNetTool shareManager] postNetWithUrl:loadUrl urlBody:nil bodyStyle:QYXBodyString header:nil response:QYXJSON success:^(id result) {
        if ([result[@"msgType"] integerValue] == 0) {
            NSString *category = [result[@"obj"] substringToIndex:1];
            NSString *queueNum = [result[@"obj"] substringFromIndex:1];;
            NSString *deskPeopleNum = [category judgeDeskPeopleNumFromDeskCategory:category];
            _categoryLabel.text = category;
            _deskCategory.text = [NSString stringWithFormat:@"%@桌", deskPeopleNum];
            _queueNumLabel.text = [NSString stringWithFormat:@"%@%@", category, queueNum];
            [self showAlertLittleTitleAndChangeCellStatus:_queueNumLabel.text];

        }

    } failure:^(NSError *error) {


    }];
}
- (void)showAlertLittleTitleAndChangeCellStatus:(NSString *)queueNum{

    ZTAddOrSubAlertView *alertV = [[ZTAddOrSubAlertView alloc] initWithStyle:ZTalertSheetStyleSubTitle];
    alertV.titleLabel.text =  @"出号并打印号牌？";
    alertV.titleLabel.font = [UIFont systemFontOfSize:17 weight:17];
    [alertV.cancelBT setTitle:@"取消" forState:UIControlStateNormal];
    [alertV.confirmBT setTitle:@"确定" forState:UIControlStateNormal];
    alertV.littleLabel.text = _queueNumLabel.text;
    [alertV.confirmBT setTitleColor:UIColorFromRGB(0xfd7577) forState:UIControlStateNormal];

    alertV.littleLabel.font = [UIFont systemFontOfSize:18 weight:20];
    [alertV showView];
    if (_manualWorkSuccess) {
        _manualWorkSuccess(NO);
    }
    alertV.complete = ^(BOOL complete){
        if (_manualWorkSuccess) {
            _manualWorkSuccess(YES);
        }
        if (complete) {
            //修改视图

        } else {
            //
        }
    };

}
- (UIViewController *)viewController {
    for (UIView* next = [self superview]; next; next = next.superview) {
        UIResponder *nextResponder = [next nextResponder];
        if ([nextResponder isKindOfClass:[UIViewController class]]) {
            return (UIViewController *)nextResponder;
        }
    }
    return nil;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
