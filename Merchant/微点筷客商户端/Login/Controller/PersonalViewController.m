//
//  PersonalViewController.m
//  微点筷客商户端
//
//  Created by 张森森 on 16/10/9.
//  Copyright © 2016年 张森森. All rights reserved.
//

#import "PersonalViewController.h"
#import "UIBarButtonItem+SSExtension.h"
#import "AddPersonalViewController.h"
#import "StuffAccountModel.h"
#import "StaffInfoCell.h"
@interface PersonalViewController ()<UITableViewDelegate, UITableViewDataSource>
{
    NSMutableArray *_staffDataArr;
}
@property (nonatomic,assign)NSInteger kainteger;
@property (nonatomic,strong)NSMutableArray * nameary;
@property (nonatomic,strong)NSArray * qxary;
//* 员工表  (NSString) *
@property (nonatomic, strong) UITableView *tableV;
@end

@implementation PersonalViewController
- (void)viewDidLoad {
    [super viewDidLoad];

//    [self createWholeView];
    [self createTableView];
    
    [self getData];

}
- (void)getData{
    NSString *keyUrl = @"api/merchant/storeStaffManage";
    NSString *operation = @"0"; // - 0:查询 1：添加 2：删除 3：修改
    NSString *loadUrl = [NSString stringWithFormat:@"%@%@?token=%@&storeId=%@&operation=%@", kBaseURL, keyUrl, TOKEN, tempStoreID, operation];
    [SVProgressHUD showWithStatus:@"加载中..."];
      
    [[QYXNetTool shareManager] postNetWithUrl:loadUrl urlBody:nil bodyStyle:QYXBodyString header:nil response:QYXJSON success:^(id result) {
        if ([result[@"msgType"] integerValue] == 0) {
            [SVProgressHUD showSuccessWithStatus:@"加载完毕"];
            ZTLog(@"%@", result);
            id obj = result[@"obj"];
            if (![obj isNull] && ![obj isKindOfClass:[NSString class]]) {
                _staffDataArr = [NSMutableArray array];
                [result[@"obj"] enumerateObjectsUsingBlock:^(NSDictionary *obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    StuffAccountModel *model = [StuffAccountModel mj_objectWithKeyValues:obj];
                    [_staffDataArr addObject:model];
                }];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [_tableV reloadData];
                });
            }
        } else {
            [SVProgressHUD showErrorWithStatus:@"加载失败"];
        }
    } failure:^(NSError *error) {

    }];
}

- (void)createTableView{
    //初始化导航栏
    self.titleView.text = @"员工账号";
    self.view.backgroundColor = UIColorFromRGB(0xffffff);

    //创建员工表

    _tableV = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    _tableV.backgroundColor = [UIColor whiteColor];
    _tableV.delegate = self;
    _tableV.dataSource = self;
    _tableV.bounces = NO;
    _tableV.separatorStyle = 0;

    [self.view addSubview:_tableV];
    _tableV.sd_layout.spaceToSuperView(UIEdgeInsetsMake(64, 0, 50, 0));

    ButtonStyle *addStaffBT = [ButtonStyle buttonWithType:UIButtonTypeCustom];
    [addStaffBT setBackgroundImage:[UIImage imageNamed:@"添加员工"] forState:UIControlStateNormal];
    [addStaffBT setBackgroundColor:[UIColor whiteColor]];
    [addStaffBT addTarget:self action:@selector(addStaffClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:addStaffBT];
    addStaffBT.sd_layout
    .centerXEqualToView(self.view)
    .bottomSpaceToView(self.view, 25)
    .widthIs(55)
    .heightIs(55);

}
-(void)leftBarButtonItemAction
{
    [self.navigationController  popViewControllerAnimated:YES];
}
#pragma makr -------  table delegate ---------
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1 + _staffDataArr.count;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 1) {
        return 30;
    } else
    return 15;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.001;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *headView = [[UIView alloc] init];
    headView.backgroundColor = [UIColor whiteColor];
    UILabel *titleLabel =[[UILabel alloc] init];
    if (section == 1) {
        titleLabel.text = @" 员工账号:";
        titleLabel.textColor = [UIColor lightGrayColor];
        titleLabel.font = [UIFont systemFontOfSize:14];
        titleLabel.textAlignment = NSTextAlignmentLeft;
    } else {
        titleLabel.backgroundColor = [UIColor whiteColor];
    }
    [headView addSubview:titleLabel];
    titleLabel.sd_layout
    .leftSpaceToView(headView, 10)
    .rightSpaceToView(headView, 10)
    .topEqualToView(headView)
    .bottomEqualToView(headView);
    return headView;

}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
       return [StaffInfoCell setIndexPath:indexPath withModel:nil];
    } else {
       return [StaffInfoCell setIndexPath:indexPath withModel:_staffDataArr[indexPath.section - 1]];
    }
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        [StaffInfoCell setIndexPath:indexPath withModel:nil];
    } else {
        [StaffInfoCell setIndexPath:indexPath withModel:_staffDataArr[indexPath.section - 1]];
    }
    NSString *str = [NSString stringWithFormat:@"staffCell%ld", (long)indexPath.section];
    StaffInfoCell *cell = [_tableV dequeueReusableCellWithIdentifier:str];
    cell = nil;
    if (cell == nil) {
        cell = [[StaffInfoCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:str];
    }
    cell.section = indexPath.section;
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    AddPersonalViewController * addpersonview = [[AddPersonalViewController alloc]init];
    addpersonview.boolinteger = 1;
    if (indexPath.section == 0) {
        StuffAccountModel *model = [[StuffAccountModel alloc] init];
        model.isBoss = YES;
        addpersonview.model = model;
    } else {
        addpersonview.model = _staffDataArr[indexPath.section - 1];
    }
    //修改成功返回回调
    addpersonview.changStaffInfoSccess = ^(BOOL success){
        [self getData];
    };
     [self.navigationController pushViewController:addpersonview animated:YES];

}
- (void)addStaffClick:(ButtonStyle *)sender{
    AddPersonalViewController *addpersonalview = [[AddPersonalViewController alloc]init];
    addpersonalview.boolinteger=0;
    addpersonalview.changStaffInfoSccess = ^(BOOL success){
        if (success) {
            [self getData];
        }
    };
    [self.navigationController pushViewController:addpersonalview animated:YES];
}
-(void)Change:(ButtonStyle *)btn
{
    if (btn.tag==500) {
        _qxary = @[@"1",@"1",@"1",@"1"];
        AddPersonalViewController * addpersonview = [[AddPersonalViewController alloc]init];
        addpersonview.boolinteger=1;
        addpersonview.quanxianary = [_qxary mutableCopy];
        addpersonview.xinxiary = _nameary[btn.tag-500];
        [self.navigationController pushViewController:addpersonview animated:YES];
    }
    if (btn.tag==501) {
        _qxary = @[@"0",@"1",@"1",@"1"];
        AddPersonalViewController * addpersonview = [[AddPersonalViewController alloc]init];
        addpersonview.boolinteger=1;
        addpersonview.quanxianary = [_qxary mutableCopy];
        addpersonview.xinxiary = _nameary[btn.tag-500];
        [self.navigationController pushViewController:addpersonview animated:YES];
        
    }
    
    
}

#pragma mark 添加店员
-(void)Addperson
{
    AddPersonalViewController *addpersonalview = [[AddPersonalViewController alloc]init];
    addpersonalview.boolinteger=0;
    [self.navigationController pushViewController:addpersonalview animated:YES];
    
    
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
