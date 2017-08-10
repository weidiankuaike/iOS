//
//  NewMerchantVC.m
//  wdKuaiKe_iOS
//
//  Created by Skyer God on 16/9/29.
//  Copyright © 2016年 weiDianKuaiKe. All rights reserved.
//

#import "NewMerchantVC.h"

#import "SDCycleScrollView.h"
#import "ZTViewSelectorController.h"
#import "NewMerchantDetailVC.h"
//#import "NewOrderVC.h"
#import "RestaurantOrderVC.h"
#import "ShoppingCartView.h"

#import "ShoppingCartSingletonView.h"

//#import "NewOrderVC.h"
#import "QYXNetTool.h"
#import "SecurityUtil.h"
//
#import "UIBarButtonItem+SSExtension.h"
#import "MBProgressHUD+SS.h"
#import "WMCustomDatePicker.h"
#import "SunmitViewController.h"
#import "ResviceDetail.h"
#import "LoginViewController.h"
#import "WQLPaoMaView.h"
#import "AnimationLabel.h"
@interface NewMerchantVC ()<WMCustomDatePickerDelegate>
@property (nonatomic, strong) NewMerchantDetailVC *merchantDetailVC ;
@property (nonatomic, strong) RestaurantOrderVC *orderVC ;
@property (nonatomic, strong) ZTViewSelectorController *controlView;
@property (nonatomic, strong) NSDictionary * xinxidict;
@property (nonatomic, strong) UIView * pickview;//时间选择
@property (nonatomic,copy)  NSString * begintimestr;
@property (nonatomic, copy)   NSString * timestr;// 获取到的时间
@property (nonatomic, strong)   UIView * shezhivieww;//人数选择
@property (nonatomic, strong) UIButton * yudingbtn;//预定按钮
@property (nonatomic, strong) UIView * ydbottomview;//预定视图
@property (nonatomic, strong) UILabel * timelabel;//预定时间和人数label
@property (nonatomic, copy) NSString * time;//预定时间
@property (nonatomic,copy)  NSString * people;//预定人数

@property (nonatomic,strong) UIButton *daybtn;
@property (nonatomic,copy) NSString * uptime;
@property (nonatomic,strong)UILabel * numlabel;//商品总数label
@property (nonatomic,strong)UILabel * moneylabel;//商品总价
@property (nonatomic,copy)NSString * numstr;//本地获取的总数
@property (nonatomic,copy)NSString * sumstr;//本地获取的价格综合
@property (nonatomic,strong)NSMutableArray * dictary;//存放所有菜品数据的数据
@property (nonatomic,strong)NSMutableDictionary * userddict;//樽坊本地的字典
@property (nonatomic,strong)UIButton * tijiaobtn;
@property (nonatomic,strong)NSMutableDictionary * chuanzhidict;//传到预定详情页的字典
@property (nonatomic,retain) ResviceDetail * detailview;
@property (nonatomic,copy)NSString * storename;//店铺名字
@property (nonatomic,copy)UILabel * titlabel;//标题
@property (nonatomic,copy)NSString * isBook;//是否接受预定
@property (nonatomic,copy)NSString * bookDays;//提前预定天数
@property (nonatomic,retain)UIView * backgroundView;//蒙版
@property (nonatomic,strong)WQLPaoMaView * animationView;//跑马灯

@property (nonatomic,copy)NSString * noticeStr;//店铺公告
@end
static int a = 0;
@implementation NewMerchantVC
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];

    self.navigationController.navigationBar.hidden = NO;
    self.tabBarController.tabBar.hidden = YES;

    
    _controlView.hidden = NO;
    self.navigationController.navigationBar.translucent = NO;
    [self.navigationController.navigationBar setBarTintColor:UIColorFromRGB(0xfd7577)];
    
    [self Takesomething];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:NO];

    [self.navigationController.view viewWithTag:3000].hidden = NO;
    self.tabBarController.tabBar.hidden = NO;
