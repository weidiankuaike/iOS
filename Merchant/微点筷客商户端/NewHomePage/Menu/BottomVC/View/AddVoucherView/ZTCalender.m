//
//  ZTCalender.m
//  Clendar
//
//  Created by Skyer God on 16/10/25.
//  Copyright © 2016年 weiDianKuaiKe. All rights reserved.
//

#import "ZTCalender.h"
#define screenWith  [UIScreen mainScreen].bounds.size.width
#define screenHeight [UIScreen mainScreen].bounds.size.height
@interface ZTCalender ()<UIPickerViewDelegate, UIPickerViewDataSource>
{
    NSInteger yearRange;
    NSInteger dayRange;
    NSInteger startYear;
    NSInteger selectedYear;
    NSInteger selectedMonth;
    NSInteger selectedDay;
    NSInteger selectedHour;
    NSInteger selectedMinute;
    NSInteger selectedSecond;
    NSCalendar *calendar;

    NSInteger endStartYear;
    NSInteger endYear;
    NSInteger endMonth;
    NSInteger endDay;


    //左边退出按钮
    ButtonStyle *cancelButton;
    //右边的确定按钮
    ButtonStyle *chooseButton;
}
@property (nonatomic, copy) NSArray *selectedArray;
@property (nonatomic, strong) UIPickerView *pickerView;
@property (nonatomic,strong) NSString *string;
@end

