//
//  BrowseViewController.m
//  WDKKtest
//
//  Created by 张森森 on 16/8/5.
//  Copyright © 2016年 weiDianKuaiKe. All rights reserved.
//

#import "BrowseViewController.h"
#import "UIBarButtonItem+SSExtension.h"
#import "MBProgressHUD+SS.h"
#import "QYXNetTool.h"
#import "NSObject+JudgeNull.h"
#import <CoreLocation/CoreLocation.h>
#import "BrowTableViewCell.h"
#import "Browmodel.h"
#import "MJRefresh.h"
#import "MJRefreshNormalHeader.h"
#import "MJRefreshAutoNormalFooter.h"
#import "NewMerchantVC.h"
@interface BrowseViewController ()<CLLocationManagerDelegate,UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) CLLocationManager * locationManager;
@property (nonatomic,copy) NSString * lngstr;
@property (nonatomic,copy) NSString * latstr;
@property (nonatomic,strong)NSMutableArray * browary;
@property (nonatomic,strong)UITableView * browtableview;
@property (nonatomic,assign)NSInteger pageint;//网络请求页数

@end

@implementation BrowseViewController
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = NO;
    self.navigationController.navigationBar.translucent = NO;
    [self.navigationController.navigationBar setBarTintColor:UIColorFromRGB(0xfd7577)];
    self.tabBarController.tabBar.hidden = YES;

}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.view.backgroundColor = RGB(238, 238, 238);
    UILabel * titlabel = [[UILabel alloc]init];
    titlabel.frame = CGRectMake(0, 0, 80, 30);
    titlabel.textAlignment = NSTextAlignmentCenter;
    titlabel.font = [UIFont systemFontOfSize:15];
    titlabel.text = @"最近浏览";
    titlabel.textColor = [UIColor whiteColor];
    self.navigationItem.titleView = titlabel;
    UIBarButtonItem * backbtn = [UIBarButtonItem itemWithTarget:self Action:@selector(Back) image:@"left-1" selectImage:nil];
    self.navigationItem.leftBarButtonItem = backbtn;
    
    _browary = [NSMutableArray array];
    
    _pageint = 1;
    [self Creattable];    
    __weak typeof(self) weakSelf = self;
    
    self.browtableview.header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
    
    
    self.browtableview.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        [weakSelf Getqingqiu:NO];
    }];
    [self.browtableview.mj_header beginRefreshing];

}
- (void)loadNewData
{
    [self Getqingqiu:YES];
}
-(void)endRefresh
{
    if (_pageint == 1) {
        [self.browtableview.mj_header endRefreshing];
    }
    [self.browtableview.mj_footer endRefreshing];
}
#pragma mark 网络请求
-(void)Getqingqiu:(BOOL)isrefresh
{
    if (isrefresh) {
        _pageint = 1;
        [_browary removeAllObjects];
        
    }else{
        _pageint++;
    }
    
    
    _lngstr = [[NSUserDefaults standardUserDefaults]objectForKey:@"longitude"];
    _latstr = [[NSUserDefaults standardUserDefaults]objectForKey:@"latitude"];
    
    NSString * urlstr = [NSString stringWithFormat:@"%@/api/user/userVisitingManage?token=%@&userId=%@&lng=%@&lat=%@&pageNum=%d",commonUrl,Token,Userid,_lngstr,_latstr,_pageint];
    NSArray * ulary = [urlstr componentsSeparatedByString:@"?"];
    
    [MBProgressHUD showMessage:@"请稍等"];
    [[QYXNetTool shareManager] postNetWithUrl:ulary.firstObject urlBody:ulary.lastObject bodyStyle:QYXBodyString header:nil response:QYXJSON success:^(id result){
     
         
         [MBProgressHUD hideHUD];
        [self endRefresh];

        NSLog(@">>><<<<>>>%@",result);
        
       
        NSString * msgType = [NSString stringWithFormat:@"%@",result[@"msgType"]];
         if (![[result objectForKey:@"obj"] isNull]) {
             
             NSInteger flag = [result[@"flag"] integerValue];
             
             if (_pageint>=flag-1) {
                 
                 self.browtableview.mj_footer.hidden = YES;
             }
             NSArray * browary = [result objectForKey:@"obj"];
             for (int i =0; i<browary.count; i++) {
                 
                 Browmodel * model = [[Browmodel alloc]initWithgetstrwithdict:browary[i]];
                 [_browary addObject:model];
             }
             if (_browtableview) {
                 
                 [_browtableview reloadData];
             }
             else
             {
                 [self Creattable];
             }
         }
        
         else if ([msgType isEqualToString:@"2"]){
             
                 [MBProgressHUD showError:@"您最近暂无浏览记录"];
                 [self Creatimge];
         }
         
     } failure:^(NSError *error)
     {
         [MBProgressHUD hideHUD];
         [self endRefresh];

         [MBProgressHUD showError:@"网络参数错误"];
     }];

}
#pragma  mark 猫
-(void)Creatimge
{
    UIImageView * catimage = [[UIImageView alloc]init];
    catimage.image = [UIImage imageNamed:@"暂无数据"];
    [self.view addSubview:catimage];
    catimage.sd_layout.centerXEqualToView(self.view).centerYEqualToView(self.view).widthIs(autoScaleW(200)).heightIs(autoScaleH(200));
    
    
}
#pragma mark 创建表
-(void)Creattable
{
    _browtableview = [[UITableView alloc]init];
    _browtableview.delegate = self;
    _browtableview.dataSource = self;
    _browtableview.frame = self.view.bounds;
    _browtableview.showsVerticalScrollIndicator = NO;
    _browtableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_browtableview];
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return _browary.count;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    BrowTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"brow"];
    if (!cell) {
       
        cell = [[BrowTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"brow"];
    }
    cell.selectionStyle = 0;
    UILabel * linelabel = [[UILabel alloc]init];
    linelabel.backgroundColor = UIColorFromRGB(0xeeeeee);
    [cell addSubview:linelabel];
    linelabel.sd_layout.leftEqualToView(cell).rightEqualToView(cell).bottomEqualToView(cell).heightIs(1);
    
    cell.model = _browary [indexPath.row];
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 110;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    Browmodel * model = _browary[indexPath.row];
    
    NewMerchantVC * storeDetail = [[NewMerchantVC alloc]init];
    storeDetail.idstr = model.storeidstr;
    [self.navigationController pushViewController:storeDetail animated:YES];
    
    
}
-(void)Back
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
