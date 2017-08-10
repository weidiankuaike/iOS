//
//  AboutUsVC.m
//  微点筷客商户端
//
//  Created by Skyer God on 17/1/13.
//  Copyright © 2017年 张森森. All rights reserved.
//

#import "AboutUsVC.h"
#import "AgreementVC.h"
#import "ProductionFeatures.h"
@interface AboutUsVC ()<UITableViewDelegate, UITableViewDataSource>

@end

@implementation AboutUsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = RGB(238, 238, 238);
    self.titleView.text = @"关于我们";
    self.rightBarItem.hidden = YES;

    [self setUp];
}
-(void)leftBarButtonItemAction{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)setUp{

    UIImageView *imageV = [[UIImageView alloc] init];
    imageV.image = [UIImage imageNamed:@"图层1"];
    [self.view addSubview:imageV];
    
    
    NSDictionary * infoDict = [[NSBundle mainBundle] infoDictionary];
    NSString * bundleVersion = infoDict[@"CFBundleVersion"];
    
    UILabel *versionLabel = [[UILabel alloc] init];
    versionLabel.text = [NSString stringWithFormat:@"微点筷客V%@",bundleVersion];
    [self.view addSubview:versionLabel];

    UITableView *tableV = [[UITableView alloc] init];
    tableV.backgroundColor = [UIColor whiteColor];
    tableV.delegate = self;
    tableV.dataSource = self;

    [tableV registerClass:[UITableViewCell class] forCellReuseIdentifier:@"about"];
    [self.view addSubview:tableV];
    tableV.bounces = NO;

    imageV.sd_layout
    .centerXEqualToView(self.view)
    .centerYIs(self.view.center.y / 2.3)
    .widthIs(imageV.image.size.width * 2)
    .heightEqualToWidth(0);

    versionLabel.sd_layout
    .centerXEqualToView(self.view)
    .topSpaceToView(imageV, 10)
    .heightIs(40);
    [versionLabel setSingleLineAutoResizeWithMaxWidth:160];


    tableV.sd_layout
    .leftEqualToView(self.view)
    .rightEqualToView(self.view)
    .topSpaceToView(versionLabel, 60)
    .heightIs (50 * 4);


//    UILabel *midLabel = [[UILabel alloc] init];
//    midLabel.text = @"|";
//    midLabel.textAlignment = NSTextAlignmentCenter;
//    midLabel.contentMode = UIControlContentHorizontalAlignmentCenter;
//    midLabel.textColor = [UIColor blackColor];
//    [self.view addSubview:midLabel];
//
//
//    UIButton *protocolBT = [UIButton buttonWithType:UIButtonTypeCustom];
//    [protocolBT setTitle:@"服务协议" forState:UIControlStateNormal];
//    [protocolBT setTitleColor:[[UIColor blackColor] colorWithAlphaComponent:0.8] forState:UIControlStateNormal];
//    [protocolBT addTarget:self action:@selector(protocolClick:) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:protocolBT];
//
//    UIButton *responsebilityBT = [UIButton buttonWithType:UIButtonTypeCustom];
//    [responsebilityBT setTitle:@"免责声明" forState:UIControlStateNormal];
//    [responsebilityBT setTitleColor:protocolBT.titleLabel.textColor forState:UIControlStateNormal];
//    [responsebilityBT addTarget:self action:@selector(responseClick:) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:responsebilityBT];

    UIButton *commpanyBT = [UIButton buttonWithType:UIButtonTypeCustom];
    [commpanyBT setTitle:@"厦门微点筷客信息技术有限公司" forState:UIControlStateNormal];
    [commpanyBT setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
//    [commpanyBT addTarget:self action:@selector(responseClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:commpanyBT];

    UIButton *powerBT = [UIButton buttonWithType:UIButtonTypeCustom];
    [powerBT setTitle:@"© 2016-2017 wdkk.mobi   版权所有." forState:UIControlStateNormal];
    [powerBT setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
//    [powerBT addTarget:self action:@selector(responseClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:powerBT];

    powerBT.sd_layout
    .leftSpaceToView(self.view, 8)
    .rightSpaceToView(self.view, 8)
    .bottomSpaceToView(self.view, 10)
    .heightIs(20);
    powerBT.titleLabel.adjustsFontSizeToFitWidth = YES;
    [powerBT.titleLabel setFont:[UIFont systemFontOfSize:14]];
    [commpanyBT.titleLabel setFont:powerBT.titleLabel.font];

    commpanyBT.sd_layout
    .centerXEqualToView(self.view)
    .bottomSpaceToView(powerBT, 0);
    [commpanyBT setupAutoSizeWithHorizontalPadding:5 buttonHeight:20];

//    midLabel.sd_layout
//    .bottomSpaceToView(commpanyBT, 0)
//    .centerXEqualToView(self.view)
//    .widthIs(3)
//    .heightIs(30);
//
//    protocolBT.sd_layout
//    .rightSpaceToView(midLabel, 3)
//    .centerYEqualToView(midLabel);
//    [protocolBT setupAutoSizeWithHorizontalPadding:3 buttonHeight:30];
//
//    responsebilityBT.sd_layout
//    .leftSpaceToView(midLabel, 3)
//    .centerYEqualToView(midLabel);
//    [responsebilityBT setupAutoSizeWithHorizontalPadding:3 buttonHeight:30];





}
//- (void)protocolClick:(UIButton *)sender{
//    AgreementVC *protocolVC = [[AgreementVC alloc] init];
//    protocolVC.tempTitle = @"服务协议";
//    protocolVC.tempURL = @"https://shop.wdkk.mobi/h5/agreement";
//    [self.navigationController pushViewController:protocolVC animated:YES];
//}
//- (void)responseClick:(UIButton *)sender{
//    AgreementVC *protocolVC = [[AgreementVC alloc] init];
//    protocolVC.tempTitle = @"免责声明";
//    protocolVC.tempURL = @"https://shop.wdkk.mobi/h5/exemption";
//    [self.navigationController pushViewController:protocolVC animated:YES];
//}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 4;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSArray *titleArr = @[@"平台介绍",@"功能亮点",@"服务协议",@"客服电话"];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"about" forIndexPath:indexPath];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"about"];
    }
    if (indexPath.row == 0) {
        UILabel *topLine = [[UILabel alloc] init];
        topLine.backgroundColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.5];
        [cell addSubview:topLine];
        topLine.sd_layout
        .centerXEqualToView(cell)
        .topEqualToView(cell)
        .widthRatioToView(cell, 1)
        .heightIs(0.6);
    }
    cell.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
    cell.selectionStyle = UITableViewCellSelectionStyleNone;

    cell.textLabel.text = titleArr[indexPath.row];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;

    [self setExtraCellLineHidden:tableView];
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0 || indexPath.row == 1) {
        ProductionFeatures *productionVC = [[ProductionFeatures alloc] init];
        productionVC.isFeatures = indexPath.row;
        [self.navigationController pushViewController:productionVC animated:YES];
    }

    if (indexPath.row == 2) {
        AgreementVC *protocolVC = [[AgreementVC alloc] init];
        protocolVC.tempTitle = @"服务协议";
        protocolVC.tempURL = @"https://www.wdkk.mobi/h5/agreement";
        [self.navigationController pushViewController:protocolVC animated:YES];
    }
    if (indexPath.row == 3) {
        NSString *message = NSLocalizedString(@"4000865552", nil);
        NSString *cancelButtonTitle = NSLocalizedString(@"取消", nil);
        NSString *otherButtonTitle = NSLocalizedString(@"拨打", nil);

        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:message preferredStyle:UIAlertControllerStyleAlert];

        // Create the actions.
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:cancelButtonTitle style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
            [alertController dismissViewControllerAnimated:YES completion:^{

            }];
        }];
        UIAlertAction *otherAction = [UIAlertAction actionWithTitle:otherButtonTitle style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            NSMutableString *str=[[NSMutableString alloc] initWithFormat:@"tel:%ld",4000865552];
            UIWebView *callWebview = [[UIWebView alloc] init];
            [callWebview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:str]]];
            [self.view addSubview:callWebview];
        }];

        // Add the actions.
        [alertController addAction:cancelAction];
        [alertController addAction:otherAction];
        [self presentViewController:alertController animated:YES completion:nil];
    }
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
