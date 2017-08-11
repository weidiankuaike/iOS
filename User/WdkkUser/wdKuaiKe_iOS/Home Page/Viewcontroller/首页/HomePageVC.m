//
//  HomePageVC.m
//  wdKuaiKe_iOS
//
//  Created by Skyer God on 16/8/4.
//  Copyright © 2016年 weiDianKuaiKe. All rights reserved.
//
#define Ios8 ([[[UIDevice currentDevice] systemVersion] doubleValue] >=8.0 ? YES : NO)
#import "HomePageVC.h"

#import "RecommendTableViewCell.h"
#import "MerchantListCell.h"
#import "HeaderView.h"
#import "SerachView.h"
#import "ScanViewController.h"
#import "SearchViewController.h"
#import "PickerViewController.h"
#import "NetworkSingleton.h"
#import "SecurityUtil.h"
#import "QYXNetTool.h"
#import "LeftRightButton.h"
#import "ZTDropDownMenu.h"
#import "NewMerchantVC.h"
#import "LNLocationManager.h"
#import "LNSearchManager.h"
#import <AMapFoundationKit/AMapFoundationKit.h>
#import <AMapLocationKit/AMapLocationKit.h>
//重写
#import "MinePageVC.h"
#import "Btnscrollerview.h"
#import <SDCycleScrollView.h>
#import "StoreScrollview.h"
#import "MBProgressHUD+SS.h"
#import "Homemodel.h"
#import "NSObject+JudgeNull.h"
#import "HomeTableViewCell.h"
#import "MJExtension.h"
#import "SdycViewController.h"
#import "LoginViewController.h"
#import "SearchStoreModel.h"
#import "MJRefreshNormalHeader.h"
#import "MJRefreshAutoNormalFooter.h"
#import "AppDelegate.h"
#import "XGPush.h"
#import "DeviceSet.h"
@interface HomePageVC ()<UITableViewDelegate, UITableViewDataSource, AMapLocationManagerDelegate>
{

    NSMutableArray *_data1;
    NSMutableArray *_data2;
    NSMutableArray *_data3;
    NSMutableArray *_data4;
    
    NSInteger _currentData1Index;
    NSInteger _currentData2Index;
    NSInteger _currentData3Index;
    NSInteger _currentData4index;
    
    UIImageView * headview;//头像
}

@property (nonatomic, strong) UIView *naviView;
@property (nonatomic, strong) UIButton *localtionBT;
@property (nonatomic, strong) UITableView *homeTableView;
@property (nonatomic, strong) NSMutableArray *dataArr;
@property (nonatomic, strong) UIActivityIndicatorView *activityIndicatorView;
@property (nonatomic, strong) LNLocationManager *locationManager;
@property (nonatomic, strong) LNSearchManager *searchManager;
@property (nonatomic, strong) AMapLocationManager *amapLocationmanager;
@property (nonatomic, copy)NSString * latstr;
@property (nonatomic, copy)NSString * lngstr;
@property (strong,nonatomic)SDCycleScrollView *cycleScrollView;//轮播器
@property (strong,nonatomic)NSMutableArray * imageary;//轮播图图片
@property (strong,nonatomic)NSMutableArray * storeimage;//轮播图内url
@property (strong,nonatomic)NSMutableArray * urlid;//根据id加载url
@property (strong,nonatomic)NSMutableArray * titleAry;//轮播图内标题
@property (nonatomic,strong)NSMutableArray * modelary;//model数组
@property (nonatomic,strong)NSMutableArray * idary;//筛选数组
@property (nonatomic,assign)NSInteger pageint;//网络请求页数
@end
@implementation HomePageVC

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:NO];

    self.navigationController.navigationBar.hidden = YES;
