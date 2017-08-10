//
//  Withdraw cashViewController.m
//  微点筷客商户端
//
//  Created by 张森森 on 16/10/18.
//  Copyright © 2016年 张森森. All rights reserved.
//

#import "Withdraw cashViewController.h"
#import "UIBarButtonItem+SSExtension.h"
@interface Withdraw_cashViewController ()

@end

@implementation Withdraw_cashViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.titleView.text = @"账单详情";
    self.view.backgroundColor = RGB(242, 242, 242);

    CGFloat height = [[UIApplication sharedApplication] statusBarFrame].size.height + self.navigationController.navigationBar.frame.size.height;
    UILabel * tedaylabel = [[UILabel alloc]init];
    tedaylabel.text = @"手动提现";
    tedaylabel.textColor = [UIColor blackColor];
    tedaylabel.textAlignment = NSTextAlignmentCenter;
    tedaylabel.font = [UIFont systemFontOfSize:autoScaleW(13)];
    [self.view addSubview:tedaylabel];
    tedaylabel.sd_layout.centerXEqualToView(self.view).topSpaceToView(self.view,height+autoScaleH(30)).widthIs(autoScaleW(80)).heightIs(autoScaleH(15));
    
    UILabel * moneylabel = [[UILabel alloc]init];
    moneylabel.text = [NSString stringWithFormat:@"-%@",_firstmoney];
    moneylabel.textAlignment = NSTextAlignmentCenter;
    moneylabel.textColor = RGB(9, 9, 9);
    moneylabel.font = [UIFont systemFontOfSize:autoScaleW(20)];
    CGSize size = [moneylabel.text sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:moneylabel.font,NSFontAttributeName, nil]];
    CGFloat wind = size.width;
    [self.view addSubview:moneylabel];
    moneylabel.sd_layout.leftEqualToView(tedaylabel).topSpaceToView(tedaylabel,autoScaleH(30)).widthIs(wind).heightIs(autoScaleH(22));
    
    UILabel * yingblabel =[[UILabel alloc]init];
    yingblabel.text = _ztstr;
    yingblabel.textColor = [UIColor lightGrayColor];
    yingblabel.textAlignment = NSTextAlignmentCenter;
    yingblabel.font = [UIFont systemFontOfSize:autoScaleW(13)];
    [self.view addSubview:yingblabel];
    
    yingblabel.sd_layout.centerXEqualToView(self.view).topSpaceToView(moneylabel,autoScaleH(13)).widthIs(autoScaleW(80)).heightIs(autoScaleH(15));
    
    
    UILabel * firstlabel = [[UILabel alloc]init];
    firstlabel.backgroundColor = UIColorFromRGB(0xeeeeee);
    [self.view addSubview:firstlabel];
    firstlabel.sd_layout.leftEqualToView(self.view).rightEqualToView(self.view).topSpaceToView(yingblabel,autoScaleH(50)).heightIs(0.5);
    
    NSArray  * zzary = @[@"款项去向",@"发起时间",@"操作后账户余额",];
    
    for (int i=0; i<3; i++)
    {
        UILabel * xinxilabel = [[UILabel alloc]init];
        xinxilabel.text = zzary[i];
        xinxilabel.font = [UIFont systemFontOfSize:autoScaleW(13)];
        [self.view addSubview:xinxilabel];
        xinxilabel.sd_layout.leftSpaceToView(self.view,autoScaleW(15)).topSpaceToView(yingblabel,autoScaleH(60)+i*(autoScaleH(25))).widthIs(autoScaleW(120)).heightIs(autoScaleH(15));
    }
    NSString * card = [_cardstr substringWithRange:NSMakeRange(_cardstr.length-4, 4)];
    NSString * number = nil;
    if ([_typestr isEqualToString:@"支付宝"]) {
        number = [NSString stringWithFormat:@"%@(%@)",_typestr,_cardstr];
        
    }else if ([_typestr isEqualToString:@"余额"])
    {
        number = [NSString stringWithFormat:@"%@",_typestr];
    }
    else
    {
       number = [NSString stringWithFormat:@"%@(%@)",_typestr,card];
    }
    NSString * secondmoneystr = [NSString stringWithFormat:@"￥%@",_secondmoney];
    NSArray * fuary = @[number,_timestr,secondmoneystr];
    
    for (int i=0; i<3; i++)
    {
        UILabel * xinxilabel = [[UILabel alloc]init];
        xinxilabel.text = fuary[i];
        xinxilabel.font = [UIFont systemFontOfSize:autoScaleW(13)];
        xinxilabel.textAlignment = NSTextAlignmentLeft;
        [self.view addSubview:xinxilabel];
        xinxilabel.sd_layout.rightSpaceToView(self.view,autoScaleW(15)).topSpaceToView(yingblabel,autoScaleH(60)+i*(autoScaleH(25))).heightIs(autoScaleH(15));
        [xinxilabel setSingleLineAutoResizeWithMaxWidth:200];
    }
    
    UILabel * linelabel = [[UILabel alloc]init];
    linelabel.backgroundColor = UIColorFromRGB(0xeeeeee);
    [self.view addSubview:linelabel];
    linelabel.sd_layout.leftEqualToView(self.view).rightEqualToView(self.view).topSpaceToView(yingblabel,autoScaleH(140)).heightIs(0.5);
    
    ButtonStyle * wyingyebtn = [ButtonStyle buttonWithType:UIButtonTypeCustom];
    [wyingyebtn setTitle:@"对此账单有疑问？" forState:UIControlStateNormal];
    [wyingyebtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    wyingyebtn.titleLabel.font = [UIFont systemFontOfSize:autoScaleW(15)];
    [self.view addSubview:wyingyebtn];
    
    wyingyebtn.sd_layout.leftSpaceToView(self.view,autoScaleW(108)).topSpaceToView(linelabel,autoScaleH(35)).widthIs(autoScaleW(150)).heightIs(autoScaleH(20));
    
    
}
-(void)leftBarButtonItemAction
{
    
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
