//
//  ZT_doublePickerView.m
//  微点筷客商户端
//
//  Created by Skyer God on 16/10/20.
//  Copyright © 2016年 张森森. All rights reserved.
//

#import "ZT_doublePickerView.h"
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
#define self6PlusHeightRate [UIScreen mainScreen].bounds.size.height/736.0


#define XMRECT6(rect) CGRectMake(rect.origin.x*self6WidthRate, rect.origin.y*self6HeightRate, rect.size.width*self6WidthRate, rect.size.height*self6HeightRate)

#define XMRECT(rect) CGRectMake(rect.origin.x*selfWidthRate, rect.origin.y*selfHeightRate, rect.size.width*selfWidthRate, rect.size.height*selfHeightRate)

#import "ZTTimerPickerView.h"

@implementation ZT_doublePickerView
{
    //    row
    NSInteger left0_row;
    NSInteger left1_row;
    NSInteger right0_row;
    NSInteger right1_row;
    // pickerView

    

    // 小时

    NSArray * _hours_Arr;
    // 分钟
    NSArray * _min_arr;
}

-(instancetype)initWithLeftArr:(NSArray *)leftArr RightArr:(NSArray *)rightArr{

    self=[super init];

    if (self) {

        _hours_Arr= leftArr;

        _min_arr= rightArr;

        self.frame=CGRectMake(0, 0, selfWidth, selfHeight-64);
        self.backgroundColor = RGBA(0, 0, 0, 0.3);
        [self createUI];
    }
    return self;

}

