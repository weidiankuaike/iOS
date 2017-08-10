//
//  MinePageVC.m
//  wdKuaiKe_iOS
//
//  Created by Skyer God on 16/8/4.
//  Copyright © 2016年 weiDianKuaiKe. All rights reserved.
//

#import "MinePageVC.h"
#import "UIBarButtonItem+SSExtension.h"
#import "LLHConst.h"
#import "LoginViewController.h"
#import "MyorderViewController.h"
#import "BrowseViewController.h"


//重新
#import "MyticketViewController.h"
#import "MyWalletViewController.h"
#import "ShoucangViewController.h"
#import "NewFeedbackViewController.h"
#import <UIImageView+WebCache.h>
#import "MyMaterialViewController.h"
#import "ErectViewController.h"
#import "ServeCenterViewController.h"
#import "BusinessViewController.h"
#import "MBProgressHUD+SS.h"
#import "QYXNetTool.h"
#import "ServicedetailViewController.h"
#import "MyQueueViewController.h"
@interface MinePageVC ()<UITableViewDelegate,UITableViewDataSource>

{
    
    NSArray * labelAry;
    NSArray * seclabelAry;
    NSArray * imageAry;
    NSArray * secimageary;
    NSArray * orderImageAry;
    NSArray * orderLabelAry;
    BOOL islogin ;

}
@property (nonatomic,copy)NSString * token;
@property (nonatomic,copy)NSString * headimage;
@property (nonatomic,strong)UIImageView * headimageview;
@property (nonatomic,strong)UIButton * loginBtn;
@property (nonatomic,copy)NSString * namestr;
@property (nonatomic,copy)NSString * phonestr;
@end

@implementation MinePageVC

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
   
    self.navigationController.navigationBar.hidden = YES;
    self.tabBarController.tabBar.hidden = YES;
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"navImage"] forBarPosition:UIBarPositionAny barMetrics:UIBarMetricsDefault];
    
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
    [self getData];
    
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.tabBarController.tabBar.hidden = NO;
}
- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor lightGrayColor];
    _token = [[NSUserDefaults standardUserDefaults]objectForKey:@"token"];
    _headimage = [[NSUserDefaults standardUserDefaults]objectForKey:@"headimage"];
    _namestr = [[NSUserDefaults standardUserDefaults]objectForKey:@"name"];
    self.automaticallyAdjustsScrollViewInsets = NO;
    // 表头
    CGFloat height = [[UIApplication sharedApplication] statusBarFrame].size.height + self.navigationController.navigationBar.frame.size.height;
    UIView * headview = [[UIView alloc]init];
    headview.frame = CGRectMake(0, 0, GetWidth, GetHeight*0.273);
    [self.view addSubview:headview];
    UIImageView * headimag = [[UIImageView alloc]init];
    headimag.image = [UIImage imageNamed:@"1"];
    headimag.frame = headview.frame;
    [headview addSubview:headimag];
    headimag.userInteractionEnabled = YES;
    
