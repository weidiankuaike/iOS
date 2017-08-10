//
//  MineViewController.m
//  wdKuaiKe_iOS
//
//  Created by 张森森 on 16/9/6.
//  Copyright © 2016年 weiDianKuaiKe. All rights reserved.
//

#import "MineViewController.h"
#import "LoginViewController.h"
#import "LLHConst.h"
#import "LoginViewController.h"
#import "MyorderViewController.h"
#import "ShoucangViewController.h"
#import "BrowseViewController.h"
#import "PayViewController.h"
#import "MyWalletViewController.h"
#import "ToushuViewController.h"
#import "MyMaterialViewController.h"
#import "ChangeimageView.h"
#import "UIImageView+WebCache.h"
@interface MineViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    
    NSArray * labelAry;
    NSArray * seclabelAry;
    NSArray * imageAry;
    NSArray * secimageary;
    NSArray * orderImageAry;
    NSArray * orderLabelAry;
    BOOL islogin ;

}
@property (nonatomic,strong)UIImageView * headimageview;
@property (nonatomic,strong)UIButton * loginBtn;
@property (nonatomic,strong)UIImage * headima;
@property (nonatomic,strong)NSString * namelabel;
@property (nonatomic,strong)UILabel * loginlabel;
@property (nonatomic,copy)NSString * namestring;
@property (nonatomic,copy)NSString * phonestring;
@property (nonatomic,copy)NSString * imagestring;
@end

