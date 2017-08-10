//
//  ReportSuccessVC.m
//  微点筷客商户端
//
//  Created by Skyer God on 17/1/9.
//  Copyright © 2017年 张森森. All rights reserved.
//

#import "ReportSuccessVC.h"

@interface ReportSuccessVC ()
{
    UIImageView *imageV;
}
@end

@implementation ReportSuccessVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    self.rightBarItem.hidden = YES;

    imageV = [[UIImageView alloc] init];
    imageV.backgroundColor = [UIColor whiteColor];
    imageV.image = [UIImage imageNamed:@"画圈打勾"];
    [self.view addSubview:imageV];


    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.text = @"提交成功";
    titleLabel.textColor = [UIColor grayColor];
    titleLabel.font = [UIFont systemFontOfSize:23];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:titleLabel];

    UILabel *littleTitleLabel = [[UILabel alloc] init];
    littleTitleLabel.text = @"您的投诉我们已经收到，我们将尽快处理您的投诉!";
    littleTitleLabel.numberOfLines = 0;
    littleTitleLabel.textColor = [UIColor grayColor];
    littleTitleLabel.font = [UIFont systemFontOfSize:17];
    littleTitleLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:littleTitleLabel];

    imageV.sd_layout
    .centerXEqualToView(self.view)
    .centerYIs(self.view.center.y - 60)
    .widthIs(120)
    .heightEqualToWidth(0);

    titleLabel.sd_layout
    .centerXEqualToView(self.view)
    .topSpaceToView(imageV, 30)
    .widthIs(300)
    .heightIs(30);

    littleTitleLabel.frame = CGRectMake(50, self.view.center.y + 80, 300, 60);


}
-(void)leftBarButtonItemAction{
    [self.navigationController popViewControllerAnimated:YES];
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
