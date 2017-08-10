//
//  KitchenVC.m
//  微点筷客商户端
//
//  Created by Skyer God on 16/11/9.
//  Copyright © 2016年 张森森. All rights reserved.
//

#import "KitchenVC.h"
#import "TableViewCell.h"
#import "OutKitchenModel.h"
#import "InnerKitchenModel.h"
//#import "RightKitchenView.h"
#import <MJExtension/MJExtension.h>
#import "InnerKitchenCell.h"
#import <UserNotifications/UserNotifications.h>
#import <UserNotificationsUI/UserNotificationsUI.h>
#import "MJChiBaoziHeader.h"
#define ZTMainScreen  [UIScreen mainScreen].bounds

@interface KitchenVC ()<UITableViewDelegate, UITableViewDataSource, UNUserNotificationCenterDelegate, UIApplicationDelegate>
{
    BOOL isDeskSearch;
    BOOL oldStatus;
}
/** 后厨列表   (strong) **/
@property (nonatomic, strong) UITableView *tableV;
/** <#行注释#>   (strong) **/
@property (nonatomic, strong) NSMutableArray *dataArr;
/** 侧边视图   (strong) **/
//@property (nonatomic, strong) RightKitchenView *rightView;
/** 暂无订单，或者未开启后厨功能   (strong) **/
@property (nonatomic, strong) UIView *placeHolderView;
@end

@implementation KitchenVC
{
    ButtonStyle *rightButton;
    //    void (^NetRequireSuccess)(BOOL success);
    //    void (^NetRequireError)(NSError *error);
}

-(UITableView *)tableV{
    if (!_tableV) {
        self.automaticallyAdjustsScrollViewInsets = NO;
        _tableV = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableV.backgroundColor= RGB(238, 238, 238);
        _tableV.delegate = self;
        _tableV.dataSource = self;
        [self.view addSubview:_tableV];

        if (_placeHolderView) {
            [_placeHolderView removeFromSuperview];
            _placeHolderView = nil;
        }
//        MJChiBaoziHeader *header = [MJChiBaoziHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
//        _tableV.mj_header = header;
//        [_tableV.mj_header beginRefreshing];

    }
    _tableV.sd_layout.spaceToSuperView(UIEdgeInsetsMake(64, 0, 49, 0));
    [_tableV updateLayout];
    return _tableV;
}

//-(void)viewWillAppear:(BOOL)animated{
//    [super viewWillAppear:animated];
//
////    self.placeHolderView.hidden = NO;
//#pragma mark --- 暂时关闭后厨功能， 先不掉用下面方法，老板需求大于天－－－－
////    [self searchOrderOpenStatus];
//}
-(void)judgeBaseViewControllerStatus:(BOOL)isOut{
    [super judgeBaseViewControllerStatus:isOut];
    if (!isOut) {
        //        [self searchOrderOpenStatus];
    }
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //    __weak typeof(self) weakSelf = self;
    //    NetRequireSuccess = ^(BOOL success){
    //        __strong  typeof(weakSelf) strongSelf = weakSelf;
    //        if (success) {
    //            //后厨开启
    //            [strongSelf initNavigationBarItem];
    //            [strongSelf.tableV registerClass:[TableViewCell class] forCellReuseIdentifier:@"outCell"];
    //            strongSelf.rightView.backgroundColor = [UIColor whiteColor];
    //        } else {
    //            //后厨未开启
    //            strongSelf.placeHolderView.backgroundColor = [UIColor whiteColor];
    //        }
    //    };
    self.titleView.text = @"后厨管理";

    self.placeHolderView.hidden = NO;
}

