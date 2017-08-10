//
//  FinancialViewController.m
//  微点筷客商户端
//
//  Created by 张森森 on 16/10/17.
//  Copyright © 2016年 张森森. All rights reserved.
//

#import "FinancialViewController.h"
#import "UIBarButtonItem+SSExtension.h"
#import "MymoneyTableViewCell.h"
#import "ShouzhijiluViewController.h"
#import "Withdraw cashViewController.h"
#import "TixianViewController.h"
#import "FinatanView.h"
#import "NumberViewController.h"
#import "Withdraw cashViewController.h"
#import "MBProgressHUD+SS.h"
#import "QYXNetTool.h"
#import "NSObject+JudgeNull.h"
#import "FinacialModel.h"
#import "ZTAlertSheetView.h"
#import "FlowCountViewController.h"
@interface FinancialViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong)UIView * bigview;
@property (nonatomic,strong)NSMutableArray * modelary;
@property (nonatomic,strong)UILabel * moneylabel;
@property (nonatomic,strong)UILabel * yuelabel;
@property (nonatomic,copy)NSString * jryye;
@property (nonatomic,copy)NSString * yuestr;
@property (nonatomic,copy)NSString * havestr;
@property (nonatomic,copy)NSString * alipaystr;
@property (nonatomic,strong)UITableView * caiwutable;
@end

