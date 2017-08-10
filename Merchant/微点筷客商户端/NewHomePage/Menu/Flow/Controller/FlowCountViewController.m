//
//  FlowCountViewController.m
//  merchantClient
//
//  Created by 张森森 on 2017/7/31.
//  Copyright © 2017年 张甜. All rights reserved.
//

#import "FlowCountViewController.h"
#import "ZTSelectLabel.h"
#import "MBProgressHUD+SS.h"
@interface FlowCountViewController ()
/** 筛选弹窗   (strong) **/
@property (nonatomic, strong) ZTSelectLabel *selectView;
@property (nonatomic,copy)   NSString * flowtypestr;//查询类型
@property (nonatomic,copy)   NSString * timetypestr;//查询时间
@property (nonatomic,copy)   NSString * daystr;//本月几号
@property (nonatomic,copy) NSString * weekstr;//周几
@property (nonatomic,copy) NSString * numberStr;//代替daystr或weeker
@property (nonatomic,copy) NSString * duibistr;//对比额；
@property (nonatomic,copy) NSString * sumStr;//展示总额；
@property (nonatomic,strong) NSMutableArray * orderary;//订单数据
@property (nonatomic,strong) NSMutableArray * fangkeary;//访客数据
@property (nonatomic,strong) NSMutableArray * priceary;//营业额数据
@property (nonatomic,strong)  UIView * ratioView;//对比额视图
@property (nonatomic,strong) UIView * orderOrvisit;//订单和访客视图
@property (nonatomic,strong) UILabel * linelabell;
@property (nonatomic,strong) UIView * turnoverView;//营业额视图
@property (nonatomic,strong) NSArray * timeAry;//开始结束时间
@end

@implementation FlowCountViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.titleView.text = @"流量统计";
    self.view.backgroundColor = [UIColor whiteColor];
    
