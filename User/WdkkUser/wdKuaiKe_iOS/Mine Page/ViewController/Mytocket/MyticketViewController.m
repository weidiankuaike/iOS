//
//  MyticketViewController.m
//  wdKuaiKe_iOS
//
//  Created by 张森森 on 16/12/21.
//  Copyright © 2016年 weiDianKuaiKe. All rights reserved.
//

#import "MyticketViewController.h"
#import "UIBarButtonItem+SSExtension.h"
#import "MBProgressHUD+SS.h"
#import "QYXNetTool.h"
#import "MyticketTableViewCell.h"
#import "NSObject+JudgeNull.h"
#import "MyticketModel.h"
@interface MyticketViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong)NSMutableArray * modelary;
@end

@implementation MyticketViewController

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = NO;
    self.tabBarController.tabBar.hidden = YES;
    self.navigationController.navigationBar.translucent = NO;

    [self.navigationController.navigationBar setBarTintColor:UIColorFromRGB(0xfd7577)];

}
- (void)viewDidLoad {
    [super viewDidLoad];

    UILabel * titlabel = [[UILabel alloc]init];
    titlabel.frame = CGRectMake(0, 0, 80, 30);
    titlabel.textAlignment = NSTextAlignmentCenter;
    titlabel.font = [UIFont systemFontOfSize:15];
    titlabel.text = @"我的卡券";
    titlabel.textColor = [UIColor whiteColor];
    self.navigationItem.titleView = titlabel;
    
    
    UIBarButtonItem * backbtn = [UIBarButtonItem itemWithTarget:self Action:@selector(Back) image:@"left-1" selectImage:nil];
    self.navigationItem.leftBarButtonItem = backbtn;
    
    _modelary = [NSMutableArray array];
    [MBProgressHUD showMessage:@"请稍等"];

     NSString * url = [NSString stringWithFormat:@"%@/api/user/searchMyConpon?token=%@&userId=%@",commonUrl,Token,Userid];
     NSArray * urlary = [url componentsSeparatedByString:@"?"];
     
     [[QYXNetTool shareManager]postNetWithUrl:urlary.firstObject urlBody:urlary.lastObject bodyStyle:QYXBodyString header:nil response:QYXJSON success:^(id result)
     
     
    {
        [MBProgressHUD hideHUD];
        NSLog(@"???%@",result);
        
        NSString * msgType = [NSString stringWithFormat:@"%@",result[@"msgType"]];
        if ([msgType isEqualToString:@"0"]) {
            NSArray * datavalue = [result objectForKey:@"obj"];
            
            for (int i =0; i<datavalue.count; i++) {
                
                MyticketModel * model = [[MyticketModel alloc]initWithGetstrWithdict: datavalue[i]];
                [_modelary addObject:model];
            }
            
            [self creatTableview];

        }else if ([msgType isEqualToString:@"2"]){
            
            [MBProgressHUD showError:@"你没有卡券"];
            [self Creatimge];
            
        }else if ([msgType isEqualToString:@"1"]){
            
            [MBProgressHUD showError:@"网络错误"];
        }
        
    } failure:^(NSError *error)
    {
        [MBProgressHUD hideHUD];
        [MBProgressHUD showError:@"网络错误"];
    }];
}
#pragma  mark 猫
-(void)Creatimge
{
    UIImageView * catimage = [[UIImageView alloc]init];
    catimage.image = [UIImage imageNamed:@"暂无数据"];
    [self.view addSubview:catimage];
    catimage.sd_layout.centerXEqualToView(self.view).centerYEqualToView(self.view).widthIs(autoScaleW(200)).heightIs(autoScaleH(200));
    
    
    
}
- (void)creatTableview{
    UITableView * tickettable = [[UITableView alloc]init];
    tickettable.delegate = self;
    tickettable.dataSource = self;
    tickettable.showsVerticalScrollIndicator = NO;
    tickettable.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:tickettable];
    tickettable.sd_layout.leftEqualToView(self.view).rightEqualToView(self.view).topSpaceToView(self.view,0).heightIs(GetHeight);
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _modelary.count;

}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
   MyticketTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"ticket"];
    if (!cell) {
        cell = [[MyticketTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ticket"];
    }
    cell.model = _modelary[indexPath.section];
    
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 10;
}
-(UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView * view = [[UIView alloc]init];
    view.backgroundColor = [UIColor clearColor];
    
    return view;
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
