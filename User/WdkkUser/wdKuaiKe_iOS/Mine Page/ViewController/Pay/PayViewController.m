//
//  PayViewController.m
//  wdKuaiKe_iOS
//
//  Created by 张森森 on 16/9/12.
//  Copyright © 2016年 weiDianKuaiKe. All rights reserved.
//

#import "PayViewController.h"
#import "UIBarButtonItem+SSExtension.h"
#import "PayTableViewCell.h"
#import "MBProgressHUD+SS.h"
#import "QYXNetTool.h"
#import <UIImageView+WebCache.h>
#import "NSObject+JudgeNull.h"
#import "CanuserTicketViewController.h"
#import <AlipaySDK/AlipaySDK.h>
#import "Order.h"
#import "RSADataSigner.h"
#import "OrderdetailViewController.h"
@interface PayViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,retain)UIButton * chooseBtn;
@property (nonatomic,strong)NSMutableArray * btnAry;
@property (nonatomic,strong)NSArray * nlAry;
@property (nonatomic,strong)NSArray * tjAry;
@property (nonatomic,strong)NSArray * imageary;
@property (nonatomic,strong)NSArray * secondimageary;
@property (nonatomic,copy)NSString * balancestr;
@property (nonatomic,copy)NSString * quanstr;
@property (nonatomic,strong)UIImageView * headimage;
@property (nonatomic,strong)NSArray * listary;
@property (nonatomic,strong)UILabel * daitilabel;
@property (nonatomic,strong)UIButton * querenBtn;
@property (nonatomic,assign)NSInteger  payType;//支付方式 0微信1支付宝
@property (nonatomic,assign)NSString * timers;//支付剩余时间
@property (nonatomic,retain)dispatch_source_t timer;//支付倒计时
@property (nonatomic,strong) UILabel * endtimelabel;//支付label
@property (nonatomic,copy)NSString * paykey;
@property (nonatomic,copy)NSString * type;//支付成功类型;
@property (nonatomic,copy)NSString * actBool;//使用优惠券后是否用调用第三方
@property (nonatomic,copy)NSString * swishOn;//是否开启余额
//@property (nonatomic,assign)NSString * actId;
@property (nonatomic,strong)UIImageView * storeimageview;
@property (nonatomic,strong)UILabel * storenamelabel;
@property (nonatomic,strong)UILabel * moneylabel;
@property (nonatomic,copy)NSString * oldOrderid;//旧的订单号 加单的时候支付成功到订单详情的时候要用
@end

@implementation PayViewController
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = NO;
    self.navigationController.navigationBar.translucent = NO;
    [self.navigationController.navigationBar setBarTintColor:UIColorFromRGB(0xfd7577)];
    self.tabBarController.tabBar.hidden = YES;