//    self.navigationController.navigationBar.translucent = NO;
    self.tabBarController.tabBar.hidden = NO;
    self.naviView.hidden = NO;

    NSString * headImage = [[NSUserDefaults standardUserDefaults]objectForKey:@"headimage"];
    
    if (headImage!=nil) {
        NSArray * imageary = [headImage componentsSeparatedByString:@":"];
        NSMutableArray * imagemustary = [NSMutableArray arrayWithArray:imageary];
        [imagemustary replaceObjectAtIndex:0 withObject:@"https"];
        NSString * headImagester = [imagemustary componentsJoinedByString:@":"];
        [headview sd_setImageWithURL:[NSURL URLWithString:headImagester] placeholderImage:[UIImage imageNamed:@"1"]];
        
    }
    else{
        headview.image = [UIImage imageNamed:@"头像"];
    }
}
- (void)setUp{
    [self.locationManager startWithBlock:^{

        [self.activityIndicatorView startAnimating];
    } completionBlock:^(CLLocation *location) {
        [self.searchManager startReverseGeocode:location completeionBlock:^(LNLocationGeocoder *locationGeocoder, NSError *error) {
            if (!error) {
                [self.activityIndicatorView stopAnimating];
                NSMutableString *mutableString = [NSMutableString stringWithFormat:@"%@",locationGeocoder.city];
                NSString *title = [mutableString stringByReplacingOccurrencesOfString:@"市" withString:@""];
                [self.localtionBT setTitle:title forState:UIControlStateNormal];
                [self.localtionBT setHidden:NO];
            }
        }];
    } failure:^(CLLocation *location, NSError *error) {
        NSLog(@"%@", error);
    }];
}

- (UIActivityIndicatorView*)activityIndicatorView{
    if (_activityIndicatorView == nil) {
//        _activityIndicatorView = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(15, 15, BUTTON_HEIGHT, BUTTON_HEIGHT)];
        _activityIndicatorView.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
        _activityIndicatorView.color = [UIColor grayColor];
        _activityIndicatorView.hidesWhenStopped = YES;
    }
    return _activityIndicatorView;
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:NO];

    //    self.navigationController.navigationBar.hidden = NO;
//    self.naviView.hidden = YES;



}

-(void)endRefresh
{
    if (_pageint == 1) {
        [self.homeTableView.mj_header endRefreshing];
    }
    [self.homeTableView.mj_footer endRefreshing];
}
- (void)getData:(BOOL)isrefresh
{

    if (isrefresh) {
        _pageint = 1;
//        isFirstCome = YES;
        [_modelary removeAllObjects];
        [_imageary removeAllObjects];
        [_storeimage removeAllObjects];
        [_titleAry removeAllObjects];
        [_urlid removeAllObjects];

    }else{
        _pageint++;
    }

    _lngstr = [[NSUserDefaults standardUserDefaults]objectForKey:@"longitude"];
    _latstr = [[NSUserDefaults standardUserDefaults]objectForKey:@"latitude"];

   NSString * urlstr = [NSString stringWithFormat:@"%@/getHomeData?lat=%@&lng=%@&storePage=%ld",commonUrl,_latstr,_lngstr,_pageint];
    
    NSArray * urlary = [urlstr componentsSeparatedByString:@"?"];
    
    [MBProgressHUD showMessage:@"请稍等"];
    [[QYXNetTool shareManager] postNetWithUrl:urlary.firstObject urlBody:urlary.lastObject bodyStyle:QYXBodyString header:nil response:QYXJSON success:^(id result){
        NSLog(@">>>>>><<<<<%@",result);
        [self endRefresh];
        [MBProgressHUD hideHUD];
        
      NSString * codeStr = [NSString stringWithFormat:@"%@",[result objectForKey:@"msgType"]];
        if ([codeStr isEqualToString:@"2000"])
        {
            LoginViewController * loginview = [[LoginViewController alloc]init];
            [self.navigationController pushViewController:loginview animated:YES];
            
        }
        
        else if ([codeStr isEqualToString:@"0"])
        {
        NSDictionary * objdict = [result objectForKey:@"obj"];
        if (![objdict isNull]) {
            
            
            [_imageary removeAllObjects];
            [_storeimage removeAllObjects];
            [_titleAry removeAllObjects];
            [_urlid removeAllObjects];
            NSArray * dataary = [objdict objectForKey:@"storeData"];
            for (int i =0; i<dataary.count; i++)
            {
                SearchStoreModel * model = [SearchStoreModel mj_objectWithKeyValues:dataary[i]];
                [_modelary addObject:model];
            }
            NSArray * typeary = [objdict objectForKey:@"storeTypes"];
            NSArray * weburlAry = objdict[@"advert"];//轮播图
            if (weburlAry!=nil) {
                
                for (int i=0; i<weburlAry.count; i++) {
                    NSString * imageurl = weburlAry[i][@"adImgurl"];
                    NSString * titleStr = weburlAry[i][@"adTitle"];
                    NSString * webUrl = weburlAry[i][@"adUrl"];
                    NSString * urlid = weburlAry[i][@"id"];
                    [_imageary addObject:imageurl];
                    [_storeimage addObject:webUrl];
                    [_titleAry addObject:titleStr];
                    [_urlid addObject:urlid];
                    
                }
            }
            for (int a =0; a<typeary.count; a++) {
                
                NSDictionary * typedict = typeary[a];
                NSString * idstr = typedict[@"merchantType"];
                [_idary addObject:idstr];
            }
            
            if (_homeTableView) {
                
                [_homeTableView reloadData];
            }
            else
            {
                [self initWithHomePageTableView];
            }
        }
        }
        else if ([codeStr integerValue]==2)
        {
            [MBProgressHUD showError:@"没有店铺啦!"];
        }else{
            
            [MBProgressHUD showError:@"网络参数错误"];
        }
         
        
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUD];
        [self endRefresh];
        [MBProgressHUD showError:@"请求失败"];
    }];

}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];

            /** 设置允许后台定位参数，保持不会被系统挂起 **/
    self.amapLocationmanager = [[AMapLocationManager alloc] init];
    self.amapLocationmanager.delegate = self;
    [self.amapLocationmanager setPausesLocationUpdatesAutomatically:NO];

