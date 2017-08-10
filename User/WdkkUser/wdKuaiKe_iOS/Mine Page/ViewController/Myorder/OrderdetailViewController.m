//
//  OrderdetailViewController.m
//  wdKuaiKe_iOS
//
//  Created by 张森森 on 16/12/28.
//  Copyright © 2016年 weiDianKuaiKe. All rights reserved.
//

#import "OrderdetailViewController.h"
#import "UIBarButtonItem+SSExtension.h"
#import "MBProgressHUD+SS.h"
#import "QYXNetTool.h"
#import "PayViewController.h"
#import "DineserveViewController.h"
#import "NSObject+JudgeNull.h"
#import "AMapRouteSearchRequestAPI.h"
#import "NewMerchantVC.h"
#import "QRViewController.h"
#import "MyorderViewController.h"
#import "JudgeViewController.h"
#import "ZTAddOrSubAlertView.h"
@interface OrderdetailViewController ()
@property (nonatomic,strong)UIScrollView * orderscroll;
@property (nonatomic,strong)UIButton * zhifubtn;
@property (nonatomic,assign)NSInteger typestr;
@property (nonatomic,strong)UIImageView * storeimage;
@property (nonatomic,strong)UILabel * titlelabel;
@property (nonatomic,retain)dispatch_source_t timer;
@property (nonatomic,strong)NSDictionary * orderdetailDict;//订单详情字典
@property (nonatomic,copy)NSString * arraveTime;//到达时间
@property (nonatomic,strong)NSArray * caiAry;
@property (nonatomic,copy)NSString * remark;//备注
@property (nonatomic,strong)UIButton * paybtn;//根据订单状态判断底部第一个按钮是否xianshi
@property (nonatomic,strong)UILabel * endtimelabel;//定时器label
@property (nonatomic,strong)UIView * bootomview;//菜品
@property (nonatomic,strong)UIView * returnView;//退菜
@property (nonatomic,strong)NSArray * returnAry;
@property (nonatomic,strong)NSMutableArray * returnMoney;//退菜价格
@end
@implementation OrderdetailViewController

