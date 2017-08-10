//
//  ServeTableViewCell.m
//  微点筷客商户端
//
//  Created by 张森森 on 16/10/13.
//  Copyright © 2016年 张森森. All rights reserved.
//

#import "ServeTableViewCell.h"

@implementation ServeTableViewCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        CGFloat width = autoScaleW(70);
        CGFloat lineSpace = autoScaleW((self.contentView.size.width - width * 4 - 8 * 2) / 3);
        _firstlabel = [[UILabel alloc]init];
        _firstlabel.font =[UIFont systemFontOfSize:13];
        [self.contentView addSubview:_firstlabel];
        _firstlabel.sd_layout
        .leftSpaceToView(self.contentView,autoScaleW(8))
        .centerYEqualToView(self.contentView)
        .widthIs(width)
        .heightIs(autoScaleH(15));
        
        _secondlabel = [[UILabel alloc]init];
        _secondlabel.font = [UIFont systemFontOfSize:13];
        _secondlabel.textAlignment = NSTextAlignmentCenter;

        [self.contentView addSubview:_secondlabel];
        _secondlabel.sd_layout
        .leftSpaceToView(_firstlabel,lineSpace)
        .centerYEqualToView(self.contentView)
        .widthIs(width)
        .heightIs(autoScaleH(15));
        
        _timelabel = [[UILabel alloc]init];
        _timelabel.font = [UIFont systemFontOfSize:13];
        _timelabel.textColor = RGB(197, 197, 197);
        _timelabel.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:_timelabel];
        _timelabel.sd_layout
        .leftSpaceToView(_secondlabel, lineSpace)
        .centerYEqualToView(self.contentView)
        .widthIs(width)
        .heightIs(autoScaleH(15));
        
        _responseBt = [ButtonStyle buttonWithType:UIButtonTypeCustom];
        [_responseBt setTitle:@"应答" forState:UIControlStateNormal];
        [_responseBt  setTitleColor:UIColorFromRGB(0xfd7577) forState:UIControlStateNormal];
        _responseBt.titleLabel.font = [UIFont systemFontOfSize:13];
        _responseBt.contentMode = UIControlContentHorizontalAlignmentRight;
        _responseBt.titleLabel.textAlignment = NSTextAlignmentRight;
        [self.contentView addSubview:_responseBt];
        [_responseBt addTarget:self action:@selector(responseClick:) forControlEvents:UIControlEventTouchUpInside];
        _responseBt.sd_layout
        .rightSpaceToView(self.contentView,autoScaleW(8))
        .centerYEqualToView(self.contentView)
        .widthIs(width)
        .heightIs(15);


    }
    
    
    return self;
}

- (void)timeRun{
    _beginTime = [_model.timeGap integerValue];
//    NSTimeInterval delayTime = 0.0f;
    //定时器间隔时间
    NSTimeInterval timeInterval = 1.0f;
    //创建子线程队列
    dispatch_queue_t queue = dispatch_queue_create("sceneQueue", DISPATCH_QUEUE_CONCURRENT);
    //使用之前创建的队列来创建计时器
    _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    //设置延时执行时间，delayTime为要延时的秒数
//    dispatch_time_t startDelayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayTime * NSEC_PER_SEC));
    //设置计时器
    dispatch_source_set_timer(_timer, 0, timeInterval * NSEC_PER_SEC, 0.1 * NSEC_PER_SEC);
    dispatch_source_set_event_handler(_timer, ^{
        if (_beginTime > 0) {
            dispatch_async(dispatch_get_main_queue(), ^{
                _timelabel.text = [NSString stringWithFormat:@"等待%lds",(long)_beginTime];
                _beginTime--;
            });

        } else {
            dispatch_source_cancel(_timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                _timelabel.text = @"超时过期";
            });
        }
    });
    // 启动计时器
    dispatch_resume(_timer);

}
-(void)setModel:(SceneInfoModel *)model{
    _model = model;
    [self timeRun];

}
- (void)responseClick:(ButtonStyle *)sender{
//    dispatch_suspend(_timer);
    dispatch_cancel(_timer);

    if (_responseBlock) {
        _responseBlock(_model);
    }
}
- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