//    UIButton * xiaoxi = [[UIButton alloc]init];
//    [xiaoxi setBackgroundImage:[UIImage imageNamed:@"消息"] forState:UIControlStateNormal];
//    [xiaoxi addTarget:self action:@selector(Xiaoxi) forControlEvents:UIControlEventTouchUpInside];
//    [headview addSubview:xiaoxi];
//    xiaoxi.sd_layout.rightSpaceToView(headview,autoScaleW(15)).topSpaceToView(headview,autoScaleH(30)).heightIs(autoScaleH(20)).widthIs(autoScaleW(20));
    UIButton * szBtn =[ UIButton buttonWithType:UIButtonTypeCustom];
    [szBtn setBackgroundImage:[UIImage imageNamed:@"设置-(1)"] forState:UIControlStateNormal];
    [szBtn addTarget:self action:@selector(shezhi) forControlEvents:UIControlEventTouchUpInside];
    [headview addSubview:szBtn];
    szBtn.sd_layout.rightSpaceToView(headview,20).topSpaceToView(headview,autoScaleH(30)).heightIs(autoScaleH(25)).widthIs(autoScaleW(25));
    
     _headimageview =[[UIImageView alloc]init];
    _headimageview.layer.masksToBounds = YES;
    _headimageview.layer.cornerRadius = autoScaleW(42);
    [headimag addSubview:_headimageview];
    _headimageview.sd_layout.centerXEqualToView(headimag).centerYEqualToView(headimag).widthIs(autoScaleW(84)).heightIs(autoScaleW(84));
    _headimageview.userInteractionEnabled = YES;
    UITapGestureRecognizer * logintap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(Login)];
    [_headimageview addGestureRecognizer:logintap];
    
    
    _loginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _loginBtn.titleLabel.font = [UIFont boldSystemFontOfSize:autoScaleW(15)];
    [_loginBtn setTitleColor:UIColorFromRGB(0x191919) forState:UIControlStateNormal];
    [_loginBtn addTarget:self action:@selector(Login) forControlEvents:UIControlEventTouchUpInside];
    [headimag addSubview:_loginBtn];
    _loginBtn.sd_layout.centerXEqualToView(_headimageview).topSpaceToView(_headimageview,autoScaleH(5)).widthIs(kWidth(120)).heightIs(kHeight(25));
    
    UIImageView * rightimage = [[UIImageView alloc]init];
    rightimage.image = [UIImage imageNamed:@"形状-3-拷贝"];
    [headimag addSubview:rightimage];
    rightimage.sd_layout.rightSpaceToView(headimag,kWidth(15)).topSpaceToView(headimag,kHeight(68)).widthIs(kWidth(16)).heightIs(kHeight(27));
    //表
    
    UITableView * MineTableview = [[UITableView alloc]init];
    MineTableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    MineTableview.delegate =self;
    MineTableview.dataSource= self;
    MineTableview.scrollEnabled = NO;
    MineTableview.tableHeaderView = headview;
    [self.view addSubview:MineTableview];
    MineTableview.sd_layout.leftSpaceToView(self.view,0).topSpaceToView(self.view,0).widthIs(GetWidth).heightIs(GetHeight);
    
    UIButton * backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [backBtn setImage:[UIImage imageNamed:@"left-1"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(clickBack) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backBtn];
    backBtn.sd_layout.leftSpaceToView(self.view,kWidth(15)).topSpaceToView(self.view,kHeight(20)).widthIs(kWidth(30)).heightIs(kHeight(20));
    
    labelAry = @[@"最近浏览",@"我的收藏"];
    seclabelAry = @[@"服务中心",@"意见反馈",@"欢迎评价",@"商家入驻",];
    imageAry = @[@"浏览-(1)",@"收藏"];
    secimageary = @[@"服务",@"关于我们",@"推荐-(1)",@"入驻"];
    orderImageAry = @[@"代金券",@"钱包-(3)"];
    orderLabelAry = @[@"我的卡券",@"我的钱包",];
    
}
//网络请求
- (void)getData
{
    NSString * url = [NSString stringWithFormat:@"%@/api/user/userInfoManage?token=%@&userId=%@&operation=0",commonUrl,Token,Userid];
    NSArray * urlary = [url componentsSeparatedByString:@"?"];
    [MBProgressHUD showMessage:@"请稍等"];
    [[QYXNetTool shareManager]postNetWithUrl:urlary.firstObject urlBody:urlary.lastObject bodyStyle:QYXBodyString header:nil response:QYXJSON success:^(id result) {
        NSLog(@"infooo%@",result);
        [MBProgressHUD hideHUD];
        NSString * msgtype = [NSString stringWithFormat:@"%@",result[@"msgType"]];
        if ([msgtype isEqualToString:@"0"]) {
            NSDictionary * obldict = result[@"obj"];
            NSString * imagestr = obldict[@"avatar"];
            _namestr = obldict[@"name"];
            //http图片转https
            NSArray * imageary = [imagestr componentsSeparatedByString:@":"];
            NSMutableArray * imagemustary = [NSMutableArray arrayWithArray:imageary];
            [imagemustary replaceObjectAtIndex:0 withObject:@"https"];
            _headimage = [imagemustary componentsJoinedByString:@":"];
             [_headimageview sd_setImageWithURL:[NSURL URLWithString:_headimage]placeholderImage:[UIImage imageNamed:@"1"]];
            
            [_loginBtn setTitle:_namestr forState:UIControlStateNormal];
            _phonestr = obldict[@"phone"];
            islogin = YES;
            
        }
        else if ([msgtype isEqualToString:@"2000"]){
            
            LoginViewController * loginView = [[LoginViewController alloc]init];
            [self.navigationController pushViewController:loginView animated:YES];
        }
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUD];
        [MBProgressHUD showError:@"请求失败"];
    }];
    
}
#pragma mark 设置按钮回调
-(void)shezhi
{
    ErectViewController * erectview = [[ErectViewController alloc]init];
    
    [self.navigationController pushViewController:erectview animated:YES];
    
}
#pragma mark 登录按钮回调
-(void)Login
{
    
    
    if (islogin ==NO) {
        LoginViewController * loginView = [[LoginViewController alloc]init];
        
        self.tabBarController.tabBar.hidden = YES;
        [self.tabBarController.view viewWithTag:2000].hidden = YES;
        self.navigationController.navigationBar.hidden = YES;
        [self.navigationController pushViewController:loginView animated:NO];
    }
    else
    {
        MyMaterialViewController * payview = [[MyMaterialViewController alloc]init];
        
        [self.navigationController pushViewController:payview animated:NO];
        
    }
}

