//
//  FirsttixianViewController.m
//  微点筷客商户端
//
//  Created by 张森森 on 16/10/24.
//  Copyright © 2016年 张森森. All rights reserved.
//

#import "FirsttixianViewController.h"
#import "UIBarButtonItem+SSExtension.h"
#import "LoginTableViewCell.h"
#import "MimaViewController.h"
#import "ChangeBankViewController.h"
#import "NumberViewController.h"
@interface FirsttixianViewController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>
@property (nonatomic,strong)NSArray * leftary;
@property (nonatomic,strong)NSArray * fieldary;
@property (nonatomic,strong)ButtonStyle * tijiaoBtn;
@property (nonatomic,strong)UITextField * firstfie;
@property (nonatomic,strong)UITextField * secfie;
@end

@implementation FirsttixianViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.titleView.text = @"提现卡号";
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
    headlabell.text = @"为保障您的资金安全，请务必使用本人卡号";
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
    [_tijiaoBtn setTitle:@"第一步(1/2)" forState:UIControlStateNormal];
    [_tijiaoBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _tijiaoBtn .titleLabel.font =[UIFont systemFontOfSize:autoScaleW(15)];
    [_tijiaoBtn addTarget:self action:@selector(Tijiao) forControlEvents:UIControlEventTouchUpInside];
    _tijiaoBtn.layer.masksToBounds = YES;
    _tijiaoBtn.layer.cornerRadius = autoScaleW(5);
    _tijiaoBtn.userInteractionEnabled = NO;
    [_tijiaoBtn setBackgroundColor:[UIColor lightGrayColor]];
     
    [self.view addSubview:_tijiaoBtn];
    _tijiaoBtn.sd_layout.leftSpaceToView(self.view,autoScaleW(10)).rightSpaceToView(self.view,autoScaleW(10)).topSpaceToView(tixiantable,autoScaleH(20)).heightIs(autoScaleH(33));
    
    
    _fieldary = @[@"请输入您的姓名",@"请务必输入本人卡号",];
    _leftary =  @[@"持卡人",@"提现卡号"];
    
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(Down)];
    [self.view addGestureRecognizer:tap];
    
    
    
    
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
    
    if (indexPath.row==0) {
        
        _firstfie = cell.textfild;
    }
    if (indexPath.row==1) {
        
        cell.textfild.delegate = self;
       
        cell.textfild.keyboardType = UIKeyboardTypeNumberPad;
        _secfie = cell.textfild;
        
    }
    
    return cell;
}
-(void)leftBarButtonItemAction
{
    NSUInteger index = 0;
    for (UIViewController *controller in self.navigationController.viewControllers) {
        index++;
        if ([controller isKindOfClass:[NumberViewController class]]) {
            NumberViewController *revise =(NumberViewController *)controller;
            [self.navigationController popToViewController:revise animated:YES];
        } else {
            if (index == self.navigationController.viewControllers.count) {
//                [self.navigationController popViewControllerAnimated:YES];
                [SVProgressHUD showInfoWithStatus:@"请补全银行卡信息，此信息为必填项."];
            }
        }

    }
}
-(void)Tijiao
{
       
    if (_firstfie.text!=nil&&_secfie.text!=nil) {
            if (![_secfie.text bankCardluhmCheck]) {
                [SVProgressHUD showInfoWithStatus:@"请输入正确的体现卡号"];
                return;
            }
        NSString *message = NSLocalizedString(@"点击下一步后，修改卡号需联系客服，务必确认您的卡号无误", nil);
        NSString *cancelButtonTitle = NSLocalizedString(@"取消", nil);
        NSString *otherButtonTitle = NSLocalizedString(@"确定", nil);
        
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:message preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:cancelButtonTitle style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
            [alertController dismissViewControllerAnimated:YES completion:^{
                
                
                
            }];
        }];
        
        UIAlertAction *otherAction = [UIAlertAction actionWithTitle:otherButtonTitle style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            
            if (_pushinter==1) {
                MimaViewController * mimaview = [[MimaViewController alloc]init];
                mimaview.namestr = _firstfie.text;
                mimaview.phonestr = _secfie.text;
                
                [self.navigationController pushViewController:mimaview animated:YES];
            }
            if (_pushinter==2)
            {
                ChangeBankViewController * changebankview = [[ChangeBankViewController alloc]init];
                changebankview.namestr = _firstfie.text;
                changebankview.idcardstr = _secfie.text;
                changebankview.xianinteger = _xianshiint;
                [self.navigationController pushViewController:changebankview animated:YES];
                
            }

            
            }];

        
        [alertController addAction:cancelAction];
        [alertController addAction:otherAction];
        
        [self presentViewController:alertController animated:YES completion:nil];

    } else {
        
        UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"信息不能为空" preferredStyle:UIAlertControllerStyleAlert];
                __weak UIAlertAction * cancel = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:nil];
        
                [alert addAction:cancel];
        
                [self presentViewController:alert animated:YES completion:nil];
        
        
    }
    
    
    
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
//    NSLog(@"kk%lu",textField.text.length);
    if (textField.text.length>=15||textField.text.length<=19) {
        _tijiaoBtn.userInteractionEnabled = YES;
        _tijiaoBtn.backgroundColor = UIColorFromRGB(0xfd7577);
        
    }
    if (textField.text.length<15||textField.text.length>19) {
        _tijiaoBtn.userInteractionEnabled = NO;
        _tijiaoBtn.backgroundColor = [UIColor lightGrayColor];
        
    }
    
    return YES;
    
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
