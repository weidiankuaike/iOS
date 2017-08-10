//
//  VoiceSetVC.m
//  微点筷客商户端
//
//  Created by Skyer God on 17/4/7.
//  Copyright © 2017年 张森森. All rights reserved.
//

#import "VoiceSetVC.h"
typedef void(^complete)(BOOL success);
@interface VoiceSetVC ()<UITableViewDelegate, UITableViewDataSource, UIActionSheetDelegate>
{
    NSArray *oneSectionArr;
    NSMutableArray *oneDataArr;
    UITableView *tableV;
}

@end

@implementation VoiceSetVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    self.titleView.text = @"提醒设置";
    oneSectionArr = @[@"预订新订单提醒", @"到店扫码新订单提醒", @"现场新服务提醒"];
    tableV = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    tableV.delegate = self;
    tableV.dataSource = self;
    tableV.bounces = NO;
    [self.view addSubview:tableV];
    tableV.sd_layout
    .leftEqualToView(self.view)
    .rightEqualToView(self.view)
    .topSpaceToView(self.view, 64)
    .bottomEqualToView(self.view);
    if ([_BaseModel.storeBase.isChecked integerValue] >= 3) {//判断是否是入驻后
        [self loadDataWithOperType:@"0" changeKey:@"" changeValue:@"" complete:nil];
    }
}


//参数名	中文名	类型	说明
//isAutomaticOrder	到店是否自动接单	String	无
//isReserveOrders	预订是否开启自动接单	String	无
//isPrint	是否自动打印	String	无
//printPage	打印联数	String	无
//isNewOrderRmd	新订单提醒	String	无
//isArriveRmd	到店扫码新订单提醒	String	无
//isSeviceRmd	现场新服务提醒	String	无

/*    方法调用  */
//operaType－operation 0 查询 1修改
//changeKey－type 0:到店是否自动接单 1:是否自动打印 2:是否开启语音提醒 3:预订是否开启自动接单
//typeVal－changeValue 0：关闭 1:开启
- (void)loadDataWithOperType:(NSString *)operaType changeKey:(NSString *)changeKey changeValue:(NSString *)changeValue complete:(complete)complete{
    if ([operaType integerValue] == 1) {
        [SVProgressHUD showWithStatus:@"修改中"];
    }
    NSString *keyUrl = @"api/merchant/editAutomatic";
    NSString *loadUrl = [NSString stringWithFormat:@"%@%@?token=%@&storeId=%@&operation=%@&type=%@&typeVal=%@&userId=%@", kBaseURL, keyUrl, TOKEN, storeID, operaType, changeKey, changeValue, UserId];
      
    [[QYXNetTool shareManager] postNetWithUrl:loadUrl urlBody:nil bodyStyle:QYXBodyString header:nil response:QYXJSON success:^(id result) {
        oneDataArr = [NSMutableArray array];
        if ([result[@"msgType"] isEqualToString:@"0"]) {
            if ([operaType isEqualToString:@"0"]) {//查询
                [oneDataArr addObject:result[@"obj"][@"isNewOrderRmd"]];
                [oneDataArr addObject:result[@"obj"][@"isArriveRmd"]];
                [oneDataArr addObject:result[@"obj"][@"isSeviceRmd"]];
                [tableV reloadData];
            } else {
                //修改
                ZTLog(@"%@", result);
                complete(YES);
            }
            [SVProgressHUD dismiss];
        } else {
            [SVProgressHUD showErrorWithStatus:@"操作异常"];
            if (complete) {
                complete(NO);
            }
        }
    } failure:^(NSError *error) {
        if (complete) {
            complete(NO);
        }
    }];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    //#warning Incomplete implementation, return the number of sections
    return 1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section;
{
    return 44;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    //#warning Incomplete implementation, return the number of rows
    return oneSectionArr.count;
}
-(NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return NSLocalizedString(@"常规设置", @"");
    }
    return nil;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"voice"];
    if (!cell) {
        cell =[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"voice"];
    }
    cell.textLabel.text = oneSectionArr[indexPath.row];
    UISwitch *mySwitch = (UISwitch *)[self.view viewWithTag:300 + indexPath.row];
    if (mySwitch == nil) {
        mySwitch = [[UISwitch alloc]init];
        mySwitch.tag = 300 + indexPath.row;
    }
    mySwitch.on = [oneDataArr[indexPath.row] boolValue];
    [mySwitch setOnTintColor:UIColorFromRGB(0xfd7577)];
    [mySwitch addTarget:self action:@selector(swChange:) forControlEvents:UIControlEventValueChanged];
    [cell addSubview:mySwitch];
    mySwitch.sd_layout.rightSpaceToView(cell,autoScaleW(15)).topSpaceToView(cell,autoScaleH(8)).widthIs(autoScaleW(8)).heightIs(autoScaleH(11));


    [self setExtraCellLineHidden:tableV];
    cell.selectionStyle = 0;
    return cell;
}
- (void)swChange:(UISwitch *)sw{
    //0:到店是否自动接单 1:预订是否开启自动接单 2:是否自动打印 3:打印联数 4.预定新订单提醒 5:到店扫码新订单提醒 6：现场新服务提醒
    NSInteger tag = sw.tag - 300 + 4;
    [self loadDataWithOperType:@"1" changeKey:[NSString stringWithFormat:@"%ld", (long)tag] changeValue:[NSString stringWithFormat:@"%d", sw.on] complete:^(BOOL success) {
        if (!success) {
            sw.on = !sw.on;
        }
    }];
}
/** 隐藏多余的分割线 **/
-(void)setExtraCellLineHidden: (UITableView *)tableView
{
    UIView *view = [UIView new];

    view.backgroundColor = [UIColor clearColor];

    [tableView setTableFooterView:view];
}

@end