#pragma mark 数据源方法
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section==0) {
        return 2;
    }
    if (section==1) {
        return 2;
    }
    return 5;
}
-(UITableViewCell* )tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *celldent = @"id";
    UITableViewCell * cell = [tableView cellForRowAtIndexPath:indexPath];
    if (!cell) {
        
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:celldent];
    }
    
    UILabel *linelabel = [[UILabel alloc]init];
    linelabel.backgroundColor = UIColorFromRGB(0xDCDCDC);
    [cell addSubview:linelabel];
    linelabel.sd_layout.leftSpaceToView(cell,0).bottomSpaceToView(cell,0).widthIs(GetWidth).heightIs(1);
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if (indexPath.section==0) {
        
        if (indexPath.row==1) {
            
            cell.backgroundColor =UIColorFromRGB(0xEEEEEE);
        }
        
            if (indexPath.row==0) {
            
            for (int i =0; i <2; i++) {
                
                UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
                button.tag = 100+i;
                [button addTarget:self action:@selector(OrderBtn:) forControlEvents:UIControlEventTouchUpInside];
                [cell addSubview:button];
                button.sd_layout.leftSpaceToView(cell,(GetWidth-autoScaleW(63)*2)/3+i*((GetWidth-autoScaleW(62)*2)/3+autoScaleH(63))).topSpaceToView(cell,kHeight(10)).widthIs(kWidth(63)).heightIs(kHeight(50));
                
                UIImageView * orderimage = [[UIImageView alloc]init];
                orderimage.image = [UIImage imageNamed:orderImageAry[i]];
                [button addSubview:orderimage];
                orderimage.sd_layout.leftSpaceToView(button,kWidth(21)).topSpaceToView(button,0).widthIs(kWidth(21)).heightIs(kHeight(23));
                
                UILabel * orderlabel =[[UILabel alloc]init];
                orderlabel.font = [UIFont systemFontOfSize:autoScaleW(13)];
                orderlabel.textColor = UIColorFromRGB(0x6E6E6E);
                orderlabel.text = orderLabelAry[i];
                [button addSubview:orderlabel];
                orderlabel.sd_layout.leftSpaceToView(button,0).topSpaceToView(orderimage,kHeight(15)).widthIs(kWidth(63)).heightIs(kHeight(12));
            }
        }
    }
    if (indexPath.section==1) {
        
        
            UIImageView  * imageview  = [[UIImageView alloc]init];
            imageview.image = [UIImage imageNamed:imageAry[indexPath.row]];
            [cell addSubview:imageview];
            imageview.sd_layout.leftSpaceToView(cell,kWidth(15)).topSpaceToView(cell,kHeight(10)).widthIs(kWidth(19)).heightIs(kHeight(19));
            
            UILabel * leftlabel = [[UILabel alloc]init];
            leftlabel.font = [UIFont systemFontOfSize:autoScaleW(14)];
            leftlabel.textColor = UIColorFromRGB(0x6E6E6E);
            leftlabel.text = labelAry [indexPath.row];
            [cell addSubview:leftlabel];
            leftlabel.sd_layout.leftSpaceToView(imageview,kWidth(5)).topSpaceToView(cell,kHeight(14)).widthIs(kWidth(100)).heightIs(kHeight(12));
            
            UIImageView * rightimage = [[UIImageView alloc]init];
            rightimage.image = [UIImage imageNamed:@"形状-3-拷贝"];
            [cell addSubview:rightimage];
            rightimage.sd_layout.rightSpaceToView(cell,kWidth(15)).topSpaceToView(cell,kHeight(15)).widthIs(kWidth(8)).heightIs(kHeight(11));
        
    }
    if (indexPath.section==2) {
        
        if (indexPath.row==0) {
            
            cell.backgroundColor =UIColorFromRGB(0xEEEEEE);
            
        }
        else
        {
            UIImageView  * imageview  = [[UIImageView alloc]init];
            imageview.image = [UIImage imageNamed:secimageary[indexPath.row-1]];
            [cell addSubview:imageview];
            imageview.sd_layout.leftSpaceToView(cell,kWidth(15)).topSpaceToView(cell,kHeight(10)).widthIs(kWidth(19)).heightIs(kHeight(19));
            
            UILabel * leftlabel = [[UILabel alloc]init];
            leftlabel.font = [UIFont systemFontOfSize:autoScaleW(14)];
            leftlabel.textColor = UIColorFromRGB(0x6E6E6E);
            leftlabel.text = seclabelAry [indexPath.row-1];
            [cell addSubview:leftlabel];
            leftlabel.sd_layout.leftSpaceToView(imageview,kWidth(5)).topSpaceToView(cell,kHeight(14)).widthIs(kWidth(100)).heightIs(kHeight(12));
            
            UIImageView * rightimage = [[UIImageView alloc]init];
            rightimage.image = [UIImage imageNamed:@"形状-3-拷贝"];
            [cell addSubview:rightimage];
            rightimage.sd_layout.rightSpaceToView(cell,kWidth(15)).topSpaceToView(cell,kHeight(15)).widthIs(kWidth(8)).heightIs(kHeight(11));
        }
        
        
    }
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0) {
        
        if (indexPath.row==1) {
            return kHeight(20);
        }
        if (indexPath.row==0) {
            return kHeight(70);
        }
    }
    
    if (indexPath.section==2) {
        
        if (indexPath.row==0) {
            return kHeight(20);
        }
    }
    
    
    return kHeight(45);
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==1) {
        if (indexPath.row==0) {
            BrowseViewController * browseview = [[BrowseViewController alloc]init];
           
            [self.navigationController pushViewController:browseview animated:NO];
            
        }
        if (indexPath.row==1) {
            
            ShoucangViewController * shoucangview = [[ShoucangViewController alloc]init];
            [self.navigationController pushViewController:shoucangview animated:NO];
            
        }
//        }if (indexPath.row==2) {
//            
//            MyQueueViewController * myQueueView = [[MyQueueViewController alloc]init];
//            [self.navigationController pushViewController:myQueueView animated:NO];
//            
//        }
    
        
    }
    
    if (indexPath.section==2)
    {
        if (indexPath.row==2) {
            
            NewFeedbackViewController * newfeedview = [[NewFeedbackViewController alloc]init];
            [self.navigationController pushViewController:newfeedview animated:NO];
        }
        else if (indexPath.row==1)
        {
            ServeCenterViewController * servecenterview = [[ServeCenterViewController alloc]init];
            [self.navigationController pushViewController:servecenterview animated:YES];
            
        }
        else if (indexPath.row==4)
        {
            BusinessViewController * businessview = [[BusinessViewController alloc]init];
            [self.navigationController pushViewController:businessview animated:YES];
            
        }
       
        
        
        
    }
}


#pragma mark 订单按钮回调

-(void)OrderBtn:(UIButton*)orderbtn
{
    if (orderbtn.tag==100) {
        
        MyticketViewController * myticketview = [[MyticketViewController alloc]init];
        [self.navigationController pushViewController:myticketview animated:NO];
        
        
    }
    if (orderbtn.tag==101)
    {
        MyWalletViewController * mywalletview = [[MyWalletViewController alloc]init];
        [self.navigationController pushViewController:mywalletview animated:NO];
        
    }
    
}
-(void)clickBack
{
    [self.navigationController popViewControllerAnimated:NO];
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
