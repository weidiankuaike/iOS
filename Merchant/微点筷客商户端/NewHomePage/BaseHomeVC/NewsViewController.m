//
//  NewsViewController.m
//  微点筷客商户端
//
//  Created by 张森森 on 16/10/26.
//  Copyright © 2016年 张森森. All rights reserved.
//

#import "NewsViewController.h"
#import "UIBarButtonItem+SSExtension.h"
#import "NewsTableViewCell.h"
@interface NewsViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong)NSArray *typeary;
@property (nonatomic,strong)NSArray * titleary;

@end

@implementation NewsViewController
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = NO;
    self.tabBarController.tabBar.hidden = YES;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    self.titleView.text = @"消息列表";
    self.view.backgroundColor = RGB(242, 242, 242);

    
    CGFloat height = [[UIApplication sharedApplication] statusBarFrame].size.height + self.navigationController.navigationBar.frame.size.height;
    
    UITableView * newstableview = [[UITableView alloc]init];
    newstableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    newstableview.delegate = self;
    newstableview.dataSource = self;
    [self.view addSubview:newstableview];
    newstableview.sd_layout.leftSpaceToView(self.view,0).topSpaceToView(self.view,height).widthIs(kScreenWidth).heightIs(kScreenHeight -height-autoScaleH(100));
    
    _titleary = @[@"订单订单订单订单订单订单",@"不是订单不是订单不是订单",@"不是订单不是订单不是订单不是订单",@"不是订单不是订单不是订单不是订单",@"订单订单订单订单订单订单",@"13546512465464",];
    _typeary = @[@"1",@"1",@"2",@"2",@"1",@"2",];
    
    ButtonStyle * clickbtn = [[ButtonStyle alloc]init];
    [clickbtn setTitle:@"查看全部" forState:UIControlStateNormal];
    [clickbtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    clickbtn.titleLabel.font = [UIFont systemFontOfSize:autoScaleW(12)];
    [clickbtn addTarget:self action:@selector(Quanbu) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:clickbtn];
    clickbtn.sd_layout.centerXEqualToView(self.view).topSpaceToView(newstableview,autoScaleH(15)).widthIs(autoScaleW(55)).heightIs(autoScaleH(15));

}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _newsarray.count;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NewsTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"news"];
    if (!cell) {
        
        cell = [[NewsTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"news"];
    }
    
    ButtonStyle * lookbtn = [ButtonStyle buttonWithType:UIButtonTypeCustom];
    [lookbtn setTitle:@"查看" forState:UIControlStateNormal];
    [lookbtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    lookbtn.titleLabel.font = [UIFont systemFontOfSize:13];
    [lookbtn addTarget:self action:@selector(Look:event:) forControlEvents:UIControlEventTouchUpInside];
    [cell addSubview:lookbtn];
    lookbtn.sd_layout.rightSpaceToView(cell,autoScaleW(15)).topSpaceToView(cell,autoScaleH(15)).widthIs(autoScaleW(30)).heightIs(autoScaleH(20));
    NSString * typstr = _typeary[indexPath.row];
    if ([typstr isEqualToString:@"1"]) {
        cell.headimage.image = [UIImage imageNamed:@"q"];
    } else {
        cell.headimage.image = [UIImage imageNamed:@"dsa"];
    }
    cell.timelabel.text = @"10-23 17:00";
    cell.detailabel.text = _titleary[indexPath.row];
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return autoScaleH(45);
}

-(void)Look:(ButtonStyle *)btn event:(id)event
{
    
    
    
}

-(void)leftBarButtonItemAction
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
-(void)Change
{
    
    
    
}
-(void)Quanbu
{
    
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
