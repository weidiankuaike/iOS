//
//  ZTTimerPickerView.m
//  wdKuaiKe_iOS
//
//  Created by Skyer God on 16/10/7.
//  Copyright © 2016年 weiDianKuaiKe. All rights reserved.
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
//颜色16进制
//#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1]

#define XMRECT6(rect) CGRectMake(rect.origin.x*self6WidthRate, rect.origin.y*self6HeightRate, rect.size.width*self6WidthRate, rect.size.height*self6HeightRate)

#define XMRECT(rect) CGRectMake(rect.origin.x*selfWidthRate, rect.origin.y*selfHeightRate, rect.size.width*selfWidthRate, rect.size.height*selfHeightRate)

#import "ZTTimerPickerView.h"

@implementation ZTTimerPickerView
{
    //    row
    NSInteger left0_row;
    NSInteger left1_row;
    NSInteger right0_row;
    NSInteger right1_row;
    // pickerView

    UIPickerView * _pickerView_left;
    // pickerView

    UIPickerView * _pickerView_right;
    // 小时

    NSArray * _hours_Arr;
    // 分钟
    NSArray * _min_arr;
    UIView * timeview;
}

-(instancetype)init{

    self=[super init];

    if (self) {

    _hours_Arr=@[@"00",@"01",@"02",@"03",@"04",@"05",@"06",@"07",@"08",@"09",@"10",@"11",@"12",@"13",@"14",@"15",@"16",@"17",@"18",@"19",@"20",@"21",@"22",@"23"];

        _min_arr=@[@"00",@"30"];

        self.frame=CGRectMake(0, selfHeight, selfWidth, selfHeight-64);

        [self createUI];
    }

    return self;
    
}