//    [self.amapLocationmanager setAllowsBackgroundLocationUpdates:YES];

    [self.amapLocationmanager startUpdatingLocation];


    self.dataArr = [NSMutableArray array];
    
    self.modelary = [NSMutableArray array];
    self.idary = [NSMutableArray array];
    self.imageary = [NSMutableArray array];
    self.storeimage = [NSMutableArray array];
    self.titleAry = [NSMutableArray array];
    self.urlid = [NSMutableArray array];
    [self initWithHomePageTableView];

    _pageint = 1;
//    [self getData:YES];
    __weak typeof(self) weakSelf = self;
    
    self.homeTableView.header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
    
    
    self.homeTableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        [weakSelf getData:NO];
        
    }];
   
    [self setupSearchBarView];
    
    if ([self respondsToSelector:@selector(setNeedsStatusBarAppearanceUpdate)]) {

        [self prefersStatusBarHidden];

        [self performSelector:@selector(setNeedsStatusBarAppearanceUpdate)];

    }

    [self setUp];
   
    [self.homeTableView.mj_header beginRefreshing];
    
    [self notificationOpen];
    
    
}
- (void)loadNewData
{
    [self getData:YES];
}
-(void)amapLocationManager:(AMapLocationManager *)manager didUpdateLocation:(CLLocation *)location{
    NSLog(@"location:{lat:%f; lon:%f; accuracy:%f}", location.coordinate.latitude, location.coordinate.longitude, location.horizontalAccuracy);
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:location];
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:data forKey:@"location"];
    [defaults synchronize];
    
    if (location!=nil) {
        [manager stopUpdatingLocation];
        
        [defaults setObject: [NSString stringWithFormat:@"%f",location.coordinate.latitude ]forKey:@"latitude"];
        [defaults setObject:[NSString stringWithFormat:@"%f",location.coordinate.longitude] forKey:@"longitude"];
        [defaults synchronize];
    }
}
- (BOOL)prefersStatusBarHidden
{
    return YES;
}
#pragma mark -- //创建searchbar
- (void)setupSearchBarView{


    //搜索栏视图
    self.naviView = [[UIView alloc] init];
//    //    self.navigationItem.titleView = self.naviView;
//    [self.navigationController.view addSubview:_naviView];
//    //    self.naviView.frame = CGRectMake(0, 0, self.view.bounds.size.width, 44);
//    self.naviView.sd_layout.leftSpaceToView(self.navigationController.view,5).rightSpaceToView(self.navigationController.view, 5).heightIs(40).topSpaceToView(self.navigationController.view, 10);
   
    self.naviView.backgroundColor = UIColorFromRGB(0xfd7577);
    [self.view addSubview:self.naviView];
    self.naviView.sd_layout.leftEqualToView(self.view).rightEqualToView(self.view).topEqualToView(self.view).heightIs(autoScaleH(100));
    
#pragma mark  --  //定位按钮
    _localtionBT = [UIButton buttonWithType:UIButtonTypeCustom];
    _localtionBT.frame = CGRectMake(0, 20, 70, self.naviView.frame.size.height);
    [_localtionBT setTitle:@"厦门" forState:UIControlStateNormal];
    [_localtionBT.titleLabel setFont:[UIFont systemFontOfSize:15]];
    _localtionBT.titleLabel.textAlignment = NSTextAlignmentLeft;
    [_localtionBT setImage:[UIImage imageNamed:@"icon_searchBar_arrow@2x"] forState:UIControlStateNormal];
    [_localtionBT setImage:[UIImage imageNamed:@"icon_searchBar_arrow@2x"] forState:UIControlStateSelected];
    [_localtionBT setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 20)];
    [_localtionBT setImageEdgeInsets:UIEdgeInsetsMake(0, _localtionBT.frame.size.width - 20, 0, 0)];
    [_localtionBT addTarget:self action:@selector(starSearchLocation:) forControlEvents:UIControlEventTouchUpInside];
    _localtionBT.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [self.naviView addSubview:_localtionBT];

    _localtionBT.sd_layout
    .centerXEqualToView(self.naviView)
    .topSpaceToView (self.naviView,autoScaleH(15))
    .heightIs(autoScaleH(30));
    [_localtionBT setupAutoSizeWithHorizontalPadding:3 buttonHeight:autoScaleH(30)];
