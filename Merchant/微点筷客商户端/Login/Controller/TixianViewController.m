//
//  TixianViewController.m
//  微点筷客商户端
//
//  Created by 张森森 on 16/10/7.
//  Copyright © 2016年 张森森. All rights reserved.
//

#import "TixianViewController.h"
#import "LoginTableViewCell.h"
#import "UIBarButtonItem+SSExtension.h"
#import "ChangeBankViewController.h"
#import "PhoneyzViewController.h"
#import "ChangetixianViewController.h"
#import "ZTAddOrSubAlertView.h"
@interface TixianViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    
    NSArray * titary;
//    NSArray * centerary;
    UIView * _timeview;
    NSInteger xianinteger;
}
@end

@implementation TixianViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.titleView.text = @"提现设置";
    self.view.backgroundColor = UIColorFromRGB(0xffffff);
    

    CGFloat height = [[UIApplication sharedApplication] statusBarFrame].size.height + self.navigationController.navigationBar.frame.size.height;
    
    UIView* headlabel = [[UIView alloc]init];
    headlabel.backgroundColor = RGB(242, 242, 242);
    [self.view addSubview:headlabel];
    headlabel.sd_layout.leftEqualToView(self.view).rightEqualToView(self.view).topSpaceToView(self.view,height).heightIs(autoScaleH(20));
    
