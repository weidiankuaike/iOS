//
//  ServeCenterViewController.m
//  wdKuaiKe_iOS
//
//  Created by 张森森 on 17/1/13.
//  Copyright © 2017年 weiDianKuaiKe. All rights reserved.
//

#import "ServeCenterViewController.h"
#import "UIBarButtonItem+SSExtension.h"
#import "ServicedetailViewController.h"
#import "MBProgressHUD+SS.h"
@interface ServeCenterViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong)NSArray * titary;
@end

@implementation ServeCenterViewController
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
    titlabel.text = @"服务中心";
    titlabel.textColor = [UIColor whiteColor];
    self.navigationItem.titleView = titlabel;
    UIBarButtonItem * backbtn = [UIBarButtonItem itemWithTarget:self Action:@selector(Back) image:@"left-1" selectImage:nil];
    self.navigationItem.leftBarButtonItem = backbtn;
    
    
    _titary = @[@"预定订单取消后，如何退款？",@"到店后，商家并未为我预留位置？",@"为什么我的账号无法预定？",@"排队领号后，怎么到店用餐？",@"我所领到的优惠卡券如何使用？",@"钱包里的余额如何提现？"];
    
    [self Creatheadview];
    [self Creattableview];
    
}
#pragma mark 头视图
- (void)Creatheadview
{
    UIView * headview = [[UIView alloc]init];
    headview.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:headview];
    headview.sd_layout.leftEqualToView(self.view).rightEqualToView(self.view).topEqualToView(self.view).heightIs(autoScaleH(120));
    
    NSArray * imageary = @[@"客服QQ",@"客服电话"];
    
    for (int i=0; i<2; i++) {
        
        UIButton * servebtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [servebtn setBackgroundImage:[UIImage imageNamed:imageary[i]] forState:UIControlStateNormal];
        servebtn.tag = 5000+i;
        [servebtn addTarget:self action:@selector(Service:) forControlEvents:UIControlEventTouchUpInside];
        [headview addSubview:servebtn];
        servebtn.sd_layout.leftSpaceToView(headview,(GetWidth/2 - autoScaleW(60))/2 +i*(GetWidth/2)).topSpaceToView(headview,autoScaleH(30)).widthIs(autoScaleW(60)).heightIs(autoScaleW(60));
        
    }
    UILabel * firstlinelabel = [[UILabel alloc]init];
    firstlinelabel.backgroundColor = UIColorFromRGB(0xeeeeee);
    [headview addSubview:firstlinelabel];
    firstlinelabel.sd_layout.centerYEqualToView(headview).topEqualToView(headview).widthIs(1).heightIs(autoScaleH(120));
    
    UILabel * secondlabel = [[UILabel alloc]init];
    secondlabel.backgroundColor = UIColorFromRGB(0xeeeeee);
    [headview addSubview:secondlabel];
    secondlabel.sd_layout.leftEqualToView(headview).rightEqualToView(headview).bottomEqualToView(headview).heightIs(1);

}
#pragma mark 问题列表
- (void)Creattableview
{
    UITableView * questiontable = [[UITableView alloc]init];
    questiontable.scrollEnabled = NO;
    questiontable.delegate = self;
    questiontable.dataSource = self;
    questiontable.separatorStyle = 0;
    [self.view addSubview:questiontable];
    questiontable.sd_layout.leftEqualToView(self.view).rightEqualToView(self.view).topSpaceToView(self.view,autoScaleH(120)).heightIs(GetHeight - autoScaleH(120));
    
    
    
}
#pragma mark 数据源方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _titary.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"sec"];
    if (!cell) {
        
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"sec"];
    }
    
    UILabel * leftlabel = [[UILabel alloc]init];
    leftlabel.font = [UIFont systemFontOfSize:autoScaleW(15)];
    leftlabel.text = _titary[indexPath.row];
    leftlabel.textColor = [UIColor blackColor];
    [cell addSubview:leftlabel];
    leftlabel.sd_layout.leftSpaceToView(cell,15).topSpaceToView(cell,15).heightIs(15);
    [leftlabel setSingleLineAutoResizeWithMaxWidth:300];
     cell.selectionStyle = 0;
    
    UILabel * linelabel = [[UILabel alloc]init];
    linelabel.backgroundColor  = UIColorFromRGB(0xeeeeee);
    [cell addSubview:linelabel];
    linelabel.sd_layout.leftEqualToView(cell).rightEqualToView(cell).bottomEqualToView(cell).heightIs(1);
    
    
    return cell;
}
#pragma mark 区头
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 30;
    
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView * headsecion = [[UIView alloc]init];
   
    UILabel * titlelabel = [[UILabel alloc]init];
    titlelabel.text = @"常见问题";
    titlelabel.textColor = [UIColor blackColor];
    titlelabel.font = [UIFont systemFontOfSize:autoScaleW(15)];
    [headsecion addSubview:titlelabel];
    titlelabel.sd_layout.centerXEqualToView(headsecion).topSpaceToView(headsecion,autoScaleH(7)).widthIs(70).heightIs(autoScaleH(15));
    
    return headsecion;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    ServicedetailViewController * servicetail = [[ServicedetailViewController alloc]init];
//    [self.navigationController pushViewController:servicetail animated:YES];
    
    [MBProgressHUD showSuccess:@"请联系客服"];
}
#pragma mark 返回
- (void)Back
{
    
    [self.navigationController popViewControllerAnimated:YES];
    
    
}
#pragma mark 客服和服务
- (void)Service:(UIButton*)btn{
    if (btn.tag==5000) {
        UIWebView *webView = [[UIWebView alloc] initWithFrame:CGRectZero];
        NSURL *url = [NSURL URLWithString:@"mqq://im/chat?chat_type=wpa&uin=310868425&version=1&src_type=web"];
        NSURLRequest *request = [NSURLRequest requestWithURL:url];
        [webView loadRequest:request];
        [self.view addSubview:webView];
        
        
        
    }else if (btn.tag==5001){
        
        
        
        NSMutableString * str = [[NSMutableString alloc]initWithFormat:@"tel:%@",@"4000865552"];
        UIWebView *callWebview = [[UIWebView alloc]init];
        [callWebview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:str]]];
        [self.view addSubview:callWebview];
        
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
