//
//  ChangeNameViewController.m
//  wdKuaiKe_iOS
//
//  Created by 张森森 on 17/4/5.
//  Copyright © 2017年 weiDianKuaiKe. All rights reserved.
//

#import "ChangeNameViewController.h"
#import "UIBarButtonItem+SSExtension.h"
#import "MBProgressHUD+SS.h"
#import "QYXNetTool.h"
@interface ChangeNameViewController ()
{
    UITextField * nametext;
}
@end

@implementation ChangeNameViewController
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = NO;
    self.navigationController.navigationBar.translucent = NO;
    [self.navigationController.navigationBar setBarTintColor:UIColorFromRGB(0xfd7577)];
    self.tabBarController.tabBar.hidden = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = RGB(238, 238, 238);
    UILabel * titlabel = [[UILabel alloc]init];
    titlabel.frame = CGRectMake(0, 0, 80, 30);
    titlabel.textAlignment = NSTextAlignmentCenter;
    titlabel.font = [UIFont systemFontOfSize:15];
    titlabel.text = @"修改昵称";
    titlabel.textColor = [UIColor whiteColor];
    self.navigationItem.titleView = titlabel;
    UIBarButtonItem * backbtn = [UIBarButtonItem itemWithTarget:self Action:@selector(Back) image:@"left-1" selectImage:nil];
    self.navigationItem.leftBarButtonItem = backbtn;
    [self Creatview];
    
}
- (void)Creatview{
    UIView * backgroundview = [[UIView alloc]init];
    backgroundview.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:backgroundview];
    backgroundview.sd_layout.leftEqualToView(self.view).rightEqualToView(self.view).topSpaceToView(self.view,autoScaleH(30)).heightIs(autoScaleH(50));
    
    UILabel * leftlabel = [[UILabel alloc]init];
    leftlabel.font = [UIFont systemFontOfSize:autoScaleW(15)];
    leftlabel.textColor = [UIColor lightGrayColor];
    leftlabel.text = @"新的昵称:";
    [backgroundview addSubview:leftlabel];
    leftlabel.sd_layout.leftSpaceToView(backgroundview,autoScaleW(15)).topSpaceToView(backgroundview,autoScaleW(10)).heightIs(autoScaleH(30)).widthIs(autoScaleW(100));
    
    nametext = [[UITextField alloc]init];
    nametext.placeholder = @"请输入您的昵称";
    nametext.font = [UIFont systemFontOfSize:autoScaleW(15)];
    nametext.clearsOnBeginEditing = YES;
    [backgroundview addSubview:nametext];
    nametext.sd_layout.leftSpaceToView(leftlabel,autoScaleW(10)).topEqualToView(leftlabel).heightIs(autoScaleH(30)).widthIs(GetWidth-autoScaleW(15)-autoScaleW(10)-autoScaleW(100));
    
    UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:@"确认" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    //    button.titleLabel.font = [UIFont systemFontOfSize:autoScaleW(15)];
    button.backgroundColor = UIColorFromRGB(0xfd7577);
    [button addTarget:self action:@selector(changeName) forControlEvents:UIControlEventTouchUpInside];
    button.layer.cornerRadius = 3;
    [self.view addSubview:button];
    button.sd_layout.leftSpaceToView(self.view,autoScaleW(15)).rightSpaceToView(self.view,autoScaleW(15)).topSpaceToView(backgroundview,autoScaleH(50)).heightIs(autoScaleH(40));

}
#pragma mark 修改昵称
- (void)changeName{
    if (nametext.text!=nil) {
        [MBProgressHUD showMessage:@"请稍等"];
        NSString * url = [NSString stringWithFormat:@"%@/api/user/userInfoManage?token=%@&userId=%@&operation=7&name=%@",commonUrl,Token,Userid,nametext.text];
        NSArray * urlary = [url componentsSeparatedByString:@"?"];
        [[QYXNetTool shareManager]postNetWithUrl:urlary.firstObject urlBody:urlary.lastObject bodyStyle:QYXBodyString header:nil response:QYXJSON success:^(id result) {
            [MBProgressHUD hideHUD];
            
            NSString* msgtype = [NSString stringWithFormat:@"%@",result[@"msgType"]];
            if ([msgtype isEqualToString:@"0"]) {
                [MBProgressHUD showSuccess:@"修改成功"];
                [self Back];
                
            }
        } failure:^(NSError *error) {
            [MBProgressHUD showError:@"请求失败"];
        }];
    }else{
        
        [MBProgressHUD showError:@"请输入正确内容"];
    }
   
    
    
    
}
- (void)Back{
    
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
