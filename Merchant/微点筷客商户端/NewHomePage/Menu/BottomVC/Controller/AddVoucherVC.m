//
//  AddVoucherVC.m
//  微点筷客商户端
//
//  Created by Skyer God on 16/10/24.
//  Copyright © 2016年 张森森. All rights reserved.
//

#import "AddVoucherVC.h"
#import "AddVoucherCell.h"
#import "TextFiledAlertView.h"
#import "ZTTimerPickerView.h"
#import "ZTCalender.h"
#import "ZTAddOrSubAlertView.h"
#import "TextFieldViewController.h"
#import "ZT_doublePickerView.h"
#import "UINavigationController+FDFullscreenPopGesture.h"
#import "ZT_TimerPickerView_Double.h"
#import "UIView+Observer.h"
@interface AddVoucherVC ()<UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, ZTTimerPickerViewDelegate, ZTPickViewDelegate, ZTDeskPickerViewDelegate>
/** 整体tableV **/
@property (nonatomic, strong) UITableView *tableV;
/** 遮罩页   (strong) **/
@property (nonatomic, strong) UIView *maskView;
/** 发放选择背景图   (strong) **/
@property (nonatomic, strong) UIView *allocationView;
/** 完成保存，返回上一页添加券   (strong) **/
@property (nonatomic, strong) ButtonStyle *saveButton;

/** 保存当前的indexPath   (strong) **/
@property (nonatomic, strong) NSIndexPath *currentIndexPath;

@property (nonatomic, strong) ZTCalender *calender;
/** 保存卡券信息，然后上传   (strong) **/
@property (nonatomic, strong) NSMutableDictionary *voucherInfoDic;
@end

@implementation AddVoucherVC
{
    NSString *discountStr;
    NSArray *chooseTitleArr;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.rightBarItem.hidden = YES;
    self.fd_interactivePopDisabled = YES;
    //    [[IQKeyboardManager sharedManager] setShouldResignOnTouchOutside:NO];
    //    [[IQKeyboardManager sharedManager] setShouldHidePreviousNext:YES];
    self.voucherInfoDic = [NSMutableDictionary dictionary];

    [_voucherInfoDic setObject:_isVoucherCard ? @"0":@"2" forKey:@"cardType"];

    self.view.backgroundColor = [UIColor whiteColor];
    if (_isVoucherCard) {
        self.titleView.text = @"添加卡券";
    } else{
        self.titleView.text = @"添加优惠活动";
    }
    chooseTitleArr = @[@"减", @"¥"];
    [self createWholeTabeV];
}