#pragma mark 用户头像
    headview = [[UIImageView alloc]init];
    headview.layer.masksToBounds = YES;
    headview.layer.cornerRadius = autoScaleW(20);
    [self.naviView addSubview:headview];
    headview.sd_layout.leftSpaceToView(self.naviView,autoScaleW(10)).topSpaceToView(self.naviView,autoScaleH(15)).widthIs(autoScaleW(40)).heightIs(autoScaleW(40));
    headview.userInteractionEnabled = YES;
    UITapGestureRecognizer * tap1 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(Mine)];
    [headview addGestureRecognizer:tap1];


#pragma mark --    //创建消息按钮
    UIButton *scanButton = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *buttonImage = [UIImage  imageNamed:@"消息-1"];
    [scanButton setBackgroundImage:buttonImage forState:UIControlStateNormal];
//    scanButton.imageView.contentMode = UIViewContentModeScaleAspectFit;
//    UIImage *stretchableButtonImage = [buttonImage  stretchableImageWithLeftCapWidth:0  topCapHeight:0];
//    [scanButton  setBackgroundImage:stretchableButtonImage  forState:UIControlStateNormal];
//    [scanButton imageRectForContentRect:scanButton.frame];
    [scanButton addTarget:self action:@selector(scanButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.naviView addSubview:scanButton];
    scanButton.sd_layout
    .rightSpaceToView(self.naviView, 20)
    .topEqualToView(_localtionBT)
    .widthIs(25)
    .heightIs(20);
   

#pragma mark  --  //创建搜索框
    UIButton *searchBarView = [UIButton buttonWithType:UIButtonTypeCustom];
    searchBarView.backgroundColor = [UIColor whiteColor];
    searchBarView.frame = CGRectMake(_localtionBT.frame.size.width + 5, _localtionBT.frame.origin.y, self.naviView.frame.size.width - _localtionBT.frame.size.width * 2, self.naviView.frame.size.height);
    
    [searchBarView setImage:[UIImage imageNamed:@"icon_search"] forState:UIControlStateNormal];
    searchBarView.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, autoScaleW(65));
    
    [searchBarView setTitle:@"请输入商家或者菜品名称" forState:UIControlStateNormal];
    [searchBarView setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [searchBarView addTarget:self action:@selector(seachBarAction:) forControlEvents:UIControlEventTouchUpInside];
    
    searchBarView.titleEdgeInsets = UIEdgeInsetsMake(0, -5, 0, 0);
    searchBarView.titleLabel.textColor = [UIColor colorWithRed:0.1651 green:0.1651 blue:0.1651 alpha:1.0];
    searchBarView.titleLabel.font = [UIFont systemFontOfSize:13];
    searchBarView.layer.borderWidth = 1.0f;
    searchBarView.layer.borderColor = [UIColor whiteColor].CGColor;
    searchBarView.layer.cornerRadius = searchBarView.frame.size.height / 8;
    [self.naviView addSubview:searchBarView];
    searchBarView.sd_layout
    .leftSpaceToView(self.naviView, 15)
    .rightSpaceToView(self.naviView, 15)
    .bottomSpaceToView(self.naviView, 10)
    .heightIs(autoScaleH(30));
    
}
#pragma mark 头像手势
-(void)Mine
{
    if ([[NSUserDefaults standardUserDefaults]objectForKey:@"token"] !=nil) {
    
    MinePageVC * mineview = [[MinePageVC alloc]init];
    [self.navigationController pushViewController:mineview animated:YES];
    }else{
        
        LoginViewController * loginview = [[LoginViewController alloc]init];
        [self.navigationController pushViewController:loginview animated:YES];

    }
    
}


