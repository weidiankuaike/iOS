//
//  ToushuViewController.m
//  wdKuaiKe_iOS
//
//  Created by 张森森 on 16/9/21.
//  Copyright © 2016年 weiDianKuaiKe. All rights reserved.
//

#import "ToushuViewController.h"
#import "UIBarButtonItem+SSExtension.h"
#import "NewFeedbackViewController.h"
@interface ToushuViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong)NSArray * titleary;
@end

@implementation ToushuViewController
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = NO;
    self.tabBarController.tabBar.hidden = YES;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = UIColorFromRGB(0xffffff);
    UIBarButtonItem * leftback = [UIBarButtonItem itemWithTarget:self Action:@selector(Back) image:@"形状-1" selectImage:nil];
    UIBarButtonItem * yuebtn = [UIBarButtonItem itemWithTarget:self Action:@selector(Back) andTitle:@"投诉意见"];
    self.navigationItem.leftBarButtonItems = @[leftback,yuebtn];
    CGFloat height = [[UIApplication sharedApplication] statusBarFrame].size.height + self.navigationController.navigationBar.frame.size.height;
    
    UITableView * toushutable = [[UITableView alloc]init];
    toushutable.separatorStyle = UITableViewCellSeparatorStyleNone;
    toushutable.delegate = self;
    toushutable.dataSource = self;
    [self.view addSubview:toushutable];
    toushutable.sd_layout.leftSpaceToView(self.view,0).topSpaceToView(self.view,0).widthIs(self.view.frame.size.width).heightIs(self.view.frame.size.height - height);
    
    _titleary = @[@"意见反馈",@"常见问题",@"网络诊断",];
    
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return 3;
    
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"tou"];
    if (!cell) {
        
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"tou"];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    UILabel * linlabel = [[UILabel alloc]init];
    linlabel.backgroundColor = RGB(230, 230, 230);
    [cell addSubview:linlabel];
    linlabel.sd_layout.leftSpaceToView(cell,0).rightSpaceToView(cell,0).bottomSpaceToView(cell,0).heightIs(autoScaleH(1));
    
    UILabel * titlelab = [[UILabel alloc]init];
    titlelab.text = _titleary[indexPath.row];
    titlelab.font = [UIFont systemFontOfSize:autoScaleW(15)];
    [cell addSubview:titlelab];
    titlelab.sd_layout.leftSpaceToView(cell,autoScaleW(15)).topSpaceToView(cell,autoScaleH(15)).widthIs(autoScaleW(100)).heightIs(autoScaleH(15));
    
    
    
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.row ==0) {
        NewFeedbackViewController * feedbackview = [[NewFeedbackViewController alloc]init];
        [self.navigationController pushViewController:feedbackview animated:YES];
        
    }
}
-(void)Back
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