-(void)createUI{

    // 背景白色View

    UIView * white_view=[[UIView alloc]init];

    white_view.frame = CGRectMake(0, 0, kScreenWidth, autoScaleH(250));
    white_view.backgroundColor=[UIColor whiteColor];

    white_view.layer.cornerRadius=10;

    [self addSubview:white_view];

    //选择时间标题

    UILabel * title_label=[[UILabel alloc]initWithFrame:XMRECT6(CGRectMake((275-150)/2, 21, 150, 30))];

    title_label.text=@"营业时间设置";

    title_label.textColor=UIColorFromRGB(0x383838);

    title_label.textAlignment=NSTextAlignmentCenter;

    [white_view addSubview:title_label];
    //营业时间和打烊时间标题

    for (int i=0; i<2; i++) {

        UILabel * label=[[UILabel alloc]initWithFrame:XMRECT6(CGRectMake(70+116*i, 60, 100, 30))];

        label.font=[UIFont systemFontOfSize:14];

        label.textColor=UIColorFromRGB(0x383838);

        label.textAlignment=NSTextAlignmentCenter;

        [white_view addSubview:label];

        if (i==0) {

            label.text=@"营业时间";

        }else{

            label.text=@"打烊时间";
        }

    }
    //   分割线

//    UILabel * button_line=[[UILabel alloc]initWithFrame:CGRectMake(0, 250*self6HeightRate, 275*self6WidthRate, 1)];
//
//    button_line.backgroundColor=selfBacground;
//
//    [white_view addSubview:button_line];


    //  选择营业时间

    //                    _pickerView_left=[[UIPickerView alloc]initWithFrame:XMRECT6(CGRectMake(20,80, 275-40,150))];

    _pickerView_left=[[UIPickerView alloc]initWithFrame:XMRECT6(CGRectMake(70,100,100,130))];

    _pickerView_left.delegate=self;

    _pickerView_left.dataSource=self;

    _pickerView_left.backgroundColor=UIColorFromRGB(0xfbfbfb);

    [white_view addSubview:_pickerView_left];


    _pickerView_right=[[UIPickerView alloc]initWithFrame:XMRECT6(CGRectMake(180,100,100,130))];

    _pickerView_right.delegate=self;

    _pickerView_right.dataSource=self;

    _pickerView_right.backgroundColor=UIColorFromRGB(0xfbfbfb);

    [white_view addSubview:_pickerView_right];

    //   选中的背景图绿色

    UIImageView * imageView=[[UIImageView alloc]initWithFrame:(CGRectMake(30*self6WidthRate,152*self6HeightRate,2,26))];

    [imageView setImage:[UIImage imageNamed:@"bjzsx"]];

    [white_view addSubview:imageView];

    UILabel * green_dian=[[UILabel alloc]initWithFrame:XMRECT(CGRectMake(105, 125,30,30))];

    green_dian.text=@":";

    green_dian.textColor=selfGreen;

    green_dian.font=[UIFont systemFontOfSize:14];

    [white_view addSubview:green_dian];


    //    选中背景图红色

    UIImageView * imageView_red=[[UIImageView alloc]initWithFrame:(CGRectMake(140*self6WidthRate,152*self6HeightRate,2,26))];

    [imageView_red setImage:[UIImage imageNamed:@"hbjzsx"]];

    [white_view addSubview:imageView_red];

    UILabel * red_dian=[[UILabel alloc]initWithFrame:XMRECT(CGRectMake(198, 125,30,30))];

    red_dian.text=@":";

    red_dian.textColor=[UIColor redColor];

    red_dian.font=[UIFont systemFontOfSize:14];

    [white_view addSubview:red_dian];

    //   取消和设置按钮

//    for (int i=0; i<2; i++) {
//
//        ButtonStyle * button=[[ButtonStyle alloc]initWithFrame:XMRECT6(CGRectMake(275/2*i,250,275/2, 50))];
//
//        [button setTitleColor:selfGreen forState:UIControlStateNormal];
//
//        [white_view addSubview:button];
//
//        if (i==0) {
//
//            [button setTitle:@"取消" forState:UIControlStateNormal];
//
//            [button addTarget:self action:@selector(cancel) forControlEvents:UIControlEventTouchUpInside];
//
//
//        }else{
//
//            [button setTitle:@"设置" forState:UIControlStateNormal];
//
//            [button addTarget:self action:@selector(timeClick) forControlEvents:UIControlEventTouchUpInside];
//        }
//    }
    
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
    
    //按钮分割线

//    UILabel * bnt_line=[[UILabel alloc]initWithFrame:CGRectMake(275/2*self6WidthRate, 250*self6HeightRate , 1,50*self6HeightRate)];
//
//    [bnt_line setBackgroundColor:selfBacground];
//
//    [white_view addSubview:bnt_line];

}
-(void)cancel{

    [timeview removeFromSuperview];

}
-(void)timeClick{

    
        [self time];
    

    [timeview removeFromSuperview];
}
-(void)time{

    if (_delegate&&[_delegate respondsToSelector:@selector(ZTselectTimesViewSetOneLeft:andOneRight:andTwoLeft:andTwoRight:)]) {

        NSString *OneLeft = [_hours_Arr objectAtIndex:[_pickerView_left selectedRowInComponent:0]];
        NSString *OneRight = [_min_arr objectAtIndex:[_pickerView_left selectedRowInComponent:1]];
        NSString *twoLeft = [_hours_Arr objectAtIndex:[_pickerView_right selectedRowInComponent:0]];
        NSString *twoRight = [_min_arr objectAtIndex:[_pickerView_right selectedRowInComponent:1]];

        [_delegate ZTselectTimesViewSetOneLeft:OneLeft andOneRight:OneRight andTwoLeft:twoLeft andTwoRight:twoRight];

    }
}