- (void)seachBarAction:(UIButton *)sender{

    
    self.naviView.hidden = YES;
    
    SearchViewController *searchVC  = [[SearchViewController alloc] init];
    searchVC.latstr = _latstr;
    searchVC.lngstr = _lngstr;
    [self.navigationController pushViewController:searchVC animated:YES];
    
}
//定位按钮
- (void)starSearchLocation:(UIButton *)sender{

//    PickerViewController *addressPickerDemo = [[PickerViewController alloc] init];
//
//    self.navigationController.navigationBar.hidden = NO;
//
//    self.naviView.hidden = YES;
//
//    [self.navigationController pushViewController:addressPickerDemo animated:YES];
    
    [MBProgressHUD showError:@"暂未开启此功能哦，只限厦门"];
}
//点击扫描
-(void)scanButtonClick:(UIButton *)sender{

      [MBProgressHUD showError:@"暂未开启此功能哦"];

}
#pragma mark -- //初始化首页tableView
- (void)initWithHomePageTableView{
    _homeTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 100, self.view.frame.size.width, self.view.frame.size.height) style:UITableViewStylePlain];
    _homeTableView.backgroundColor = [UIColor whiteColor];
    _homeTableView.dataSource = self;
    _homeTableView.delegate = self;
    _homeTableView.showsVerticalScrollIndicator = NO;//滑动线隐藏
