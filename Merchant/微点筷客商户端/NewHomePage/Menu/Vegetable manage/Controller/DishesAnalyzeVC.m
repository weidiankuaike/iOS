//
//  DishesAnalyzeVC.m
//  merchantClient
//
//  Created by Skyer God on 2017/7/17.
//  Copyright © 2017年 张甜. All rights reserved.
//

#import "DishesAnalyzeVC.h"
#import "merchantClient-Bridging-Header.h"
#import "ZTChartView.h"
#import "ZTChartCell.h"
#import "ZTSelectLabel.h"
#import "MBProgressHUD+SS.h"
#import <MJExtension.h>
#import "DishesAnalyzeModel.h"
#import "NSObject+GetAllProPerty.h"
@interface DishesAnalyzeVC ()<UITableViewDelegate, UITableViewDataSource>
/** 图标   (strong) **/
@property (nonatomic, strong)  ZTChartView *chartView;
/** 展位图   (strong) **/
@property (nonatomic, strong) UIImageView *placeHolderView;
/** <#行注释#>   (strong) **/
@property (nonatomic, strong) UITableView *tableV;
/** 筛选弹窗   (strong) **/
@property (nonatomic, strong) ZTSelectLabel *selectView;
/** <#注释#>  (NSString) **/
@property (nonatomic, copy) NSString *flowType;//sum_fee销售额 product_cnt销售量  love好评
/** <#注释#>  (NSString) **/
@property (nonatomic, copy) NSString *timeType;//0当天 1本周  2本月  3用户选择时间
/** <#行注释#>   (strong) **/
@property (nonatomic, strong) NSMutableArray *dataArr;

@end