- (void)createWholeTabeV{

    _tableV = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    _tableV.backgroundColor = [UIColor whiteColor];
    _tableV.delegate = self;
    _tableV.dataSource = self;
    [self.view addSubview:_tableV];

    _tableV.sd_layout.spaceToSuperView(UIEdgeInsetsMake(64, 0, 60, 0));
//    _tableV.sd_layout
//    .bottomSpaceToView(self.view, 60);

    _saveButton = [ButtonStyle buttonWithType:UIButtonTypeCustom];
    [_saveButton setTitle:@"完成" forState:UIControlStateNormal];
    [_saveButton setBackgroundColor:[UIColor lightGrayColor]];
    [_saveButton addTarget:self action:@selector(saveButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    _saveButton.enabled = NO;
    [self.view addSubview:_saveButton];

    _saveButton.sd_layout
    .leftSpaceToView(self.view, 20)
    .bottomSpaceToView(self.view, 20)
    .rightSpaceToView(self.view, 20)
    .heightIs(40);

    [_saveButton setSd_cornerRadiusFromHeightRatio:@(0.1)];

    NSArray *keyPathsArr = @[@"beginTime", @"cardType", @"consumptionOver", @"discount", @"discountedPrice", @"endTime", @"conditions"];

    [self.KVOControllerNonRetaining observe:_voucherInfoDic keyPaths:keyPathsArr options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld block:^(id  _Nullable observer, id  _Nonnull object, NSDictionary<NSKeyValueChangeKey,id> * _Nonnull change) {

        if (object == _voucherInfoDic && _voucherInfoDic.allValues.count >= (_isVoucherCard ? 6 : 5)) {
            AddVoucherCell *cell = [_tableV cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
            if (cell.secTextField.isFirstResponder) {
                [cell.secTextField resignFirstResponder];
            }
            if ( cell.secTextField.text != nil && ![cell.secTextField.text isNull]) {
                [_saveButton setBackgroundColor:UIColorFromRGB(0xfd7577)];
                _saveButton.enabled = YES;
            } else {
                [_saveButton setBackgroundColor:[UIColor lightGrayColor]];
                _saveButton.enabled = NO;
            }
        }
    }];

}

- (void)saveButtonAction:(ButtonStyle *)sender{

    AddVoucherCell *cell = [_tableV cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
    if ([cell.firstTextField.text isNull] || [cell.secTextField.text isNull] ) {
        [SVProgressHUD showInfoWithStatus:@"请补全活动信息"];
        return;
    }

    CGFloat secText = [cell.secTextField.text floatValue];
    if ([cell.symbolLabel.text isEqualToString:@"折"]) {
        if (secText > 10.00) {
            [SVProgressHUD showInfoWithStatus:@"请输入正确的折扣程度"];
            return;
        }
    } else {
        if (secText > [cell.firstTextField.text floatValue]) {
            [SVProgressHUD showInfoWithStatus:@"优惠金额不能大于满减金额"];
            return;
        }
    }
    if ([_voucherInfoDic[@"beginTime"] isNull] || _voucherInfoDic[@"endTime"] == nil) {
        [SVProgressHUD showInfoWithStatus:@"请输入活动期限"];
        return;
    }

    _returnValues(_voucherInfoDic);
    [self.navigationController popToRootViewControllerAnimated:YES];


}
#pragma  mark --    tableV Delegate     --
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (_isVoucherCard) {
        return 4;
    } else {
        return 3;
    }
}
- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath{

    return 30;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 1) {
        return 100;
    }
    return 45;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    if (indexPath.row != 1) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([UITableViewCell class])];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:NSStringFromClass([UITableViewCell class])];
        }
        NSArray *detailArr = @[@"满减优惠", @"", @"点击选择活动期间"];
        NSArray *arrTitle = @[@"活动类型", @"使用期限", @"活动期限"];
        if (_isVoucherCard) {
            detailArr = @[@"满减优惠", @"", @"点击选择活动期间", @"点击设置发放条件"];
            arrTitle = @[@"活动类型", @"使用期限", @"活动期限", @"发放条件"];
        }
        cell.detailTextLabel.text = detailArr[indexPath.row];

        cell.textLabel.text = arrTitle[indexPath.row];
        cell.textLabel.font = [UIFont systemFontOfSize:15];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.detailTextLabel.font = [UIFont systemFontOfSize:13];
        //        cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
        //        cell.accessoryView = [UIView new];
        if (_isVoucherCard) {
            if (indexPath.row >=3) {
                [self setExtraCellLineHidden:_tableV];
            }
        } else {
            if (indexPath.row >=2) {
                [self setExtraCellLineHidden:_tableV];
            }
        }
        return cell;
    } else {
        AddVoucherCell *cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([AddVoucherCell class]) owner:self options:0] lastObject];
        cell.chooseTitleArr = chooseTitleArr;
        cell.firstTextField.delegate = self;
        cell.firstTextField.tag = 300;
        cell.secTextField.delegate = self;
        if ([cell.symbolLabel.text isEqualToString:@"折"]) {
            cell.secTextField.tag = 401;
            //            cell.secTextField.delegate = nil;

            if (![_voucherInfoDic[@"discount"] isNull] && _voucherInfoDic[@"discount"] != nil) {
                cell.secTextField.text = _voucherInfoDic[@"discount"];
            }
        } else {
            cell.secTextField.tag = 400;
            if (![_voucherInfoDic[@"discountedPrice"] isNull] && _voucherInfoDic[@"discountedPrice"] != nil) {
                cell.secTextField.text = _voucherInfoDic[@"discountedPrice"];
            }
        }
        if (![_voucherInfoDic[@"consumptionOver"] isNull] && _voucherInfoDic[@"consumptionOver"]) {
            cell.firstTextField.text = _voucherInfoDic[@"consumptionOver"];
        }
        return cell;
    }
}
-(BOOL)textFieldShouldReturn:(UITextField*)textField {

    [textField resignFirstResponder];

    return YES;

}
-(BOOL)textFieldShouldEndEditing:(UITextField *)textField{
    if ([textField.text doubleValue] == 0 && ![textField.text isNull]) {
        textField.text = @"";
    }
    return YES;
}
-(void)textFieldDidEndEditing:(UITextField *)textField{

    if (textField.tag == 300) {
        [_voucherInfoDic setObject:textField.text forKey:@"consumptionOver"];
    } else {
        AddVoucherCell *cell = [_tableV cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
        if (textField.tag == 401) {
            [_voucherInfoDic setObject:cell.secTextField.text forKey:@"discount"];
        } else {
            [_voucherInfoDic setObject:cell.secTextField.text forKey:@"discountedPrice"];
        }
    }
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    //如果输入的是“.”  判断之前已经有"."或者字符串为空
    if ([string isEqualToString:@"."] && ([textField.text rangeOfString:@"."].location != NSNotFound || [textField.text isEqualToString:@""])) {
        textField.text = @"0.";
        return NO;
    }
    NSMutableString *str = [[NSMutableString alloc] initWithString:textField.text];
    [str insertString:string atIndex:range.location];
    CGFloat discount = fabs([str doubleValue]);

    if (textField.tag == 401) {
        //限制不能大于10 0 ～ 9 取值
        if (floor(discount) > 9 || (str.length >= [str rangeOfString:@"."].location+3)) {
            return NO;
        }
    }
    //拼出输入完成的str,判断str的长度大于等于“.”的位置＋4,则返回false,此次插入string失败 （"379132.424",长度10,"."的位置6, 10>=6+4）
    if (str.length >= [str rangeOfString:@"."].location+4){
        return NO;
    }
    //去除第一个0 如086， 00
    if ([[str substringToIndex:1] isEqualToString:@"0"] && [textField.text rangeOfString:@"."].location ==  NSNotFound && ![string isEqualToString:@"."]) {
        textField.text = string;
        return NO;
    }
    //去除0.00的情况
    if ((discount - floor(discount) == 0 && range.location > 2 && [textField.text rangeOfString:@"."].location !=  NSNotFound  && ![string  isEqualToString:@""]) || [@(discount) integerValue] > 9999) {
        return NO;
    }


    return YES;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    _currentIndexPath = indexPath;

    if (indexPath.row == 0) {
        ZTAddOrSubAlertView *singleSelectAlert = [[ZTAddOrSubAlertView alloc] initWithStyle:ZTalertSheetStyleSingleSelectList];
        singleSelectAlert.singleListArr = [NSMutableArray arrayWithArray:@[@"满减优惠", @"折扣优惠"]];
        if (_isVoucherCard) {
            singleSelectAlert.singleListArr = [NSMutableArray arrayWithArray:@[@"代金券", @"折扣券"]];
        }
        [singleSelectAlert showView];
        __weak typeof(cell) weakCell = cell;
        singleSelectAlert.singleSelectIndex = ^(NSInteger index, NSString *selectStr){
            if (index == 0) {
                weakCell.detailTextLabel.text = selectStr;
                [_voucherInfoDic setObject:_isVoucherCard ? @"0":@"2" forKey:@"cardType"];
                chooseTitleArr = @[@"减", @"¥"];
            } else if (index == 1) {
                weakCell.detailTextLabel.text = selectStr;
                [_voucherInfoDic setObject:_isVoucherCard ? @"1":@"3" forKey:@"cardType"];
                chooseTitleArr = @[@"打", @"折"];
            } else;

            [_tableV reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:1 inSection:0]] withRowAnimation:UITableViewRowAnimationAutomatic];
        };
    }

    if (indexPath.row == 2) {
        [self showLimitTimeZone];
    }

    if (indexPath.row == 3) {
        //设置发放条件
        TextFieldViewController *textVC = [[TextFieldViewController alloc] init];
        textVC.title = @"使用条件";
        textVC.textDidFinish = ^(NSString *text){
            if (text) {
                UITableViewCell *cell = [_tableV cellForRowAtIndexPath:indexPath];
                cell.detailTextLabel.text = [NSString stringWithFormat:@"消费满%@元发放", text];
                [_voucherInfoDic setObject:text forKey:@"conditions"];
            }
        };
        [self.navigationController pushViewController:textVC animated:YES];
    }
}
- (void)showTopVoucherView{
    /** top alertView **/
    NSMutableArray *leftArr = [NSMutableArray array];
    NSMutableArray *rightArr = [NSMutableArray array];
    for (NSInteger i =9; i >= 0; i --) {
        if (i == 0) {
        } else {
            [leftArr addObject:[NSString stringWithFormat:@"%ld", (long)i]];
        }
        [rightArr addObject:[NSString stringWithFormat:@"%.1lf", i / 10.0]];
    }
    ZT_doublePickerView *discountPicker = [[ZT_doublePickerView alloc] initWithLeftArr:leftArr RightArr:rightArr];
    discountPicker.delegate = self;
    discountPicker.titleLabel.text = @"选择折扣程度";
    [discountPicker.addBT setTitle:@"确定" forState:UIControlStateNormal];
    discountPicker.categortyLabel.text = @"整数";
    discountPicker.numLabel.text = @"小数";
    [discountPicker showTime];
}
- (void)ZTselectTimesView:(ZT_doublePickerView *)deskPicker SetOneLeft:(NSString *)oneLeft andOneRight:(NSString *)oneRight{
    AddVoucherCell *cell = [_tableV cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
    cell.secTextField.text = [NSString stringWithFormat:@"%.1lf", ([oneLeft doubleValue] + [oneRight doubleValue])];
    [_voucherInfoDic setObject:[NSString stringWithFormat:@"%.1lf",[oneLeft doubleValue] + [oneRight doubleValue]] forKey:@"discount"];

}
#pragma mark -------- 当所有卡券信息填写完整后， 完成按钮变色， 点击后返回上一页，并用block回调，传回保存好的卡券字典信息 －－－－
-(void)returnVoucherValues:(returnValues)valuesDic{
    _returnValues = valuesDic;
}
/** 展示使用期限 **/
- (void)showLimitTimeZone{


    ZT_TimerPickerView_Double *firstPicker = [[ZT_TimerPickerView_Double alloc] initWithStartTime:nil];
    [firstPicker.addBT setTitle:@"下一步" forState:UIControlStateNormal];
    [firstPicker  showView];
    firstPicker.returnSelectDate = ^(NSString *firstDate){
        UITableViewCell *cell = [_tableV cellForRowAtIndexPath:_currentIndexPath];
        ZT_TimerPickerView_Double *secondPicker = [[ZT_TimerPickerView_Double alloc] initWithStartTime:firstDate];
        secondPicker.titleLabel.text = @"设置优惠截止时间";
        [secondPicker showView];
        secondPicker.returnSelectDate = ^ (NSString *secondDate){
            cell.detailTextLabel.text = [NSString stringWithFormat:@"%@至%@", firstDate, secondDate];
            [_voucherInfoDic setObject:firstDate forKey:@"beginTime"];
            [_voucherInfoDic setObject:secondDate forKey:@"endTime"];
            _currentIndexPath = [NSIndexPath indexPathForRow:1 inSection:0];
        };
    };
}
- (NSString *)timeTransformToTimesWithDate:(NSString*)date{

    NSDateFormatter  *dateformatter=[[NSDateFormatter alloc] init];
    [dateformatter setDateFormat:@"YYYY-MM-dd"];

    NSDate * now = [dateformatter dateFromString:date];
    //转成时间戳
    NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)[now timeIntervalSince1970] * 1000];

    return timeSp;
}
//赋值给textField
-(void)didFinishPickView:(NSString *)date
{
    [_voucherInfoDic setObject:date forKey:@"beginTime"];
    UITableViewCell *cell = [_tableV cellForRowAtIndexPath:_currentIndexPath];
    cell.detailTextLabel.text = date;

}
-(void)ZTselectTimesViewSetOneLeft:(NSString *)oneLeft andOneRight:(NSString *)oneRight andTwoLeft:(NSString *)twoLeft andTwoRight:(NSString *)twoRight{

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
