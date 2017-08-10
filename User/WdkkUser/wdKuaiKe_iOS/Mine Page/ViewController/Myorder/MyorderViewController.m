//
//  MyorderViewController.m
//  WDKKtest
//
//  Created by 张森森 on 16/8/4.
//  Copyright © 2016年 weiDianKuaiKe. All rights reserved.
//

#import "MyorderViewController.h"
#import "UIBarButtonItem+SSExtension.h"
#import "LLHConst.h"
#import "MyorderTableViewCell.h"
#import "MBProgressHUD+SS.h"
#import "QYXNetTool.h"
#import "NSObject+JudgeNull.h"
#import "Myordermodel.h"
#import "LoginViewController.h"
#import "OrderdetailViewController.h"
#import "JudgeViewController.h"
#import "ImagepickerViewController.h"
#import "MJRefreshNormalHeader.h"
#import "MJRefreshAutoNormalFooter.h"
#import "PayViewController.h"
#import "NewMerchantVC.h"
#import "DineserveViewController.h"
#import "QRViewController.h"
@interface MyorderViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    UIButton * _clickBtn;
    UIImageView * orderomage;
}
//@property(nonatomic,strong)NSArray * imageAry ;
//@property(nonatomic,strong)NSArray * labelAry;
//@property(nonatomic,strong)NSArray * seleimageary;
@property(nonatomic,strong)UIImageView * navigationview;
@property (nonatomic,strong)UILabel * linelabell;
@property (nonatomic,strong)UIButton * daitibtn;
@property (nonatomic,assign)CGFloat height;
@property (nonatomic,strong)UITableView * ordertable;
@property (nonatomic,assign)NSInteger typeint;
@property (nonatomic,strong)NSMutableArray * modelary;
@property (nonatomic,copy)NSString * typestr;
@property (nonatomic,assign)NSInteger pagenum;//网络请求页数
@property (nonatomic,assign)BOOL change;//判断是否清除订单数组数据。上拉加载不清除
@property (nonatomic,strong)DineserveViewController * dineserview;

@end

@implementation MyorderViewController

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBar.translucent = NO;

    self.navigationController.navigationBar.barTintColor = UIColorFromRGB(0xfd7577);
    self.navigationController.navigationBar.hidden = NO;
    self.tabBarController.tabBar.hidden = NO;
    [self.ordertable.mj_header beginRefreshing];

}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColorFromRGB(0xffffff);
    self.title = @"我的订单";
    _change = NO;
    _typeint = 1;
    CGFloat height = [[UIApplication sharedApplication] statusBarFrame].size.height + self.navigationController.navigationBar.frame.size.height;
    //导航栏
    UIBarButtonItem * backBar = [UIBarButtonItem itemWithTarget:self Action:@selector(Back) image:@"形状" selectImage:nil];
    
    self.navigationItem.leftBarButtonItem =backBar;
    UILabel * titlabel = [[UILabel alloc]init];
    titlabel.frame = CGRectMake(0, 0, 80, 30);
    titlabel.textAlignment = NSTextAlignmentCenter;
    titlabel.font = [UIFont systemFontOfSize:15];
    titlabel.text = @"我的订单";
    titlabel.textColor = [UIColor whiteColor];
    self.navigationItem.titleView = titlabel;
    
