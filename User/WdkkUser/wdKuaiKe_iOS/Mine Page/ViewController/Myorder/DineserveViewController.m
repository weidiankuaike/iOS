//
//  DineserveViewController.m
//  wdKuaiKe_iOS
//
//  Created by 张森森 on 17/1/3.
//  Copyright © 2017年 weiDianKuaiKe. All rights reserved.
//
#import "DineserveViewController.h"
#import "UIBarButtonItem+SSExtension.h"
#import "MBProgressHUD+SS.h"
#import "QYXNetTool.h"
#import "NSObject+JudgeNull.h"
#import "HasDineViewController.h"
#import "CircularProgressBar.h"
#import "ZTAlertSheetView.h"
#import "NewMerchantVC.h"
#import "AddOrderViewController.h"
#import "PayViewController.h"
#import "MyorderViewController.h"
#import "AppDelegate.h"
@interface DineserveViewController ()<CircularProgressDelegate>
@property (nonatomic,strong)UIScrollView * orderscroll;//服务滑动图
@property (nonatomic,strong)UILabel * titlelabel;
@property (nonatomic,strong)NSMutableArray * serveary;//获取服务的数组
@property (nonatomic,copy)NSString * moneystr;//加菜的金额
@property (nonatomic,copy)NSString * isservice;//商家是否开启现场服务
@property (nonatomic,strong)CircularProgressBar * m_circularProgressBar;//呼叫服务后的倒计时进度条
@property (nonatomic,assign)NSInteger serviceint;//呼叫服务接口要用的服务标识
@property (nonatomic,copy)NSString * feeStr;//判断是否加餐的金额
@property (nonatomic,copy)NSString * secondOrderid;//新的id
@property (nonatomic,copy)NSString * timerStr;//倒计时时间
@end

@implementation DineserveViewController
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
    titlabel.text = @"用餐服务";
    titlabel.textColor = [UIColor whiteColor];
    self.navigationItem.titleView = titlabel;
    UIBarButtonItem * backbtn = [UIBarButtonItem itemWithTarget:self Action:@selector(Back) image:@"left-1" selectImage:nil];
    self.navigationItem.leftBarButtonItem = backbtn;
    