//    _controlView.hidden = YES;

}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    self.view.backgroundColor = [UIColor whiteColor];
    _titlabel = [[UILabel alloc]init];
    _titlabel.frame = CGRectMake(0, 0, 200, 30);
    _titlabel.textAlignment = NSTextAlignmentCenter;
    _titlabel.font = [UIFont systemFontOfSize:15];
    _titlabel.text = _titlestr;
    _titlabel.textColor = [UIColor whiteColor];
    self.navigationItem.titleView = _titlabel;
    UIBarButtonItem * backbtn = [UIBarButtonItem itemWithTarget:self Action:@selector(Back) image:@"left-1" selectImage:nil];
    self.navigationItem.leftBarButtonItem = backbtn;
   
    _userddict = [NSMutableDictionary dictionary];
    

    [self Getdata];
    //预定订单详情页通知
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(Change:) name:@"changedine" object:nil];
    //提交订单通知
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(Remove) name:@"remove" object:nil];
    
    //订单详情页消失通知
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(removeView) name:@"removeView" object:nil];
 }
- (void)removeView{
    
    a = 0;
}
#pragma mark 取出保存本地的店铺信息
- (void)Takesomething
{
    NSMutableDictionary * mutdict = [[NSUserDefaults standardUserDefaults]objectForKey:@"save"];
    NSLog(@",.,.%@",mutdict);
    
    _chuanzhidict = [NSMutableDictionary dictionary];
    _dictary = [NSMutableArray array];
    if (mutdict !=nil) {
        
        NSArray * keysary = mutdict.allKeys;
        NSString * keystr = keysary.firstObject;
        
        if ([keystr isEqualToString:_idstr]) {
            NSDictionary * dict = [mutdict objectForKey:_idstr];
            _numstr = dict[@"num"];
            _sumstr = dict[@"sum"];
            _time = dict[@"time"];
            _people = dict[@"people"];
            _timestr = dict[@"uptimer"];
            _dictary = [NSMutableArray arrayWithArray:dict [@"dictary"]];
            _chuanzhidict = [NSMutableDictionary dictionaryWithDictionary:dict];
        }
    }
}
#pragma mark 网络请求
- (void)Getdata
{
  __weak NSString * userId=nil;
    if ([[NSUserDefaults standardUserDefaults]objectForKey:@"idd"]==nil) {
        
        userId = @"";
    }else{
        userId = [[NSUserDefaults standardUserDefaults]objectForKey:@"idd"];
    }
    
    NSString * urlstr = [NSString stringWithFormat:@"%@/getStoreData?storeId=%@&userId=%@&lat=&lng=",commonUrl,_idstr,userId];
    [MBProgressHUD showMessage:@"请稍等"];
    NSArray * urlary = [urlstr componentsSeparatedByString:@"?"];
    
    [[QYXNetTool shareManager]postNetWithUrl:urlary.firstObject urlBody:urlary.lastObject bodyStyle:QYXBodyString header:nil response:QYXJSON success:^(id result)
    {
        NSLog(@">>>%@",result);
        [MBProgressHUD hideHUD];
        NSString * msgtype = [NSString stringWithFormat:@"%@",[result objectForKey:@"msgType"]];
        if ([msgtype isEqualToString:@"0"]) {
            
            _xinxidict = [result objectForKey:@"obj"];
            _starstr = [NSString stringWithFormat:@"%@",_xinxidict[@"avgScore"]];
            _storename = _xinxidict[@"name"];
            _storeImage = _xinxidict[@"storeImage"];
            _titlabel.text = _storename;
            _bookDays = _xinxidict[@"bookdays"];
            _isBook = [NSString stringWithFormat:@"%@",_xinxidict[@"isBook"]];
            _noticeStr = [NSString stringWithFormat:@"%@",_xinxidict[@"noticeBoard"]];
             [self setupTopHeaderView];
             
        }
        
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUD];
        [MBProgressHUD showError:@"网络错误"];
    }];
}

