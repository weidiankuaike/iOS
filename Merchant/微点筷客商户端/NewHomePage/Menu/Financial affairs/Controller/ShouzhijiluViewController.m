//
//  ShouzhijiluViewController.m
//  微点筷客商户端
//
//  Created by 张森森 on 16/10/17.
//  Copyright © 2016年 张森森. All rights reserved.
//

#import "ShouzhijiluViewController.h"
#import "UIBarButtonItem+SSExtension.h"
#import "MymoneyTableViewCell.h"
#import "Withdraw cashViewController.h"
#import "CalendarView.h"
#import "MBProgressHUD+SS.h"
#import "QYXNetTool.h"
#import "FinacialModel.h"
#import "NSObject+JudgeNull.h"
#import "ZTSelectLabel.h"
#import "MJRefreshNormalHeader.h"
#import "MJRefreshAutoNormalFooter.h"
@interface ShouzhijiluViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,assign)  CGFloat height;
@property (nonatomic,strong) ButtonStyle * daitibtn;
@property (nonatomic,strong) ButtonStyle * tidaibtn;
@property (nonatomic,strong) UIView * chooseView;
@property (nonatomic,strong) UITableView * ordertable;
@property (nonatomic,strong) NSMutableArray * monthary;
@property (nonatomic,strong) ButtonStyle * choosebtn;
@property (nonatomic,strong) UIView * secchooseview;
@property (nonatomic,strong) UIImageView * bgimage;
@property (nonatomic,copy)   NSString * typestr;//0体现 1收入3全部 2退款
@property (nonatomic,copy)   NSString*timestr;// 0当天 1昨天 2 前天 3用户选择时间
@property (nonatomic,strong) NSMutableArray * modelary;

@property (nonatomic,assign) NSInteger heightint;
@property (nonatomic,strong) UIImageView * catimage;
@property (nonatomic,strong) ButtonStyle * morebtn;
@property (nonatomic,assign) NSInteger pagecount;//请求分页
@property (nonatomic,copy) NSString * morestr;
@property (nonatomic,copy) NSString * daystr;
@property (nonatomic,copy)NSString * sumstr;
@property (nonatomic,strong)ZTSelectLabel * selectView;//选择视图
@property (nonatomic,strong)NSArray * timeAry;
@property (nonatomic,copy) NSString * chooseTime;
@end
@implementation ShouzhijiluViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    _heightint = 0;

    self.titleView.text = @"收支记录";
    self.view.backgroundColor = [UIColor whiteColor];

    _height = [[UIApplication sharedApplication] statusBarFrame].size.height + self.navigationController.navigationBar.frame.size.height;
    [self.rightBarItem setImage:[UIImage imageNamed:@"bottom_arrow"] forState:UIControlStateNormal];
    [self.rightBarItem setTitle:@"筛选" forState:UIControlStateNormal];
    self.rightBarItem.hidden = NO;
    self.rightBarItem.ztButtonStyle = ZTButtonStyleTextLeftImageRight;
    
    [self Creatimge];
    _modelary = [NSMutableArray array];
   
    _timestr = @"0";
    _typestr = @"3";
    _pagecount = 0 ;
    _chooseTime = @"";
    
    [self loadNewData];
    
    [self Creattable];
    
    _ordertable.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
   
    
    
    _ordertable.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        [self updateDataWithFlowType:_typestr timeType:_timestr zoneTime:_chooseTime refsh:NO];
    }];
    
    
}

