//
//  ZTPrintFormatVC.m
//  微点筷客商户端
//
//  Created by Skyer God on 17/1/3.
//  Copyright © 2017年 张森森. All rights reserved.
//

#import "ZTPrintFormatVC.h"

#import "SEPrinterManager.h"
#import "PrinterModel.h"
#import "OrderPrintDetailModel.h"
#import "NSString+TimeHandle.h"
typedef void (^requireDataSuccess)(BOOL success);
@interface ZTPrintFormatVC ()<UITableViewDelegate, UITableViewDataSource>
@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) NSArray *deviceArray;  /**< 蓝牙设备个数 */
/** model   (strong) **/
@property (nonatomic, strong) PrinterModel *printModel;
/** 只打印一次   (NSInteger) **/
@property (nonatomic, assign) NSInteger oncePrintCount;
/** <#行注释#>   (strong) **/@property (nonatomic, strong) SEPrinterManager *manager;
@end

@implementation ZTPrintFormatVC
-(UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.backgroundColor = [UIColor whiteColor];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = 0;
        [self.view addSubview:_tableView];


        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"print"];
    }
    _tableView.sd_layout.spaceToSuperView(UIEdgeInsetsMake(64, 0, 0, 0));
    return _tableView;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.titleView.text = @"未连接";
    _manager = [SEPrinterManager sharedInstance];
    //请求打印数据
    [self getOrderInfo:^(BOOL success) {
        if (success) {
            //打印相关数据
            //判断是否连接打印机
            if (_manager.isConnected == NO) {
                //未连接打印机
                [_manager startScanPerpheralTimeout:10 Success:^(NSArray<CBPeripheral *> *perpherals, BOOL isTimeout) {
                    ZTLog(@"%@", perpherals);
                    _deviceArray = perpherals;
                    [_tableView reloadData];
                } failure:^(SEScanError error) {
                    ZTLog(@"%ld", (long)error);
                }];
            } else {
                //自动重新连接上次保存的打印机
                    [_manager fullOptionPeripheral:_manager.connectedPerpheral completion:^(SEOptionStage stage, CBPeripheral *perpheral, NSError *error) {
                        if (stage == SEOptionStageSeekCharacteristics) {
                            HLPrinter *printer = [self getPrinter];
                            NSData *mainData = [printer getFinalData];
                            if (_oncePrintCount == 0) {
                                for (NSInteger i = 0; i < [_printModel.printPage integerValue]; i++) {
                                    [_manager sendPrintData:mainData completion:^(CBPeripheral *connectPerpheral, BOOL completion, NSString *error) {
                                        if (completion) {
                                            [self.navigationController popViewControllerAnimated:YES];
                                        }
                                    }];
                                }
                            }
                            _oncePrintCount++;
                        }

                }];
            }

        }
    }];

    self.view.backgroundColor = [UIColor whiteColor];
    self.tableView.backgroundColor = [UIColor whiteColor];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(selectBluetoothAndUpdate)
                                                 name:UIApplicationWillEnterForegroundNotification object:nil];

}
- (void)selectBluetoothAndUpdate{
    //打印相关数据
    //判断是否连接打印机
    if (_manager.isConnected == NO) {
        //未连接打印机
        [_manager startScanPerpheralTimeout:10 Success:^(NSArray<CBPeripheral *> *perpherals, BOOL isTimeout) {
            ZTLog(@"%@", perpherals);
            _deviceArray = perpherals;
            [_tableView reloadData];
        } failure:^(SEScanError error) {
            ZTLog(@"%ld", (long)error);
        }];
    }
}
- (void)getOrderInfo:(requireDataSuccess)requireDataCompelte{
    //    /api/order/orderData
    NSString *keyUrl = @"api/order/orderData";
    NSString *storeId = storeID;
    NSString *orderId = _orderId;
    NSString *loadUrl = [NSString stringWithFormat:@"%@%@?token=%@&storeId=%@&orderId=%@", kBaseURL, keyUrl, TOKEN, storeId, orderId];
      
    [[QYXNetTool shareManager] postNetWithUrl:loadUrl urlBody:nil bodyStyle:QYXBodyString header:nil response:QYXJSON success:^(id result) {
        if ([result[@"msgType"] integerValue] == 0) {
            _printModel = [PrinterModel mj_objectWithKeyValues:result[@"obj"]];
            requireDataCompelte(YES);
        }
    } failure:^(NSError *error) {

    }];
}
- (HLPrinter *)getPrinter{
    HLPrinter *printer = [[HLPrinter alloc] init];
    NSString *title = _BaseModel.storeBase.name;

    [printer appendText:title alignment:HLTextAlignmentCenter fontSize:HLFontSizeTitleMiddle];
    NSString *orderNum = [NSString stringWithFormat:@"订单号:%@", _orderId];
    [printer appendText:orderNum alignment:HLTextAlignmentCenter fontSize:0x07];
    NSString *orderDate = [NSString getDateFromNow:TIME_TO_SEC]; //@"2017-01-03-10:00";
    [printer appendText:orderDate alignment:HLTextAlignmentCenter fontSize:HLFontSizeTitleSmalle];
    //    NSString *oneseparatorLine = @"--------------";
    [printer appendSeperatorLine];

    [printer appendTitle:@"订单状态:" value:[self judgeOrderType:_printModel.orderType] valueOffset:150];
    NSString *arriveTimeNum = [NSString stringWithFormat:@"%@(第%@次到店)", _printModel.orderName, _printModel.severalStore];
    [printer appendTitle:@"用户昵称:" value:arriveTimeNum valueOffset:150];
    [printer appendTitle:@"用餐人数:" value:[_printModel.mealsNo isNull] ? @"待定" : _printModel.mealsNo valueOffset:150];

    NSString *boardNum = [NSString stringWithFormat:@"%@", _printModel.boardNum];
    [printer appendTitle:@"桌号:" value:boardNum valueOffset:150];
    NSString *createTime = [[_printModel.createTime getDateTimeFromTimeStrWithOption:TIME_TO_SEC] substringFromIndex:5];
    [printer appendTitle:@"预定时间" value:createTime valueOffset:150];
    [printer appendTitle:@"预留时间:" value:@"10分钟以上" valueOffset:150];
    [printer appendTitle:@"联系方式:" value:_printModel.userPhone valueOffset:150];
    //    NSString *twoSeparatorLine = @"----------------";
    [printer appendSeperatorLine];
    NSString *remark = [_printModel.remark isNull] ? @"无" :_printModel.remark;
    [printer appendTitle:@"备注信息:" value:remark valueOffset:150];
    //    NSString *threeSeparatorLine = @"-----------------";
    [printer appendSeperatorLine];


    NSString *dishesInfo = @"菜品信息";
    [printer appendText:dishesInfo alignment:HLTextAlignmentCenter];
    __block CGFloat total = 0.0;
    //    NSMutableArray *dishesArr = [NSMutableArray array];
    [printer appendLeftText:@"菜名" middleText:@"数量" rightText:@"单价" isTitle:NO];
    [_printModel.orderDets enumerateObjectsUsingBlock:^(OrderPrintDetailModel  * orderModel, NSUInteger idx, BOOL * _Nonnull stop) {

        [printer appendLeftText:orderModel.productName middleText:[NSString stringWithFormat:@" x %@", orderModel.quantity] rightText:orderModel.fee isTitle:NO];
        total += [orderModel.fee floatValue] * [orderModel.quantity intValue];

    }];

    [printer appendSeperatorLine];

    NSString *totalStr = [NSString stringWithFormat:@"￥%.2lf", total];
    [printer appendTitle:@"菜品总额:" value:totalStr];
    NSString *disCategory = [_printModel.cardTitle isNull] ? @"优惠金额:": _printModel.cardTitle;
    NSString *discountNum = [NSString stringWithFormat:@"￥%.2lf", [_printModel.discountedPrice floatValue]];
    [printer appendTitle:disCategory value:discountNum];
    CGFloat orderMoney = [_printModel.realTotalFee doubleValue];
    CGFloat backMoney = [_printModel.retreatPrice doubleValue];

    NSString *orderOrBack = [NSString stringWithFormat:@"%.2lf/%.2lf", orderMoney, backMoney];
    
    [printer appendTitle:@"订金/退款:" value:orderOrBack];
    NSString *realPay = [NSString stringWithFormat:@"￥ %.2f", [_printModel.realTotalFee doubleValue]];
    [printer appendTitle:@"共计:" value:realPay fontSize:0x09];

    [printer appendFooter:nil];

    return printer;
}


