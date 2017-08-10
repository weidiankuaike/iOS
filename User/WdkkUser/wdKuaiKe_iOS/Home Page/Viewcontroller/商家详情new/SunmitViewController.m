//
//  SunmitViewController.m
//  wdKuaiKe_iOS
//
//  Created by 张森森 on 17/1/16.
//  Copyright © 2017年 weiDianKuaiKe. All rights reserved.
//

#import "SunmitViewController.h"
#import "UIBarButtonItem+SSExtension.h"
#import "SunmitTableViewCell.h"
#import "MBProgressHUD+SS.h"
#import "QYXNetTool.h"
#import "RevisePhoneViewController.h"
#import "OrderdetailViewController.h"
#import "LoginViewController.h"
#import "WMCustomDatePicker.h"
#import "NSObject+JudgeNull.h"
#import "ZTAddOrSubAlertView.h"
#import "DeviceSet.h"
#import <XGPush.h>
#import "PayViewController.h"
#import "CanuserTicketViewController.h"
@interface SunmitViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong)UITextView * feedbackview;//备注
@property (nonatomic,strong)UILabel * pllabel;
@property (nonatomic,strong)UIScrollView * bigview;
@property (nonatomic,copy)NSString * idstr;//
@property (nonatomic,copy)NSString * numstr;//
@property (nonatomic, strong) UIView * pickview;//时间选择
@property (nonatomic, strong) UIView * shezhivieww;//人数选择
@property (nonatomic,strong)UIButton *daybtn;//选择人数代替按钮
@property (nonatomic,copy)NSString * choosetimestr;
@property (nonatomic,strong)UILabel * substituteTime;//接收重新选择时间的label
@property (nonatomic,strong)UILabel * substitutepeople;//接受重新选择人数的label
@property (nonatomic,strong)UITableView * ordertable;
@property (nonatomic,strong)UILabel * feelabel;
@property (nonatomic,assign)float fee;//总价
@property (nonatomic,retain)UIView * backgroundView;
@property (nonatomic,retain)UIView * peopleBackView;
@property (nonatomic,strong)NSDictionary* objDict;
@property (nonatomic,strong)UIView * remarksview;
@property (nonatomic,assign)NSInteger couint;//是否有优惠券 0 没 1 有
@property (nonatomic,assign)NSInteger storeAc;//店铺是否有活动
@property (nonatomic,strong)NSMutableArray * btnAry;
@property (nonatomic,copy)NSString * actId;//优惠券 ，活动id
@property (nonatomic,strong)NSMutableArray * imageAry;

@end

