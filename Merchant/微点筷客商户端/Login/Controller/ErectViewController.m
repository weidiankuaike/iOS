//
//  ErectViewController.m
//  微点筷客商户端
//
//  Created by 张森森 on 16/10/6.
//  Copyright © 2016年 张森森. All rights reserved.
//

#import "ErectViewController.h"
#import "TixianViewController.h"
#import "PersonalViewController.h"
#import "UIBarButtonItem+SSExtension.h"
#import "HomeVC.h"
#import "FirsttixianViewController.h"
#import "QYXNetTool.h"
#import "MBProgressHUD+SS.h"
#import "ServiceCategoryVC.h"
#import "MBProgressHUD+SS.h"
@interface ErectViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    NSArray * firstary;
    NSArray * threeary;
    NSArray * fourary;
    NSArray * addAry;
    UISwitch * _mySwitch;
    UIImageView* _jianImage;
    UITableView * erecttableview;
    UILabel * leftlabel1;
    ButtonStyle * btn;
    UILabel * linlab;
    UILabel * linlab1;
    BOOL isopen;
    UILabel* timelabel;
    BOOL isfirst;
}
@property (nonatomic,assign)int  finteger;
@property (nonatomic,assign)int sinteger;
@property (nonatomic,assign)int tinteger;
@property (nonatomic,assign)int fourinteger;
@property (nonatomic,copy)NSString * serverstr ;
@end