-(void)viewWillAppear:(BOOL)animated
{
 
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = YES;
}
- (void)viewDidLoad
{
    
    [super viewDidLoad];
    self.view.backgroundColor = RGB(238, 238, 238);
    UILabel * titlabel = [[UILabel alloc]init];
    titlabel.frame = CGRectMake(0, 0, 80, 30);
    titlabel.textAlignment = NSTextAlignmentCenter;
    titlabel.font = [UIFont systemFontOfSize:15];
    titlabel.text = @"订单详情";
    titlabel.textColor = [UIColor whiteColor];
    self.navigationItem.titleView = titlabel;
    UIBarButtonItem * backbtn = [UIBarButtonItem itemWithTarget:self Action:@selector(Back) image:@"left-1" selectImage:nil];
    self.navigationItem.leftBarButtonItem = backbtn;
    _typestr = 0;
    _remark = nil;
    
    [self Getaf];
    
     [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(orderTypeChange) name:@"xgpush" object:nil];
 
}
- (void)orderTypeChange{
    if ([self isCurrentViewControllerVisible:self]==YES) {
      [self Getaf];
    }
}
- (void)Getaf
{
    NSString * uelstr = [NSString stringWithFormat:@"%@/api/user/getMyOrderInfo?token=%@&orderId=%@",commonUrl,Token,_orderId];
    NSArray * urlary = [uelstr componentsSeparatedByString:@"?"];
    [MBProgressHUD showMessage:@"请稍等"];
    [[QYXNetTool shareManager]postNetWithUrl:urlary.firstObject urlBody:urlary.lastObject bodyStyle:QYXBodyString header:nil response:QYXJSON success:^(id result)
     {
         [MBProgressHUD hideHUD];
         NSLog(@",.,.,.%@",result);
        if (![[result objectForKey:@"obj"] isNull]) {
            
            NSDictionary * obj = [result objectForKey:@"obj"];
            _orderdetailDict = [obj objectForKey:@"orderBase"];
            _caiAry = obj[@"detVoList"];
            _returnAry = obj[@"retreatList"];
            NSString * time = _orderdetailDict[@"arrivalTime"];
            NSTimeInterval arrveltime = [time doubleValue]/1000.0;
            NSDate *_timeld = [NSDate dateWithTimeIntervalSince1970:arrveltime];
            NSDateFormatter * dateformatte = [[NSDateFormatter alloc]init];
            [dateformatte setDateFormat:@"MM-dd HH:mm"];
            _arraveTime = [dateformatte stringFromDate:_timeld];
            if (_orderscroll) {
                
                [_orderscroll removeFromSuperview];
             }
            [self Creatscroll];
            [self Creatbottomview];
            
        }else{
            [MBProgressHUD showError:@"请求失败"];
        }
        
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUD];
        [MBProgressHUD showError:@"网络错误"];
        
    }];
    
}
-(void)Creatscroll
{
    __weak NSString * mealno;
    if (![_orderdetailDict[@"mealsNo"] isNull]) {
        mealno = _orderdetailDict[@"mealsNo"];
    }else{
        mealno = @"到店用餐";
    }
    
    NSMutableArray * informary = [NSMutableArray arrayWithObjects:_orderdetailDict[@"orderName"],_orderdetailDict[@"orderId"],_arraveTime,@"30分钟或以上",mealno,@"待定", nil];
    
    
    NSArray * xinxiary = @[@"用户名",@"订单编号",@"预定用餐时间",@"预留时间",@"用餐人数",@"桌号",];
    
    _orderscroll = [[UIScrollView alloc]init];
    if (![_caiAry isNull]) {
        
        if (_returnAry.count==0) {
            _orderscroll.contentSize = CGSizeMake(0, autoScaleH(150)+autoScaleH(100)+xinxiary.count*autoScaleH(25)+autoScaleH(80)+autoScaleH(70)+_caiAry.count*autoScaleH(20)+autoScaleH(190));
        }else{
            
            _orderscroll.contentSize = CGSizeMake(0, autoScaleH(150)+autoScaleH(100)+xinxiary.count*autoScaleH(25)+autoScaleH(80)+autoScaleH(70)+_caiAry.count*autoScaleH(20)+autoScaleH(210)+_returnAry.count*autoScaleH(20)+autoScaleH(70));
        }
        
    }else
    {
         _orderscroll.contentSize = CGSizeMake(0, autoScaleH(150)+autoScaleH(100)+xinxiary.count*autoScaleH(25)+autoScaleH(80)+autoScaleH(70)+autoScaleH(90));
    }
   
    
    [self.view addSubview:_orderscroll];
    _orderscroll.sd_layout.leftEqualToView(self.view).rightEqualToView(self.view).widthIs(GetWidth).heightIs(GetHeight-autoScaleH(50));
    
    UIView * headview = [[UIView alloc]init];
    headview.backgroundColor = [UIColor whiteColor];
    [_orderscroll addSubview:headview];
    headview.sd_layout.leftEqualToView(_orderscroll).rightEqualToView(_orderscroll).topSpaceToView(_orderscroll,0).heightIs(autoScaleH(150));
    
    NSString * ordertypestr = [NSString stringWithFormat:@"%@",_orderdetailDict[@"orderType"]];
    _titlelabel = [[UILabel alloc]init];
    
    if ([ordertypestr isEqualToString:@"1"]||[ordertypestr isEqualToString:@"11"]) {
        
        _titlelabel.text = @"等待商家接单";
    }else if ([ordertypestr isEqualToString:@"4"]||[ordertypestr isEqualToString:@"14"]){
        _titlelabel.text = @"预订成功";
    }else if ([ordertypestr isEqualToString:@"18"]){
        _titlelabel.text = @"正在用餐";
    }
    else if([ordertypestr isEqualToString:@"0"]){
        if ([_orderdetailDict[@"disOrderType"] integerValue]==0) {
            _titlelabel.text = @"等待支付";

        }else if ([_orderdetailDict[@"disOrderType"] integerValue]==1&&[_orderdetailDict[@"disOrderType"] floatValue]>0){//判断是预定还是服务页面退出来的，服务页面是否有加菜
            _titlelabel.text = @"等待支付";

        }else if ([_orderdetailDict[@"disOrderType"] integerValue]==1 &&[_orderdetailDict[@"disOrderType"] floatValue]==0){
            _titlelabel.text = @"正在用餐";
        }
    }else if ([ordertypestr isEqualToString:@"19"]){
        _titlelabel.text = @"用餐结束";
    }else
    {
        _titlelabel.text = @"订单取消";
    }
    _titlelabel.font = [UIFont systemFontOfSize:autoScaleW(15)];
    _titlelabel.textColor = UIColorFromRGB(0xfd7577);
    _titlelabel.textAlignment = NSTextAlignmentCenter;
    [headview addSubview:_titlelabel];
    _titlelabel.sd_layout.centerXEqualToView(headview).topSpaceToView(headview,autoScaleH(15)).heightIs(autoScaleH(20));
    [_titlelabel setSingleLineAutoResizeWithMaxWidth:200];
    
    if ([ordertypestr isEqualToString:@"1"]||[ordertypestr isEqualToString:@"0"]||[ordertypestr isEqualToString:@"11"]) {
        _endtimelabel = [[UILabel alloc]init];
        _endtimelabel.text = @"";
        _endtimelabel.textColor = [UIColor blackColor];
        _endtimelabel.font = [UIFont systemFontOfSize:autoScaleW(15)];
        [headview addSubview:_endtimelabel];
        _endtimelabel.sd_layout.leftSpaceToView(_titlelabel,autoScaleW(15)).topEqualToView(_titlelabel).heightIs(autoScaleH(15)).widthIs(autoScaleW(140));
        if ([ordertypestr isEqualToString:@"0"]) {
            
            if ([_orderdetailDict[@"disOrderType"] integerValue]==0) {
                
                [self timer];

            }
        }else{
            
            [self timer];
        }
        
    }
    
    UIImageView * promptimage = [[UIImageView alloc]init];
    if ([_orderdetailDict[@"orderType"] integerValue]==1||[_orderdetailDict[@"orderType"] integerValue]==11||[_orderdetailDict[@"orderType"] integerValue]==0) {
        if ([_orderdetailDict[@"orderType"] integerValue]==0) {
            if ([_orderdetailDict[@"disOrderType"] integerValue]==0 ) {
                 promptimage.image = [UIImage imageNamed:@"提交订单"];//预定
                
            }else if ([_orderdetailDict[@"disOrderType"] integerValue]==1&&[_orderdetailDict[@"disOrderType"] floatValue]>0){//判断是预定还是服务页面退出来的，服务页面是否有加菜
                 promptimage.image = [UIImage imageNamed:@"提交订单"];
                
            }else if ([_orderdetailDict[@"disOrderType"] integerValue]==1&&[_orderdetailDict[@"disOrderType"] floatValue]==0){//服务，为加菜
                 promptimage.image = [UIImage imageNamed:@"预订成功"];
            }

        }else{
             promptimage.image = [UIImage imageNamed:@"提交订单"];
        }
       
    }else if ([_orderdetailDict[@"orderType"] integerValue]==4||[_orderdetailDict[@"orderType"] integerValue]==14||[_orderdetailDict[@"orderType"] integerValue]==18||[_orderdetailDict[@"orderType"] integerValue]==19||[_orderdetailDict[@"orderType"] integerValue]==21){
        promptimage.image = [UIImage imageNamed:@"预定成功"];
    }else{
        promptimage.image = [UIImage imageNamed:@"订单取消"];

    }
    
    [headview addSubview:promptimage];
    promptimage.sd_layout.leftEqualToView(headview).rightEqualToView(headview).topSpaceToView(_titlelabel,autoScaleH(25)).heightIs(autoScaleH(50));
    
    UIButton * addriveview = [[UIButton alloc]init];
    addriveview.backgroundColor = [UIColor whiteColor];
    [addriveview addTarget:self action:@selector(GotoStore) forControlEvents:UIControlEventTouchUpInside];
    [_orderscroll addSubview:addriveview];
    addriveview.sd_layout.leftEqualToView(_orderscroll).rightEqualToView(_orderscroll).topSpaceToView(headview,autoScaleH(10)).heightIs(autoScaleH(100));
    
    UIView * storeview = [[UIView alloc]init];
    storeview.backgroundColor = [UIColor whiteColor];
    [addriveview addSubview:storeview];
    storeview.sd_layout.leftEqualToView(addriveview).rightEqualToView(addriveview).topEqualToView(addriveview).heightIs(autoScaleH(50));
    
    _storeimage = [[UIImageView alloc]init];
    
    [_storeimage sd_setImageWithURL:[NSURL URLWithString:_orderdetailDict[@"storeImage"]]placeholderImage:[UIImage imageNamed:@"1"]];
    [storeview addSubview:_storeimage];
    _storeimage.sd_layout.leftSpaceToView(storeview,autoScaleW(15)).topSpaceToView(storeview,autoScaleH(5)).widthIs(autoScaleW(40)).heightIs(autoScaleH(40));
    
    UILabel * namelabel = [[UILabel alloc]init];
    namelabel.text = _orderdetailDict[@"storeName"];
    namelabel.textColor = [UIColor lightGrayColor];
    namelabel.font = [UIFont systemFontOfSize:autoScaleW(13)];
    [storeview addSubview:namelabel];
    namelabel.sd_layout.leftSpaceToView(_storeimage,autoScaleW(10)).topSpaceToView(storeview,autoScaleH(25)).widthIs(GetWidth-autoScaleW(70)).heightIs(autoScaleH(15));
    
    UIImageView * rightimage = [[UIImageView alloc]init];
    rightimage.image = [UIImage imageNamed:@"arrow-1-拷贝"];
    [storeview addSubview:rightimage];
    rightimage.sd_layout.rightSpaceToView(storeview,autoScaleW(15)).topSpaceToView(storeview,autoScaleH(25)).widthIs(autoScaleW(10)).heightIs(autoScaleH(10));
    
    UILabel * bottomLabel = [[UILabel alloc]init];
    bottomLabel.backgroundColor = UIColorFromRGB(0xeeeeee);
    [storeview addSubview:bottomLabel];
    bottomLabel.sd_layout.rightEqualToView(storeview).leftEqualToView(storeview).bottomEqualToView(storeview).heightIs(1);
    
    UIButton * addressbtn = [UIButton buttonWithType:UIButtonTypeCustom];
    addressbtn.backgroundColor = [UIColor whiteColor];
    [addressbtn addTarget:self action:@selector(ClickAddressbtn) forControlEvents:UIControlEventTouchUpInside];
    [addriveview addSubview:addressbtn];
    addressbtn.sd_layout.leftEqualToView(addriveview).rightSpaceToView(addriveview,autoScaleW(45)).topSpaceToView(storeview,0).heightIs(autoScaleH(50));
    
    
    UILabel * addresslabel = [[UILabel alloc]init];
    addresslabel.text = _orderdetailDict[@"storeAddress"];
    addresslabel.textColor = [UIColor lightGrayColor];
    addresslabel.font = [UIFont systemFontOfSize:autoScaleW(13)];
    addresslabel.numberOfLines = 0 ;
    [addressbtn addSubview:addresslabel];
    addresslabel.sd_layout.leftSpaceToView(addressbtn,autoScaleW(15)).topSpaceToView(addressbtn,autoScaleH(5)).widthIs(autoScaleW(200)).heightIs(autoScaleH(40));
    
   
    UIButton * phonebtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [phonebtn setImage:[UIImage imageNamed:@"电话"] forState:UIControlStateNormal];
    [phonebtn addTarget:self action:@selector(Callphone) forControlEvents:UIControlEventTouchUpInside];
    [addriveview addSubview:phonebtn];
    phonebtn.sd_layout.rightSpaceToView(addriveview,autoScaleW(15)).topEqualToView(addressbtn).widthIs(autoScaleW(30)).heightIs(autoScaleH(50));
    
    
    for (int i =0; i<xinxiary.count; i++) {
        
        UIView * labelview = [[UIView alloc]init];
        labelview.backgroundColor = [UIColor whiteColor];
        [_orderscroll addSubview:labelview];
        labelview.sd_layout.leftEqualToView(_orderscroll).rightEqualToView(_orderscroll).topSpaceToView(addriveview,autoScaleH(10)+i*autoScaleH(25)).heightIs(autoScaleH(25));
        
        UILabel * linelabel = [[UILabel alloc]init];
        linelabel.backgroundColor = UIColorFromRGB(0xeeeeee);
        [labelview addSubview:linelabel];
        linelabel.sd_layout.leftEqualToView(labelview).rightEqualToView(labelview).bottomEqualToView(labelview).heightIs(1);
        
        UILabel * leftlabel = [[UILabel alloc]init];
        leftlabel.text = xinxiary[i];
        leftlabel.font = [UIFont systemFontOfSize:autoScaleW(13)];
        leftlabel.textColor = [UIColor lightGrayColor];
        [labelview addSubview: leftlabel];
        leftlabel.sd_layout.leftSpaceToView(labelview,autoScaleW(15)).topSpaceToView(labelview,autoScaleH(5)).heightIs(autoScaleH(15));
        [leftlabel setSingleLineAutoResizeWithMaxWidth:200];
        
        UILabel * rightlabel = [[UILabel alloc]init];
        rightlabel.text = informary[i];
        rightlabel.font = [UIFont systemFontOfSize:autoScaleW(13)];
        rightlabel.textColor = [UIColor lightGrayColor];
        [labelview addSubview: rightlabel];
        rightlabel.sd_layout.rightSpaceToView(labelview,autoScaleW(15)).topSpaceToView(labelview,autoScaleH(5)).heightIs(autoScaleH(15));
        [rightlabel setSingleLineAutoResizeWithMaxWidth:200];
        
        
    }
  //备注
    UIView * remarksview = [[UIView alloc]init];
    remarksview.backgroundColor = [UIColor whiteColor];
    [_orderscroll addSubview:remarksview];
    remarksview.sd_layout.leftEqualToView(_orderscroll).rightEqualToView(_orderscroll).topSpaceToView(addriveview,autoScaleH(30)+xinxiary.count*25).heightIs(autoScaleH(80) );
    
    UILabel * remarklabel = [[UILabel alloc]init];
    remarklabel.textColor = [UIColor lightGrayColor];
    remarklabel.font = [UIFont systemFontOfSize:autoScaleW(13)];
    remarklabel.text = @"备注信息:";
    [remarksview addSubview:remarklabel];
    remarklabel.sd_layout.leftSpaceToView(remarksview,autoScaleW(15)).topSpaceToView(remarksview,autoScaleH(5)).widthIs(autoScaleW(60)).heightIs(autoScaleH(15));
    
    UILabel * remarkdetailabel = [[UILabel alloc]init];
    remarkdetailabel.font = [UIFont systemFontOfSize:autoScaleW(11)];

    NSMutableParagraphStyle *paraStyle01 = [[NSMutableParagraphStyle alloc] init];
    paraStyle01.alignment = NSTextAlignmentLeft;  //对齐
    paraStyle01.headIndent = 0.0f;//行首缩进
    //参数：（字体大小17号字乘以2，34f即首行空出两个字符）
    CGFloat emptylen = remarkdetailabel.font.pointSize * 2;
    paraStyle01.firstLineHeadIndent = emptylen;//首行缩进
    paraStyle01.tailIndent = 0.0f;//行尾缩进
    paraStyle01.lineSpacing = 2.0f;//行间距
    if (![_remark isNull]) {
        
        NSAttributedString *attrText = [[NSAttributedString alloc] initWithString:_orderdetailDict[@"remark"] attributes:@{NSParagraphStyleAttributeName:paraStyle01}];
        
        remarkdetailabel.attributedText = attrText;
    }
    remarkdetailabel.textColor = [UIColor blackColor];
    remarkdetailabel.layer.borderWidth = 1;
    remarkdetailabel.layer.borderColor = UIColorFromRGB(0xeeeeee).CGColor;
    [remarksview addSubview:remarkdetailabel];
    remarkdetailabel.sd_layout.leftSpaceToView(remarksview,autoScaleW(10)).rightSpaceToView(remarksview,autoScaleW(10)).topSpaceToView(remarklabel,autoScaleH(5)).heightIs(autoScaleH(35));
    
    //菜品信息
    if (![_caiAry isNull]) {
        _bootomview = [[UIView alloc]init];
        _bootomview.backgroundColor = [UIColor whiteColor];
        [_orderscroll addSubview:_bootomview];
        _bootomview.sd_layout.leftEqualToView(_orderscroll).rightEqualToView(_orderscroll).topSpaceToView(remarksview,autoScaleH(10)).heightIs(autoScaleH(70)+_caiAry.count*autoScaleH(20));
        
        
        UILabel * lianxilabel = [[UILabel alloc]init];
        lianxilabel.text = @"菜品信息:";
        lianxilabel.textColor = [UIColor blackColor];
        lianxilabel.font  = [UIFont systemFontOfSize:autoScaleW(13)];
        [_bootomview addSubview:lianxilabel];
        lianxilabel.sd_layout.leftSpaceToView(_bootomview,autoScaleW(15)).topSpaceToView(_bootomview,autoScaleH(10)).widthIs(autoScaleW(128)).heightIs(autoScaleH(15));
        
        UILabel * linelabel = [[UILabel alloc]init];
        linelabel.backgroundColor = RGB(228, 228, 228);
        [_bootomview addSubview:linelabel];
        linelabel.sd_layout.leftSpaceToView(_bootomview,autoScaleW(15)).rightSpaceToView(_bootomview,autoScaleW(15)).topSpaceToView(lianxilabel,autoScaleH(5)).heightIs(autoScaleH(1));
        if (_caiAry.count!=0) {
            for (int i=0; i<_caiAry.count; i++)
            {
                
                UILabel * caidanlabel = [[UILabel alloc]init];
                [_bootomview addSubview:caidanlabel];
                caidanlabel.sd_layout.leftSpaceToView(_bootomview,autoScaleW(15)).topSpaceToView(linelabel,autoScaleH(5)+i*autoScaleH(20)).widthIs(GetWidth-autoScaleW(30)).heightIs(15);
                
                UILabel * namelabel = [[UILabel alloc]init];
                namelabel.text = _caiAry[i][@"productName"];
                namelabel.font = [UIFont systemFontOfSize:autoScaleW(13)];
                namelabel.textColor = [UIColor lightGrayColor];
                [caidanlabel addSubview:namelabel];
                namelabel.sd_layout.leftSpaceToView(caidanlabel,autoScaleW(28)).topSpaceToView(caidanlabel,0).widthIs(GetWidth/2-autoScaleW(30)).heightIs(autoScaleH(15));
                
                UILabel * sllabel = [[UILabel alloc]init];
                sllabel.text = [NSString stringWithFormat:@"%@份",_caiAry[i][@"cnt"]];
                sllabel.font = [UIFont systemFontOfSize:autoScaleW(13)];
                [caidanlabel addSubview:sllabel];
                sllabel.sd_layout.centerXEqualToView(caidanlabel).topSpaceToView(caidanlabel,0).widthIs(autoScaleW(30)).heightIs(autoScaleH(15));
                
                UILabel * moneylabel = [[UILabel alloc]init];
                moneylabel.text = [NSString stringWithFormat:@"￥%@",_caiAry[i][@"fee"]];
                moneylabel.font = [UIFont systemFontOfSize:autoScaleW(13)];
                [caidanlabel addSubview:moneylabel];
                moneylabel.sd_layout.rightSpaceToView(caidanlabel,autoScaleW(28)).topSpaceToView(caidanlabel,0).widthIs(autoScaleW(50)).heightIs(autoScaleH(15));
                
            }
            
            UILabel * slinelabel = [[UILabel alloc]init];
            slinelabel.backgroundColor = RGB(228, 228, 228);
            [_bootomview addSubview:slinelabel];
            slinelabel.sd_layout.leftSpaceToView(_bootomview,autoScaleW(15)).rightSpaceToView(_bootomview,autoScaleW(15)).topSpaceToView(linelabel,autoScaleH(20)*_caiAry.count+autoScaleH(10)).heightIs(autoScaleH(1));
            
            UILabel * zonglabel = [[UILabel alloc]init];
            zonglabel.text = [NSString stringWithFormat:@"共计￥%@",_orderdetailDict[@"totalFee"]];
            zonglabel.textColor = [UIColor blackColor];
            zonglabel.textAlignment = NSTextAlignmentRight;
            zonglabel.font  =[UIFont systemFontOfSize:autoScaleW(13)];
            [_bootomview addSubview:zonglabel];
            zonglabel.sd_layout.rightSpaceToView(_bootomview,autoScaleW(15)).topSpaceToView(slinelabel,0).widthIs(autoScaleW(200)).heightIs(autoScaleH(20));
            
        }

    }
    
    if (_returnAry.count!=0) {

        _returnMoney = [NSMutableArray array];
        _returnView = [[UIView alloc]init];
        _returnView.backgroundColor = [UIColor whiteColor];
        [_orderscroll addSubview:_returnView];
        _returnView.sd_layout.leftEqualToView(_orderscroll).rightEqualToView(_orderscroll).topSpaceToView(_bootomview,autoScaleH(10)).heightIs(autoScaleH(70)+_returnAry.count*autoScaleH(20));
        
        
        UILabel * lianxilabel = [[UILabel alloc]init];
        lianxilabel.text = @"退菜信息:";
        lianxilabel.textColor = [UIColor blackColor];
        lianxilabel.font  = [UIFont systemFontOfSize:autoScaleW(13)];
        [_returnView addSubview:lianxilabel];
        lianxilabel.sd_layout.leftSpaceToView(_returnView,autoScaleW(15)).topSpaceToView(_returnView,autoScaleH(10)).widthIs(autoScaleW(128)).heightIs(autoScaleH(15));
        
        UILabel * linelabel = [[UILabel alloc]init];
        linelabel.backgroundColor = RGB(228, 228, 228);
        [_returnView addSubview:linelabel];
        linelabel.sd_layout.leftSpaceToView(_returnView,autoScaleW(15)).rightSpaceToView(_returnView,autoScaleW(15)).topSpaceToView(lianxilabel,autoScaleH(5)).heightIs(autoScaleH(1));

        for (int i =0; i<_returnAry.count; i++) {
            
            
            UILabel * caidanlabel = [[UILabel alloc]init];
            [_returnView addSubview:caidanlabel];
            caidanlabel.sd_layout.leftSpaceToView(_returnView,autoScaleW(15)).topSpaceToView(linelabel,autoScaleH(5)+i*autoScaleH(20)).widthIs(GetWidth-autoScaleW(30)).heightIs(15);
            
            UILabel * namelabel = [[UILabel alloc]init];
            namelabel.text = _returnAry[i][@"productName"];
            namelabel.font = [UIFont systemFontOfSize:autoScaleW(13)];
            namelabel.textColor = [UIColor lightGrayColor];
            [caidanlabel addSubview:namelabel];
            namelabel.sd_layout.leftSpaceToView(caidanlabel,autoScaleW(28)).topSpaceToView(caidanlabel,0).widthIs(autoScaleW(150)).heightIs(autoScaleH(15));
            
            UILabel * sllabel = [[UILabel alloc]init];
            sllabel.text = [NSString stringWithFormat:@"%@份",_returnAry[i][@"isRetreat"]];
            sllabel.font = [UIFont systemFontOfSize:autoScaleW(13)];
            [caidanlabel addSubview:sllabel];
            sllabel.sd_layout.centerXEqualToView(caidanlabel).topSpaceToView(caidanlabel,0).widthIs(autoScaleW(30)).heightIs(autoScaleH(15));
            
            UILabel * moneylabel = [[UILabel alloc]init];
            moneylabel.text = [NSString stringWithFormat:@"￥%@",_returnAry[i][@"fee"]];
            moneylabel.font = [UIFont systemFontOfSize:autoScaleW(13)];
            [caidanlabel addSubview:moneylabel];
            moneylabel.sd_layout.rightSpaceToView(caidanlabel,autoScaleW(28)).topSpaceToView(caidanlabel,0).widthIs(autoScaleW(50)).heightIs(autoScaleH(15));
            float returnsum = [_returnAry[i][@"isRetreat"] integerValue]* [_returnAry[i][@"fee"] floatValue];
            
            NSString * sumstr = [NSString stringWithFormat:@"%f",returnsum];
            [_returnMoney addObject:sumstr];
        }
        UILabel * slinelabel = [[UILabel alloc]init];
        slinelabel.backgroundColor = RGB(228, 228, 228);
        [_returnView addSubview:slinelabel];
        slinelabel.sd_layout.leftSpaceToView(_returnView,autoScaleW(15)).rightSpaceToView(_returnView,autoScaleW(15)).topSpaceToView(linelabel,autoScaleH(20)*_returnAry.count+autoScaleH(10)).heightIs(autoScaleH(1));
        
        NSNumber * sum = [ _returnMoney valueForKeyPath:@"@sum.floatValue"];
        UILabel * zonglabel = [[UILabel alloc]init];
        zonglabel.text = [NSString stringWithFormat:@"共退￥%@",sum];
        zonglabel.textColor = [UIColor blackColor];
        zonglabel.textAlignment = NSTextAlignmentRight;
        zonglabel.font  =[UIFont systemFontOfSize:autoScaleW(13)];
        [_returnView addSubview:zonglabel];
        zonglabel.sd_layout.rightSpaceToView(_returnView,autoScaleW(15)).topSpaceToView(slinelabel,0).widthIs(autoScaleW(200)).heightIs(autoScaleH(20));
    }
   
    if (![_caiAry isNull]) {
        if (![_orderdetailDict[@"extraFee"]isNull]||![_orderdetailDict[@"activitiesId"] isNull]) {
            [self showView];
        }
    }
}
#pragma mark 是否有使用卡券，是否加菜
- (void)showView{
    
    __weak NSArray * ticketAry = nil;
    __weak NSArray * ticketMoneyary = nil;
    NSString * discountedPrice = [NSString stringWithFormat:@"￥%@",_orderdetailDict[@"discountedPrice"]];
    NSString * realTotalFee = [NSString stringWithFormat:@"%@",_orderdetailDict[@"realTotalFee"]];
    
    double realtotal = [realTotalFee doubleValue];
    
    NSString * realtotalStr = [NSString stringWithFormat:@"￥%.2f",realtotal];
    NSString * extrafee = [NSString stringWithFormat:@"￥%@",_orderdetailDict[@"extraFee"]];
    if (![_orderdetailDict[@"activitiesId"] isNull]&&![extrafee isEqualToString:@"0"]) {//使用卡券
        ticketAry = @[@"到店消费",_orderdetailDict[@"cardTitle"],@"实付"];
       
        ticketMoneyary = @[extrafee,discountedPrice,realtotalStr];
    }
     else if (![_orderdetailDict[@"extraFee"]isNull]&&[_orderdetailDict[@"activitiesId"] isNull]) {
            
         ticketAry = @[@"到店消费"];
         ticketMoneyary = @[extrafee];
            
        }else if([_orderdetailDict[@"extraFee"]isNull]&&![_orderdetailDict[@"activitiesId"] isNull]) {
            ticketAry = @[_orderdetailDict[@"cardTitle"],@"实付"];
           
            ticketMoneyary = @[discountedPrice,realtotalStr];
        }
        
    
    for (int i =0; i<ticketAry.count; i++) {
        
        UIView * ticketView = [[UIView alloc]init];
        ticketView.backgroundColor = [UIColor whiteColor];
        [_orderscroll addSubview:ticketView];
        ticketView.sd_layout.leftEqualToView(_orderscroll).rightEqualToView(_orderscroll).heightIs(autoScaleH(30));
        if (_returnAry.count==0) {
            
            ticketView.sd_layout.topSpaceToView(_bootomview,i*autoScaleH(30));
        }else{
            
            ticketView.sd_layout.topSpaceToView(_returnView,i*autoScaleH(30));
        }
        UILabel * ticketLeftlabel = [[UILabel alloc]init];
        ticketLeftlabel.text = ticketAry[i];
        ticketLeftlabel.textColor = [UIColor blackColor];
        ticketLeftlabel.font = [UIFont systemFontOfSize:autoScaleW(15)];
        [ticketView addSubview:ticketLeftlabel];
        ticketLeftlabel.sd_layout.leftSpaceToView(ticketView,autoScaleW(15)).topSpaceToView(ticketView,7).heightIs(autoScaleH(15));
        [ticketLeftlabel setSingleLineAutoResizeWithMaxWidth:200];
        
        UILabel * ticketRightlabel = [[UILabel alloc]init];
        ticketRightlabel.text = ticketMoneyary[i];
        ticketRightlabel.textColor = [UIColor blackColor];
        ticketRightlabel.textAlignment = NSTextAlignmentRight;
        ticketRightlabel.font = [UIFont systemFontOfSize:autoScaleW(13)];
        [ticketView addSubview:ticketRightlabel];
        ticketRightlabel.sd_layout.rightSpaceToView(ticketView,autoScaleW(15)).topSpaceToView(ticketView,7).heightIs(autoScaleH(15));
        [ticketRightlabel setSingleLineAutoResizeWithMaxWidth:200];
        
    }

    
}
#pragma mark 底部信息
-(void)Creatbottomview
{
    UIView * paybottomview = [[UIView alloc]init];
    paybottomview.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:paybottomview];
    paybottomview.sd_layout.leftEqualToView(self.view).rightEqualToView(self.view).bottomEqualToView(self.view).heightIs(autoScaleH(50));
    
   if (![_caiAry isNull]) {
    UILabel * moneylabel = [[UILabel alloc]init];
    NSString * realTotalFee = [NSString stringWithFormat:@"%@",_orderdetailDict[@"realTotalFee"]];
       if ([realTotalFee isEqualToString:@"0"]) {//支付完成返回时 要判断是否使用优惠券
           moneylabel.text = [NSString stringWithFormat:@"￥%@",_orderdetailDict[@"totalFee"]];

       }else{
           NSString * realTotalFee = [NSString stringWithFormat:@"%@",_orderdetailDict[@"realTotalFee"]];
           
           double realtotal = [realTotalFee doubleValue];
           
           NSString * realtotalStr = [NSString stringWithFormat:@"￥%.2f",realtotal];
           moneylabel.text = realtotalStr;

       }
    moneylabel.textColor = UIColorFromRGB(0xfd7577);
    moneylabel.font = [UIFont boldSystemFontOfSize:autoScaleW(15)];
    [paybottomview addSubview:moneylabel];
    moneylabel.sd_layout.leftSpaceToView(paybottomview,autoScaleW(5)).topSpaceToView(paybottomview,autoScaleH(15)).heightIs(autoScaleH(20));
    [moneylabel setSingleLineAutoResizeWithMaxWidth:150];
   }
    
    _zhifubtn = [UIButton buttonWithType:UIButtonTypeCustom];
    
    _zhifubtn.backgroundColor = UIColorFromRGB(0xfd7577);
    _zhifubtn.titleLabel.font = [UIFont systemFontOfSize:autoScaleW(13)];
    
    [_zhifubtn addTarget:self action:@selector(Cancel) forControlEvents:UIControlEventTouchUpInside];
    _zhifubtn.layer.cornerRadius = 3;
    [paybottomview addSubview:_zhifubtn];
    _zhifubtn.sd_layout.rightSpaceToView(paybottomview,autoScaleW(10)).topSpaceToView(paybottomview,autoScaleH(15)).widthIs(autoScaleW(80)).heightIs(autoScaleH(30));
    
    NSString * typeorder = [NSString stringWithFormat:@"%@",_orderdetailDict[@"orderType"]];
    if ([typeorder isEqualToString:@"4"]||[typeorder isEqualToString:@"14"]){
        _typestr = 1;
        [_zhifubtn setTitle:@"扫码用餐" forState:UIControlStateNormal];
    }else if ([typeorder isEqualToString:@"18"]){
        _typestr = 3;
        [_zhifubtn setTitle:@"进入服务" forState:UIControlStateNormal];

    }else if ([typeorder isEqualToString:@"19"]){
        _typestr = 4;
        [_zhifubtn setTitle:@"去评价" forState:UIControlStateNormal];

    }else if ([typeorder isEqualToString:@"0"]){
        if ([_orderdetailDict[@"disOrderType"] integerValue]==0) {
            _typestr = 5;
            [_zhifubtn setTitle:@"去支付" forState:UIControlStateNormal];//预定
            
        }else if ([_orderdetailDict[@"disOrderType"] integerValue]==1&&[_orderdetailDict[@"disOrderType"] floatValue]>0){//判断是预定还是服务页面退出来的，服务页面是否有加菜
            _typestr = 5;
            [_zhifubtn setTitle:@"去支付" forState:UIControlStateNormal];
            
        }else if ([_orderdetailDict[@"disOrderType"] integerValue]==1&&[_orderdetailDict[@"disOrderType"] floatValue]==0){//服务，为加菜
            _typestr = 3;
            [_zhifubtn setTitle:@"进入服务" forState:UIControlStateNormal];
        }
    }else if ([typeorder isEqualToString:@"1"]||[typeorder isEqualToString:@"11"]){
        _typestr = 0;
        [_zhifubtn setTitle:@"取消订单" forState:UIControlStateNormal];
    }else{
        _typestr = 2;
        [_zhifubtn setTitle:@"再次预订" forState:UIControlStateNormal];
    }
     //未支付，倒计时支付
        UIButton * paybtn = [UIButton buttonWithType:UIButtonTypeCustom];
        paybtn.backgroundColor = UIColorFromRGB(0xfd7577);
            [paybtn addTarget:self action:@selector(Pay) forControlEvents:UIControlEventTouchUpInside];
        paybtn.layer.cornerRadius = 3;
        paybtn.titleLabel.font = [UIFont systemFontOfSize:autoScaleW(13)];
        [paybottomview addSubview:paybtn];
        paybtn.sd_layout.rightSpaceToView(_zhifubtn,autoScaleW(10)).topEqualToView(_zhifubtn).widthIs(autoScaleW(80)).heightIs(autoScaleH(30));
    
    if ([typeorder isEqualToString:@"4"]||[typeorder isEqualToString:@"0"]){
        
        [paybtn setTitle:@"取消订单" forState:UIControlStateNormal];
        
    }else{
        paybtn.hidden = YES;
    }

}
#pragma mark 倒计时定时器
- (void)timer
{
    
    UIApplication*   app = [UIApplication sharedApplication];
    __block    UIBackgroundTaskIdentifier bgTask;
    bgTask = [app beginBackgroundTaskWithExpirationHandler:^{
        dispatch_async(dispatch_get_main_queue(), ^{
            [app endBackgroundTask:bgTask];

        });
    }];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            if (bgTask != UIBackgroundTaskInvalid)
            {
                bgTask = UIBackgroundTaskInvalid;
            }
        });
    });
    
    NSTimeInterval timeterval = [_orderdetailDict[@"timers"] integerValue];