//    _height = [[UIApplication sharedApplication] statusBarFrame].size.height + self.navigationController.navigationBar.frame.size.height;
     
    NSArray * choosetitle = @[@"全部订单",@"待评价",@"有退款",];
    for (int i=0; i<choosetitle.count; i++) {
        UIButton * choosebtn = [[UIButton alloc]init];
        choosebtn.titleLabel.font = [UIFont systemFontOfSize:autoScaleW(15)];
        [choosebtn setTitle:choosetitle[i] forState:UIControlStateNormal];
        [choosebtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        [choosebtn setTitleColor:UIColorFromRGB(0xfd7577) forState:UIControlStateSelected];
        [choosebtn setBackgroundColor:[UIColor clearColor]];
        choosebtn.tag = 300+i;
        [choosebtn addTarget:self action:@selector(Choose:) forControlEvents:UIControlEventTouchUpInside];
        
        UILabel * linelabel = [[UILabel alloc]init];
        linelabel.backgroundColor = UIColorFromRGB(0xeeeeee);
        [choosebtn addSubview:linelabel];
        linelabel.sd_layout.leftSpaceToView(choosebtn,0).bottomEqualToView(choosebtn).widthIs(GetWidth/3-autoScaleW(30)).heightIs(1);
        
        if (i==0||i==1) {
            
            UILabel * linelabel = [[UILabel alloc]init];
            linelabel.backgroundColor = UIColorFromRGB(0xeeeeee);
            [choosebtn addSubview:linelabel];
            linelabel.sd_layout.rightSpaceToView(choosebtn,0).topSpaceToView(choosebtn,autoScaleH(2)).widthIs(1).heightIs(26);
            
        }
        if (i==0) {
            choosebtn.selected = YES;
            _daitibtn = choosebtn;
        }
        [self.view addSubview:choosebtn];
        choosebtn.sd_layout.leftSpaceToView(self.view,+i*(GetWidth/3)).topSpaceToView(self.view,autoScaleH(5)).widthIs(GetWidth/3).heightIs(autoScaleH(50));
    }
    
    _linelabell = [[UILabel alloc]init];
    _linelabell.backgroundColor = UIColorFromRGB(0xfd7577);
    _linelabell.frame = CGRectMake(autoScaleW(15), _height+autoScaleH(45), GetWidth/3-autoScaleW(30), 1.5);
    [self.view addSubview:_linelabell];
    
    [self CreatTable];
    self.ordertable.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self CreatAf:YES];
    }];
    
    self.ordertable.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        [self CreatAf:NO];
        
    }];
    
    _modelary = [NSMutableArray array];
    
    _pagenum = 1;
    _typestr = @"0";
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(orderTypeChange) name:@"xgpush" object:nil];

    
}
- (void)reload {
    
     [self.ordertable.mj_header beginRefreshing];
    
}
- (void)endRefresh
{
    
    if (_pagenum == 1) {
        
        [self.ordertable.mj_header endRefreshing];
    }
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           
    [self.ordertable.mj_footer endRefreshing];
}
#pragma mark 创建表
-(void)CreatAf:(BOOL)isrefresh
{
    
    if (isrefresh) {
        _pagenum = 1;
        self.ordertable.mj_footer.hidden = NO;
        [_modelary removeAllObjects];

    }
    else
    {
        _pagenum ++;
        _change = NO;
        
    }
    
    [MBProgressHUD showMessage:@"请稍等"];
    NSString * urlstr = [NSString stringWithFormat:@"%@/api/user/myOrderManage?token=%@&userId=%@&pageNum=%ld&type=%@&operation=0",commonUrl,Token,Userid,_pagenum,_typestr];
    NSArray * urlary = [urlstr componentsSeparatedByString:@"?"];
    [[QYXNetTool shareManager]postNetWithUrl:urlary.firstObject urlBody:urlary.lastObject bodyStyle:QYXBodyString header:nil response:QYXJSON success:^(id result) 
     {
         NSLog(@">>>%@",result);
         [MBProgressHUD hideHUD];
         [self endRefresh];
         
         NSString * codestr = [NSString stringWithFormat:@"%@",[result objectForKey:@"msgType"]];
         if ([codestr isEqualToString:@"2000"])
         {
             LoginViewController * loginview = [[LoginViewController alloc]init];
             [self.navigationController pushViewController:loginview animated:YES];
             
         }
         else
         {
             NSString * msgtype = [NSString stringWithFormat:[result objectForKey:@"msgType"]];

            if (![[result objectForKey:@"obj"] isNull]||[msgtype isEqualToString:@"0"])
           {
             if (_change==YES) {
                 
                 [_modelary removeAllObjects];

             }
               NSDictionary * objdict = [result objectForKey:@"obj"];

             NSArray * dataary = [objdict objectForKey:@"list"];
             for (int i= 0; i<dataary.count; i++) {
                 
                 Myordermodel * model = [[Myordermodel alloc]initWithgetsomethingwithdict:dataary[i]];
                 [_modelary addObject:model];
             }
             
             if (_ordertable)
             {
                 [_ordertable reloadData];
             }
             else
             {
               [self CreatTable];
             }
             
           }else{
               if([msgtype isEqualToString:@"2"]){
                   
                   [MBProgressHUD showSuccess:@"暂无订单"];
                   _ordertable.mj_footer.hidden = YES;
                   
               }else if ([msgtype isEqualToString:@"1"]){
               [MBProgressHUD showError:@"请求失败"];
               }
               
               [_modelary removeAllObjects];
               
               if (_ordertable)
               {
                   [_ordertable reloadData];
               }
               else
               {
                   [self CreatTable];
               }
           }
             
         }
         
     } failure:^(NSError *error)
     {
         [MBProgressHUD hideHUD];
         [MBProgressHUD showError:@"网络错误"];
         
         [self endRefresh];                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                 
         
         
     }];
    
}
- (void)orderTypeChange{
    if ([self isCurrentViewControllerVisible:self]==YES) {
        [self CreatAf:YES];
        
    }
}
-(void)Choose:(UIButton * )btn
{
    _daitibtn.selected = NO;
    btn.selected = YES;
    
    _daitibtn = btn;
    _change = YES;
    
    if (btn.tag==300) {
        _linelabell.frame = CGRectMake(autoScaleW(15), _height+autoScaleH(45), GetWidth/3-autoScaleW(30), 1.5);
        
       _typestr = @"0";
        
        [self CreatAf:YES];
    }
    if (btn.tag==301) {
        
        _linelabell.frame = CGRectMake(GetWidth/3+autoScaleW(15), _height+autoScaleH(45), GetWidth/3-autoScaleW(30), 1.5);
        
        _typeint = 2;
        _typestr = @"1";
        
        [self CreatAf:YES];
        
    }
    if (btn.tag==302) {
        
        _linelabell.frame = CGRectMake(GetWidth/3*2+autoScaleW(15), _height+autoScaleH(45), GetWidth/3-autoScaleW(30), 1.5);
        
        _typeint = 3;
       _typestr = @"2";
        [self CreatAf:YES];
        
    }
}
#pragma mark 创建表
- (void)CreatTable
{
    _ordertable = [[UITableView alloc]init];
    _ordertable.separatorStyle = UITableViewCellSeparatorStyleNone;
    _ordertable.showsVerticalScrollIndicator = NO;
    _ordertable.delegate = self;
    _ordertable.dataSource = self;
    _ordertable.backgroundColor = RGB(242, 242, 242);
    [_ordertable registerClass:[MyorderTableViewCell class] forCellReuseIdentifier:@"order"];
    [self.view addSubview:_ordertable];
    _ordertable.sd_layout.leftSpaceToView(self.view,0).topSpaceToView(self.view,autoScaleH(50)).rightSpaceToView(self.view,0).heightIs(self.view.frame.size.height-autoScaleH(154));
}