@implementation ErectViewController
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationItem setHidesBackButton:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.titleView.text = @"完成设置";
    isopen = YES;
    isfirst = YES;
    _finteger = 1;
    _sinteger = 1;
    _tinteger = 1;
    _fourinteger = 1;
    self.view.backgroundColor= UIColorFromRGB(0xffffff);
    self.automaticallyAdjustsScrollViewInsets = NO;
    
     CGFloat height = [[UIApplication sharedApplication] statusBarFrame].size.height + self.navigationController.navigationBar.frame.size.height;
    erecttableview = [[UITableView alloc]init];
    erecttableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    erecttableview.delegate = self;
    erecttableview.dataSource = self;
    [self.view addSubview:erecttableview];
    erecttableview.sd_layout.leftEqualToView(self.view).topSpaceToView(self.view,height).widthIs(self.view.frame.size.width).heightIs(self.view.frame.size.height-autoScaleH(50)-height);
    
    ButtonStyle * loginbtn = [ButtonStyle buttonWithType:UIButtonTypeCustom];
    [loginbtn setTitle:@"完成设置" forState:UIControlStateNormal];
    loginbtn.titleLabel.font = [UIFont systemFontOfSize:autoScaleW(15)];
    [loginbtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    loginbtn.backgroundColor = UIColorFromRGB(0xfd7577);
    [loginbtn addTarget:self action:@selector(Finish) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:loginbtn];
    loginbtn.sd_layout.leftSpaceToView(self.view,autoScaleW(10)).rightSpaceToView(self.view,autoScaleW(10)).bottomSpaceToView(self.view,autoScaleH(10)).heightIs(autoScaleH(33));
    
    
    firstary = @[@"提现设置",@"员工账号",];
    fourary = @[@"接受用餐预定",@"接受排队领号",@"开启现场服务管理",@"开启排队管理",];
    
    
    
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section==0) {
        
        return 4;
    }
   
    return 6;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * idenstring = @"erct";
    UITableViewCell * cell = [tableView cellForRowAtIndexPath:indexPath];
    if (!cell) {
        cell= [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:idenstring];
    }
    
    
    UILabel * linlabb =[[UILabel alloc]init];
    linlabb.backgroundColor = UIColorFromRGB(0xeeeeee);
    [cell addSubview:linlabb];
    linlabb.sd_layout.leftSpaceToView(cell,0).rightSpaceToView(cell,0).bottomSpaceToView(cell,0).heightIs(0.5);
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (indexPath.section==0) {
        
        if (indexPath.row==3) {
            cell.backgroundColor= RGB(242, 242, 242);
            
        }
         if (indexPath.row==0)
        {

            UILabel * leftlabel = [[UILabel alloc]init];
            leftlabel.frame = CGRectMake(autoScaleW(15), autoScaleH(4), autoScaleW(120), autoScaleH(15));
            leftlabel.font = [UIFont systemFontOfSize:autoScaleW(15)];
            leftlabel.textColor = [UIColor lightGrayColor];
            leftlabel.text = @"账号设置";
            [cell addSubview:leftlabel];
            
        }
        if (indexPath.row==1||indexPath.row==2)
        {
            UILabel * leftlabel = [[UILabel alloc]init];
            leftlabel.text= firstary[indexPath.row-1];
            leftlabel.font =[UIFont systemFontOfSize:autoScaleW(15)];
            [cell addSubview:leftlabel];
            leftlabel.sd_layout.leftSpaceToView(cell,autoScaleW(15)).topSpaceToView(cell,autoScaleH(15)).heightIs(autoScaleH(15));
            [leftlabel setSingleLineAutoResizeWithMaxWidth:100];
            UIImageView * rightimage = [[UIImageView alloc]init];
            rightimage.image = [UIImage imageNamed:@"形状-3-拷贝"];
            [cell addSubview:rightimage];
            rightimage.sd_layout.rightSpaceToView(cell,autoScaleW(15)).topSpaceToView(cell,autoScaleH(15)).widthIs(autoScaleW(8)).heightIs(autoScaleH(11));
        }
        
    }

    if (indexPath.section==1) {
        if (indexPath.row==0) {
            
            UILabel * leftlabel = [[UILabel alloc]init];
            leftlabel.frame = CGRectMake(autoScaleW(15), autoScaleH(4), autoScaleW(80), autoScaleH(15));
            leftlabel.font = [UIFont systemFontOfSize:autoScaleW(15)];
            leftlabel.textColor = [UIColor lightGrayColor];
            leftlabel.text = @"功能设置";
            [cell addSubview:leftlabel];
            [leftlabel setSingleLineAutoResizeWithMaxWidth:120];
        }
        else if (indexPath.row==1)
        {
            UILabel * leftlabel = [[UILabel alloc]init];
            leftlabel.text= @"所提供的服务";
            leftlabel.font =[UIFont systemFontOfSize:autoScaleW(15)];
            [cell addSubview:leftlabel];
            leftlabel.sd_layout.leftSpaceToView(cell,autoScaleW(15)).topSpaceToView(cell,autoScaleH(15)).widthIs(autoScaleW(80)).heightIs(autoScaleH(15));
            [leftlabel setSingleLineAutoResizeWithMaxWidth:200];
            UIImageView * rightimage = [[UIImageView alloc]init];
            rightimage.image = [UIImage imageNamed:@"形状-3-拷贝"];
            [cell addSubview:rightimage];
            rightimage.sd_layout.rightSpaceToView(cell,autoScaleW(15)).topSpaceToView(cell,autoScaleH(15)).widthIs(autoScaleW(8)).heightIs(autoScaleH(11));
        }
        else
        {
        UILabel * leftlabel = [[UILabel alloc]init];
        leftlabel.text = nil;
        leftlabel.text= fourary [indexPath.row-2];
        leftlabel.font =[UIFont systemFontOfSize:autoScaleW(15)];
        [cell addSubview:leftlabel];
        leftlabel.sd_layout.leftSpaceToView(cell,autoScaleW(15)).topSpaceToView(cell,autoScaleH(15)).widthIs(autoScaleW(120)).heightIs(autoScaleH(15));
            [leftlabel setSingleLineAutoResizeWithMaxWidth:200];
        _mySwitch = [[UISwitch alloc]init];
        _mySwitch.on = YES;
        _mySwitch.tag = 300 + indexPath.row;
//            NSLog(@"jjjj%ld",(long)_mySwitch.tag);
        [_mySwitch setOnTintColor:UIColorFromRGB(0xfd7577)];
        [_mySwitch addTarget:self action:@selector(swChange:) forControlEvents:UIControlEventValueChanged];
        [cell addSubview:_mySwitch];
        _mySwitch.sd_layout.rightSpaceToView(cell,autoScaleW(15)).topSpaceToView(cell,autoScaleH(8)).widthIs(autoScaleW(8)).heightIs(autoScaleH(11));
        }
        
    }
    
    [cell layoutSubviews];
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.section==0) {
        
        if (indexPath.row==3) {
            
            return autoScaleH(10);
        }
        if (indexPath.row==0) {
            
            return autoScaleH(20);
        }
    }
    
    if (indexPath.section==1) {
        
        
        if (indexPath.row==0) {
            
            return autoScaleH(20);
        }
        
    }
    
    return autoScaleH(45);
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0) {
        
        if (indexPath.row==1) {
            if (isfirst==YES) {
                FirsttixianViewController * tixianView = [[FirsttixianViewController alloc]init];
                tixianView.pushinter = 1;
                [self.navigationController pushViewController:tixianView animated:YES];
            
            }
            
       
            if (isfirst==NO) {
               
                [MBProgressHUD showError:@"请完成设置后到更多设置页面进行修改"];
            }
           isfirst = NO;
        }
        
        if (indexPath.row==2) {

            PersonalViewController * personalView = [[PersonalViewController alloc]init];
            [self.navigationController pushViewController:personalView animated:YES];
        }
        
        
    }
    if (indexPath.section==1) {
        
        if (indexPath.row==1) {
           
            
            
            ServiceCategoryVC * servevieww = [[ServiceCategoryVC alloc]init];
            servevieww.returnJoinInVC = ^(NSString * str) {
                _serverstr = str;
            };
            [self.navigationController pushViewController:servevieww animated:YES];
        }
    }
}
#pragma mark 开关按钮
-(void)swChange:(UISwitch*)sw
{
    if (sw.tag==302) {
        
        if (sw.on==YES) {
            
            _finteger=1;
        }
        else
        {
            _finteger=0;
        }
    }
    if (sw.tag==303) {
        
        if (sw.on==YES) {
            
            _sinteger = 1;
        }
        else
        {
            _sinteger = 0;
        }
    }
    if (sw.tag==304) {
        
        if (sw.on==YES) {
            
            _tinteger = 1;
        }
        else
        {
            _tinteger = 0;
        }
    }
    if (sw.tag==305) {
        
        if (sw.on==YES) {
            _fourinteger=1;
            
        }
        else
        {
            _fourinteger=0;
        }
    }
}
-(void)Finish
{
//    NSLog(@"kk%@",_serverstr);
//    NSLog(@"bbb%dvv%d%d%d",_finteger,_sinteger,_tinteger,_fourinteger);


    [MBProgressHUD showMessage:@"请稍等"];
    if ([_serverstr isNull] || _serverstr == nil) {
        _serverstr = @"呼叫,加水,纸巾,清理,加饭,催菜,";
    }
    NSString *uploadUrl = [NSString stringWithFormat:@"%@api/merchant/accountAllSet?token=%@&isLine=%d&isBook=%d&isService=%d&isKitchen=%d&offerService=%@&id=%@",kBaseURL,TOKEN,_finteger,_sinteger,_tinteger,_fourinteger,_serverstr,UserId];
          
        [[QYXNetTool shareManager] postNetWithUrl:uploadUrl urlBody:nil bodyStyle:QYXBodyString header:nil response:QYXJSON success:^(id result) {
        [MBProgressHUD hideHUD];
        NSString * codestr = [result objectForKey:@"msgType"];
        if ([codestr integerValue]==0) {
            [MBProgressHUD showSuccess:@"入驻成功"];
//            NSLog(@"resultttt%@",result);
            NSDictionary * dict = [result objectForKey:@"obj"];
            if (![dict isNull]) {
                NSUserDefaults * userde = [NSUserDefaults standardUserDefaults];
                NSData *archData = [NSKeyedArchiver  archivedDataWithRootObject:result[@"obj"]];
                [userde setObject:archData forKey:LocationLoginInResultsKey];
                HomeVC *homeVC = [[HomeVC alloc] init];
                [self  presentViewController:homeVC animated:YES completion:nil];
            }
        }
        if ([codestr integerValue]==1001) {
            
            [MBProgressHUD showError:@"提现卡号未绑定"];
            
        }
        if ([codestr integerValue]==1000) {
            
            [MBProgressHUD showError:@"系统异常"];
        }
        
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUD];
        
    }];
    
    
   
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
