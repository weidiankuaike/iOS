//
//  ReportViewController.m
//  微点筷客商户端
//
//  Created by 张森森 on 16/10/19.
//  Copyright © 2016年 张森森. All rights reserved.
//

#import "ReportViewController.h"
#import "UIBarButtonItem+SSExtension.h"
#import "MBProgressHUD+SS.h"
#import "QYXNetTool.h"
#import "ReportSuccessVC.h"
@interface ReportViewController ()
{
    NSMutableArray *caseArr;
}
@property (nonatomic,strong)NSMutableArray * btnary;
@property (nonatomic,strong)NSMutableArray * labelary;
@property (nonatomic,strong)UILabel *lavel;
@property (nonatomic,strong)NSMutableArray * codenameary;
@property (nonatomic,strong)NSMutableArray * codevalueary;
@property (nonatomic,copy) NSString * iddstr;
@property (nonatomic,copy) NSString * judestr;
@property (nonatomic,copy) NSString * token;
@end

@implementation ReportViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    caseArr = [NSMutableArray array];
    self.titleView.text = @"举报";
    self.view.backgroundColor = RGB(242, 242, 242);

    _token = TOKEN;
    NSLog(@"%@",_judeidstr);

    _codenameary = [NSMutableArray array];
    _codevalueary = [NSMutableArray array];

    [MBProgressHUD showMessage:@"请稍等"];
    NSString *uploadUrl =[NSString stringWithFormat:@"%@api/merchant/searchComplainType?token=%@&codeSortValue=%@",kBaseURL,_token,@"SJTS0000"];

    [[QYXNetTool shareManager] postNetWithUrl:uploadUrl urlBody:nil bodyStyle:QYXBodyString header:nil response:QYXJSON success:^(id result) {
        [MBProgressHUD hideHUD];
        NSLog(@"%@",result);

        NSArray * codedict = [result objectForKey:@"obj"];
        for (int i =0; i<codedict.count; i++) {

            NSString * codename = codedict[i][@"codeName"];
            NSString * codecalue = codedict[i][@"codeValue"];
            [_codenameary addObject:codename];
            [_codevalueary addObject:codecalue];

        }

        [self CreatUI];


    } failure:^(NSError *error)
     {
         [MBProgressHUD hideHUD];


     }];


  


}
- (void)CreatUI
{
    CGFloat height = [[UIApplication sharedApplication] statusBarFrame].size.height + self.navigationController.navigationBar.frame.size.height;

    UILabel * flabel = [[UILabel alloc]init];
    flabel.text = [NSString stringWithFormat:@"是否举报%@的评论:",_namestring];
    flabel.font = [UIFont systemFontOfSize:autoScaleW(13)];
    flabel.textColor = [UIColor blackColor];
    [self.view addSubview:flabel];
    flabel.sd_layout.leftSpaceToView(self.view,autoScaleW(20)).topSpaceToView(self.view,autoScaleH(20)+height).widthIs(autoScaleW(180)).heightIs(autoScaleH(15));

    UILabel * xqlabel = [[UILabel alloc]init];
    xqlabel.text = _xqstring;
    xqlabel.font = [UIFont systemFontOfSize:autoScaleW(12)];
    xqlabel.textColor =RGB(70, 70, 70);
    xqlabel.numberOfLines= 0;
    [self.view addSubview:xqlabel];
    xqlabel.sd_layout.leftSpaceToView(self.view,autoScaleW(35)).topSpaceToView(flabel,autoScaleH(20)).widthIs(kScreenWidth-autoScaleW(70)).autoHeightRatio(0);

    UIView * backgroundview = [[UIView alloc]init];
    backgroundview.backgroundColor = RGB(238, 238, 238);
    [self.view addSubview:backgroundview];
    backgroundview.sd_layout.leftSpaceToView(self.view,autoScaleW(35)).topSpaceToView(xqlabel,autoScaleH(20)).widthIs(kScreenWidth - autoScaleW(70)).heightIs(autoScaleH(80));



    _btnary = [NSMutableArray array];
    _labelary = [NSMutableArray array];

    for (int i=0; i<_codenameary.count; i++) {

        UILabel * sslabel = [[UILabel alloc]init];
        sslabel.text = _codenameary[i];
        sslabel.font = [UIFont systemFontOfSize:autoScaleW(11)];
        sslabel.textColor = [UIColor blackColor];
        [backgroundview addSubview:sslabel];
        [_labelary addObject:sslabel];
        sslabel.sd_layout.leftSpaceToView(backgroundview,autoScaleW(60)+i%2*autoScaleW(135)).topSpaceToView(backgroundview,autoScaleH(17)+i/2*autoScaleH(37)).widthIs(autoScaleW(50)).heightIs(autoScaleH(15));

        ButtonStyle * buton = [ButtonStyle buttonWithType:UIButtonTypeCustom];
        [buton setImage:[UIImage imageNamed:@"555"] forState:UIControlStateNormal];
        [buton setImage:[UIImage imageNamed:@"777"] forState:UIControlStateSelected];
        [buton addTarget:self action:@selector(Choose:) forControlEvents:UIControlEventTouchUpInside];
        buton.tag= 200+i;

        [backgroundview addSubview:buton];
        [_btnary addObject:buton];
        buton.sd_layout.leftSpaceToView(backgroundview,autoScaleW(45)+i%2*(autoScaleW(135))).topSpaceToView(backgroundview,autoScaleH(18)+i/2*autoScaleH(37)).widthIs(autoScaleW(15)).heightIs(autoScaleH(15));


    }
    ButtonStyle * jbbtn = [[ButtonStyle alloc]init];
    [jbbtn setTitle:@"举报" forState:UIControlStateNormal];
    jbbtn.layer.masksToBounds = YES;
    jbbtn.layer.cornerRadius = autoScaleW(3);
    [jbbtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [jbbtn setBackgroundColor:UIColorFromRGB(0xfd7577)];
    jbbtn.titleLabel.font = [UIFont systemFontOfSize:autoScaleW(15)];
    [jbbtn addTarget:self action:@selector(Judge) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:jbbtn];
    jbbtn.sd_layout.centerXEqualToView(self.view).topSpaceToView(backgroundview,autoScaleH(40)).widthIs(kScreenWidth-autoScaleW(70)).heightIs(autoScaleH(30));


    NSArray * tisary = @[@"提交举报交由客服审核，",@"客服会尽快采取相应处理措施",];

    for (int i=0; i<2; i++) {

        UILabel * tishilabel = [[UILabel alloc]init];
        tishilabel.font = [UIFont systemFontOfSize:autoScaleW(13)];
        tishilabel.textAlignment = NSTextAlignmentCenter;
        tishilabel.textColor = RGB(189, 189, 189);
        tishilabel.text = tisary[i];
        [self.view addSubview:tishilabel];
        tishilabel.sd_layout.centerXEqualToView(self.view).topSpaceToView(jbbtn,autoScaleH(50)+i*autoScaleH(20)).widthIs(autoScaleW(200)).heightIs(autoScaleH(15));

    }


}
-(void)Choose:(ButtonStyle *)btn
{

    btn.selected = !btn.selected;

    NSString *btnName = _codenameary[btn.tag - 200];
    if ([caseArr containsObject:btnName]) {
        [caseArr removeObject:btnName];
    } else {
        [caseArr addObject:btnName];
    }

}
-(void)leftBarButtonItemAction {
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)Judge {
    if (caseArr.count == 0) {
        //没有选择举报原因
        [SVProgressHUD setMinimumDismissTimeInterval:1.0];
        [SVProgressHUD showErrorWithStatus:@"请选择原因"];
    } else {
        NSString *tempStr = [caseArr componentsJoinedByString:@","];
        _judestr = [tempStr stringByAppendingString:@","];
        NSString *loadUrl = [NSString stringWithFormat:@"%@api/merchant/addMerchantComplain?token=%@&storeId=%@&complainType=%@&evalId=%@",kBaseURL,_token,@"100002",_judestr,_judeidstr];
        [MBProgressHUD showMessage:@"请稍等"];

        [[QYXNetTool shareManager] postNetWithUrl:loadUrl urlBody:nil bodyStyle:QYXBodyString header:nil response:QYXJSON success:^(id result) {
            [MBProgressHUD hideHUD];
            NSString *codestr = [result objectForKey:@"msgType"];
            if ([codestr isEqualToString:@"0"]) {
                ReportSuccessVC *successVC = [[ReportSuccessVC alloc] init];
                [self.navigationController pushViewController:successVC animated:YES];
            }
        } failure:^(NSError *error) {
            [MBProgressHUD hideHUD];
        }];
    }

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