@implementation FinancialViewController
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [ReloadVIew registerReloadView:self];
    self.navigationController.navigationBar.hidden = NO;
    self.tabBarController.tabBar.hidden = YES;
    if ([_alipaystr isEqualToString:@""]) {
        [self Getaf];
    }
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.hidden = NO;
    self.tabBarController.tabBar.hidden = YES;
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.titleView.text = @"财务管理";
    self.view.backgroundColor = RGB(242, 242, 242);

    [self.rightBarItem setImage:[UIImage imageNamed:@"白色设置"] forState:UIControlStateNormal];
    [self.rightBarItem setTitle:@"设置" forState:UIControlStateNormal];
    self.rightBarItem.hidden = NO;
    self.rightBarItem.textToImageSapce = 3;
    self.rightBarItem.ztButtonStyle = ZTButtonStyleTextLeftImageRight;
    
    CGFloat height = [[UIApplication sharedApplication] statusBarFrame].size.height + self.navigationController.navigationBar.frame.size.height;
    UILabel * tedaylabel = [[UILabel alloc]init];
    tedaylabel.text = @"今日营业额";
    tedaylabel.textColor = RGB(139, 139, 139);
    tedaylabel.font = [UIFont systemFontOfSize:autoScaleW(13)];
    [self.view addSubview:tedaylabel];
    tedaylabel.sd_layout.centerXEqualToView(self.view).topSpaceToView(self.view,height+autoScaleH(30)).widthIs(autoScaleW(80)).heightIs(autoScaleH(15));
    
    _moneylabel = [[UILabel alloc]init];
    _moneylabel.textColor = RGB(9, 9, 9);
    _moneylabel.text = @"￥0.00";
    _moneylabel.font = [UIFont systemFontOfSize:autoScaleW(20)];
    [self.view addSubview:_moneylabel];
    _moneylabel.sd_layout.leftSpaceToView(self.view,autoScaleW(108)).topSpaceToView(tedaylabel,autoScaleH(30)).heightIs(autoScaleH(22));
    [_moneylabel setSingleLineAutoResizeWithMaxWidth:200];
    
    ButtonStyle * yingyebtn = [ButtonStyle buttonWithType:UIButtonTypeCustom];
    [yingyebtn setTitle:@"营业分析" forState:UIControlStateNormal];
    [yingyebtn setTitleColor:RGB(238, 183, 117) forState:UIControlStateNormal];
    yingyebtn.titleLabel.font = [UIFont systemFontOfSize:autoScaleW(13)];
    [yingyebtn addTarget:self action:@selector(Fenxi) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:yingyebtn];
    yingyebtn.sd_layout.leftSpaceToView(_moneylabel,0).topSpaceToView(tedaylabel,autoScaleH(35)).widthIs(autoScaleW(80)).heightIs(autoScaleH(15));
    
    NSArray * firstary = @[@"账户余额",@"0.00"];
    NSArray * twoary = @[@"最低提现限额",@"100.00",];
    NSMutableArray * mary = [NSMutableArray array];
    [mary addObject:firstary];
    [mary addObject:twoary];
    
    for (int i=0; i<mary.count; i++) {
        UILabel * twolabel = [[UILabel alloc]init];
        [self.view addSubview:twolabel];
        twolabel.sd_layout.leftSpaceToView(self.view ,autoScaleW(25)+i*((kScreenWidth-autoScaleW(50))/2)).topSpaceToView(_moneylabel,autoScaleH(22)).widthIs((kScreenWidth-autoScaleW(50))/2).heightIs(autoScaleH(47));
        if (i==0) {
            
            UILabel * slinlabel = [[UILabel alloc]init];
            slinlabel.backgroundColor = RGB(228, 228, 228);
            [twolabel addSubview:slinlabel];
            slinlabel.sd_layout.rightSpaceToView(twolabel,0).topSpaceToView(twolabel,0).widthIs(0.5).heightIs(twolabel.frame.size.height);
        }
        
        for (int a=0; a<2; a++) {
            
            UILabel * linlabel = [[UILabel alloc]init];
            linlabel.backgroundColor = RGB(228, 228, 228);
            [twolabel addSubview:linlabel];
            linlabel.sd_layout.leftSpaceToView(twolabel,0).topSpaceToView(twolabel,a*twolabel.frame.size.height).widthIs(twolabel.frame.size.width).heightIs(0.5);
            UILabel * sslabel = [[UILabel alloc]init];
            sslabel.text = mary[i][a];
            if (a==0) {
                
                sslabel.textColor = [UIColor grayColor];
                sslabel.font = [UIFont systemFontOfSize:autoScaleW(13)];
                
            }
            if (a==1) {
                sslabel.textColor = RGB(9, 9, 9);
                sslabel.font = [UIFont systemFontOfSize:autoScaleW(15)];
                
            }
            if (i==0&&a==1) {
                
                _yuelabel = sslabel;
            }
            sslabel.textAlignment = NSTextAlignmentCenter;
            [twolabel addSubview:sslabel];
            sslabel.sd_layout.leftEqualToView(twolabel).rightEqualToView(twolabel).topSpaceToView(twolabel,a*(twolabel.frame.size.height/2)).heightIs(twolabel.frame.size.height/2);
        }
    }
    
    
    ButtonStyle * ssbtn = [ButtonStyle buttonWithType:UIButtonTypeCustom];
    [ssbtn setTitle:@"提现" forState:UIControlStateNormal];
    ssbtn.titleLabel.font = [UIFont systemFontOfSize:autoScaleW(20)];
    ssbtn.layer.masksToBounds = YES;
    ssbtn.layer.cornerRadius = autoScaleW(5);
    [ssbtn setBackgroundColor:UIColorFromRGB(0xfd7577)];
    [ssbtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [ssbtn addTarget:self action:@selector(Click) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:ssbtn];
    ssbtn.sd_layout.leftSpaceToView(self.view ,autoScaleW(10)).rightSpaceToView(self.view,autoScaleW(10)).bottomSpaceToView(self.view,autoScaleH(5)).widthIs(kScreenWidth-autoScaleW(20)).heightIs(autoScaleH(40));

    [self Getaf];
    
}
-(void)Getaf
{
    NSString * token = TOKEN;
    
    NSString * storeid = storeID;
    NSString * userid = UserId;
    [MBProgressHUD showMessage:@"请稍等"];
    NSString *uploadUrl = [NSString stringWithFormat:@"%@api/merchant/searchFinancialInfo?token=%@&storeId=%@&userId=%@",kBaseURL,token,storeid,userid];
       
     [[QYXNetTool shareManager] postNetWithUrl:uploadUrl urlBody:nil bodyStyle:QYXBodyString header:nil response:QYXJSON success:^(id result) {

         [MBProgressHUD hideHUD];
         _modelary = [NSMutableArray array];
         id objvalue = [result objectForKey:@"obj"];
         
         ZTLog(@"<><>%@",result);
         if (![objvalue isNull] && ![objvalue isKindOfClass:[NSString class]]) {
             
             _jryye = [NSString stringWithFormat:@"%@",[objvalue objectForKey:@"totalFee"]] ;
             _yuestr = [NSString stringWithFormat:@"%@",[objvalue objectForKey:@"accoutAmount"]];
             float yuef = [_yuestr floatValue];
             _havestr = [NSString stringWithFormat:@"%@",[objvalue objectForKey:@"type"]];
             _moneylabel.text = [NSString stringWithFormat:@"￥%@",_jryye];
             _yuelabel.text = [NSString stringWithFormat:@"￥%.2f",yuef];
             
             _alipaystr = [NSString stringWithFormat:@"%@",[objvalue objectForKey:@"alipay"]];
             
             NSArray * listary = [objvalue objectForKey:@"list"];
             if (listary.count!=0) {
                 for (int i =0; i<listary.count; i++) {
                     FinacialModel * model = [[FinacialModel alloc]initWithgetsonthingwithdict:listary[i]];
                     
                     [_modelary addObject:model];
                 }
                 if (_caiwutable) {
                     
                     [_caiwutable reloadData];
                 } else {
                     [self CreatTableview];
                 }
             }
         }
     } failure:^(NSError *error) {
         [MBProgressHUD hideHUD];
         [MBProgressHUD showError:@"网络错误"];

     }];
    

}
-(void)CreatTableview
{
   
    UITableView * caiwutable = [[UITableView alloc]init];
    caiwutable.separatorStyle = UITableViewCellSeparatorStyleNone;
    caiwutable.backgroundColor = RGB(242, 242, 242);
    caiwutable.delegate =self;
    caiwutable.dataSource = self;
    caiwutable.scrollEnabled = NO;
    [self.view addSubview:caiwutable];
    caiwutable.sd_layout.leftSpaceToView(self.view,autoScaleW(25)).rightSpaceToView(self.view,autoScaleW(25)).topSpaceToView(_moneylabel,autoScaleH(80)).heightIs(autoScaleH(60)*4);
    
    ButtonStyle * clickbtn = [[ButtonStyle alloc]init];
    [clickbtn setTitle:@"查看全部" forState:UIControlStateNormal];
    [clickbtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    clickbtn.titleLabel.font = [UIFont systemFontOfSize:autoScaleW(13)];
    [clickbtn addTarget:self action:@selector(Quanbu) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:clickbtn];
    clickbtn.sd_layout.centerXEqualToView(self.view).topSpaceToView(caiwutable,autoScaleH(35)).widthIs(autoScaleW(65)).heightIs(autoScaleH(15));

    if (_modelary.count>=4) {
        clickbtn.hidden = NO;
    }else{
        clickbtn.hidden = YES;
    }
    
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (_modelary.count >= 4) {
        return 4;
    }
     return _modelary.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MymoneyTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"ss"];
    if (!cell) {
        cell = [[MymoneyTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ss"];
    }
    UILabel * linelabel = [[UILabel alloc]init];
    linelabel.backgroundColor = UIColorFromRGB(0xeeeeee);
    [cell addSubview:linelabel];
    linelabel.sd_layout.leftEqualToView(cell).rightEqualToView(cell).bottomEqualToView(cell).heightIs(0.5);
    
    cell.backgroundColor = RGB(242, 242, 242);
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    FinacialModel * model = _modelary[indexPath.row];
        cell.xiaoflabel.text = model.timestr;
    if ([model.trackstr isEqualToString:@"余额"]) {
        if ([model.typestr isEqualToString:@"收入"]) {
            
            cell.yuelabel.text = [NSString stringWithFormat:@"订单收入"];
            
        }else{
            cell.yuelabel.text = [NSString stringWithFormat:@"您向用户发起退款"];
        }
    }
    else{
        cell.yuelabel.text = [NSString stringWithFormat:@"您向%@发起了转账操作",model.trackstr];
    }
    cell.timelabel.text = model.typestr;
    
    if ([model.typestr isEqualToString:@"收入"]) {
        cell.jiagelabel.text = [NSString stringWithFormat:@"+%@",model.moneystr];
        
    }else{
        cell.jiagelabel.text = [NSString stringWithFormat:@"-%@",model.moneystr];
    }
    
    return cell;
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return autoScaleH(60);
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    FinacialModel * model = _modelary[indexPath.row];
    Withdraw_cashViewController * withderaw = [[Withdraw_cashViewController alloc]init];
    withderaw.cardstr = model.cardstr;
    withderaw.timestr = model.timestr;
    withderaw.firstmoney = model.moneystr;
    withderaw.secondmoney = model.balance;
    withderaw.typestr = model.trackstr;
    withderaw.ztstr = model.statusstr;
    [self.navigationController pushViewController:withderaw animated:YES];
    
}
-(void)leftBarButtonItemAction
{
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}
#pragma mark 设置
-(void)rightBarButtonItemAction:(ButtonStyle *)sender
{
    [self Crearui];
    
}
-(void)Fenxi
{
    FlowCountViewController * flowview = [[FlowCountViewController alloc]init];
    flowview.xianint = 2;
    [self.navigationController pushViewController:flowview animated:YES];
    
}

-(void)Click
{
    if ([_alipaystr isNull]) {
        //尚未绑定支付宝,跳转支付宝绑定页面
        _alipaystr = @"";
    } else {
        //已绑定支付宝帐号
    }
    if ([_yuestr doubleValue] >= 100 && [_havestr integerValue] == 0) {
        //满足提现条件
        FinatanView * finaview = [[FinatanView alloc]initWithHave:[_havestr integerValue] str:_alipaystr];
        finaview.frame = CGRectMake(0, 0, kScreenWidth,kScreenHeight);
        finaview.balanceMoney = _yuestr;
        finaview.block = ^(NSString * str) {
            if ([str isEqualToString:@"push"]) {
                NumberViewController * numberview = [[NumberViewController alloc]init];
                [self.navigationController pushViewController:numberview animated:YES];
            }
            if ([str isEqualToString:@"refresh"]) {

                [self Getaf];
            }

        };
        [self.navigationController.view addSubview:finaview];

    } else {
        if ([_havestr integerValue] == 1) {
            [SVProgressHUD showInfoWithStatus:@"每日最大提现次数为一次"];
        } else {
             [SVProgressHUD showInfoWithStatus:@"最低提现额度为100元"];
        }

    }

}
#pragma mark 显示全部
-(void)Quanbu
{
    ShouzhijiluViewController * shouzhiview = [[ShouzhijiluViewController alloc]init];
    [self.navigationController pushViewController:shouzhiview animated:YES];
    
}
-(void)Crearui
{
    
    UIWindow * window = [UIApplication sharedApplication].keyWindow;
    
    _bigview = [[UIView alloc]init];
    _bigview.backgroundColor = RGBA(0, 0, 0, 0.3);
    _bigview.alpha = 0;
    [window addSubview:_bigview];
    NSArray * ary = @[@"提现设置",@"取消",];
    ZTAlertSheetView *alertV = [[ZTAlertSheetView alloc] initWithTitleArray:ary];
    [alertV showView];
    alertV.alertSheetReturn = ^(NSInteger index){
        if (index == 0) {
            NumberViewController * numberview = [[NumberViewController alloc]init];
            [self.navigationController pushViewController:numberview animated:YES];
        } else;
    };
    
//    for (int i=0; i<ary.count; i++) {
//        
//        ButtonStyle * querenBtn = [ButtonStyle buttonWithType:UIButtonTypeCustom];
//        querenBtn.layer.masksToBounds = YES;
//        querenBtn.tag = 200 +i;
//        querenBtn.layer.cornerRadius = autoScaleW(10);
//        querenBtn.titleLabel.font = [UIFont systemFontOfSize:autoScaleW(20)];
//        [querenBtn setTitle:ary[i] forState:UIControlStateNormal];
//        [querenBtn setTitleColor:UIColorFromRGB(0xfd7577) forState:UIControlStateNormal];
//        [querenBtn setBackgroundColor:[UIColor whiteColor]];
//        
//        [querenBtn addTarget:self action:@selector(Clickbtn:) forControlEvents:UIControlEventTouchUpInside];
//        [_bigview addSubview:querenBtn];
//        querenBtn.sd_layout.leftSpaceToView(_bigview,autoScaleW(8)).bottomSpaceToView(_bigview,autoScaleH(10)+i*autoScaleH(64)).widthIs(kScreenWidth-autoScaleW(16)).heightIs(autoScaleH(55));
//        
//    }
//    [UIView animateWithDuration:0.5 animations:^{
//        
//        _bigview.alpha=1;
//        
//        _bigview.frame =window.bounds;
//    }];

}
//-(void)Clickbtn:(ButtonStyle *)btn
//{
//    if (btn.tag==200) {
//        
//        [_bigview removeFromSuperview];
//    }
//    
//    if (btn.tag==201) {
//        
//        [_bigview removeFromSuperview];
//        NumberViewController * numberview = [[NumberViewController alloc]init];
//        [self.navigationController pushViewController:numberview animated:YES];
//    }
//    
//}
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
