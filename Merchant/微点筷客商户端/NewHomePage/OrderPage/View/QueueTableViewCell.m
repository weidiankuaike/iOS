//
//  QueueTableViewCell.m
//  微点筷客商户端
//
//  Created by 张森森 on 16/11/10.
//  Copyright © 2016年 张森森. All rights reserved.
//

#import "QueueTableViewCell.h"
#import "ZTAddOrSubAlertView.h"

@interface QueueTableViewCell ()
{
    UILabel *startEatLabel;
    UIImageView *statusImageV;
}
@end
@implementation QueueTableViewCell
-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        //        self.contentView.backgroundColor = RGB(arc4random_uniform(255), arc4random_uniform(255), arc4random_uniform(255));
        //        _headImageV = [[UIImageView alloc]init];
        //        _headImageV.image = [UIImage imageNamed:@"sad"];
        //        [self.contentView addSubview:_headImageV];

        //        _headImageV.sd_layout
        //        .leftSpaceToView(self.contentView, start_x)
        //        .topSpaceToView(self.contentView, start_x)
        //        .widthIs(autoScaleW(38))
        //        .heightIs(autoScaleH(38));
        //
        //        UILabel * nameLabel = [[UILabel alloc]init];
        //        nameLabel.text = @"老王";
        //        nameLabel.textAlignment = NSTextAlignmentCenter;
        //        nameLabel.font = [UIFont systemFontOfSize:autoScaleW(11)];
        //        [self.contentView addSubview:nameLabel];
        //
        //        nameLabel.sd_layout
        //        .centerXEqualToView(_headImageV)
        //        .topSpaceToView(_headImageV,autoScaleH(5))
        //        .bottomEqualToView(self.contentView)
        //        .widthIs(autoScaleW(50));


        CGFloat start_x = autoScaleW(15);
        CGFloat topSpace = autoScaleH(10);
        CGFloat sumHeight = (80 - topSpace * 2) / 2;

        NSString * string = [NSString stringWithFormat:@"%@",@"C45"];
        NSString * timestring = [NSString stringWithFormat:@"%d人/%d号桌",4,5];

        NSArray * xinxiary = @[string,timestring,];

        for (int i=0; i<2; i++)
        {
            UILabel * deskOrQueueNum = [[UILabel alloc]init];
            deskOrQueueNum.text = xinxiary[i];
            deskOrQueueNum.tag = 100 + i;
            deskOrQueueNum.textAlignment = NSTextAlignmentCenter;
            deskOrQueueNum.font = [UIFont systemFontOfSize:autoScaleW(13)];
            if (i==0) {

                deskOrQueueNum.font = [UIFont systemFontOfSize:autoScaleW(17)];
            }
            [self.contentView addSubview:deskOrQueueNum];
            deskOrQueueNum.sd_layout
            .leftSpaceToView(self.contentView, start_x)
            .topSpaceToView(self.contentView, topSpace + sumHeight * i)
            .widthIs(autoScaleW(80))
            .heightIs(autoScaleH(sumHeight));
        }

        startEatLabel = [[UILabel alloc] init];
        startEatLabel.backgroundColor = [UIColor whiteColor];
        startEatLabel.font = [UIFont systemFontOfSize:15];
        startEatLabel.text = @"开始用餐";
        startEatLabel.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:startEatLabel];
        startEatLabel.hidden = YES;
        startEatLabel.sd_layout
        .centerYEqualToView(self.contentView)
        .centerXEqualToView(self.contentView)
        .widthIs(100)
        .heightIs(30);

        statusImageV = [[UIImageView alloc] init];
        statusImageV.backgroundColor = [UIColor whiteColor];
        statusImageV.image = [UIImage imageNamed:@"黑勾"];
        [self.contentView addSubview:statusImageV];

        statusImageV.hidden = YES;
        statusImageV.sd_layout
        .rightSpaceToView(self.contentView, start_x * 2.5)
        .centerYEqualToView(self.contentView)
        .widthIs(25)
        .heightIs(25);

        _timeImageV = [[UIImageView alloc]init];
        _timeImageV.image = [UIImage imageNamed:@"时间"];
        [self.contentView addSubview:_timeImageV];
        _timeImageV.sd_layout
        .topSpaceToView(self.contentView, start_x + 5)
        .centerXEqualToView(self.contentView)
        .widthIs(autoScaleW(20))
        .heightIs(autoScaleW(20));

        _timeLabel = [[UILabel alloc]init];
        _timeLabel.textAlignment = NSTextAlignmentCenter;
        _timeLabel.font = [UIFont systemFontOfSize:autoScaleW(11)];
        [self.contentView addSubview:_timeLabel];
        _timeLabel.sd_layout
        .centerXEqualToView(self.contentView)
        .topSpaceToView(_timeImageV,0)
        .widthIs(autoScaleW(80))
        .heightIs(sumHeight - 10);

        _tiShiLabel = [[UILabel alloc]init];
        _tiShiLabel.font = [UIFont systemFontOfSize:autoScaleW(13)];
        _tiShiLabel.textColor = [UIColor blackColor];
        _tiShiLabel.textAlignment = NSTextAlignmentRight;
        //        NSMutableAttributedString * str = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"请带领客人前往%d号桌",15]];
        //        [str addAttribute:NSForegroundColorAttributeName value:UIColorFromRGB(0xfd7577) range:NSMakeRange(7, 4)];
        //        _tiShiLabel.attributedText = str;
        [self.contentView addSubview:_tiShiLabel];
        _tiShiLabel.hidden = YES;
        _tiShiLabel.sd_layout
        .rightSpaceToView(self.contentView,start_x)
        .centerYEqualToView(self.contentView)
        .widthIs(autoScaleW(200))
        .heightIs(autoScaleH(15));


        _sureBT = [ButtonStyle buttonWithType:UIButtonTypeCustom];
        [_sureBT setTitle:@"确认到店" forState:UIControlStateNormal];
        [_sureBT setTitleColor:UIColorFromRGB(0xfd7577) forState:UIControlStateNormal];
        _sureBT.titleLabel.font = [UIFont systemFontOfSize:autoScaleW(17)];
        [_sureBT addTarget:self action:@selector(sureClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:_sureBT];
        _sureBT.sd_layout
        .centerYEqualToView(self.contentView)
        .rightSpaceToView(self.contentView, start_x)
        .widthIs(autoScaleW(75))
        .heightIs(autoScaleH(20));

    }


    return self;
}
- (void)sureClick:(ButtonStyle *)sender{
    ZTAddOrSubAlertView *alertV = [[ZTAddOrSubAlertView alloc] initWithStyle:ZTalertSheetStyleSubTitle];
    alertV.titleLabel.text =  [NSString stringWithFormat:@"%@号已经到店？" , _model.queue];
    [alertV.cancelBT setTitle:@"未到店" forState:UIControlStateNormal];
    [alertV.confirmBT setTitle:@"已到店" forState:UIControlStateNormal];
    [alertV.confirmBT setTitleColor:UIColorFromRGB(0xfd7577) forState:UIControlStateNormal];
    NSMutableAttributedString * str = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"确认后,请带领客人前往%@%@号桌", _model.boardType,_model.boardNum]];
    [str addAttribute:NSForegroundColorAttributeName value:UIColorFromRGB(0xfd7577) range:NSMakeRange(11, 4)];
    alertV.littleLabel.attributedText = str;
    [alertV showView];
    alertV.complete = ^(BOOL complete){
        if (complete) {
            [self getQueueProceingSourceData:@"3"];
        } else {
            //
        }
    };

}
-(void)startTime
{

    NSString * _Nullable str = [NSString stringWithFormat:@"%ld", (long)_index];
    const char *queueName = [str cStringUsingEncoding:NSUTF8StringEncoding];
    dispatch_queue_t queue = dispatch_queue_create(queueName, 0);
    _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1*NSEC_PER_SEC, 0); //每秒执行
    dispatch_source_set_event_handler(_timer, ^{

        if(_model.timeGap <= 0) { //倒计时结束，关闭
            dispatch_source_cancel(_timer);
            _timer = nil;
            if (_timeOverOrAbandonedBlock) {
                _timeOverOrAbandonedBlock(YES);
            }
            ZTLog(@"________%ld", _index);

            dispatch_async(dispatch_get_main_queue(), ^{
                //设置界面的按钮显示 根据自己需求设置
                startEatLabel.text = @"超时取消";
                startEatLabel.hidden = NO;
                statusImageV.hidden = NO;
                statusImageV.image = [UIImage imageNamed:@"黑叉"];
                _timeImageV.hidden = YES;
                _timeLabel.hidden = YES;
                _sureBT.hidden = YES;
            });


        } else {
            dispatch_async(dispatch_get_main_queue(), ^{
                _timeLabel.text = [NSString stringWithFormat:@"剩余%lds", (long)_model.timeGap];
                _model.timeGap--;
            });

        }
    });
    dispatch_resume(_timer);
}

