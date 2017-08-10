//
//  QueueCurrentOrHistoryVC.m
//  微点筷客商户端
//
//  Created by Skyer God on 2017/7/5.
//  Copyright © 2017年 张甜. All rights reserved.
//

#import "QueueCurrentOrHistoryVC.h"
#import "QueueNumberCell.h"
#import "MJChiBaoziHeader.h"
@interface QueueCurrentOrHistoryVC ()<UITableViewDelegate, UITableViewDataSource>
/** <#行注释#>   (strong) **/
@property (nonatomic, strong) UITableView *tableV;
@end

@implementation QueueCurrentOrHistoryVC
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
   }
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    if (_tableV) {
        MJChiBaoziHeader *header = [MJChiBaoziHeader headerWithRefreshingTarget:self refreshingAction:@selector(getData)];
        _tableV.mj_header = header;
//        [_tableV.mj_header beginRefreshing];
    }
    ZTLog(@"___+_+_+___+_+_+_+_+_+  %ld", _selectIndex);

}
- (void)getData{
//    _tableV.backgroundColor = RGB(getRandomNum(), getRandomNum(), getRandomNum());
    [_tableV.mj_header endRefreshing];
}
int getRandomNum(){
    return arc4random() % 256;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    self.tableV = [[UITableView alloc] initWithFrame:CGRectZero];
    self.tableV.backgroundColor = [UIColor whiteColor];
    _tableV.separatorStyle = 0;
    _tableV.showsVerticalScrollIndicator = NO;
    _tableV.delegate = self;
    _tableV.dataSource = self;
    [self.view addSubview:_tableV];

    _tableV.sd_layout
    .spaceToSuperView(UIEdgeInsetsMake(0, 0, 0, 0));

    [_tableV registerNib:[UINib nibWithNibName:NSStringFromClass([QueueNumberCell class]) bundle:Nil] forCellReuseIdentifier:@"queueCell"];
    
}
#pragma mark -- tableView delegate --
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return pxSizeH(22);
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
     UIView *backView = [UIView new];
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.colors = @[(__bridge id)RGB(225, 225, 225).CGColor, (__bridge id)UIColorFromRGB(0xf6f6f6).CGColor, (__bridge id)[UIColor whiteColor].CGColor];
    gradientLayer.locations = @[@0, @0.4, @1.0];
    gradientLayer.startPoint = CGPointMake(0, 0);
    gradientLayer.endPoint = CGPointMake(0, 1.0);
    gradientLayer.frame = CGRectMake(0, 0, kScreenWidth, pxSizeH(22));
    [backView.layer insertSublayer:gradientLayer atIndex:0];

    return backView;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 5;//暂时固定显示三个
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 1 || indexPath.row == 3) {
        return pxSizeH(22);
    }
    return pxSizeH(216);
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    if (indexPath.row == 1 || indexPath.row == 3) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell"];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [UIColor whiteColor];
        return cell;
    }

    static  NSString *identify = @"queueCell";
    [QueueNumberCell cellStatus:1];
    QueueNumberCell *cell = [tableView dequeueReusableCellWithIdentifier:identify];
    if (!cell) {
        cell = [[QueueNumberCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identify];
    }
    [cell.phoneLabel addTarget:self action:@selector(callPhone:) forControlEvents:UIControlEventTouchUpInside];
    cell.userInteractionEnabled = YES;
    return cell;
}

//拨打电话
- (void)callPhone:(ButtonStyle *)sender {
    NSString *phoneNumber = sender.titleLabel.text;
    NSString *message = NSLocalizedString(phoneNumber, nil);
    NSString *cancelButtonTitle = NSLocalizedString(@"取消", nil);
    NSString *otherButtonTitle = NSLocalizedString(@"拨打", nil);

    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:message preferredStyle:UIAlertControllerStyleAlert];

    // Create the actions.
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:cancelButtonTitle style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        [alertController dismissViewControllerAnimated:YES completion:^{


        }];
    }];

    UIAlertAction *otherAction = [UIAlertAction actionWithTitle:otherButtonTitle style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        NSMutableString *str=[[NSMutableString alloc] initWithFormat:@"tel:%@",phoneNumber];
        UIWebView *callWebview = [[UIWebView alloc] init];
        [callWebview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:str]]];


    }];

    // Add the actions.
    [alertController addAction:cancelAction];
    [alertController addAction:otherAction];
    
    [self presentViewController:alertController animated:YES completion:nil];
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