//    _height = [[UIApplication sharedApplication] statusBarFrame].size.height + self.navigationController.navigationBar.frame.size.height;
    
    [self.rightBarItem setImage:[UIImage imageNamed:@"bottom_arrow"] forState:UIControlStateNormal];
    [self.rightBarItem setTitle:@"筛选" forState:UIControlStateNormal];
    self.rightBarItem.hidden = NO;
    self.rightBarItem.ztButtonStyle = ZTButtonStyleTextLeftImageRight;
 //本月，本周时间
    NSDate *now = [NSDate date];
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSUInteger unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond| NSCalendarUnitWeekday;
    
    NSDateComponents *dateComponent = [calendar components:unitFlags fromDate:now];
    NSInteger day = [dateComponent day];
    NSInteger weekday = [dateComponent weekday];
    NSArray * arrWeek=[NSArray arrayWithObjects:@"7",@"1",@"2",@"3",@"4",@"5",@"6", nil];
    _weekstr = [NSString stringWithFormat:@"%@",arrWeek[weekday-1]];
    _daystr = [NSString stringWithFormat:@"%ld",day];
   
    _orderary = [NSMutableArray array];
    _priceary = [NSMutableArray array];
    _fangkeary = [NSMutableArray array];
 
    if (_xianint ==2) {//从财务管理的 营业分析跳转过来
        
        _flowtypestr = @"0";
    }else{
        _flowtypestr = @"1";

    }
    _timetypestr = @"0";
    _numberStr = _daystr;
    [self updateDataWithFlowType:_flowtypestr timeType:_timetypestr zoneTime:@"&beginTime=&endTime="];
    
}
//筛选点击
-(void)rightBarButtonItemAction:(ButtonStyle *)sender{
    sender.selected = !sender.selected;
    if (sender.selected) {
        [self.rightBarItem setImage:[UIImage imageNamed:@"top_arrow"] forState:UIControlStateNormal];
    } else {
        [self.rightBarItem setImage:[UIImage imageNamed:@"bottom_arrow"] forState:UIControlStateSelected];
    }
    if (_selectView == nil) {
        _selectView = [[ZTSelectLabel alloc] initWithTitleArr:@[@"排序", @"时长"] TopArr:@[@"订单",@"访客",@"营业额"] BottomArr:@[@"当天",@"本周",@"本月",@"选择"] formatOptions:@{SSCalendarType:@(CalendarTypeDouble),ZTTouchObject:sender}];
    }
    [_selectView showSelectButtonView];
    @weakify(self);
    
    _selectView.buttonClickBlock = ^(NSInteger type, NSInteger index, NSArray<NSString *> *timeArr, ButtonStyle *sender) {
        
        @strongify(self);
        
        if (type == 0) {
            
            switch (index) {
                case 0:
                    _flowtypestr = @"1";
                    break;
                case 1:
                    _flowtypestr = @"2";
                    break;
                case 2:
                    _flowtypestr = @"0";
                    break;
                default:
                    break;
            }
        } else {
            switch (index) {
                case 0:
                    _timetypestr = @"0";
                    _numberStr = @"1";
                    break;
                case 1:
                    _timetypestr = @"1";
                    _numberStr = _weekstr;
                    break;
                case 2:
                    _timetypestr = @"2";
                    _numberStr = _daystr;
                    break;
                case 3:
                    _timetypestr = @"3";
                    break;
                    
                default:
                    break;
            }
        }
        
        if (timeArr!=nil) {
            
            _timeAry = [timeArr copy];
        }
        if ([self.timetypestr isEqualToString:@"3"]) {
            if (_timeAry!=nil) {
                 [self updateDataWithFlowType:self.flowtypestr timeType:self.timetypestr zoneTime:[NSString stringWithFormat:@"&beginTime=%@&endTime=%@", self.timeAry[0], self.timeAry[1]]];
            }
           
        } else {
           
            [self updateDataWithFlowType:self.flowtypestr timeType:self.timetypestr zoneTime:@"&beginTime=&endTime="];
        }
        
    };
}
#pragma mark 网络请求
-(void)updateDataWithFlowType:(NSString *)flowType timeType:(NSString *)timeType zoneTime:(NSString *)zoneTime{
    
    [MBProgressHUD showMessage:@"请稍等"];
    NSString * urlstr = [NSString stringWithFormat:@"%@api/merchant/searchTrafficStatistics?token=%@&userId=%@&storeId=%@&flowType=%@&timeType=%@&timeNum=%@%@",kBaseURL,TOKEN,UserId,storeID,_flowtypestr,_timetypestr,_numberStr,zoneTime];
    
    [[QYXNetTool shareManager]postNetWithUrl:urlstr urlBody:nil bodyStyle:QYXBodyString header:nil response:QYXJSON success:^(id result) {
        [MBProgressHUD hideHUD];
        NSLog(@">>>><<<<%@",result);
        if ([result[@"msgType"] isEqualToString:@"1"]) {
            [SVProgressHUD showErrorWithStatus:@"请求失败"];
        } else {
            NSArray * objdictary = [result objectForKey:@"obj"];
            NSDictionary * objdict = objdictary.firstObject;
            
            if ([_flowtypestr isEqualToString:@"0"]) {//营业额
                NSString * totalfee = [NSString stringWithFormat:@"%@",[objdict objectForKey:@"totalFee"]];
                totalfee = [totalfee isNull] ? @"0" : totalfee;
                float total = [totalfee floatValue];
                NSString * totalstr = [NSString stringWithFormat:@"%.2f",total];
                
                _sumStr = totalstr;
                
                NSArray * objdictary = [result objectForKey:@"obj"];
                NSDictionary * objdict = objdictary.firstObject;
                NSString * comparedStatus = [[objdict objectForKey:@"compared"] isNull] ? @"0" : [objdict objectForKey:@"compared"];
                NSString * avgtotalstr = [[objdict objectForKey:@"avgTotalFee"] isNull] ? @"0" : [objdict objectForKey:@"avgTotalFee"];
                float avgto = [avgtotalstr floatValue];
                NSString * avgtotal = [NSString stringWithFormat:@"%.2f",avgto];
                NSString * onlinetofee = [[objdict objectForKey:@"onlineTotalFee"] isNull] ? @"0" : [objdict objectForKey:@"onlineTotalFee"];
                float online = [onlinetofee floatValue];
                NSString * onlineto = [NSString stringWithFormat:@"%.2f",online];
                NSString * instoreto = [[objdict objectForKey:@"inStoreTotalFee"] isNull] ? @"0" : [objdict objectForKey:@"inStoreTotalFee"];
                float instore = [instoreto floatValue];
                NSString * instorefee = [NSString stringWithFormat:@"%.2f",instore];
                NSString * discounted = [[objdict objectForKey:@"discountedPrice"] isNull] ? @"0" : [objdict objectForKey:@"discountedPrice"];
                float discount = [discounted floatValue];
                NSString * discountprice = [NSString stringWithFormat:@"%.2f",discount];
                
                [_priceary removeAllObjects];
                [_priceary addObject:onlineto];
                [_priceary addObject:instorefee];
                [_priceary addObject:discountprice];
                [_priceary addObject:avgtotal];
                
                _duibistr = comparedStatus;
                [self ratioUI];
                [self turnoverUI];
            }
            if ([_flowtypestr isEqualToString:@"1"]) {//访客
                NSString * cntstr = [NSString stringWithFormat:@"%@",[objdict objectForKey:@"orderCnt"]] ;
                cntstr = [cntstr isNull] ? @"0" : cntstr;
                _sumStr = cntstr;
                [_orderary removeAllObjects];
                NSString * onlineorder = [objdict objectForKey:@"onlineOrder"];
                onlineorder = [onlineorder isNull] ? @"0" : onlineorder;
                NSString * oldorder = [objdict objectForKey:@"oldCustOrder"];
                oldorder = [oldorder isNull] ? @"0" : oldorder;
                NSString * avgorder = [objdict objectForKey:@"avgFee"];
                avgorder = [avgorder isNull] ? @"0" : avgorder;
                NSString * inorderstr = [objdict objectForKey:@"inStoreOrder"];
                inorderstr = [inorderstr isNull] ? @"0" : inorderstr;
                NSString * neworder = [objdict objectForKey:@"newCustOrder"];
                neworder = [neworder isNull] ? @"0" : neworder;
                
                [_orderary addObject:onlineorder];
                [_orderary addObject:oldorder];
                [_orderary addObject:avgorder];
                [_orderary addObject:inorderstr];
                [_orderary addObject:neworder];
                
                NSString * avguser = [objdict objectForKey:@"avgUser"];
                
                [_orderary addObject:avguser];
                NSString * duibis = [objdict objectForKey:@"compared"];
                _duibistr = duibis;
                [self ratioUI];
                [self orderUI];
            }
            if ([_flowtypestr isEqualToString:@"2"]) {//营业额
                NSString * cnstr = [[NSString stringWithFormat:@"%@",[objdict objectForKey:@"accessCnt"]] isNull] ? @"0": [objdict objectForKey:@"accessCnt"];
                _sumStr = cnstr;
                [_fangkeary removeAllObjects];
                NSString * visitors = [[objdict objectForKey:@"visitorsCnt"] isNull] ? @"0" :[objdict objectForKey:@"visitorsCnt"];
                NSString * newvisi = [[objdict objectForKey:@"newVisitorsCnt"] isNull] ? @"0" :[objdict objectForKey:@"newVisitorsCnt"];
                NSString * collectcnt = [[objdict objectForKey:@"collectionCnt"] isNull] ? @"0" :[objdict objectForKey:@"collectionCnt"];
                NSString * dinReserCnt = [[objdict objectForKey:@"dinReserCnt"] isNull] ? @"0" :[objdict objectForKey:@"dinReserCnt"];
                NSString * evaBack = [[objdict objectForKey:@"evaBackCnt"] isNull] ? @"0" :[objdict objectForKey:@"evaBackCnt"];
                
                [_fangkeary addObject:cnstr];
                [_fangkeary addObject:visitors];
                [_fangkeary addObject:newvisi];
                [_fangkeary addObject:collectcnt];
                [_fangkeary addObject:dinReserCnt];
                [_fangkeary addObject:evaBack];
                NSString * duibis = [objdict objectForKey:@"compared"];
                _duibistr = duibis;
                [self ratioUI];
                [self orderUI];
            }
        }
        
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUD];
    }];
    
}
- (void)ratioUI{//对比视图
    if (!_ratioView) {
        
        _ratioView  = [[UIView alloc]init];
        _ratioView.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:_ratioView];
        _ratioView.sd_layout.leftEqualToView(self.view).rightEqualToView(self.view).topSpaceToView(self.view, 64).heightIs(autoScaleH(130));

    }
    for (UIView * view in _ratioView.subviews) {
        
        [view removeFromSuperview];
    }
    UILabel * tedaylabel = [[UILabel alloc]init];
    if ([_flowtypestr isEqualToString:@"1"]) {//订单
        
        if ([_timetypestr isEqualToString:@"0"]) {
            
            tedaylabel.text = @"当日订单量";
            
        }
        else if ([_timetypestr isEqualToString:@"1"])
        {
            
            tedaylabel.text = @"本周订单量";
            
        }
        else if ([_timetypestr isEqualToString:@"2"])
        {
            tedaylabel.text = @"本月订单量";
            
        }else{
            
            tedaylabel.text = @"所选时间段订单量";
        }
        
        
    }else if ([_flowtypestr isEqualToString:@"2"]){//访客
        
        if ([_timetypestr isEqualToString:@"0"]) {
            
            tedaylabel.text = @"当日访问量";
            
        }
        else if ([_timetypestr isEqualToString:@"1"])
        {
            
            tedaylabel.text = @"本周访问量";
            
        }
        else if ([_timetypestr isEqualToString:@"2"])
        {
            tedaylabel.text = @"本月访问量";
            
        }else{
            
            tedaylabel.text = @"所选时间段访问量";
        }
    }else if ([_flowtypestr isEqualToString:@"0"]){
        if ([_timetypestr isEqualToString:@"0"]) {
            
            tedaylabel.text = @"当日营业额";
            
        }
        else if ([_timetypestr isEqualToString:@"1"])
        {
            
            tedaylabel.text = @"本周营业额";
            
        }
        else if ([_timetypestr isEqualToString:@"2"])
        {
            tedaylabel.text = @"本月营业额";
            
        }else{
            
            tedaylabel.text = @"所选时间段营业额";
        }
        
    }
    tedaylabel.textColor = [UIColor blackColor];
    tedaylabel.font = [UIFont systemFontOfSize:autoScaleW(13)];
    [_ratioView addSubview:tedaylabel];
    tedaylabel.sd_layout.centerXEqualToView(_ratioView).topSpaceToView(_ratioView,autoScaleH(30)).heightIs(autoScaleH(15));
    [tedaylabel setSingleLineAutoResizeWithMaxWidth:200];
    
    UILabel * moneylabel = [[UILabel alloc]init];
    if ([_flowtypestr isEqualToString:@"0"]) {
        moneylabel.text = [NSString stringWithFormat:@"￥%@",_sumStr];

    }else if ([_flowtypestr isEqualToString:@"1"]){
        moneylabel.text = [NSString stringWithFormat:@"%@单",_sumStr];

    }else{
        moneylabel.text = [NSString stringWithFormat:@"%@人",_sumStr];

    }
    moneylabel.textColor = RGB(9, 9, 9);
    moneylabel.font = [UIFont systemFontOfSize:autoScaleW(25)];
    CGSize size = [moneylabel.text sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:moneylabel.font,NSFontAttributeName, nil]];
    CGFloat wind = size.width;
    [_ratioView addSubview:moneylabel];
    moneylabel.sd_layout.leftSpaceToView(_ratioView,autoScaleW(138)).topSpaceToView(tedaylabel,autoScaleH(30)).widthIs(wind).heightIs(autoScaleH(22));
    
    if (![_timetypestr isEqualToString:@"3"]) {
        
        for (int a =0; a <2; a ++) {
            
            UILabel * adlabel =[[UILabel alloc]init];
            if (a==0) {
                
                adlabel.text = _duibistr;
                
            }
            if (a==1) {
                
                if ([_timetypestr isEqualToString:@"0"])
                {
                    adlabel.text = @"对比昨天";
                    
                }
                if ([_timetypestr isEqualToString:@"1"]) {
                    
                    adlabel.text = @"对比上周";
                }
                if ([_timetypestr isEqualToString:@"2"]) {
                    
                    adlabel.text = @"对比上月";
                }
             }
            adlabel.font = [UIFont systemFontOfSize:autoScaleW(9)];
            adlabel.textColor = [UIColor lightGrayColor];
            if (a ==0) {
                adlabel.backgroundColor = RGB(234, 158, 60);
                adlabel.textColor = [UIColor whiteColor];
                adlabel.textAlignment = NSTextAlignmentCenter;
            }
            [_ratioView addSubview:adlabel];
            adlabel.sd_layout.leftSpaceToView(moneylabel,autoScaleW(13)).topSpaceToView(tedaylabel,autoScaleH(30)+a *autoScaleH(15)).widthIs(autoScaleW(40)).heightIs(autoScaleH(12));
        }

    }
    
    _linelabell = [[UILabel alloc]init];
    _linelabell.backgroundColor = [UIColor lightGrayColor];
    [_ratioView addSubview:_linelabell];
    _linelabell.sd_layout.leftSpaceToView(_ratioView,autoScaleW(20)).rightSpaceToView(_ratioView,autoScaleW(20)).topSpaceToView(moneylabel,autoScaleH(33)).heightIs(1);
    
}
- (void)orderUI{//订单，访客
    NSArray * imageary = @[@"预定-(1)",@"老访客",@"lll",@"门店订单",@"新增客户",@"人均",];
    NSArray * sstitary = @[@"在线预定订单",@"老客户订单",@"订单均价",@"到店用餐订单",@"新客户订单",@"客单均价",];
    
    NSArray * fimageqry = @[@"人人",@"公司人数",@"新访客",@"收藏",@"点餐",@"评价",];
    NSArray * ftitary  = @[@"访问人次",@"访问人数",@"新增访客",@"被收藏",@"预定用餐",@"评价反馈",];
    
    if (!_orderOrvisit) {
        
        _orderOrvisit = [[UIView alloc]init];
        _orderOrvisit.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:_orderOrvisit];
        _orderOrvisit.sd_layout.leftEqualToView(self.view).rightEqualToView(self.view).topSpaceToView(_ratioView, 0).heightIs(self.view.frame.size.height - _ratioView.height_sd);
        
       
            
            _turnoverView.hidden = YES;
    
        
    }else{
        _turnoverView.hidden = YES;
        _orderOrvisit.hidden = NO;
    }
    
    for (UIView * view in _orderOrvisit.subviews) {
        
        [view removeFromSuperview];
    }
    
       for (int b=0; b <6; b++) {
        UIView * zhanshiview = [[UIView alloc]init];
        [_orderOrvisit addSubview:zhanshiview];
        zhanshiview.sd_layout.leftSpaceToView(_orderOrvisit,(b%3)*(kScreenWidth/3)).topSpaceToView(_orderOrvisit,autoScaleH(30)+(b/3)*autoScaleH(102)).widthIs(kScreenWidth/3).heightIs(autoScaleH(102));
        UIImageView * imageview = [[UIImageView alloc]init];
            if ([_flowtypestr isEqualToString:@"1"]) {
                imageview.image = [UIImage imageNamed:imageary[b]];

            }else{
                imageview.image = [UIImage imageNamed:fimageqry[b]];

            }
        [zhanshiview addSubview:imageview];
        imageview.sd_layout.centerXEqualToView(zhanshiview).topSpaceToView(zhanshiview,autoScaleH(10)).widthIs(autoScaleW(28)).heightIs(autoScaleH(28));
        UILabel * zssslabel = [[UILabel alloc]init];
            if ([_flowtypestr isEqualToString:@"1"]) {
                
                zssslabel.text = sstitary[b];

            }else{
                zssslabel.text = ftitary[b];

            }
        zssslabel.font = [UIFont systemFontOfSize:autoScaleW(11)];
        zssslabel.textColor = [UIColor grayColor];
        zssslabel.textAlignment = NSTextAlignmentCenter;
        [zhanshiview addSubview:zssslabel];
        zssslabel.sd_layout.centerXEqualToView(zhanshiview).topSpaceToView(imageview,autoScaleH(10)).widthIs(zhanshiview.frame.size.width).heightIs(autoScaleH(15));
        UILabel * dfdlabel = [[UILabel alloc]init];
            if ([_flowtypestr isEqualToString:@"1"]) {
                
                if ([_orderary[b] isNull]) {
                    dfdlabel.text = @"0单";
                }
                else
                {
                    dfdlabel.text = [NSString stringWithFormat:@"%@单",_orderary[b]];
                }
                
                if (b==2||b==5) {
                    
                    dfdlabel.text = [NSString stringWithFormat:@"%@",_orderary[b]];
                }
            }else if ([_flowtypestr isEqualToString:@"2"]){
                
                dfdlabel.text = [NSString stringWithFormat:@"%@人",_fangkeary[b]];
            }
       
        
        dfdlabel.textColor =[UIColor blackColor];
        dfdlabel.textAlignment = NSTextAlignmentCenter;
        dfdlabel.font =[UIFont systemFontOfSize:autoScaleW(15)];
        [zhanshiview addSubview:dfdlabel];
        dfdlabel.sd_layout.centerXEqualToView(zhanshiview).topSpaceToView(zssslabel,autoScaleH(10)).widthIs(zhanshiview.frame.size.width).heightIs(autoScaleH(20));
        if (b==0||b==1||b==3||b==4)
        {
            UILabel * dsdlabel = [[UILabel alloc]init];
            dsdlabel.backgroundColor = [UIColor grayColor];
            [zhanshiview addSubview:dsdlabel];
            dsdlabel.sd_layout.topEqualToView(zhanshiview).rightEqualToView(zhanshiview).widthIs(1).heightIs(zhanshiview.frame.size.height);
            
        }
        if (b==0||b==1||b==2)
            
        {  UILabel * sslinelabel = [[UILabel alloc]init];
            sslinelabel.backgroundColor = [UIColor grayColor];
            [zhanshiview addSubview:sslinelabel];
            sslinelabel.sd_layout.rightEqualToView(zhanshiview).leftEqualToView(zhanshiview).heightIs(1).bottomEqualToView(zhanshiview);
            
        }
    }
    
}

