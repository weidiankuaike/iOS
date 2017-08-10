//
//  RestaurantActivityVC.m
//  微点筷客商户端
//
//  Created by Skyer God on 16/10/18.
//  Copyright © 2016年 张森森. All rights reserved.
//

#import "RestaurantActivityVC.h"
#import "BaseButton.h"
#import "ZT_doublePickerView.h"
#import "AddVoucherVC.h"
#import "VoucherViewMedel.h"
#import "TextFieldViewController.h"
#import "ZTAddOrSubAlertView.h"
#import "NewVoucherCell.h"
#import <MJExtension/MJExtension.h>
#import "BottomAddVoucherCell.h"
#import "NSObject+JudgeNull.h"
#import "MBProgress+GodSkyer.h"
#import "NewActivityCell.h"

@interface RestaurantActivityVC ()<UITextViewDelegate, UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource>
/** textView   (strong) **/
@property (nonatomic, strong) UITextView *textView;
@property (nonatomic, strong) UIView *shoppingNoticeView;
@property (nonatomic, strong)UILabel *separatorLine;

/** 保存添加卡券内容字典   (strong) **/
@property (nonatomic, strong) NSMutableDictionary *addVoucherDic;

/** 保存活动的数组   (strong) **/
@property (nonatomic, strong) NSMutableArray *addActivityArr;
/** 保存卡券的数组   (strong) **/
@property (nonatomic, strong) NSMutableArray *addVoucherArr;
/** 弹窗遮罩页   (strong) **/
@property (nonatomic, strong) UIView *maskView;
/** 中间卡券类型选择视图   (strong) **/
@property (nonatomic, strong) UIView *midVoucherAlert;

/** 选择的类型   (strong) **/
@property (nonatomic, copy) NSString *currentCategory;

/** 卡券信息字典key－model类   (strong) **/
@property (nonatomic, strong) VoucherViewMedel *model;

@property (nonatomic, strong) UITableView *voucherTabeV;

/** 判断是卡券还是活动   (NSInteger) **/
@property (nonatomic, assign) BOOL isVoucherCard;
@end

@implementation RestaurantActivityVC

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:YES];
    BaseButton *shoppingNoticeBT = (BaseButton *)[self.view viewWithTag:100];
    if (shoppingNoticeBT.isSelected) {
        [_textView becomeFirstResponder];
    }

    [IQKeyboardManager sharedManager].shouldResignOnTouchOutside = YES;
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:YES];
    [_textView resignFirstResponder];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [ReloadVIew registerReloadView:self];
    // Do any additional setup after loading the view.
    self.rightBarItem.hidden = YES;
    self.view.backgroundColor = [UIColor whiteColor];
    [self createShopActivityView];
    self.titleView.text = @"餐厅活动";
    self.tabBarController.tabBar.hidden = YES;
    [self getDataNoticeboardInfoWithLoadStatus:0 noticeBoard:nil];

}
-(void)leftBarButtonItemAction{
    [self dismissViewControllerAnimated:YES completion:nil];
}