//    _homeTableView.separatorStyle = 0;
    _homeTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [_homeTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    [_homeTableView registerClass:[UITableViewHeaderFooterView class] forHeaderFooterViewReuseIdentifier:@"headerView"];

    //    设置当you导航栏自动添加64的高度的属性为NO
    self.automaticallyAdjustsScrollViewInsets = NO;


    [self.view addSubview:_homeTableView];

    self.homeTableView.sd_layout.leftSpaceToView(self.view, 0).topSpaceToView(self.view, autoScaleH(100)).rightEqualToView(self.view).bottomSpaceToView(self.view, 49);

}
//tableView协议方法
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return autoScaleH(270);
    }
    return autoScaleH(30);
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    if (section == 0) {

        //建立首页展示头视图
        UIView *backView = [[UIView alloc] init];
 
        Btnscrollerview * btnscroller = [[Btnscrollerview alloc]initWithint:8];
        btnscroller.showsVerticalScrollIndicator = FALSE;
        btnscroller.showsHorizontalScrollIndicator = FALSE;
        btnscroller.block = ^(NSInteger btnint)
        {
            NSString * idstr = _idary[btnint];
            SearchViewController * searchVc = [[SearchViewController alloc]init];
            searchVc.typestr = idstr;
            searchVc.latstr = _latstr;
            searchVc.lngstr = _lngstr;
            searchVc.pushinteger = 2;
            [self.navigationController pushViewController:searchVc animated:YES];
            
        };
        btnscroller.contentSize = CGSizeMake(GetWidth*2, 0);
        [backView addSubview:btnscroller];
        btnscroller.sd_layout.leftEqualToView(backView).topEqualToView(backView).rightEqualToView(backView).heightIs(autoScaleH(110));
        
        
        CGRect rect = CGRectMake(0, autoScaleH(120), self.view.bounds.size.width, autoScaleH(140));
        self.cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:rect imageURLStringsGroup:nil];
        self.cycleScrollView.showPageControl = YES;
        self.cycleScrollView.pageControlAliment= SDCycleScrollViewPageContolAlimentCenter;
        self.cycleScrollView.imageURLStringsGroup = [self.imageary copy];
        self.cycleScrollView.placeholderImage = [UIImage imageNamed:@"6"];
        self.cycleScrollView.currentPageDotColor = RGB(234, 158, 56);
        self.cycleScrollView.pageDotColor = [UIColor whiteColor];
        self.cycleScrollView.clickItemOperationBlock = ^ (NSInteger itemint)
        {
            if (_titleAry.count!=0) {
                
                SdycViewController * sdycview = [[SdycViewController alloc]init];
                sdycview.titleStr = _titleAry[[_urlid[itemint] integerValue]-1];
                sdycview.urlStr = _storeimage[[_urlid[itemint] integerValue]-1];
                [self.navigationController pushViewController:sdycview animated:YES];
            }else{
                
                [MBProgressHUD showError:@"网络加载错误"];
            }
           
        };
        [backView addSubview:self.cycleScrollView];
        
//        StoreScrollview * storeview = [[StoreScrollview alloc]initWithary:_storeimage];
//        storeview.showsHorizontalScrollIndicator = NO;
//        storeview.contentSize = CGSizeMake(GetWidth *3, 0);
//        storeview.contentOffset = CGPointMake(0 ,0);
//        storeview.pagingEnabled = YES;
//        storeview.layer.borderWidth = 1;
//        storeview.layer.borderColor = [UIColor lightGrayColor].CGColor;
//        [backView addSubview:storeview];
//        storeview.sd_layout.leftEqualToView(backView).rightEqualToView(backView).topSpaceToView(backView,autoScaleH(270)).heightIs(autoScaleH(120));
        
        return backView;

    }
        else {
//
        UIView * chooseview = [[UIView alloc]init];
        chooseview.backgroundColor = [UIColor whiteColor];
            
            UILabel * secheadlabel = [[UILabel alloc]init];
            secheadlabel.text = @"推荐商家";
            secheadlabel.font = [UIFont systemFontOfSize:13];
            secheadlabel.textColor = [UIColor lightGrayColor];
            [chooseview addSubview:secheadlabel];
            secheadlabel.sd_layout.leftSpaceToView(chooseview,autoScaleW(15)).topSpaceToView(chooseview,autoScaleH(7)).widthIs(60).heightIs(15);
            
            UILabel * linelabel = [[UILabel alloc]init];
            linelabel.backgroundColor = UIColorFromRGB(0xeeeeee);
            [chooseview addSubview:linelabel];
            linelabel.sd_layout.leftEqualToView(chooseview).rightEqualToView(chooseview).bottomEqualToView(chooseview).heightIs(1);
       return chooseview;
    
    }
}