-(void)createUI{

    // 背景白色View

    UIView * backView=[[UIView alloc]initWithFrame:(CGRectMake(autoScaleW(50), autoScaleH(220),autoScaleW(selfWidth - 100 - 50),autoScaleH(180)))];

    backView.backgroundColor=RGB(238, 238, 238);

    backView.layer.cornerRadius= 10;

    [self addSubview:backView];

    backView.sd_layout
    .centerXEqualToView(self)
    .centerYEqualToView(self)
    .widthRatioToView(self, 0.7);


    /** 完成按钮 **/
    _cancelBT = [ButtonStyle buttonWithType:UIButtonTypeCustom];
    [_cancelBT setTitle:@"取消" forState:UIControlStateNormal];
    [_cancelBT setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [_cancelBT.titleLabel setFont:[UIFont systemFontOfSize:14]];
    [_cancelBT addTarget:self action:@selector(cancel) forControlEvents:UIControlEventTouchUpInside];
    [backView addSubview:_cancelBT];

    /** 添加按钮 **/
    _addBT = [ButtonStyle buttonWithType:UIButtonTypeCustom];
    [_addBT setTitle:@"添加" forState:UIControlStateNormal];
    [_addBT.titleLabel setFont:_cancelBT.titleLabel.font];
    [_addBT setTitleColor:RGB(239, 167, 98) forState:UIControlStateNormal];
    [_addBT addTarget:self action:@selector(timeClick) forControlEvents:UIControlEventTouchUpInside];
    [backView addSubview:_addBT];

    /** 中间标题按钮 **/

    _titleLabel=[[UILabel alloc]init];

    _titleLabel.text=@"手动添加餐桌";
    _titleLabel.font = _cancelBT.titleLabel.font;
    _titleLabel.textColor=UIColorFromRGB(0x383838);

    _titleLabel.textAlignment=NSTextAlignmentCenter;

    [backView addSubview:_titleLabel];

            /** 标题提示 **/

    _littleTitle = [[UILabel alloc] init];
    _littleTitle.text = @"餐桌会自动编号";
    _littleTitle.font = [UIFont systemFontOfSize:11];
    _littleTitle.textColor = [UIColor lightGrayColor];
    _littleTitle.textAlignment = NSTextAlignmentCenter;
    _littleTitle.hidden = YES;
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

    _categortyLabel.font=[UIFont systemFontOfSize:14];

    _categortyLabel.textColor=UIColorFromRGB(0x383838);

    _categortyLabel.text = @"类型";
    _categortyLabel.textAlignment=NSTextAlignmentCenter;
    [backView addSubview:_categortyLabel];

    CGFloat start_x = backView.frame.size.width / 6;
    _categortyLabel.sd_layout
    .leftSpaceToView(backView, start_x)
    .topSpaceToView(_littleTitle, 1)
    .widthIs(30)
    .heightIs(15);

    _numLabel=[[UILabel alloc]init];

    _numLabel.font=[UIFont systemFontOfSize:14];
    _numLabel.text = @"编号";
    _numLabel.textColor=UIColorFromRGB(0x383838);

    _numLabel.textAlignment=NSTextAlignmentCenter;

    [backView addSubview:_numLabel];

    _numLabel.sd_layout
    .rightSpaceToView(backView, start_x)
    .topEqualToView(_categortyLabel)
    .widthIs(30)
    .heightIs(15);


    //  选择类型

    [_categortyLabel updateLayout];
    _pickerView_left=[[UIPickerView alloc]initWithFrame:CGRectMake(0, autoScaleH(_categortyLabel.origin_sd.y + _categortyLabel.height_sd), autoScaleW(backView.width_sd), autoScaleH(120))];

    _pickerView_left.delegate=self;

    _pickerView_left.dataSource=self;

    _pickerView_left.showsSelectionIndicator = YES;

    _pickerView_left.backgroundColor=RGB(238, 238, 238);

    [backView addSubview:_pickerView_left];
    _pickerView_left.sd_layout.centerXEqualToView(backView)
    .leftEqualToView(backView)
    .rightEqualToView(backView);
    [backView setupAutoHeightWithBottomView:_pickerView_left bottomMargin:10];

    [_pickerView_left selectRow:2 inComponent:0 animated:true];
    [_pickerView_left selectRow:2 inComponent:1 animated:true];
}
-(void)cancel{
    if(_cancelBTClick) {
        _cancelBTClick();
    }
    [self removeFromSuperview];

}
-(void)timeClick{
    [self time];
    [self removeFromSuperview];
    if (_addBTClick) {
        _addBTClick();
    }
}
-(void)time{

    if (_delegate&&[_delegate respondsToSelector:@selector(ZTselectTimesView: SetOneLeft: andOneRight:)]) {

        NSString *OneLeft = [_hours_Arr objectAtIndex:[_pickerView_left selectedRowInComponent:0]];
        NSString *OneRight = [_min_arr objectAtIndex:[_pickerView_left selectedRowInComponent:1]];

        [_delegate ZTselectTimesView:self SetOneLeft:OneLeft andOneRight:OneRight];

    }
}

-(void)showTime{

    [UIView animateWithDuration:0.3 animations:^{

        UIWindow * window=[UIApplication sharedApplication].keyWindow;

        self.frame=CGRectMake(0,0,selfWidth, selfHeight);

        [window addSubview:self];

    } completion:^(BOOL finished) {

    }];
}
- (void)setOldShowTimeOneLeft:(NSString *)oneLeft andOneRight:(NSString *)oneRight{
//    NSLog(@"oneLeft-%@ oneRight-%@",oneLeft,oneRight);

    for(int i=0; i<_hours_Arr.count; i++ )

        if( [oneLeft isEqual: _hours_Arr[i]]){

            left0_row=i;

        }
    for (int j=0; j<_min_arr.count; j++) {

        if( [oneRight isEqual: _min_arr[j]]){

            left1_row=j;

        }    }
    [_pickerView_left selectRow:left0_row inComponent:0 animated:true];

    [_pickerView_left selectRow:left1_row inComponent:1 animated:true];

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
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {

    if (pickerView==_pickerView_left) {

        if (component==0) {

            left0_row=row;

            [_pickerView_left reloadComponent:0];

        }else{

            left1_row=row;

            [_pickerView_left reloadComponent:1];

        }

    }

}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{

    UILabel* pickerLabel = (UILabel*)view;
    if (!pickerLabel){
        pickerLabel = [[UILabel alloc] init];
        // Setup label properties - frame, font, colors etc
        //adjustsFontSizeToFitWidth property to YES
        pickerLabel.minimumScaleFactor = 12;
        pickerLabel.adjustsFontSizeToFitWidth = YES;
        [pickerLabel setTextAlignment:NSTextAlignmentCenter];
        pickerLabel.backgroundColor = [UIColor lightTextColor];
        pickerLabel.tag=row;
        [pickerLabel setFont:[UIFont systemFontOfSize:15]];
        if (_pickerView_left==pickerView) {

            if (component==0&&left0_row==row) {
                
                pickerLabel.textColor=RGBA(0, 0, 0, 0.7);
                
            }else if (component==1&&left1_row==row){
                
                pickerLabel.textColor=RGBA(0, 0, 0, 0.7);
                
            }
            
        }

    }
    pickerLabel.text=[self pickerView:pickerView titleForRow:row forComponent:component];
    
    return pickerLabel;
}





@end