-(void)setModel:(QueueModel *)model{
    _model = model;

    dispatch_async(dispatch_get_main_queue(), ^{

        UILabel *firstLabel = [self viewWithTag:100];
        UILabel *secLabel = [self viewWithTag:101];

        firstLabel.text = [NSString stringWithFormat:@"%@", model.queue];
        secLabel.text = [NSString stringWithFormat:@"%@/%@号桌",[model judgeDeskCategoryFromString:_model.boardType], model.boardNum];

        switch ([model.isArrive integerValue]) {
            case 1:
            {
                startEatLabel.hidden = YES;
                statusImageV.hidden = YES;
                _timeImageV.hidden = NO;
                _timeLabel.hidden = NO;
                _tiShiLabel.hidden = YES;
                _sureBT.hidden = NO;
                [self startTime];
            }
                break;
            case 2:
            {
                //修改视图
                //分配号码成功之后切换视图
                _tiShiLabel.hidden = NO;
                _sureBT.hidden = YES;
                _timeLabel.hidden = YES;
                _timeImageV.hidden = YES;
                startEatLabel.hidden = YES;
                statusImageV.hidden = YES;

                NSString *deskNum = [NSString stringWithFormat:@"%@%@号",model.boardType, model.boardNum];
                NSString *tempDeskNum = [NSString stringWithFormat:@"请带领客人前往%@桌", deskNum];
                NSMutableAttributedString * str = [[NSMutableAttributedString alloc]initWithString:tempDeskNum];
                NSRange range = [tempDeskNum rangeOfString:deskNum];
                [str addAttribute:NSForegroundColorAttributeName value:UIColorFromRGB(0xfd7577) range:range];
                _tiShiLabel.attributedText = str;

                if (_timer) {
                    dispatch_cancel(_timer);
//                    _timeout = 0;
                }
            }
                break;

            default:
                break;
        }

    });
}
//进行中数据源加载
- (void)getQueueProceingSourceData:(NSString *)type{


    NSString *keyUrl = @"api/merchant/numberQueueManage";
    NSString *storeId = storeID;
    NSString *userId = _BaseModel.id;
    NSString *operation = type;//0 判断是否开启 1 开启排队状态 2确定到店,分配桌号 3 已到店 4 开始用餐  5 员工领号 6 打印领号 7 暂停 8 关闭排队（系统将不再烦好，已放出的排号过号后，可以关闭排号模式）

    NSString *boardType = _model.boardType;
    NSString *queueNum = _model.queueNum;
    NSString *loadUrl = [NSString stringWithFormat:@"%@%@?token=%@&storeId=%@&userId=%@&operation=%@&boardType=%@&queueNum=%@", kBaseURL, keyUrl, TOKEN, storeId, userId, operation, boardType, queueNum];
      
    [[QYXNetTool shareManager] postNetWithUrl:loadUrl urlBody:nil bodyStyle:QYXBodyString header:nil response:QYXJSON success:^(id result) {

        if ([result[@"msgType"] integerValue] == 0) {

            if ([type isEqualToString:@"3"]) {
                //修改视图
                //分配号码成功之后切换视图
                _tiShiLabel.hidden = NO;
                _sureBT.hidden = YES;
                _timeLabel.hidden = YES;
                _timeImageV.hidden = YES;
                NSString *deskNum = [NSString stringWithFormat:@"%@%@号",_model.boardType, _model.boardNum];
                NSString *tempDeskNum = [NSString stringWithFormat:@"请带领客人前往%@桌", deskNum];
                NSMutableAttributedString * str = [[NSMutableAttributedString alloc]initWithString:tempDeskNum];
                NSRange range = [tempDeskNum rangeOfString:deskNum];
                [str addAttribute:NSForegroundColorAttributeName value:UIColorFromRGB(0xfd7577) range:range];
                _tiShiLabel.attributedText = str;

                if (_timer) {
                    dispatch_cancel(_timer);
//                    _timeout = 0;
                }
                if (_sureClickIsArrivedBlock) {
                    _sureClickIsArrivedBlock(YES);
                }
            } else if ([type isEqualToString:@"4"]) {
                if (_startEatingBlock) {
                    _startEatingBlock(YES);
                }
            }
        } else {
            if ([type isEqualToString:@"4"]) {
                if (_startEatingBlock) {
                    _startEatingBlock(YES);
                }
            }
            [SVProgressHUD showErrorWithStatus:@"参数错误"];
        }
    } failure:^(NSError *error) {
        
    }];
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
    if (selected && _tiShiLabel.hidden == NO && statusImageV.hidden == YES) {
        _tiShiLabel.hidden = YES;
        startEatLabel.hidden = NO;
        statusImageV.hidden = NO;
        startEatLabel.text = @"正在用餐";
        statusImageV.image = [UIImage imageNamed:@"黑勾"];
        //
    }
    if (selected && [_model.isArrive isEqualToString:@"2"]) {
        [self getQueueProceingSourceData:@"4"];
    }
}

@end
