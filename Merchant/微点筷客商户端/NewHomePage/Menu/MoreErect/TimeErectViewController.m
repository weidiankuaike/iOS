//
//  TimeErectViewController.m
//  微点筷客商户端
//
//  Created by 张森森 on 16/12/8.
//  Copyright © 2016年 张森森. All rights reserved.
//

#import "TimeErectViewController.h"
#import "ZTTimerPickerView.h"
#import "UIBarButtonItem+SSExtension.h"
#import "BusinessTimeModel.h"
#import <MJExtension.h>
@interface TimeErectViewController ()<UITableViewDelegate,UITableViewDataSource,ZTTimerPickerViewDelegate>
{
    BusinessTimeModel *_timeModel;
    NSIndexPath *currentIndexP;
}
@property (nonatomic,strong)NSArray * lefttitleary;
@property (nonatomic,strong)NSMutableArray * labelary;
@property (nonatomic,strong)UILabel * timelabel;
@property (nonatomic,assign)NSInteger ztinter;
/** 入驻后，营业时间数据源   (strong) **/
@property (nonatomic, strong) NSMutableArray *changeTimeArr;
/** 表  (NSString) **/
@property (nonatomic, copy) UITableView *timeTable;
@end

@implementation TimeErectViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _changeTimeArr = [NSMutableArray array];
    [self getData];

    self.titleView.text = @"营业时间";
    self.view.backgroundColor = [UIColor whiteColor];
    
    ButtonStyle *_tijiaoBtn = [ButtonStyle buttonWithType:UIButtonTypeCustom];
    [_tijiaoBtn setTitle:@"确定" forState:UIControlStateNormal];
    [_tijiaoBtn setBackgroundColor:UIColorFromRGB(0xfd7577)];
    
    //    _tijiaoBtn.userInteractionEnabled = NO;
    [_tijiaoBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _tijiaoBtn .titleLabel.font =[UIFont systemFontOfSize:autoScaleW(15)];
    [_tijiaoBtn addTarget:self action:@selector(Tijiao) forControlEvents:UIControlEventTouchUpInside];
    _tijiaoBtn.layer.masksToBounds = YES;
    _tijiaoBtn.layer.cornerRadius = autoScaleW(5);
    [self.view addSubview:_tijiaoBtn];
    _tijiaoBtn.sd_layout.leftSpaceToView(self.view,autoScaleW(10)).rightSpaceToView(self.view,autoScaleW(10)).bottomSpaceToView(self.view,autoScaleH(10)).heightIs(autoScaleH(33));
    
    _timeTable = [[UITableView alloc]init];
    _timeTable.backgroundColor = RGB(242, 242, 242);
    _timeTable.delegate = self;
    _timeTable.dataSource = self;
    _timeTable.scrollEnabled = NO;
    _timeTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_timeTable];
    _timeTable.sd_layout.leftEqualToView(self.view).rightEqualToView(self.view).topSpaceToView(self.view,64).bottomSpaceToView(_tijiaoBtn, 0);
    
    
    _lefttitleary = @[@"统一设置",@"周一",@"周二",@"周三",@"周四",@"周五",@"周六",@"周日",];
    _labelary = [NSMutableArray array];
    
}
- (void)getData{
    NSString *keyUrl = @"api/merchant/operatingHours";
    NSString *operatingType = @"1";//操作类型 1查询 2 修改
    NSString *tempStoreId = nil;
    if (_isChecked) {
        tempStoreId = storeID;
    } else {
        tempStoreId = UserId;
    }
    NSString *loadUrl = [NSString stringWithFormat:@"%@%@?token=%@&storeId=%@&operatingType=%@", kBaseURL, keyUrl, TOKEN, tempStoreId, operatingType];
    if (_isChecked) {
        [SVProgressHUD showInfoWithStatus:@"加载中..."];
    }
      
    [[QYXNetTool shareManager] postNetWithUrl:loadUrl urlBody:nil bodyStyle:QYXBodyString header:nil response:QYXJSON success:^(id result) {
//        ZTLog(@"%@", result);
        if ([result[@"msgType"] integerValue] == 0) {
            if (_isChecked) {
                [SVProgressHUD showSuccessWithStatus:@"加载完毕"];
            }
            id obj = result[@"obj"];
            if (![obj isNull] && ![obj isKindOfClass:[NSString class]]) {
                _timeModel = [BusinessTimeModel mj_objectWithKeyValues:result[@"obj"]];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [_timeTable reloadData];
                });
            }
        }
    } failure:^(NSError *error) {

    }];
}

