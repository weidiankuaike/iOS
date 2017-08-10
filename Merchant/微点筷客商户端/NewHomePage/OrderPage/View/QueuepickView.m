//
//  QueuepickView.m
//  微点筷客商户端
//
//  Created by 张森森 on 16/12/2.
//  Copyright © 2016年 张森森. All rights reserved.
//
#define selfGreen [UIColor colorWithRed:69/255.0 green:181/255.0 blue:55/255.0 alpha:0.8]
//iPhone 6
#define self6WidthRate [UIScreen mainScreen].bounds.size.width/375.0

#define selfBacground [UIColor colorWithRed:240/255.0 green:240/255.0 blue:240/255.0 alpha:1.0]

#define selfWidth [UIScreen mainScreen].bounds.size.width

#define selfHeight [UIScreen mainScreen].bounds.size.height

#define selfWidthRate [UIScreen mainScreen].bounds.size.width/320.0

#define selfHeightRate [UIScreen mainScreen].bounds.size.height/568.0

#define self6WidthRate [UIScreen mainScreen].bounds.size.width/375.0

#define self6HeightRate [UIScreen mainScreen].bounds.size.height/667.0

#define XMRECT6(rect) CGRectMake(rect.origin.x*self6WidthRate, rect.origin.y*self6HeightRate, rect.size.width*self6WidthRate, rect.size.height*self6HeightRate)

#define XMRECT(rect) CGRectMake(rect.origin.x*selfWidthRate, rect.origin.y*selfHeightRate, rect.size.width*selfWidthRate, rect.size.height*selfHeightRate)
#import "QueuepickView.h"

@implementation QueuepickView
{
    NSArray * hoursary;
    UIPickerView * centerPickview;
    UIView * timeview;
    NSInteger left0_row;
}

-(instancetype)init{
    
    self=[super init];
    
    if (self) {
        
       hoursary=@[@"10秒",@"20秒",@"30秒",@"40秒",@"50秒",@"60秒",@"70秒",@"80秒",@"90秒"];
        
        
        self.frame=CGRectMake(0, kScreenWidth, kScreenWidth, kScreenHeight-64);
        
        [self createUI];
    }
    
    return self;
    
}
-(void)createUI
{
    
    // 背景白色View
    
    UIView * white_view=[[UIView alloc]init];
    
    white_view.frame = CGRectMake(0, 0, kScreenWidth, autoScaleH(250));
    white_view.backgroundColor=[UIColor whiteColor];
    
    white_view.layer.cornerRadius=10;
    
    [self addSubview:white_view];
    
    //选择时间标题
    
    UILabel * title_label=[[UILabel alloc]initWithFrame:XMRECT6(CGRectMake((275-130)/2, 21, 150, 30))];
    
    title_label.text=@"叫号等待时间";
    
    title_label.textColor=UIColorFromRGB(0x383838);
    
    title_label.textAlignment=NSTextAlignmentCenter;
    
    [white_view addSubview:title_label];
    
//    NSLog(@"winddddd%f",self.frame.size.width);
    centerPickview = [[UIPickerView alloc]init];
    centerPickview.delegate = self;
    centerPickview.dataSource = self;
    centerPickview.backgroundColor=UIColorFromRGB(0xfbfbfb);
    [white_view addSubview:centerPickview];
    centerPickview.sd_layout.centerXEqualToView (white_view).centerYEqualToView(white_view).widthIs(white_view.frame.size.width).heightIs(white_view.frame.size.height-title_label.frame.size.height);
    
    ButtonStyle * quxiaobtn = [ButtonStyle buttonWithType:UIButtonTypeCustom];
    [quxiaobtn setTitleColor:UIColorFromRGB(0xfd7577) forState:UIControlStateNormal];
    quxiaobtn.titleLabel.font = [UIFont systemFontOfSize:autoScaleW(13)];
    [quxiaobtn setTitle:@"取消" forState:UIControlStateNormal];
    [quxiaobtn addTarget:self action:@selector(cancel) forControlEvents:UIControlEventTouchUpInside];
    [white_view addSubview:quxiaobtn];
    quxiaobtn.sd_layout.leftSpaceToView(white_view,autoScaleW(15)).topSpaceToView(white_view,autoScaleH(15)).widthIs(autoScaleW(30)).heightIs(autoScaleH(15));
    
    ButtonStyle * quedingbtn = [ButtonStyle buttonWithType:UIButtonTypeCustom];
    [quedingbtn setTitleColor:UIColorFromRGB(0xfd7577) forState:UIControlStateNormal];
    quedingbtn.titleLabel.font = [UIFont systemFontOfSize:autoScaleW(13)];
    [quedingbtn setTitle:@"确定" forState:UIControlStateNormal];
    [quedingbtn addTarget:self action:@selector(timeClick) forControlEvents:UIControlEventTouchUpInside];
    [white_view addSubview:quedingbtn];
    quedingbtn.sd_layout.rightSpaceToView(white_view,autoScaleW(15)).topSpaceToView(white_view,autoScaleH(15)).widthIs(autoScaleW(30)).heightIs(autoScaleH(15));
    
}
-(void)cancel{
    
    [timeview removeFromSuperview];
    
}
-(void)timeClick{
    
    
    [self time];
    
    
    [timeview removeFromSuperview];
}
-(void)showTime{

    UIWindow * window=[UIApplication sharedApplication].keyWindow;
    timeview = [[UIView alloc]init];
    timeview.backgroundColor = RGBA(0, 0, 0, 0.3);
    [window addSubview:timeview];
    timeview.sd_layout.leftSpaceToView(window,0).topSpaceToView(window,0).widthIs(kScreenWidth).heightIs(kScreenHeight);
    [timeview addSubview:self];
    self.sd_layout.leftSpaceToView(timeview,0).bottomSpaceToView(timeview,0).widthIs(kScreenWidth).heightIs(autoScaleH(250));
    timeview.alpha = 0;
    [UIView animateWithDuration:0.3 animations:^{
        timeview.alpha = 1;
        
    } completion:^(BOOL finished) {
        
        
    }];
}

-(void)time{
    
    if (_delegate&&[_delegate respondsToSelector:@selector(ZTselectTimesViewSetOneLeft:)]) {
        
        NSString *OneLeft = [hoursary objectAtIndex:[centerPickview selectedRowInComponent:0]];
        
        
        [_delegate ZTselectTimesViewSetOneLeft:OneLeft];
        
    }
}


- (void)setOldShowTimeOneLeft:(NSString *)oneLeft
{
    
    for(int i=0; i<hoursary.count; i++ )
        
        if( [oneLeft isEqual: hoursary[i]]){
            
            left0_row=i;
            
        }

    [centerPickview selectRow:left0_row inComponent:0 animated:true];

}


-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}
-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    
    return hoursary.count;
    
}
-(NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return hoursary[row];
}
-(CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component
{
    
    return self.frame.size.width;
    
    
}
-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    
    
    
    
}
@end