@implementation DishesAnalyzeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [ReloadVIew registerReloadView:self];
    self.titleView.text = @"菜品分析";
    self.placeHolderView.hidden = NO;
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.tableV = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    self.tableV.hidden = YES;
    self.tableV.backgroundColor = [UIColor whiteColor];
    _tableV.separatorStyle = 0;
    _tableV.showsVerticalScrollIndicator = NO;
    _tableV.delegate = self;
    _tableV.dataSource = self;
    [self.view addSubview:_tableV];
    _tableV.sd_layout.spaceToSuperView(UIEdgeInsetsMake(64, 0, 0, 0));
    [_tableV registerNib:[UINib nibWithNibName:NSStringFromClass([ZTChartCell class]) bundle:nil] forCellReuseIdentifier:@"charCell"];

    [self.rightBarItem setImage:[UIImage imageNamed:@"bottom_arrow"] forState:UIControlStateNormal];
    [self.rightBarItem setTitle:@"筛选" forState:UIControlStateNormal];
    self.rightBarItem.hidden = NO;
    self.rightBarItem.ztButtonStyle = ZTButtonStyleTextLeftImageRight;
    _flowType = @"sum_fee";
    _timeType = @"0";
    [self updateDataWithFlowType:_flowType timeType:_timeType zoneTime:@""];

}
#pragma mark 网络请求
-(void)updateDataWithFlowType:(NSString *)flowType timeType:(NSString *)timeType zoneTime:(NSString *)zoneTime
{

    [MBProgressHUD showMessage:@"请稍等"];
    NSString *uploadUrl = [NSString stringWithFormat:@"%@api/merchant/searchDishAnalysis?token=%@&storeId=%@&flowType=%@&timeType=%@%@",kBaseURL, TOKEN, storeID, flowType, timeType, zoneTime];
    [[QYXNetTool shareManager] postNetWithUrl:uploadUrl urlBody:nil bodyStyle:QYXBodyString header:nil response:QYXJSON success:^(id result) {
        [MBProgressHUD hideHUD];
        ZTLog(@">>>>>>%@",result);

        id obj = result[@"obj"];
        NSString * msgtype = [NSString stringWithFormat:@"%@",result[@"msgType"]];

        if ([msgtype isEqualToString:@"0"]) {
            if ([obj isNull]||[obj isKindOfClass:[NSString class]]) {
                [MBProgressHUD showError:@"暂无数据"];

                _placeHolderView.hidden = NO;
                _tableV.hidden = YES;
            } else {
                NSArray *objArr = obj;
                _placeHolderView.hidden = YES;
                _tableV.hidden = NO;
                _dataArr = [NSMutableArray array];
                for (NSInteger i = 0; i < objArr.count; i++) {
                    DishesAnalyzeModel *model = [DishesAnalyzeModel mj_objectWithKeyValues:objArr[i]];
                    [model setNumber:[NSString stringWithFormat:@"%ld", i + 1]];
                    [model setFlowType:_flowType];
                    [_dataArr addObject:model];
                }
                [_tableV reloadData];
            }
        } else {
            [MBProgressHUD showError:@"数据请求失败"];
        }
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUD];
        
    }];
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
        _selectView = [[ZTSelectLabel alloc] initWithTitleArr:@[@"排序", @"时长"] TopArr:@[@"销售额",@"销售量",@"好评"] BottomArr:@[@"当天",@"7天",@"30天",@"选择"] formatOptions:@{SSCalendarType:@(CalendarTypeDouble), ZTTouchObject:sender}];
    }
    [_selectView showSelectButtonView];
    @weakify(self);

    _selectView.buttonClickBlock = ^(NSInteger type, NSInteger index, NSArray<NSString *> *timeArr, ButtonStyle *sender) {

        @strongify(self);

        if (type == 0) {

            switch (index) {
                case 0:
                    _flowType = @"sum_fee";
                    break;
                case 1:
                    _flowType = @"product_cnt";
                    break;
                case 2:
                    _flowType = @"love";
                    break;
                default:
                    break;
            }
        } else {
            switch (index) {
                case 0:
                    _timeType = @"0";
                    break;
                case 1:
                    _timeType = @"1";
                    break;
                case 2:
                    _timeType = @"2";
                    break;
                case 3:
                    _timeType = @"3";
                    break;

                default:
                    break;
            }
        }

        if ([sender.titleLabel.text isEqualToString:@"选择"]) {
            [self updateDataWithFlowType:self.flowType timeType:self.timeType zoneTime:[NSString stringWithFormat:@"&beginTime=%@&endTime=%@", timeArr[0], timeArr[1]]];
        } else {
            [self updateDataWithFlowType:self.flowType timeType:self.timeType zoneTime:@""];
        }

    };
}
#pragma mark -- tableView delegate --
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return autoScaleH(230);
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataArr.count + 1;//暂时固定显示三个
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return autoScaleH(50);
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{

    //最多展示三个菜品  3 2  1
    NSArray *tempArr;
    if (_dataArr.count >= 3) {
       tempArr = [_dataArr objectsAtIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, 3)]];
    } else if (_dataArr.count == 2) {
        tempArr = [_dataArr objectsAtIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, 2)]];
    } else {
        tempArr = [_dataArr objectsAtIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, 1)]];
    }
    NSMutableArray *titleArr = [NSMutableArray array];
    NSMutableArray *percentArr = [NSMutableArray array];
    CGFloat sumPercent = 0.0f;
    for (int i = 0; i < tempArr.count; i++) {
        DishesAnalyzeModel *model = tempArr[i];
        [titleArr addObject:model.productName];
        [percentArr addObject:[NSString stringWithFormat:@"%.2lf", [model.pct doubleValue] * 100]];
        sumPercent += [model.pct doubleValue];
    }
    //判断是否需要加入 其它 菜品数据
    if (1 - sumPercent > 0) {
        [titleArr insertObject:@"其他" atIndex:titleArr.count];
        [percentArr insertObject:[NSString stringWithFormat:@"%.2lf", (1 - sumPercent) * 100] atIndex:percentArr.count];
    }
    //创建 表视图
    _chartView = [[ZTChartView alloc] initChartViewWithFrame:CGRectMake(0, 64, kScreenWidth, autoScaleH(230)) titleArr:titleArr percentArr:percentArr];

    return _chartView;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ZTChartCell *cell = [tableView dequeueReusableCellWithIdentifier:@"charCell" forIndexPath:indexPath ];
    if (indexPath.row > 0) {
        cell.model = _dataArr[indexPath.row - 1];
    } else {
        cell.flowType = _flowType;
    }
    return cell;
}
#pragma  mark 猫
-(UIImageView *)placeHolderView{
    if (!_placeHolderView) {
        _placeHolderView = [[UIImageView alloc] init];
        _placeHolderView.image = [UIImage imageNamed:@"暂无数据"];
        _placeHolderView.backgroundColor = RGB(242, 242, 242);
        [self.view addSubview:_placeHolderView];
        _placeHolderView.sd_layout
        .centerXEqualToView(self.view)
        .centerYEqualToView(self.view)
        .widthIs(_placeHolderView.image.size.width * 2)
        .heightIs(_placeHolderView.image.size.height * 2);
    }
    [_placeHolderView updateLayout];
    [self.view bringSubviewToFront:_placeHolderView];
    return _placeHolderView;
}
-(void)leftBarButtonItemAction{
    [self dismissViewControllerAnimated:YES completion:nil];
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


