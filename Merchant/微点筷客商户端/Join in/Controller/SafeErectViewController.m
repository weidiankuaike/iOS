//
//  SafeErectViewController.m
//  微点筷客商户端
//
//  Created by 张森森 on 16/10/25.
//  Copyright © 2016年 张森森. All rights reserved.
//

#import "SafeErectViewController.h"
#import "UIBarButtonItem+SSExtension.h"
#import "LoginTableViewCell.h"
#import "TixianViewController.h"
#import "PhoneyzViewController.h"
#import "ChangelogincodeViewController.h"
@interface SafeErectViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong)NSArray * titleary;

@end

@implementation SafeErectViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.titleView.text = @"安全设置";
    self.view.backgroundColor= RGB(242, 242, 242);
    self.automaticallyAdjustsScrollViewInsets = NO;

    
    CGFloat height = [[UIApplication sharedApplication] statusBarFrame].size.height + self.navigationController.navigationBar.frame.size.height;
    _titleary = @[@"修改登录密码",@"更改管理员手机号",@"提现设置",];
    
    UITableView*_yanzhengtableview = [[UITableView alloc]init];
    _yanzhengtableview.scrollEnabled = NO;
    _yanzhengtableview.delegate = self;
    _yanzhengtableview.dataSource = self;
    _yanzhengtableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_yanzhengtableview];
    _yanzhengtableview.sd_layout.leftSpaceToView(self.view,0).topSpaceToView(self.view,autoScaleH(15)+height).widthIs(kScreenWidth).heightIs(autoScaleH(45*_titleary.count));
    
    
       
    
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    LoginTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"safe"];
    
    if (!cell) {
        cell = [[LoginTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"safe"];
    }
    UILabel * linlab =[[UILabel alloc]init];
    linlab.backgroundColor = UIColorFromRGB(0xeeeeee);
    [cell addSubview:linlab];
    linlab.sd_layout.leftSpaceToView(cell,0).rightSpaceToView(cell,0).bottomSpaceToView(cell,0).heightIs(0.5);
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    
    cell.textfild.hidden = YES;
    cell.leftlabel.text = _titleary[indexPath.row];
    
    
    
    UIImageView * rightimage = [[UIImageView alloc]init];
    rightimage.image = [UIImage imageNamed:@"形状-3-拷贝"];
    [cell addSubview:rightimage];
    rightimage.sd_layout.rightSpaceToView(cell,autoScaleW(15)).topSpaceToView(cell,autoScaleH(15)).widthIs(autoScaleW(8)).heightIs(autoScaleH(11));
    
    
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return autoScaleH(45);
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row==2) {
        
        TixianViewController * tixianview = [[TixianViewController alloc]init];
        
        [self.navigationController pushViewController:tixianview animated:YES];
        
    }
    if (indexPath.row==1) {
        
        PhoneyzViewController * phoneView = [[PhoneyzViewController alloc]init];
        phoneView.phonestr = @"8888888888";
        phoneView.tiaointeger = 1;
        [self.navigationController pushViewController:phoneView animated:YES];
        
    }
    if (indexPath.row==0) {
        
        ChangelogincodeViewController * changecode = [[ChangelogincodeViewController alloc]init];
        [self.navigationController pushViewController:changecode animated:YES];
    }
    
    
    
}


-(void)leftBarButtonItemAction
{
    [self.navigationController popViewControllerAnimated:YES];
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
