//
//  MimaViewController.m
//  微点筷客商户端
//
//  Created by 张森森 on 16/10/24.
//  Copyright © 2016年 张森森. All rights reserved.
//

#import "MimaViewController.h"
#import "UIBarButtonItem+SSExtension.h"
#import "LoginTableViewCell.h"
#import "QYXNetTool.h"
#import "MBProgressHUD+SS.h"
#import "NumberViewController.h"
#import "ErectViewController.h"
@interface MimaViewController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>
@property (nonatomic,strong)NSArray * leftary;
@property (nonatomic,strong)NSArray * fieldary;
@property (nonatomic,strong)ButtonStyle * tijiaoBtn;
@property (nonatomic,strong)UITextField * firstfie;
@property (nonatomic,strong)UITextField * secfie;

@end

@implementation MimaViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.titleView.text = @"提现密码";
    self.view.backgroundColor = RGB(242, 242, 242);
    self.automaticallyAdjustsScrollViewInsets = NO;

    
    CGFloat height = [[UIApplication sharedApplication] statusBarFrame].size.height + self.navigationController.navigationBar.frame.size.height;
    
    UIView* headlabel = [[UIView alloc]init];
    headlabel.backgroundColor = RGB(242, 242, 242);
    [self.view addSubview:headlabel];
    headlabel.sd_layout.leftEqualToView(self.view).rightEqualToView(self.view).topSpaceToView(self.view,height).heightIs(autoScaleH(20));
    
    UIImageView * tanimage = [[UIImageView alloc]init];
    tanimage.image =[UIImage imageNamed:@"感叹号"];
    [headlabel addSubview:tanimage];
    tanimage.sd_layout.leftSpaceToView(headlabel,autoScaleW(15)).topSpaceToView(headlabel,autoScaleH(5)).widthIs(autoScaleW(10)).heightIs(autoScaleH(10));
    
    
    
    UILabel* headlabell = [[UILabel alloc]init];
    headlabell.text = @"为保障您的资金安全，请牢记您的密码";
    headlabell.textColor = UIColorFromRGB(0xfd7577);
    headlabell.font = [UIFont systemFontOfSize:autoScaleW(11)];
    [headlabel addSubview:headlabell];
    headlabell.sd_layout.leftSpaceToView(tanimage,autoScaleW(2)).widthIs(kScreenWidth-autoScaleW(30)).topSpaceToView(headlabel,autoScaleH(2)).heightIs(autoScaleH(15));
    
    UITableView * tixiantable = [[UITableView alloc]init];
    tixiantable.separatorStyle = UITableViewCellSeparatorStyleNone;
    tixiantable.delegate = self;
    tixiantable.dataSource = self;
    [self.view addSubview:tixiantable];
    tixiantable.sd_layout.leftEqualToView(self.view).rightEqualToView(self.view).topSpaceToView(headlabel,0).heightIs(autoScaleH(45*2));
    
    _tijiaoBtn = [ButtonStyle buttonWithType:UIButtonTypeCustom];
    [_tijiaoBtn setTitle:@"完成" forState:UIControlStateNormal];
    [_tijiaoBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _tijiaoBtn .titleLabel.font =[UIFont systemFontOfSize:autoScaleW(15)];
    [_tijiaoBtn addTarget:self action:@selector(Tijiao) forControlEvents:UIControlEventTouchUpInside];
    _tijiaoBtn.layer.masksToBounds = YES;
    _tijiaoBtn.layer.cornerRadius = autoScaleW(5);
    [_tijiaoBtn setBackgroundColor:[UIColor lightGrayColor]];
    _tijiaoBtn.userInteractionEnabled = NO;
    [self.view addSubview:_tijiaoBtn];
    _tijiaoBtn.sd_layout.leftSpaceToView(self.view,autoScaleW(10)).rightSpaceToView(self.view,autoScaleW(10)).topSpaceToView(tixiantable,autoScaleH(20)).heightIs(autoScaleH(33));
    
    
    _fieldary = @[@"密码为6位数字",@"请再次输入您的密码",];
    _leftary =  @[@"提现密码",@"确认密码"];
    
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(Down)];
    [self.view addGestureRecognizer:tap];
    
    
