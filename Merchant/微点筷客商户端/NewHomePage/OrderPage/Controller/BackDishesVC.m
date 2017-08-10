//
//  BackDishesVC.m
//  微点筷客商户端
//
//  Created by Skyer God on 2017/5/12.
//  Copyright © 2017年 张森森. All rights reserved.
//

#import "BackDishesVC.h"
#import "BackDishesCell.h"
#import "ZTAddOrSubAlertView.h"
@interface BackDishesVC ()<UITableViewDelegate, UITableViewDataSource>
@property (strong, nonatomic) IBOutlet UITableView *tableV;
@property (strong, nonatomic) IBOutlet UIView *noticeView;
@property (strong, nonatomic) IBOutlet ButtonStyle *confirmButton;
@property (strong, nonatomic) IBOutlet UILabel *noticeLabel;
@property (strong, nonatomic) IBOutlet UILabel *moneyLabel;
@property (strong, nonatomic) IBOutlet UILabel *realLabel;
/** 临时存放算式元素   (strong) **/
@property (nonatomic, strong) NSMutableArray *productIdsArr;
/** 临时存放算式元素   (strong) **/
@property (nonatomic, strong) NSMutableArray *numArr;
@end

@implementation BackDishesVC
static NSString *identifyStr = @"backCell";
-(NSMutableDictionary *)selectDic{
    if (_selectDic == nil) {
        _selectDic = [NSMutableDictionary dictionary];

    }
    return _selectDic;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = [UIColor whiteColor];

    self.titleView.text = @"退菜申请";
    self.rightBarItem.hidden = YES;
    _confirmButton.sd_layout
    .leftEqualToView(self.view)
    .rightEqualToView(self.view)
    .heightIs(autoScaleH(45))
    .bottomEqualToView(self.view);

    _noticeView.sd_layout
    .bottomSpaceToView(_confirmButton, 0)
    .leftSpaceToView(self.view, 0)
    .rightEqualToView(self.view);

    _moneyLabel.sd_layout
    .leftSpaceToView(_noticeView, autoScaleW(12))
    .rightSpaceToView(_noticeView, autoScaleW(12))
    .topSpaceToView(_noticeView, autoScaleH(5))
    .autoHeightRatio(0);

    _noticeLabel.sd_layout
    .topSpaceToView(_moneyLabel, 0)
    .leftEqualToView(_moneyLabel)
    .rightEqualToView(_moneyLabel)
    .heightIs(autoScaleH(30));

    _realLabel.sd_layout
    .topSpaceToView(_noticeLabel, 0)
    .leftEqualToView(_noticeLabel)
    .rightEqualToView(_noticeLabel)
    .heightIs(autoScaleH(30));

    [_noticeView setupAutoHeightWithBottomView:_realLabel bottomMargin:0];

    _tableV.sd_layout
    .bottomSpaceToView(_noticeView, 0);

    _moneyLabel.numberOfLines = 0;
    self.view.backgroundColor = [UIColor whiteColor];
    _tableV.backgroundColor = [UIColor whiteColor];
    [_tableV registerNib:[UINib nibWithNibName:NSStringFromClass([BackDishesCell class]) bundle:nil] forCellReuseIdentifier:identifyStr];
    _tableV.estimatedRowHeight = 0;
    _tableV.estimatedSectionHeaderHeight = 0;
    _tableV.estimatedSectionFooterHeight = 0;
    [self judgeBackCondition];

    

}
-(void)rightBarButtonItemAction:(ButtonStyle *)sender{

}
-(void)leftBarButtonItemAction{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)setOrderModel:(OrderModel *)orderModel{
    _orderModel = orderModel;
    for (NSInteger i = 0; i < _orderModel.beBackDets.count; i++) {
        [self.selectDic setObject:@"0" forKey:@(i)];
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return autoScaleH(70);
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _orderModel.beBackDets.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    BackDishesCell *cell = [tableView dequeueReusableCellWithIdentifier:identifyStr];

    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.selectButton.tag = 8888 + indexPath.row;
    cell.model = _orderModel.beBackDets[indexPath.row];

    cell.addOrsubClick = ^(NSString *num) {
        [_selectDic setObject:num forKey:@(indexPath.row)];
        [self judgeBackCondition];
    };
    cell.numLabel.text = _selectDic[@(indexPath.row)];

    ZTLog(@"%@", _selectDic);

//    if (indexPath.row > _orderModel.beBackDets.count) {
//        [self setExtraCellLineHidden:_tableV];
//    }

    return cell;
}
- (void)judgeBackCondition{
    NSInteger sum = 0;
    CGFloat sumMoney = 0.00f;
    NSMutableArray *tempArr = [NSMutableArray array];
    _productIdsArr = [NSMutableArray array];
    _numArr = [NSMutableArray array];
    for (NSInteger i = 0; i < _selectDic.count; i++) {
        NSInteger num = [_selectDic[@(i)] integerValue];
        sum += num;
        if (num != 0) {
            OrderPrintDetailModel *model = _orderModel.beBackDets[i];
            [tempArr addObject:[NSString stringWithFormat:@"%@x%ld", model.pfee, (long)num]];
            sumMoney = sumMoney + [model.pfee floatValue] * num;
            [_productIdsArr addObject:[NSNumber numberWithInteger:[model.productId integerValue]]];
            [_numArr addObject:@(num)];
        }
    }
    //处理退菜金额
    if (sum == 0) {
        _moneyLabel.text = @"1. 退菜金额=所退菜品*选中数量";
    } else {
        [_confirmButton setBackgroundColor:UIColorFromRGB(0xfd7577)];
        if (floor(sumMoney) == sumMoney) {
            _moneyLabel.text = [NSString stringWithFormat:@"1. 退菜金额为(元)：%.0lf=%@", sumMoney , [tempArr componentsJoinedByString:@"+"]];
        } else {
            _moneyLabel.text = [NSString stringWithFormat:@"1. 退菜金额为(元)：%.2lf=%@", sumMoney , [tempArr componentsJoinedByString:@"+"]];
        }
    }
    //处理实退金额
    if ([_orderModel.activitiesId integerValue] == 0) {
        _noticeLabel.text = @"2. 当前无可用优惠券";
    } else {
        _noticeLabel.text = [NSString stringWithFormat:@"2. 当前可用优惠券:%@", _orderModel.cardTitle];
    }
    _realLabel.text = [NSString stringWithFormat:@"3. 实退金额为(元)：%.2lf", sumMoney];
    CGFloat surplusMoney = [[_orderModel.backMoneyCondition isNull] ? @"0": _orderModel.backMoneyCondition doubleValue] - sumMoney - [[_orderModel.consumptionOver isNull] ? @"0":_orderModel.consumptionOver doubleValue];
    if (surplusMoney < 0.00 && [_orderModel.activitiesId integerValue] != 0) {//不可以使用优惠券
        //不可以使用优惠券
        [SVProgressHUD showInfoWithStatus:@"当前不满足退菜条件"];
        _realLabel.text = @"3. 只有当剩余菜品总额大于当前优惠条件才能退菜";
    }
    //判断是否可以进行退菜 退菜剩余金额必须大于等于优惠条件金额，且若无优惠不能全退。

    if (_productIdsArr.count == 0 || surplusMoney <= 0.00 ) {
        [_confirmButton setBackgroundColor:[UIColor lightGrayColor]];
        _confirmButton.tag = 111;
    } else {
         _confirmButton.tag = 222;
        [_confirmButton setBackgroundColor:UIColorFromRGB(0xfd7577)];
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        [_noticeView setupAutoHeightWithBottomView:_realLabel bottomMargin:0];
        _tableV.sd_layout
        .bottomSpaceToView(_noticeView, 0);
        [_tableV updateLayout];
    });
}
- (IBAction)confirmButtonClick:(ButtonStyle *)sender {
    if (sender.tag == 111) {
        //
        [SVProgressHUD showInfoWithStatus:@"当前不满足退菜条件"];
    } else {
        ZTAddOrSubAlertView *alertV = [[ZTAddOrSubAlertView alloc] initWithStyle:ZTalertSheetStyleSubTitle];
        [alertV showView];
        alertV.titleLabel.text = @"确定退菜？";
        alertV.littleLabel.text = @"确定后，菜品将被退掉，并且退款金额将会返回到用户余额中。";
        alertV.littleLabel.adjustsFontSizeToFitWidth = YES;
        alertV.complete = ^(BOOL isSure){
            if (isSure) {
                [self uploadBackDishes];
            }
        };
    }
}
- (void)uploadBackDishes{
    //    NSData *productIds =[NSJSONSerialization dataWithJSONObject:_productIdsArr options:NSJSONWritingPrettyPrinted error:nil];
    NSString *jsonProduct=[_productIdsArr componentsJoinedByString:@","];

    //    NSData *numData =[NSJSONSerialization dataWithJSONObject:_numArr options:NSJSONWritingPrettyPrinted error:nil];
    NSString *jsonNum=[_numArr componentsJoinedByString:@","];


    NSString *keyUrl = @"api/merchant/retreat";
    NSString *loadUrl = [NSString stringWithFormat:@"%@%@?token=%@&storeId=%@&userId=%@&productIds=%@&num=%@&orderId=%@",kBaseURL, keyUrl, TOKEN, storeID, UserId, jsonProduct, jsonNum, _orderModel.orderid];
    [SVProgressHUD showWithStatus:@"正在处理"];
    [[QYXNetTool shareManager] postNetWithUrl:loadUrl urlBody:nil bodyStyle:QYXBodyString header:nil response:QYXJSON success:^(id result) {
        if ([result[@"msgType"] integerValue] == 0) {
            [SVProgressHUD showSuccessWithStatus:@"退菜成功"];
            [self.navigationController popToRootViewControllerAnimated:YES];
        } else {
            [SVProgressHUD showErrorWithStatus:@"处理异常"];
        }
    } failure:^(NSError *error) {
            [SVProgressHUD showErrorWithStatus:@"处理异常"];
    }];
}
/** 隐藏多余的分割线 **/
-(void)setExtraCellLineHidden: (UITableView *)tableView
{
    UIView *view = [UIView new];

    view.backgroundColor = [UIColor clearColor];

    [tableView setTableFooterView:view];
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