@implementation ZTCalender
- (id)init {
    if (self = [super init]) {

        //盛放按钮的View
        UIView *upVeiw = [[UIView alloc]initWithFrame:CGRectMake(-2, 0, [UIScreen mainScreen].bounds.size.width+4, 82)];
        upVeiw.backgroundColor = RGBA(238, 238, 238, 1);
        [self addSubview:upVeiw];
        //左边的取消按钮
        cancelButton = [ButtonStyle buttonWithType:UIButtonTypeCustom];
        cancelButton.frame = CGRectMake(12, 0, 40, 40);
        [cancelButton setTitle:@"取消" forState:UIControlStateNormal];
        [cancelButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        [cancelButton addTarget:self action:@selector(hiddenPickerView) forControlEvents:UIControlEventTouchUpInside];
        [upVeiw addSubview:cancelButton];

        //右边的确定按钮
        chooseButton = [ButtonStyle buttonWithType:UIButtonTypeCustom];
        chooseButton.frame = CGRectMake([UIScreen mainScreen].bounds.size.width - 50, 0, 40, 40);
        [chooseButton setTitle:@"确定" forState:UIControlStateNormal];
        [chooseButton setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
        [chooseButton addTarget:self action:@selector(hiddenPickerViewRight) forControlEvents:UIControlEventTouchUpInside];
        [upVeiw addSubview:chooseButton];
        //中间标题
        UILabel *titleLabel = [[UILabel alloc] init];
        titleLabel.text = @"设置优惠时间段";
        titleLabel.font = [UIFont systemFontOfSize:14];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        [upVeiw addSubview:titleLabel];

        UILabel *separatorLine = [[UILabel alloc] init];
        separatorLine.backgroundColor = [UIColor lightGrayColor];
        [upVeiw addSubview:separatorLine];

        UILabel *leftTitleLabel = [[UILabel alloc] init];
        leftTitleLabel.text = @"起始时间";
        leftTitleLabel.font = [UIFont systemFontOfSize:14];
        [upVeiw addSubview:leftTitleLabel];

        UILabel *rightTitleLabel = [[UILabel alloc] init];
        rightTitleLabel.text = @"截止时间";
        rightTitleLabel.font = leftTitleLabel.font;
        [upVeiw addSubview:rightTitleLabel];

        UILabel *bottomSeparator = [[UILabel alloc] init];
        bottomSeparator.backgroundColor = separatorLine.backgroundColor;
        [upVeiw addSubview:bottomSeparator];

        titleLabel.sd_layout
        .leftSpaceToView(cancelButton, 0)
        .topEqualToView(cancelButton)
        .rightSpaceToView(chooseButton, 0)
        .bottomEqualToView(cancelButton);

        separatorLine.sd_layout
        .leftEqualToView(upVeiw)
        .topSpaceToView(titleLabel, 0)
        .rightEqualToView(upVeiw)
        .heightIs(1);

        leftTitleLabel.sd_layout
        .centerXIs(upVeiw.center.x / 2)
        .topSpaceToView(separatorLine, 0)
        .heightIs(40);
        [leftTitleLabel setSingleLineAutoResizeWithMaxWidth:100];

        rightTitleLabel.sd_layout
        .centerXIs(upVeiw.center.x + upVeiw.center.x / 2)
        .topEqualToView(leftTitleLabel)
        .heightIs(40);
        [rightTitleLabel setSingleLineAutoResizeWithMaxWidth:100];

        bottomSeparator.sd_layout
        .leftEqualToView(separatorLine)
        .topSpaceToView(rightTitleLabel, 0)
        .rightEqualToView(separatorLine)
        .heightIs(1);

        self.pickerView = [[UIPickerView alloc]initWithFrame:CGRectMake(0, 82, [UIScreen mainScreen].bounds.size.width, 180)];
        self.pickerView.backgroundColor = RGBA(238, 238, 238, 1);
        self.pickerView.dataSource=self;
        self.pickerView.delegate=self;
        [self addSubview:self.pickerView];


        NSCalendar *calendar0 = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
        NSDateComponents *comps = [[NSDateComponents alloc] init];
        NSInteger unitFlags =  NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute;
        comps = [calendar0 components:unitFlags fromDate:[NSDate date]];
        NSInteger year=[comps year];

        startYear=year-1;
        endStartYear = year;

        yearRange=30;
        selectedYear=2016;
        selectedMonth=1;
        selectedDay=1;
        endYear =2016;
        endMonth = 1;
        endDay = 1;
        dayRange=[self isAllDay:startYear andMonth:1];
        [self hiddenPickerView];
        _string =[NSString stringWithFormat:@"%ld.%.2ld.%.2ld - %ld.%.2ld.%.2ld",(long)selectedYear,selectedMonth,selectedDay,endYear,endMonth,endDay];
    }
    return self;
}
#pragma mark --
#pragma mark -- UIPickerViewDataSource
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 7;
}
//确定每一列返回的东西
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    switch (component) {
        case 0:
        {
            return yearRange;
        }
            break;
        case 1:
        {
            return 12;
        }
            break;
        case 2:
        {
            return dayRange;
        }
            break;
        case 3:
        {
            return 1;
        }
            break;
        case 4:
        {
            return yearRange;
        }
            break;
        case 5:
        {
            return 12;
        }
            break;
        case 6:
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
//默认时间的处理
-(void)setCurDate:(NSDate *)curDate
{
    //获取当前时间
    NSCalendar *calendar0 = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    NSInteger unitFlags =  NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute;
    comps = [calendar0 components:unitFlags fromDate:[NSDate date]];
    NSInteger year=[comps year];
    NSInteger month=[comps month];
    NSInteger day=[comps day];
    NSInteger hour=[comps hour];


    selectedYear=year;
    selectedMonth=month;
    selectedDay=day;


    dayRange=[self isAllDay:year andMonth:month];

    [self.pickerView selectRow:year-startYear inComponent:0 animated:true];
    [self.pickerView selectRow:month-1 inComponent:1 animated:true];
    [self.pickerView selectRow:day-1 inComponent:2 animated:true];
    [self.pickerView selectRow:hour inComponent:3 animated:true];
    [self.pickerView selectRow:year-startYear inComponent:4 animated:true];
    [self.pickerView selectRow:month-1 inComponent:5 animated:true];
    [self.pickerView selectRow:day-1 inComponent:6 animated:true];


    [self.pickerView reloadAllComponents];
}
-(UIView*)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    UILabel*label=[[UILabel alloc]initWithFrame:CGRectMake(screenWith*component/6.0, 0,screenWith/6.0, 30)];
    label.font=[UIFont systemFontOfSize:15.0];
    label.tag=component*100+row;
    label.textAlignment=NSTextAlignmentCenter;
    switch (component) {
        case 0:
        {
            label.frame=CGRectMake(5, 0,screenWith/4.0, 30);
            label.text=[NSString stringWithFormat:@"%ld年",(long)(startYear + row)];
        }
            break;
        case 1:
        {
            label.frame=CGRectMake(screenWith/4.0, 0, screenWith/8.0, 30);
            label.text=[NSString stringWithFormat:@"%ld月",(long)row+1];
        }
            break;
        case 2:
        {
            label.frame=CGRectMake(screenWith*3/8, 0, screenWith/8.0, 30);
            label.text=[NSString stringWithFormat:@"%ld日",(long)row+1];
        }
            break;
        case 3:
        {
            label.textAlignment=NSTextAlignmentCenter;
            label.text=@"--";
        }
            break;
        case 4:
        {
            label.frame=CGRectMake(5, 0,screenWith/4.0, 30);
            label.text=[NSString stringWithFormat:@"%ld年",(long)(startYear + row)];
        }
            break;
        case 5:
        {
            label.frame=CGRectMake(screenWith/4.0, 0, screenWith/8.0, 30);
            label.text=[NSString stringWithFormat:@"%ld月",(long)row+1];
        }
            break;
        case 6:{
            label.frame=CGRectMake(screenWith*3/8, 0, screenWith/8.0, 30);
            label.text=[NSString stringWithFormat:@"%ld日",(long)row+1];
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
            selectedYear=startYear + row;
            dayRange=[self isAllDay:selectedYear andMonth:selectedMonth];
            [self.pickerView reloadComponent:2];
        }
            break;
        case 1:
        {
            selectedMonth=row+1;
            dayRange=[self isAllDay:selectedYear andMonth:selectedMonth];
            [self.pickerView reloadComponent:2];
        }
            break;
        case 2:
        {
            selectedDay=row+1;
        }
            break;
        case 3:
        {
            selectedHour=1;
        }
            break;
        case 4:
        {
            endYear=startYear + row;
            dayRange=[self isAllDay:endYear andMonth:endMonth];
            [self.pickerView reloadComponent:2];
        }
            break;
        case 5:{
            endMonth=row+1;
            dayRange=[self isAllDay:endYear andMonth:endMonth];
            [self.pickerView reloadComponent:6];
        }
            break;
        case 6:{
            endDay=row+1;
        }

        default:
            break;
    }

    _string =[NSString stringWithFormat:@"%ld.%.2ld.%.2ld - %ld.%.2ld.%.2ld",(long)selectedYear,selectedMonth,selectedDay,endYear,endMonth,endDay];

}


#pragma mark -- show and hidden
- (void)showInView:(UIView *)view {

    [UIView animateWithDuration:0.7f animations:^{
        self.frame = CGRectMake(0, view.frame.size.height-200, view.frame.size.width, 800);
        // self.backgroundColor = [UIColor redColor];
    } completion:^(BOOL finished) {
        //self.frame = CGRectMake(0, view.frame.size.height-200, view.frame.size.width, 200);
    }];
}
//隐藏View
//取消的隐藏
- (void)hiddenPickerView
{
    [UIView animateWithDuration:0.7f animations:^{
        self.frame = CGRectMake(0, self.frame.origin.y + self.frame.size.height, self.frame.size.width, self.frame.size.height);
    } completion:^(BOOL finished) {
        // self.frame = CGRectMake(0, self.frame.origin.y + self.frame.size.height, self.frame.size.width, self.frame.size.height);
    }];

}
//确认的隐藏
-(void)hiddenPickerViewRight
{
    [UIView animateWithDuration:0.7f animations:^{
        self.frame = CGRectMake(0, self.frame.origin.y + self.frame.size.height, self.frame.size.width, self.frame.size.height);
    } completion:^(BOOL finished) {
        // self.frame = CGRectMake(0, self.frame.origin.y + self.frame.size.height, self.frame.size.width, self.frame.size.height);
    }];
    if ([self.delegate respondsToSelector:@selector(didFinishPickView:)]) {
        [self.delegate didFinishPickView:_string];
    }

}
- (NSArray *)selectedArray {
    if (!_selectedArray) {
        self.selectedArray = [@[] mutableCopy];
    }
    return _selectedArray;
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

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
