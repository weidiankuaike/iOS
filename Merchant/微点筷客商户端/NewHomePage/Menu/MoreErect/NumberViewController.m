//
//  NumberViewController.m
//  微点筷客商户端
//
//  Created by 张森森 on 16/10/28.
//  Copyright © 2016年 张森森. All rights reserved.
//

#import "NumberViewController.h"
#import "UIBarButtonItem+SSExtension.h"
#import "LoginTableViewCell.h"
#import "PersonalViewController.h"
#import "PhoneyzViewController.h"
#import "ZTAddOrSubAlertView.h"
#import "ChangetixianViewController.h"
#import "ChangelogincodeViewController.h"
#import "MBProgressHUD+SS.h"
#import "QYXNetTool.h"
#import "NSObject+JudgeNull.h"
#import "ViewController.h"
#import "DeviceSet.h"
#import "XGPush.h"
@interface NumberViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong)UITableView * tableView;
@property (nonatomic,strong)NSArray  * firAry;
@property (nonatomic,strong)NSArray  * secary;
@property (nonatomic,strong)NSArray  * thrary;
@end

@implementation NumberViewController{
    NSString *_editStatus;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self GetsonethingWithaf];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.titleView.text = @"账号管理";
    self.view.backgroundColor = RGB(242, 242, 242);
    self.automaticallyAdjustsScrollViewInsets = NO;




    _secary = @[@"管理员手机号",@"提现银行卡",@"提现支付宝",];
    _thrary = @[@"登录密码",@"提现密码",];


    ButtonStyle *registerBT = [ButtonStyle buttonWithType:UIButtonTypeCustom];
    [registerBT setTitle:@"注销登录" forState:UIControlStateNormal];
    [registerBT setBackgroundColor:UIColorFromRGB(0xfd7577)];
    [self.view addSubview:registerBT];
    [registerBT addTarget:self action:@selector(registerBTClick:) forControlEvents:UIControlEventTouchUpInside];

    registerBT.sd_layout
    .leftSpaceToView(self.view, 20)
    .rightSpaceToView(self.view, 20)
    .bottomSpaceToView(self.view, 80)
    .heightIs(45);
    [registerBT setSd_cornerRadiusFromHeightRatio:@(0.12)];
}
-(void)leftBarButtonItemAction{
    [self Back];
}
- (void)registerBTClick:(ButtonStyle *)sender{
    //清空登录数据
//    NSString *tempLoginName = LoginName;
    NSUserDefaults *userDefaut = [NSUserDefaults standardUserDefaults];
    [userDefaut setObject:@"error" forKey:@"token"];
    [userDefaut setObject:@"error" forKey:LocationLoginInResultsKey];
    [userDefaut setObject:@[] forKey:LocationLimitsChangeKey];
    [XGPush delAccount:^{
        if ([TOKEN isEqualToString:@"error"]) {
            //跳转到登录界面
            ViewController *loginVC = [[ViewController alloc] init];
            //        self.modalPresentationStyle = UIModalPresentationCurrentContext;
            //        self.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
            //        [self presentViewController:loginVC animated:YES completion:^{
            //            loginVC.registLogName = tempLoginName;
            //        }];

            [self.navigationController pushViewController:loginVC animated:YES];
        }
    } errorCallback:^{
    }];

}
-(void)GetsonethingWithaf
{
    CGFloat height = [[UIApplication sharedApplication] statusBarFrame].size.height + self.navigationController.navigationBar.frame.size.height;

    _numbary = [NSMutableArray array];
    NSString * token = TOKEN;
    NSString * userid = UserId;
    [MBProgressHUD showMessage:@"请稍等"];
    NSString *uploadUrl = [NSString stringWithFormat:@"%@api/merchant/searchMUserInfo?token=%@&userId=%@",kBaseURL,token,userid];
      
    [[QYXNetTool shareManager] postNetWithUrl:uploadUrl urlBody:nil bodyStyle:QYXBodyString header:nil response:QYXJSON success:^(id result) {
        [MBProgressHUD hideHUD];
//        NSLog(@"resulttt%@",result);
        id obj = [result objectForKey:@"obj"];

        if (![obj isNull] && ![obj isKindOfClass:[NSString class]]) {

            NSString * name = [NSString stringWithFormat:@"%@",[obj objectForKey:@"loginName"]];
            NSString * cardstr = [NSString stringWithFormat:@"%@",[obj objectForKey:@"cardNo"]];
            NSString * alipay = [NSString stringWithFormat:@"%@",[obj objectForKey:@"alipay"]];
            _editStatus = obj[@"editStatus"]; //0 为提交 1 审核中 2 审核通过
            [_numbary addObject:name];
            [_numbary addObject:cardstr];
            [_numbary addObject:alipay];

            _tableView = [[UITableView alloc]init];
            _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
            _tableView.delegate = self;
            _tableView.dataSource = self;
            _tableView.scrollEnabled = NO;
            [self.view addSubview:_tableView];
            _tableView.sd_layout.leftEqualToView(self.view).topSpaceToView(self.view,height).widthIs(self.view.frame.size.width).heightIs(autoScaleH(105)+autoScaleH(45)*6);
        }

    } failure:^(NSError *error) {

        [MBProgressHUD hideHUD];

     }];
}


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section==0) {
        return 3;
    }
    if (section==1) {

        return 5;
    }
    return 4;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    LoginTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"num"];
    if (!cell) {

        cell = [[LoginTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"num"];
    }

    cell.selectionStyle = UITableViewCellSelectionStyleNone;

    cell.textfild.hidden = YES;
    UILabel * linelabel = [[UILabel alloc]init];
    linelabel.backgroundColor = UIColorFromRGB(0xeeeeee);
    [cell addSubview:linelabel];
    linelabel.sd_layout.leftEqualToView(cell).rightEqualToView(cell).bottomEqualToView(cell).heightIs(0.5);

    if (indexPath.section==0) {
        if (indexPath.row==0) {
            cell.backgroundColor = RGB(242, 242, 242);

        }
        if (indexPath.row==1) {

            UILabel * leftlabel = [[UILabel alloc]init];
            leftlabel.frame = CGRectMake(autoScaleW(15), autoScaleH(4), autoScaleW(50), autoScaleH(15));
            leftlabel.font = [UIFont systemFontOfSize:autoScaleW(11)];
            leftlabel.textColor = [UIColor lightGrayColor];
            leftlabel.text = @"账号设置";
            [cell addSubview:leftlabel];
        }

        if (indexPath.row==2)

        {
            UILabel * leftlabel = [[UILabel alloc]init];
            leftlabel.text= @"员工账号";
            leftlabel.font =[UIFont systemFontOfSize:13];
            [cell addSubview:leftlabel];
            leftlabel.sd_layout.leftSpaceToView(cell,autoScaleW(15)).centerYEqualToView(cell).widthIs(autoScaleW(70)).heightIs(autoScaleH(15));
            UIImageView * rightimage = [[UIImageView alloc]init];
            rightimage.image = [UIImage imageNamed:@"形状-3-拷贝"];
            [cell addSubview:rightimage];
            rightimage.sd_layout.rightSpaceToView(cell,autoScaleW(15)).centerYEqualToView(cell).widthIs(autoScaleW(8)).heightIs(autoScaleH(11));
        }

    }
    if (indexPath.section==1) {
        if (indexPath.row==0) {
            cell.backgroundColor = RGB(242, 242, 242);

        }
        if (indexPath.row==1) {

            UILabel * leftlabel = [[UILabel alloc]init];
            leftlabel.frame = CGRectMake(autoScaleW(15), autoScaleH(4), autoScaleW(50), autoScaleH(15));
            leftlabel.font = [UIFont systemFontOfSize:autoScaleW(11)];
            leftlabel.textColor = [UIColor lightGrayColor];
            leftlabel.text = @"绑定信息";
            [cell addSubview:leftlabel];
        }
        if (indexPath.row==2||indexPath.row==3||indexPath.row==4)
        {
            cell.leftlabel.text = _secary[indexPath.row-2];
            UILabel * centerlabel = [[UILabel alloc]init];



            if (![_numbary[indexPath.row-2] isNull])
            {
                centerlabel.text =                                                                                                                                                                                                                                                      _numbary[indexPath.row-2];
                if ([_numbary[indexPath.row - 2] isNull]) {
                    centerlabel.text = @"";
                } else {
                    centerlabel.text =                                                                                                                                                                                                                                                      _numbary[indexPath.row-2];
                }

                UIImageView * rightimage = [[UIImageView alloc]init];
                rightimage.image = [UIImage imageNamed:@"感叹号hao"];
                [cell addSubview:rightimage];
                rightimage.sd_layout.rightSpaceToView(cell,autoScaleW(15)).centerYEqualToView(cell).widthIs(autoScaleW(15)).heightIs(autoScaleH(15));


            }

            centerlabel.font = [UIFont systemFontOfSize:autoScaleW(13)];
            centerlabel.textColor = [UIColor lightGrayColor];
            [cell addSubview:centerlabel];
            centerlabel.sd_layout.leftSpaceToView(cell.leftlabel,autoScaleW(20)).centerYEqualToView(cell).widthIs(autoScaleW(140)).heightIs(autoScaleH(15));


            ButtonStyle * xiugaiBtn = [ButtonStyle buttonWithType:UIButtonTypeCustom];
            xiugaiBtn.tag= indexPath.row+200;
            if (![_numbary[indexPath.row-2] isNull])
            {
                [xiugaiBtn setTitle:@"修改" forState:UIControlStateNormal];

            }
            else
            {
                [xiugaiBtn setTitle:@"绑定" forState:UIControlStateNormal];
            }

            [xiugaiBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
            xiugaiBtn.titleLabel.font = [UIFont systemFontOfSize:13] ;
            xiugaiBtn.tag = 200 +indexPath.row;
            [xiugaiBtn addTarget:self action:@selector(Change:) forControlEvents:UIControlEventTouchUpInside];
            [cell addSubview:xiugaiBtn];
            xiugaiBtn.sd_layout.rightSpaceToView(cell,autoScaleW(35)).centerYEqualToView(cell).widthIs(autoScaleW(50)).heightIs(autoScaleH(20));

        }

    }
    if (indexPath.section==2) {
        if (indexPath.row==0) {
            cell.backgroundColor = RGB(242, 242, 242);

        }
        if (indexPath.row==1) {

            UILabel * leftlabel = [[UILabel alloc]init];
            leftlabel.frame = CGRectMake(autoScaleW(15), autoScaleH(4), autoScaleW(50), autoScaleH(15));
            leftlabel.font = [UIFont systemFontOfSize:autoScaleW(11)];
            leftlabel.textColor = [UIColor lightGrayColor];
            leftlabel.text = @"账号安全";
            [cell addSubview:leftlabel];
        }
        if(indexPath.row==2||indexPath.row==3)
        {
            cell.leftlabel.text = _thrary[indexPath.row-2];

            UIImageView * rightimage = [[UIImageView alloc]init];
            rightimage.image = [UIImage imageNamed:@"形状-3-拷贝"];
            [cell addSubview:rightimage];
            rightimage.sd_layout.rightSpaceToView(cell,autoScaleW(15)).topSpaceToView(cell,autoScaleH(20)).widthIs(autoScaleW(8)).heightIs(autoScaleH(11));

            ButtonStyle * xiugaiBtn = [ButtonStyle buttonWithType:UIButtonTypeCustom];
            xiugaiBtn.tag= indexPath.row;
            [xiugaiBtn setTitle:@"修改" forState:UIControlStateNormal];
            [xiugaiBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
            xiugaiBtn.titleLabel.font = [UIFont systemFontOfSize:13] ;
            xiugaiBtn.tag = 300 +indexPath.row;
            [xiugaiBtn addTarget:self action:@selector(Xiugai:) forControlEvents:UIControlEventTouchUpInside];
            [cell addSubview:xiugaiBtn];
            xiugaiBtn.sd_layout.rightSpaceToView(rightimage,autoScaleW(10)).topSpaceToView(cell,autoScaleH(15)).widthIs(autoScaleW(50)).heightIs(autoScaleH(20));

        }

    }



    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0) {

        if (indexPath.row==2) {
            PersonalViewController * personalview = [[PersonalViewController alloc]init];
            [self.navigationController pushViewController:personalview animated:YES];
        }
    }



}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{

    if (indexPath.row==0) {

        return autoScaleH(15);
    }
    if (indexPath.row==1) {

        return autoScaleH(20);
    }
    return autoScaleH(45);
}
#pragma mark 绑定信息按钮
-(void)Change:(ButtonStyle *)btn
{
    if ([_numbary[btn.tag-202] isNull]) {//未绑定时绑定，只有支付宝会出现这种情况
        
        if (btn.tag ==204) {
            
            PhoneyzViewController * phoneyz = [[PhoneyzViewController alloc]init];
            phoneyz.tiaointeger = 4;
            phoneyz.xianinteger = 2;
            phoneyz.phonestr = _numbary[0];
            
            [self.navigationController pushViewController:phoneyz animated:YES];
        }

    }
    else{
        
        ZTAddOrSubAlertView * selectview = [[ZTAddOrSubAlertView alloc] initWithStyle:ZTalertSheetStyleSubTitle];
        [selectview showView];
        selectview.littleLabel.text = @"*可能到涉及账号安全";
        if (btn.tag==202) {
            
            selectview.titleLabel.text = @"确定要修改管理员手机号";
            
        }
        if (btn.tag==203) {
            selectview.titleLabel.text = @"确定要修改提现银行卡";
            if ([_editStatus integerValue] == 0 ) {
                //未提交资料。或者审核被拒
            } else if ([_editStatus integerValue] == 1) {
                //审核中
                selectview.titleLabel.text = @"正在审核，请耐心等待";
                selectview.littleLabel.hidden = YES;
            } else {
                //2 审核通过
            }
            
        }
        if (btn.tag==204) {
            
            selectview.titleLabel.text = @"确定要修改提现支付宝？";
            
        }
        selectview.complete = ^(BOOL ss)
        {
            if (ss==YES)
            {
                
                
                if (btn.tag==202) {
                    
                    PhoneyzViewController * phoneyz = [[PhoneyzViewController alloc]init];
                    phoneyz.phonestr = _numbary[0];
                    phoneyz.tiaointeger = 1;
                    [self.navigationController pushViewController:phoneyz animated:YES];
                }
                if (btn.tag ==203&&[_editStatus integerValue] != 1) {//银行卡不在审核状态时
                    
                    PhoneyzViewController * phoneyz = [[PhoneyzViewController alloc]init];
                    phoneyz.tiaointeger = 3;
                    phoneyz.xianinteger = 1;
                    phoneyz.phonestr = _numbary[0];
                    
                    [self.navigationController pushViewController:phoneyz animated:YES];
                }
                if (btn.tag ==204) {
                    
                    PhoneyzViewController * phoneyz = [[PhoneyzViewController alloc]init];
                    
                    phoneyz.tiaointeger = 4;
                    phoneyz.xianinteger = 2;
                    phoneyz.phonestr = _numbary[0];
                    
                    [self.navigationController pushViewController:phoneyz animated:YES];
                }
            }
        };

    }
    
   
}
#pragma mark 账号安全按钮
-(void)Xiugai:(ButtonStyle *)btn
{
    if (btn.tag==303) {
        ChangetixianViewController * changgetixian = [[ChangetixianViewController alloc]init];
        changgetixian.tiaointer = 1;
        [self.navigationController pushViewController:changgetixian animated:YES];

    }
    if (btn.tag==302) {
        ChangelogincodeViewController * changeloginview = [[ChangelogincodeViewController alloc]init];
        [self.navigationController pushViewController:changeloginview animated:YES];
    }

}
-(void)Back
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