//    UIImageView * tanimage = [[UIImageView alloc]init];
//    tanimage.image =[UIImage imageNamed:@"感叹号"];
//    [headlabel addSubview:tanimage];
//    tanimage.sd_layout.leftSpaceToView(headlabel,autoScaleW(15)).topSpaceToView(headlabel,autoScaleH(5)).widthIs(autoScaleW(10)).heightIs(autoScaleH(10));
//    
//    
//    
//    UILabel* headlabell = [[UILabel alloc]init];
//    headlabell.text = @"修改提现卡号请联系客服";
//    headlabell.textColor = UIColorFromRGB(0xfd7577);
//    headlabell.font = [UIFont systemFontOfSize:autoScaleW(11)];
//    [headlabel addSubview:headlabell];
//    headlabell.sd_layout.leftSpaceToView(tanimage,autoScaleW(2)).widthIs(kScreenWidth-autoScaleW(30)).topSpaceToView(headlabel,autoScaleH(2)).heightIs(autoScaleH(15));
    
    titary = @[@"持卡人",@"提现卡号",@"绑定支付宝", @"修改提现密码",@"忘记提现密码",];
    
    UITableView * tixiantable = [[UITableView alloc]init];
    tixiantable.separatorStyle = UITableViewCellSeparatorStyleNone;
    tixiantable.delegate = self;
    tixiantable.dataSource = self;
    [self.view addSubview:tixiantable];
    tixiantable.sd_layout.leftEqualToView(self.view).rightEqualToView(self.view).topSpaceToView(headlabel,0).heightIs(autoScaleH(45*titary.count));
    
    
    
}
-(void)leftBarButtonItemAction{
    [self Back];
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return titary.count;
    
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    LoginTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"tixian"];
    if (!cell) {
        
        cell= [[LoginTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"tixian"];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    
    UILabel * linlab =[[UILabel alloc]init];
    linlab.backgroundColor = UIColorFromRGB(0xeeeeee);
    [cell addSubview:linlab];
    linlab.sd_layout.leftSpaceToView(cell,0).rightSpaceToView(cell,0).bottomSpaceToView(cell,0).heightIs(0.5);
    
    cell.leftlabel.text = titary[indexPath.row];
    cell.textfild.hidden = YES;
    
    if (indexPath.row==0||indexPath.row==1||indexPath.row==2) {
        
        UILabel * centerlabel = [[UILabel alloc]init];
        centerlabel.font = [UIFont systemFontOfSize:autoScaleW(11)];
        centerlabel.textColor = [UIColor lightGrayColor];
        [cell addSubview:centerlabel];
        centerlabel.sd_layout.leftSpaceToView(cell.leftlabel,0).topSpaceToView(cell,autoScaleH(15)).widthIs(autoScaleW(140)).heightIs(autoScaleH(15));
        if (indexPath.row==0) {
            
            centerlabel.text= @"林玲玲";
        }
        if (indexPath.row==1||indexPath.row==2) {
            centerlabel.text = @"1234567891234567";
            
            ButtonStyle * xiugaiBtn = [ButtonStyle buttonWithType:UIButtonTypeCustom];
            xiugaiBtn.tag= indexPath.row;
            [xiugaiBtn setTitle:@"修改" forState:UIControlStateNormal];
            [xiugaiBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
            xiugaiBtn.titleLabel.font = [UIFont systemFontOfSize:13] ;
            xiugaiBtn.tag = 200 +indexPath.row;
            [xiugaiBtn addTarget:self action:@selector(Change:) forControlEvents:UIControlEventTouchUpInside];
            [cell addSubview:xiugaiBtn];
            xiugaiBtn.sd_layout.rightSpaceToView(cell,autoScaleW(15)).topSpaceToView(cell,autoScaleH(15)).widthIs(autoScaleW(50)).heightIs(autoScaleH(20));
            
            if (indexPath.row==1) {
                
                 centerlabel.text = @"1234567891234567";
            }
            if (indexPath.row==2) {
                
                 centerlabel.text = @"1234567891234567";
            }
        }
        
    }
    else
    {
        
        UIImageView * rightimage = [[UIImageView alloc]init];
        rightimage.image = [UIImage imageNamed:@"形状-3-拷贝"];
        [cell addSubview:rightimage];
        rightimage.sd_layout.rightSpaceToView(cell,autoScaleW(15)).topSpaceToView(cell,autoScaleH(15)).widthIs(autoScaleW(8)).heightIs(autoScaleH(11));
        
        
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row==2) {
        
        PhoneyzViewController * phoneyzview = [[PhoneyzViewController alloc]init];
        phoneyzview.tiaointeger = 2;
        [self.navigationController pushViewController:phoneyzview animated:YES];
        
    }
    if (indexPath.row==3) {
        
        ChangetixianViewController * changetixianview = [[ChangetixianViewController alloc]init];
        [self.navigationController pushViewController:changetixianview animated:YES];
    }
}
-(void)Change:(ButtonStyle *)btn
{
    
    
    if (btn.tag==201) {
        xianinteger = 1;
       
    }
    if (btn.tag==202) {
        
        xianinteger = 2;
        
        
            }
    
    ZTAddOrSubAlertView * selectview = [[ZTAddOrSubAlertView alloc] initWithStyle:ZTalertSheetStyleSubTitle];
    [selectview showView];
    selectview.littleLabel.text = @"*可能到涉及账号安全";
    
    if (btn.tag==201) {
        selectview.titleLabel.text = @"确定要修改提现银行卡";
        
    }
    if (btn.tag==202) {
        
        selectview.titleLabel.text = @"确定要修改提现支付宝？";
        
    }
    selectview.complete = ^(BOOL ss)
    {
        if (ss==YES)
        {
            
            
            
            if (btn.tag ==201) {
                
                PhoneyzViewController * phoneyz = [[PhoneyzViewController alloc]init];
                phoneyz.phonestr = @"123456789102";
                
                phoneyz.tiaointeger = 2;
                phoneyz.xianinteger = 1;
                [self.navigationController pushViewController:phoneyz animated:YES];
            }
            if (btn.tag ==202) {
                
                PhoneyzViewController * phoneyz = [[PhoneyzViewController alloc]init];
                phoneyz.phonestr = @"123456789102";
                
                phoneyz.tiaointeger = 2;
                phoneyz.xianinteger = 2;
                [self.navigationController pushViewController:phoneyz animated:YES];
                
            }
            
            
            
            
        }
        
    };

   
    
    
    
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