//- (void)loadNewData{
//    NSString *type = isDeskSearch ? @"1" : @"0";
//    [self getAllDataWithType:type];
//}
#pragma mark --- 查询功能是否开启 －－－
- (void)searchOrderOpenStatus{

    LoginInfoModel *_model = _BaseModel;
    NSString *isBoss = _model.isBoss;
    NSString *userId = _model.id;
    NSString *keyUrl = @"api/merchant/searchFeatures";
    NSString *flag = @"is_kitchen";
    NSString *loadUrl = [NSString stringWithFormat:@"%@%@?token=%@&storeId=%@&flag=%@&isBoss=%@&userId=%@", kBaseURL, keyUrl, TOKEN, storeID, flag, isBoss, userId];

      
    [[QYXNetTool shareManager] postNetWithUrl:loadUrl urlBody:nil bodyStyle:QYXBodyString header:nil response:QYXJSON success:^(id result) {
        if ([result[@"msgType"] integerValue] == 0) {
            //权限/功能 判断 0 没有 1有
            BOOL newStatus = [result[@"obj"][@"is_kitchen"] integerValue] == 0 ? NO : YES;
            BOOL newLimitStatus = [result[@"obj"][@"isKitchenManage"] integerValue] == 0 ? NO : YES;
            //            if ([_model.isBoss integerValue] == 1) {
            //                newStatus = YES;
            //            }
            if (newStatus && newLimitStatus) {
                if (oldStatus == newStatus) {
                    //不创建视图
                } else {
                    //后厨开启
                    //删除旧视图，创建新视图
                    [self.view.subviews  enumerateObjectsUsingBlock:^(id _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                        [obj removeFromSuperview];
                        obj = nil;
                    }];
                    _placeHolderView = nil;
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self initNavigationBarItem];
                        self.tableV.sd_layout.spaceToSuperView(UIEdgeInsetsMake(64, 0, 0, 0));
                        [self.tableV registerClass:[TableViewCell class] forCellReuseIdentifier:@"outCell"];
                        //                        self.rightView.backgroundColor = [UIColor whiteColor];
                    });
                }
            } else {
                //删除旧视图，创建新视图
                [self.view.subviews  enumerateObjectsUsingBlock:^(id _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    [obj removeFromSuperview];
                    obj = nil;
                }];
                _tableV = nil;
                //后厨未开启
                self.placeHolderView.backgroundColor = [UIColor whiteColor];
            }
            oldStatus = newStatus;
        }
    } failure:^(NSError *error) {

    }];
}
#pragma mark ------- 获取数据源 -------- 默认查看方式为菜品查看----
- (void)getAllDataWithType:(NSString *)type{
    NSString *keyUrl = @"api/merchant/searchKitchenUnServed";
    NSString *searchType = type;
    isDeskSearch = [type integerValue];
    NSString *loadUrl = [NSString stringWithFormat:@"%@%@?token=%@&storeId=%@&searchType=%@&userId=%@", kBaseURL, keyUrl, TOKEN, storeID, searchType, UserId];
    [SVProgressHUD showWithStatus:@"加载中..."];
      
    [[QYXNetTool shareManager] postNetWithUrl:loadUrl urlBody:nil bodyStyle:QYXBodyString header:nil response:QYXJSON success:^(id result) {
        if ([result[@"msgType"] integerValue] == 0) {
            id obj = result[@"obj"];
            if (![obj isNull] && ![obj isKindOfClass:[NSString class]]) {
                _dataArr = [NSMutableArray array];
                [result[@"obj"] enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    OutKitchenModel *outModel = [OutKitchenModel mj_objectWithKeyValues:obj];
                    NSArray *array =  [InnerKitchenModel mj_objectArrayWithKeyValuesArray:obj[@"voList"]];
                    outModel.voList = [NSMutableArray arrayWithArray:array];
                    outModel.isShow = NO;
                    [_dataArr addObject:outModel];
                }];
                [SVProgressHUD showSuccessWithStatus:@"加载完毕."];
                if (_placeHolderView) {
                    [_placeHolderView removeFromSuperview];
                    _placeHolderView = nil;
                }
                [self.tableV reloadData];

            } else {
                //暂无数据
                [SVProgressHUD showInfoWithStatus:@"暂无数据"];
                self.placeHolderView.hidden = NO;

            }

        } else {
            [SVProgressHUD showErrorWithStatus:@"网络异常"];
        }
        [_tableV reloadData];
        [_tableV.mj_header endRefreshing];

    } failure:^(NSError *error) {

    }];
}

- (void)getData{
    //    NSArray *nameA = @[@"1",@"2",@"3",@"4",@"5",@"6"];
    //    NSString *string = @"今天天气真特么好，";
    //    NSString *subString= @"333";
    //    //模拟数据
    //    for (int i = 0; i< nameA.count; i++) {
    //        OutKitchenModel *outModel =[[OutKitchenModel alloc]init];
    //        outModel.name = nameA[i];
    //        outModel.name = [nameA[i] stringByAppendingString:string];
    //        outModel.array =[NSMutableArray array];
    //        for (int j = 0; j<i+1; j++) {
    //            InnerKitchenModel *innerModel =[[InnerKitchenModel alloc]init];
    //            innerModel.name = [NSString stringWithFormat:@"%d个说%@",j,subString];
    //
    //            for (int k = 0; k< j; k++) {
    //                innerModel.name =[innerModel.name stringByAppendingString:subString];
    //            }
    //            [outModel.array addObject:innerModel];
    //        }
    //        outModel.isShow = NO;
    //        [_dataArr  addObject:outModel];
    //    }
}
#pragma mark --- talbe Delegate ---
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataArr.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    OutKitchenModel *model = _dataArr[indexPath.row];
    if (model.height == 0) {
        return [TableViewCell cellHeight];
    }else{
        return model.height;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    NSString *str = @"outCell";
    TableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:str];

    cell.isDeskSearch = isDeskSearch;
    OutKitchenModel *outModel = _dataArr[indexPath.row];
    //此方法用做刷新整个数据源时，展开上次打开的状态
    NSInteger oldRow = [[[NSUserDefaults standardUserDefaults] objectForKey:@"oldIndexPath"] integerValue];
    NSIndexPath *oldIndexPath = [NSIndexPath indexPathForRow:oldRow inSection:indexPath.section];
    NSIndexPath *nowIndexPath = indexPath;
    if ([nowIndexPath isEqual:oldIndexPath]) {
        outModel.isShow = YES;
    }
    cell.model = _dataArr[indexPath.row];
    cell.index = indexPath.row;

    cell.longGR = ^(UILongPressGestureRecognizer *longGR){

        [UIView animateWithDuration:.35 animations:^{
            //            self.rightView.frame = CGRectMake(kScreenWidth - 50, 0, kScreenWidth, kScreenHeight);
        }];
    };
    cell.lackFoodUploadCompleted = ^(BOOL completed){
        if (!completed) {
            [self getAllDataWithType:@"0"];
        } else {
            [self getAllDataWithType:@"1"];
        }
    };
    if (indexPath.row == _dataArr.count - 1) {
        [self setExtraCellLineHidden:_tableV];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    //选择展开有且仅有一个列表，并保存展开列表的行，以便数据刷新后继续打开
    TableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    for (OutKitchenModel *outModel in _dataArr) {
        outModel.isShow = NO;
    }
    NSIndexPath *tempIndexPath = indexPath;
    NSInteger oldRow = [[[NSUserDefaults standardUserDefaults] objectForKey:@"oldIndexPath"] integerValue];
    NSIndexPath *oldIndexPath = [NSIndexPath indexPathForRow:oldRow inSection:indexPath.section] ;
    if ([oldIndexPath isEqual:tempIndexPath]) {
        cell.model.isShow = !cell.selected;
        [[NSUserDefaults standardUserDefaults] setObject:@"-1" forKey:@"oldIndexPath"];
    } else{
        cell.model.isShow = cell.selected;
        [[NSUserDefaults standardUserDefaults] setObject:@(tempIndexPath.row) forKey:@"oldIndexPath"];
    }
    [tableView reloadDataWithExistedHeightCache];


    //    [self registerUNAuthorNotifacation];
}
/** 隐藏多余的分割线 **/
-(void)setExtraCellLineHidden: (UITableView *)tableView
{
    UIView *view = [UIView new];

    view.backgroundColor = [UIColor clearColor];

    [tableView setTableFooterView:view];
}