- (void)setupTopHeaderView{
//    /** 顶部轮播图 和 两个导航栏 **/
//
//    /** 设置定时器 **/
//    NSArray *imageArr = @[@"first",@"second",@"turnPlay"];
//    NSArray *titleArr = @[@"one", @"two", @"three"];
//    self.automaticallyAdjustsScrollViewInsets = NO;
//
//    SDCycleScrollView *scrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, star_y, self.view.size.width, height) imageNamesGroup:imageArr];
//    scrollView.titlesGroup = titleArr;
//    scrollView.backgroundColor = [UIColor redColor];
//    [self.view addSubview:scrollView];
    CGFloat star_y = 50;
    CGFloat height = autoScaleH(180);
    UIImageView * headimage = [[UIImageView alloc]init];
    [headimage sd_setImageWithURL:[NSURL URLWithString:self.storeImage] placeholderImage:[UIImage imageNamed:@"1"]];
    headimage.frame = CGRectMake(0, 0, self.view.size.width, height);
    [self.view addSubview:headimage];
    headimage.userInteractionEnabled = YES;
    
 //系统自带模糊效果
//    UIBlurEffect * beffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
//    UIVisualEffectView * view = [[UIVisualEffectView alloc]initWithEffect:beffect];
//    view.frame = headimage.bounds;
//    [headimage addSubview:view];
    
    if (![_noticeStr isEqualToString:@""]) {
        
        AnimationLabel * animation = [[AnimationLabel alloc]initWithFrame:CGRectMake(0, 0, headimage.frame.size.width, autoScaleW(20)) text:[NSString stringWithFormat:@"店铺公告:%@",_noticeStr] image:headimage];
        animation.backgroundColor = [UIColor greenColor];
        [headimage addSubview:animation];
        
    }
    
    //名字
    UILabel * namelabel = [[UILabel alloc]init];
    namelabel.text = _storename;
    namelabel.textColor = [UIColor whiteColor];
    [headimage addSubview:namelabel];
    namelabel.sd_layout.leftSpaceToView(headimage,autoScaleW(15)).bottomSpaceToView(headimage,autoScaleH(50)).heightIs(autoScaleH(20));
    [namelabel setSingleLineAutoResizeWithMaxWidth:300];
    
    
    NSString * iscollect = [NSString stringWithFormat:@"%@",_xinxidict[@"isCollected"]] ;
    
    UIButton * scbtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [scbtn setBackgroundImage:[UIImage imageNamed:@"收藏2"] forState:UIControlStateNormal];
    [scbtn setBackgroundImage:[UIImage imageNamed:@"收藏1"] forState:UIControlStateSelected];
    if ([iscollect isEqualToString:@"1"]) {
        
        scbtn.selected = YES;
    }
    
    [scbtn addTarget:self action:@selector(Shoucang:) forControlEvents:UIControlEventTouchUpInside];
    [headimage addSubview:scbtn];
    scbtn.sd_layout.rightSpaceToView(headimage,autoScaleW(25)).bottomSpaceToView(headimage,autoScaleH(30)).widthIs(autoScaleW(30)).heightIs(autoScaleW(25));
    
    //评分
    
    UILabel * pflabel = [[UILabel alloc]init];
    pflabel.text = @"评分:";
    pflabel.textColor = [UIColor whiteColor];
    pflabel.font = [UIFont systemFontOfSize:autoScaleW(13)];
    [headimage addSubview:pflabel];
    pflabel.sd_layout.leftEqualToView(namelabel).topSpaceToView(namelabel,autoScaleH(10)).widthIs(autoScaleW(35)).heightIs(autoScaleH(15));
    
    
    if ([_starstr rangeOfString:@"."].location!=NSNotFound)
    {
        
        float x = [_starstr floatValue];
        int v = ceilf(x);
        if ([[_starstr substringWithRange:NSMakeRange(2, 1)] integerValue]<=5)
        {
            for (int i=0; i<v; i++) {
                
                UIImageView * xingimage = [[UIImageView alloc]init];
                if (i!=(v-1)) {
                    xingimage.image = [UIImage imageNamed:@"x"];
                }
                else
                {
                    xingimage.image = [UIImage imageNamed:@"半"];
                }
                [headimage addSubview:xingimage];
                
                xingimage.sd_layout.leftSpaceToView(pflabel,autoScaleW(10)+i*autoScaleW(15)).topSpaceToView(namelabel,autoScaleH(10)).widthIs(autoScaleW(15)).heightIs(autoScaleH(15));
            }
            
        }
        else
        {
            for (int i=0; i<v; i++) {
                
                UIImageView * xingimage = [[UIImageView alloc]init];
                
                xingimage.image = [UIImage imageNamed:@"x"];
                [headimage addSubview:xingimage];
                
                xingimage.sd_layout.leftSpaceToView(pflabel,autoScaleW(10)+i*autoScaleW(15)).topSpaceToView(namelabel,autoScaleH(10)).widthIs(autoScaleW(15)).heightIs(autoScaleH(15));
            }
            
        }
    }
    else
    {
        
        for (int i=0; i<[_starstr integerValue]; i++)
        {
            
            UIImageView * xingimage = [[UIImageView alloc]init];
            xingimage.image = [UIImage imageNamed:@"x"];
            [headimage addSubview:xingimage];
            
            xingimage.sd_layout.leftSpaceToView(pflabel,autoScaleW(10)+i*autoScaleW(15)).topSpaceToView(namelabel,autoScaleH(10)).widthIs(autoScaleW(15)).heightIs(autoScaleH(15));
        }
    }
    
    /** 设置两个导航分栏控制器 **/
   
    _merchantDetailVC = [[NewMerchantDetailVC alloc] init];
    _merchantDetailVC.dict = _xinxidict;
    _merchantDetailVC.storeid = _idstr;
    _orderVC = [[RestaurantOrderVC alloc] init];
    
    _orderVC.block = ^(NSInteger number,float sum,NSMutableArray * dictary)
    {
        if (number!=0) {
            
            _numlabel.hidden = NO;
            _numlabel.text = [NSString stringWithFormat:@"%ld",number];
            
            _moneylabel.text = [NSString stringWithFormat:@"￥%.2f",sum];
            _moneylabel.textColor = UIColorFromRGB(0xfd7577);

        }
        else
        {
            _numlabel.hidden = YES;
            _moneylabel.text = @"购物车空空如也";

        }
        
        _dictary = dictary;
        
        [_chuanzhidict setObject:_dictary forKey:@"dictary"];
        
//        if (_numstr!=nil||_people!=nil) {
        
            _yudingbtn.hidden = YES;
            _ydbottomview.hidden = NO;
//        }
        
        if (_people==nil)
        {
            [_tijiaobtn setTitle:@"选时选座" forState:UIControlStateNormal];
            
        }
        
    };
    _orderVC.isbook = _isBook;
    _orderVC.storeid = _idstr;
    _orderVC.number = [_numstr integerValue];
    NSString * sumstring = [_sumstr substringFromIndex:1];
    _orderVC.sum = [sumstring floatValue];
    _orderVC.dictary = _dictary;
    NSArray *vcNameArr = @[_merchantDetailVC, _orderVC];
    [self addChildViewController:_orderVC];
    [self addChildViewController:_merchantDetailVC];
    NSArray *naviTitlesArr = @[@"商家信息",@"预约点餐"];
        CGRect rect  = CGRectMake(0, height, self.view.size.width, self.view.size.height - height);
    _controlView = [[ZTViewSelectorController alloc] initWithControllers:vcNameArr titles:naviTitlesArr frame:rect];
     [self.view addSubview:_controlView];
    _controlView.block = ^(NSInteger selectindx){
      //block 回调 改变点餐视图的位置
        if (selectindx==0) {
            _controlView.frame = CGRectMake(0, height, self.view.size.width, self.view.size.height - height);
        }
        else if (selectindx==1){
            _controlView.frame = CGRectMake(0, 0, self.view.size.width, self.view.size.height) ;
        }
        [_controlView updateLayout];
    };
    

//预定按钮，预定视图，二选一
    
    _yudingbtn = [UIButton buttonWithType:UIButtonTypeCustom];
    if ([_isBook isEqualToString:@"1"]) {
        
       [_yudingbtn setTitle:@"预订" forState:UIControlStateNormal];
        _yudingbtn.backgroundColor = UIColorFromRGB(0xfd7577);
        _yudingbtn.userInteractionEnabled = YES;
    }else{
        
        [_yudingbtn setTitle:@"未开启预订" forState:UIControlStateNormal];
        _yudingbtn.backgroundColor = [UIColor lightGrayColor];
        _yudingbtn.userInteractionEnabled = NO;
    }
    
    _yudingbtn.titleLabel.font = [UIFont systemFontOfSize:autoScaleW(15)];
    [_yudingbtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    [_yudingbtn addTarget:self action:@selector(Reserve) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_yudingbtn];
    _yudingbtn.sd_layout.leftEqualToView(self.view).rightEqualToView(self.view).bottomEqualToView(self.view).heightIs(autoScaleH(50));
    
    
    _ydbottomview = [[UIView alloc]init];
    [self.view addSubview:_ydbottomview];
    _ydbottomview.sd_layout.leftEqualToView(self.view).rightEqualToView(self.view).bottomEqualToView(self.view).heightIs(autoScaleH(50));
    _ydbottomview.userInteractionEnabled = YES;
    
    UITapGestureRecognizer * tapges = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(Present)];
    [_ydbottomview addGestureRecognizer:tapges];
    
    UIImageView * carimage = [[UIImageView alloc]init];
    carimage.tag = 5000;
    carimage.image = [UIImage imageNamed:@"购物车"];
    [_ydbottomview addSubview:carimage];
    carimage.sd_layout.leftSpaceToView(_ydbottomview,autoScaleW(5)).centerYIs(_ydbottomview.centerY - autoScaleH(15)).widthIs(autoScaleW(40)).heightIs(autoScaleH(40));
//    [self.view insertSubview:carimage atIndex:0];

    _numlabel = [[UILabel alloc]init];
    _numlabel.textAlignment = NSTextAlignmentCenter;
    _numlabel.textColor = UIColorFromRGB(0xfd7577);
    _numlabel.backgroundColor = [UIColor whiteColor];
    _numlabel.layer.masksToBounds = YES;
    _numlabel.layer.cornerRadius = autoScaleW(7.5);
    [carimage addSubview:_numlabel];
    _numlabel.sd_layout.centerYIs(carimage.frame.origin.y+autoScaleH(8)).centerXIs(carimage.centerX + autoScaleW(12)).widthIs(autoScaleW(15)).heightIs(autoScaleH(15));
    _numlabel.adjustsFontSizeToFitWidth = YES;
    
    if (_numstr!=nil) {
        
        _numlabel.text = _numstr;
    }
    else
    {
        _numlabel.hidden = YES;
    }
    
    _moneylabel = [[UILabel alloc]init];
    if (_sumstr !=nil) {
        
        _moneylabel.font = [UIFont boldSystemFontOfSize:autoScaleW(15)];
        _moneylabel.text = _sumstr;
        _moneylabel.textColor = UIColorFromRGB(0xfd7577);
        
    }
    else
    {
        _moneylabel.text = @"购物车空空如也";
        _moneylabel.textColor = [UIColor lightGrayColor];
        _moneylabel.font = [UIFont systemFontOfSize:autoScaleW(13)];
    }
    [_ydbottomview addSubview:_moneylabel];
    _moneylabel.sd_layout.leftSpaceToView(carimage,autoScaleW(10)).topSpaceToView(_ydbottomview,autoScaleH(15)).heightIs(autoScaleH(15));
    [_moneylabel setSingleLineAutoResizeWithMaxWidth:150];
    
    
    _timelabel = [[UILabel alloc]init];
    _timelabel.font = [UIFont systemFontOfSize:autoScaleW(13)];
    _timelabel.textColor = [UIColor blackColor];
    [_ydbottomview addSubview:_timelabel];
    _timelabel.sd_layout.leftSpaceToView(_moneylabel,autoScaleW(10)).topSpaceToView(_ydbottomview,autoScaleH(15)).widthIs(150).heightIs(autoScaleH(15));
    
    if (_time!=nil&&_people!=nil) {
        
        _timelabel.text = [NSString stringWithFormat:@"%@,%@用餐",_time,_people];
      }
    else
    {
         _timelabel.text = @"未选择时间及人数";
    }
    

    _tijiaobtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_tijiaobtn setTitle:@"提交订单" forState:UIControlStateNormal];
    _tijiaobtn.backgroundColor = [UIColor orangeColor];
    [_tijiaobtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _tijiaobtn.titleLabel.font = [UIFont systemFontOfSize:autoScaleW(13)];
    [_tijiaobtn addTarget:self action:@selector(Tijiao) forControlEvents:UIControlEventTouchUpInside];
    [_ydbottomview addSubview:_tijiaobtn];
    _tijiaobtn.sd_layout.rightEqualToView(_ydbottomview).topEqualToView(_ydbottomview).widthIs(autoScaleW(70)).heightIs(autoScaleH(50));
    
    if (_numstr!=nil||_people!=nil) {
        
        _yudingbtn.hidden = YES;
        _ydbottomview.hidden = NO;
    }
    else
    {
        _ydbottomview.hidden = YES;
        _yudingbtn.hidden = NO; 
    }
    
        if (_numstr!=nil&&_people==nil)
        {
            [_tijiaobtn setTitle:@"选时选座" forState:UIControlStateNormal];
            
        }

 }
