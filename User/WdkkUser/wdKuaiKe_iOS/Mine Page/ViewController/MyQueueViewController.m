//
//  MyQueueViewController.m
//  wdKuaiKe_iOS
//
//  Created by 张森森 on 2017/7/3.
//  Copyright © 2017年 weiDianKuaiKe. All rights reserved.
//

#import "MyQueueViewController.h"
#import "UIBarButtonItem+SSExtension.h"
#import "MyqueueTableViewCell.h"
#import "QueueDetailViewController.h"
@interface MyQueueViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong)UIButton * daitibtn;
@property (nonatomic,strong)UILabel * linelabell;
@end

@implementation MyQueueViewController
-(void)viewWillAppear:(BOOL)animated{
    
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
    titlabel.text = @"我的排号";
    titlabel.textColor = [UIColor whiteColor];
    self.navigationItem.titleView = titlabel;
    UIBarButtonItem * backbtn = [UIBarButtonItem itemWithTarget:self Action:@selector(Back) image:@"left-1" selectImage:nil];
    self.navigationItem.leftBarButtonItem = backbtn;
    
    NSArray * choosetitle = @[@"正在排号",@"历史排号"];
    for (int i=0; i<choosetitle.count; i++) {
        UIButton * choosebtn = [[UIButton alloc]init];
        choosebtn.titleLabel.font = [UIFont systemFontOfSize:autoScaleW(16)];
        [choosebtn setTitle:choosetitle[i] forState:UIControlStateNormal];
        [choosebtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        [choosebtn setTitleColor:UIColorFromRGB(0xfd7577) forState:UIControlStateSelected];
        [choosebtn setBackgroundColor:[UIColor whiteColor]];
        choosebtn.tag = 300+i;
        [choosebtn addTarget:self action:@selector(Choose:) forControlEvents:UIControlEventTouchUpInside];
        
        
        if (i==0) {
            
            UILabel * linelabel = [[UILabel alloc]init];
            linelabel.backgroundColor = UIColorFromRGB(0xeeeeee);
            [choosebtn addSubview:linelabel];
            linelabel.sd_layout.rightSpaceToView(choosebtn,0).topSpaceToView(choosebtn,autoScaleH(10)).widthIs(1).heightIs(autoScaleH(30));
            
        }
        if (i==0) {
            choosebtn.selected = YES;
            _daitibtn = choosebtn;
        }
        [self.view addSubview:choosebtn];
        choosebtn.sd_layout.leftSpaceToView(self.view,+i*(GetWidth/2)).topSpaceToView(self.view,0).widthIs(GetWidth/2).heightIs(autoScaleH(50));
    }
    
    _linelabell = [[UILabel alloc]init];
    _linelabell.backgroundColor = UIColorFromRGB(0xfd7577);
    _linelabell.frame = CGRectMake(GetWidth/8,autoScaleH(48), GetWidth/4, 1.5);
    [self.view addSubview:_linelabell];
    
    
    UITableView * queueTableview = [[UITableView alloc]init];
    queueTableview.separatorStyle = 0;
    queueTableview.delegate = self;
    queueTableview.dataSource = self;
    queueTableview.backgroundColor = [UIColor clearColor];
    [self.view addSubview:queueTableview];
    queueTableview.sd_layout.leftEqualToView(self.view).rightEqualToView(self.view).topSpaceToView(self.view, autoScaleH(65)).heightIs(self.view.frame.size.height-autoScaleH(65));
    
    
    
    
 
}
-(void)Choose:(UIButton * )btn
{
    _daitibtn.selected = NO;
    btn.selected = YES;
    
    _daitibtn = btn;
//    _change = YES;
    
    if (btn.tag==300) {
        _linelabell.frame = CGRectMake(GetWidth/8,autoScaleH(48), GetWidth/4, 1.5);
        
//        _typestr = @"0";
        
//        [self CreatAf:YES];
    }
    if (btn.tag==301) {
        
        _linelabell.frame = CGRectMake(GetWidth/8*5, autoScaleH(48), GetWidth/4, 1.5);
        
//        _typeint = 2;
//        _typestr = @"1";
        
//        [self CreatAf:YES];
        
    }
    
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 3;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 1;
}
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    MyqueueTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"queue"];
    if (!cell) {
        
        cell = [[MyqueueTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"queue"];
    }
    cell.selectionStyle = 0;
    cell.backgroundColor = [UIColor clearColor];
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return autoScaleH(105);
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return autoScaleH(10);
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *headerView = [[UIView alloc] init];
    headerView.backgroundColor = [UIColor clearColor];
    return headerView;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    QueueDetailViewController * queueDetVc = [[QueueDetailViewController alloc]init];
    [self.navigationController pushViewController:queueDetVc animated:YES];
    
    
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