- (void)uploadBusinessTimeWithDay:(NSString *)everyDayAppendTime{
    NSString *keyUrl = @"api/merchant/operatingHours";
    NSString *operatingType = @"2";//操作类型 1查询 2 修改
    NSString *tempStoreId = nil;
    if (_isChecked) {
        tempStoreId = storeID;
    } else {
        tempStoreId = UserId;
    }
    NSString *loadUrl = [NSString stringWithFormat:@"%@%@?token=%@&storeId=%@&operatingType=%@%@", kBaseURL, keyUrl, TOKEN, tempStoreId, operatingType, everyDayAppendTime];
    [SVProgressHUD showInfoWithStatus:@"上传中..."];
      
    [[QYXNetTool shareManager] postNetWithUrl:loadUrl urlBody:nil bodyStyle:QYXBodyString header:nil response:QYXJSON success:^(id result) {
//        ZTLog(@"%@", result);
        NSInteger msgTypeStatus = [result[@"msgType"] integerValue];
        if (msgTypeStatus == 0 || msgTypeStatus == 2) {
            [SVProgressHUD showSuccessWithStatus:@"修改成功"];
            if (_timeSuccess) {
                _timeSuccess(YES);
                [self.navigationController popViewControllerAnimated:YES];
            }
        }
    } failure:^(NSError *error) {
        
        
    }];

}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 8;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"time"];
    if (!cell)
    {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"time"];
     }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.textLabel.text = _lefttitleary[indexPath.section];
    switch ([_timeModel isNull] ? 1111: indexPath.section) {
        case 1:
            cell.detailTextLabel.text = _timeModel.businessMonday;
            break;
        case 2:
            cell.detailTextLabel.text = _timeModel.businessTuesday;
            break;
        case 3:
            cell.detailTextLabel.text = _timeModel.businessWednesday;
            break;
        case 4:
            cell.detailTextLabel.text = _timeModel.businessThursday;
            break;
        case 5:
            cell.detailTextLabel.text = _timeModel.businessFriday;
            break;
        case 6:
            cell.detailTextLabel.text = _timeModel.businessSaturday;
            break;
        case 7:
            cell.detailTextLabel.text = _timeModel.businessSunday;
            break;

        default:
            break;
    }
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section==1) {
        
        return 15;
    }
    return 5;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 45;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    currentIndexP = indexPath;
    ZTTimerPickerView *timePicker = [[ZTTimerPickerView alloc] init];
    timePicker.delegate = self;
    [timePicker showTime];

}
-(void)ZTselectTimesViewSetOneLeft:(NSString *)oneLeft andOneRight:(NSString *)oneRight andTwoLeft:(NSString *)twoLeft andTwoRight:(NSString *)twoRight
{
    
    [[self.view viewWithTag:1111] setTitle:[NSString stringWithFormat:@"%@:%@", oneLeft, oneRight] forState:UIControlStateNormal];
    [[self.view viewWithTag:1112] setTitle:[NSString stringWithFormat:@"%@:%@", twoLeft, twoRight] forState:UIControlStateNormal];
    
    NSString * leftstr = [NSString stringWithFormat:@"%@:%@", oneLeft, oneRight];
    NSString * rightstr = [NSString stringWithFormat:@"%@:%@", twoLeft, twoRight];

    if (currentIndexP.section >=1) {
        //修改单个时间
        UITableViewCell *cell = [_timeTable cellForRowAtIndexPath:currentIndexP];
        cell.detailTextLabel.text = [NSString stringWithFormat:@"%@-%@",leftstr,rightstr];
    } else {
        //整体修改时间
        NSInteger rowScount = [_timeTable numberOfSections];
        for (NSInteger i = 0; i < rowScount; i++) {
            UITableViewCell *cell = [_timeTable cellForRowAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:i]];
            cell.detailTextLabel.text = [NSString stringWithFormat:@"%@-%@",leftstr,rightstr];
        }
    }
}

-(void)Tijiao
{
    NSInteger rowScount = [_timeTable numberOfSections];
    NSString *timeAppendStr = @"";
    NSArray *timeKeyArr = @[@"",@"businessMonday",@"businessTuesday",@"businessWednesday",@"businessThursday",@"businessFriday",@"businessSaturday",@"businessSunday"];
    for (NSInteger i = 1; i < rowScount; i++) {
        UITableViewCell *cell = [_timeTable cellForRowAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:i]];
        NSString *tempStr = [NSString stringWithFormat:@"&%@=%@", timeKeyArr[i], cell.detailTextLabel.text];
      timeAppendStr = [timeAppendStr stringByAppendingString:tempStr];
    }
    [self uploadBusinessTimeWithDay:timeAppendStr];
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