- (void)loadNewData{
    
    [self updateDataWithFlowType:_typestr timeType:_timestr zoneTime:_chooseTime refsh:YES];
}
-(void)endRefresh//停止刷新
{
    if (_pagecount == 0) {
        [self.ordertable.mj_header endRefreshing];
    }
    [self.ordertable.mj_footer endRefreshing];
}
-(void)leftBarButtonItemAction
{
    if (_bgimage) {

        [_bgimage removeFromSuperview];
    }
    [self dismissViewControllerAnimated:YES completion:^{

    }];
}
-(void)Creattable
{
    UIView * headview = [[UIView alloc]init];
    headview.backgroundColor = RGB(238, 238, 238);
    headview.frame = CGRectMake(0, 0, kScreenWidth, autoScaleH(25));
    [self.view addSubview:headview];
    //    headview.sd_layout.leftEqualToView(self.view).rightEqualToView(self.view).topSpaceToView(self.view,autoScaleH(66)).heightIs(autoScaleH(25));

    UILabel * hlabel = [[UILabel alloc]init];
    hlabel.text = @"收支记录";
    hlabel .font =[UIFont systemFontOfSize:autoScaleW(11)];
    [headview addSubview:hlabel];
    hlabel.sd_layout.leftSpaceToView(headview,autoScaleW(15)).topSpaceToView(headview,autoScaleH(10)).widthIs(autoScaleW(100));
    _ordertable =[[UITableView alloc]init];
    _ordertable.separatorStyle = UITableViewCellSeparatorStyleNone;
    _ordertable.delegate = self;
    _ordertable.dataSource = self;
    _ordertable.tableHeaderView = headview;
    _ordertable.showsVerticalScrollIndicator = NO;
    [self.view addSubview:_ordertable];
    if (_heightint==0)
    {
        _ordertable.sd_layout.leftSpaceToView(self.view,0).topSpaceToView(self.view,_height).widthIs(kScreenWidth).heightIs(kScreenHeight-_height);

    }
    if (_heightint==1)
    {
        _ordertable.sd_layout.leftSpaceToView(self.view,0).topSpaceToView(self.view,autoScaleH(101)+_height).widthIs(kScreenWidth).heightIs(kScreenHeight-autoScaleH(101)-_height);
    }

}
-(void)Creatimge
{
    if (!_catimage) {
        
        _catimage = [[UIImageView alloc]init];
        _catimage.image = [UIImage imageNamed:@"暂无数据"];
        [self.view addSubview:_catimage];
        _catimage.sd_layout.centerXEqualToView(self.view).centerYEqualToView(self.view).widthIs(_catimage.image.size.width * 2).heightIs(_catimage.image.size.width * 2);
        _catimage.hidden = YES;
    }
  
}
//筛选点击
-(void)rightBarButtonItemAction:(ButtonStyle *)sender{
    
    sender.selected = !sender.selected;
    if (sender.selected) {
        [self.rightBarItem setImage:[UIImage imageNamed:@"top_arrow"] forState:UIControlStateNormal];
    } else {
        [self.rightBarItem setImage:[UIImage imageNamed:@"bottom_arrow"] forState:UIControlStateNormal];
    }
    if (_selectView == nil) {
        _selectView = [[ZTSelectLabel alloc] initWithTitleArr:@[@"类型", @"日期"] TopArr:@[@"全部",@"收入",@"提现",@"退款"] BottomArr:@[@"今天",@"昨天",@"前天",@"选择"] formatOptions:@{SSCalendarType:@(CalendarTypeSingle),ZTTouchObject:sender}];
    }
    [_selectView showSelectButtonView];
    @weakify(self);
    
    _selectView.buttonClickBlock = ^(NSInteger type, NSInteger index, NSArray<NSString *> *timeArr, ButtonStyle *sender) {
        
        @strongify(self);
        
        if (type == 0) {
            
            switch (index) {
                case 0:
                    _typestr = @"3";
                    break;
                case 1:
                    _typestr = @"1";
                    break;
                case 2:
                    _typestr = @"0";
                    break;
                 case 3:
                    _typestr = @"2";
                default:
                    break;
            }
        } else {
            switch (index) {
                case 0:
                    _timestr = @"0";
                    break;
                case 1:
                    _timestr = @"1";
                    break;
                case 2:
                    _timestr = @"2";
                    break;
                case 3:
                    _timestr = @"3";
                    break;
                    
                default:
                    break;
            }
        }
        
        if (timeArr!=nil) {
            
            _timeAry = [timeArr copy];
        }
        
        if ([self.timestr isEqualToString:@"3"]) {
            if (_timeAry!=nil) {
                _chooseTime = [NSString stringWithFormat:@"&beginTime=%@&endTime=%@", self.timeAry[0], self.timeAry[0]];
                
                [self.ordertable.mj_header beginRefreshing];
            }
            
        }else{
            _chooseTime = @"";
            [self.ordertable.mj_header beginRefreshing];
        }
    };
    
}
- (void)updateDataWithFlowType:(NSString *)flowType timeType:(NSString *)timeType zoneTime:(NSString *)zoneTime refsh:(BOOL)ref{
    
    if (ref==YES) {
        _pagecount=0;
        [_modelary removeAllObjects];
    }else{
        
        _pagecount+=8;
    }
    
    [MBProgressHUD showMessage:@"请稍等"];
    NSString *uploadUrl = [NSString stringWithFormat:@"%@api/merchant/incomePayRecord?token=%@&userId=%@&searchType=%@&searchTime=%@&offset=%ld&rows=%d%@",kBaseURL,TOKEN,UserId,flowType, timeType,(long)_pagecount,10,zoneTime];
    
    [[QYXNetTool shareManager] postNetWithUrl:uploadUrl urlBody:nil bodyStyle:QYXBodyString header:nil response:QYXJSON success:^(id result) {
        [MBProgressHUD hideHUD];
        [self endRefresh];
        
        NSString * sumstr = [result objectForKey:@"msg"];
        if (![sumstr isEqualToString:@"0"]&&[sumstr integerValue]>=8) {
            
            _ordertable.mj_footer.hidden = NO;
        }
        else
        {
            _ordertable.mj_footer.hidden = YES;
        }
        
        
        id obj = result[@"obj"];
        if (![obj isNull] && ![obj isKindOfClass:[NSString class]])
        {
            NSArray *objvalue = [result objectForKey:@"obj"];
           
            for (int  i =0; i<objvalue.count; i++)
            {
                
                FinacialModel * model = [[FinacialModel alloc]initWithgetsonthingwithdict:objvalue[i]];
                [_modelary addObject:model];
            }
            _catimage.hidden = YES;
            if (!_ordertable) {
                
                [self Creattable];
            }
            else
            {
                _ordertable.hidden = NO;
                [_ordertable reloadData];
            }
        }
        else
        {
            if (_pagecount==0) {//首次请求
                
                if (_ordertable) {
                    
                    _ordertable.hidden = YES;
                }
                
                
                    _catimage.hidden = NO;
                
            }else{
                
                [MBProgressHUD showError:@"无更多数据"];
            }
           
            
        }
        
    } failure:^(NSError *error)
     {
         [MBProgressHUD hideHUD];
         [self endRefresh];
     }];
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _modelary.count;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MymoneyTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"zss"];
    if (!cell) {

        cell = [[MymoneyTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"zss"];
    }
    UILabel * linelabel = [[UILabel alloc]init];
    linelabel.backgroundColor = UIColorFromRGB(0xeeeeee);
    [cell addSubview:linelabel];
    linelabel.sd_layout.leftEqualToView(cell).rightEqualToView(cell).bottomEqualToView(cell).heightIs(0.5);
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    FinacialModel * model = _modelary[indexPath.row];
    cell.xiaoflabel.text = model.timestr;
    if ([model.trackstr isEqualToString:@"余额"]) {
        if ([model.typestr isEqualToString:@"收入"]) {

            cell.yuelabel.text = [NSString stringWithFormat:@"订单收入"];

        }else{
        cell.yuelabel.text = [NSString stringWithFormat:@"您向用户发起退款"];
        }
    }
    else{
        cell.yuelabel.text = [NSString stringWithFormat:@"您向%@发起了转账操作",model.trackstr];
    }
    cell.timelabel.text = model.typestr;
    
    if ([model.typestr isEqualToString:@"收入"]) {
        cell.jiagelabel.text = [NSString stringWithFormat:@"+%@",model.moneystr];

    }else{
        cell.jiagelabel.text = [NSString stringWithFormat:@"-%@",model.moneystr];
    }
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{

    return autoScaleH(60);
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    FinacialModel * model = _modelary[indexPath.row];

    Withdraw_cashViewController * withderaw = [[Withdraw_cashViewController alloc]init];
    withderaw.cardstr = model.cardstr;
    withderaw.timestr = model.timestr;
    withderaw.firstmoney = model.moneystr;
    withderaw.secondmoney = model.balance;
    withderaw.typestr = model.trackstr;
    withderaw.ztstr = model.statusstr;

    [self.navigationController pushViewController:withderaw animated:YES];

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