#pragma mark --  //设置点击商家列表响应
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section==1) {
        if (_modelary.count!=0) {
            
            SearchStoreModel * model = _modelary[indexPath.row];
            NewMerchantVC *vc = [[NewMerchantVC alloc] init];
            vc.model = model;
            vc.idstr = model.storeId;
            vc.titlestr = model.storeName;
            [self.navigationController pushViewController:vc animated:YES];
        }else{
            [MBProgressHUD showError:@"网络加载错误"];
        }
      
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 0;
    }
    
    return _modelary.count;
}
//设置cell高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
//    if (indexPath.section==0) {
//        
//        return 120;
//    }
    
    if (indexPath.section==1) {
        
          return [tableView cellHeightForIndexPath:indexPath cellContentViewWidth:[self cellContentViewWith] tableView:tableView];
    }
    return 0;
    
}
- (CGFloat)cellContentViewWith
{
    CGFloat width = [UIScreen mainScreen].bounds.size.width;

    // 适配ios7横屏
    if ([UIApplication sharedApplication].statusBarOrientation != UIInterfaceOrientationPortrait && [[UIDevice currentDevice].systemVersion floatValue] < 8) {
        width = [UIScreen mainScreen].bounds.size.height;
    }
    return width;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSString *str = [NSString stringWithFormat:@"%ld-%ld", indexPath.row, indexPath.section];
    HomeTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:str];
    if (!cell) {
        
        cell = [[HomeTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:str];
    }
    
    cell.selectionStyle = 0;
    if (_latstr==nil) {
        
        cell.distancelabel.text = @"未开启定位";
    }
    
    UILabel * linelabel = [[UILabel alloc]init];
    linelabel.backgroundColor = UIColorFromRGB(0xe4e4e4);
    [cell addSubview:linelabel];
    linelabel.sd_layout.leftEqualToView(cell).rightEqualToView(cell).bottomEqualToView(cell).heightIs(10);
    
    
    if (indexPath.section==1) {
        if (_modelary.count!=0) {
            
            cell.model = _modelary[indexPath.row];

        }
    }
    
    
    return cell;
    
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat sectionHeaderHeight = autoScaleH(60);
    if (scrollView.contentOffset.y<=sectionHeaderHeight&&scrollView.contentOffset.y>=0) {
        scrollView.contentInset = UIEdgeInsetsMake(-scrollView.contentOffset.y, 0, 0, 0);
    } else if (scrollView.contentOffset.y>=sectionHeaderHeight) {
        scrollView.contentInset = UIEdgeInsetsMake(-sectionHeaderHeight, 0, 0, 0);
    }
}


#pragma mark ---------------------------mebu button delegate ----------------------------------------
#pragma mark ---------------------------mebu button delegate----------------------------------------
#pragma mark 查看通知是否开启
- (void)notificationOpen{
        //通知是否开启
    if ([[NSUserDefaults standardUserDefaults]objectForKey:@"token"] !=nil) {
        
        DeviceSet * device = [[DeviceSet alloc]init];
        if ([device isAllowedNotification]==NO) {
            
            UIAlertController * alertView = [UIAlertController alertControllerWithTitle:nil message:@"您未开启通知，是否开启便于接受商家消息" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction * cancelAction = [UIAlertAction actionWithTitle:@"偏不" style:UIAlertActionStyleCancel handler:nil];
            UIAlertAction * okAction = [UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                
                NSURL * url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
                
                if([[UIApplication sharedApplication] canOpenURL:url]) {
                    
                    NSURL*url =[NSURL URLWithString:UIApplicationOpenSettingsURLString];           [[UIApplication sharedApplication] openURL:url];
                    
                }
                
            }];
            
            [alertView addAction:cancelAction];
            [alertView addAction:okAction];
            
            [self presentViewController:alertView animated:YES completion:nil];
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
