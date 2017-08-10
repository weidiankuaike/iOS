//
//  PrintSetVC.m
//  微点筷客商户端
//
//  Created by Skyer God on 17/4/7.
//  Copyright © 2017年 张森森. All rights reserved.
//

#import "PrintSetVC.h"
#import "SEPrinterManager.h"
typedef void(^complete)(BOOL success);
@interface PrintSetVC ()<UITableViewDelegate, UITableViewDataSource, UIActionSheetDelegate>
{
    NSArray *oneSectionArr;
    NSMutableArray *oneDataArr;
    UITableView *tableV;
    UISwitch *_mySwitch;
    SEPrinterManager *printManager;
    NSMutableArray *twoSecondArr;
    BOOL isConnectBluetooth;
}

@end

@implementation PrintSetVC{
    BOOL isAutoPrint;
}
- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    if (printManager) {
        [printManager stopScan];
    }
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    self.titleView.text = @"打印设置";
    oneSectionArr = @[@"新订单自动打印", @"打印联数"];
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
    isConnectBluetooth = NO;
    if ([_BaseModel.storeBase.isChecked integerValue] >= 3) {//判断是否是入驻后
        [self loadDataWithOperType:@"0" changeKey:@"" changeValue:@"" complete:nil];
    }
    printManager = [SEPrinterManager sharedInstance];
    if (isConnectBluetooth == NO) {
        twoSecondArr = [NSMutableArray arrayWithObjects:@"\t\t暂无发现可用打印机或蓝牙未连接", nil];

        [tableV reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationAutomatic];
    }
    __block NSArray *tempArr;
    [printManager startScanPerpheralTimeout:10.0f Success:^(NSArray<CBPeripheral *> *perpherals, BOOL isTimeout) {
        isConnectBluetooth = YES;
        twoSecondArr = [NSMutableArray array];
        if (perpherals.count == 0) {
            twoSecondArr = [NSMutableArray arrayWithObjects:@"\t\t暂无发现可用打印机或蓝牙未连接", nil];
        } else {
            twoSecondArr = [perpherals mutableCopy];
        }
        if ([tempArr isEqualToArray:[twoSecondArr copy]]) {

        } else {
            ZTLog(@"Pringt_____Services+++%@", perpherals);
            if (twoSecondArr.count != 0) {
                [tableV reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationAutomatic];
                tempArr = [twoSecondArr copy];
            }
        }
    } failure:^(SEScanError error) {

    }];
}
//operaType－operation 0 查询 1修改
//changeKey－type 0:到店是否自动接单 1:是否自动打印 2:是否开启语音提醒 3:预订是否开启自动接单
//typeVal－changeValue 0：关闭 1:开启
- (void)loadDataWithOperType:(NSString *)operaType changeKey:(NSString *)changeKey changeValue:(NSString *)changeValue complete:(complete)complete{
     NSString *keyUrl = @"api/merchant/editAutomatic";
    NSString *loadUrl = [NSString stringWithFormat:@"%@%@?token=%@&storeId=%@&operation=%@&type=%@&typeVal=%@&userId=%@", kBaseURL, keyUrl, TOKEN, storeID, operaType, changeKey, changeValue, UserId];
      
    if ([operaType integerValue] == 1) {
        [SVProgressHUD showWithStatus:@"修改中"];
    }
    [[QYXNetTool shareManager] postNetWithUrl:loadUrl urlBody:nil bodyStyle:QYXBodyString header:nil response:QYXJSON success:^(id result) {
        oneDataArr = [NSMutableArray array];
        if ([result[@"msgType"] isEqualToString:@"0"]) {
            if ([operaType isEqualToString:@"0"]) {//查询
                [oneDataArr addObject:[NSString stringWithFormat:@"%@", result[@"obj"][@"isPrint"]]];
                [oneDataArr addObject:[NSString stringWithFormat:@"%@", result[@"obj"][@"printPage"]]];
                if ([result[@"obj"][@"isAutomaticOrder"] integerValue] == 1 || [result[@"obj"][@"isReserveOrders"] integerValue] == 1) {
                    //判断
                    isAutoPrint = YES;
                } else {
                    isAutoPrint = NO;
                }
                [tableV reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationAutomatic];
            } else {
                //修改
                ZTLog(@"%@", result);
                if (complete) {
                    complete(YES);
                }
            }
            [SVProgressHUD dismiss];
        } else {
            if (complete) {
                complete(NO);
            }
            [SVProgressHUD showErrorWithStatus:@"操作异常"];
        }
    } failure:^(NSError *error) {
        if (complete) {
            complete(NO);
        }
    }];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    //#warning Incomplete implementation, return the number of sections
    return 2;
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
    if (section == 0) {
        return oneSectionArr.count;
    } else {
        return twoSecondArr.count;
    }
}
-(NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return NSLocalizedString(@"常规设置", @"");
    }
    return NSLocalizedString(@"更换打印机", @"");
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"printer"];
    if (!cell) {
        cell =[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"settingindentify"];
    }

    if (indexPath.section == 0) {
        cell.textLabel.text = oneSectionArr[indexPath.row];
        if (indexPath.row == 0) {
            _mySwitch = [[UISwitch alloc]init];
            _mySwitch.on = YES;
            _mySwitch.tag = 300 + indexPath.row;
            [_mySwitch setOnTintColor:UIColorFromRGB(0xfd7577)];
            [_mySwitch addTarget:self action:@selector(swChange:) forControlEvents:UIControlEventValueChanged];
            [cell addSubview:_mySwitch];
            _mySwitch.sd_layout.rightSpaceToView(cell,autoScaleW(15)).topSpaceToView(cell,autoScaleH(8)).widthIs(autoScaleW(8)).heightIs(autoScaleH(11));
            if (oneDataArr.count == 2) {
                _mySwitch.on = [oneDataArr[0] boolValue];
            }
        }

        if (indexPath.row == 1) {
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            if (oneDataArr.count == 2) {
                cell.detailTextLabel.text = [NSString stringWithFormat:@"%@", oneDataArr[1]];
            }
        }
    } else {
        if (isConnectBluetooth && [twoSecondArr.firstObject isKindOfClass:[CBPeripheral class]]) {
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            CBPeripheral *peripherral = [twoSecondArr objectAtIndex:indexPath.row];
            cell.textLabel.text = [NSString stringWithFormat:@"%ld. 名称:%@",indexPath.row + 1, peripherral.name];
            NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
            id connectPrinter = [userDefaults objectForKey:@"peripheral"];
            if ([printManager isConnected] == NO) {
                cell.detailTextLabel.text = @"请选择";
            }
            NSString *connectIdentifier = peripherral.identifier.UUIDString;
            if ([connectPrinter isEqualToString:connectIdentifier]) {
                cell.detailTextLabel.text = @"当前选中";
                cell.detailTextLabel.textColor = UIColorFromRGB(0xfd7577);
                cell.accessoryType = UITableViewCellAccessoryNone;
            }
        } else {
            cell.textLabel.text = [twoSecondArr objectAtIndex:indexPath.row];
            cell.textLabel.textColor = [UIColor lightGrayColor];
            cell.textLabel.font = [UIFont systemFontOfSize:autoScaleW(15)];
        }
    }
    [self setExtraCellLineHidden:tableV];
    cell.selectionStyle = 0;
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        if (indexPath.row == 1) {
            [self showActionSheet];
        }
    } else {
        if (isConnectBluetooth) {

            CBPeripheral *peripheral = twoSecondArr[indexPath.row];
            [SVProgressHUD showWithStatus:@"蓝牙连接中，若第一次连接此设备可能配对时间较长，请耐心等待..."];

            if (printManager.isConnected && [printManager.connectedPerpheral isEqual:peripheral]) {
                [SVProgressHUD showInfoWithStatus:@"已连接"];
                return;
            }
                [printManager connectPeripheral:peripheral completion:^(CBPeripheral *perpheral, NSError *error) {

                    switch (perpheral.state) {
                        case CBPeripheralStateConnecting:
                            [SVProgressHUD showWithStatus:@"连接中"];
                            break;
                        case CBPeripheralStateConnected:
                        {
                            [SVProgressHUD showSuccessWithStatus:@"连接成功"];
                            [tableV beginUpdates];
                            [tableV reloadSections:[NSIndexSet indexSetWithIndex:indexPath.section] withRowAnimation:UITableViewRowAnimationNone];
                            [tableV endUpdates];
                        }
                            break;
                        case CBPeripheralStateDisconnecting:
                            [SVProgressHUD showWithStatus:@"断开中"];
                            break;
                        case CBPeripheralStateDisconnected:
                            [SVProgressHUD showSuccessWithStatus:@"已断开"];
                            break;

                        default:
                            break;
                    }
                }];
        }
    }
}
/** 隐藏多余的分割线 **/
-(void)setExtraCellLineHidden: (UITableView *)tableView
{
    UIView *view = [UIView new];

    view.backgroundColor = [UIColor clearColor];

    [tableView setTableFooterView:view];
}
#pragma mark sheet
-(void)showActionSheet{

    UIActionSheet *action =[[UIActionSheet alloc] initWithTitle:NSLocalizedString(@"请选择", @"") delegate:self cancelButtonTitle:NSLocalizedString(@"取消", @"") destructiveButtonTitle:nil otherButtonTitles:nil, nil];
    NSArray *tmp =@[@"1", @"2", @"3", @"4"];
    for (NSString *item in tmp) {
        [action addButtonWithTitle:item];
    }
    [action showInView:self.view];
}
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex NS_DEPRECATED_IOS(2_0, 8_3);
{
    if (buttonIndex > 0) {
        UITableViewCell *cell = [tableV cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
        NSString *oldValue = cell.detailTextLabel.text;
        cell.detailTextLabel.text = [NSString stringWithFormat:@"%ld", (long)buttonIndex];
        //0:到店是否自动接单 1:预订是否开启自动接单 2:是否自动打印 3:打印联数 4.预定新订单提醒 5:到店扫码新订单提醒 6：现场新服务提醒
        [self loadDataWithOperType:@"1" changeKey:@"3" changeValue:cell.detailTextLabel.text complete:^(BOOL success) {
            if (!success) {
                cell.detailTextLabel.text = oldValue;
            }
        }];
    }

}
- (void)swChange:(UISwitch *)sw{
    //0:到店是否自动接单 1:预订是否开启自动接单 2:是否自动打印 3:打印联数 4.预定新订单提醒 5:到店扫码新订单提醒 6：现场新服务提醒
    if (isAutoPrint) {
        [SVProgressHUD showInfoWithStatus:@"自动接单状态不可关闭自动打印"];
        sw.on = YES;
        return;
    } else {
        [self loadDataWithOperType:@"1" changeKey:@"2" changeValue:[NSString stringWithFormat:@"%d", sw.on] complete:^(BOOL success) {
            if (!success) {
                sw.on = !sw.on;
            }
        }];
    }
}
-(void)leftBarButtonItemAction{
    [super leftBarButtonItemAction];

    [printManager stopScan];
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