- (void)turnoverUI{//营业额
    NSArray *yimageary = @[@"定金",@"金额",@"补贴",@"日均",];
    NSArray * ytitary = @[@"在线预定金额",@"到店点餐金额",@"活动补贴",@"日均营业额",];
    
    if (!_turnoverView) {
        
        _turnoverView = [[UIView alloc]init];
        [self.view addSubview:_turnoverView];
        _turnoverView.sd_layout.leftEqualToView(self.view).rightEqualToView(self.view).topSpaceToView(_ratioView, 0).heightIs(self.view.frame.size.height - _ratioView.height_sd);
        
            _orderOrvisit.hidden = YES;
    }else{
        _orderOrvisit.hidden = YES;
        _turnoverView.hidden = NO;
    }
    
    for (UIView * view in _turnoverView.subviews) {//先删除子视图，重新加载
        
        [view removeFromSuperview];
    }
    
    for (int i=0; i<4; i++) {
        UIView * zhanshiview = [[UIView alloc]init];
        [_turnoverView addSubview:zhanshiview];
        if (i<3) {
            zhanshiview.sd_layout.leftSpaceToView(_turnoverView,i*(kScreenWidth/3)).topSpaceToView(_turnoverView,autoScaleH(30)).widthIs(kScreenWidth/3).heightIs(autoScaleH(102));
        }
        if (i==3) {
            
            zhanshiview.sd_layout.leftSpaceToView(_turnoverView,(kScreenWidth/3)).topSpaceToView(_turnoverView,autoScaleH(30)+autoScaleH(102)).widthIs(kScreenWidth/3).heightIs(autoScaleH(102));
        }
        
        UIImageView * imageview = [[UIImageView alloc]init];
        imageview.image = [UIImage imageNamed:yimageary[i]];
        [zhanshiview addSubview:imageview];
        imageview.sd_layout.centerXEqualToView(zhanshiview).topSpaceToView(zhanshiview,autoScaleH(10)).widthIs(autoScaleW(28)).heightIs(autoScaleH(28));
        UILabel * zssslabel = [[UILabel alloc]init];
        zssslabel.text = ytitary[i];
        zssslabel.font = [UIFont systemFontOfSize:autoScaleW(11)];
        zssslabel.textColor = [UIColor grayColor];
        zssslabel.textAlignment = NSTextAlignmentCenter;
        [zhanshiview addSubview:zssslabel];
        zssslabel.sd_layout.centerXEqualToView(zhanshiview).topSpaceToView(imageview,autoScaleH(10)).widthIs(zhanshiview.frame.size.width).heightIs(autoScaleH(15));
        UILabel * dfdlabel = [[UILabel alloc]init];
        dfdlabel.text = [NSString stringWithFormat:@"￥%@",_priceary[i]];
        dfdlabel.textColor =[UIColor blackColor];
        dfdlabel.textAlignment = NSTextAlignmentCenter;
        dfdlabel.font =[UIFont systemFontOfSize:autoScaleW(15)];
        [zhanshiview addSubview:dfdlabel];
        dfdlabel.sd_layout.centerXEqualToView(zhanshiview).topSpaceToView(zssslabel,autoScaleH(10)).widthIs(zhanshiview.frame.size.width).heightIs(autoScaleH(20));
        
        if (i==0||i==1||i==3) {
            
            
            UILabel * dsdlabel = [[UILabel alloc]init];
            dsdlabel.backgroundColor = [UIColor grayColor];
            [zhanshiview addSubview:dsdlabel];
            dsdlabel.sd_layout.topEqualToView(zhanshiview).rightEqualToView(zhanshiview).widthIs(1).heightIs(zhanshiview.frame.size.height);
            
        }
        if (i==0||i==1||i==2)
            
        {  UILabel * sslinelabel = [[UILabel alloc]init];
            sslinelabel.backgroundColor = [UIColor grayColor];
            [zhanshiview addSubview:sslinelabel];
            sslinelabel.sd_layout.rightEqualToView(zhanshiview).leftEqualToView(zhanshiview).heightIs(1).bottomEqualToView(zhanshiview);
            
        }
        if (i==3) {
            
            UILabel * dsdlabel = [[UILabel alloc]init];
            dsdlabel.backgroundColor = [UIColor grayColor];
            [zhanshiview addSubview:dsdlabel];
            dsdlabel.sd_layout.topEqualToView(zhanshiview).leftEqualToView(zhanshiview).widthIs(1).heightIs(zhanshiview.frame.size.height);
        }
    
    }
    
}
-(void)leftBarButtonItemAction
{
   
    if (_xianint==2) {
        
        [self.navigationController popViewControllerAnimated:YES];
    }
    else
    {
        [self dismissViewControllerAnimated:YES completion:^{
            
        }];
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