-(void)showTime{

    [UIView animateWithDuration:0.3 animations:^{

        UIWindow * window=[UIApplication sharedApplication].keyWindow;
        timeview = [[UIView alloc]init];
        timeview.backgroundColor = RGBA(0, 0, 0, 0.3);
        [window addSubview:timeview];
        timeview.sd_layout.leftSpaceToView(window,0).topSpaceToView(window,0).widthIs(kScreenWidth).heightIs(kScreenHeight);


        [timeview addSubview:self];
        
        self.sd_layout.leftSpaceToView(timeview,0).bottomSpaceToView(timeview,0).widthIs(kScreenWidth).heightIs(autoScaleH(250));
        

    } completion:^(BOOL finished) {


    }];
}
- (void)setOldShowTimeOneLeft:(NSString *)oneLeft andOneRight:(NSString *)oneRight andTwoLeft:(NSString *)twoLeft andTwoRight:(NSString *)twoRight {
//    NSLog(@"oneLeft-%@ oneRight-%@ twoLeft-%@ twoRight-%@",oneLeft,oneRight,twoLeft,twoRight);

    for(int i=0; i<_hours_Arr.count; i++ )

        if( [oneLeft isEqual: _hours_Arr[i]]){

            left0_row=i;

        }else if ([twoLeft isEqual:_hours_Arr[i]]){

            right0_row=i;

        }

    for (int j=0; j<_min_arr.count; j++) {

        if( [oneRight isEqual: _min_arr[j]]){

            left1_row=j;

        }else if ([twoRight isEqual:_min_arr[j]]){

            right1_row=j;

        }
    }
    [_pickerView_left selectRow:left0_row inComponent:0 animated:true];

    [_pickerView_left selectRow:left1_row inComponent:1 animated:true];

    [_pickerView_right selectRow:right0_row inComponent:0 animated:YES];

    [_pickerView_right selectRow:right1_row inComponent:1 animated:YES];
}
#pragma mark ========================================pikerViewdelegate====================
//一共多少列
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 2;
}
//每列对应多少行
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    if (component == 0) {
        return _hours_Arr.count;
    } else if (component == 1) {
        return _min_arr.count;
    }else
    {
        return  0;
    }

    //    else {
    //        return self.twonArray.count;
    //    }
}
//每列每行显示的数据是什么
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    if (component == 0) {
        return [_hours_Arr objectAtIndex:row];
    } else if (component == 1) {
        return [_min_arr objectAtIndex:row];
    }else{

        return 0;
    }

}
////组建的宽度
- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component {
    if (component == 0) {
        return 50*self6WidthRate;
    } else if (component == 1) {
        return 50*self6WidthRate;
    }else{

        return 0;
    }

}
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {

    if (pickerView==_pickerView_left) {

        if (component==0) {

            left0_row=row;

            [_pickerView_left reloadComponent:0];

        }else{

            left1_row=row;

            [_pickerView_left reloadComponent:1];

        }

    } else if (pickerView==_pickerView_right){

        if (component==0) {

            right0_row=row;

            [_pickerView_right reloadComponent:0];

        }else{

            right1_row=row;

            [_pickerView_right reloadComponent:1];

        }

    }

}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{

    UILabel* pickerLabel = (UILabel*)view;
    if (!pickerLabel){
        pickerLabel = [[UILabel alloc] init];
        // Setup label properties - frame, font, colors etc
        //adjustsFontSizeToFitWidth property to YES
        pickerLabel.minimumScaleFactor = 8;
        pickerLabel.adjustsFontSizeToFitWidth = YES;
        [pickerLabel setTextAlignment:NSTextAlignmentCenter];

        pickerView.layer.borderWidth=0.5;

        pickerLabel.tag=row;

        pickerView.layer.borderColor=selfBacground.CGColor;

        [pickerLabel setFont:[UIFont systemFontOfSize:15]];

        if (_pickerView_left==pickerView) {

            if (component==0&&left0_row==row) {

                pickerLabel.textColor=selfGreen;

            }else if (component==1&&left1_row==row){

                pickerLabel.textColor=selfGreen;

            }

        }else if (_pickerView_right==pickerView){

            if (component==0&&right0_row==row) {

                pickerLabel.textColor=[UIColor redColor];

            }else if (component==1&&right1_row==row){

                pickerLabel.textColor=[UIColor redColor];

            }
        }

    }
    pickerLabel.text=[self pickerView:pickerView titleForRow:row forComponent:component];

    return pickerLabel;
}





@end
