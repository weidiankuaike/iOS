//
//  ZTSelectLabel.m
//  merchantClient
//
//  Created by Skyer God on 2017/7/17.
//  Copyright © 2017年 张甜. All rights reserved.
//

#import "ZTSelectLabel.h"
#import "PMCalendar.h"
#import "CalendarView.h"

@interface ZTSelectLabel ()<PMCalendarControllerDelegate, UIGestureRecognizerDelegate>
/** <#行注释#>   (strong) **/
//@property (nonatomic, strong)  UIImageView *calendarView;
@property (nonatomic, strong) PMCalendarController *pmCC;
/** <#行注释#>   (strong) **/
@property (nonatomic, strong) YYLabel *timeLabel;
/** <#行注释#>   (strong) **/
@property (nonatomic, strong) UIView *showTimeView;
/** <#行注释#>   (strong) **/
@property (nonatomic, strong) UIImageView *calendarView;
/** <#行注释#>   (strong) **/
@property (nonatomic, strong) ButtonStyle *tempButton;
@end
@implementation ZTSelectLabel
{
    NSMutableArray *topTempArr;
    NSMutableArray *bottomTempArr;
    UILabel *topLabel;
    UILabel *bottomLabel;
    UIView *maskView;
    NSArray *timeArr;
    ;
    CalendarView * calend;
    NSDictionary *options;
}
/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */
-(instancetype)initWithTitleArr:(NSArray<NSString *> *)titleArr TopArr:(NSArray<NSString *> *)topArr BottomArr:(NSArray<NSString *> *)bottomArr formatOptions:(NSDictionary *)formatOptions{
    self = [super init];
    if (self) {
        options = formatOptions;
        maskView.hidden = YES;
        maskView.alpha = 0;
        maskView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
        maskView.backgroundColor = RGBA(0, 0, 0, 0.2);
        UITapGestureRecognizer *tapGR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(maskViewTapClick:)];
        tapGR.delegate = self;
        [maskView addGestureRecognizer:tapGR];

        [[UIApplication sharedApplication].keyWindow addSubview:maskView];
        [maskView addSubview:self];

        self.backgroundColor = [UIColor whiteColor];
        self.sd_layout
        .topSpaceToView(maskView, 64)
        .centerXEqualToView(maskView)
        .widthRatioToView(maskView, 1)
        .heightIs(260);

        //初始化视图
        [self setUpWithTopArr:topArr BottomArr:bottomArr WithTitleArr:titleArr];
    }
    return self;
}
- (void)setUpWithTopArr:(NSArray<NSString *> *)topArr BottomArr:(NSArray<NSString *> *)bottomArr WithTitleArr:(NSArray<NSString *> *)titleArr{

    CGFloat start_x = autoScaleW(12);
    CGFloat top_y = autoScaleH(15);
    CGFloat beginWidth = autoScaleW(40);
    CGFloat commanHeight = autoScaleH(30);


    CGFloat topSpace = autoScaleW(20);
    CGFloat bottomSpace = autoScaleW(20);
    CGFloat start_space = autoScaleW(15);
    CGFloat fontSize = autoScaleW(13);
    NSMutableArray *topWidthArr = [NSMutableArray array];
    CGFloat sumOneWidth = 0;
    for (NSInteger i = 0; i < topArr.count; i++) {
        CGSize size = [topArr[i] sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:fontSize],NSFontAttributeName, nil]];
        sumOneWidth += size.width;
        CGFloat perWordWidth = size.width / topArr[i].length;

        if (sumOneWidth / perWordWidth >= 12) {
            topSpace -= perWordWidth / 1.7;
            [topWidthArr addObject:@(size.width + perWordWidth)];
        } else {
            [topWidthArr addObject:@(size.width + perWordWidth * 2)];
        }
    }

    CGFloat sumTwoWidth = 0;
    if (bottomArr != nil || bottomArr.count != 0) {
        for (NSInteger i = 0; i < bottomArr.count; i++) {
            CGSize size = [bottomArr[i] sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:fontSize],NSFontAttributeName, nil]];
            sumTwoWidth += size.width;
            CGFloat perWordWidth = size.width / bottomArr[i].length;

            if (sumTwoWidth / perWordWidth >= 12) {
                bottomSpace -= perWordWidth / 1.7;
                [topWidthArr addObject:@(size.width + perWordWidth)];
            } else {
                [topWidthArr addObject:@(size.width + perWordWidth * 2)];
            }
        }
    }
    if (fabs(topSpace - bottomSpace) < 5) {
        bottomSpace += 8;
    }
    topLabel = [[UILabel alloc] init];
    topLabel.text = titleArr[0];
    topLabel.font = [UIFont systemFontOfSize:autoScaleW(16)];
    [self addSubview:topLabel];



    if (bottomArr != nil || bottomArr.count != 0) {
        top_y = autoScaleH(10);
        if (titleArr[0].length > 2 && titleArr[1].length > 2) {
            beginWidth = autoScaleW(60);
        }
    } else {
        top_y = autoScaleH(15);
        if (titleArr[0].length > 2) {
            beginWidth = autoScaleW(60);
        }
    }

    topLabel.sd_layout
    .leftSpaceToView(self, start_x)
    .topSpaceToView(self, top_y)
    .heightIs(commanHeight)
    .widthIs(beginWidth);

    if (bottomArr != nil || bottomArr.count != 0) {
        bottomLabel = [[UILabel alloc] init];
        bottomLabel.text = titleArr[1];
        bottomLabel.font = topLabel.font;
        [self addSubview:bottomLabel];

        bottomLabel.sd_layout
        .leftEqualToView(topLabel)
        .topSpaceToView(topLabel, autoScaleH(8))
        .widthRatioToView(topLabel, 1)
        .heightRatioToView(topLabel, 1);
    }

    for (NSInteger i = 0; i < topArr.count; i++) {
        CGFloat aveOneWidth = [topWidthArr[i] floatValue];
        CGFloat sumWidth = [[[topWidthArr objectsAtIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, i)]] valueForKeyPath:@"@sum.floatValue"] doubleValue];
        if (i == 0) {
            topTempArr = [NSMutableArray array];
        }
        ButtonStyle * topButton = [ButtonStyle buttonWithType:UIButtonTypeCustom];
        [topButton setTitle:topArr[i] forState:UIControlStateNormal];
        [topButton setTitleColor:UIColorFromRGB(0xfd7577) forState:UIControlStateSelected];
        [topButton setTitleColor:RGB(181, 181, 181) forState:UIControlStateNormal];
        topButton.layer.borderWidth = 1;
        topButton.layer.borderColor = RGB(181, 181, 181).CGColor;
        if (i==0) {
            topButton.selected = YES;
            topButton.layer.borderColor = UIColorFromRGB(0xfd7577).CGColor;
        }
        topButton.tag= 666 + i;
        topButton.titleLabel.font = [UIFont systemFontOfSize:fontSize];
        topButton.layer.masksToBounds = YES;
        topButton.layer.cornerRadius = autoScaleW(3);
        [topButton addTarget:self action:@selector(topButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:topButton];

        topButton.sd_layout
        .leftSpaceToView(topLabel, start_space + i * topSpace + (i== 0 ?:sumWidth))
        .centerYEqualToView(topLabel)
        .widthIs(aveOneWidth)
        .heightIs(commanHeight);

        [topTempArr addObject:topButton];
    }
    if (bottomArr != nil || bottomArr.count != 0) {

        for (NSInteger i = 0; i < bottomArr.count; i++) {
            CGFloat aveTwoWidth = [topWidthArr[i + topArr.count] floatValue];
            CGFloat sumWidth = [[[topWidthArr objectsAtIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(topArr.count, i)]] valueForKeyPath:@"@sum.floatValue"] doubleValue];
            ZTLog(@"%@\n%@",topWidthArr, [topWidthArr objectsAtIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(topArr.count, i)]]);
            if (i == 0) {
                bottomTempArr = [NSMutableArray array];
            }
            ButtonStyle * bottomButton = [ButtonStyle buttonWithType:UIButtonTypeCustom];
            [bottomButton setTitle:bottomArr[i] forState:UIControlStateNormal];
            [bottomButton setTitleColor:UIColorFromRGB(0xfd7577) forState:UIControlStateSelected];
            [bottomButton setTitleColor:RGB(181, 181, 181) forState:UIControlStateNormal];
            bottomButton.layer.borderWidth = 1;
            bottomButton.layer.borderColor = RGB(181, 181, 181).CGColor;
            if (i==0) {
                bottomButton.selected = YES;
                bottomButton.layer.borderColor = UIColorFromRGB(0xfd7577).CGColor;
            }
            bottomButton.tag= 777 + i;
            bottomButton.titleLabel.font = [UIFont systemFontOfSize:fontSize];
            bottomButton.layer.masksToBounds = YES;
            bottomButton.layer.cornerRadius = autoScaleW(3);
            [bottomButton addTarget:self action:@selector(bottonButtonClick:) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:bottomButton];

            bottomButton.sd_layout
            .leftSpaceToView(bottomLabel, start_space + i * bottomSpace + (i== 0 ?:sumWidth))
            .centerYEqualToView(bottomLabel)
            .widthIs(aveTwoWidth)
            .heightIs(commanHeight);

            [bottomTempArr addObject:bottomButton];
        }

    }


    if (bottomArr != nil || bottomArr.count != 0) {
        [self setupAutoHeightWithBottomView:bottomLabel bottomMargin:top_y];
    } else {
        [self setupAutoHeightWithBottomView:topLabel bottomMargin:top_y];
    }
    [self updateLayout];
}
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer{
    CGPoint point = [gestureRecognizer locationInView:maskView];

    if (gestureRecognizer == [maskView.gestureRecognizers lastObject] && CGRectContainsPoint(_calendarView.frame, point) && _calendarView.hidden == NO) {
        return NO;
    }
    return YES;
}
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer{
    return YES;
}
- (void)maskViewTapClick:(UITapGestureRecognizer *)tapGR{
    [self.pmCC.view convertRect:self.pmCC.view.frame toView:maskView];
    if (tapGR.state == UIGestureRecognizerStateEnded) {
        CGPoint point = [tapGR locationInView:maskView];
        UIView *view =  self.pmCC.mainView;
        CGRect rect = CGRectMake(view.origin.x, 64 + view.origin.y, view.width_sd, view.height_sd);
        if (!CGRectContainsPoint(self.frame, point) && !CGRectContainsPoint(rect, point)) {
            [self dismissSelectButtonView];
        }
    }
}
- (void)showSelectButtonView{
    self.sd_layout.topEqualToView(maskView);
    [self updateLayout];
    [[[[(UIButton *)options[ZTTouchObject] viewController] childViewControllers]lastObject] view].frame = CGRectMake(0, self.height_sd, kScreenWidth, kScreenHeight);
    [UIView animateWithDuration:.3f delay:0 options:UIViewAnimationOptionLayoutSubviews animations:^{

    } completion:^(BOOL finished) {
        maskView.hidden = NO;
        maskView.alpha = 1;
        self.sd_layout.topSpaceToView(maskView, 64);
        [self updateLayout];
    }];
}
- (void)dismissSelectButtonView{
    [(UIButton *)options[ZTTouchObject] sendActionsForControlEvents:UIControlEventTouchUpInside]; //同步筛选按钮的点击状态
    [[[[(UIButton *)options[ZTTouchObject] viewController] childViewControllers]lastObject] view].frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
    [UIView animateWithDuration:.3f delay:.3 options:UIViewAnimationOptionCurveEaseOut animations:^{

    } completion:^(BOOL finished) {
        maskView.hidden = YES;
        maskView.alpha = 0;
    }];
}
- (void)topButtonClick:(ButtonStyle *)sender{
    [self dismissSelectButtonView];
    if (_buttonClickBlock) {
        _buttonClickBlock(0, sender.tag - 666, timeArr, sender);
    }
    [topTempArr enumerateObjectsUsingBlock:^(ButtonStyle *button, NSUInteger idx, BOOL * _Nonnull stop) {
        if (button == sender) {
            sender.selected = YES;
            sender.layer.borderColor = UIColorFromRGB(0xfd7577).CGColor;
        } else {
            button.selected = NO;
            button.layer.borderColor = RGB(181, 181, 181).CGColor;
        }
    }];
}
- (void)bottonButtonClick:(ButtonStyle *)sender{
    _tempButton = sender;
    if (![sender.titleLabel.text isEqualToString:@"选择"]) {
        [self dismissSelectButtonView];
        self.pmCC.mainView.hidden = YES;
        _showTimeView.hidden = YES;
        if (_buttonClickBlock) {
            _buttonClickBlock(1, sender.tag - 777, timeArr, sender);
        }
    } else {
        self.pmCC.mainView.hidden = NO;
        _showTimeView.hidden = NO;
    }
    [bottomTempArr enumerateObjectsUsingBlock:^(ButtonStyle *button, NSUInteger idx, BOOL * _Nonnull stop) {
        if (button == sender) {
            sender.selected = YES;
            sender.layer.borderColor = UIColorFromRGB(0xfd7577).CGColor;
        } else {
            button.selected = NO;
            button.layer.borderColor = RGB(181, 181, 181).CGColor;
        }
        if ([sender.titleLabel.text isEqualToString:@"选择"]) {
            [self show_calendarViewWithOptions:options];
            //            [self createPMCalanderView:sender];
        } else {
            _calendarView.hidden = YES;
        }
    }];
}
//创建日历 黑色 多选
- (void)createPMCalanderView:(ButtonStyle *)sender{
    if (self.pmCC == nil) {
        self.pmCC = [[PMCalendarController alloc] initWithThemeName:@"default"];
    }
    _pmCC.delegate = self;
    _pmCC.mondayFirstDayOfWeek = NO;
    [_pmCC presentCalendarFromView:sender permittedArrowDirections:PMCalendarArrowDirectionAny animated:YES];
    _pmCC.mainView.frame = CGRectMake(_pmCC.mainView.origin.x, 64 + _pmCC.mainView.origin.y, _pmCC.mainView.width_sd, _pmCC.mainView.height_sd);
    [maskView addSubview:_pmCC.mainView];

    [self calendarController:_pmCC didChangePeriod:_pmCC.period];

    //添加展示板
    if (_showTimeView == nil) {
        _showTimeView = [UIView new];

    }
    _showTimeView.backgroundColor = RGBA(0, 0, 0, 0.8);
    [maskView addSubview:_showTimeView];

    _showTimeView.sd_layout
    .topSpaceToView(_pmCC.mainView, 0)
    .leftEqualToView(_pmCC.mainView)
    .widthRatioToView(_pmCC.mainView, 0.95)
    .heightIs((autoScaleH(35)));

    if (_timeLabel == nil) {
        _timeLabel = [YYLabel new];
    }
    _timeLabel.font = [UIFont systemFontOfSize:16];
    _timeLabel.textAlignment = NSTextAlignmentCenter;
    _timeLabel.textColor = [UIColor whiteColor];
    CGFloat padding = 10;
    _timeLabel.textContainerInset = UIEdgeInsetsMake(padding, padding, padding, padding);
    [_showTimeView addSubview:_timeLabel];

    _timeLabel.sd_layout
    .topSpaceToView(_showTimeView, 0)
    .leftEqualToView(_showTimeView)
    .widthRatioToView(_showTimeView, 1)
    .heightIs(autoScaleH(25));

    ButtonStyle *cancelButon = [ButtonStyle buttonWithType:UIButtonTypeCustom];
    [cancelButon setTitle:@"取消" forState:UIControlStateNormal];
    cancelButon.tag = 100;
    [_showTimeView addSubview:cancelButon];

    ButtonStyle *confirmButton = [ButtonStyle buttonWithType:UIButtonTypeCustom];
    [confirmButton setTitle:@"确定" forState:UIControlStateNormal];
    confirmButton.tag = 101;
    [_showTimeView addSubview:confirmButton];

    [cancelButon addTarget:self action:@selector(confirmOrCancelClick:) forControlEvents:UIControlEventTouchUpInside];
    [confirmButton addTarget:self action:@selector(confirmOrCancelClick:) forControlEvents:UIControlEventTouchUpInside];

    cancelButon.sd_layout
    .leftSpaceToView(_showTimeView, padding)
    .topSpaceToView(_timeLabel, padding / 2)
    .widthIs(autoScaleW(60))
    .heightIs(autoScaleH(30));

    confirmButton.sd_layout
    .rightSpaceToView(_showTimeView, padding)
    .topEqualToView(cancelButon)
    .widthRatioToView(cancelButon, 1)
    .heightRatioToView(cancelButon, 1);

    [_showTimeView setupAutoHeightWithBottomView:confirmButton bottomMargin:padding];

    [_showTimeView setSd_cornerRadiusFromHeightRatio:@(0.2)];

}
- (void)confirmOrCancelClick:(ButtonStyle *)sender{
    if (sender.tag == 101) {
        if (_buttonClickBlock) {
            _buttonClickBlock(1, 3, timeArr, self.tempButton);
        }
    }
    [self dismissSelectButtonView];
}
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

