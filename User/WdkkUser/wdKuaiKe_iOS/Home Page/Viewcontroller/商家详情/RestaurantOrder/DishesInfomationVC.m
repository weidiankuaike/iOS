//
//  DishesInfomationVC.m
//  wdKuaiKe_iOS
//
//  Created by Skyer God on 16/9/19.
//  Copyright © 2016年 weiDianKuaiKe. All rights reserved.
//

#import "DishesInfomationVC.h"

#import "DishesInfoCell.h"

#import "DishesInfoModel.h"

#import "MJRefresh.h"

#import "DishesIntroductionInfoCell.h"

#import "EvaluateDetailListCell.h"

#import "DishesEvaluateTitileCell.h"

#import "ShoppingCartSingletonView.h"

@interface DishesInfomationVC ()<UITableViewDelegate, UITableViewDataSource>
{
    NSArray *_dataArr;

}
@property (nonatomic, strong) NSMutableArray *modelsArray;
@end

@implementation DishesInfomationVC
{
    UITableView *_tableV;
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];

    self.tabBarController.tabBar.hidden = YES;
    [self.view addSubview:[ShoppingCartSingletonView shareManagerWithParentView:self.view]];
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:self.view];
    [[NSUserDefaults standardUserDefaults] setObject:data forKey:@"currentParentView"];
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"Dishes Infomation";


            /** 假数据 **/
    [self createMOdelWithCount:10];

            /** 先以整体为单位铺建 tableView **/
    [self setupDishesInfoView];




}

- (void)createMOdelWithCount:(NSInteger)count{
    if (!_modelsArray) {
        _modelsArray = [NSMutableArray array];
    }

}
- (void)setupDishesInfoView{

    _tableV = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    _tableV.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_tableV];

    _tableV.sd_layout.leftEqualToView(self.view).topSpaceToView(self.view, 0).rightEqualToView(self.view).bottomSpaceToView(self.view, 0);
    _tableV.delegate = self;
    _tableV.dataSource = self;
    _tableV.separatorStyle = 0;

    [_tableV registerClass:[DishesInfoCell class] forCellReuseIdentifier:NSStringFromClass([DishesInfoCell class])];
    [_tableV registerClass:[DishesIntroductionInfoCell class] forCellReuseIdentifier:NSStringFromClass([DishesIntroductionInfoCell class])];
    [_tableV registerClass:[EvaluateDetailListCell class] forCellReuseIdentifier:NSStringFromClass([EvaluateDetailListCell class])];
    [_tableV registerClass:[DishesEvaluateTitileCell class] forCellReuseIdentifier:NSStringFromClass([DishesEvaluateTitileCell class])];


}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _modelsArray.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    Class currentClass = [DishesInfoCell class];

    if (indexPath.row == 1) {
        currentClass = [DishesIntroductionInfoCell class];
    }
    if (indexPath.row == 2) {
        currentClass = [DishesEvaluateTitileCell class];
    }

    if (indexPath.row > 2) {
        currentClass = [EvaluateDetailListCell class];
    }

    DishesInfoModel *model = self.modelsArray[indexPath.row];

 
    return [_tableV cellHeightForIndexPath:indexPath model:model keyPath:@"model" cellClass:currentClass contentViewWidth:[self cellContentViewWith]];
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
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    Class  currentClassCell = [DishesInfoCell class];
    if (indexPath.row == 1) {
        currentClassCell = [DishesIntroductionInfoCell class];
    }
    if (indexPath.row == 2) {
        currentClassCell = [DishesEvaluateTitileCell class];
    }
    if (indexPath.row > 2) {
        currentClassCell = [EvaluateDetailListCell class];
    }
    DishesInfoCell *cell = nil;

    DishesInfoModel *model = self.modelsArray[indexPath.row];

    cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([currentClassCell class])];
    cell.model = model;

    return cell;

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