//    [self Gateaf];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = RGB(238, 238, 238);
    UILabel * titlabel = [[UILabel alloc]init];
    titlabel.frame = CGRectMake(0, 0, 80, 30);
    titlabel.textAlignment = NSTextAlignmentCenter;
    titlabel.font = [UIFont systemFontOfSize:15];
    titlabel.text = @"在线支付";
    titlabel.textColor = [UIColor whiteColor];
    self.navigationItem.titleView = titlabel;
    UIBarButtonItem * backbtn = [UIBarButtonItem itemWithTarget:self Action:@selector(Goback) image:@"left-1" selectImage:nil];
    self.navigationItem.leftBarButtonItem = backbtn;
    
    _payType = 0;
    _headimage = [[UIImageView alloc]init];
    _headimage.image = [UIImage imageNamed:@"支付背景"];
    [self.view addSubview:_headimage];
    _headimage.sd_layout.leftEqualToView(self.view).rightEqualToView(self.view).topSpaceToView(self.view,0).heightIs(autoScaleH(150));
    
    _storeimageview = [[UIImageView alloc]init];
    [_storeimageview sd_setImageWithURL:[NSURL URLWithString:_storeimage]];
    [_headimage addSubview:_storeimageview];
    _storeimageview.sd_layout.leftSpaceToView(_headimage,autoScaleW(15)).topSpaceToView(_headimage,autoScaleH(15)).widthIs(autoScaleW(40)).heightIs(autoScaleH(40));
    
    _storenamelabel = [[UILabel alloc]init];
    _storenamelabel.text = _storename;
    _storenamelabel.font = [UIFont systemFontOfSize:autoScaleW(13)];
    _storenamelabel.textColor = [UIColor whiteColor];
    [_headimage addSubview:_storenamelabel];
    _storenamelabel.sd_layout.leftSpaceToView(_storeimageview,autoScaleW(10)).topSpaceToView(_headimage,autoScaleH(20)).heightIs(autoScaleH(15));
    [_storenamelabel setSingleLineAutoResizeWithMaxWidth:300];
    
    UILabel * advancelabel = [[UILabel alloc]init];
    advancelabel.text = @"预付菜金";
    advancelabel.font = [UIFont systemFontOfSize:autoScaleW(15)];
    advancelabel.textColor = [UIColor whiteColor];
    [_headimage addSubview:advancelabel];
    advancelabel.sd_layout.leftSpaceToView(_headimage,autoScaleW(130)).centerYEqualToView(_headimage).widthIs(autoScaleW(65)).heightIs(autoScaleH(20));
    
    _moneylabel = [[UILabel alloc]init];
    double money = [_moneystr doubleValue];
    
    _moneylabel.text = [NSString stringWithFormat:@"￥%.2f",money];
    
    _moneylabel.textColor = [UIColor whiteColor];
    _moneylabel.font = [UIFont boldSystemFontOfSize:autoScaleW(20)];
    [_headimage addSubview:_moneylabel];
    _moneylabel.sd_layout.leftSpaceToView(advancelabel,autoScaleW(15)).centerYEqualToView(_headimage).heightIs(autoScaleH(25));
    [_moneylabel setSingleLineAutoResizeWithMaxWidth:200];
    
    UILabel * cutlinelabel = [[UILabel alloc]init];
    cutlinelabel.backgroundColor = RGB(173, 170, 170);
    [_headimage addSubview:cutlinelabel];
    
    cutlinelabel.sd_layout.leftSpaceToView(_headimage,autoScaleW(15)).rightSpaceToView(_headimage,autoScaleW(15)).topSpaceToView(_moneylabel,autoScaleH(20)).heightIs(1);
    
     //支付倒计时
    _endtimelabel = [[UILabel alloc]init];
    _endtimelabel.textColor = [UIColor whiteColor];
    _endtimelabel.text = @"";
    _endtimelabel.textAlignment = NSTextAlignmentCenter;
    _endtimelabel.font = [UIFont systemFontOfSize:autoScaleW(15)];
    [_headimage addSubview:_endtimelabel];
    _endtimelabel.sd_layout.leftEqualToView(_headimage).topSpaceToView(cutlinelabel,autoScaleH(15)).heightIs(autoScaleH(15)).widthIs(GetWidth);
    
    _querenBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _querenBtn.backgroundColor = UIColorFromRGB(0xfd7577);
    [_querenBtn setTitle:@"确认支付" forState:UIControlStateNormal];
    [_querenBtn setTitleColor:UIColorFromRGB(0xffffff) forState:UIControlStateNormal];
    [_querenBtn addTarget:self action:@selector(Pay) forControlEvents:UIControlEventTouchUpInside];
    _querenBtn.layer.masksToBounds = YES;
    _querenBtn.layer.cornerRadius = 3;
    [self.view addSubview:_querenBtn];
    _querenBtn.sd_layout.leftSpaceToView(self.view,autoScaleW(20)).rightSpaceToView(self.view,autoScaleW(20)).topSpaceToView(_headimage,autoScaleH(150)+autoScaleH(120)).heightIs(autoScaleH(40));
    _querenBtn.hidden = YES;
    
    _btnAry = [NSMutableArray array];
    
    _nlAry = @[@"微信支付",@"支付宝支付",];
    _tjAry = @[@"推荐微信安装5.0及以上版本的用户使用",@"推荐有支付宝账号的用户使用",];
    _imageary = @[@"微信支付",@"支付宝支付",];
    _secondimageary = @[@"余额",@"优惠券"];
    _actId = @"";
    _swishOn = @"1";
    //微信支付通知
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(Success) name:@"success" object:nil];
    [self Gateaf];
    
}
- (void)CountDown
{
    UIApplication*   app = [UIApplication sharedApplication];
    __block    UIBackgroundTaskIdentifier bgTask;
    bgTask = [app beginBackgroundTaskWithExpirationHandler:^{
        dispatch_async(dispatch_get_main_queue(), ^{
            if (bgTask != UIBackgroundTaskInvalid)
            {
                bgTask = UIBackgroundTaskInvalid;
            }
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

    NSTimeInterval timeterval = [_timers integerValue];
    
    if (timeterval==0)//超时
    {
        [self Back];
        
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
                        

                        dispatch_async(dispatch_get_main_queue(), ^{
                            //                            [MBProgressHUD showMessage:@"请稍等"];
                            
                            NSString * url = [NSString stringWithFormat:@"%@/api/user/myOrderManage?token=%@&userId=%@&operation=2&orderId=%@&orderType=%@",commonUrl,Token,Userid,_orderid,_ordertype];
                            NSArray * urlary = [url componentsSeparatedByString:@"?"];
                            
                            [[QYXNetTool shareManager]postNetWithUrl:urlary.firstObject urlBody:urlary.lastObject bodyStyle:QYXBodyString header:nil response:QYXJSON success:^(id result)
                             {
                                 
                                 //                                 [MBProgressHUD hideHUD];
                                if (self.block)
                                 {
                                     
                                     self.block(@"fail");
                                     
                                 }
                                 [self Back];
                                 
                             } failure:^(NSError *error)
                             {
                                 [MBProgressHUD hideHUD];
                                 [MBProgressHUD showMessage:@"请求失败"];

                                 
                             }];
                        });
                    }else{
                        int days = (int)(timeout/(3600*24));
                        
                        int hours = (int)((timeout-days*24*3600)/3600);
                        int minute = (int)(timeout-days*24*3600-hours*3600)/60;
                        int second = timeout-days*24*3600-hours*3600-minute*60;
                        
                        
                        dispatch_async(dispatch_get_main_queue(), ^{
                            
                            if (minute>=1) {
                                
                                _endtimelabel.text = [NSString stringWithFormat:@"剩余时间：%d:%d",minute,second];
                                
                            }
                            else
                            {
                                _endtimelabel.text = [NSString stringWithFormat:@"剩余时间：%ds",second];
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
#pragma mark 网络请求
-(void)Gateaf
{
    NSString * urlstr = [NSString stringWithFormat:@"%@/api/user/payManage?token=%@&userId=%@&operation=%ld&orderId=%@",commonUrl,Token,Userid,_pushint,_orderid];
    [MBProgressHUD showMessage:@"请稍等"];
    NSArray * urlary = [urlstr componentsSeparatedByString:@"?"];
    [[QYXNetTool shareManager]postNetWithUrl:urlary.firstObject urlBody:urlary.lastObject bodyStyle:QYXBodyString header:nil response:QYXJSON success:^(id result)     {
        [MBProgressHUD hideHUD];
        
        NSLog(@"KLKLKL%@",result);
        if (![[result objectForKey:@"obj"] isNull])
        {
//            NSArray * objary = [result objectForKey:@"obj"];
            NSDictionary * objdict = [result objectForKey:@"obj"];
            _balancestr = [objdict objectForKey:@"myBalance"];
            if (![[objdict objectForKey:@"acList"] isNull])
            {
                _quanstr = @"请选一张优惠券吧";
                _listary = [objdict objectForKey:@"acList"];
                
            }
            else
            {
                _quanstr = @"您没有当前店铺可使用的优惠券";
            }
            
            _timers = objdict[@"timers"];
            _paykey = objdict[@"payKey"];
            _ordertype = objdict[@"orderType"];
            UITableView * puttableview = [[UITableView alloc]init];
            puttableview.backgroundColor = RGB(238, 238, 238);
            puttableview.separatorStyle = UITableViewCellSeparatorStyleNone;
            puttableview.delegate =self;
            puttableview.dataSource =self;
            [self.view addSubview:puttableview];
            puttableview.sd_layout.leftSpaceToView(self.view,0).topSpaceToView(_headimage,0).widthIs(GetWidth).heightIs(autoScaleH(150)+autoScaleH(100));
            
            _querenBtn.hidden = NO;
            if (_pushint ==0) {//加单是没有倒计时
                
                [self CountDown];

            }
            else if (_pushint ==1){
                
                _oldOrderid = objdict[@"oldOrderId"];
            }
            //店铺信息
            if (_storename == nil) {
                [_storeimageview sd_setImageWithURL:[NSURL URLWithString:objdict[@"storeImage"]]];

            }
            
            if (_storename==nil) {
                _storenamelabel.text = [NSString stringWithFormat:@"%@",objdict[@"storeName"]];

            }
            if (_moneystr == nil) {
                _moneylabel.text = [NSString stringWithFormat:@"￥%@",objdict[@"totalFee"]];

            }
        }else{
            
            [MBProgressHUD showError:@"请求失败"];
        }
        
        
    } failure:^(NSError *error)
    {
        [MBProgressHUD hideHUD];
        [MBProgressHUD showMessage:@"请求失败"];

    }];
    
}
- (void)Goback
{
    
    [self Back];
}
//支付完返回
-(void)Back
{
    OrderdetailViewController * orderdetailview = [[OrderdetailViewController alloc]init];
    
    if (_pushint == 0) {
        orderdetailview.orderId = _orderid;

    }else{
        
        orderdetailview.orderId = _oldOrderid;
    }
    [self.navigationController pushViewController:orderdetailview animated:YES];

    
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
   
    if (section==0) {
        
        return 2;
    }
    return 1;
    
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    PayTableViewCell * cell =[tableView dequeueReusableCellWithIdentifier:@"pay"];
    if (!cell) {
        
        cell = [[PayTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"pay"];
        
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    UILabel * linelabel = [[UILabel alloc]init];
    linelabel.backgroundColor = UIColorFromRGB(0xeeeeee);
    
    [cell addSubview:linelabel];

    linelabel.sd_layout.leftSpaceToView(cell,0).bottomSpaceToView(cell,0).widthIs(GetWidth).heightIs(0.5);
    if (indexPath.section==0) {
        
        UIButton * chooseBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [chooseBtn setBackgroundImage:[UIImage imageNamed:@"未打钩"] forState:UIControlStateNormal];
        [chooseBtn setBackgroundImage:[UIImage imageNamed:@"打勾"] forState:UIControlStateSelected];
        [chooseBtn addTarget:self action:@selector(Choose:) forControlEvents:UIControlEventTouchUpInside];
        chooseBtn.tag = indexPath.row;
        if (indexPath.row==0) {
            [self Choose:chooseBtn];
        }
        [cell addSubview:chooseBtn];
        [_btnAry addObject:chooseBtn];
        chooseBtn.sd_layout.rightSpaceToView(cell,autoScaleW(15)).centerYEqualToView(cell).widthIs(autoScaleW(25)).heightIs(autoScaleW(25));
        
        cell.namelable.text = _nlAry[indexPath.row];
        cell.tuijainlabel.text = _tjAry[indexPath.row];
        cell.headimage.image = [UIImage imageNamed:_imageary[indexPath.row]];
    }
    if (indexPath.section==1)
    {
        cell.headimage.image = [UIImage imageNamed:_secondimageary[indexPath.row]];
        cell.headimage.sd_layout.leftSpaceToView(cell,autoScaleW(15)).topSpaceToView(cell,autoScaleH(10)).widthIs(autoScaleW(20)).heightIs(autoScaleH(20));
        cell.namelable.hidden = YES;
        cell.tuijainlabel.hidden = YES;
        
        UILabel * titlabel = [[UILabel alloc]init];
        titlabel.font = [UIFont systemFontOfSize:autoScaleW(13)];
        titlabel.textColor = [UIColor blackColor];
        [cell addSubview:titlabel];
        titlabel.sd_layout.centerXEqualToView(cell).topSpaceToView(cell,autoScaleH(15)).heightIs(autoScaleH(15));
        [titlabel setSingleLineAutoResizeWithMaxWidth:300];
        
        if (indexPath.row==0) {
            
            titlabel.text = [NSString stringWithFormat:@"账户余额:￥%@",_balancestr] ;
            
            
            UISwitch * mySwitth = [[UISwitch alloc]init];
            mySwitth.on = YES;
            [mySwitth setOnTintColor:UIColorFromRGB(0xfd7577)];
            [mySwitth setThumbTintColor:[UIColor whiteColor]];
            mySwitth.tag = 300+indexPath.row;
            [mySwitth addTarget:self action:@selector(swChange:) forControlEvents:UIControlEventValueChanged];
            [cell addSubview:mySwitth];
            mySwitth.sd_layout.rightSpaceToView(cell,autoScaleW(15)).topSpaceToView(cell,autoScaleH(8)).widthIs(autoScaleW(8)).heightIs(autoScaleH(11));
            
        }
//        else if (indexPath.row==1)
//        {
//            UIImageView * rightimage = [[UIImageView alloc]init];
//            rightimage.image = [UIImage imageNamed:@"arrow-1-拷贝"];
//            [cell addSubview:rightimage];
//            rightimage.sd_layout.rightSpaceToView(cell,autoScaleW(15)).topSpaceToView(cell,15).widthIs(10).heightIs(15);
//  
//             titlabel.text = _quanstr;
//            _daitilabel = titlabel;
//            
//        }
        
        
        
    }
    
    return cell;
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==1) {
        
        return 45;
    }
    return  70;
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
//    if (indexPath.section==1) {
//        
//        if (indexPath.row==1&&_listary.count!=0)
//        {
//            CanuserTicketViewController * canuserview = [[CanuserTicketViewController alloc]init];
//            canuserview.listary = _listary;
//            canuserview.blck = ^(NSString * namestr,NSString * moneystr,NSString * idstr)
//            {
//                _daitilabel.text = [NSString stringWithFormat:@"%@:%@",namestr,moneystr];
//                _actId = idstr;
//            };
//            
//            
//            [self.navigationController pushViewController:canuserview animated:YES];
//            
//        }
//    }
    
    
}
#pragma mark 选择支付方式
-(void)Choose:(UIButton*)btn

{
    NSLog(@"cccc");
    btn.selected = !btn.selected;
    
    for (UIButton * choosebtn in _btnAry) {
        if (choosebtn.tag==btn.tag) {
            
            choosebtn.selected = YES;
            if (choosebtn.tag==0) {
                
                _payType = 0;
            }
            else
            {
                _payType = 1;
//                [MBProgressHUD showError:@"暂未开放此功能"];
            }
            
        }
        else
        {
            choosebtn.selected = NO;
        }
    }
    
    
}
#pragma mark 是否开启余额
- (void)swChange:(UISwitch*)sw
{
    if (sw.on == YES) {
        
        _swishOn = @"1";
    }
    else{
        _swishOn = @"0";
    }
    
    
    
}
-(void)getsomethingwith:(payblock)block
{
    self.block = block;
}
- (void)Pay
{
    if ([_swishOn isEqualToString:@"0"]) {//没有开启余额
        
        if (_payType==0) {
            //判断是否安装微信
            if ([WXApi isWXAppSupportApi]) {
                [self lalalala];
            }
            else{
                [MBProgressHUD showError:@"您的手机未安装微信"];
            }
        }
        else
        {
            //是否安装支付宝
//            NSURL * alipay = [NSURL URLWithString:@"alipay"];
//            if ([[UIApplication sharedApplication]canOpenURL:alipay]) {
//                [self AliPay];
//                
//            }
//            else{
//                [MBProgressHUD showError:@"您的手机为安装支付宝"];
//            }
            [self AliPay];
        }
    }
    else{
        [self getPayinformation];
    }

}
#pragma mark 确认支付按钮网络请求
- (void)getPayinformation
{
    [MBProgressHUD showMessage:@"请稍等"];
    NSString * urlstr = [NSString stringWithFormat:@"%@/api/user/surePayOrder?token=%@&orderId=%@&isUseBalance=%@&actId=%@",commonUrl,Token,_orderid,_swishOn,_actId];
    NSArray * urlary = [urlstr componentsSeparatedByString:@"?"];
    [[QYXNetTool shareManager]postNetWithUrl:urlary.firstObject urlBody:urlary.lastObject bodyStyle:QYXBodyString header:nil response:QYXJSON success:^(id result) {
        [MBProgressHUD hideHUD];
        NSLog(@"Payyyyyyyyyyy%@",result);
        NSString * msgtype = [NSString stringWithFormat:@"%@",result[@"msgType"]];
        if ([msgtype isEqualToString:@"5"]) {
            if (_payType==0) {
                //判断是否安装微信
                if ([WXApi isWXAppSupportApi]) {
                    [self lalalala];
                }
                else{
                    [MBProgressHUD showError:@"您的手机未安装微信"];
                }
            }
            else
            {
                [self AliPay];
            }
        }else if ([msgtype isEqualToString:@"0"])
        {
            _type = @"1";
            [self Paysuccess];
        }
        
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUD];
        [MBProgressHUD showError:@"网络参数错误"];
    }];
    
    
}
//支付成功
- (void)Success
{
    _type = @"0";
    [self Paysuccess];
    
    
}
// 微信支付
- (void)lalalala
{
    [MBProgressHUD showMessage:@"请稍等"];
    NSString * url = [NSString stringWithFormat:@"%@/weixinPay/weixinPay?token=%@&orderId=%@&isUseBalance=%@&actId=%@",commonUrl,Token,_orderid,_swishOn,_actId];
    NSArray * urlary = [url componentsSeparatedByString:@"?"];
    [[QYXNetTool shareManager]postNetWithUrl:urlary.firstObject urlBody:urlary.lastObject bodyStyle:QYXBodyString header:nil response:QYXJSON success:^(id result) {
        [MBProgressHUD hideHUD];
        NSLog(@"KLKL<>?<IO:%@",result);
        
        NSString * msgType = [result objectForKey:@"msgType"];
        if ([msgType isEqualToString:@"0"]) {
            
            NSDictionary *dic = [result objectForKey:@"obj"];
                           // 发起微信支付，设置参数
                PayReq *request = [[PayReq alloc] init];
                request.openID = [dic objectForKey:@"appid"];
                request.partnerId = [dic objectForKey:@"partnerid"];
                request.prepayId= [dic objectForKey:@"prepayid"];
                request.package = @"Sign=WXPay";
                request.nonceStr= [dic objectForKey:@"noncestr"];
                request.sign = dic[@"sign"];

            NSString * timestr = [NSString stringWithFormat:@"%@",dic[@"timestamp"]];
                request.timeStamp= timestr.intValue;
                
//                // 签名加密
//                MXWechatSignAdaptor *md5 = [[MXWechatSignAdaptor alloc] init];
//                
//                request.sign=[md5 createMD5SingForPay:request.openID
//                                            partnerid:request.partnerId
//                                             prepayid:request.prepayId
//                                              package:request.package
//                                             noncestr:request.nonceStr
//                                            timestamp:request.timeStamp];
                // 调用微信
                [WXApi sendReq:request];
            
        }else{
            [MBProgressHUD hideHUD];
            [MBProgressHUD showError:@"服务器返回失败"];
        }
        
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUD];
        [MBProgressHUD showError:@"请求失败"];
    }];
}
#pragma Mark 支付宝支付
-(void)AliPay
{
    [MBProgressHUD showMessage:@"请稍等"];
    NSString * urlstr = [NSString stringWithFormat:@"%@/alipay/alipay?token=%@&orderId=%@&isUseBalance=%@&actId=%@",commonUrl,Token,_orderid,_swishOn,_actId];
    NSArray * urlary = [urlstr componentsSeparatedByString:@"?"];
    [[QYXNetTool shareManager]postNetWithUrl:urlary.firstObject urlBody:urlary.lastObject bodyStyle:QYXBodyString header:nil response:QYXJSON success:^(id result) {
        [MBProgressHUD hideHUD];
        NSLog(@"..>>///%@",result);
        NSString * msgstr = [NSString stringWithFormat:@"%@",result[@"msgType"]];
        if ([msgstr isEqualToString:@"0"]) {
            
            NSString * objstr = [NSString stringWithFormat:@"%@",result[@"obj"]];
            NSData * jsondata = [objstr dataUsingEncoding:NSUTF8StringEncoding];
            NSError * err;
            NSDictionary * objdict = [NSJSONSerialization JSONObjectWithData:jsondata options:NSJSONReadingMutableContainers error:&err];
            
//            NSDictionary * objdict = result[@"obj"];
            
            
            NSString * appID = Appid;
            NSString * rsaPrivateKey = PRIVATEKEY;
            if ([appID length] == 0 ||
                [rsaPrivateKey length] == 0 )
            {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
                 message:@"缺少appId或者私钥。"delegate:self cancelButtonTitle:@"确定"
                                                      otherButtonTitles:nil];
                [alert show];
                return;
            }
            else{
                    NSString *appScheme = @"alipay2016090801870168";
                
                   
                    // NOTE: 调用支付结果开始支付
                    [[AlipaySDK defaultService] payOrder:objstr fromScheme:appScheme callback:^(NSDictionary *resultDic) {
                        
                        
                    }];
//                }
            }

            
        }else{
            
            [MBProgressHUD showError:@"服务器返回失败"];
            
        }
    } failure:^(NSError *error) {
        [MBProgressHUD showError:@"服务器请求失败"];
        [MBProgressHUD hideHUD];
    }];
    
    
}
#pragma mark 支付成功后请求
- (void)Paysuccess
{
    NSString * url = [NSString stringWithFormat:@"%@/api/user/paySuccessChangeOrderType?token=%@&orderId=%@&type=%@&payKey=%@&actId=%@&isUseBalance=%@",commonUrl,Token,_orderid,_type,_paykey,_actId,_swishOn];
    NSArray * urlary = [url componentsSeparatedByString:@"?"];
    [MBProgressHUD showMessage:@"请稍等"];
    [[QYXNetTool shareManager]postNetWithUrl:urlary.firstObject urlBody:urlary.lastObject bodyStyle:QYXBodyString header:nil response:QYXJSON success:^(id result) {
        NSLog(@"payyyy%@",result);
        [MBProgressHUD hideHUD];
        NSString * msgtype = [NSString stringWithFormat:@"%@",result[@"msgType"]];
        if ([msgtype isEqualToString:@"0"]) {
            [MBProgressHUD showSuccess:@"确认成功"];
            [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"save"];
            [[NSUserDefaults standardUserDefaults]synchronize];
            
            if (_timer!=nil) {
                
                dispatch_source_cancel(_timer);
                
            }//销毁定时器
            
            
            if (self.block)
            {
                
                self.block(@"success");
                
            }
        }
        else{
            [MBProgressHUD showError:@"确认失败,若扣钱,请联系客服"];
        }
        
        [self Back];
        
        
    } failure:^(NSError *error) {
        
        [MBProgressHUD hideHUD];
         [MBProgressHUD showError:@"确认失败,若扣钱,请联系客服"];
    }];
    
}
//#pragma mark 微信支付
//- (void)WxPay
//{
//    NSString * urlstr = [NSString stringWithFormat:@"%@/createWeiXinPay?token=%@&orderId=%@&ip=%@",commonUrl,_orderid,PhoneIP];
//    NSArray * urlary = [urlstr componentsSeparatedByString:@"?"];
//    [MBProgressHUD showMessage:@"请稍等"];
//    [[QYXNetTool shareManager]postNetWithUrl:urlary.firstObject urlBody:urlary.lastObject bodyStyle:QYXBodyString header:nil response:QYXJSON success:^(id result) {
//        [MBProgressHUD hideHUD];
//        NSLog(@"<><>%@",result);
//        
//    } failure:^(NSError *error) {
//        
//        [MBProgressHUD hideHUD];
//    }];
//    
//    
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
