//
//  MyWalletViewController.m
//  wdKuaiKe_iOS
//
//  Created by 张森森 on 16/9/19.
//  Copyright © 2016年 weiDianKuaiKe. All rights reserved.
//

#import "MyWalletViewController.h"
#import "UIBarButtonItem+SSExtension.h"
#import "MBProgressHUD+SS.h"
#import "QYXNetTool.h"
#import "NSObject+JudgeNull.h"
#import "Mywalletmodel.h"
#import "MywalletTableViewCell.h"
#import "MyWithdrawViewController.h"
@interface MyWalletViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong)UIScrollView * scrollview;
@property (nonatomic,assign)NSInteger kainteger;
@property (nonatomic,strong)NSMutableArray * modelary;
@property (nonatomic,copy)NSString * iswithdraw;
@property (nonatomic,assign)double balance;
@end

@implementation MyWalletViewController

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = NO;
    self.navigationController.navigationBar.translucent = NO;
    [self.navigationController.navigationBar setBarTintColor:UIColorFromRGB(0xfd7577)];
    self.tabBarController.tabBar.hidden = YES;
    [self getData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = RGB(238, 238, 238);
    UILabel * titlabel = [[UILabel alloc]init];
    titlabel.frame = CGRectMake(0, 0, 80, 30);
    titlabel.textAlignment = NSTextAlignmentCenter;
    titlabel.font = [UIFont systemFontOfSize:15];
    titlabel.text = @"我的钱包";
    titlabel.textColor = [UIColor whiteColor];
    self.navigationItem.titleView = titlabel;
    
    UIBarButtonItem * backbtn = [UIBarButtonItem itemWithTarget:self Action:@selector(leftclick) image:@"left-1" selectImage:nil];
    self.navigationItem.leftBarButtonItem = backbtn;
    
}
- (void)getData{
    
    [MBProgressHUD showMessage:@"请稍等"];
    NSString * url = [NSString stringWithFormat:@"%@/api/user/AccountManage?token=%@&userId=%@&op=0",commonUrl,Token,Userid];
    NSArray * urlary = [url componentsSeparatedByString:@"?"];
    
    [[QYXNetTool shareManager]postNetWithUrl:urlary.firstObject urlBody:urlary.lastObject bodyStyle:QYXBodyString header:nil response:QYXJSON success:^(id result)
     {
         
         [MBProgressHUD hideHUD];
         
         NSLog(@">>>>%@",result);
         if (![[result objectForKey:@"obj"] isNull]) {
             
             NSDictionary * datadict = [result objectForKey:@"obj"];
             _iswithdraw = [NSString stringWithFormat:@"%@",[datadict objectForKey:@"isWithdraw"]];
             
             NSString * balanceStr = [NSString stringWithFormat:@"%@",[datadict objectForKey:@"mybalance"]] ;
             _balance = [balanceStr doubleValue];
             [self creatView];

             if (![[datadict objectForKey:@"myAccountDets"]isNull]) {
                 
                 NSArray * ary = [datadict objectForKey:@"myAccountDets"];
                 for (int i =0; i<ary.count; i++) {
                     
                     Mywalletmodel * model = [[Mywalletmodel alloc]initWithgetstrWithdict:ary[i]];
                     [_modelary addObject:model];
                     
                 }
                 [self Creattable];
             }
         }else{
             //            [MBProgressHUD showError:@""];
         }
         
     } failure:^(NSError *error)
     {
         [MBProgressHUD hideHUD];
         [MBProgressHUD showError:@"网络错误"];
     }];
    

}
- (void)creatView{
    
    UIView * headview = [[UIView alloc]init];
    headview.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:headview];
    headview.sd_layout.leftEqualToView(self.view).rightEqualToView(self.view).topSpaceToView(self.view,autoScaleH(10)).heightIs(autoScaleH(160));
    
    UILabel * firstlabel = [[UILabel alloc]init];
    firstlabel.text = @"账户余额";
    firstlabel.font = [UIFont systemFontOfSize:autoScaleW(15)];
    firstlabel.textColor = UIColorFromRGB(0x737373);
    [headview addSubview:firstlabel];
    firstlabel.sd_layout.leftSpaceToView(headview,autoScaleW(90)).centerYEqualToView(headview).widthIs(autoScaleW(70)).heightIs(15);
    
    UILabel * moneylabel = [[UILabel alloc]init];
    moneylabel.font = [UIFont systemFontOfSize:autoScaleW(20)];
    moneylabel.textColor = UIColorFromRGB(0x000000);
    [headview addSubview:moneylabel];
    moneylabel.sd_layout.leftSpaceToView(firstlabel,autoScaleW(15)).centerYEqualToView(headview).heightIs(autoScaleH(20));
    
    UIButton * tixianbtn = [UIButton buttonWithType:UIButtonTypeCustom];
    tixianbtn.backgroundColor = [UIColor lightGrayColor];
    [tixianbtn setTitle:@"提现" forState:UIControlStateNormal];
    tixianbtn.userInteractionEnabled = NO;
    tixianbtn.layer.masksToBounds = YES;
    tixianbtn.layer.cornerRadius = 3;
    tixianbtn.titleLabel.font = [UIFont systemFontOfSize:autoScaleW(15)];
    [tixianbtn addTarget:self action:@selector(Withdraw) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:tixianbtn];
    tixianbtn.sd_layout.leftSpaceToView(self.view,autoScaleW(15)).rightSpaceToView(self.view,autoScaleW(15)).heightIs(autoScaleH(40)).topSpaceToView(headview,autoScaleH(10));
    _modelary = [NSMutableArray array];
    moneylabel.text = [NSString stringWithFormat:@"%.2f",_balance];
    [moneylabel setSingleLineAutoResizeWithMaxWidth:200];
    if (_balance>0)
    {
        tixianbtn.userInteractionEnabled = YES;
        tixianbtn.backgroundColor = UIColorFromRGB(0xfd7577);
    }


}
#pragma mark 提现
-(void)Withdraw
{
    if ([_iswithdraw isEqualToString:@"0"])
    {
        MyWithdrawViewController * mywithdrawview = [[MyWithdrawViewController alloc]init];
        mywithdrawview.moneystr = [NSString stringWithFormat:@"%.2f",_balance];
        [self.navigationController pushViewController:mywithdrawview animated:YES];
        
        
    }
    else if ([_iswithdraw isEqualToString:@"1"])
    {
        [MBProgressHUD showError:@"今天提现权限已用完"];
    }
    
}
#pragma mark 创建表
-(void)Creattable
{
    
    UIView * bootomview = [[UIView alloc]init];
    bootomview.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:bootomview];
    bootomview.sd_layout.leftEqualToView(self.view).rightEqualToView(self.view).topSpaceToView(self.view,autoScaleH(230)).heightIs(self.view.frame.size.height-autoScaleH(220));
    
    UILabel * titlelabel = [[UILabel alloc]init];
    titlelabel.font = [UIFont systemFontOfSize:autoScaleW(13)];
    titlelabel.text = @"近30天收支记录";
    titlelabel.textColor = UIColorFromRGB(0x000000);
    [bootomview addSubview:titlelabel];
    titlelabel.sd_layout.centerXEqualToView(bootomview).topSpaceToView(bootomview,autoScaleH(15)).heightIs(autoScaleH(15));
    [titlelabel setSingleLineAutoResizeWithMaxWidth:150];
    
    CGFloat wind = titlelabel.frame.size.width;
    NSLog(@">>>%f",wind);
    for (int i=0; i<2; i++) {
        UILabel * linelabel = [[UILabel alloc]init];
        linelabel.backgroundColor = UIColorFromRGB(0xbfbfbf);
        [bootomview addSubview:linelabel];
        linelabel.sd_layout.leftSpaceToView(bootomview,i*((GetWidth-autoScaleW(120))/2+autoScaleW(120))).topSpaceToView(bootomview,autoScaleH(20)).widthIs((GetWidth-autoScaleW(120))/2).heightIs(1);
      }
    
    
    UITableView * moneytable = [[UITableView alloc]init];
    moneytable.delegate = self;
    moneytable.dataSource = self;
    moneytable.showsVerticalScrollIndicator = NO;
    moneytable.separatorStyle = UITableViewCellSeparatorStyleNone;
    [bootomview addSubview:moneytable];
    moneytable.sd_layout.leftSpaceToView(bootomview,autoScaleW(15)).rightSpaceToView(bootomview,autoScaleW(15)).topSpaceToView(titlelabel,autoScaleH(15)).heightIs(bootomview.frame.size.height-autoScaleH(45));
    
    
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _modelary.count;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MywalletTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"wallet"];
    if (!cell) {
        cell = [[MywalletTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"wallet"];
    }
    
    UILabel * linelabel = [[UILabel alloc]init];
    linelabel.backgroundColor = UIColorFromRGB(0xeeeeee);
    [cell addSubview:linelabel];
    linelabel.sd_layout.leftEqualToView(cell).rightEqualToView(cell).bottomEqualToView(cell).heightIs(1);
    
    cell.model = _modelary[indexPath.row];
    
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 75;
}

-(void)leftclick
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
