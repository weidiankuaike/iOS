//
//  ZT_TimerPickerView_Double.m
//  微点筷客商户端
//
//  Created by Skyer God on 16/12/2.
//  Copyright © 2016年 张森森. All rights reserved.
//

#define ZTMainScreen  [UIScreen mainScreen].bounds


#import "ZT_TimerPickerView_Double.h"

@interface ZT_TimerPickerView_Double ()<UIPickerViewDelegate, UIPickerViewDataSource>
@property (nonatomic, copy) NSString *startTime;
@end
@implementation ZT_TimerPickerView_Double
{

    UIPickerView * _pickerView;


    NSInteger dayRange;
    NSInteger selectedYear;
    NSInteger selectedMonth;
    NSInteger selectedDay;
    NSCalendar *calendar;

    UIView *backView;
    UIView *maskView;


    NSInteger currentYear;
    NSInteger currentMonth;
    NSInteger currentDay;
    NSInteger oldDateRange;
    NSString *string;

    NSMutableArray *tempMonthArr ;
    NSInteger tempYear;
}

- (instancetype)initWithStartTime:(NSString *)startTime
{
    self = [super init];
    if (self) {
        tempYear = 0;
        _startTime = startTime;
        maskView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
        maskView.backgroundColor = RGBA(0, 0, 0, 0.3);
        [[UIApplication sharedApplication].keyWindow addSubview:maskView];
        tempMonthArr = [NSMutableArray array];
        self.backgroundColor = [UIColor clearColor];
        self.frame = maskView.frame;
        [maskView addSubview:self];
        [self createUI];

    }
    return self;
}
-(void)createUI{

    // 背景白色View

    backView = [[UIView alloc] init];
    backView.backgroundColor=RGB(238, 238, 238);

    backView.layer.cornerRadius=10;

    [self addSubview:backView];

    backView.sd_layout
    .centerXEqualToView(self)
    .centerYEqualToView(self)
    .widthRatioToView(self, 0.7);


    /** 完成按钮 **/
    _cancelBT = [ButtonStyle buttonWithType:UIButtonTypeCustom];
    [_cancelBT setTitle:@"取消" forState:UIControlStateNormal];
    [_cancelBT setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [_cancelBT.titleLabel setFont:[UIFont systemFontOfSize:autoScaleW(15)]];
    [_cancelBT addTarget:self action:@selector(cancelAction) forControlEvents:UIControlEventTouchUpInside];
    [backView addSubview:_cancelBT];

    /** 添加按钮 **/
    _addBT = [ButtonStyle buttonWithType:UIButtonTypeCustom];
    [_addBT setTitle:@"确认" forState:UIControlStateNormal];
    [_addBT.titleLabel setFont:_cancelBT.titleLabel.font];
    [_addBT setTitleColor:UIColorFromRGB(0xfd7577) forState:UIControlStateNormal];
    [_addBT addTarget:self action:@selector(addClick) forControlEvents:UIControlEventTouchUpInside];
    [backView addSubview:_addBT];

    /** 中间标题按钮 **/

    _titleLabel=[[UILabel alloc]init];

    _titleLabel.text=@"设置优惠开始时间";
    _titleLabel.font = _cancelBT.titleLabel.font;
    _titleLabel.textColor=UIColorFromRGB(0x383838);
    _titleLabel.adjustsFontSizeToFitWidth = YES;
    _titleLabel.textAlignment=NSTextAlignmentCenter;

    [backView addSubview:_titleLabel];

    /** 标题提示 **/

    _littleTitle = [[UILabel alloc] init];
    _littleTitle.text = @"当前时间";
    _littleTitle.font = [UIFont systemFontOfSize:autoScaleW(12)];
    _littleTitle.textColor = [UIColor lightGrayColor];
    _littleTitle.textAlignment = NSTextAlignmentCenter;
    _littleTitle.hidden = NO;
    [backView addSubview:_littleTitle];


    _cancelBT.sd_layout
    .leftSpaceToView(backView, 10)
    .topSpaceToView(backView, 15);
    [_cancelBT setupAutoSizeWithHorizontalPadding:1 buttonHeight:20];

    _addBT.sd_layout
    .topEqualToView(_cancelBT)
    .rightSpaceToView(backView, 10);
    [_addBT setupAutoSizeWithHorizontalPadding:1 buttonHeight:20];

    _titleLabel.sd_layout
    .centerXEqualToView(backView)
    .topSpaceToView(_cancelBT, -10)
    .heightIs(20);
    [_titleLabel setSingleLineAutoResizeWithMaxWidth:120];

    _littleTitle.sd_layout
    .centerXEqualToView(_titleLabel)
    .topSpaceToView(_titleLabel, 0)
    .heightIs(20);
    [_littleTitle setSingleLineAutoResizeWithMaxWidth:120];

    //类型和编号

    _categortyLabel=[[UILabel alloc]init];

    _categortyLabel.font=[UIFont systemFontOfSize:autoScaleW(14)];

    _categortyLabel.textColor=UIColorFromRGB(0x383838);
    _categortyLabel.text = @"月份";
    _categortyLabel.textAlignment=NSTextAlignmentCenter;
    [backView addSubview:_categortyLabel];

    [backView updateLayout];
    CGFloat start_x = backView.width_sd / 6;
    _categortyLabel.sd_layout
    .leftSpaceToView(backView, start_x)
    .topSpaceToView(_littleTitle, 1)
    .widthIs(50)
    .heightIs(15);

    _numLabel=[[UILabel alloc]init];

    _numLabel.font=_categortyLabel.font;
    _numLabel.text = @"天数";
    _numLabel.textColor=UIColorFromRGB(0x383838);

    _numLabel.textAlignment=NSTextAlignmentCenter;

    [backView addSubview:_numLabel];

    _numLabel.sd_layout
    .rightSpaceToView(backView, start_x)
    .topEqualToView(_categortyLabel)
    .widthRatioToView(_categortyLabel, 1)
    .heightIs(15);


    NSCalendar *calendar0 = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    NSInteger unitFlags =  NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute;
    comps = [calendar0 components:unitFlags fromDate:[NSDate date]];

    if (![_startTime containsString:@"-"]) {
        currentYear = comps.year;
        currentMonth = comps.month;
        currentDay = comps.day;
        oldDateRange = dayRange;

        selectedYear=comps.year;
        selectedMonth=comps.month;
        selectedDay=comps.day ;
        dayRange=[self isAllDay:selectedYear andMonth:comps.month];
    } else {
        NSArray *startCompsArr = [_startTime componentsSeparatedByString:@"-"];
        currentYear = [startCompsArr[0] integerValue];
        currentMonth = [startCompsArr[1] integerValue];
        currentDay = [startCompsArr[2] integerValue];
        oldDateRange = dayRange;

        selectedYear=[startCompsArr[0] integerValue];
        selectedMonth=[startCompsArr[1] integerValue];
        selectedDay=[startCompsArr[2] integerValue] ;
        dayRange=[self isAllDay:selectedYear andMonth:comps.month];
    }


    for (NSInteger i = 0; i < 12; i++) {
        NSInteger temp = i + selectedMonth;
        if (temp >12) {
            temp -=12;
        }
        [tempMonthArr addObject:@(temp)];
    }
    ZTLog(@"%@", tempMonthArr);

    //  选择类型
    [_categortyLabel updateLayout];
    _pickerView=[[UIPickerView alloc]initWithFrame:CGRectMake(0, _categortyLabel.origin_sd.y + _categortyLabel.height_sd, backView.width_sd, 120)];

    _pickerView.delegate=self;

    _pickerView.dataSource=self;

    _pickerView.showsSelectionIndicator = YES;

    _pickerView.backgroundColor= RGB(238, 238, 238);
    [backView addSubview:_pickerView];

//    [backView updateLayout];
//    _pickerView.sd_layout
//    .centerXEqualToView(backView)
//    .heightIs(240)
//    .widthRatioToView(backView, 0.9)
//    .topSpaceToView(_categortyLabel, 5);

    [backView setupAutoHeightWithBottomView:_pickerView bottomMargin:10];
    [_pickerView selectRow:0 inComponent:0 animated:true];
    [_pickerView selectRow:selectedDay - 1 inComponent:1 animated:true];
    [_pickerView reloadAllComponents];
       string = [NSString stringWithFormat:@"%ld-%.2ld-%.2ld",(long)selectedYear,selectedMonth==0?12:selectedMonth,selectedDay];
    _littleTitle.text = string;

}
#pragma mark --
#pragma mark -- UIPickerViewDataSource
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 2;
}
//确定每一列返回的东西
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    switch (component) {
        case 0:
        {
            return tempMonthArr.count;
        }
            break;
        case 1:
        {
            return dayRange;
        }
            break;
        default:
            break;
    }
    return 0;
}
#pragma mark -- UIPickerViewDelegate
- (nullable NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    if (component == 0) {
        return [NSString stringWithFormat:@"%@月",tempMonthArr[row]];
    } else {
        return [NSString stringWithFormat:@"%ld日",(long)row + 1];
    }
}
-(UIView*)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UILabel *)recycledLabel
{
    UILabel*label= (UILabel *)recycledLabel;
    if (!label) {
        label = [[UILabel alloc] initWithFrame:CGRectZero];
        label.textColor = [UIColor blackColor];
    }
    label.font=[UIFont systemFontOfSize:15.0];
    label.textAlignment=NSTextAlignmentCenter;
    switch (component) {
        case 0:
        {
//            label.backgroundColor = [UIColor purpleColor];
//            label.frame=CGRectMake(0, 0, kScreenWidth/4.0, 30);
            label.text=[NSString stringWithFormat:@"%@月",tempMonthArr[row]];
        }
            break;
        case 1:
        {
//            label.backgroundColor = [UIColor redColor];
//            label.frame=CGRectMake(kScreenWidth*3/8, 0, kScreenWidth/4.0, 30);
            label.text=[NSString stringWithFormat:@"%ld日",(long)row + 1];
        }
            break;
        default:
            break;
    }
    return label;
}
// 监听picker的滑动

