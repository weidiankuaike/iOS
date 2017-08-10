//
//  ErectViewController.m
//  wdKuaiKe_iOS
//
//  Created by 张森森 on 17/1/10.
//  Copyright © 2017年 weiDianKuaiKe. All rights reserved.
//

#import "ErectViewController.h"
#import "UIBarButtonItem+SSExtension.h"
#import "LoginTableViewCell.h"
#import "LoginViewController.h"
#import "AppDelegate.h"
#import "MBProgressHUD+SS.h"
#import "AboutUsVC.h"
@interface ErectViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong)NSArray * lefttitary;
@property (nonatomic,strong)UILabel * fileSize;
@end

@implementation ErectViewController
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = NO;
    self.navigationController.navigationBar.translucent = NO;
    [self.navigationController.navigationBar setBarTintColor:UIColorFromRGB(0xfd7577)];
    self.tabBarController.tabBar.hidden = YES;
    
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
//    [self.navigationController popToRootViewControllerAnimated:YES];
//    NSMutableArray *vcs = [self.navigationController.viewControllers mutableCopy];
//    [vcs removeAllObjects];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = RGB(238, 238, 238);
    UILabel * titlabel = [[UILabel alloc]init];
    titlabel.frame = CGRectMake(0, 0, 80, 30);
    titlabel.textAlignment = NSTextAlignmentCenter;
    titlabel.font = [UIFont systemFontOfSize:15];
    titlabel.text = @"设置";
    titlabel.textColor = [UIColor whiteColor];
    self.navigationItem.titleView = titlabel;
    UIBarButtonItem * backbtn = [UIBarButtonItem itemWithTarget:self Action:@selector(Back) image:@"left-1" selectImage:nil];
    self.navigationItem.leftBarButtonItem = backbtn;
    
    UITableView * erecttable = [[UITableView alloc]init];
    erecttable.delegate = self;
    erecttable.dataSource = self;
    erecttable.scrollEnabled = NO;
    erecttable.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:erecttable];
    erecttable.sd_layout.leftEqualToView(self.view).rightEqualToView(self.view).topEqualToView(self.view).heightIs(110);
    
    _lefttitary = @[@"清理缓存",@"关于我们"];
    
    UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:@"退出登录" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//    button.titleLabel.font = [UIFont systemFontOfSize:autoScaleW(15)];
    button.backgroundColor = UIColorFromRGB(0xfd7577);
    [button addTarget:self action:@selector(Logout) forControlEvents:UIControlEventTouchUpInside];
    button.layer.cornerRadius = 3;
    [self.view addSubview:button];
    button.sd_layout.leftSpaceToView(self.view,autoScaleW(15)).rightSpaceToView(self.view,autoScaleW(15)).topSpaceToView(erecttable,autoScaleH(50)).heightIs(autoScaleH(40));
    
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    LoginTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"erect"];
    if (!cell) {
        
        cell = [[LoginTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"erect"];
    }
    cell.selectionStyle = 0;
    cell.textfild.hidden = YES;
    cell.leftlabel.text = _lefttitary[indexPath.section];
    if (indexPath.section==0) {
        if (indexPath.row==0) {
            UILabel * sizeLabel = [[UILabel alloc]init];
            sizeLabel.textColor = [UIColor blackColor];
            sizeLabel.textAlignment = NSTextAlignmentRight;
            sizeLabel.font = [UIFont systemFontOfSize:13];
            [cell addSubview:sizeLabel];
            sizeLabel.sd_layout.rightSpaceToView(cell,autoScaleW(15)).topSpaceToView(cell,autoScaleH(15)).widthIs(autoScaleW(100)).heightIs(autoScaleH(15));
            _fileSize = sizeLabel;
            [self getSize];
        }
        
    }
    return cell;
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10;
}
#pragma mark 退出
-(void)Logout
{
    
//    [(AppDelegate *)[UIApplication sharedApplication].delegate showWindowHome:@"loginOut"];
    LoginViewController * loginviewcontroller = [[LoginViewController alloc]init];
    loginviewcontroller.putInt = 1;
    [self.navigationController pushViewController: loginviewcontroller animated:YES];
    
    
    NSUserDefaults * userde = [NSUserDefaults standardUserDefaults];
    
    [userde removeObjectForKey:@"idd"];
    [userde removeObjectForKey:@"loginName"];
    [userde removeObjectForKey:@"name"];
    [userde removeObjectForKey:@"token"];
    [userde removeObjectForKey:@"headimage"];
    [userde removeObjectForKey:@"save"];
    [userde synchronize];
    
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0) {
        if (indexPath.row==0) {
            
            [MBProgressHUD showMessage:@"请稍等"];
            [[SDImageCache sharedImageCache] clearDiskOnCompletion:^{
                dispatch_async(dispatch_get_global_queue(0, 0), ^{
                    NSUserDefaults * userde = [NSUserDefaults standardUserDefaults];
                
                    [userde removeObjectForKey:@"save"];
                    [userde synchronize];

                   
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        
                        [MBProgressHUD hideHUD];
                        // 设置文字
                        self.fileSize.text = @"已清理";
                    });
                });
            }];
        }
    }else if (indexPath.section==1){
        
        if (indexPath.row==0) {
            
            AboutUsVC * aboutvc = [[AboutUsVC alloc]init];
            [self.navigationController pushViewController:aboutvc animated:YES];
        }
    }
    
    
    
}
- (void)getSize{
    //        NSString *path =
    //        [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES).lastObject stringByAppendingPathComponent:@"Documents"];
    //         unsigned long long size = [[NSFileManager defaultManager] attributesOfItemAtPath:path error:nil].fileSize;
    //fileSize是封装在Category中的。
    
    unsigned long long size = [SDImageCache sharedImageCache].getSize; //CustomFile + SDWebImage 缓存
    
    //设置文件大小格式
    NSString *sizeText = nil;
    if (size >= pow(10, 9)) {
        sizeText = [NSString stringWithFormat:@"%.2fGB", size / pow(10, 9)];
    }else if (size >= pow(10, 6)) {
        sizeText = [NSString stringWithFormat:@"%.2fMB", size / pow(10, 6)];
    }else if (size >= pow(10, 3)) {
        sizeText = [NSString stringWithFormat:@"%.2fKB", size / pow(10, 3)];
    }else {
        sizeText = [NSString stringWithFormat:@"%zdB", size];
    }
    _fileSize.text = sizeText;
    NSLog(@">>>>%@",sizeText);

}
- (void)Back{
    
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
