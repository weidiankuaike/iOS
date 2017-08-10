//
//  BusinessErectViewController.m
//  微点筷客商户端
//
//  Created by 张森森 on 16/10/10.
//  Copyright © 2016年 张森森. All rights reserved.
//

#import "BusinessErectViewController.h"
#import "MyorderViewController.h"
#import "ZTAlertSheetView.h"
@interface BusinessErectViewController ()

@property (nonatomic,strong)ButtonStyle * daitibtn;
@property (nonatomic,strong)ButtonStyle * daybtn;
@property (nonatomic,strong)UIView * shezhiview;
@property (nonatomic,strong) UIView * shezhivieww;
@property (nonatomic,strong)UILabel * tishilabel;
@property (nonatomic,strong)NSArray * array;
@property (nonatomic,assign)NSInteger chooseinteger;
@property (nonatomic,strong)ButtonStyle * choosebtn;
@property (nonatomic,strong)UIView * tishiview;
@property (nonatomic,strong)ZTAlertSheetView * ztalertview;

@end

@implementation BusinessErectViewController
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear: animated];
    self.tabBarController.tabBar.hidden=YES;
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.tabBarController.tabBar.hidden = NO;
}
- (void)viewDidLoad {
    [super viewDidLoad];


    NSArray * ary = @[@"可接受提前多久预定",@"取消",];
    self.ztalertview = [[ZTAlertSheetView alloc]initWithTitleArray:ary];
    [self.ztalertview showView];
    __weak __typeof (self)weakself = self;
    self.ztalertview.alertSheetReturn = ^(NSInteger ztcount) {
        if (ztcount==0) {
            weakself.view.backgroundColor = RGBA(0, 0, 0, 0.3);
            
            weakself.shezhivieww.hidden = NO;
        }
        if (ztcount==1) {
            [weakself dismissViewControllerAnimated:YES completion:^{
                
            }];
        }
    };
    [self CreatUI];
    [self yuding];
}