//    NSLog(@"......%@%@",_namestr,_phonestr);

}
-(void)Down
{
    [self.view endEditing:YES];
    
    
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    LoginTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"fir"];
    if (!cell) {
        
        cell = [[LoginTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"fir"];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.leftlabel.text = _leftary[indexPath.row];
    cell.textfild.placeholder = _fieldary[indexPath.row];
    cell.textfild.secureTextEntry = YES;
    if (indexPath.row==0) {
        cell.textfild.delegate = self;
        cell.textfild.keyboardType = UIKeyboardTypeNumberPad;

        _firstfie = cell.textfild;


    }
    if (indexPath.row==1) {
        
        
        cell.textfild.keyboardType = UIKeyboardTypeNumberPad;
        
        _secfie = cell.textfild;
        
    }
    
    return cell;
}
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
//    NSLog(@"kk%lu",textField.text.length);
    if (textField.text.length==5) {
        _tijiaoBtn.userInteractionEnabled = YES;
        _tijiaoBtn.backgroundColor = UIColorFromRGB(0xfd7577);
        
    }
    if (textField.text.length<5||textField.text.length>5) {
        _tijiaoBtn.userInteractionEnabled = NO;
        _tijiaoBtn.backgroundColor = [UIColor lightGrayColor];
        
    }
    
    return YES;
    
}

-(void)leftBarButtonItemAction
{
    [self.navigationController popViewControllerAnimated:NO];
    
}
-(void)Tijiao
{
    
   
//    NSLog(@"%@",self.navigationController.viewControllers);
//    
//    
//    for (UIViewController *controller in self.navigationController.viewControllers) {
//        if ([controller isKindOfClass:[ErectViewController class]]) {
//            ErectViewController *revise =(ErectViewController *)controller;
//            [self.navigationController popToViewController:revise animated:YES];
//        }
//    }
    
    if (_firstfie.text!=nil&&_secfie.text!=nil)
    {
        if (_firstfie.text==_secfie.text) {
           NSString *token= TOKEN;
            NSString * idd = UserId;
            long iddd = [idd integerValue];

            [MBProgressHUD showMessage:@"请稍等"];
            NSString *uploadUrl = [NSString stringWithFormat:@"%@api/merchant/accountSet?token=%@&cardholder=%@&cardNo=%@&tixianPwd=%@&id=%ld",kBaseURL,token,_namestr,_phonestr,[ZTMd5Security MD5ForLower32Bate:_firstfie.text], iddd];
               
             [[QYXNetTool shareManager] postNetWithUrl:uploadUrl urlBody:nil bodyStyle:QYXBodyString header:nil response:QYXJSON success:^(id result) {
                [MBProgressHUD hideHUD];
                NSString * codestr = [result objectForKey:@"msgType"];
                if ([codestr integerValue]==0) {
                    [MBProgressHUD showSuccess:@"设置成功"];
                        for (UIViewController *controller in self.navigationController.viewControllers) {
    if ([controller isKindOfClass:[ErectViewController class]]) {
        ErectViewController *revise =(ErectViewController *)controller;
        [self.navigationController popToViewController:revise animated:YES];
    }
}//
                }
                
            } failure:^(NSError *error)
            {
                [MBProgressHUD hideHUD];
             
                
                
            }];
            
         }
        else
        {
            UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"密码不一致" preferredStyle:UIAlertControllerStyleAlert];
            __weak UIAlertAction * cancel = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:nil];
            
            [alert addAction:cancel];
            
            [self presentViewController:alert animated:YES completion:nil];

        }
        
    }
    else
    {
        
        UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"信息不能为空" preferredStyle:UIAlertControllerStyleAlert];
        __weak UIAlertAction * cancel = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:nil];
        
        [alert addAction:cancel];
        
        [self presentViewController:alert animated:YES completion:nil];
        
        
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
