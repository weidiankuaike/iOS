//
//  FinishOrderViewController.m
//  微点筷客商户端
//
//  Created by 张森森 on 16/10/11.
//  Copyright © 2016年 张森森. All rights reserved.
//

#import "FinishOrderViewController.h"
#import "UIBarButtonItem+SSExtension.h"
#import "OrderTableViewCell.h"
#import "OrderdetailViewController.h"
#import "CalendarView.h"
#import "MBProgressHUD+SS.h"
#import "QYXNetTool.h"
#import <UIImageView+WebCache.h>
#import "ZTSelectLabel.h"
#import "MJRefreshNormalHeader.h"
#import "MJRefreshAutoNormalFooter.h"
@interface FinishOrderViewController ()<UITableViewDelegate,UITableViewDataSource,UIGestureRecognizerDelegate>
@property (nonatomic,assign)  CGFloat height;
@property (nonatomic,strong) ButtonStyle * daitibtn;
@property (nonatomic,strong) ButtonStyle * tidaibtn;
@property (nonatomic,strong) UIView * chooseView;
@property (nonatomic,strong) UITableView * ordertable;
@property (nonatomic,strong) UIView * secchooseview;
@property (nonatomic,strong) NSMutableArray * monthary;
@property (nonatomic,strong) ButtonStyle * choosebtn;
@property (nonatomic,strong) UIImageView * bgimage;
@property (nonatomic,copy) NSString * typestr;
@property (nonatomic,assign)NSInteger pagecount;
@property (nonatomic,strong)NSMutableArray * modelary;
@property (nonatomic,copy)NSString * storeid;
@property (nonatomic,copy) NSString * choosemonstring;
@property (nonatomic,copy) NSString * yearstr;
@property (nonatomic,copy) NSString * choosezsstr;
@property (nonatomic,copy) NSString * choosessstr;
@property (nonatomic,copy) NSString * daystr;
@property (nonatomic,copy) NSString * seachtime;
@property (nonatomic,strong) ZTSelectLabel * selectLabel;
@property (nonatomic,strong)NSArray * timeAry;//选择时间数组
@property (nonatomic,copy) NSString * chooseTime;
/** <#行注释#>   (strong) **/
@property (nonatomic, strong) UIImageView *placeHolderView;
@end
static int a=0;
@implementation FinishOrderViewController
-(UIImageView *)placeHolderView{
    if (!_placeHolderView) {
        _placeHolderView = [[UIImageView alloc] init];
        _placeHolderView.image = [UIImage imageNamed:@"暂无订单"];
        _placeHolderView.backgroundColor = RGB(242, 242, 242);
        [self.view addSubview:_placeHolderView];
        _placeHolderView.sd_layout
        .centerXEqualToView(self.view)
        .centerYEqualToView(self.view)
        .widthIs(_placeHolderView.image.size.width * 2)
        .heightIs(_placeHolderView.image.size.height * 2);
    }
    [_placeHolderView updateLayout];
    //    [self.view bringSubviewToFront:_placeHolderView];
    return _placeHolderView;
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    self.navigationController.navigationBar.hidden = NO;
    self.tabBarController.tabBar.hidden = YES;
    [ReloadVIew registerReloadView:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.titleView.text = @"订单记录";
    self.view.backgroundColor = RGB(242, 242, 242);
    [self.rightBarItem setImage:[UIImage imageNamed:@"bottom_arrow"] forState:UIControlStateNormal];
    [self.rightBarItem setTitle:@"筛选" forState:UIControlStateNormal];
    self.rightBarItem.hidden = NO;
    self.rightBarItem.ztButtonStyle = ZTButtonStyleTextLeftImageRight;
     _height = [[UIApplication sharedApplication] statusBarFrame].size.height + self.navigationController.navigationBar.frame.size.height;
    
    
    _storeid = storeID;
    _typestr = @"6";
    _pagecount = 0;
    _modelary = [NSMutableArray array];
    _seachtime = @"0";
    _chooseTime = @"";
    [self updateDataWithFlowType:_typestr timeType:_seachtime zoneTime:_chooseTime refsh:YES];
    
    [self createSelectView];
    [self Creattable];

    self.ordertable.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewdata)];
    self.ordertable.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        [self updateDataWithFlowType:_typestr timeType:_seachtime zoneTime:_chooseTime refsh:NO];
    }];
    
    
    
}
- (void)loadNewdata{
     [self updateDataWithFlowType:_typestr timeType:_seachtime zoneTime:_chooseTime refsh:YES];
    
}
//停止刷新
- (void)endRef{
    
    if (_pagecount ==0) {
        
        [self.ordertable.mj_header endRefreshing];
    }
    
    [self.ordertable.mj_footer endRefreshing];
}
- (void)createSelectView {


    NSDate *now = [NSDate date];

    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSUInteger unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;

    NSDateComponents *dateComponent = [calendar components:unitFlags fromDate:now];

    NSInteger year = [dateComponent year];
    NSInteger day = [dateComponent day];

    _yearstr = [NSString stringWithFormat:@"%ld",(long)year];
    _daystr = [NSString stringWithFormat:@"%ld",(long)day];
    _choosemonstring = [NSString stringWithFormat:@"%ld",(long)day];
    _choosezsstr = [NSString stringWithFormat:@"%ld",day-1];
    _choosessstr = [NSString stringWithFormat:@"%ld",day-2];

}
#pragma mark 创建列表
-(void)Creattable
{
    UIView * headview = [[UIView alloc]init];
    headview.backgroundColor = RGB(238, 238, 238);
    headview.frame = CGRectMake(0, 0, kScreenWidth, autoScaleH(25));
    [self.view addSubview:headview];
    
    UILabel * hlabel = [[UILabel alloc]init];
    hlabel.text = @"订单记录";
    hlabel .font =[UIFont systemFontOfSize:13];
    [headview addSubview:hlabel];
    hlabel.sd_layout.leftSpaceToView(headview,autoScaleW(15)).topSpaceToView(headview,autoScaleH(10)).widthIs(autoScaleW(100));
    
    _ordertable =[[UITableView alloc]init];
    _ordertable.separatorStyle = UITableViewCellSeparatorStyleNone;
    _ordertable.delegate = self;
    _ordertable.dataSource = self;
    _ordertable.tableHeaderView = headview;
    
    [self.view addSubview:_ordertable];
    _ordertable.sd_layout.leftSpaceToView(self.view,0).topSpaceToView(self.view,_height).widthIs(kScreenWidth).heightIs(kScreenHeight-_height);
}
-(void)leftBarButtonItemAction
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)rightBarButtonItemAction:(ButtonStyle *)sender{
    
    sender.selected = !sender.selected;
    
    if (sender.selected) {
        [self.rightBarItem setImage:[UIImage imageNamed:@"top_arrow"] forState:UIControlStateNormal];
    } else {
        [self.rightBarItem setImage:[UIImage imageNamed:@"bottom_arrow"] forState:UIControlStateNormal];
    }
    
    if (!_selectLabel) {
        
        _selectLabel = [[ZTSelectLabel alloc]initWithTitleArr:@[@"类型",@"时间"] TopArr:@[@"全部",@"已取消",@"有退款",@"用餐结束"] BottomArr:@[@"今天",@"昨天",@"前天",@"选择"] formatOptions:@{SSCalendarType:@(CalendarTypeDouble),ZTTouchObject:sender}];
    }
    [_selectLabel showSelectButtonView];
    @weakify(self);
    
    _selectLabel.buttonClickBlock = ^(NSInteger type, NSInteger index, NSArray<NSString *> *timeArr, ButtonStyle *sender) {
        
        @strongify(self);
        
        if (type == 0) {
            
            switch (index) {
                case 0:
                    _typestr = @"6";
                    break;
                case 1:
                    _typestr = @"3";
                    break;
                case 2:
                    _typestr = @"4";
                    break;
                case 3:
                    _typestr = @"5";
                default:
                    break;
            }
        } else {
            switch (index) {
                case 0:
                    _seachtime = @"0";
                    break;
                case 1:
                    _seachtime = @"1";
                    break;
                case 2:
                    _seachtime = @"2";
                    break;
                case 3:
                    _seachtime = @"3";
                    break;
                    
                default:
                    break;
            }
        }
        
        if (timeArr!=nil) {
            
            _timeAry = [timeArr copy];
        }
        
        if ([self.seachtime isEqualToString:@"3"]) {
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
        
        _pagecount = 0;
        [_modelary removeAllObjects];
        
    }else{
        _pagecount+=8;
    }
    
    [MBProgressHUD showMessage:@"请稍等"];
    NSString *loadUrl = [NSString stringWithFormat:@"%@api/merchant/searchOrder?token=%@&storeId=%@&orderType=%@&searchTime=%@&offset=%ld&rows=%d&userId=%@%@",kBaseURL,TOKEN,_storeid,flowType,timeType,(long)_pagecount,8, UserId,zoneTime];
    
    [[QYXNetTool shareManager] postNetWithUrl:loadUrl urlBody:nil bodyStyle:QYXBodyString header:nil response:QYXJSON success:^(id result) {
        [MBProgressHUD hideHUD];
        [self endRef];
        NSString * msgstr = [result objectForKey:@"msgType"];
        
        NSArray * objvalue = [result objectForKey:@"obj"];
        _modelary = [NSMutableArray array];
        id obj = result[@"obj"];
        if ([msgstr isEqualToString:@"0"]) {
            if (![obj isNull] && ![obj isKindOfClass:[NSString class]]) {
                
                for (int i=0; i<objvalue.count; i++) {
                    OrderModel * model = [[OrderModel alloc]initWithgetsomethingwithdict:objvalue[i]];
                    [_modelary addObject:model];
                }
                if (_placeHolderView) {
                    
                    _placeHolderView.hidden = YES;

                }
                if (!_ordertable) {
                    
                    [self Creattable];
                }
                else
                {
                    _ordertable.hidden = NO;
                    [_ordertable reloadData];
                }
                
                
            } else {
                if (_pagecount==0) {//首次请求
                    
                    if (_ordertable) {
                        
                        _ordertable.hidden = YES;
                    }
                    if (!_placeHolderView) {
                        
                        [self placeHolderView];

                    }
                    
                }else{
                    
                    [MBProgressHUD showError:@"无更多数据"];
                }
            }
        } else {
            //数据异常
            [MBProgressHUD showError:@"请求失败"];
        }
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUD];
        [self endRef];
    }];
    
}


-(void)Clickbtn:(ButtonStyle *)btn
{
    
    [_choosebtn setTitle:btn.titleLabel.text forState:UIControlStateNormal];
    
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _modelary.count;
    
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    OrderTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"jilu"];
    if (!cell) {
        
        cell = [[OrderTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"jilu"];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    UILabel * linelabel = [[UILabel alloc]init];
    linelabel.backgroundColor = UIColorFromRGB(0xeeeeee);
    [cell addSubview:linelabel];
    linelabel.sd_layout.leftEqualToView(cell).rightEqualToView(cell).bottomEqualToView(cell).heightIs(0.5);
    OrderModel *model = _modelary[indexPath.row];
    cell.model = model;
    
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPat
{
    return 90;
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_bgimage) {
        [_bgimage removeFromSuperview];
        a=0;
    }
    OrderModel * model = _modelary[indexPath.row];
    OrderdetailViewController * orderview = [[OrderdetailViewController alloc]init];
    orderview.isOrderRecord = YES;
    orderview.model = model;
    [self.navigationController pushViewController:orderview animated:YES];
    
}

-(void)Clickbtn:(ButtonStyle *)btn event:(id)event
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