//店铺公告 查询
- (void)getDataNoticeboardInfoWithLoadStatus: (NSInteger)type noticeBoard:(NSString *)noticeBoard{
    NSString *keyApi = @"api/merchant/editNoticeBoard";
    // 0 查询  1 修改

    NSString *uploadUrl = [NSString stringWithFormat:@"%@%@?token=%@&storeId=%@&type=%ld&noticeBoard=%@", kBaseURL, keyApi, TOKEN, storeID, (long)type, noticeBoard];

    [SVProgressHUD showWithStatus:@"加载中..."];

    [[QYXNetTool shareManager] postNetWithUrl:uploadUrl urlBody:nil bodyStyle:QYXBodyString header:nil response:QYXJSON success:^(id result) {
        if (type == 0 && ![result[@"msgType"] isNull]) {
            id obj = result[@"obj"];
            if (![obj isNull]) {
                _textView.text = result[@"obj"];
            }
        }
        if (type == 1) {
            [SVProgressHUD showSuccessWithStatus:@"发布成功"];
        } else {
            [SVProgressHUD dismiss];
        }
    } failure:^(NSError *error) {

    }];
}
//餐厅卡券 查询
- (void)getDataWithVouchers{

    NSString *keyApi = @"api/merchant/searchActivities";
    NSString *uploadUrl = [NSString stringWithFormat:@"%@%@?token=%@&storeId=%@", kBaseURL, keyApi, TOKEN, storeID];

    [MBProgressHUD showHUDAddedTo:self.view animated:YES];

    [[QYXNetTool shareManager] postNetWithUrl:uploadUrl urlBody:nil bodyStyle:QYXBodyString header:nil response:QYXJSON success:^(id result) {
        _addActivityArr = [NSMutableArray array];
        _addVoucherArr = [NSMutableArray array];
        //0 启用 1 停用  2 过期  type
        ZTLog(@"%@", result);
        dispatch_async(dispatch_get_main_queue(), ^{
            if ([result[@"msgType"] integerValue] == 0) {
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                [result[@"obj"] enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    VoucherViewMedel *model = [VoucherViewMedel mj_objectWithKeyValues:obj];
                    if ([model.cardType isEqualToString:@"2"] || [model.cardType isEqualToString:@"3"]) {
                         [_addActivityArr addObject:model];
                    } else {
                        [_addVoucherArr addObject:model];
                    }
                }];
            } else {
                [SVProgressHUD showErrorWithStatus:@"查询失败"];
            }
            [_voucherTabeV reloadData];
        });
    } failure:^(NSError *error) {

    }];

}
//上传
- (void)uploadVoucherCardWithModel:(VoucherViewMedel *)model{
    _addActivityArr = [NSMutableArray new];
    NSString *keyApi = @"api/merchant/operationActivities";
    NSString *cardTitle = @"";
    NSString *discount = model.discount;
    NSString *discountedPrice = model.discountedPrice;
    switch ([model.cardType integerValue]) {
        case 0:
            cardTitle = [NSString stringWithFormat:@"%@元代金券", model.consumptionOver];
            discount = @"";
            break;
        case 1:
            cardTitle = [NSString stringWithFormat:@"%@元折扣券", model.consumptionOver];
            discountedPrice = @"";
            break;
        case 2:
            cardTitle = [NSString stringWithFormat:@"满%@减%@", model.consumptionOver, model.discountedPrice];
             discount = @"";
            break;
        case 3:
            cardTitle = [NSString stringWithFormat:@"满%@打%@折", model.consumptionOver, model.discount];
            discountedPrice = @"";
            break;

        default:
            break;
    }
    NSString *cardType = model.cardType;//0:代金券，1:折扣卷，2：店铺活动（满减）3：店铺活动（折扣）
    NSString *consumptionOver = model.consumptionOver;//使用条件
    NSString *conditions = @"0";
    if (_isVoucherCard) {
        conditions = model.conditions; //发放条件
    }
    NSString *beginTime = model.beginTime;
    NSString *endTime = model.endTime;
    NSString *type = @"0"; //0 新增 1 删除
    NSString *operationType = @"0";
    NSString *uploadUrl = [NSString stringWithFormat:@"%@%@?token=%@&storeId=%@&type=%@&cardTitle=%@&cardType=%@&discountedPrice=%@&discount=%@&susidyCard=%@&issuingOpportunity=%@&consumptionOver=%@&conditions=%@&beginTime=%@&endTime=%@&operationType=%@", kBaseURL, keyApi, TOKEN, storeID, type, cardTitle, cardType, discountedPrice, discount, cardType, cardType, consumptionOver, conditions,beginTime,endTime, operationType];


    [[QYXNetTool shareManager] postNetWithUrl:uploadUrl urlBody:nil bodyStyle:QYXBodyString header:nil response:QYXJSON success:^(id result) {

        if ([result[@"msgType"] integerValue] == 0) {

            [self getDataWithVouchers];
        }
    } failure:^(NSError *error) {

    }];

}
//停用 or  启用 operationType  传 1 修改  type = //0 启用 1 停用 2
- (void)uploadDeleteVoucherWithVoucherId:(NSString *)ID withType:(NSString *)type{

    NSString *keyApi = @"api/merchant/operationActivities";
    NSString *voucherId = ID;
    NSString *operationType = @"1";
    NSString *uploadUrl = [NSString stringWithFormat:@"%@%@?token=%@&storeId=%@&type=%@&id=%@&operationType=%@", kBaseURL, keyApi, TOKEN, storeID, type,voucherId, operationType];

    [MBProgressHUD showHUDAddedTo:self.view animated:YES];

    [[QYXNetTool shareManager] postNetWithUrl:uploadUrl urlBody:nil bodyStyle:QYXBodyString header:nil response:QYXJSON success:^(id result) {

        dispatch_async(dispatch_get_main_queue(), ^{
            if ([result[@"msgType"] integerValue] == 0) {
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                [self getDataWithVouchers];
            }
        });

    } failure:^(NSError *error) {
        //删除失败
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [_voucherTabeV reloadData];
    }];
}
/** 店铺公告  餐厅卡券  平台活动 **/
- (void)createShopActivityView{
    NSArray *arr = @[@"店铺公告",@"餐厅活动",@"餐厅卡券"];
    NSArray *arrUnImgs = @[@"公告未选中",@"平台活动未选中",@"餐厅卡券未选中"];
    NSArray *arrImgs = @[@"公告选中", @"平台活动选中",@"餐厅卡券选中"];
    for (NSInteger i = 0; i < arr.count; i++) {

        BaseButton *button = [BaseButton buttonWithType:UIButtonTypeCustom];
        [button setImage:[UIImage imageNamed:arrUnImgs[i]] forState:UIControlStateNormal];
        [button setImage:[UIImage imageNamed:arrImgs[i]] forState:UIControlStateSelected];
        [button setTitle:arr[i] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        [button setTitleColor:RGBA(242, 157, 56, 0.8) forState:UIControlStateSelected];
        [button.titleLabel setFont:[UIFont systemFontOfSize:15]];
        [button addTarget:self action:@selector(buttonGroupAction:) forControlEvents:UIControlEventTouchUpInside];
        [button setBackgroundColor:[UIColor lightTextColor]];
        button.tag = 100 + i;
        [self.view addSubview:button];
        if (i == 0) {
            button.selected = YES;
        }

        CGFloat start_x = autoScaleW(25);
        CGFloat start_y = 64 + autoScaleW(25);
        CGFloat height = autoScaleH(105);
        CGFloat lineSapce = autoScaleW(35);
        CGFloat width = (self.view.frame.size.width - lineSapce * (arr.count - 1) - start_x * 2) / arr.count;
        button.sd_layout
        .leftSpaceToView(self.view, start_x + (width + lineSapce) * i)
        .topSpaceToView(self.view, start_y)
        .widthIs(width)
        .heightIs(height);

        button.Image_X = autoScaleW(10);
        button.Image_Y = autoScaleH(5);
        button.Title_Space = autoScaleH(10);
    }

    _separatorLine = [[UILabel alloc] init];
    _separatorLine.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:_separatorLine];

    _separatorLine.sd_layout
    .leftSpaceToView(self.view, autoScaleW(7))
    .topSpaceToView([self.view viewWithTag:100], autoScaleH(15))
    .rightSpaceToView(self.view, autoScaleW(7))
    .heightIs(0.8);

    [self buttonGroupAction:[self.view viewWithTag:100]];
}

