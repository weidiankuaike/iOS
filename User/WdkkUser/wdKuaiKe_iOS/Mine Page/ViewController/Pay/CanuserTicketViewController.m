//
//  CanuserTicketViewController.m
//  wdKuaiKe_iOS
//
//  Created by 张森森 on 16/12/30.
//  Copyright © 2016年 weiDianKuaiKe. All rights reserved.
//

#import "CanuserTicketViewController.h"
#import "UIBarButtonItem+SSExtension.h"
#import "NSObject+JudgeNull.h"
#import "MyticketTableViewCell.h"
#import "MBProgressHUD+SS.h"
#import "MyticketModel.h"
@interface CanuserTicketViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong)NSMutableArray * modelary;
@end

@implementation CanuserTicketViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = RGB(238, 238, 238);
    UILabel * titlabel = [[UILabel alloc]init];
    titlabel.frame = CGRectMake(0, 0, 80, 30);
    titlabel.textAlignment = NSTextAlignmentCenter;
    titlabel.font = [UIFont systemFontOfSize:15];
    titlabel.text = @"可使用卡券";
    titlabel.textColor = [UIColor whiteColor];
    self.navigationItem.titleView = titlabel;
    UIBarButtonItem * backbtn = [UIBarButtonItem itemWithTarget:self Action:@selector(Back) image:@"left-1" selectImage:nil];
    self.navigationItem.leftBarButtonItem = backbtn;

    
    UITableView * usertickettable = [[UITableView alloc]init];
    usertickettable.delegate = self;
    usertickettable.dataSource = self;
    [usertickettable registerClass:[MyticketTableViewCell class] forCellReuseIdentifier:@"user"];
    usertickettable.frame = self.view.bounds;
    [self.view addSubview:usertickettable];
    
    _modelary = [NSMutableArray array];
    for (int i=0; i<_listary.count; i++) {
        
        MyticketModel * model = [[MyticketModel alloc]initWithGetstrWithdict:_listary[i]];
        [_modelary addObject:model];
        
    }
    
    
    
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return _listary.count;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MyticketTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"user"];
    
    cell.model = _modelary[indexPath.row];
    
    
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

-(void)getsomethingwithblock:(userblock)block{
    
    self.blck = block;
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    MyticketModel * model = _modelary[indexPath.row];
    if ([model.cardtype isEqualToString:@"0"]) {
        
        self.blck(model.namestr,model.discount,model.cardId);

    }
    else if ([model.cardtype isEqualToString:@"1"])
    {
        NSString * moentystr = [NSString stringWithFormat:@"%.1f折",[model.discount floatValue]*10];
        
        self.blck (model.namestr,moentystr,model.cardId);
        
    }
    [self.navigationController popViewControllerAnimated:YES];
    
    
    
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