- (void)pickerView:(UIPickerView *)pickerView
      didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    switch (component) {
        case 0:
        {
//            ZTLog(@"row-%ld %ld", row, selectedMonth);
            selectedMonth = [tempMonthArr[row] integerValue];
            oldDateRange = dayRange;
            tempYear = 0;
            if (selectedMonth < [tempMonthArr[0] integerValue]) {
                tempYear = selectedYear + 1;
            } else {
                tempYear = selectedYear;
            }
            if (selectedMonth == 0) {
                dayRange = [self isAllDay:selectedYear andMonth:12];
            } else {
                dayRange=[self isAllDay:selectedYear andMonth:selectedMonth];
                [_pickerView reloadComponent:1];
            }

        }
            break;
        case 1:
        {
            selectedDay=row + 1;
        }
            break;
        default:
            break;
    }

    //限制天数选择范围
    if (selectedYear >= currentYear) {
        if (selectedMonth == currentMonth) {
            if (currentDay  > selectedDay) {
                [pickerView selectRow:currentDay - 1  inComponent:1 animated:YES];
                selectedDay = currentDay;

            }
        }
    }

    //必须处理每个月最后一天
//    if (oldDateRange > dayRange && selectedDay == oldDateRange) {
//        selectedDay = dayRange;
//    } else if (oldDateRange < dayRange && selectedDay == dayRange) {
//        selectedDay = oldDateRange;
//    } else;

    tempYear = 0;
    if (selectedMonth < [tempMonthArr[0] integerValue]) {
        tempYear = selectedYear + 1;
    } else {
        tempYear = selectedYear;
    }
    if (selectedDay > dayRange) {
        selectedDay = dayRange;
    }
    string = [NSString stringWithFormat:@"%ld-%.2ld-%.2ld",(long)tempYear,selectedMonth,selectedDay];
    _littleTitle.text = string;

}


