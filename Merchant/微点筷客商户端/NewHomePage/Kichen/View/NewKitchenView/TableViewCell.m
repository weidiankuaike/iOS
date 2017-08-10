//
//  TableViewCell.m
//  微点筷客商户端
//
//  Created by Skyer God on 16/11/9.
//  Copyright © 2016年 张森森. All rights reserved.
//

#import "TableViewCell.h"
#import "InnerKitchenCell.h"
#import "ZTAlertSheetView.h"
#import "ZTAddOrSubAlertView.h"
@interface TableViewCell ()<UITableViewDataSource, UITableViewDelegate, UIGestureRecognizerDelegate>
{
    BOOL isShowDeleteLineWhenEndAnimation;
    NSIndexPath *indexP;
    void(^NetRequireSuccess)(BOOL success);
    void(^NetRequireError)(NSError *error);
    UIPanGestureRecognizer *swipRight;
}
@end
@implementation TableViewCell
static CGFloat outCellHeight = 40;
static const CGFloat height = 40;
static const CGFloat innerCellHeight = 80;
+(CGFloat)cellHeight
{
    return outCellHeight;
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(UIImageView *)indicatorImageV{
    if (!_indicatorImageV) {
        _indicatorImageV = [[UIImageView alloc] init];
        _indicatorImageV.image = [UIImage imageNamed:@"左右三角"];
        [self.contentView addSubview:_indicatorImageV];
        _indicatorImageV.sd_layout
        .leftSpaceToView(self.contentView, 23)
        .topSpaceToView(self.contentView, (height - _indicatorImageV.image.size.height) / 2 + 3)
        .widthIs(_indicatorImageV.image.size.width)
        .heightEqualToWidth(0);

    }
    return _indicatorImageV;
}
-(UILabel *)outNameLabel{
    if (!_outNameLabel) {
        _outNameLabel = [[UILabel alloc] init];
        _outNameLabel.text = @"红烧鲤鱼";
        _outNameLabel.font = [UIFont systemFontOfSize:15];
        [self.contentView addSubview:_outNameLabel];

        self.outNameLabel.sd_layout
        .leftSpaceToView(self.indicatorImageV, 15)
        .centerYEqualToView(self.indicatorImageV)
        .heightIs(height - 3);
        [self.outNameLabel setSingleLineAutoResizeWithMaxWidth:200];
    }
    return _outNameLabel;
}
- (UILabel *)outNumLabel{
    if (!_outNumLabel) {
        _outNumLabel = [[UILabel alloc] init];
        _outNumLabel.text = @"(共8份)";
        _outNumLabel.font = [UIFont systemFontOfSize:12];
        [self.contentView addSubview:_outNumLabel];

        self.outNumLabel.sd_layout
        .leftSpaceToView(_outNameLabel, 5)
        .centerYEqualToView(_outNameLabel)
        .heightIs(20);
        [self.outNumLabel setSingleLineAutoResizeWithMaxWidth:100];
    }
    return _outNumLabel;
}
-(UILabel *)promptLabel{
    if (!_promptLabel) {
        _promptLabel = [[UILabel alloc] init];
        _promptLabel.text = @"右滑管理全部";
        _promptLabel.font = [UIFont systemFontOfSize:13];
        [self.contentView addSubview:_promptLabel];

        self.promptLabel.sd_layout
        .centerYEqualToView(_outNameLabel)
        .rightSpaceToView(self.contentView, 23)
        .heightIs(20);
        [_promptLabel setSingleLineAutoResizeWithMaxWidth:160];
    }
    _promptLabel.hidden = YES;
    return _promptLabel;
}
- (UITableView *)innerTabelV{
    if (!_innerTabelV) {
        _innerTabelV = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _innerTabelV.delegate = self;
        _innerTabelV.dataSource = self;
        _innerTabelV.scrollsToTop = NO;
        _innerTabelV.bounces = NO;
        [self.contentView addSubview:_innerTabelV];
        [_innerTabelV registerClass:[InnerKitchenCell class] forCellReuseIdentifier:@"innerCell"];


        self.innerTabelV.sd_layout
        .leftEqualToView(self.indicatorImageV)
        .topSpaceToView(self.outNameLabel, 0)
        .rightEqualToView(self.contentView)
        .heightIs(0);

    }
    return _innerTabelV;
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {

        self.backgroundColor =[UIColor whiteColor];
        self.selectionStyle = 0;
        [self create];


        UILongPressGestureRecognizer *longGR = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongGestureMethod:)];
        [self.contentView addGestureRecognizer:longGR];

        swipRight = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(swipRightAction:)];
        //        swipRight.direction = UISwipeGestureRecognizerDirectionRight;
        [self.contentView addGestureRecognizer:swipRight];
        swipRight.delegate = self;

        isShowDeleteLineWhenEndAnimation = YES;

    }
    return self;
}
-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch{
    if ([touch.view isDescendantOfView:_innerTabelV] || !_model.isShow) {
        return NO;
    } else {
        return YES;
    }
}
- (void)swipRightAction:(UIPanGestureRecognizer *)swipGR{

    CGPoint point =[swipGR translationInView:self.contentView];
    CGFloat limitDistance = [UIScreen mainScreen].bounds.size.width * 2 / 5.0;
    if (swipGR.state == UIGestureRecognizerStateEnded && point.x > limitDistance && [_model.unServingNum integerValue] > 0) {

        ZTAddOrSubAlertView *alertSubTitle = [[ZTAddOrSubAlertView alloc]initWithStyle:ZTalertSheetStyleSubTitle];
        if (_isDeskSearch) {
            alertSubTitle.titleLabel.text = @"全部上菜";
            alertSubTitle.littleLabel.text = [NSString stringWithFormat:@"%@号桌的菜全部烹饪好了？", _model.boardNum];
        } else {
            alertSubTitle.titleLabel.text = @"全部上菜";
            alertSubTitle.littleLabel.text = [NSString stringWithFormat:@"所有桌的%@已经做好了？", _model.productName];
        }
        alertSubTitle.complete = ^(BOOL complete){
            if (complete) {
                if (!_isDeskSearch) {
                    //此时的ServingCount传0，代表是滑动外层事件
                    [self uploadServingDishesToServicesWithType:@"0" withServingCount:@"0"];
                } else {
                    [self uploadServingDishesToServicesWithType:@"1" withServingCount:@"0"];
                }
                __weak typeof(_innerTabelV) weakInnerTableV = _innerTabelV;
                NetRequireSuccess = ^(BOOL success){
                    if (success) {
                        NSInteger rows = [weakInnerTableV numberOfRowsInSection:0];
                        NSMutableArray *indexPathArr = [NSMutableArray array];
                        for (NSInteger i = 0; i  < rows; i++) {
                            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];
                            InnerKitchenCell *innerCell = [weakInnerTableV cellForRowAtIndexPath:indexPath];
                            innerCell.deleteLineLabel.hidden = NO;
                            [indexPathArr addObject:indexPath];
                        }
                    }
                };
            }
        };
    } else if (swipGR.state == UIGestureRecognizerStateEnded && point.x < -limitDistance){
        //        NSInteger rows = [_innerTabelV numberOfRowsInSection:0];
        //        NSMutableArray *indexPathArr = [NSMutableArray array];
        //        for (NSInteger i = 0; i  < rows; i++) {
        //            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];
        //            InnerKitchenCell *innerCell = [_innerTabelV cellForRowAtIndexPath:indexPath];
        //            innerCell.deleteLineLabel.hidden = YES;
        //            [indexPathArr addObject:indexPath];
        //        }
    }
}