#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _deviceArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"print";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
    }

    CBPeripheral *peripherral = [self.deviceArray objectAtIndex:indexPath.row];
    cell.textLabel.text = [NSString stringWithFormat:@"%ld. 名称:%@",indexPath.row + 1, peripherral.name];

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    CBPeripheral *peripheral = [self.deviceArray objectAtIndex:indexPath.row];
    [SVProgressHUD showWithStatus:@"蓝牙连接中，若第一次连接此设备可能配对时间较长，请耐心等待..."];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(8.0f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [SVProgressHUD showErrorWithStatus:@"该打印机连接设备数目已达上限或机型不支持"];
        [_manager cancelPeripheral:peripheral];
    });

    [_manager connectPeripheral:peripheral completion:^(CBPeripheral *perpheral, NSError *error) {
        if (error) {
            [SVProgressHUD showErrorWithStatus:@"连接失败"];
        } else {
            self.titleView.text = @"已连接";
            [SVProgressHUD showSuccessWithStatus:@"连接成功"];
        }
    }];

    //     如果你需要连接，立刻去打印
    __weak typeof(self) weakSelf = self;
    [_manager fullOptionPeripheral:peripheral completion:^(SEOptionStage stage, CBPeripheral *perpheral, NSError *error) {
        if (stage == SEOptionStageSeekCharacteristics) {
            HLPrinter *printer = [self getPrinter];

            NSData *mainData = [printer getFinalData];
            for (NSInteger i = 0; i < [_printModel.printPage integerValue]; i++) {
                [_manager sendPrintData:mainData completion:^(CBPeripheral *connectPerpheral, BOOL completion, NSString *error) {
                    if (completion) {
                        [weakSelf.navigationController popViewControllerAnimated:YES];
                    }
                }];
            }
        }
    }];
}
- (NSString *)judgeOrderType:(NSString *)orderType{

    NSInteger orderStatus = [orderType integerValue];
    NSArray *cancelStatus = @[@2 ,@3, @5, @6, @7, @8, @9, @10, @13 ,@15, @16, @17, @20, @22, @23];
    NSArray *preStatus = @[@0, @1, @11, @12];//2 等待接单
    //    NSArray *recStatus = @[@4 , @14,@18, @19, @21];

    NSString *tempType = @"已取消";
    if ([cancelStatus containsObject:@(orderStatus)]) {
        tempType = @"已取消";
    } else if ([preStatus containsObject:@(orderStatus)]){
        tempType = @"已预订";
    } else {
        tempType = @"已接单";
    }

    return tempType;
}
- (void)dealloc
{
    _manager = nil;
}
// 返回
- (void)leftBarButtonItemAction{
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