#pragma mark PMCalendarControllerDelegate methods

- (void)calendarController:(PMCalendarController *)calendarController didChangePeriod:(PMPeriod *)newPeriod
{

    timeArr = @[[newPeriod.startDate dateStringWithFormat:@"yyyy-MM-dd"], [newPeriod.endDate dateStringWithFormat:@"yyyy-MM-dd"]];
    [self showMessage:[NSString stringWithFormat:@"%@ - %@" , [newPeriod.startDate dateStringWithFormat:@"yyyy-MM-dd"] , [newPeriod.endDate dateStringWithFormat:@"yyyy-MM-dd"]]];


}
- (void)showMessage:(NSString *)msg {



    _timeLabel.text = msg;
    _showTimeView.alpha = 0;
    [UIView animateWithDuration:0.3 animations:^{

    } completion:^(BOOL finished) {
        _showTimeView.alpha = 1;
    }];
}

//创建日历  森森
- (void)show_calendarViewWithOptions:(NSDictionary *)formatOptions{

    if (_calendarView == nil) {
        _calendarView = [[UIImageView alloc]init];
    }
    _calendarView.userInteractionEnabled = YES;
    _calendarView.image = [UIImage imageNamed:@"日历边框"];
    [maskView addSubview:_calendarView];

    _calendarView.hidden = NO;
    _calendarView.sd_layout
    .centerXEqualToView(maskView)
    .topSpaceToView(self, 1)
    .widthIs(kScreenWidth-autoScaleW(50))
    .heightIs(autoScaleH(400));


    if (calend == nil) {
        calend = [[CalendarView alloc]initWithStyle:(formatOptions == nil ? 1 : [formatOptions[SSCalendarType] integerValue])];
    }
    __weak typeof(self) weakSelf = self;
    calend.block = ^(NSString * lstring,NSString* rstring,NSString* choosestr) {
        if ([choosestr isEqualToString:@"sure"] || [choosestr isEqualToString:@"remove"]) {
            weakSelf.calendarView.hidden = YES;
            if (weakSelf.buttonClickBlock) {
                weakSelf.buttonClickBlock(1, 3, @[lstring, rstring], weakSelf.tempButton);
            }
            [weakSelf dismissSelectButtonView];
        }
    };
    calend.layer.masksToBounds = YES;
    calend.layer.cornerRadius = 3;
    calend.backgroundColor = [UIColor whiteColor];
    [_calendarView addSubview:calend];

    calend.sd_layout
    .leftSpaceToView(_calendarView,autoScaleW(2))
    .topSpaceToView(_calendarView,autoScaleH(12))
    .widthIs(_calendarView.width_sd - autoScaleW(4))
    .heightIs(autoScaleH(375));
    [calend updateLayout];
}

@end