//    NSTimeInterval timeterval = 30;
    if (timeterval==0)//超时
    {
        [_zhifubtn setTitle:@"再次预订" forState:UIControlStateNormal];
        _typestr = 2;
        _titlelabel.text = @"超时取消";
    }
    else
    {
        NSLog(@"klkl%d",timeterval);
        if (_timer==nil) {
            __block int timeout = timeterval; //倒计时时间
            
            if (timeout!=0) {
                dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0);
                _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
                dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
                dispatch_source_set_event_handler(_timer, ^{
                    if(timeout<=0){ //倒计时结束，关闭
                        dispatch_source_cancel(_timer);
                        _timer = nil;
                            //                                                            [MBProgressHUD showMessage:@"请稍等"];
                            
                            NSString * url = [NSString stringWithFormat:@"%@/api/user/myOrderManage?token=%@&userId=%@&operation=2&orderId=%@&orderType=%@",commonUrl,Token,Userid,_orderdetailDict[@"orderId"],_orderdetailDict[@"orderType"]];
                            NSArray * urlary = [url componentsSeparatedByString:@"?"];
                            
                            [[QYXNetTool shareManager]postNetWithUrl:urlary.firstObject urlBody:urlary.lastObject bodyStyle:QYXBodyString header:nil response:QYXJSON success:^(id result)
                             {
                                
                                NSString * msgstr = [NSString stringWithFormat:@"%@",result[@"msgType"]];
                                 if ([msgstr isEqualToString:@"0"]) {
                                     [_zhifubtn setTitle:@"再次预订" forState:UIControlStateNormal];
                                     _typestr = 2;
                                     _titlelabel.text = @"订单取消";
                                     _endtimelabel.hidden = YES;
                                 }else{
                                     
                                     [MBProgressHUD showError:@"取消失败，请联系客服"];
                                 }
                                 
                             } failure:^(NSError *error)
                             {
                                 [MBProgressHUD showError:@"请求失败"];
                                 
                             }];
//                        });
                    }else{
                        int days = (int)(timeout/(3600*24));
                        
                        int hours = (int)((timeout-days*24*3600)/3600);
                        int minute = (int)(timeout-days*24*3600-hours*3600)/60;
                        int second = timeout-days*24*3600-hours*3600-minute*60;
                        
                        dispatch_async(dispatch_get_main_queue(), ^{
                            
                            if (minute>=1) {
                                
                                _endtimelabel.text = [NSString stringWithFormat:@"(剩余时间%dm:%ds)",minute,second];
                                
                            }
                            else
                            {
                                _endtimelabel.text = [NSString stringWithFormat:@"(剩余时间%ds)",second];
                            }
                            
                        });
                        timeout--;
                    }
                });
                dispatch_resume(_timer);
            }
        }
    }

    
}
#pragma mark 打电话
-(void)Callphone
{
    NSString *message = NSLocalizedString(_model.storephone, nil);
    NSString *cancelButtonTitle = NSLocalizedString(@"取消", nil);
    NSString *otherButtonTitle = NSLocalizedString(@"拨打", nil);
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:message preferredStyle:UIAlertControllerStyleAlert];
    
    // Create the actions.
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:cancelButtonTitle style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        [alertController dismissViewControllerAnimated:YES completion:^{
            
            
        }];
    }];
    
    UIAlertAction *otherAction = [UIAlertAction actionWithTitle:otherButtonTitle style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        NSMutableString *str=[[NSMutableString alloc] initWithFormat:@"tel:%@",_model.storephone];
        UIWebView *callWebview = [[UIWebView alloc] init];
        [callWebview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:str]]];
        [self.view addSubview:callWebview];
        
    }];
    
    // Add the actions.
    [alertController addAction:cancelAction];
    [alertController addAction:otherAction];
    
    [self presentViewController:alertController animated:YES completion:nil];
}
#pragma mark 进店
- (void)GotoStore
{
    NewMerchantVC * storedetail = [[NewMerchantVC alloc]init];
    storedetail.idstr = _orderdetailDict[@"storeId"];
    storedetail.titlestr = _orderdetailDict[@"storeName"];
    [self.navigationController pushViewController:storedetail animated:YES];
    
    
}
#pragma mark 导航
- (void)ClickAddressbtn
{
    AMapRouteSearchRequestAPI *routeMap = [[AMapRouteSearchRequestAPI alloc] init];
    routeMap.latstr = _orderdetailDict[@"lat"];
    routeMap.lngstr = _orderdetailDict[@"lng"];
    [self.navigationController pushViewController:routeMap animated:YES];
}
#pragma mark 取消按钮
-(void) Pay
{
   
        NSDateFormatter *formatter=[[NSDateFormatter alloc]init];
        [formatter setDateFormat:@"MM-dd HH:mm"];
        NSString *dateTime=[formatter stringFromDate:[NSDate date]];
        NSDate *date = [formatter dateFromString:dateTime];
        
        NSString * arrivestr = [NSString stringWithFormat:@"%@",_orderdetailDict[@"arrivalTime"]];
        NSTimeInterval timestr = [arrivestr doubleValue]/1000.0;
        NSDate * arrivedata = [NSDate dateWithTimeIntervalSince1970:timestr];
        
        
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"MM-dd HH:mm"];
        NSString *oneDayStr = [dateFormatter stringFromDate:date];
        NSString *anotherDayStr = [dateFormatter stringFromDate:arrivedata];
        NSDate *dateA = [dateFormatter dateFromString:oneDayStr];
        NSDate *dateB = [dateFormatter dateFromString:anotherDayStr];
        NSComparisonResult result = [dateA compare:dateB];
        if (result ==  NSOrderedAscending) {
            
            ZTAddOrSubAlertView * subalert = [[ZTAddOrSubAlertView alloc]initWithStyle:ZTalertSheetStyleTitle];
            subalert.titleLabel.text = @"您确定要取消订单？";
            subalert.complete = ^(BOOL choose){
                if (choose==YES) {
                    
                    [self cancleOrder];
                    
                }
                
            };
        }
        else if (result == NSOrderedDescending){
            [MBProgressHUD showMessage:@"请稍等"];
            NSString * deletUrl = [NSString stringWithFormat:@"%@/common/getPer?",commonUrl];
            [[QYXNetTool shareManager]getNetWithUrl:deletUrl urlBody:nil header:nil response:QYXJSON success:^(id result) {
                [MBProgressHUD hideHUD];
                NSLog(@"<><><%@",result);
                NSString * msgType = [NSString stringWithFormat:@"%@",result[@"msgType"]];
                if ([msgType isEqualToString:@"0"]) {
                    NSString * objdstr = result[@"obj"];
                    ZTAddOrSubAlertView * subalert = [[ZTAddOrSubAlertView alloc]initWithStyle:ZTalertSheetStyleTitle];
                    subalert.titleLabel.text = [NSString stringWithFormat:@"若迟到超三十分钟取消要扣%@的商家损失费",objdstr];
                    subalert.complete = ^(BOOL choose){
                        if (choose==YES) {
                            
                            [self cancleOrder];
                            
                        }
                    };
                    
                }else{
                    [MBProgressHUD showMessage:@"请求失败"];
                }
            } failure:^(NSError *error) {
                [MBProgressHUD hideHUD];
            }];
         }

}
//取消订单
- (void)cancleOrder{
    [MBProgressHUD showMessage:@"请稍等"];
    
    NSString * url = [NSString stringWithFormat:@"%@/api/user/myOrderManage?token=%@&userId=%@&operation=1&orderId=%@&orderType=%@",commonUrl,Token,Userid,_orderdetailDict[@"orderId"],_orderdetailDict[@"orderType"]];
    NSArray * urlary = [url componentsSeparatedByString:@"?"];
    
    [[QYXNetTool shareManager]postNetWithUrl:urlary.firstObject urlBody:urlary.lastObject bodyStyle:QYXBodyString header:nil response:QYXJSON success:^(id result)
     
     {
         [MBProgressHUD hideHUD];
         
         NSString * msgtype = [NSString stringWithFormat:@"%@",result[@"msgType"]];
         if ([msgtype isEqualToString:@"0"]) {
             [MBProgressHUD showSuccess:@"取消成功"];
             [self Back];
         }else{
             [MBProgressHUD showError:@"取消失败"];
         }
     } failure:^(NSError *error)
     {
         [MBProgressHUD hideHUD];
         [MBProgressHUD showMessage:@"请求失败"];

         
     }];

}
#pragma mark 取消订单或者扫码用餐按钮
-(void)Cancel
{//根据各个订单状态 判断要执行的方法
    if (_typestr==0)
    {
        [self Pay];
    }
    else if (_typestr==1)
    {
        QRViewController * qrview = [[QRViewController alloc]init];
        qrview.orderid = _orderdetailDict[@"orderId"];
        qrview.pushint = 2;
        qrview.operation = @"0";
        [self.navigationController pushViewController:qrview animated:YES];
    }
    else if (_typestr==2){
        [self GotoStore];
    }
    else if (_typestr==3){
        DineserveViewController * dineview = [[DineserveViewController alloc]init];
        dineview.orderid = _orderdetailDict[@"orderId"];
        dineview.operint = @"0";
        dineview.storeid = _orderdetailDict[@"storeId"];
        [self.navigationController pushViewController:dineview animated:YES];
    }else if (_typestr==4){
        JudgeViewController * judeview = [[JudgeViewController alloc]init];
        judeview.orderId = _orderdetailDict[@"orderId"];
        [self.navigationController pushViewController:judeview animated:YES];
        
    } else if (_typestr==5) {
        
        PayViewController * payview = [[PayViewController alloc]init];
        payview.orderid = _orderdetailDict[@"orderId"];
        payview.storeid = _orderdetailDict[@"storeId"];
        payview.pushint = 0;
        payview.block = ^(NSString * str)
        {
            if ([str isEqualToString:@"success"]) {
                
                [_zhifubtn setTitle:@"扫码用餐" forState:UIControlStateNormal];
                _titlelabel.text = @"等待商家接单";
                
                if (_timer!=nil) {
                    
                    dispatch_source_cancel(_timer);
                }
                _typestr = 1;
            }
        };
        [self.navigationController pushViewController:payview animated:YES];
    }

}
-(void)Back
{
    
            MyorderViewController * myorderview = [[MyorderViewController alloc]init];
            self.tabBarController.selectedIndex = 1;
            [self.navigationController pushViewController:myorderview animated:YES];
    
    
    
}
-(BOOL)isCurrentViewControllerVisible:(UIViewController *)viewController
{
    return (viewController.isViewLoaded && viewController.view.window);
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