//查看预定详情
- (void)Present
{
    if (_numstr = nil) {
        
        [self Reserve];
    }
    else
    {
    if (_chuanzhidict==nil) {
        
        _chuanzhidict = _userddict;
    }
        NSMutableArray * dishary = [NSMutableArray arrayWithArray:_chuanzhidict[@"dictary"] ];
        if (a==0&&_dictary.count!=0) {//查看预定详情页面
           _detailview = [[ResviceDetail alloc]initWithary:dishary];
            [self.view addSubview:_detailview];
            _detailview.sd_layout.leftEqualToView(self.view).rightEqualToView(self.view).bottomSpaceToView(_ydbottomview,0).heightIs(self.view.frame.size.height - _ydbottomview.frame.size.height);
            [self.view bringSubviewToFront:_ydbottomview];
            a +=1;
        }
        else
        {
            [_detailview removeFromSuperview];
            _detailview = nil;
            a = 0;
        }
    }
    
}
//订单详情修改订单
- (void)Change:(NSNotification*)not
{
    NSString * change = not.userInfo[@"change"];
    if ([change isEqualToString:@"yes"]) {
        _numstr = [NSString stringWithFormat:@"%ld",[_numlabel.text integerValue]+1];//预定菜品数量
        NSString * sumstring = [_moneylabel.text substringFromIndex:1];                  NSString * fee = not.userInfo[@"fee"];
                    _sumstr = [NSString stringWithFormat:@"%.2f",[sumstring floatValue]+[fee floatValue]];//预定总价
        
        _numlabel.text = _numstr;
        _moneylabel.text = [NSString stringWithFormat:@"￥%@",_sumstr];
        _dictary = [NSMutableArray arrayWithArray:not.userInfo[@"ary"]] ;
        [_chuanzhidict setObject:_dictary forKey:@"dictary"];

        
    }
    else if ([change isEqualToString:@"no"])
    {
        _numstr = [NSString stringWithFormat:@"%ld",[_numlabel.text integerValue]-1];//预定菜品数量
                            NSString * sumstring = [_moneylabel.text substringFromIndex:1];
                            NSString * fee = not.userInfo[@"fee"];
                            _sumstr = [NSString stringWithFormat:@"%.2f",[sumstring floatValue]-[fee floatValue]];//预定总价
        
        _numlabel.text = _numstr;
        _moneylabel.text = [NSString stringWithFormat:@"￥%@",_sumstr];
        _dictary = [NSMutableArray arrayWithArray:not.userInfo[@"ary"]] ;
        [_chuanzhidict setObject:_dictary forKey:@"dictary"];

    }
    else if ([change isEqualToString:@"choose"])
    {
        [_detailview removeFromSuperview];
        a = 0;
       
        [self Reserve];
        
    }
    else if ([change isEqualToString:@"remove"])
    {
        [_detailview removeFromSuperview];
        a = 0;
        _numlabel.hidden = YES;
        _moneylabel.text = @"购物车空空如也";
        _dictary = [NSMutableArray arrayWithArray:not.userInfo[@"ary"]] ;
        [_chuanzhidict setObject:_dictary forKey:@"dictary"];
    }

}
//提交订单删除菜品
- (void)Remove
{
    
    _numlabel.hidden = YES;
    _moneylabel.text = @"购物车空空如也";
    
}
#pragma mark 预定
- (void)Reserve
{
    
    if (_uptime==nil&&_backgroundView==nil) {
        
        [self creattimechoose];
        [UIView animateWithDuration:0.5 animations:^{
            //        self.pickerView.frame = CGRectMake(0, self.view.height-260, [UIScreen mainScreen].bounds.size.width, 300);
            self.backgroundView.frame = CGRectMake(0, 0, GetWidth, GetHeight);
        }];
    }
}
//时间选择器
- (void)creattimechoose
{
    self.backgroundView = [[UIView alloc]initWithFrame:CGRectMake(0, GetHeight, GetWidth, GetHeight)];
    self.backgroundView.backgroundColor = RGBA(0, 0, 0, 0.3);
    self.pickview = [[UIView alloc] initWithFrame:CGRectMake(0, GetHeight-autoScaleH(260), [UIScreen mainScreen].bounds.size.width, autoScaleH(260))];
    self.pickview.backgroundColor = [UIColor whiteColor];
    
    WMCustomDatePicker *picker = [[WMCustomDatePicker alloc]initWithframe:CGRectMake(0, 40, [UIScreen mainScreen].bounds.size.width, 214) Delegate:self PickerStyle:WMDateStyle_DayHourMinute Day:[_bookDays integerValue]+1];
    picker.minLimitDate = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    self.begintimestr = [dateFormatter stringFromDate:[NSDate date]];
//    self.timestr = [dateFormatter stringFromDate:picker.date];
    
//    NSDateFormatter * uptimefor = [[NSDateFormatter alloc]init];
//    [uptimefor setDateFormat:@"MM-dd HH:mm"];
//    self.uptime = [uptimefor stringFromDate:picker.date];
    
    
    [self.pickview addSubview:picker];
    self.pickview.userInteractionEnabled = YES;
    [self.backgroundView addSubview:self.pickview];
    [self.navigationController.view addSubview:self.backgroundView];
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
}
//选择时间
- (void)timePickerBtnClicked:(UIButton *)btn{
     if (btn.tag==106) {
        if (_uptime!=nil) {
            
            [_userddict setObject:_uptime forKey:@"time"];
            
            [_userddict setObject:_timestr forKey:@"uptimer"];
            
            [UIView animateWithDuration:0.5 animations:^{
                //        self.pickerView.frame = CGRectMake(0, self.view.height-260, [UIScreen mainScreen].bounds.size.width, 300);
                [self Choosepeople];
                
            }];
            [_pickview removeFromSuperview];
        }
       else
       {
           [MBProgressHUD showError:@"请选择时间"];
       }
    }
    if (btn.tag ==105) {
         [_backgroundView removeFromSuperview];
        _backgroundView = nil;
        _uptime = nil;
    }
}
//选择人数
- (void)Choosepeople
{
    _shezhivieww = [[UIView alloc]init];
    _shezhivieww.backgroundColor = [UIColor whiteColor];
    [_backgroundView addSubview:_shezhivieww];
    _shezhivieww.sd_layout.leftSpaceToView(_backgroundView,0).rightSpaceToView(_backgroundView,0).bottomSpaceToView(_backgroundView,0).heightIs(autoScaleH(260));
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
}
#pragma mark 预定人数按钮
-(void)Ydday:(UIButton*)btn
{
    _daybtn.selected= NO;
    _daybtn.layer.borderColor = RGB(196, 196, 197).CGColor;
    btn.selected=YES;
    
    btn.layer.borderColor =  UIColorFromRGB(0xfd7577).CGColor;
    
    _daybtn = btn;
}

