//
//  VagetableViewController.m
//  微点筷客商户端
//
//  Created by 张森森 on 16/10/20.
//  Copyright © 2016年 张森森. All rights reserved.
//

#import "VagetableViewController.h"
#import "UIBarButtonItem+SSExtension.h"
#import "VBPieChart.h"
#import "UIColor+HexColor.h"
#import "VageTableViewCell.h"
#import "MBProgressHUD+SS.h"
#import "QYXNetTool.h"
#import "CalendarView.h"
#import "merchantClient-Bridging-Header.h"
@interface VagetableViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) UIImageView * imageview;
@property (nonatomic,assign)  CGFloat height;
@property (nonatomic,strong) ButtonStyle * daitibtn;
@property (nonatomic,strong) ButtonStyle * tidaibtn;
@property (nonatomic,strong) UIView * chooseView;
@property (nonatomic,strong) UITableView * ordertable;
@property (nonatomic, retain) NSArray *chartValues;
@property (nonatomic,retain) UIView * bigview;
@property (nonatomic,strong) UITableView * vagetable;
@property (nonatomic,assign) NSInteger vaginteger;
@property (nonatomic,strong) NSMutableArray * nameary;
@property (nonatomic,strong) NSMutableArray * pctary;
@property (nonatomic,strong) NSMutableArray * bianary;
@property (nonatomic,copy)   NSString * token;
@property (nonatomic,copy)    NSString * storeid;
@property (nonatomic,copy)   NSString * clicktype;
@property (nonatomic,copy)   NSString * timetype;
@property (nonatomic,strong) NSMutableArray * allnameary;
@property (nonatomic,strong) NSMutableArray * allpctary;
@property (nonatomic,strong) UIImageView * bgimage;
@property (nonatomic,strong) UIImageView * placeHolderView;
@property (nonatomic,strong)  NSArray * objary;
@end
static int a=0;
@implementation VagetableViewController
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [ReloadVIew registerReloadView:self];
    self.navigationController.navigationBar.hidden = NO;
    self.tabBarController.tabBar.hidden = YES;

}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.hidden = YES;
    self.tabBarController.tabBar.hidden = NO;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    _vaginteger=1;

    _clicktype = @"sum_fee";
    _timetype = @"2";
    self.titleView.text = @"菜品分析";
    self.view.backgroundColor = [UIColor whiteColor];


    _height = [[UIApplication sharedApplication] statusBarFrame].size.height + self.navigationController.navigationBar.frame.size.height;

    ButtonStyle * rightbtn = [ButtonStyle buttonWithType:UIButtonTypeCustom];
    rightbtn.tag = 2017;
    [rightbtn addTarget:self action:@selector(rightBarItemClick) forControlEvents:UIControlEventTouchUpInside];
    //    rightbtn.selected = YES;
    rightbtn.frame = CGRectMake(0, 0, autoScaleW(45), autoScaleH(30));
    UILabel * label = [[UILabel alloc]init];
    label.text = @"筛选";
    label.textColor = [UIColor whiteColor];
    label.font = [UIFont systemFontOfSize:autoScaleW(15)];
    [rightbtn addSubview:label];
    label.userInteractionEnabled = YES;
    UITapGestureRecognizer *tapGR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(rightBarItemClick)];

    [label addGestureRecognizer:tapGR];
    label.sd_layout.centerXEqualToView(rightbtn).centerYEqualToView(rightbtn).widthIs(autoScaleW(35)).heightIs(autoScaleH(30));
    _imageview = [[UIImageView alloc]init];
    if (rightbtn.selected ==YES) {

        _imageview.image = [UIImage imageNamed:@"bottom_arrow"];
    }
    else
    {
        _imageview.image = [UIImage imageNamed:@"top_arrow"];

    }
    [rightbtn addSubview:_imageview];
    _imageview.sd_layout.leftSpaceToView(label,0).centerYEqualToView(rightbtn).widthIs(autoScaleW(10)).heightIs(autoScaleH(8));
    _imageview.userInteractionEnabled = YES;
    UIBarButtonItem * btn = [[UIBarButtonItem alloc]initWithCustomView:rightbtn];
    self.navigationItem.rightBarButtonItem = btn;

    _chooseView = [[UIView alloc]init];
    [self.view addSubview:_chooseView];
    _chooseView.sd_layout.leftSpaceToView(self.view,0).topSpaceToView(self.view,_height).widthIs(kScreenWidth).heightIs(autoScaleH(100));
    _chooseView.hidden = YES;

    NSArray * titleary = @[@"排序",@"时长",];

    for (int i=0; i<2; i++)
    {
        UILabel * qlabel = [[UILabel alloc]init];
        qlabel.text = titleary [i];
        qlabel.font = [UIFont systemFontOfSize:autoScaleW(13)];
        [_chooseView addSubview:qlabel];
        qlabel.sd_layout.leftSpaceToView(_chooseView,autoScaleW(15)).topSpaceToView(_chooseView,autoScaleH(10)+i*autoScaleH(45)).widthIs(autoScaleW(35)).heightIs(autoScaleH(25));
    }
    NSArray * farray = @[@"销售额",@"销售量",@"好评",];

    for (int i=0;i<3; i++) {

        ButtonStyle * fbtn = [ButtonStyle buttonWithType:UIButtonTypeCustom];
        [fbtn setTitle:farray[i] forState:UIControlStateNormal];
        [fbtn setTitleColor:UIColorFromRGB(0xfd7577) forState:UIControlStateSelected];
        [fbtn setTitleColor:RGB(181, 181, 181) forState:UIControlStateNormal];
        fbtn.layer.borderWidth = 1;
        fbtn.layer.borderColor = RGB(181, 181, 181).CGColor;
        if (i==0) {
            fbtn.selected = YES;
            fbtn.layer.borderColor = UIColorFromRGB(0xfd7577).CGColor;
            _daitibtn = fbtn;
        }
        fbtn.tag= 1000+i;
        fbtn.titleLabel.font = [UIFont systemFontOfSize:autoScaleW(13)];
        fbtn.layer.masksToBounds = YES;
        fbtn.layer.cornerRadius = autoScaleW(3);
        [fbtn addTarget:self action:@selector(Click:) forControlEvents:UIControlEventTouchUpInside];
        [_chooseView addSubview:fbtn];
        fbtn.sd_layout.leftSpaceToView(_chooseView, autoScaleW(70)+i*autoScaleW(75)).topSpaceToView(_chooseView,autoScaleH(10)).widthIs(autoScaleW(60)).heightIs(autoScaleH(25));

    }


    NSArray * sarray = @[@"当天",@"7天",@"30天",@"选择",];
    for (int i=0; i<4; i++) {

        ButtonStyle * fbtn = [ButtonStyle buttonWithType:UIButtonTypeCustom];
        [fbtn setTitle:sarray[i] forState:UIControlStateNormal];
        [fbtn setTitleColor:UIColorFromRGB(0xfd7577) forState:UIControlStateSelected];
        [fbtn setTitleColor:RGB(181, 181, 181) forState:UIControlStateNormal];
        fbtn.layer.borderWidth = 1;
        fbtn.layer.borderColor = RGB(181, 181, 181).CGColor;
        if (i==0) {

            fbtn.selected = YES;
            fbtn.layer.borderColor = UIColorFromRGB(0xfd7577).CGColor;
            _tidaibtn = fbtn;
        }
        fbtn.tag=500+i;
        fbtn.titleLabel.font = [UIFont systemFontOfSize:autoScaleW(13)];
        fbtn.layer.masksToBounds = YES;
        fbtn.layer.cornerRadius = autoScaleW(3);
        [fbtn addTarget:self action:@selector(Bian:) forControlEvents:UIControlEventTouchUpInside];
        [_chooseView addSubview:fbtn];
        fbtn.sd_layout.leftSpaceToView(_chooseView, autoScaleW(70)+i*autoScaleW(65)).topSpaceToView(_chooseView,autoScaleH(55)).widthIs(autoScaleW(50)).heightIs(autoScaleH(25));

    }
    _pctary = [NSMutableArray array];
    _nameary = [NSMutableArray array];
    _bianary = [NSMutableArray array];
    _allpctary = [NSMutableArray array];
    _allnameary = [NSMutableArray array];

    _token = TOKEN;
    _storeid = tempStoreID;

    [MBProgressHUD showSuccess:@"请稍等"];
    NSString *uploadUrl = [NSString stringWithFormat:@"%@api/merchant/searchDishAnalysis?token=%@&storeId=%@&flowType=%@&timeType=%@&userId=%@",kBaseURL,_token,_storeid,_clicktype,_timetype, UserId];

    [[QYXNetTool shareManager] postNetWithUrl:uploadUrl urlBody:nil bodyStyle:QYXBodyString header:nil response:QYXJSON success:^(id result) {
        [MBProgressHUD hideHUD];
        //        NSLog(@">>>>>>>>>>>>>%@",result);
        id obj = result[@"obj"];
        NSString * msgtype = [NSString stringWithFormat:@"%@",result[@"msgType"]];

        if ([msgtype isEqualToString:@"0"]) {

            if ([obj isNull]||[obj isKindOfClass:[NSString class]])
            {
                self.placeHolderView.hidden = NO;

            } else {
                self.placeHolderView.hidden = YES;
                _objary = [result objectForKey:@"obj"];

                for (int i=0; i<_objary.count; i++) {
                    NSString * sumfee = _objary[i][@"sumFee"];
                    [_bianary addObject:sumfee];
                    NSString * pct = _objary[i][@"pct"];
                    float pctinteger = [pct floatValue];
                    NSInteger pctint = pctinteger*100;
                    NSString * pc = [NSString stringWithFormat:@"%ld",(long)pctint];
                    [_allpctary addObject:pc];
                    NSString * namestring = _objary[i][@"productName"];
                    [_allnameary addObject:namestring];
                    if (i==0||i==1||i==2)
                    {
                        NSString * pct = _objary[i][@"pct"];
                        float pctinteger = [pct floatValue];
                        NSInteger pctint = pctinteger*100;
                        NSString * pc = [NSString stringWithFormat:@"%ld",(long)pctint];
                        [_pctary addObject:pc];
                        NSString * namestring = _objary[i][@"productName"];

                        [_nameary addObject:namestring];

                    }

                }

                _bigview =[[UIView alloc]init];
                _bigview.frame = CGRectMake(0,_height, kScreenWidth, autoScaleH(230));
                [self.view addSubview:_bigview];

                [self Shanxing];

                _vagetable = [[UITableView alloc]init];
                _vagetable.separatorStyle = UITableViewCellSeparatorStyleNone;
                _vagetable.delegate = self;
                _vagetable.dataSource = self;
                _vagetable.tableHeaderView = _bigview;
                [self.view addSubview:_vagetable];
                _vagetable.sd_layout.leftSpaceToView(self.view,0).rightEqualToView(self.view).topSpaceToView(self.view,_height).heightIs(kScreenHeight-_height);
            }
        } else {
            //请求失败
             [MBProgressHUD showError:@"请求失败"];
        }

    } failure:^(NSError *error) {


    }];


}
#pragma  mark 猫
-(UIImageView *)placeHolderView{
    if (!_placeHolderView) {
        _placeHolderView = [[UIImageView alloc] init];
        _placeHolderView.image = [UIImage imageNamed:@"暂无数据"];
        _placeHolderView.backgroundColor = RGB(242, 242, 242);
        [self.view addSubview:_placeHolderView];
        _placeHolderView.sd_layout
        .centerXEqualToView(self.view)
        .centerYEqualToView(self.view)
        .widthIs(_placeHolderView.image.size.width * 2)
        .heightIs(_placeHolderView.image.size.height * 2);
    }
    [_placeHolderView updateLayout];
    [self.view bringSubviewToFront:_placeHolderView];
    if (_placeHolderView.isHidden) {
        [self.view.subviews  enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if (!obj.isHidden) {
                obj.hidden = YES;
            }
        }];
    } else {
        [self.view.subviews  enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if (obj.isHidden) {
                obj.hidden = NO;
            }
        }];
    }
    return _placeHolderView;
}
#pragma mark 网络请求
-(void)Getaf
{
    if ([_timetype isEqualToString:@"3"]) {

        [MBProgressHUD showSuccess:@"请稍等"];
        NSString *uploadUrl = [NSString stringWithFormat:@"%@api/merchant/searchDishAnalysis?token=%@&storeId=%@&flowType=%@&timeType=%@&beginTime=&endTime=",kBaseURL,_token,_storeid,_clicktype,_timetype];

        [[QYXNetTool shareManager] postNetWithUrl:uploadUrl urlBody:nil bodyStyle:QYXBodyString header:nil response:QYXJSON success:^(id result) {
            [MBProgressHUD hideHUD];
            //            NSLog(@">>>>>>%@",result);

            id obj = result[@"obj"];
            NSString * msgtype = [NSString stringWithFormat:@"%@",result[@"msgType"]];

            if ([msgtype isEqualToString:@"0"]) {

                if ([obj isNull]||[obj isKindOfClass:[NSString class]]) {
                    self.placeHolderView.hidden = NO;
                } else {
                    self.placeHolderView.hidden = YES;
                    NSArray * objary = [result objectForKey:@"obj"];
                    for (int i=0; i<objary.count; i++) {
                        NSString * sumfee = objary[i][@"sumFee"];
                        [_bianary addObject:sumfee];
                        NSString * pct = objary[i][@"pct"];
                        float pctinteger = [pct floatValue];
                        NSInteger pctint = pctinteger*100;
                        NSString * pc = [NSString stringWithFormat:@"%ld",(long)pctint];
                        [_allpctary addObject:pc];
                        NSString * namestring = objary[i][@"productName"];
                        [_allnameary addObject:namestring];
                        if (i==0||i==1||i==2) {
                            NSString * pct = objary[i][@"pct"];
                            float pctinteger = [pct floatValue];
                            NSInteger pctint = pctinteger*100;
                            NSString * pc = [NSString stringWithFormat:@"%ld",(long)pctint];
                            [_pctary addObject:pc];
                            NSString * namestring = objary[i][@"productName"];
                            [_nameary addObject:namestring];
                        }

                    }
                }
            } else {
                [MBProgressHUD showError:@"数据请求失败"];
            }
        } failure:^(NSError *error) {


         }];

    } else {
        [MBProgressHUD showMessage:@"请稍等"];
        NSString *uploadUrl = [NSString stringWithFormat:@"%@api/merchant/searchDishAnalysis?token=%@&storeId=%@&flowType=%@&timeType=%@",kBaseURL,_token,_storeid,_clicktype,_timetype];

        [[QYXNetTool shareManager] postNetWithUrl:uploadUrl urlBody:nil bodyStyle:QYXBodyString header:nil response:QYXJSON success:^(id result) {
            [MBProgressHUD hideHUD];
            //            NSLog(@">>>>>>%@",result);

            [_bianary removeAllObjects];
            [_allnameary removeAllObjects];
            [_allpctary removeAllObjects];
            [_nameary removeAllObjects];
            [_pctary removeAllObjects];
            id obj = result[@"obj"];
            NSString * msgtype = [NSString stringWithFormat:@"%@",result[@"msgType"]];

            if ([msgtype isEqualToString:@"0"]) {

                if ([obj isNull]||[obj isKindOfClass:[NSString class]]) {
                    self.placeHolderView.hidden = NO;
                } else {
                    self.placeHolderView.hidden = YES;
                    NSArray * objary = [result objectForKey:@"obj"];
                        for (int i=0; i<objary.count; i++) {
                            if ([_clicktype isEqualToString:@"sum_fee"]) {
                                NSString * sumfee = objary[i][@"sumFee"];
                                [_bianary addObject:sumfee];
                            }
                            if ([_clicktype isEqualToString:@"product_cnt"]) {

                                NSString * sumfee = objary[i][@"productCnt"];
                                [_bianary addObject:sumfee];
                            }
                            if ([_clicktype isEqualToString:@"love"]) {

                                NSString * sumfee = objary[i][@"love"];
                                [_bianary addObject:sumfee];
                            }
                            NSString * pct = objary[i][@"pct"];
                            float pctinteger = [pct floatValue];
                            NSInteger pctint = pctinteger*100;
                            NSString * pc = [NSString stringWithFormat:@"%ld",(long)pctint];
                            [_allpctary addObject:pc];
                            NSString * namestring = objary[i][@"productName"];
                            [_allnameary addObject:namestring];
                            if (i==0||i==1||i==2) {
                                NSString * pct = objary[i][@"pct"];
                                float pctinteger = [pct floatValue];
                                NSInteger pctint = pctinteger*100;
                                NSString * pc = [NSString stringWithFormat:@"%ld",(long)pctint];
                                [_pctary addObject:pc];
                                NSString * namestring = objary[i][@"productName"];


                                [_nameary addObject:namestring];

                            }

                        }
                        for (UIView *view in _bigview.subviews) {

                            [view removeFromSuperview];
                        }
                        [self Shanxing];
                    }
                    [_vagetable reloadData];
            } else {
                [MBProgressHUD showError:@"请求失败"];
            }
        } failure:^(NSError *error) {


         }];
    }
}
#pragma mark 扇形图
-(void)Shanxing
{
    NSNumber * sum = [_pctary valueForKeyPath:@"@sum.floatValue"];
    NSInteger sumint = [sum integerValue];
    //    NSInteger pctint = sumint*100;
    NSInteger qita = 100-sumint;



    if (_pctary.count >=3) {

        self.chartValues = @[

                             @{@"name":@"first", @"value":_pctary[0], @"color":RGB(72, 117, 187), @"strokeColor":RGB(72, 117, 187)},

                             @{@"name":@"fourth", @"value":_pctary[1], @"color":RGB(80, 156, 135), @"strokeColor":[UIColor whiteColor]},

                             @{@"name":@"five", @"value":_pctary[2], @"color":RGB(234, 158, 56), @"strokeColor":[UIColor whiteColor]},

                             @{@"value":@(qita), @"color":RGB(240, 90, 74), @"strokeColor":[UIColor whiteColor]},

                             ];
    } else if (_pctary.count == 2) {
        self.chartValues = @[

                             @{@"name":@"first", @"value":_pctary[0], @"color":RGB(72, 117, 187), @"strokeColor":RGB(72, 117, 187)},

                             @{@"name":@"fourth", @"value":@(100-[_pctary[0] integerValue]), @"color":RGB(80, 156, 135), @"strokeColor":[UIColor whiteColor]},

                             ];
    } else if (_pctary.count == 1) {
        self.chartValues = @[
                             @{@"name":@"first", @"value":_pctary[0], @"color":RGB(72, 117, 187), @"strokeColor":RGB(72, 117, 187)}];
    } else {

    }
    VBPieChart * chart = [VBPieChart new];
    chart.startAngle = M_PI+M_PI_2;
    chart.holeRadiusPrecent = 0.3;

    [chart setChartValues:_chartValues animation:YES];
    [_bigview addSubview:chart];
    chart.sd_layout.leftSpaceToView(_bigview,kScreenWidth/2-autoScaleW(10)).topSpaceToView(_bigview,autoScaleH(30)).widthIs(autoScaleW(180)).heightIs(autoScaleW(180));


    NSArray * ysary  = @[RGB(72, 117, 187),RGB(80, 156, 135),RGB(234, 158, 56),RGB(240, 90, 74),];


    [_nameary addObject:@"其他"];
    for (int i=0; i<_nameary.count; i++) {
        UILabel * shanlabel =[[UILabel alloc]init];
        shanlabel.text = _nameary[i];
        shanlabel.font = [UIFont systemFontOfSize:autoScaleW(13)];
        shanlabel.textColor = RGB(128, 128, 128);
        CGSize size = [shanlabel.text sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:shanlabel.font,NSFontAttributeName, nil]];
        CGFloat wind = size.width;
        [_bigview addSubview:shanlabel];
        shanlabel.sd_layout.leftSpaceToView(_bigview,autoScaleW(35)).topSpaceToView(_bigview,autoScaleH(50)+i*autoScaleH(30)).widthIs(wind).heightIs(autoScaleH(25));

        UILabel * yslabel = [[UILabel alloc]init];
        yslabel.backgroundColor = ysary[i];
        [_bigview addSubview:yslabel];
        yslabel.sd_layout.leftSpaceToView(_bigview,autoScaleW(17)).topSpaceToView(_bigview,autoScaleH(58)+i*autoScaleH(30)).widthIs(autoScaleW(13)).heightIs(autoScaleH(13));

    }

    UILabel * linlabel = [[UILabel alloc]init];
    linlabel.backgroundColor = RGB(216, 216, 216);
    [_bigview addSubview:linlabel];
    linlabel.sd_layout.leftEqualToView(_bigview).rightEqualToView(_bigview).bottomEqualToView(_bigview).heightIs(0.5);

}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _allpctary.count;

}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    VageTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"vag"];
    if (!cell) {
        cell = [[VageTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"vag"];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (indexPath.row==0) {

        cell.pmlabel.font = [UIFont systemFontOfSize:autoScaleW(13)];
        cell.pmlabel.text = @"排名";
        cell.namelabel.font = [UIFont systemFontOfSize:autoScaleW(13)];
        cell.namelabel.text = @"菜品名称";
        cell.xslabel.font = [UIFont systemFontOfSize:autoScaleW(13)];
        if (_vaginteger==1) {

            cell.xslabel.text = @"销售额";

        }
        if (_vaginteger==2) {
            cell.xslabel.text = @"销售量";

        }
        if (_vaginteger==3) {
            cell.xslabel.text = @"好评";

        }
        cell.zblabel.font = [UIFont systemFontOfSize:autoScaleW(13)];
        cell.zblabel.text = @"占比";
    }
    else
    {
        cell.pmlabel.text = [NSString stringWithFormat:@"%ld",(long)indexPath.row];
        cell.namelabel.text = _allnameary[indexPath.row-1];
        if (_vaginteger==1) {

            cell.xslabel.text = [NSString stringWithFormat:@"%@元",_bianary[indexPath.row-1]];

        }
        if (_vaginteger==2) {
            cell.xslabel.text = [NSString stringWithFormat:@"%@份",_bianary[indexPath.row-1]];;

        }
        if (_vaginteger==3) {
            cell.xslabel.text = [NSString stringWithFormat:@"%@人",_bianary[indexPath.row-1]];;

        }

        cell.zblabel.text = [NSString stringWithFormat:@"%@%%",_allpctary[indexPath.row-1]];;
    }


    return cell;

}
-(void)leftBarButtonItemAction
{
    if (_bgimage) {

        [_bgimage removeFromSuperview];
    }
    [self dismissViewControllerAnimated:YES completion:^{

    }];
}
#pragma mark 筛选按钮
-(void)rightBarItemClick
{
    ButtonStyle *btn = [self.navigationController.view viewWithTag:2017];
    btn.selected = !btn.selected;
    if (btn.selected==YES) {

        _imageview.image = [UIImage imageNamed:@"bottom_arrow"];
        _chooseView.hidden = NO;
        if (_objary==nil||[_objary isNull]) {

        } else {
            _vagetable.sd_layout.leftSpaceToView(self.view,0).topSpaceToView(self.view,autoScaleH(101)+_height).widthIs(kScreenWidth).heightIs(kScreenHeight-autoScaleH(101)-_height);
        }
    } else {
        _imageview.image = [UIImage imageNamed:@"top_arrow"];
        _chooseView.hidden = YES;
        if (_objary==nil||[_objary isNull]) {
        } else {
            _vagetable.sd_layout.leftSpaceToView(self.view,0).topSpaceToView(self.view,_height).heightIs(kScreenHeight - _height).widthIs(kScreenWidth);
        }


    }


}
#pragma mark 第一行选择按钮
-(void)Click:(ButtonStyle *)btn
{
    _daitibtn.selected = NO;
    _daitibtn.layer.borderColor = RGB(181, 181, 181).CGColor;
    btn.selected = YES;
    btn.layer.borderColor = UIColorFromRGB(0xfd7577).CGColor;

    _daitibtn = btn;
    if (btn.tag==1000) {

        _vaginteger =1;
        _clicktype = @"sum_fee";
        [self Getaf];

        [_bgimage removeFromSuperview];
        a=0;

    }
    if (btn.tag==1001) {

        _vaginteger =2;
        _clicktype = @"product_cnt";
        [self Getaf];

        [_bgimage removeFromSuperview];
        a=0;
    }
    if (btn.tag==1002) {

        _vaginteger=3;
        _clicktype = @"love";
        [self Getaf];

        [_bgimage removeFromSuperview];
        a=0;
    }

}
#pragma mark 第二行
-(void)Bian:(ButtonStyle *)bbtn
{
    _tidaibtn.selected = NO;
    _tidaibtn.layer.borderColor = RGB(181, 181, 181).CGColor;
    bbtn.selected = YES;
    bbtn.layer.borderColor = UIColorFromRGB(0xfd7577).CGColor;

    _tidaibtn = bbtn;

    if (bbtn.tag==500) {
        _timetype = @"0";
        [self Getaf];
        [_bgimage removeFromSuperview];
        a=0;
    }
    if (bbtn.tag==501) {
        _timetype = @"1";
        [self Getaf];
        [_bgimage removeFromSuperview];
        a=0;
    }
    if (bbtn.tag==502) {

        _timetype = @"2";
        [self Getaf];
        [_bgimage removeFromSuperview];
        a=0;
    }
    if (bbtn.tag==503) {

        _timetype = @"3";

        a+=1;
        if (a==1) {

            UIWindow * window = [UIApplication sharedApplication].keyWindow;
            _bgimage = [[UIImageView alloc]init];
            _bgimage.image = [UIImage imageNamed:@"日历边框"];
            [window addSubview:_bgimage];
            _bgimage.sd_layout.leftSpaceToView(window,autoScaleW(20)).topSpaceToView(window,autoScaleH(144)).widthIs(kScreenWidth-autoScaleW(50)).heightIs(autoScaleH(400));
            _bgimage.userInteractionEnabled = YES;
            CalendarView * calend = [[CalendarView alloc]initWithStyle:1];
            calend.block = ^(NSString * lstring,NSString* rstring,NSString* choosestr)
            {
                //                NSLog(@"str===%@,%@",lstring,rstring);
                if ([choosestr isEqualToString:@"remove"]) {

                    [_bgimage removeFromSuperview];
                    a =0;
                }
                if ([choosestr isEqualToString:@"sure"]) {

                    [_bgimage removeFromSuperview];
                    a=0;
                    NSString * idd = UserId;
                    NSString * token = TOKEN;

                    NSString * storeid = @"100002";
                    [MBProgressHUD showMessage:@"请稍等"];
                    NSString *uploadUrl = [NSString stringWithFormat:@"%@api/merchant/searchTrafficStatistics?token=%@&userId=%@&storeId=%@&flowType=%@&timeType=%@&timeNum=&beginTime=%@&endTime=%@",kBaseURL,token,idd,storeid,_clicktype,_timetype,lstring,rstring];

                    [[QYXNetTool shareManager] postNetWithUrl:uploadUrl urlBody:nil bodyStyle:QYXBodyString header:nil response:QYXJSON success:^(id result) {
                        [MBProgressHUD hideHUD];
                        //                        NSLog(@"liuliang===%@",result);
                        
                    } failure:^(NSError *error)
                     {
                         [MBProgressHUD hideHUD];
                     }];
                    
                    
                    
                }
                
            };
            
            calend.layer.masksToBounds = YES;
            calend.layer.cornerRadius = 3;
            calend.backgroundColor = [UIColor whiteColor];
            [_bgimage addSubview:calend];
            calend.sd_layout.leftSpaceToView(_bgimage,autoScaleW(2)).topSpaceToView(_bgimage,autoScaleH(12)).widthIs(_bgimage.frame.size.width-autoScaleW(4)).heightIs(autoScaleH(375));
        }
        if (a==2) {
            
            [_bgimage removeFromSuperview];
            a=0;
        }
        
        
        
        
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