@implementation SunmitViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = YES;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    UILabel * titlabel = [[UILabel alloc]init];
    titlabel.frame = CGRectMake(0, 0, 80, 30);
    titlabel.textAlignment = NSTextAlignmentCenter;
    titlabel.font = [UIFont systemFontOfSize:15];
    titlabel.text = @"提交订单";
    titlabel.textColor = [UIColor whiteColor];
    self.navigationItem.titleView = titlabel;
    UIBarButtonItem * backbtn = [UIBarButtonItem itemWithTarget:self Action:@selector(Back) image:@"left-1" selectImage:nil];
    self.navigationItem.leftBarButtonItem = backbtn;
    
    _backgroundView = nil;
    _peopleBackView = nil;
    _numstr = @"";
    _actId = @"";
    [self getDine];
    
    if (_dictary.count!=0) {//有菜品时候 加载 菜品信息和优惠券  没有 直接提交订单
        
        [self getData];

    }else{
        [self dishView];
    }
}
#pragma mark 获取菜品id串和数量
- (void)getDine
{
    if (_dictary.count!=0) {
        
        NSMutableArray * idary = [NSMutableArray array];
        NSMutableArray * numary = [NSMutableArray array];
        
        for (int i=0; i<_dictary.count; i++) {
            
            NSMutableDictionary * dict = _dictary[i];
            NSString * idstr = dict[@"id"];
            NSString * numstr = dict[@"number"];
            
            [idary addObject:idstr];
            [numary addObject:numstr];
            
        }
        
        NSString * upidstr = [idary componentsJoinedByString:@","];
        NSString * upnumstr = [numary componentsJoinedByString:@","];
        _idstr = [NSString stringWithFormat:@"%@,",upidstr];
        _numstr = [NSString stringWithFormat:@"%@,",upnumstr];
        
        
    }else
    {
        _idstr = @"";
    }
}
- (void)getData{
    
    __weak NSString * sumstr = nil;
    
    if ([_feestr isEqualToString:@""]) {
        sumstr = @"0";
    }else{
        sumstr = [_feestr substringFromIndex:1];

    }
    [MBProgressHUD showMessage:@"请稍等"];
    NSString * url = [NSString stringWithFormat:@"%@/api/order/reservationOrderData?token=%@&userId=%@&storeId=%@&totalFee=%@",commonUrl,Token,Userid,_storeid,sumstr];
    
    NSArray * urlary = [url componentsSeparatedByString:@"?"];
    
    [[QYXNetTool shareManager]postNetWithUrl:urlary.firstObject urlBody:urlary.lastObject bodyStyle:QYXBodyString header:nil response:QYXJSON success:^(id result) {
        [MBProgressHUD hideHUD];
        NSLog(@"<><>><><>%@",result);
        
        NSString * msgtype = [NSString stringWithFormat:@"%@",result[@"msgType"]];
        if ([msgtype isEqualToString:@"0"]) {
            
            _objDict = result[@"obj"];
            [self dishView];
        }else if([msgtype isEqualToString:@"2000"]){
            
            LoginViewController * loginview = [[LoginViewController alloc]init];
            [self.navigationController pushViewController:loginview animated:YES];
            
        }else{
            
            [MBProgressHUD showError:@"请求失败"];
        }
        
        
    } failure:^(NSError *error) {
        
        [MBProgressHUD hideHUD];
        [MBProgressHUD showError:@"网络错误"];
    }];
    
    
}
- (void)dishView{
    
    
    _bigview = [[UIScrollView alloc]init];
    _bigview.showsVerticalScrollIndicator = NO;
    _bigview.backgroundColor = RGB(238, 238, 238);
    if (_dictary.count!=0) {
        _bigview.contentSize = CGSizeMake(GetWidth, autoScaleH(210)+autoScaleH(70)+_dictary.count*autoScaleH(20)+ autoScaleH(45)+autoScaleH(90)+ autoScaleH(60));
        
    }else{
        
        _bigview.contentSize = CGSizeMake(GetWidth,self.view.frame.size.height);
        _bigview.scrollEnabled = NO;
    }
    
    [self.view addSubview:_bigview];
    _bigview.userInteractionEnabled = YES;
    _bigview.sd_layout.leftEqualToView(self.view).rightEqualToView(self.view).widthIs(GetWidth).heightIs(self.view.frame.size.height);
    
    
    NSMutableArray * xinxiary = [NSMutableArray arrayWithObjects:_timestr,_peoplestr, nil];
    NSArray * leftary = @[@"用餐时间",@"用餐人数"];
    for (int i =0; i<2; i++)
    {
        
        
        UIButton * sunmitbtn = [UIButton buttonWithType:UIButtonTypeCustom];
        sunmitbtn.backgroundColor = [UIColor whiteColor];
        sunmitbtn.tag = 1000 + i;
        [sunmitbtn addTarget:self action:@selector(AgainChoosetimeandnum:) forControlEvents:UIControlEventTouchUpInside];
        [_bigview addSubview:sunmitbtn];
        sunmitbtn.sd_layout.leftEqualToView(_bigview).rightEqualToView(_bigview).topSpaceToView(_bigview,i*autoScaleH(45)).heightIs(autoScaleH(45));
        
        UILabel * leftlabel = [[UILabel alloc]init];
        leftlabel.text = leftary[i];
        leftlabel.font = [UIFont systemFontOfSize:autoScaleW(13)];
        leftlabel.textColor = [UIColor blackColor];
        [sunmitbtn addSubview:leftlabel];
        leftlabel.sd_layout.leftSpaceToView(sunmitbtn,autoScaleW(15)).topSpaceToView(sunmitbtn,autoScaleH(15)).widthIs(60).heightIs(autoScaleH(15));
        
        UIImageView * rightimage = [[UIImageView alloc]init];
        rightimage.image = [UIImage imageNamed:@"arrow-1-拷贝"];
        [sunmitbtn addSubview:rightimage];
        rightimage.sd_layout.rightSpaceToView(sunmitbtn,autoScaleW(15)).topSpaceToView(sunmitbtn,autoScaleH(15)).widthIs(autoScaleW(10)).heightIs(autoScaleH(15));
        
        UILabel * rightlabel = [[UILabel alloc]init];
        if (i==0) {
            
            rightlabel.text = _timestr;
            _substituteTime = rightlabel;
        }
        else if (i==1)
        {
            rightlabel.text = _peoplestr;
            _substitutepeople = rightlabel;
        }
        rightlabel.text = xinxiary[i];
        rightlabel.textColor = [UIColor blackColor];
        rightlabel.textAlignment = NSTextAlignmentCenter;
        rightlabel.font = [UIFont systemFontOfSize:autoScaleW(13)];
        [sunmitbtn addSubview:rightlabel];
        rightlabel.sd_layout.rightSpaceToView(rightimage,autoScaleW(10)).topSpaceToView(sunmitbtn,autoScaleH(15)).heightIs(autoScaleH(15));
        [rightlabel setSingleLineAutoResizeWithMaxWidth:200];
        
        UILabel * firstlinelabel = [[UILabel alloc]init];
        firstlinelabel.backgroundColor = UIColorFromRGB(0xeeeeee);
        [sunmitbtn addSubview:firstlinelabel];
        firstlinelabel.sd_layout.leftEqualToView(sunmitbtn).rightEqualToView(sunmitbtn).bottomEqualToView(sunmitbtn).heightIs(1);
        
        
    }
    _remarksview = [[UIView alloc]init];
    _remarksview.backgroundColor = [UIColor whiteColor];
    [_bigview addSubview:_remarksview];
    _remarksview.sd_layout.leftEqualToView(_bigview).rightEqualToView(_bigview).topSpaceToView(_bigview,autoScaleH(100)).heightIs(autoScaleH(120) );
    
    UILabel * remarklabel = [[UILabel alloc]init];
    remarklabel.textColor = [UIColor blackColor];
    remarklabel.font = [UIFont systemFontOfSize:autoScaleW(13)];
    remarklabel.text = @"备注信息:";
    [_remarksview addSubview:remarklabel];
    remarklabel.sd_layout.leftSpaceToView(_remarksview,autoScaleW(15)).topSpaceToView(_remarksview,autoScaleH(5)).widthIs(autoScaleW(60)).heightIs(autoScaleH(15));
    
    _feedbackview = [[UITextView alloc]init];
    _feedbackview.font = [UIFont systemFontOfSize:autoScaleW(13)];
    _feedbackview.delegate = self;
    _feedbackview.layer.borderWidth = 1;
    _feedbackview.layer.borderColor = [UIColor lightGrayColor].CGColor;
    [_remarksview addSubview:_feedbackview];
    _feedbackview.sd_layout.leftSpaceToView(_remarksview,autoScaleW(15)).rightSpaceToView(_remarksview,autoScaleW(15)).topSpaceToView(remarklabel,autoScaleH(10)).heightIs(autoScaleH(70));
    
    _pllabel = [[UILabel alloc]init];
    _pllabel.enabled = NO;
    _pllabel.text = @"点此填写备注信息";
    _pllabel.font =[UIFont systemFontOfSize:autoScaleW(13)];
    _pllabel.backgroundColor = [UIColor clearColor];
    CGSize size = [_pllabel.text sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:_pllabel.font,NSFontAttributeName, nil]];
    CGFloat wind = size.width;
    [_feedbackview addSubview:_pllabel];
    _pllabel.sd_layout.centerXEqualToView(_feedbackview).centerYEqualToView(_feedbackview).widthIs(wind).heightIs(autoScaleH(15));
    
    UIButton * sunmitbtn = [UIButton buttonWithType:UIButtonTypeCustom];
    sunmitbtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [sunmitbtn setTitle:@"提交订单" forState:UIControlStateNormal];
    sunmitbtn.titleLabel.font = [UIFont systemFontOfSize:autoScaleW(15)];
    [sunmitbtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    sunmitbtn.backgroundColor = UIColorFromRGB(0xfd7577);
    [sunmitbtn addTarget:self action:@selector(Reserve) forControlEvents:UIControlEventTouchUpInside];
    sunmitbtn.layer.masksToBounds = YES;
    sunmitbtn.layer.cornerRadius = 3;
    [_bigview addSubview:sunmitbtn];
    if (_dictary.count==0) {
        
        sunmitbtn.sd_layout.leftSpaceToView(_bigview,autoScaleW(10)).rightSpaceToView(_bigview,autoScaleW(10)).topSpaceToView(_remarksview,_bigview.height_sd - autoScaleH(220)-autoScaleH(110)).heightIs(autoScaleH(40));
    }
    else{
        
        sunmitbtn.sd_layout.leftSpaceToView(_bigview,autoScaleW(10)).rightSpaceToView(_bigview,autoScaleW(10)).topSpaceToView(_remarksview,autoScaleH(70)+_dictary.count*autoScaleH(20)+ autoScaleH(45)+autoScaleH(90)).heightIs(autoScaleH(40));
    }

    
    //菜品信息
    if (_dictary.count!=0) {
        
        UIView * dishView = [[UIView alloc]init];
        dishView.backgroundColor = [UIColor whiteColor];
        [_bigview addSubview:dishView];
        dishView.sd_layout.leftEqualToView(_bigview).rightEqualToView(_bigview).topSpaceToView(_remarksview,autoScaleH(10)).heightIs(autoScaleH(70)+_dictary.count*autoScaleH(20));
        
        
        UILabel * lianxilabel = [[UILabel alloc]init];
        lianxilabel.text = @"菜品信息:";
        lianxilabel.textColor = [UIColor blackColor];
        lianxilabel.font  = [UIFont systemFontOfSize:autoScaleW(13)];
        [dishView addSubview:lianxilabel];
        lianxilabel.sd_layout.leftSpaceToView(dishView,autoScaleW(15)).topSpaceToView(dishView,autoScaleH(10)).widthIs(autoScaleW(128)).heightIs(autoScaleH(15));
        
        UILabel * linelabel = [[UILabel alloc]init];
        linelabel.backgroundColor = RGB(228, 228, 228);
        [dishView addSubview:linelabel];
        linelabel.sd_layout.leftSpaceToView(dishView,autoScaleW(15)).rightSpaceToView(dishView,autoScaleW(15)).topSpaceToView(lianxilabel,autoScaleH(5)).heightIs(autoScaleH(1));
        for (int i=0; i<_dictary.count; i++)
        {
            
            UILabel * caidanlabel = [[UILabel alloc]init];
            [dishView addSubview:caidanlabel];
            caidanlabel.sd_layout.leftSpaceToView(dishView,autoScaleW(15)).topSpaceToView(linelabel,autoScaleH(5)+i*autoScaleH(20)).widthIs(GetWidth-autoScaleW(30)).heightIs(15);
            
            UILabel * namelabel = [[UILabel alloc]init];
            namelabel.text = _dictary[i][@"name"];
            namelabel.font = [UIFont systemFontOfSize:autoScaleW(13)];
            namelabel.textColor = [UIColor lightGrayColor];
            [caidanlabel addSubview:namelabel];
            namelabel.sd_layout.leftSpaceToView(caidanlabel,autoScaleW(28)).topSpaceToView(caidanlabel,0).widthIs(GetWidth/2-autoScaleW(30)).heightIs(autoScaleH(15));
            
            UILabel * sllabel = [[UILabel alloc]init];
            sllabel.text = [NSString stringWithFormat:@"%@份",_dictary[i][@"number"]];
            sllabel.font = [UIFont systemFontOfSize:autoScaleW(13)];
            [caidanlabel addSubview:sllabel];
            sllabel.sd_layout.leftSpaceToView(namelabel,autoScaleW(20)).topSpaceToView(caidanlabel,0).widthIs(autoScaleW(30)).heightIs(autoScaleH(15));
            
            UILabel * moneylabel = [[UILabel alloc]init];
            moneylabel.text = [NSString stringWithFormat:@"￥%@",_dictary[i][@"fee"]];
            moneylabel.font = [UIFont systemFontOfSize:autoScaleW(13)];
            [caidanlabel addSubview:moneylabel];
            moneylabel.sd_layout.rightSpaceToView(caidanlabel,autoScaleW(28)).topSpaceToView(caidanlabel,0).widthIs(autoScaleW(50)).heightIs(autoScaleH(15));
            
        }
        
        UILabel * slinelabel = [[UILabel alloc]init];
        slinelabel.backgroundColor = RGB(228, 228, 228);
        [dishView addSubview:slinelabel];
        slinelabel.sd_layout.leftSpaceToView(dishView,autoScaleW(15)).rightSpaceToView(dishView,autoScaleW(15)).topSpaceToView(linelabel,autoScaleH(20)*_dictary.count+autoScaleH(10)).heightIs(autoScaleH(1));
        
        UILabel * zonglabel = [[UILabel alloc]init];
        zonglabel.text = [NSString stringWithFormat:@"共计%@",_feestr];
        zonglabel.textColor = [UIColor blackColor];
        zonglabel.textAlignment = NSTextAlignmentRight;
        [dishView addSubview:zonglabel];
        zonglabel.sd_layout.rightSpaceToView(dishView,autoScaleW(15)).topSpaceToView(slinelabel,0).widthIs(autoScaleW(200)).heightIs(autoScaleH(20));
        
        
        
        
       //优惠券和活动 二选一
        __weak NSString * coupon = nil;
        __weak NSString * activity = nil;
        if (![_objDict[@"coupon"] isKindOfClass:[NSArray class]]) {
            
            coupon = @"您没有可使用的优惠券";
            
            
        }else{
            
            coupon = @"可选择一张优惠券";
            _couint = 1;
        }
        
        
        if ([_objDict[@"storeActivity"]isKindOfClass:[NSDictionary class]]) {
            
            activity = _objDict[@"storeActivity"][@"cardTitle"];
            _storeAc = 1;
        }else{
            
            activity = @"优惠活动不可用";
        }
        
        NSArray * btnTitleary = @[coupon,activity];
        _btnAry = [NSMutableArray array];
        _imageAry = [NSMutableArray array];
        for (int i =0; i<2; i++) {
            
            UIButton * preferentialBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            [preferentialBtn setBackgroundColor: [UIColor whiteColor]];
            [preferentialBtn addTarget:self action:@selector(Chooseyh:) forControlEvents:UIControlEventTouchUpInside];
            [preferentialBtn setTitle:btnTitleary[i] forState:UIControlStateNormal];
            [preferentialBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            preferentialBtn.titleLabel.font = [UIFont systemFontOfSize:autoScaleW(15)];
            
            preferentialBtn.tag = 5000+i;
            
            //        if ([aclistdict[@"firstSelect"] integerValue]<2) {
            //
            //            if (i==[aclistdict[@"firstSelect"] integerValue]) {
            //                preferentialBtn.selected = YES;
            //                _tbtn = preferentialBtn;
            //            }
            //
            //        }
            //        else{
            //            preferentialBtn.userInteractionEnabled = NO;
            //        }
            //
            [_bigview addSubview:preferentialBtn];
            preferentialBtn.sd_layout.leftSpaceToView(_bigview,0).rightEqualToView(_bigview).topSpaceToView(dishView,autoScaleH(15)+i*autoScaleH(40)).heightIs(autoScaleH(40));
            
            
            UILabel * linelabel = [[UILabel alloc]init];
            linelabel.backgroundColor = UIColorFromRGB(0xeeeeee);
            [preferentialBtn addSubview:linelabel];
            linelabel.sd_layout.leftEqualToView(preferentialBtn).rightEqualToView(preferentialBtn).bottomEqualToView(preferentialBtn).heightIs(1);
            
            if (i==0) {
                UIButton * rightimage = [[UIButton alloc]init];
                
                //                rightimage.image = [UIImage imageNamed:@"形状-1-拷贝"];
                [rightimage setBackgroundImage:[UIImage imageNamed:@"形状-1-拷贝"] forState:UIControlStateNormal];
                
                [preferentialBtn addSubview:rightimage];
                rightimage.sd_layout.rightSpaceToView(preferentialBtn,kWidth(15)).topSpaceToView(preferentialBtn,kHeight(15)).widthIs(kWidth(8)).heightIs(kHeight(11));
                
            }
            
            UIImageView * chooseimage = [[UIImageView alloc]init];
            if (i==[_objDict[@"firstSelect"] integerValue]) {
                
                chooseimage.image = [UIImage imageNamed:@"单选按钮_选中"];
                [self Chooseyh:preferentialBtn];
                
            }
            else{
                chooseimage.image = [UIImage imageNamed:@"单选按钮_选中-拷贝"];
                
            }
            
            chooseimage.tag = 8000 +i;
            [preferentialBtn addSubview:chooseimage];
            chooseimage.sd_layout.leftSpaceToView(preferentialBtn,autoScaleW(15)).topSpaceToView(preferentialBtn,autoScaleH(10)).widthIs(autoScaleW(20)).heightIs(autoScaleW(20));
            [_imageAry addObject:chooseimage];
            [_btnAry addObject:preferentialBtn];
        }
    }
}
- (void)Chooseyh:(UIButton*)btn{
    
    if (btn.tag-5000==0) {
        
        if (_couint==1) {//有优惠券可用
            
            for (UIImageView * imageview in _imageAry) {
                if (imageview.tag - 8000 == btn.tag - 5000) {
                    
                    imageview.image = [UIImage imageNamed:@"单选按钮_选中"];
                    
                    CanuserTicketViewController * canuserview = [[CanuserTicketViewController alloc]init];
                    canuserview.listary = _objDict[@"acList"][@"coupon"];
                    canuserview.blck = ^(NSString * namestr,NSString * moneystr,NSString * idstr)
                    {
                        [btn setTitle:[NSString stringWithFormat:@"%@:%@",namestr,moneystr] forState:UIControlStateNormal];
                        _actId = [NSString stringWithFormat:@"%@",idstr];
                    };
                    
                    
                    [self.navigationController pushViewController:canuserview animated:YES];
                    
                }else{
                    
                    imageview.image = [UIImage imageNamed:@"单选按钮_选中-拷贝"];
                    
                    
                }
                
            }
        }
        
        
    }else if (btn.tag - 5000==1){
        
        
        if (_storeAc ==1) {
            
            for (UIImageView * imageview in _imageAry) {
                
                if (imageview.tag - 8000 == btn.tag - 5000) {
                    
                    imageview.image = [UIImage imageNamed:@"单选按钮_选中"];
                    
                }else{
                    
                    imageview.image = [UIImage imageNamed:@"单选按钮_选中-拷贝"];
                    
                }
            }
            
            _actId = [NSString stringWithFormat:@"%@",_objDict[@"storeActivity"][@"id"]];
        }
    }
}

//#pragma mark 底部视图
//-(void)Creatbottomview
//{
//
//    _ordertable = [[UITableView alloc]init];
////    ordertable.backgroundColor = [UIColor redColor];
//    _ordertable.delegate = self;
//    _ordertable.dataSource = self;
//    _ordertable.separatorStyle = 0;
//    _ordertable.tableHeaderView = _bigview;
//    [self.view addSubview:_ordertable];
//    _ordertable.sd_layout.leftEqualToView(self.view).rightEqualToView(self.view).topSpaceToView(self.view,0).heightIs(self.view.frame.size.height - autoScaleH(50));
////    _dictary.count*autoScaleH(45)+114+autoScaleH(210)
//}
//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
//{
//    
//    return _dictary.count;
//    
//}
//
//- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    SunmitTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"sun"];
//    if (!cell) {
//        
//        cell = [[SunmitTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"sun"];
//    }
//    
//    NSMutableDictionary * dict = _dictary[indexPath.row];
//    [cell.headimage sd_setImageWithURL:[NSURL URLWithString:dict[@"image"]] placeholderImage:[UIImage imageNamed:@"1"]];
//    cell.namelabel.text = dict[@"name"];
//    cell.moneylabel.text = [NSString stringWithFormat:@"￥%@", dict[@"fee"]];
//    cell.numLabel.text = dict[@"number"];
//    cell.indexstr = dict[@"index"];
//    cell.idstr = dict[@"id"];
//    cell.plusBlock = ^(NSMutableDictionary * dict,BOOL change)
//    {
//        NSString * feestr = [_feestr substringFromIndex:1];
//        if (_fee==0) {
//            _fee = [feestr floatValue];//总价格
//
//        }
//        
//        __weak NSDictionary * notdict = nil;
//        //便利数组有这道菜先删除再添加新状态
//        [_dictary enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//            
//            if ([_dictary[idx][@"name"] isEqualToString:dict[@"name"]]) {
//                
//                [_dictary removeObjectAtIndex:idx];
//            }
//            
//        }];
//        
//        if (change==YES) {
//            
//            _number+=1;
//            _fee = _fee +[dict[@"fee"] floatValue];//要存到本地的数量和价格
//            
//            [_dictary addObject:dict];
//            
//             notdict = [NSDictionary dictionaryWithObjectsAndKeys:_dictary,@"ary",@"yes",@"change",dict[@"fee"],@"fee", nil];
//            _feelabel.text = [NSString stringWithFormat:@"￥%.2f",_fee];
//
//        }
//        else
//        {
//            _number-=1;
//            _fee = _fee - [dict[@"fee"] floatValue];
//            //判断是否减到0份（删除）
//            NSString * numberstr = dict[@"number"];
//            NSInteger number = [numberstr integerValue];
//            if (number==0) {
//                
//                [_dictary removeObject:dict];
//                
//                if (_dictary.count!=0) {
//                    _feelabel.text = [NSString stringWithFormat:@"￥%.2f",_fee];
//
////                    [tableView beginUpdates];
//                    [_ordertable deleteRowsAtIndexPaths:@[indexPath]withRowAnimation:UITableViewRowAnimationAutomatic];
//                    
//                    [_ordertable reloadData];
//
//                }
//                else{
//                    [_ordertable reloadData];
//                }
//            }
//            else
//            {
//                [_dictary addObject:dict];
//            }
//            //判断是否清空
//            if (_dictary.count!=0) {
//                notdict = [NSDictionary dictionaryWithObjectsAndKeys:_dictary,@"ary",@"no",@"change",dict[@"fee"],@"fee", nil];
//
//            }
//            else{
//                notdict = [NSDictionary dictionaryWithObjectsAndKeys:_dictary,@"ary",@"remove",@"change",@"0",@"fee", nil];
//            }
//            
//            _feelabel.text = [NSString stringWithFormat:@"￥%.2f",_fee];
//
//        }
//        NSDictionary * sunmitdict = [[NSUserDefaults standardUserDefaults]objectForKey:@"save"];
//        if (sunmitdict !=nil) {
//            
//            NSArray * keysary = sunmitdict.allKeys;
//            NSString * keystr = keysary.firstObject;
//            
//            if ([keystr isEqualToString:_storeid]) {
//                
//                NSDictionary * dict = [sunmitdict objectForKey:_storeid];
//                //重新保存
//                NSMutableDictionary * mutdict = [NSMutableDictionary dictionaryWithDictionary:dict];
//                [mutdict setObject:_dictary forKey:@"dictary"];
//                if (_dictary.count!=0) {
//                    [mutdict setObject:[NSString stringWithFormat:@"￥%.2f",_fee] forKey:@"sum"];
//                    [mutdict setObject:[NSString stringWithFormat:@"%ld",_number] forKey:@"num"];
//                }
//                else{
//                    [mutdict removeObjectForKey:@"sum"];
//                    [mutdict removeObjectForKey:@"num"];
//                }
//                NSMutableDictionary * zongdict = [NSMutableDictionary dictionary];
//                [zongdict setObject:mutdict forKey:_storeid];
//                
//                [[NSUserDefaults standardUserDefaults] setObject:zongdict forKey:@"save"];
//                [[NSUserDefaults standardUserDefaults] synchronize];
//                
//            }
//            
//        }
//        _feelabel.text = [NSString stringWithFormat:@"￥%.2f",_fee];
//        //发送通知改变商家详情页面预定信息
//        [[NSNotificationCenter defaultCenter]postNotificationName:@"changedine" object:self userInfo:notdict];
//
//    };
//    
//    return cell;
//}
//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    if (_dictary.count == 0) {
//        return 0.01;
//    }
//    return autoScaleH(45);
//}
//- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
//{
//    if (_dictary.count!=0) {
//        
//        return 20;
//
//    }
//    return 0.01;
//}
//- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
//{
//    UIView * headersecview = [[UIView alloc]init];
//    headersecview.backgroundColor = [UIColor whiteColor];
//    if (_dictary.count!=0) {
//        
//        UILabel * firstlabel = [[UILabel alloc]init];
//        firstlabel.text = @"已点菜单";
//        firstlabel.textColor = [UIColor lightGrayColor];
//        firstlabel.font = [UIFont systemFontOfSize:autoScaleW(13)];
//        [headersecview addSubview:firstlabel];
//        firstlabel.sd_layout.leftSpaceToView(headersecview,autoScaleW(15)).topSpaceToView(headersecview,autoScaleH(2.5)).widthIs(autoScaleW(60)).heightIs(autoScaleH(15));
//        UILabel * firstlinelabel = [[UILabel alloc]init];
//        firstlinelabel.backgroundColor = UIColorFromRGB(0xeeeeee);
//        [headersecview addSubview:firstlinelabel];
//        firstlinelabel.sd_layout.leftEqualToView(headersecview).rightEqualToView(headersecview).bottomEqualToView(headersecview).heightIs(1);
//     }
//    return headersecview;
//}
//- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
//{
//    if (_dictary.count!=0) {
//        
//        return 30;
//        
//    }
//    return 0.01;
//}
//- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
//{
//    UIView * footview = [[UIView alloc]init];
//    if (_dictary.count!=0) {
//        
//        UILabel * firstlinelabel = [[UILabel alloc]init];
//        firstlinelabel.backgroundColor = UIColorFromRGB(0xeeeeee);
//        [footview addSubview:firstlinelabel];
//        firstlinelabel.sd_layout.leftEqualToView(footview).rightEqualToView(footview).topEqualToView(footview).heightIs(1);
//        
//        UIButton * leftbtn = [UIButton buttonWithType:UIButtonTypeCustom];
//        [leftbtn addTarget:self action:@selector(RemoveDine) forControlEvents:UIControlEventTouchUpInside];
//        [footview addSubview:leftbtn];
//        leftbtn.sd_layout.leftSpaceToView(footview,autoScaleW(15)).topSpaceToView(footview,autoScaleH(7)).widthIs(autoScaleW(50)).heightIs(autoScaleH(15));
//        
//        UILabel * qklabel = [[UILabel alloc]init];
//        qklabel.text = @"清空";
//        qklabel.textColor = [UIColor blackColor];
//        qklabel.font =  [UIFont systemFontOfSize:autoScaleW(13)];
//        [leftbtn addSubview:qklabel];
//        qklabel.sd_layout.leftEqualToView(leftbtn).topEqualToView(leftbtn).widthIs(30).heightIs(15);
//        
//        UIImageView * qkimage = [[UIImageView alloc]init];
//        qkimage.image = [UIImage imageNamed:@"垃圾桶"];
//        [leftbtn addSubview:qkimage];
//        qkimage.sd_layout.leftSpaceToView(qklabel,autoScaleW(3)).topEqualToView(qklabel).widthIs(15).heightIs(15);
//        
//        _feelabel = [[UILabel alloc]init];
//        if (_fee==0) {
//            _feelabel.text = _feestr;
//            
//        }else{
//            _feelabel.text = [NSString stringWithFormat:@"￥%.2f",_fee];
//            
//        }
//        _feelabel.textColor = UIColorFromRGB(0xfd7577);
//        _feelabel.font = [UIFont systemFontOfSize:autoScaleW(15)];
//        _feelabel.textAlignment = NSTextAlignmentRight;
//        [footview addSubview:_feelabel];
//        _feelabel.sd_layout.rightSpaceToView(footview,autoScaleW(15)).topSpaceToView(footview,7).widthIs(150).heightIs(autoScaleH(15));
//
//    }
//       return footview;
//}
#pragma mark 重新选择时间或人数
- (void)AgainChoosetimeandnum:(UIButton*)btn
{
    if (btn.tag==1000) {
        
        if (_backgroundView==nil) {
            [self creattimechoose];

        }
    }
    else
    {
        if (_peopleBackView==nil) {
             [self Choosepeople];
        }
       
    }
    
}
- (void)RemoveDine
{
    [_dictary removeAllObjects];
    [_ordertable reloadData];
    
    NSDictionary * sunmitdict = [[NSUserDefaults standardUserDefaults]objectForKey:@"save"];
    if (sunmitdict !=nil) {
        
        NSArray * keysary = sunmitdict.allKeys;
        NSString * keystr = keysary.firstObject;
        
        if ([keystr isEqualToString:_storeid]) {
            
            NSDictionary * dict = [sunmitdict objectForKey:_storeid];
            
            NSArray * arydict = dict[@"dictary"];
            NSMutableArray * dictAry = [NSMutableArray arrayWithArray:arydict];
            [dictAry removeAllObjects];//删除所有菜品

            
            
            
            
            //重新保存
            NSMutableDictionary * mutdict = [NSMutableDictionary dictionaryWithDictionary:dict];
            [mutdict removeObjectForKey:@"num"];
            [mutdict removeObjectForKey:@"sum"];
            [mutdict setObject:dictAry forKey:@"dictary"];
            NSMutableDictionary * zongdict = [NSMutableDictionary dictionary];
            [zongdict setObject:mutdict forKey:_storeid];
            
            [[NSUserDefaults standardUserDefaults] setObject:zongdict forKey:@"save"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            [[NSNotificationCenter defaultCenter]postNotificationName:@"remove" object:nil];
            [self getDine];
        }
        
    }

}

#pragma mark 提交订单先判断是否绑定手机号
- (void)Reserve
{
    NSString * phoneurl = [NSString stringWithFormat:@"%@/api/user/checkUserIsBindPhone?token=%@&userId=%@",commonUrl,Token,Userid];
    NSArray * phoneurlary = [phoneurl componentsSeparatedByString:@"?"];
    
         [MBProgressHUD showMessage:@"请稍等"];
       [[QYXNetTool shareManager]postNetWithUrl:phoneurlary.firstObject urlBody:phoneurlary.lastObject bodyStyle:QYXBodyString header:nil response:QYXJSON success:^(id result) {
          
//          [MBProgressHUD hideHUD];
          NSString * msgTypestr = [NSString stringWithFormat:@"%@",result[@"msgType"]];
          if ([msgTypestr isEqualToString:@"0"]) {
              
              NSString * phonestr = [NSString stringWithFormat:@"%@",result[@"obj"]];
              [self getXG];
              [self registerXgPushAccount];
              
          }else if ([msgTypestr isEqualToString:@"1"]){
              [MBProgressHUD hideHUD];
              [MBProgressHUD showError:@"请求失败"];
              
          }else if ([msgTypestr isEqualToString:@"2"]){
              [MBProgressHUD hideHUD];
              [MBProgressHUD showSuccess:@"请先绑定手机号"];
              RevisePhoneViewController * revisephoneview = [[RevisePhoneViewController alloc]init];
              revisephoneview.pushint = 2;
             [self.navigationController pushViewController:revisephoneview animated:YES];
              
          }else if ([msgTypestr isEqualToString:@"2000"]){
              [MBProgressHUD hideHUD];
              LoginViewController * loginview = [[LoginViewController alloc]init];
              [self.navigationController pushViewController:loginview animated:YES];
          }
          
      } failure:^(NSError *error) {
          [MBProgressHUD hideHUD];
          [MBProgressHUD showError:@"网络参数错误"];
      }];
}
- (void)getXG{
    
    NSString *deviceId = [DeviceSet readKeychainValue:@"UUID"];
    if (deviceId == nil) {
        deviceId = [DeviceSet randomUUID];
    }
    NSString *device = @"ios";
    NSString *token = [DeviceSet readKeychainValue:@"deviceToken"];
    NSString * accountstr = [NSString stringWithFormat:@"u%@",Userid];
    NSString * url = [NSString stringWithFormat:@"%@/operXingeApp?token=%@&userId=%@&device=ios&deviceId=%@&account=%@&isUser=%ld",commonUrl,token,Userid,deviceId,accountstr,0];
    NSArray * urlary = [url componentsSeparatedByString:@"?"];
//    [MBProgressHUD showMessage:@"请稍等"];
    [[QYXNetTool shareManager]postNetWithUrl:urlary.firstObject urlBody:urlary.lastObject bodyStyle:QYXBodyString header:nil response:QYXJSON success:^(id result) {
//        [MBProgressHUD hideHUD];
        NSLog(@"XGGGG%@",result);
        NSString * msgstr = [NSString stringWithFormat:@"%@",result[@"msgType"]];
        if ([msgstr isEqualToString:@"0"]) {
            [self postData];
            
        }else{
            [MBProgressHUD hideHUD];
            [MBProgressHUD showError:@"请求失败"];
        }
        
    } failure:^(NSError *error) {
        
        [MBProgressHUD hideHUD];
        [MBProgressHUD showError:@"网络参数错误"];
    }];
    
}
- (void)registerXgPushAccount{
    
    NSString *account = [NSString stringWithFormat:@"u%@",Userid];
    //    NSString * account = @"ss";
    [XGPush setAccount:account successCallback:^{
        
        NSLog(@"HOMEVC---SUCCESS--%@", account);
        
    } errorCallback:^{
        NSLog(@"HOMEVC---ERROR--%@", account);
        
    }];
}

#pragma mark 提交订单
- (void)postData
{
    [self getDine];
    // 判断 是否点菜
    __weak NSString * urlstr = nil;
    
    if (![_idstr isEqualToString:@""]) {
        
        urlstr = [NSString stringWithFormat:@"%@/api/user/submitOrder?token=%@&storeId=%@&userId=%@&mealsNo=%@&remark=%@&arrivalTime=%@&productIds=%@&productNums=%@&activitiesId=%@",commonUrl,Token,_storeid,Userid,_peoplestr,_feedbackview.text,_updatetime,_idstr,_numstr,_actId];
    }
    else
    {
        urlstr = [NSString stringWithFormat:@"%@/api/user/submitOrder?token=%@&storeId=%@&userId=%@&mealsNo=%@&remark=%@&arrivalTime=%@",commonUrl,Token,_storeid,Userid,_peoplestr,_feedbackview.text,_updatetime];
    }
    
    NSArray * urlary = [urlstr componentsSeparatedByString:@"?"];
//            [MBProgressHUD showMessage:@"请稍等"];
            [[QYXNetTool shareManager]postNetWithUrl:urlary.firstObject urlBody:urlary.lastObject bodyStyle:QYXBodyString header:nil response:QYXJSON success:^(id result) {
    
                NSLog(@">>>><<<<%@",result);
                [MBProgressHUD hideHUD];
    
                NSString * typestr = [result objectForKey:@"msgType"];
    
                if ([typestr isEqualToString:@"2"]||[typestr isEqualToString:@"0"])
                {
                    if (![[result objectForKey:@"obj"] isNull]) {
                        if ([typestr isEqualToString:@"0"]) {// 点菜
                            NSDictionary * objdict = [result objectForKey:@"obj"];
                             PayViewController * ordertailview = [[PayViewController alloc]init];
                            ordertailview.orderid = objdict[@"orderId"];
                            ordertailview.pushint = 0;
                            [self.navigationController pushViewController:ordertailview animated:YES];
                        }
                        else if ([typestr isEqualToString:@"2"]){// 未点菜
                         
                            [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"save"];
                            [[NSUserDefaults standardUserDefaults]synchronize];

                        NSString * objstr = [result objectForKey:@"obj"];
                        OrderdetailViewController * ordertailview = [[OrderdetailViewController alloc]init];
                        ordertailview.orderId = objstr;
                        [self.navigationController pushViewController:ordertailview animated:YES];
                        }
                    }
                }
                else if ([typestr isEqualToString:@"1002"])
                {
                    [MBProgressHUD showSuccess:@"请先绑定手机号"];
                    RevisePhoneViewController * revisephoneview = [[RevisePhoneViewController alloc]init];
                    revisephoneview.pushint = 2;
                    [self.navigationController pushViewController:revisephoneview animated:YES];
    
                }
                else if ([typestr isEqualToString:@"3"])
                {
                    LoginViewController * loginview = [[LoginViewController alloc]init];
                    [self.navigationController pushViewController:loginview animated:YES];
                }
                else if ([typestr isEqualToString:@"1"]){
    
                    [MBProgressHUD showError:@"请求失败"];
                }
            } failure:^(NSError *error) {
                [MBProgressHUD hideHUD];
            }];
}
#pragma mark 判断提示词的消失
-(void)textViewDidChange:(UITextView *)textView
{
    if (textView.text.length ==0) {
        
        _pllabel.text = @"点此填写备注信息";
    }
    else
    {
        _pllabel.text = @"";
    }
}
//时间选择器可以封装
- (void)creattimechoose
{
    self.backgroundView = [[UIView alloc]initWithFrame:CGRectMake(0, self.view.frame.size.height, GetWidth, self.view.frame.size.height)];
    self.backgroundView.backgroundColor = RGBA(0, 0, 0, 0.3);
    
    self.pickview = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height-autoScaleH(260), [UIScreen mainScreen].bounds.size.width, autoScaleH(260))];
    self.pickview.backgroundColor = [UIColor whiteColor];
    
    WMCustomDatePicker *picker = [[WMCustomDatePicker alloc]initWithframe:CGRectMake(0, 40, [UIScreen mainScreen].bounds.size.width, 214) Delegate:self PickerStyle:WMDateStyle_DayHourMinute Day:[_bookady integerValue]+1];
    picker.minLimitDate = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
//    self.begintimestr = [dateFormatter stringFromDate:[NSDate date]];
    //    self.timestr = [dateFormatter stringFromDate:picker.date];
    
    //    NSDateFormatter * uptimefor = [[NSDateFormatter alloc]init];
    //    [uptimefor setDateFormat:@"MM-dd HH:mm"];
    //    self.uptime = [uptimefor stringFromDate:picker.date];
    
    [self.pickview addSubview:picker];
    self.pickview.userInteractionEnabled = YES;
    
    
    
    [self.navigationController.view addSubview:_backgroundView];
    [_backgroundView addSubview:self.pickview];
    
    UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    [cancelBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    cancelBtn.frame = CGRectMake(0, 0, 60, 25);
    cancelBtn.backgroundColor = [UIColor clearColor];
    cancelBtn.tag = 105;
    [cancelBtn addTarget:self action:@selector(timePickerBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.pickview addSubview:cancelBtn];
    
    UILabel * peoplelabel = [[UILabel alloc]init];
    peoplelabel.text = @"选择用餐时间";
    peoplelabel.font = [UIFont systemFontOfSize:autoScaleW(15)];
    peoplelabel.textColor = [UIColor blackColor];
    peoplelabel.textAlignment = NSTextAlignmentCenter;
    [self.pickview addSubview:peoplelabel];
    peoplelabel.sd_layout.centerXEqualToView (self.pickview).topEqualToView(cancelBtn).widthIs(autoScaleW(100)).heightIs(autoScaleH(20));
    
    UIButton *doneBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [doneBtn setTitle:@"完成" forState:UIControlStateNormal];
    [doneBtn setTitleColor:[UIColor colorWithRed:19/255.0f green:137/255.0f blue:208/255.0f alpha:1] forState:UIControlStateNormal];
    doneBtn.frame = CGRectMake([UIScreen mainScreen].bounds.size.width-60, 0, 60, 25);
    doneBtn.backgroundColor = [UIColor clearColor];
    doneBtn.tag = 106;
    [doneBtn addTarget:self action:@selector(timePickerBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.pickview addSubview:doneBtn];
    
    [UIView animateWithDuration:0.5 animations:^{
        
        self.backgroundView.frame = CGRectMake(0, 0, GetWidth, GetHeight);
    }];
    
    
}
#pragma mark 时间选择代理方法
- (void)finishDidSelectDatePicker:(WMCustomDatePicker *)datePicker date:(NSDate *)date
{
    if ([date compare:[NSDate date]] == NSOrderedDescending) {
      _updatetime = [self dateFromString:date withFormat:@"yyyy-MM-dd HH:mm"];
        self.timestr = [self dateFromString:date withFormat:@"MM-dd HH:mm"];//预定时间
    }
    
}

//根据date返回string
- (NSString *)dateFromString:(NSDate *)date withFormat:(NSString *)format {
    NSDateFormatter *inputFormatter = [[NSDateFormatter alloc] init];
    [inputFormatter setDateFormat:format];
    NSString *dateStr = [inputFormatter stringFromDate:date];
    return dateStr;
}
//选择时间
- (void)timePickerBtnClicked:(UIButton *)btn{
    
    
    
    if (btn.tag==106) {
        
        
        
        if (_timestr!=nil) {
            
            _substituteTime.text = _timestr;;
            _pickview.hidden = YES;
            NSDictionary * sunmitdict = [[NSUserDefaults standardUserDefaults]objectForKey:@"save"];
            if (sunmitdict !=nil) {
                
                NSArray * keysary = sunmitdict.allKeys;
                NSString * keystr = keysary.firstObject;
                
                if ([keystr isEqualToString:_storeid]) {
                    
                    NSDictionary * dict = [sunmitdict objectForKey:_storeid];
                    
                    //重新保存
                    NSMutableDictionary * mutdict = [NSMutableDictionary dictionaryWithDictionary:dict];
                    [mutdict setObject:_timestr forKey:@"time"];

                    NSMutableDictionary * zongdict = [NSMutableDictionary dictionary];
                    [zongdict setObject:mutdict forKey:_storeid];
                    
                    [[NSUserDefaults standardUserDefaults] setObject:zongdict forKey:@"save"];
                    [[NSUserDefaults standardUserDefaults] synchronize];
                }
            }
            [_backgroundView removeFromSuperview];
            _backgroundView = nil;
        }
        else
        {
            [MBProgressHUD showError:@"请选择时间"];
        }
        
    }
    if (btn.tag ==105) {
        
        [_backgroundView removeFromSuperview];
        _backgroundView = nil;
        _timestr = nil;

    }
}

//选择人数未封装
- (void)Choosepeople
{
    self.peopleBackView = [[UIView alloc]initWithFrame:CGRectMake(0, self.view.frame.size.height, GetWidth, self.view.frame.size.height)];
    self.peopleBackView.backgroundColor = RGBA(0, 0, 0, 0.3);
    [self.navigationController.view addSubview:_peopleBackView];
    
    _shezhivieww = [[UIView alloc]init];
    _shezhivieww.backgroundColor = [UIColor whiteColor];
    [_peopleBackView addSubview:_shezhivieww];
    _shezhivieww.sd_layout.leftSpaceToView(_peopleBackView,0).rightSpaceToView(_peopleBackView,0).bottomSpaceToView(_peopleBackView,0).heightIs(autoScaleH(260));
    
    _shezhivieww.userInteractionEnabled = YES;
    
    
    
    UIButton * quxiaobtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [quxiaobtn setTitleColor: UIColorFromRGB(0x5c5c5c)forState:UIControlStateNormal];
    quxiaobtn.titleLabel.font = [UIFont systemFontOfSize:autoScaleW(15)];
    [quxiaobtn setTitle:@"取消" forState:UIControlStateNormal];
    [quxiaobtn addTarget:self action:@selector(Cancle) forControlEvents:UIControlEventTouchUpInside];
    [_shezhivieww addSubview:quxiaobtn];
    quxiaobtn.sd_layout.leftSpaceToView(_shezhivieww,autoScaleW(10)).topSpaceToView(_shezhivieww,autoScaleH(10)).widthIs(autoScaleW(40)).heightIs(autoScaleH(30));
    
    UILabel * peoplelabel = [[UILabel alloc]init];
    peoplelabel.text = @"选择用餐人数";
    peoplelabel.font = [UIFont systemFontOfSize:autoScaleW(15)];
    peoplelabel.textColor = [UIColor blackColor];
    [_shezhivieww addSubview:peoplelabel];
    peoplelabel.sd_layout.centerXEqualToView (_shezhivieww).topEqualToView(quxiaobtn).widthIs(autoScaleW(100)).heightIs(autoScaleH(20));
    
    
    UIButton * quedingbtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [quedingbtn setTitleColor:UIColorFromRGB(0xfd7577) forState:UIControlStateNormal];
    quedingbtn.titleLabel.font = [UIFont systemFontOfSize:autoScaleW(15)];
    [quedingbtn setTitle:@"确定" forState:UIControlStateNormal];
    [quedingbtn addTarget:self action:@selector(timeClick) forControlEvents:UIControlEventTouchUpInside];
    [_shezhivieww addSubview:quedingbtn];
    quedingbtn.sd_layout.rightSpaceToView(_shezhivieww,autoScaleW(10)).topSpaceToView(_shezhivieww,autoScaleH(10)).widthIs(autoScaleW(40)).heightIs(autoScaleH(30));
    
    UILabel * linelabel = [[UILabel alloc]init];
    linelabel.backgroundColor = RGB(195, 195, 195);
    [_shezhivieww addSubview:linelabel];
    linelabel.sd_layout.leftSpaceToView(_shezhivieww,0).rightSpaceToView(_shezhivieww,0).heightIs(autoScaleH(0.5)).topSpaceToView(_shezhivieww,autoScaleH(40));
    
    for (int i=0; i<10; i++) {
        
        UIButton * zhuangtasibtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [zhuangtasibtn setTitle:[NSString stringWithFormat:@"%d人",i+1] forState:UIControlStateNormal];
        zhuangtasibtn.titleLabel.font = [UIFont systemFontOfSize:autoScaleW(15)];
        [zhuangtasibtn setTitleColor:UIColorFromRGB(0xfd7577) forState:UIControlStateSelected];
        [zhuangtasibtn setTitleColor:RGB(196, 196, 197) forState:UIControlStateNormal];
        zhuangtasibtn.layer.masksToBounds = YES;
        zhuangtasibtn.layer.cornerRadius = autoScaleW(3);
        zhuangtasibtn.layer.borderWidth = 1;
        zhuangtasibtn.layer.borderColor = RGB(196, 196, 197).CGColor;
        if (i==0) {
            zhuangtasibtn.selected = YES;
            zhuangtasibtn.layer.borderColor = UIColorFromRGB(0xfd7577).CGColor;
            _daybtn = zhuangtasibtn;
        }
        
        [zhuangtasibtn addTarget:self action:@selector(Ydday:) forControlEvents:UIControlEventTouchUpInside];
        [_shezhivieww addSubview:zhuangtasibtn];
        zhuangtasibtn.sd_layout.leftSpaceToView( _shezhivieww,autoScaleW(10)+i%4*((GetWidth-autoScaleW(65))/4 +autoScaleW(15))).topSpaceToView(linelabel,autoScaleH(10)+i/4*autoScaleW(50)).widthIs((GetWidth-autoScaleW(65))/4).heightIs(autoScaleH(30));
    }
    [UIView animateWithDuration:0.5 animations:^{
        
        self.peopleBackView.frame = CGRectMake(0, 0, GetWidth, GetHeight);
    }];
    
}
#pragma mark 预定人数按钮
-(void)Ydday:(UIButton*)btn
{
    _daybtn.selected= NO;
    _daybtn.layer.borderColor = RGB(196, 196, 197).CGColor;
    btn.selected=YES;
    
    btn.layer.borderColor = UIColorFromRGB(0xfd7577).CGColor;
    
    _daybtn = btn;
    
    
    
}

- (void)Cancle
{
//    _shezhivieww.hidden = YES;
    [_peopleBackView removeFromSuperview];
    _peopleBackView = nil;
    
}
-(void)timeClick
{
    _peoplestr = _daybtn.titleLabel.text;//预定人数
    _substitutepeople.text = _peoplestr;
    [_peopleBackView removeFromSuperview];
    _peopleBackView = nil;
    //修改本地保存的数据
    NSDictionary * sunmitdict = [[NSUserDefaults standardUserDefaults]objectForKey:@"save"];
    if (sunmitdict !=nil) {
        
        NSArray * keysary = sunmitdict.allKeys;
        NSString * keystr = keysary.firstObject;
        
        if ([keystr isEqualToString:_storeid]) {
            
            NSDictionary * dict = [sunmitdict objectForKey:_storeid];
            
            //重新保存
            NSMutableDictionary * mutdict = [NSMutableDictionary dictionaryWithDictionary:dict];
            [mutdict setObject:_peoplestr forKey:@"people"];
            
            NSMutableDictionary * zongdict = [NSMutableDictionary dictionary];
            [zongdict setObject:mutdict forKey:_storeid];
            
            [[NSUserDefaults standardUserDefaults] setObject:zongdict forKey:@"save"];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }
    }

    
    
}
#pragma mark 取消键盘
-(void)Remove
{
    [self.view endEditing:YES];
}

- (void)Back
{
    [self.navigationController popViewControllerAnimated:YES];
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