@implementation MineViewController

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    NSString * token = [[NSUserDefaults standardUserDefaults]objectForKey:@"token"];
    _namestring = [[NSUserDefaults standardUserDefaults]objectForKey:@"name"];
    _phonestring = [[NSUserDefaults standardUserDefaults]objectForKey:@"loginName"];
    _imagestring = [[NSUserDefaults standardUserDefaults]objectForKey:@"headimage"];
    UIImage * headimage = [[NSUserDefaults standardUserDefaults]objectForKey:@"image"];
    NSString * nastring = [[NSUserDefaults standardUserDefaults]objectForKey:@"changename"];
    if (headimage!=nil&&nastring!=nil) {
        UIImage * image = [UIImage imageWithData:headimage];
        _headimageview.image = image;
        _loginlabel.text = nastring;
    }
    else if (_imagestring !=nil&&_namestring !=nil)
    {
        [_headimageview sd_setImageWithURL:[NSURL URLWithString:_imagestring]];
        _loginlabel.text = _namestring;
    }
    else
    {
        _headimageview.image = [UIImage imageNamed:@"头像"];
        _loginlabel.text = @"点击登录";
        
    }
    
    self.navigationController.navigationBar.hidden = YES;
    self.tabBarController.tabBar.hidden = NO;
    if (_namestring !=nil) {
        
        islogin = YES;
    }
    else
    {
        islogin = NO;
    }
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor lightGrayColor];
    
    //设置导航栏按钮
    //    UIBarButtonItem * szbtn= [UIBarButtonItem itemWithTarget:self Action:@selector(shezhi) image:@"设置-(1)" selectImage:nil];
    //    UIBarButtonItem * xxBtn = [UIBarButtonItem itemWithTarget:self Action:@selector(Xiaoxi) image:@"消息" selectImage:nil];
    //    self.navigationItem.rightBarButtonItems= @[xxBtn,szbtn];
    
    // 表头
    CGFloat height = [[UIApplication sharedApplication] statusBarFrame].size.height + self.navigationController.navigationBar.frame.size.height;
    UIView * headview = [[UIView alloc]init];
    headview.frame = CGRectMake(0, 0, GetWidth, GetHeight*0.273+height);
    [self.view addSubview:headview];
   
    
    UIImageView * headimag = [[UIImageView alloc]init];
    headimag.image = [UIImage imageNamed:@"背"];
    headimag.frame = headview.frame;
    [headview addSubview:headimag];
    headimag.userInteractionEnabled = YES;
    
    UIButton * xiaoxi = [[UIButton alloc]init];
    [xiaoxi setBackgroundImage:[UIImage imageNamed:@"消息1"] forState:UIControlStateNormal];
    [xiaoxi addTarget:self action:@selector(Xiaoxi) forControlEvents:UIControlEventTouchUpInside];
    [headview addSubview:xiaoxi];
    xiaoxi.sd_layout.rightSpaceToView(headview,autoScaleW(15)).topSpaceToView(headview,autoScaleH(20)).heightIs(autoScaleH(20)).widthIs(autoScaleW(20));
    
    UIButton * szBtn =[ UIButton new];
    [szBtn setBackgroundImage:[UIImage imageNamed:@"设置"] forState:UIControlStateNormal];
    [szBtn addTarget:self action:@selector(shezhi) forControlEvents:UIControlEventTouchUpInside];
    [headview addSubview:szBtn];
    szBtn.sd_layout.rightSpaceToView(xiaoxi,15).topSpaceToView(headview,autoScaleH(20)).heightIs(autoScaleH(20)).widthIs(autoScaleW(20));
    
    _headimageview =[[UIImageView alloc]init];
    _headimageview.userInteractionEnabled = YES;
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(Changebig)];
    [_headimageview addGestureRecognizer:tap];
   
    _headimageview.image = [UIImage imageNamed:@"头像"];
    
    _headimageview.layer.masksToBounds = YES;
    _headimageview.layer.cornerRadius = autoScaleW(42);
    [headimag addSubview:_headimageview];
    _headimageview.sd_layout.centerXEqualToView(headview).centerYEqualToView(headview).widthIs(kWidth(84)).heightIs(kHeight(84));
    
   
    
    
    _loginlabel =[[UILabel alloc]init];
   
     _loginlabel.text = @"点击登录";
    
    _loginlabel.textAlignment = NSTextAlignmentCenter;
    _loginlabel.font = [UIFont systemFontOfSize:autoScaleW(15)];
    _loginlabel.textColor = UIColorFromRGB(0x191919);
    _loginlabel.userInteractionEnabled = YES;
    UITapGestureRecognizer * tap1 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(Changebig)];
    [_loginlabel addGestureRecognizer:tap1];
    [headimag addSubview:_loginlabel];
    _loginlabel.sd_layout.centerXEqualToView(headview).topSpaceToView(_headimageview,kHeight(16)).widthIs(kWidth(170)).heightIs(kHeight(25));
    
    //表
    
    UITableView * MineTableview = [[UITableView alloc]init];
    MineTableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    MineTableview.delegate =self;
    MineTableview.dataSource= self;
    MineTableview.scrollEnabled = NO;
    MineTableview.tableHeaderView = headview;
    [self.view addSubview:MineTableview];
    MineTableview.sd_layout.leftSpaceToView(self.view,0).topSpaceToView(self.view,0).widthIs(GetWidth).heightIs(GetHeight-self.tabBarController.tabBar.frame.size.height);
    
    labelAry = @[@"最近浏览",@"今日推荐",];
    seclabelAry = @[@"投诉建议",@"关于我们",@"服务中心",];
    orderLabelAry = @[@"我的订单",@"我的钱包",@"我的资料",@"我的收藏",];

    imageAry = @[@"浏览-(1)",@"推荐-(1)",];
    secimageary = @[@"投诉",@"关于我们",@"服务-1",];
    orderImageAry = @[@"订单-(1)",@"钱包-(3)",@"data",@"收藏",];
    
}
#pragma mark 点击头像 放大缩小
-(void)Changebig
{
        
    if (islogin ==NO) {
        
        [self Login];
    }
    else
    {
        MyMaterialViewController * payview = [[MyMaterialViewController alloc]init];
        payview.bolck = ^(UIImage *image)
        {
            _headima = image;
            

            islogin = YES;
            
            
        };

        payview.tabBarController.tabBar.hidden = YES;
        [self.navigationController pushViewController:payview animated:NO];
    }
    
    
    
    
}
-(BOOL)prefersStatusBarHidden
{
    return YES;
}
#pragma mark 设置按钮回调
-(void)shezhi
{
    NSLog(@"Boonxiakalaka");
    
}
#pragma mark 消息按钮回调
-(void)Xiaoxi
{
    
    
    
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
        payview.tabBarController.tabBar.hidden = YES;
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
   
    return 3;
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
        
        if (indexPath.row==0) {
            
            for (int i =0; i <4; i++) {
                
                UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
                button.tag = 100+i;
                [button addTarget:self action:@selector(OrderBtn:) forControlEvents:UIControlEventTouchUpInside];
                [cell addSubview:button];
                button.sd_layout.leftSpaceToView(cell,kWidth(40)+i*kWidth(80)).topSpaceToView(cell,kHeight(10)).widthIs(kWidth(63)).heightIs(kHeight(50));
                UIImageView * orderimage = [[UIImageView alloc]init];
                orderimage.image = [UIImage imageNamed:orderImageAry[i]];
                [button addSubview:orderimage];
                orderimage.sd_layout.leftSpaceToView(button,kWidth(10)).topSpaceToView(button,0).widthIs(kWidth(21)).heightIs(kHeight(23));
                UILabel * orderlabel =[[UILabel alloc]init];
                orderlabel.font = [UIFont systemFontOfSize:autoScaleW(13)];
                orderlabel.textColor = UIColorFromRGB(0x6E6E6E);
                orderlabel.text = orderLabelAry[i];
                [button addSubview:orderlabel];
                orderlabel.sd_layout.leftSpaceToView(button,0).topSpaceToView(orderimage,kHeight(15)).widthIs(kWidth(63)).heightIs(kHeight(12));
            }

        }
        
        if (indexPath.row==1) {
            cell.backgroundColor =UIColorFromRGB(0xEEEEEE);
        }
    }
        if (indexPath.section==1) {
        
        if (indexPath.row==2) {
            cell.backgroundColor =UIColorFromRGB(0xEEEEEE);
        }
        else
        {
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
    }
    if (indexPath.section==2) {
        
        
            UIImageView  * imageview  = [[UIImageView alloc]init];
            imageview.image = [UIImage imageNamed:secimageary[indexPath.row]];
            [cell addSubview:imageview];
            imageview.sd_layout.leftSpaceToView(cell,kWidth(15)).topSpaceToView(cell,kHeight(10)).widthIs(kWidth(19)).heightIs(kHeight(19));
            
            UILabel * leftlabel = [[UILabel alloc]init];
            leftlabel.font = [UIFont systemFontOfSize:autoScaleW(14)];
            leftlabel.textColor = UIColorFromRGB(0x6E6E6E);
            leftlabel.text = seclabelAry [indexPath.row];
            [cell addSubview:leftlabel];
            leftlabel.sd_layout.leftSpaceToView(imageview,kWidth(5)).topSpaceToView(cell,kHeight(14)).widthIs(kWidth(100)).heightIs(kHeight(12));
            
            UIImageView * rightimage = [[UIImageView alloc]init];
            rightimage.image = [UIImage imageNamed:@"形状-3-拷贝"];
            [cell addSubview:rightimage];
            rightimage.sd_layout.rightSpaceToView(cell,kWidth(15)).topSpaceToView(cell,kHeight(15)).widthIs(kWidth(8)).heightIs(kHeight(11));
        
        
        
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
    if (indexPath.section==1) {
        
        if (indexPath.row==2) {
            return kHeight(20);
        }
    }
    
    
    
    return kHeight(45);
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//        if (indexPath.section==1) {
//        if (indexPath.row==0) {
//            
//            BrowseViewController * browseview =[[BrowseViewController alloc]init];
//            self.navigationController.navigationBar.hidden = NO;
//            
//            [self.navigationController pushViewController:browseview animated:NO];
//            
//         }
//        if (indexPath.row==1) {
//            
//            
//            PutViewController * putview = [[PutViewController alloc]init];
//            [self.navigationController pushViewController:putview animated:NO];
//            
//        }
//     }
//    if (indexPath.section==2)
//    {
//         if (indexPath.row==0)
//        {
//        
//            ToushuViewController * payview = [[ToushuViewController alloc]init];
//            payview.tabBarController.tabBar.hidden = YES;
//            [self.navigationController pushViewController:payview animated:NO];
//            
//        }
//        if (indexPath.row==1)
//        {
//            OursViewController * oursview = [[OursViewController alloc]init];
//            [self.navigationController pushViewController:oursview animated:NO];
//        }
//    }
}
#pragma mark 订单按钮回调

-(void)OrderBtn:(UIButton*)orderbtn
{
    if (orderbtn.tag==100) {
        
        MyorderViewController * myorderView = [[MyorderViewController alloc]init];
        self.navigationController.navigationBar.hidden = NO;
        [self.navigationController pushViewController:myorderView animated:NO];

    }
    if (orderbtn.tag ==101) {
        
        
//        MymoneyViewController * mymoney = [[MymoneyViewController alloc]init];
//        
//        self.tabBarController.tabBar.hidden = YES;
//        [self.navigationController pushViewController:mymoney animated:NO];
        
        MyWalletViewController * myWallet = [[MyWalletViewController alloc]init];
        self.tabBarController.tabBar.hidden = YES;
        [self.navigationController pushViewController:myWallet animated:YES];
    }
    if (orderbtn.tag ==102)
    {
//        MyMaterialViewController * payview = [[MyMaterialViewController alloc]init];
//        payview.headimage.image = _headimageview.image;
//        payview.titlelab.text = _loginBtn.titleLabel.text;
//        
//        payview.bolck = ^(UIImage *image,NSString * namestring)
//        {
//            _headima = image;
//            _namelabel = namestring;
//            islogin = YES;
//            
//            
//        };
//        payview.tabBarController.tabBar.hidden = YES;
//        [self.navigationController pushViewController:payview animated:NO];
        
    }
    if (orderbtn.tag==103) {
        ShoucangViewController * shoucangview =[[ShoucangViewController alloc]init];
        self.navigationController.navigationBar.hidden = NO;
        [self.navigationController pushViewController:shoucangview animated:NO];
        
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