-(NSInteger)isAllDay:(NSInteger)year andMonth:(NSInteger)month
{
    int day=0;
    switch(month)
    {
        case 1:
        case 3:
        case 5:
        case 7:
        case 8:
        case 10:
        case 12:
            day=31;
            break;
        case 4:
        case 6:
        case 9:
        case 11:
            day=30;
            break;
        case 2:
        {
            if(((year%4==0)&&(year%100!=0))||(year%400==0))
            {
                day=29;
                break;
            }
            else
            {
                day=28;
                break;
            }
        }
        default:
            break;
    }
    return day;
}

#pragma mark -- 基础处理 －－－轻易不动 －－!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!-------------!!!!!!!!!!!!!!!!!!!!!!!!!!
- (void)showView{
    maskView.alpha = 0;
    [UIView animateWithDuration:.355 animations:^{
        maskView.alpha = 1;
        maskView.hidden = NO;
    }];

}

- (void)dismiss{
    [maskView removeFromSuperview];
    [UIView animateWithDuration:.35 animations:^{
        maskView.alpha = 0;
        maskView.hidden = YES;
    }];
}
- (void)cancelAction{
    [self dismiss];
}
- (void)addClick{
    string = [NSString stringWithFormat:@"%ld-%.2ld-%.2ld",(long)(tempYear != 0 ? tempYear : selectedYear),selectedMonth==0?12:selectedMonth,selectedDay];
    if (_returnSelectDate) {
        _returnSelectDate(string);
    }
    [self dismiss];
}
@end