//    UIBarButtonItem * rightbtn = [UIBarButtonItem itemWithTarget:self Action:@selector(Paythebill) andTitle:@"买单"];
//    self.navigationItem.rightBarButtonItem = rightbtn;

    NSLog(@"<>NM%@",_orderid);
    _serveary = [NSMutableArray array];
    [self Getaf];
   
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(overChange:) name:@"over" object:nil];
}
#pragma mark 获取服务
-(void)Getaf
{
    NSString * urlstr = [NSString stringWithFormat:@"%@/api/user/getServicePageMsg?&token=%@&storeId=%@&orderId=%@",commonUrl,Token,_storeid,_orderid];
    [MBProgressHUD showMessage:@"请稍等"];
    NSArray * urlary = [urlstr componentsSeparatedByString:@"?"];
    
    [[QYXNetTool shareManager]postNetWithUrl:urlary.firstObject urlBody:urlary.lastObject bodyStyle:QYXBodyString header:nil response:QYXJSON success:^(id result)
    {
        NSLog(@"<><><%@",result);
        [MBProgressHUD hideHUD];
        if (![[result objectForKey:@"obj"]isNull])
        {
            NSDictionary * objdict = [result objectForKey:@"obj"];
            NSString * isser = [NSString stringWithFormat:@"%@",[objdict objectForKey:@"isService"]];
            
            if ([isser isEqualToString:@"1"]) {
                
            NSArray * serviceary = [objdict objectForKey:@"offerService"];
            for (int i =0; i<serviceary.count; i++)
            {
                NSString * servicestr = serviceary[i];
                [_serveary addObject:servicestr];
                
            }
  
            }
            _isservice = isser;
            if (!_orderscroll) {
                
                [self Creatscroll];

            }
            
        }
        
    }
      failure:^(NSError *error)
    {
        [MBProgressHUD hideHUD];
        [MBProgressHUD showError:@"网络错误"];
        
        
    }];
    
}
-(void)Creatscroll
{
    
    _orderscroll = [[UIScrollView alloc]init];
    _orderscroll.contentSize = CGSizeMake(0, autoScaleH(150)+(GetWidth-autoScaleH(260))/2+_serveary.count/3*autoScaleH(100)+autoScaleH(75));
    _orderscroll.scrollEnabled = YES;
    [self.view addSubview:_orderscroll];
    _orderscroll.sd_layout.leftEqualToView(self.view).rightEqualToView(self.view).topSpaceToView(self.view,0).heightIs(self.view.frame.size.height);
    
    _orderscroll.userInteractionEnabled = YES;
    
    
    UIView * headview = [[UIView alloc]init];
    headview.backgroundColor = [UIColor whiteColor];
    [_orderscroll addSubview:headview];
    headview.sd_layout.leftEqualToView(_orderscroll).rightEqualToView(_orderscroll).topSpaceToView(_orderscroll,0).heightIs(autoScaleH(150));
    
    _titlelabel = [[UILabel alloc]init];
    _titlelabel.text = @"用餐服务";
    _titlelabel.font = [UIFont systemFontOfSize:autoScaleW(15)];
    _titlelabel.textColor = UIColorFromRGB(0xfd7577);
    _titlelabel.textAlignment = NSTextAlignmentCenter;
    [headview addSubview:_titlelabel];
    _titlelabel.sd_layout.centerXEqualToView(headview).topSpaceToView(headview,autoScaleH(15)).widthIs(GetWidth).heightIs(autoScaleH(20));
    
    UIImageView * promptimage = [[UIImageView alloc]init];
    promptimage.image = [UIImage imageNamed:@"用餐服务"];
    [headview addSubview:promptimage];
    promptimage.sd_layout.leftEqualToView(headview).rightEqualToView(headview).topSpaceToView(_titlelabel,autoScaleH(25)).heightIs(autoScaleH(60));
    
    UILabel * linelabel = [[UILabel alloc]init];
    linelabel.backgroundColor = UIColorFromRGB(0xeeeeee);
    [headview addSubview:linelabel];
    linelabel.sd_layout.leftSpaceToView(headview,autoScaleW(10)).rightSpaceToView(headview,autoScaleW(10)).bottomEqualToView(headview).heightIs(0.5);
    
    if ([_isservice isEqualToString:@"1"])
    {
        
        for (int i=0; i<_serveary.count; i++)
        {
            UIButton * servicebtn = [UIButton buttonWithType:UIButtonTypeCustom];
            //        [servicebtn setBackgroundImage:[UIImage imageNamed:@"用餐服务环"] forState:UIControlStateNormal];
            servicebtn.backgroundColor = [UIColor whiteColor];
            servicebtn.layer.masksToBounds = YES;
            servicebtn.layer.cornerRadius = autoScaleW(30);
            [servicebtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            servicebtn.titleLabel.font = [UIFont boldSystemFontOfSize:autoScaleW(15)];
            
            servicebtn.tag =  500 + i;
            servicebtn.titleLabel.numberOfLines = 0;
            [servicebtn addTarget:self action:@selector(Click:) forControlEvents:UIControlEventTouchUpInside];
            [_orderscroll addSubview:servicebtn];
            servicebtn.sd_layout.leftSpaceToView(_orderscroll,((GetWidth-autoScaleW(260))/2)+i%3*autoScaleW(100)).topSpaceToView(headview,((GetWidth-autoScaleW(260))/2)+i/3*autoScaleW(100)).widthIs(autoScaleW(60)).heightIs(autoScaleW(60));
            servicebtn.titleEdgeInsets = UIEdgeInsetsMake(-10, 10, -10, 10);
            [servicebtn setTitle:_serveary[i] forState:UIControlStateNormal];
            
           
        }
        
     
    }else if ([_isservice isEqualToString:@"0"])
    {
        UIImageView * placeimage = [[UIImageView alloc]init];
        placeimage.image = [UIImage imageNamed:@"未开启现场服务"];
        [_orderscroll addSubview:placeimage];
        placeimage.sd_layout.centerXEqualToView(_orderscroll).topSpaceToView(headview,autoScaleH(100)).widthIs(autoScaleW(200)).heightIs(autoScaleW(150));
        
    }
    
    UIButton * paybtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [paybtn setTitle:@"菜单" forState:UIControlStateNormal];
    paybtn.titleLabel.font = [UIFont systemFontOfSize:autoScaleW(15)];
    [paybtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    paybtn.backgroundColor = UIColorFromRGB(0xfd7577);
    paybtn.layer.masksToBounds = YES;
    paybtn.layer.cornerRadius = 3;
    [paybtn addTarget:self action:@selector(Hasdine) forControlEvents:UIControlEventTouchUpInside];
    [_orderscroll addSubview:paybtn];
    paybtn.sd_layout.leftSpaceToView(_orderscroll,autoScaleW(15)).rightSpaceToView(_orderscroll,autoScaleW(15)).bottomSpaceToView(_orderscroll,autoScaleH(15)).heightIs(autoScaleH(40));
    
    
}
#pragma mark 呼叫服务按钮
-(void)Click:(UIButton*)btn
{
    
    
    _serviceint = btn.tag - 500;
    NSString * urlstr = [NSString stringWithFormat:@"%@/api/user/scanCodeServiceManage?&token=%@&orderId=%@&serviceType=%d",commonUrl,Token,_orderid,_serviceint];
    
    NSArray * urlary = [urlstr componentsSeparatedByString:@"?"];
        [MBProgressHUD showMessage:@"请稍等"];
        [[QYXNetTool shareManager]postNetWithUrl:urlary.firstObject urlBody:urlary.lastObject bodyStyle:QYXBodyString header:nil response:QYXJSON success:^(id result) {
            [MBProgressHUD hideHUD];
            NSLog(@"resultttt%@",result);
            
            NSString * typestr = [NSString stringWithFormat:@"%@",[result objectForKey:@"msgType"]] ;
            
            if ([typestr isEqualToString:@"0"]) {
                
                

                CircularProgressBar * _m_circularProgressBar = [[CircularProgressBar alloc] init];
                
                _m_circularProgressBar.tag = btn.tag;
                _m_circularProgressBar.delegate = self;
                
                [btn addSubview:_m_circularProgressBar];
                _m_circularProgressBar.sd_layout.centerXEqualToView(btn).topSpaceToView(btn,0).widthIs(autoScaleW(60)).heightIs(autoScaleW(60));
                
                [_m_circularProgressBar setTotalMinuteTime:1];
                [_m_circularProgressBar startTimer];
            }
            
        } failure:^(NSError *error) {
            
            [MBProgressHUD hideHUD];
        }];


    
    
}
- (void)runanduploadWithobj:(UIButton*)btn
{
   
    
   

    
}


- (void)overChange:(NSNotification*)noti{
    
    NSInteger tag = [noti.userInfo[@"tag"] integerValue];
    
    UIButton * btn = (UIButton*)[self.view viewWithTag:tag];
    [btn setTitle:_serveary[tag - 500] forState:UIControlStateNormal];

}
#pragma mark 查看已点的菜
-(void)Hasdine
{
    NSArray * zlertary = @[@"加菜",@"已点的菜",@"取消"];
    ZTAlertSheetView * ztalert = [[ZTAlertSheetView alloc]initWithTitleArray:zlertary];
    [ztalert showView];
    ztalert.alertSheetReturn = ^(NSInteger clickint)
    {
        if (clickint==0) {
            
            [self AddDine];

        }
        else if (clickint==1)
        {
            HasDineViewController * hasdineview = [[HasDineViewController alloc]init];
            hasdineview.orderid = _orderid;
            [self.navigationController pushViewController:hasdineview animated:YES];
        }
        
        
    };
    
}
#pragma mark 加菜
- (void)AddDine{
    
    AddOrderViewController * addOrderview = [[AddOrderViewController alloc]init];
    addOrderview.storeid = _storeid;
    addOrderview.orderid = _orderid;
    addOrderview.block = ^(NSString * reload){
        if ([reload isEqualToString:@"success"]) {
            
            [self Getaf];
        }
        
    };
    [self.navigationController pushViewController:addOrderview animated:YES];
    
}
#pragma mark 倒计时代理方法
- (void)CircularProgressEnd
{
    [_m_circularProgressBar stopTimer];
//    [_m_circularProgressBar setTotalSecondTime:0];
    
    
}
-(void)Gettime:(NSString *)timestring CircularProgressBar:(UIView *)Circul
{
    
    UIButton * btn = (UIButton *)[self.view viewWithTag:Circul.tag];
    [btn setTitle:@"" forState:UIControlStateNormal];

    
    if ([timestring isEqualToString:@"00:00"])
    {
         dispatch_async(dispatch_get_main_queue(), ^{
             
             [Circul removeFromSuperview];
             [btn setTitle:_serveary[Circul.tag - 500] forState:UIControlStateNormal];

         });
        
    }

}

- (void)Back
{
    
        
       MyorderViewController * myorderview = [[MyorderViewController alloc]init];
       self.tabBarController.selectedIndex = 1;
       [self.navigationController pushViewController:myorderview animated:YES];

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