#pragma mark  表数据源方法
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _modelary.count;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{ 
    NSString *str = [NSString stringWithFormat:@"%ld-%ld", indexPath.section, indexPath.row];
    MyorderTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:str];
    if (!cell) {
        
        cell = [[MyorderTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:str];
    }
    cell.index = indexPath.row;
    cell.selectionStyle = 0;
    cell.model = _modelary [indexPath.section];
    cell.btn.tag = indexPath.section + 500;

    cell.block = ^(NSString * endstr){
      
        if ([endstr isEqualToString:@"reload"]) {
            
            [self CreatAf:YES];
            
        }else if ([endstr isEqualToString:@"click"]){
            
            [self Click:cell.btn];
        }
    };
    return cell;
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return autoScaleH(10);
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headerView = [[UIView alloc] init];
    headerView.backgroundColor = [UIColor clearColor];
    return headerView;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 150;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    Myordermodel * model = _modelary[indexPath.section];
    OrderdetailViewController * orderdetailview = [[OrderdetailViewController alloc]init];
    orderdetailview.model = model;
    orderdetailview.orderId = model.orderid;
    [self.navigationController pushViewController:orderdetailview animated:YES];
    
}
#pragma mark cell上按钮方法
-(void)Click:(UIButton*)btn
{
    
    Myordermodel * model = _modelary[btn.tag-500];
    if ([model.ordertype isEqualToString:@"19"])
    {
        
        if ([model.moneystr floatValue]==0) {
            NewMerchantVC * storeDetail = [[NewMerchantVC alloc]init];
            storeDetail.idstr = [NSString stringWithFormat:@"%@",model.storeid];
            storeDetail.titlestr = model.storename;
            [self.navigationController pushViewController:storeDetail animated:YES];
            
        }else{
           
            JudgeViewController * judeview = [[JudgeViewController alloc]init];
            judeview.model = model;
            judeview.orderId = model.orderid;
            [self.navigationController pushViewController:judeview animated:YES];
        }
        
    }else if ([model.ordertype isEqualToString:@"0"])
    {
        if ([model.disorderType integerValue]==1&&[model.moneystr floatValue]==0) {
            
            if (!_dineserview) {
                
                _dineserview = [[DineserveViewController alloc]init];
                _dineserview.orderid = model.orderid;
                _dineserview.storeid = model.storeid;
                
            }
            [self.navigationController pushViewController:_dineserview animated:YES];
        }else{
            PayViewController * payview = [[PayViewController alloc]init];
            payview.orderid = model.orderid;
            payview.storeid = model.storeid;
            if ([model.disorderType integerValue]==1&&[model.moneystr floatValue]>=0) {
                payview.pushint = 1;//从加菜回到列表 再去支付是 不用倒计时订单编号要变
            }
            else if ([model.disorderType integerValue]==0){
            payview.pushint = 0;
            }
            [self.navigationController pushViewController:payview animated:YES];
        }
    }
   else if ([model.ordertype isEqualToString:@"4"]||[model.ordertype isEqualToString:@"14"]){
        
        QRViewController * qrview = [[QRViewController alloc]init];
        qrview.orderid = model.orderid;
        qrview.pushint = 2;
        qrview.operation = @"0";
        [self.navigationController pushViewController:qrview animated:YES];
    
    }else if ([model.ordertype isEqualToString:@"18"]){
        if (!_dineserview) {
            
            _dineserview = [[DineserveViewController alloc]init];
            _dineserview.orderid = model.orderid;
            _dineserview.storeid = model.storeid;

        }
        [self.navigationController pushViewController:_dineserview animated:YES];
    }
    else{
        
        NewMerchantVC * storeDetail = [[NewMerchantVC alloc]init];
        storeDetail.idstr = [NSString stringWithFormat:@"%@",model.storeid];
        storeDetail.titlestr = model.storename;
        [self.navigationController pushViewController:storeDetail animated:YES];
        
    }
    
    
}

#pragma mark 返回按钮回调
-(void)Back
{
    
    [self.navigationController popViewControllerAnimated:YES];
    
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