- (void)handleLongGestureMethod:(longGesturePress )longGR{
    if (!_model.isShow) {

    } else {
        self.longGR();
    }
}
- (void)create{

    self.indicatorImageV.backgroundColor = [UIColor whiteColor];
    self.outNameLabel.backgroundColor = [UIColor whiteColor];
    self.outNumLabel.backgroundColor = [UIColor whiteColor];
    self.promptLabel.backgroundColor = [UIColor whiteColor];
    self.innerTabelV.backgroundColor = [UIColor whiteColor];

}
#pragma mark --- talbe Delegate ---
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.model.voList.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return innerCellHeight;
}
- (void)setEditing:(BOOL)editing animated:(BOOL)animated{
    [super setEditing:YES animated:YES];
}
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    InnerKitchenCell *innerCell = [tableView cellForRowAtIndexPath:indexPath];

    if (innerCell.deleteLineLabel.hidden == YES) {
        return UITableViewCellEditingStyleDelete;
    } else
        return UITableViewCellEditingStyleNone;
}
- (void)tableView:(UITableView *)tableView didEndEditingRowAtIndexPath:(NSIndexPath *)indexPath{

    isShowDeleteLineWhenEndAnimation = NO;
}
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{

    InnerKitchenCell *innerCell = (InnerKitchenCell *)[tableView cellForRowAtIndexPath:indexPath];
    NSArray *compontArr = [innerCell.numLabel.text componentsSeparatedByString:@" "];
    NSInteger num = [[compontArr lastObject] integerValue];
    __block NSInteger tempNum = num;
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        NSArray *array = @[@"该桌缺货", @"全部缺货", @"取消"];
        ZTAlertSheetView *alertSheet = [[ZTAlertSheetView alloc] initWithTitleArray:array];
        [alertSheet showView];
        alertSheet.alertSheetReturn = ^(NSInteger index){
            ZTAddOrSubAlertView *addOrSubAlert = nil;
            if (index == 0) {
                if (num > 1) {
                    //如果菜品数量大于1份， 显示菜品下架分数的选择栏
                    addOrSubAlert = [[ZTAddOrSubAlertView alloc] initWithStyle:ZTalertSheetStyleAddSubSelectTitle];
                    addOrSubAlert.rightArrowBT.hidden = YES;
                    addOrSubAlert.numLabel.text = [NSString stringWithFormat:@"%ld份", (long)num];
                    __weak typeof(addOrSubAlert) weakAddorSubAlert = addOrSubAlert;
                    addOrSubAlert.plus = ^(NSInteger count){
                        if (count >= num) {
                            count = num;
                            weakAddorSubAlert.rightArrowBT.hidden = YES;
                        } else{
                            weakAddorSubAlert.rightArrowBT.hidden = NO;
                        }
                        weakAddorSubAlert.numLabel.text = [NSString stringWithFormat:@"%ld份", (long)count];
                        tempNum = count;
                    };

                } else {
                    //如果为1份，弹出只有提示语句的缺货登记栏
                    addOrSubAlert = [[ZTAddOrSubAlertView alloc] initWithStyle:ZTalertSheetStyleSubTitle];
                }
                [addOrSubAlert showView];
                addOrSubAlert.complete = ^(BOOL complete){
                    if (complete) {
                        //#pragma mark 缺货  有份数
                        indexP = indexPath;
                        [self uploadlackFoodDishesToServices:tempNum];
                    }
                };
            } else if (index == 1) {
                //如果选择为全部缺货，显示全部缺货登记栏
                addOrSubAlert = [[ZTAddOrSubAlertView alloc] initWithStyle:ZTalertSheetStyleSubTitle];
                addOrSubAlert.complete = ^(BOOL complete){
                    if (complete) {
                        //全部缺货
                        [self uploadlackFoodDishesToServices:-1];
                    }
                };
            }
        };
    } else {

    }
}
- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath{
    return @"缺货登记";
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static double start = 0.1;
    if (indexPath.row == 0) {
        start = CFAbsoluteTimeGetCurrent();
    }
    NSString *str = @"innerCell";
    InnerKitchenCell *cell = [tableView dequeueReusableCellWithIdentifier:str];
    cell = [[InnerKitchenCell alloc] initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:str];
    cell.selectionStyle = 0;
    cell.isDeskSearch = _isDeskSearch;
    InnerKitchenModel *innnerModel =_model.voList[indexPath.row];
    innnerModel.ids = [_model.ids mutableCopy];
    cell.model = innnerModel;
    __weak typeof(cell) weakCell = cell;
    cell.swipRightComplete = ^(BOOL isShowDeleteLine){

        NSArray *compontArr = [weakCell.numLabel.text componentsSeparatedByString:@" "];
        NSInteger num = [[compontArr lastObject] integerValue];
        __block NSInteger tempNum = num;
        //isShowDeleteLineWhenEndAnimation状态判断是否时cell的编辑模式，防止在cell编辑完成时进行右滑上菜动作
        if (isShowDeleteLine && isShowDeleteLineWhenEndAnimation) {
            ZTAddOrSubAlertView *addOrSubAlert = nil;
            if (num > 1) {
                //如果菜品数量大于1份， 显示菜品下架分数的选择栏
                addOrSubAlert = [[ZTAddOrSubAlertView alloc] initWithStyle:ZTalertSheetStyleAddSubSelectTitle];
                addOrSubAlert.titleLabel.text = [NSString stringWithFormat:@"%@号桌的%@", innnerModel.boardNum, innnerModel.productName];
                addOrSubAlert.addSubViewBottoLabel.text = @"请选择您已经做好菜品的份数,点击确认上菜！";
                addOrSubAlert.rightArrowBT.hidden = YES;
                addOrSubAlert.numLabel.text = [NSString stringWithFormat:@"%ld份", (long)num];
                __weak typeof(addOrSubAlert) weakAddorSubAlert = addOrSubAlert;
                addOrSubAlert.plus = ^(NSInteger count){
                    if (count >= num) {
                        count = num;
                        weakAddorSubAlert.rightArrowBT.hidden = YES;
                    } else{
                        weakAddorSubAlert.rightArrowBT.hidden = NO;
                    }
                    weakAddorSubAlert.numLabel.text = [NSString stringWithFormat:@"%ld份", (long)count];
                    tempNum = count;
                };
                //点击弹窗的确定之后才能上传
                addOrSubAlert.complete = ^(BOOL complete){
                    NSString *numm = [NSString stringWithFormat:@"%ld", (long)tempNum];
                    if (complete) {
                        indexP = indexPath;
                        [self uploadServingDishesToServicesWithType:@"1" withServingCount:numm];
                    } else {
                        weakCell.deleteLineLabel.hidden = YES;
                    }
                };

            } else {
                //划单一的菜品
                indexP = indexPath;
                [self uploadServingDishesToServicesWithType:@"1" withServingCount:@"1"];
            }
        } else {
            indexP = indexPath;
            isShowDeleteLineWhenEndAnimation = !isShowDeleteLineWhenEndAnimation;
            if (weakCell.deleteLineLabel.hidden == NO) {
                NSString *nummmm = [NSString stringWithFormat:@"%ld", (long)num];
                [self uploadServingDishesToServicesWithType:@"2" withServingCount:nummmm];
            }
        }
        NetRequireSuccess = ^(BOOL success){
            if (success) {
                //处理是否显示删除线
                weakCell.deleteLineLabel.hidden = !isShowDeleteLine;
                if (isShowDeleteLineWhenEndAnimation == NO && isShowDeleteLine) {
                    //判断是滑动登记动作，还是滑动取消或上菜动作，根据cell的动画是否完成来做判断
                    weakCell.deleteLineLabel.hidden = YES;
                    isShowDeleteLineWhenEndAnimation = !isShowDeleteLineWhenEndAnimation;
                }
            }
        };
    };
    UIImage *image = [UIImage imageNamed:@"22"];
    NSData *data = UIImagePNGRepresentation(image);
    image = [UIImage imageWithData:data];

    if (indexPath.row == self.model.voList.count - 1) {
//        double end = CFAbsoluteTimeGetCurrent();
//        ZTLog(@"内存渲染耗时:%lf", end - start);
    }
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{


    //    if (self.sendClick) {
    //        self.sendClick(self.index,indexPath.row,isShowInnerDeleteLine);
    //    }
}

-(void)setModel:(OutKitchenModel *)model{
    _model = model;
    //    self.outNameLabel.text = model.name;

    if (!_isDeskSearch) {
        _outNameLabel.text = model.productName;
    } else {
        _outNameLabel.text = [NSString stringWithFormat:@"%@号桌", model.boardNum];
    }
    _outNumLabel.text = [NSString stringWithFormat:@"(共%@份)", model.unServingNum];
    CGFloat sumInnerCellHeight  = innerCellHeight * model.voList.count;


    _model.height = outCellHeight + sumInnerCellHeight;

    if (model.isShow == NO) {
        outCellHeight = height;
        _model.height = height;
        self.innerTabelV.sd_layout
        .leftEqualToView(self.indicatorImageV)
        .topSpaceToView(self.outNameLabel, 0)
        .rightEqualToView(self.contentView)
        .heightIs(0);
        [UIView animateWithDuration:.35 animations:^{
            self.indicatorImageV.transform = CGAffineTransformMakeRotation(0);
        }];

    } else {
        _model.height = height + sumInnerCellHeight;
        outCellHeight = _model.height;
        self.innerTabelV.sd_layout
        .leftEqualToView(self.indicatorImageV)
        .topSpaceToView(self.outNameLabel, 0)
        .rightEqualToView(self.contentView)
        .heightIs(sumInnerCellHeight);

        [UIView animateWithDuration:.35 animations:^{


            self.indicatorImageV.transform = CGAffineTransformMakeRotation(M_PI_2);
        }];

    }
    dispatch_async(dispatch_get_main_queue(), ^{
        self.promptLabel.hidden = !model.isShow;
        [_innerTabelV reloadData];
    });

}
#pragma mark ------ 缺货登记操作 －－－－－
- (void)uploadlackFoodDishesToServices:(NSInteger )count{
    InnerKitchenModel *innerModel = _model.voList[indexP.row];
    NSString *keyUrl = @"api/merchant/lackKitchen";
    NSString *orderId = innerModel.orderId;
    NSString *productId = innerModel.productId;
    NSString *deskId = innerModel.boardNum;
    NSString *storeId = storeID;
    NSString *lackFoodCount = [NSString stringWithFormat:@"%ld",(long)count];

    //缺货 lackFoodCount 份
    NSString *uploadUrl = [NSString stringWithFormat:@"%@%@?token=%@&storeId=%@&productId=%@&orderId=%@&boardNum=%@&lackFoodCount=%@", kBaseURL, keyUrl, TOKEN, storeId, productId, orderId, deskId, lackFoodCount];
    if (count < 0) {
        //全部缺货
        uploadUrl = [NSString stringWithFormat:@"%@%@?token=%@&storeId=%@&productId=%@&orderId=%@", kBaseURL, keyUrl, TOKEN, storeId, productId, orderId];
    }
    [MBProgressHUD showHUDAddedTo:self.superview.superview animated:YES];
      
    [[QYXNetTool shareManager] postNetWithUrl:uploadUrl urlBody:nil bodyStyle:QYXBodyString header:nil response:QYXJSON success:^(id result) {

        if ([result[@"msgType"] integerValue] == 0) {
            if (_lackFoodUploadCompleted) {
                _lackFoodUploadCompleted(_isDeskSearch);
            }
        } else {
            if (_lackFoodUploadCompleted) {
                _lackFoodUploadCompleted(NO);
            }
        }
        [MBProgressHUD hideHUDForView:self.superview.superview animated:YES];
    } failure:^(NSError *error) {


    }];
}
#pragma mark ------ 划单操作 －－－－－
- (void)uploadServingDishesToServicesWithType:(NSString *)type withServingCount:(NSString *)Serving{
    InnerKitchenModel *innerModel = _model.voList[indexP.row];
    NSString *keyUrl = @"api/merchant/kitchenServing";
    NSString *productId = innerModel.productId;//菜品id
    NSString *boardNum = innerModel.boardNum;//桌号
    NSString *count = Serving;//上菜数量
    NSString *storeId = storeID;//店铺id
    NSString *searchType = type;// 0 全部菜（所有桌子上这道菜） 1按桌子上菜  2撤销
    NSString *uploadUrl = nil;

    /* * *
     1.菜品查看    (1) 划内层： 店铺id  桌号 菜品id 数量 （必传） searchType = 1
                  (2) 划外层： 订单id数组， 菜品id （必传） 其它不用 searchType = 0
     2.桌号查看    (1) 内层：同菜品  searchType = 1
                  (2)外层： 桌号  searchType = 1
     3. 撤销只有内层车 searchType = 2
     * */
    //外层上菜接口
    if ([Serving integerValue] <= 0) {
        //如果serving等于0， 说明是划外层，调用uploadUrl
        if ([type integerValue] == 0) {
            //如果type等于0，外层，菜品查看
            NSString *ids = innerModel.ids;
            uploadUrl = [NSString stringWithFormat:@"%@%@?token=%@&storeId=%@&searchType=%@&ids=%@&productId=%@", kBaseURL, keyUrl, TOKEN, storeId, searchType,ids, productId];

        } else {
            //如果type等于1，外层，桌号查看
            uploadUrl = [NSString stringWithFormat:@"%@%@?token=%@&storeId=%@&searchType=%@&boardNum=%@", kBaseURL, keyUrl, TOKEN, storeId, searchType, boardNum];
        }
    } else {//内层上菜（1），撤销接口（2）
        if ([type integerValue] == 1) {
            //内层,不分查看方式
            uploadUrl = [NSString stringWithFormat:@"%@%@?token=%@&storeId=%@&searchType=%@&boardNum=%@&productId=%@&count=%@", kBaseURL, keyUrl, TOKEN, storeId, searchType, boardNum, productId, count];
        } else if ([type integerValue] == 2) {
            //type ＝ 2 撤销内层
            uploadUrl = [NSString stringWithFormat:@"%@%@?token=%@&storeId=%@&searchType=%@&boardNum=%@&productId=%@&backCount=%@", kBaseURL, keyUrl, TOKEN, storeId, searchType, boardNum, productId, count];
        }
    }
      
    [[QYXNetTool shareManager] postNetWithUrl:uploadUrl urlBody:nil bodyStyle:QYXBodyString header:nil response:QYXJSON success:^(id result) {
        if ([result[@"msgType"] integerValue] == 0) {
            if (self.lackFoodUploadCompleted) {
                _lackFoodUploadCompleted(_isDeskSearch);
            } else {
                _lackFoodUploadCompleted(NO);
            }
            if (NetRequireSuccess) {
                NetRequireSuccess(YES);
            }
        } else {
            if (NetRequireSuccess) {
                NetRequireSuccess(NO);
            }
        }
    } failure:^(NSError *error) {
        NetRequireError(error);
        
    }];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
    
    
}

@end
