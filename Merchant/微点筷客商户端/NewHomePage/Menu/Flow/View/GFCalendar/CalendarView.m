//
//  CalendarView.m
//  微点筷客商户端
//
//  Created by 张森森 on 16/11/18.
//  Copyright © 2016年 张森森. All rights reserved.
//

#import "CalendarView.h"
#import "GFCalendar.h"
#import "MBProgressHUD+SS.h"
@implementation CalendarView

-(instancetype)initWithStyle:(NSInteger)styleint
{
    self =[super init];
    if (self)
    {

        _typeinteger = styleint;

        self.frame = CGRectMake(0, 64, kScreenWidth-autoScaleW(53), kScreenHeight-64);
        [self Creatui];
    }

    return self;
}
-(void)Creatui
{

    CGFloat width = self.frame.size.width;
    CGPoint origin = CGPointMake(0, 0);

    GFCalendarView *calendar = [[GFCalendarView alloc] initWithFrameOrigin:origin width:width type:_typeinteger];

    // 点击某一天的回调
    calendar.didSelectDayHandler = ^(NSInteger year, NSInteger month, NSInteger day,NSInteger a) {

        if (_typeinteger==1) {
          
            if (_leftlabel.text!=nil&&_rightlabel.text!=nil) {//当选完区间是再次点击的时候先清空再重新选择区间
                _leftlabel.text = nil;
                _rightlabel.text = nil;
            }
            
            if (a==1) {

                _leftlabel.text = [NSString stringWithFormat:@"%ld-%ld-%ld",(long)year,month,day];

            }
            if (a==2) {

                _rightlabel.text = [NSString stringWithFormat:@"%ld-%ld-%ld",(long)year,month,day];
            }
            if (_leftlabel.text!=nil&&_rightlabel.text !=nil) {

                if ([_leftlabel.text compare:_rightlabel.text options:-1]==NSOrderedDescending) {

                    NSString * timerstr = _leftlabel.text;
                    _leftlabel.text = _rightlabel.text;
                    _rightlabel.text = timerstr;
                    //开始日期大于结束日期时候 互换

                }
            }
        }
        if (_typeinteger==2) {

            _typetwolabel.text = [NSString stringWithFormat:@"%ld-%ld-%ld",(long)year,month,day];
        }
    };

    [self addSubview:calendar];

    UIView * bgview = [[UIView alloc]init];
    bgview.backgroundColor = RGB(242, 242, 242);
    [self addSubview:bgview];
    bgview.sd_layout.topSpaceToView(calendar,autoScaleH(15)).leftSpaceToView(self,autoScaleW(10)).widthIs(kScreenWidth-autoScaleW(56)-autoScaleW(20)).heightIs(autoScaleH(20));
    if (_typeinteger==1) {
        _leftlabel = [[UILabel alloc]init];
        _leftlabel.textColor = [UIColor blackColor];
        _leftlabel.textAlignment = NSTextAlignmentRight;
        _leftlabel.font =[UIFont systemFontOfSize:autoScaleW(13)];
        [bgview addSubview:_leftlabel];
        _leftlabel.sd_layout.topSpaceToView(bgview,autoScaleH(3)).leftSpaceToView(bgview,0).widthIs((kScreenWidth-autoScaleW(100))/2).heightIs(autoScaleH(15));
        UILabel * centerlabel = [[UILabel alloc]init];
        centerlabel.textColor = [UIColor lightGrayColor];
        centerlabel.text = @"至";
        centerlabel.font = [UIFont systemFontOfSize:autoScaleW(13)];
        [bgview addSubview:centerlabel];
        centerlabel.sd_layout.centerXEqualToView(bgview).topSpaceToView(bgview,autoScaleH(3)).widthIs(autoScaleW(15)).heightIs(autoScaleH(15));

        _rightlabel = [[UILabel alloc]init];
        _rightlabel.textColor = [UIColor blackColor];
        _rightlabel.textAlignment = NSTextAlignmentLeft;
        _rightlabel.font =[UIFont systemFontOfSize:autoScaleW(13)];
        [bgview addSubview:_rightlabel];
        _rightlabel.sd_layout.topSpaceToView(bgview,autoScaleH(3)).rightSpaceToView(bgview,0).widthIs((kScreenWidth-autoScaleW(100))/2).heightIs(autoScaleH(15));


    }
    if (_typeinteger==2) {

        _typetwolabel = [[UILabel alloc]init];
        _typetwolabel.textColor = [UIColor redColor];
        _typetwolabel.textAlignment = NSTextAlignmentCenter;
        _typetwolabel.frame = bgview.frame;
        _typetwolabel.font = [UIFont systemFontOfSize:autoScaleW(13)];
        [bgview addSubview:_typetwolabel];


    }

    NSArray * titary = [NSArray arrayWithObjects:@"取消",@"确定", nil];

    for (int i =0; i<2; i++) {

        ButtonStyle * choosebtn = [ButtonStyle buttonWithType:UIButtonTypeCustom];
        [choosebtn setTitle:titary[i] forState:UIControlStateNormal];
        choosebtn.titleLabel.font = [UIFont systemFontOfSize:autoScaleW(15)];
        choosebtn.layer.masksToBounds = YES;
        choosebtn.layer.cornerRadius = 3;
        if (i==0) {

            choosebtn.layer.borderWidth = 1;
            choosebtn.layer.borderColor = UIColorFromRGB(0xfd7577).CGColor;
            [choosebtn setTitleColor:UIColorFromRGB(0xfd7577) forState:UIControlStateNormal];
        }
        if (i==1) {

            choosebtn.backgroundColor = UIColorFromRGB(0xff5c5c);
            [choosebtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        }
        choosebtn.tag = 500+i;
        [choosebtn addTarget:self action:@selector(Choose:) forControlEvents:UIControlEventTouchUpInside];

        [self addSubview:choosebtn];
        choosebtn.sd_layout.leftSpaceToView(self,autoScaleW(20)+i*autoScaleW(200)).topSpaceToView(bgview,autoScaleH(15)).widthIs(autoScaleW(80)).heightIs(autoScaleH(30));

    }
}
-(void)Getsomething:(calenblock)block
{
    self.block = block;
}
-(void)Choose:(ButtonStyle *)btn
{
    if (_typeinteger==1) {
        if (btn.tag==500)
        {
            if (self.block!=nil) {


                self.block (@"0",@"0",@"remove");
            }
        }
        if (btn.tag==501)
        {
            if (_leftlabel.text!=nil&&_rightlabel.text!=nil) {
                if (self.block!=nil) {

                    self.block (_leftlabel.text,_rightlabel.text,@"sure");
                }
            } else {

                [MBProgressHUD showError:@"请选择日期"];
            }
        }


    }
    if (_typeinteger==2)
    {

        if (btn.tag==500)
        {
            if (self.block!=nil) {


                self.block (@"0",@"0",@"remove");
            }
        }
        if (btn.tag==501)
        {
            if (_typetwolabel.text != nil) {
                if (self.block!=nil) {
                    self.block (_typetwolabel.text,@"0",@"sure");
                }
            } else {

                [MBProgressHUD showError:@"请选择日期"];
            }


        }

    }

}
//-(void)ShowView
//{
//    UIWindow * winw = [UIApplication sharedApplication].keyWindow;
//    _calenview = [[UIView alloc]init];
//    _calenview.backgroundColor = RGBA(0, 0, 0, 0.3);
//    [winw addSubview:_calenview];
//
//    _calenview.sd_layout.leftSpaceToView(winw,0).topSpaceToView(winw,0).widthIs(kScreenWidth-autoScaleW(40)).heightIs(autoScaleH(200));
//    
//    self.frame = _calenview.frame;
//    [_calenview addSubview:self];
//    
//    
//}


@end