/** 初始化导航栏 **/
- (void)initNavigationBarItem{
    self.navigationController.navigationBar.hidden = NO;
    rightButton = [ButtonStyle buttonWithType:UIButtonTypeCustom];
    [rightButton setImage:[UIImage imageNamed:@"白色搜索"] forState:UIControlStateNormal];
    [rightButton setTitle:@" 按桌号查看" forState:UIControlStateNormal];
    [rightButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [rightButton addTarget:self action:@selector(clickSelectBT:) forControlEvents:UIControlEventTouchUpInside];
    rightButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [rightButton.titleLabel setFont:[UIFont systemFontOfSize:15]];
    rightButton.frame = CGRectMake(0, 7, 110, 30);
    UIBarButtonItem *rightBarItem = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
    self.navigationItem.rightBarButtonItem = rightBarItem;
}
- (void)clickSelectBT:(ButtonStyle *)sender{

    sender.selected = !sender.selected;
    if (isDeskSearch) {
        [sender setTitle:@" 按桌号查看" forState:UIControlStateNormal];
        [self getAllDataWithType:@"0"];
    } else {
        [sender setTitle:@" 按菜品查看" forState:UIControlStateNormal];
        [self getAllDataWithType:@"1"];
    }
}
#pragma  mark ------------------ 后厨功能未开启，或者 暂无订单---------------- lazy load -----------------
/** 如果后厨没有任务或者没有开启后厨管理 **/
-(UIView *)placeHolderView{
    if (!_placeHolderView) {
        _placeHolderView = [[UIView alloc] initWithFrame:CGRectZero];
        _placeHolderView.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:_placeHolderView];

        UIImageView *imageView = [[UIImageView alloc] init];
        imageView.image = [UIImage imageNamed:@"后厨未开启"];

        [_placeHolderView addSubview:imageView];

        imageView.sd_layout
        .centerXEqualToView(self.view)
        .centerYIs(self.view.center.y - 50)
        .widthIs(imageView.image.size.width * 2)
        .heightIs(imageView.image.size.height * 2);



        UILabel *titleLabel = [[UILabel alloc] init];
        //        titleLabel.text = @"请到系统设置(菜单－更多设置－系统设置)开启！";
        titleLabel.text = @"暂未开放，敬请期待";
        titleLabel.numberOfLines = 0;
        titleLabel.textColor = [UIColor lightGrayColor];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.font = [UIFont systemFontOfSize:autoScaleW(16)];
        [_placeHolderView addSubview:titleLabel];

        //        if (_dataArr.count == 0) {
        //            imageView.image = [UIImage imageNamed:@"暂无数据"];
        //            titleLabel.hidden = YES;
        //            [_tableV removeFromSuperview];
        //            _tableV = nil;
        //        } else {
        //            titleLabel.hidden = NO;
        //        }
        titleLabel.sd_layout
        .topSpaceToView(imageView, 7)
        .centerXEqualToView(imageView)
        .centerYEqualToView(imageView)
        .heightIs(40);
        [titleLabel setSingleLineAutoResizeWithMaxWidth:300];

    }
    return _placeHolderView;
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