// 三个选项点击响应
- (void)buttonGroupAction:(BaseButton *)sender{

    static NSInteger oldTag = 100;

    if (oldTag == sender.tag) {
        if (sender.tag == 100) {
            //编辑信息
            self.shoppingNoticeView.backgroundColor = [UIColor whiteColor];
        } else if (sender.tag == 101)  {
             [self getDataWithVouchers];
        } else {
            [self getDataWithVouchers];
        }
    } else {

        if (sender.tag == 100) {
            self.shoppingNoticeView.hidden = NO;
            self.shoppingNoticeView.backgroundColor = [UIColor whiteColor];
            self.voucherTabeV.hidden = !_shoppingNoticeView.hidden;

        } else if (sender.tag == 101) {
            //创建活动
            _isVoucherCard = NO;
            self.voucherTabeV.backgroundColor = [UIColor whiteColor];
            _voucherTabeV.hidden = NO;
            self.shoppingNoticeView.hidden = !_voucherTabeV.hidden;
            [self getDataWithVouchers];
        } else {
            //卡券信息
            _isVoucherCard = YES;
            self.voucherTabeV.backgroundColor = [UIColor whiteColor];
            _voucherTabeV.hidden = NO;
            self.shoppingNoticeView.hidden = !_voucherTabeV.hidden;
            [self getDataWithVouchers];
        }

        BaseButton *button = (BaseButton *)[self.view viewWithTag:oldTag];
        button.selected = NO;
        sender.selected = YES;
    }
    oldTag = sender.tag;
    if (sender.tag !=100) {
        [_textView resignFirstResponder];
    }
}
#pragma mark -- 懒加载 第一个 店铺公告
-(UIView *)shoppingNoticeView{
    if (!_shoppingNoticeView) {
        _shoppingNoticeView = [[UIView alloc] init];
        _shoppingNoticeView.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:_shoppingNoticeView];

        self.shoppingNoticeView.sd_layout
        .leftSpaceToView(self.view, autoScaleW(10))
        .rightSpaceToView(self.view, autoScaleW(10))
        .topSpaceToView(_separatorLine, autoScaleH(10));

        UIImageView *imageV = [[UIImageView alloc] init];
        imageV.image = [UIImage imageNamed:@"编辑笔"];
        [self.shoppingNoticeView addSubview:imageV];

        UILabel *titleLabel = [[UILabel alloc] init];
        titleLabel.text = @"发布公告";
        titleLabel.font = [UIFont systemFontOfSize:autoScaleW(14)];
        titleLabel.textColor = [UIColor lightGrayColor];
        [self.shoppingNoticeView addSubview:titleLabel];

        _textView = [[UITextView alloc] initWithFrame:CGRectZero];
        _textView.backgroundColor = [UIColor whiteColor];
        _textView.delegate = self;//设置它的委托方法
        _textView.returnKeyType = UIReturnKeyDefault;//返回键的类型

        _textView.keyboardType = UIKeyboardTypeDefault;//键盘类型

        _textView.scrollEnabled = YES;//是否可以拖动

        _textView.textAlignment = NSTextAlignmentLeft; //文本显示的位置默认为居左

        _textView.autoresizingMask = UIViewAutoresizingFlexibleHeight;//自适应高度
        _textView.dataDetectorTypes = UIDataDetectorTypeAll; //显示数据类型的连接模式（如电话号码、网址、地址等）
        _textView.editable = YES;        //是否允许编辑内容，默认为“YES”

        [self.shoppingNoticeView addSubview:_textView];

        imageV.sd_layout
        .leftEqualToView(_shoppingNoticeView)
        .topSpaceToView(_shoppingNoticeView, autoScaleW(10))
        .widthIs(autoScaleW(15))
        .heightEqualToWidth(0);

        titleLabel.sd_layout
        .leftSpaceToView(imageV, autoScaleW(3))
        .topEqualToView(imageV)
        .heightIs(autoScaleH(15));
        [titleLabel setSingleLineAutoResizeWithMaxWidth:100];

        _textView.sd_layout
        .leftEqualToView(_shoppingNoticeView)
        .topSpaceToView(imageV, autoScaleH(3))
        .rightEqualToView(_shoppingNoticeView)
        .heightIs(autoScaleH(120));

        _textView.layer.borderColor = [UIColor lightGrayColor].CGColor;
        _textView.layer.borderWidth = 0.8;
        [_textView setSd_cornerRadiusFromHeightRatio:@(0.075)];

        NSArray *buttonArr = @[@"确认",@"放弃"];
        for (NSInteger i = 0; i < buttonArr.count; i ++) {
            ButtonStyle *button = [ButtonStyle buttonWithType:UIButtonTypeCustom];
            [button setTitle:buttonArr[i] forState:UIControlStateNormal];
            [_shoppingNoticeView addSubview:button];
            CGFloat width = autoScaleW(50);
            button.sd_layout
            .rightSpaceToView(_shoppingNoticeView, 0 + (width + 5) *i)
            .topSpaceToView(_textView, 7)
            .widthIs(width)
            .heightIs(autoScaleH(30));
            button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
            [button.titleLabel setFont:[UIFont systemFontOfSize:14]];
            button.layer.borderWidth = 0.8;
            [button addTarget:self action:@selector(confirmOrRevokeAction:) forControlEvents:UIControlEventTouchUpInside];
            button.tag = 300 + i;
            if (i == buttonArr.count) {
                [button setTitleColor:RGBA(242, 157, 56, 0.8) forState:UIControlStateNormal];
                button.layer.borderColor = button.titleLabel.textColor.CGColor;

            } else {
                [button setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
                button.layer.borderColor = button.titleLabel.textColor.CGColor;
            }
            [button setSd_cornerRadiusFromHeightRatio:@(0.2)];
        }

        [self.shoppingNoticeView setupAutoHeightWithBottomView:[self.shoppingNoticeView viewWithTag:300] bottomMargin:0];

    }
    return _shoppingNoticeView;
}
#pragma mark -- 懒加载 中间餐厅卡券
-(UITableView *)voucherTabeV{
    if (!_voucherTabeV) {
        _voucherTabeV = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _voucherTabeV.delegate = self;
        _voucherTabeV.dataSource = self;
        _voucherTabeV.backgroundColor = [UIColor whiteColor];
        _voucherTabeV.separatorStyle = 0;
        [self.view addSubview:_voucherTabeV];

        [_voucherTabeV registerClass:[BottomAddVoucherCell class] forCellReuseIdentifier:@"bottomCell"];
        _voucherTabeV.showsVerticalScrollIndicator = NO;

        self.voucherTabeV.sd_layout
        .topSpaceToView(_separatorLine, autoScaleH(10))
        .leftEqualToView(_shoppingNoticeView)
        .rightEqualToView(_shoppingNoticeView)
        .bottomSpaceToView(self.view, autoScaleH(10));

    }
    return _voucherTabeV;
}
#pragma mark -----------------/** 挡添加卡券信息完整后回调，并创建一张卡券的完整信息 **/------------------
/** 创建餐厅卡券 **/
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (_isVoucherCard) {
        return _addVoucherArr.count + 1;
    } else {
        return _addActivityArr.count + 1;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.001;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    if (_isVoucherCard && indexPath.section < _addVoucherArr.count) {
        VoucherViewMedel *model = _addVoucherArr[indexPath.row];
        return [_voucherTabeV cellHeightForIndexPath:indexPath model:model keyPath:@"model" cellClass:[NewActivityCell class] contentViewWidth:[self cellContentViewWith]];
    } else if (!_isVoucherCard && indexPath.section < _addActivityArr.count) {

        VoucherViewMedel *model = _addActivityArr[indexPath.row];
        return [_voucherTabeV cellHeightForIndexPath:indexPath model:model keyPath:@"model" cellClass:[NewActivityCell class] contentViewWidth:[self cellContentViewWith]];
    } else {
        return autoScaleH(80);
    }

}
- (CGFloat)cellContentViewWith
{
    CGFloat width = [UIScreen mainScreen].bounds.size.width;

    // 适配ios7横屏
    if ([UIApplication sharedApplication].statusBarOrientation != UIInterfaceOrientationPortrait && [[UIDevice currentDevice].systemVersion floatValue] < 8) {
        width = [UIScreen mainScreen].bounds.size.height;
    }
    return width;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    [NewActivityCell isVoucherCard:_isVoucherCard];
    if (!_isVoucherCard && indexPath.section < _addActivityArr.count) {
        NewActivityCell *cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([NewActivityCell class]) owner:self options:nil] lastObject];
        cell.isVoucherCard = _isVoucherCard;
        VoucherViewMedel *model = _addActivityArr[indexPath.section];
        cell.model = model;
        return cell;

    } else if (_isVoucherCard && indexPath.section < _addVoucherArr.count) {
        NewActivityCell *cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([NewActivityCell class]) owner:self options:nil] lastObject];
        VoucherViewMedel *model = _addVoucherArr[indexPath.section];
        cell.isVoucherCard = _isVoucherCard;
        cell.model = model;

        return cell;

    } else {

        BottomAddVoucherCell *bottomAddCell = [tableView dequeueReusableCellWithIdentifier:@"bottomCell"];
        bottomAddCell.addVoucherBT.userInteractionEnabled = YES;
        [bottomAddCell.addVoucherBT addTarget:self action:@selector(showAlertViewWithSubView) forControlEvents:UIControlEventTouchUpInside];
        bottomAddCell.editing = NO;
        if (_isVoucherCard) {
            [bottomAddCell.addVoucherBT setTitle:@"+ 添加卡券" forState:UIControlStateNormal];
        } else {
            [bottomAddCell.addVoucherBT setTitle:@"+ 添加活动" forState:UIControlStateNormal];
        }
        return bottomAddCell;
    }
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section  == _addActivityArr.count && !_isVoucherCard) {
        return UITableViewCellEditingStyleNone;
    } else if (indexPath.section  == _addVoucherArr.count && _isVoucherCard){
        return UITableViewCellEditingStyleNone;
    } else {
        return UITableViewCellEditingStyleDelete;
    }
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return [UIView new];
}
- (nullable NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath{
    NewVoucherCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    VoucherViewMedel *model = nil;
    if (_isVoucherCard) {
        model = [_addVoucherArr objectAtIndex:indexPath.section];
    } else {
        model = [_addActivityArr objectAtIndex:indexPath.section];
    }

    UITableViewRowAction *action = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"停用" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {

        if ([model.type isEqualToString:@"0"]) {
            ZTAddOrSubAlertView *alertV = [[ZTAddOrSubAlertView alloc] initWithStyle:ZTalertSheetStyleSubTitle];
            [alertV showView];
            alertV.titleLabel.text = @"确定停用卡券？";
            alertV.littleLabel.text = @"确定后，此卡券将会被停用，已经发放给用户的卡券，还可继续使用。";
            alertV.littleLabel.adjustsFontSizeToFitWidth = YES;
            alertV.complete = ^(BOOL isSure){
                if (isSure) {
                    [self uploadDeleteVoucherWithVoucherId:model.voucheID withType:@"1"];
                    cell.contentView.backgroundColor = UIColorFromRGB(0xffe2b6);
                }
                //                [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            };

        } else if ([model.type isEqualToString:@"1"]) {
//            [SVProgressHUD showInfoWithStatus:@"已停用"];
            ZTAddOrSubAlertView *alertV = [[ZTAddOrSubAlertView alloc] initWithStyle:ZTalertSheetStyleSubTitle];
            [alertV showView];
            alertV.titleLabel.text = @"确定启用卡券？";
            alertV.littleLabel.text = @"确定后，此卡券将会立即生效。";
            alertV.littleLabel.adjustsFontSizeToFitWidth = YES;
            alertV.complete = ^(BOOL isSure){
                if (isSure) {
                    [self uploadDeleteVoucherWithVoucherId:model.voucheID withType:@"0"];
                    cell.contentView.backgroundColor = UIColorFromRGB(0xffe2b6);
                }
            };
        } else {
            [SVProgressHUD showInfoWithStatus:@"已过期"];
        }
    }];
    return @[action];
}
/** 选择卡券类型 **/
- (void)showAlertViewWithSubView{

    AddVoucherVC *voucherVC = [[AddVoucherVC alloc] init];
    voucherVC.isVoucherCard = _isVoucherCard;
    [self.navigationController pushViewController:voucherVC animated:YES];
    [voucherVC returnVoucherValues:^(NSMutableDictionary *dic) {
        VoucherViewMedel *model = [VoucherViewMedel mj_objectWithKeyValues:[dic mutableCopy]];

        [self uploadVoucherCardWithModel:model];
    }];

}

- (void)dismiss{
    [UIView animateWithDuration:.35 animations:^{
        _midVoucherAlert.alpha = 0;
        _maskView.alpha = 0;
    } completion:^(BOOL finished) {
        _maskView.hidden = YES;
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -----------textView delegate ----

-(void)textViewDidBeginEditing:(UITextView *)textView{
    if (textView.hasText) {
        ButtonStyle *confirmBT = (ButtonStyle *)[self.view viewWithTag:300];
        [confirmBT setTitleColor:RGBA(242, 157, 56, 0.8) forState:UIControlStateNormal];
        confirmBT.layer.borderColor = RGBA(242, 157, 56, 0.8).CGColor;

        ButtonStyle *cancelBT = (ButtonStyle *)[self.view viewWithTag:301];
        [cancelBT setTitleColor:[[UIColor redColor] colorWithAlphaComponent:0.5] forState:UIControlStateNormal];
        cancelBT.layer.borderColor = [[UIColor redColor] colorWithAlphaComponent:0.5].CGColor;

    }
    textView.attributedText = [[NSAttributedString alloc] initWithString:textView.text attributes:[self handleTextWithStyle]];
}
- (void)confirmOrRevokeAction:(ButtonStyle *)sender{
    if (sender.tag == 301) {
        //取消
        _textView.text = @"";
        ButtonStyle *confirmBT = (ButtonStyle *)[self.view viewWithTag:300];
        [confirmBT setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        confirmBT.layer.borderColor = [UIColor lightGrayColor].CGColor;

        ButtonStyle *cancelBT = (ButtonStyle *)[self.view viewWithTag:301];
        [cancelBT setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        cancelBT.layer.borderColor = [UIColor lightGrayColor].CGColor;
    } else {
        //提交
        [self getDataNoticeboardInfoWithLoadStatus:1 noticeBoard:_textView.text];

    }

}
-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    if (range.location == 0 && [text isEqualToString:@""]) {
        ButtonStyle *confirmBT = (ButtonStyle *)[self.view viewWithTag:300];
        [confirmBT setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        confirmBT.layer.borderColor = [UIColor lightGrayColor].CGColor;

        ButtonStyle *cancelBT = (ButtonStyle *)[self.view viewWithTag:301];
        [cancelBT setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        cancelBT.layer.borderColor = [UIColor lightGrayColor].CGColor;
    } else {
        ButtonStyle *confirmBT = (ButtonStyle *)[self.view viewWithTag:300];
        [confirmBT setTitleColor:RGBA(242, 157, 56, 0.8) forState:UIControlStateNormal];
        confirmBT.layer.borderColor = RGBA(242, 157, 56, 0.8).CGColor;

        ButtonStyle *cancelBT = (ButtonStyle *)[self.view viewWithTag:301];
        [cancelBT setTitleColor:[[UIColor redColor] colorWithAlphaComponent:0.5] forState:UIControlStateNormal];
        cancelBT.layer.borderColor = [[UIColor redColor] colorWithAlphaComponent:0.5].CGColor;
    }
    textView.attributedText = [[NSAttributedString alloc] initWithString:textView.text attributes:[self handleTextWithStyle]];
    return YES;
}
- (NSDictionary *)handleTextWithStyle{
    //首行缩进
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = 3;    //行间距
    paragraphStyle.firstLineHeadIndent = 8;    /**首行缩进宽度*/
    paragraphStyle.alignment = NSTextAlignmentJustified;
    NSDictionary *attributes = @{
                                 NSFontAttributeName:[UIFont systemFontOfSize:autoScaleW(13)],
                                 NSParagraphStyleAttributeName:paragraphStyle
                                 };
    return attributes;
}
-(BOOL)textViewShouldEndEditing:(UITextView *)textView{
    textView.attributedText = [[NSAttributedString alloc] initWithString:textView.text attributes:[self handleTextWithStyle]];
    return [textView resignFirstResponder];
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
