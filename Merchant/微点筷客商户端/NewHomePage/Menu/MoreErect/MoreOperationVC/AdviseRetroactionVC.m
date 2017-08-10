//
//  AdviseRetroactionVC.m
//  微点筷客商户端
//
//  Created by Skyer God on 17/1/13.
//  Copyright © 2017年 张森森. All rights reserved.
//

#import "AdviseRetroactionVC.h"

@interface AdviseRetroactionVC ()<UITextViewDelegate>

@end

@implementation AdviseRetroactionVC{
    UITextView *textView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = RGB(238, 238, 238);
    self.titleView.text = @"意见反馈";
    self.rightBarItem.hidden = YES;
    [self createWholeView];
}
-(void)leftBarButtonItemAction{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)createWholeView{

    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.text = @"   公开信";
    titleLabel.font = [UIFont systemFontOfSize:14];
    titleLabel.textColor = [UIColor lightGrayColor];
    [self.view addSubview:titleLabel];

    UILabel *separatorLine = [[UILabel alloc] init];
    separatorLine.backgroundColor = [[UIColor grayColor] colorWithAlphaComponent:0.6];
    [titleLabel addSubview:separatorLine];

    UILabel *detailLabel = [[UILabel alloc] init];
    detailLabel.text = @"在使用产品的过程中，产品中存在的一些问题是否影响了您的使用体验，殷切希望您可以告知。我们十分珍视您的宝贵建议，并会不断的优化产品，谢谢！";
//    detailLabel.backgroundColor = [UIColor whiteColor];
    detailLabel.textColor = [UIColor grayColor];
    detailLabel.font = [UIFont systemFontOfSize:15];
    detailLabel.numberOfLines = 0;
    [self.view addSubview:detailLabel];

    textView = [[UITextView alloc] init];
    textView.text = @"  请输入您的反馈意见";
    textView.clearsOnInsertion = YES;
    textView.textColor = [UIColor lightGrayColor];
    textView.delegate = self;
    textView.textAlignment = NSTextAlignmentJustified;
    [self.view addSubview:textView];

    ButtonStyle *submitBT = [ButtonStyle buttonWithType:UIButtonTypeCustom];
    [submitBT setTitle:@"提交" forState:UIControlStateNormal];
    [submitBT setBackgroundColor:UIColorFromRGB(0xfd7577)];
    [submitBT addTarget:self action:@selector(submitBTClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:submitBT];



    titleLabel.sd_layout
    .leftEqualToView(self.view)
    .topSpaceToView(self.view, 64 + 5)
    .rightEqualToView(self.view)
    .heightIs(25);

    separatorLine.sd_layout
    .leftSpaceToView(titleLabel, 4)
    .rightSpaceToView(titleLabel, 4)
    .bottomEqualToView(titleLabel)
    .heightIs(0.6);

    detailLabel.sd_layout
    .topSpaceToView(titleLabel, 0)
    .rightSpaceToView(self.view, 15)
    .leftSpaceToView(self.view, 15)
    .heightIs(autoScaleH(120));

    textView.sd_layout
    .leftEqualToView(detailLabel)
    .rightEqualToView(detailLabel)
    .topSpaceToView(detailLabel, 8)
    .heightIs(autoScaleH(50));

    submitBT.sd_layout
    .leftEqualToView(textView)
    .rightEqualToView(textView)
    .topSpaceToView(textView, 10)
    .heightIs(45);
    [submitBT setSd_cornerRadiusFromHeightRatio:@(0.1)];

}
- (void)submitBTClick:(ButtonStyle *)sender{

    NSString *keyUrl = @"api/merchant/feedback";
    if ([textView.text isNull]) {
        [textView becomeFirstResponder];
        return;
    }
    NSString *uploadUrl = [NSString stringWithFormat:@"%@%@?token=%@&storeId=%@&content=%@", kBaseURL, keyUrl, TOKEN, storeID, textView.text];
      
    [[QYXNetTool shareManager] postNetWithUrl:uploadUrl urlBody:nil bodyStyle:QYXBodyString header:nil response:QYXJSON success:^(id result) {

        if ([result[@"msgType"] integerValue] == 0) {
            [SVProgressHUD showSuccessWithStatus:@"提交成功"];
        }

    } failure:^(NSError *error) {

        
    }];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.navigationController popViewControllerAnimated:YES];
        [SVProgressHUD showSuccessWithStatus:@"反馈成功!"];
    });
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