#pragma mark 弹出
-(void)CreatUI
{

}
#pragma mark 设置预定
-(void)yuding
{
    _shezhivieww = [[UIView alloc]init];
    _shezhivieww.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_shezhivieww];
    _shezhivieww.sd_layout.leftSpaceToView(self.view,autoScaleW(45)).rightSpaceToView(self.view,autoScaleW(45)).centerYEqualToView(self.view).heightIs(autoScaleH(155));
    _shezhivieww.userInteractionEnabled = YES;
    _shezhivieww.hidden = YES;
    ButtonStyle * quxiaobtn = [ButtonStyle buttonWithType:UIButtonTypeCustom];
    [quxiaobtn setTitleColor:UIColorFromRGB(0xfd7577) forState:UIControlStateNormal];
    quxiaobtn.titleLabel.font = [UIFont systemFontOfSize:autoScaleW(15)];
    [quxiaobtn setTitle:@"取消" forState:UIControlStateNormal];
    [quxiaobtn addTarget:self action:@selector(cancel) forControlEvents:UIControlEventTouchUpInside];
    [_shezhivieww addSubview:quxiaobtn];
    quxiaobtn.sd_layout.leftSpaceToView(_shezhivieww,autoScaleW(10)).topSpaceToView(_shezhivieww,autoScaleH(10)).widthIs(autoScaleW(40)).heightIs(autoScaleH(20));

    ButtonStyle * quedingbtn = [ButtonStyle buttonWithType:UIButtonTypeCustom];
    [quedingbtn setTitleColor:UIColorFromRGB(0xfd7577) forState:UIControlStateNormal];
    quedingbtn.titleLabel.font = [UIFont systemFontOfSize:autoScaleW(15)];
    [quedingbtn setTitle:@"确定" forState:UIControlStateNormal];
    [quedingbtn addTarget:self action:@selector(timeClick) forControlEvents:UIControlEventTouchUpInside];
    [_shezhivieww addSubview:quedingbtn];
    quedingbtn.sd_layout.rightSpaceToView(_shezhivieww,autoScaleW(10)).topSpaceToView(_shezhivieww,autoScaleH(10)).widthIs(autoScaleW(40)).heightIs(autoScaleH(20));

    UILabel * linelabel = [[UILabel alloc]init];
    linelabel.backgroundColor = RGB(195, 195, 195);
    [_shezhivieww addSubview:linelabel];
    linelabel.sd_layout.leftSpaceToView(_shezhivieww,0).rightSpaceToView(_shezhivieww,0).heightIs(autoScaleH(0.5)).topSpaceToView(_shezhivieww,autoScaleH(35));

    for (int i=0; i<7; i++) {

        ButtonStyle * zhuangtasibtn = [ButtonStyle buttonWithType:UIButtonTypeCustom];
        [zhuangtasibtn setTitle:[NSString stringWithFormat:@"%d天",i+1] forState:UIControlStateNormal];
        zhuangtasibtn.titleLabel.font = [UIFont systemFontOfSize:autoScaleW(13)];
        [zhuangtasibtn setTitleColor:UIColorFromRGB(0xfd7577) forState:UIControlStateSelected];
        [zhuangtasibtn setTitleColor:RGB(196, 196, 197) forState:UIControlStateNormal];
        zhuangtasibtn.layer.masksToBounds = YES;
        zhuangtasibtn.layer.cornerRadius = autoScaleW(3);
        zhuangtasibtn.layer.borderWidth = 1;
        zhuangtasibtn.layer.borderColor = RGB(196, 196, 197).CGColor;
        zhuangtasibtn.tag = 3000 + i + 1;
        if (i==0) {
            zhuangtasibtn.selected = YES;
            zhuangtasibtn.layer.borderColor = UIColorFromRGB(0xfd7577).CGColor;
            _daybtn = zhuangtasibtn;
        }

        [zhuangtasibtn addTarget:self action:@selector(Ydday:) forControlEvents:UIControlEventTouchUpInside];
        [_shezhivieww addSubview:zhuangtasibtn];
        zhuangtasibtn.sd_layout.leftSpaceToView( _shezhivieww,autoScaleW(10)+i%4*autoScaleW(70)).topSpaceToView(linelabel,autoScaleH(20)+i/4*autoScaleW(40)).widthIs(autoScaleW(55)).heightIs(autoScaleH(30));
    }

}

#pragma mark block
-(void)getstring:(xblock)block
{
    self.block = block;
}

-(void)timeClick
{
    [self dismissViewControllerAnimated:YES completion:^{

        if (_block) {
            _block([_daybtn.titleLabel.text subStringToString:@"天"]);
        }
    }];
}
-(void)cancel
{
    [self dismissViewControllerAnimated:YES completion:^{

    }];
}
#pragma mark 预定天数按钮
-(void)Ydday:(ButtonStyle *)btn
{
    _daybtn.selected= NO;
    _daybtn.layer.borderColor = RGB(196, 196, 197).CGColor;

    btn.selected=YES;
    btn.layer.borderColor =  UIColorFromRGB(0xfd7577).CGColor;
    _daybtn = btn;
}
#pragma mark 营业状态按钮
-(void)Choosezt:(ButtonStyle *)btn
{
    btn.selected=YES;
    _daitibtn.selected= NO;
    btn.layer.borderColor =  UIColorFromRGB(0xfd7577).CGColor;
    _daitibtn.layer.borderColor = RGB(196, 196, 197).CGColor;
    _daitibtn = btn;

    if (btn.tag==700) {

        _tishilabel.text = @"因为您设置了可预订，在营业状态下将正常接收预订";
        _chooseinteger = 0;
    }

    if (btn.tag==701) {

        _tishilabel.text = @"所选的时段将不再接受预定";
        _chooseinteger = 1;
    }
    if (btn.tag==702) {
        _chooseinteger = 2;

        _tishilabel.text = @"所选的时段将不再接受用餐";
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation

 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
