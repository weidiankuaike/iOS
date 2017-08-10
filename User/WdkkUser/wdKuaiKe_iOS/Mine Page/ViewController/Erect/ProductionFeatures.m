//
//  ProductionFeatures.m
//  微点筷客商户端
//
//  Created by Skyer God on 17/3/10.
//  Copyright © 2017年 张森森. All rights reserved.
//

#import "ProductionFeatures.h"

@interface ProductionFeatures ()

@end

@implementation ProductionFeatures

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];


    UIImageView *imageV = [[UIImageView alloc] init];
    imageV.image = [UIImage imageNamed:@"图层1"];
    [self.view addSubview:imageV];

    UILabel *versionLabel = [[UILabel alloc] init];
    versionLabel.text = @"微点筷客V1.0.0";
    versionLabel.font = [UIFont systemFontOfSize:20 weight:10];
    [self.view addSubview:versionLabel];

    imageV.sd_layout
    .centerXEqualToView(self.view)
    .topSpaceToView(self.view, 64 + 40)
    .widthIs(imageV.image.size.width*2)
    .heightEqualToWidth(0);

    versionLabel.sd_layout
    .centerXEqualToView(self.view)
    .topSpaceToView(imageV, 5)
    .heightIs(40);
    [versionLabel setSingleLineAutoResizeWithMaxWidth:160];


    UILabel *contentLabel = [[UILabel alloc] init];
    contentLabel.numberOfLines = 0;
    contentLabel.font = [UIFont systemFontOfSize:16];
    contentLabel.textColor = [[UIColor blackColor] colorWithAlphaComponent:0.75];
    
    if (_isFeatures) {
        //产品亮点'
        self.titleView.text = @"产品亮点";
        contentLabel.text = @"\t（一）订单管理。用户可在此模块对待处理的订单、已预定的订单、进行中的订单和历史订单进行查看、打印、取消、确认到达等操作。\n\t（二）后厨管理。用户可以查看不同编号的餐桌的菜品，也可通过查看某种菜品具体分配在哪些餐桌上，便于后厨准备菜品。 \n\t（三）门店管理。店长可以在系统内为餐厅添加餐桌、编辑要在微点筷客用户端展示的菜品分类和图片、编辑餐厅公告、发送优惠卡券、添加服务类型。 \n\t（四）统计信息。店长可以查看收支记录、账户全额提现、查看不周时段的流量统计和菜品分析，以及对餐客的评价进行管理。 \n\t（五）子账号管理系统。店长添加员工后，普通员工可登录查看自己拥有的管理权限和更改子账号的登录密码。";
    } else {
        //产品介绍
        self.titleView.text = @"产品介绍";
        contentLabel.text = @"\t微点筷客商户端餐厅管理系统是一个主要接收线上订单，同时集协助餐厅进行订单管理、后厨管理、门店管理、订单数据的统计、营销推广、子账号管理等众多功能于一体的管理系统。该系统随着互联网的发展而越来越受线全国各大实体餐厅的喜爱，逐渐成为餐厅负责人管理餐厅不可或缺的助手。长期以来，餐厅客流的传统渠道都是线下，餐厅客满时秩序难以得到保障、客人来店或因客满要长时间等待才能有空桌就餐、餐厅难以预估要准备多少食材、客人添水加菜只能大声“吼”才能叫来服务员，等等，这些因素无形之中都影响着餐厅的品牌形象和销售业绩。微点筷客商户端餐厅管理系统作为一个成功的系统专为解决这些问题而生，将为您的餐厅铺就一条更好的生财之道。";
    }

    [self.view addSubview:contentLabel];

    contentLabel.sd_layout
    .leftSpaceToView(self.view, 13)
    .rightSpaceToView(self.view, 13)
    .topSpaceToView(versionLabel, 10)
    .bottomSpaceToView(self.view, 100);

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
    

}
-(void)leftBarButtonItemAction{
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