- (void)Cancle
{
    [_backgroundView removeFromSuperview];
    [_userddict removeObjectForKey:@"time"];
    _uptime==nil;
    _backgroundView = nil;
}
-(void)timeClick
{
    [_userddict setObject:_daybtn.titleLabel.text forKey:@"people"];

    
    [_backgroundView removeFromSuperview];
    if (_yudingbtn) {
        
        _yudingbtn.hidden = YES;
        _ydbottomview.hidden = NO;
        
        NSString * ydtime = [_userddict objectForKey:@"time"];
        _time = ydtime;
        
        NSString * peoplestr = [_userddict objectForKey:@"people"];
        _people = peoplestr;
        
        _timelabel.text = [NSString stringWithFormat:@"%@,%@用餐",_time,_people];
        [_tijiaobtn setTitle:@"提交订单" forState:UIControlStateNormal];        
    }
}
- (void)Back
{
    if (_detailview) {
        
        [_detailview removeFromSuperview];
        a = 0;
    }
    //保存用户选的数据 在支付成功之后清空  提交订单一样
    if (_userddict[@"people"]!=nil) {
        [_userddict setObject:_time forKey:@"time"];
        
        [_userddict setObject:_timestr forKey:@"uptimer"];
        [_userddict setObject:_people forKey:@"people"];
        
    }
    if (![_moneylabel.text isEqualToString:@"购物车空空如也"]&&_moneylabel.text!=
        
        nil) {
        [_userddict setObject:_numlabel.text forKey:@"num"];
        [_userddict setObject:_moneylabel.text forKey:@"sum"];
        [_userddict setObject:_dictary forKey:@"dictary"];
    }
    
    if (_userddict.allKeys.count!=0) {
        
        NSMutableDictionary * zongdict = [NSMutableDictionary dictionary];
        [zongdict setObject:_userddict forKey:_idstr];
        
        [[NSUserDefaults standardUserDefaults] setObject:zongdict forKey:@"save"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    
    [_animationView stop];
    [self.navigationController popViewControllerAnimated:NO];
    
}
#pragma mark 提交
- (void)Tijiao
{
    
    if (_detailview) {
        
        [_detailview removeFromSuperview];
        _detailview = nil;
        a = 0;
    }
    
       
//    [[NSUserDefaults standardUserDefaults]setObject:_dictary forKey:@"dictary"];
    
    if (_people==nil) {
        [self Reserve];
        
    }
    
    else
    {
        if (_daybtn.titleLabel.text!=nil) {
            [_userddict setObject:_time forKey:@"time"];
            
            [_userddict setObject:_timestr forKey:@"uptimer"];
            [_userddict setObject:_people forKey:@"people"];
            
        }
        
        if (![_moneylabel.text isEqualToString:@"购物车空空如也"]) {
            [_userddict setObject:_numlabel.text forKey:@"num"];
            [_userddict setObject:_moneylabel.text forKey:@"sum"];
            [_userddict setObject:_dictary forKey:@"dictary"];
        }
        
        NSMutableDictionary * zongdict = [NSMutableDictionary dictionary];
        [zongdict setObject:_userddict forKey:_idstr];
        
        [[NSUserDefaults standardUserDefaults] setObject:zongdict forKey:@"save"];
        [[NSUserDefaults standardUserDefaults] synchronize];

        
        [_animationView stop];
        
    SunmitViewController * sunmitview = [[SunmitViewController alloc]init];
    sunmitview.peoplestr = _people;
    sunmitview.timestr = _time;
    sunmitview.dictary = _dictary;
    sunmitview.feestr = _moneylabel.text;
    sunmitview.storeid = _idstr;
    sunmitview.updatetime = _timestr;
    sunmitview.number  = [_numlabel.text integerValue];
    [self.navigationController pushViewController:sunmitview animated:NO];
        
    }
    
}

- (void)Shoucang:(UIButton *)btn
{
    [MBProgressHUD showMessage:@"请稍等"];
    
    NSString * urlstr = [NSString stringWithFormat:@"%@/api/user/myCollectManage?token=%@&userId=%@&storeId=%@&operation=1",commonUrl,Token,Userid,_idstr];
    
    NSArray * urlary = [urlstr componentsSeparatedByString:@"?"];
    
    [[QYXNetTool shareManager]postNetWithUrl:urlary.firstObject urlBody:urlary.lastObject bodyStyle:QYXBodyString header:nil response:QYXJSON success:^(id result) {
        
        [MBProgressHUD hideHUD];
        NSString * typestr = [NSString stringWithFormat:@"%@",[result objectForKey:@"msgType"]];
        if ([typestr isEqualToString:@"0"]) {
            
            if (btn.selected == NO) {
                btn.selected = YES;
                [MBProgressHUD showSuccess:@"收藏成功"];
            }
            else
            {
                btn.selected = NO;
                
                [MBProgressHUD showSuccess:@"取消成功"];
            }
        }else if ([typestr isEqualToString:@"2000"]){
            
            [MBProgressHUD showError:@"请先登录"];
            LoginViewController * loginView = [[LoginViewController alloc]init];
            [self.navigationController pushViewController:loginView animated:YES];
        }else{
            
            [MBProgressHUD showError:@"请求失败"];
        }
        
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUD];
        [MBProgressHUD showError:@"请求失败"];
    }];
}

#pragma mark 时间选择代理方法
- (void)finishDidSelectDatePicker:(WMCustomDatePicker *)datePicker date:(NSDate *)date
{
    if ([date compare:[NSDate date]] == NSOrderedDescending) {
        self.timestr = [self dateFromString:date withFormat:@"yyyy-MM-dd HH:mm"];
        self.uptime = [self dateFromString:date withFormat:@"MM-dd HH:mm"];
    }
    
}

//根据date返回string
- (NSString *)dateFromString:(NSDate *)date withFormat:(NSString *)format {
    NSDateFormatter *inputFormatter = [[NSDateFormatter alloc] init];
    [inputFormatter setDateFormat:format];
    NSString *dateStr = [inputFormatter stringFromDate:date];
    return dateStr;
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
