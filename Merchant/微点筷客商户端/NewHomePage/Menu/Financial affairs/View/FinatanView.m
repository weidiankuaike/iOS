//
//  FinatanView.m
//  微点筷客商户端
//
//  Created by 张森森 on 16/11/16.
//  Copyright © 2016年 张森森. All rights reserved.
//

#import "FinatanView.h"
#import "MBProgressHUD+SS.h"
#import "Withdraw cashViewController.h"
#import "ZTAddOrSubAlertView.h"
#import "ChangeBankViewController.h"
#import "MBProgressHUD+SS.h"
#import "QYXNetTool.h"
@implementation FinatanView 
-(instancetype)initWithHave:(BOOL)have str:(NSString *)alipay
{
    self = [super init];
    if (self) {
        
        _isHave = have;
        _alipaystr = alipay;
        [self creattan];
    }
    
    return self;
}
-(void)creattan
{
    _isHave = NO;
    self.backgroundColor = RGBA(0, 0, 0, 0.3);
    
    _token = TOKEN;
    _userid = UserId;
    
   if (_isHave==NO) {
    
    NSArray * ary = @[@"取消",@"提现到银行卡(3-6日)",@"提现到支付宝(1-2日)", ];
    
    for (int i=0; i<3; i++) {
        
        ButtonStyle * querenBtn = [ButtonStyle buttonWithType:UIButtonTypeCustom];
        querenBtn.layer.masksToBounds = YES;
        querenBtn.tag = 200 +i;
        querenBtn.titleLabel.font = [UIFont systemFontOfSize:autoScaleW(18)];
        [querenBtn setTitle:ary[i] forState:UIControlStateNormal];
        [querenBtn setTitleColor:UIColorFromRGB(0xfd7577) forState:UIControlStateNormal];
        [querenBtn setBackgroundColor:[UIColor whiteColor]];
        querenBtn.layer.masksToBounds = YES;
        querenBtn.layer.cornerRadius =autoScaleW(3);
        [querenBtn addTarget:self action:@selector(dismiss:) forControlEvents:UIControlEventTouchUpInside];
        if (i==0) {
            _fbtn = querenBtn;
        }
        if (i==1) {
            _sbtn = querenBtn;
        }
        if (i==2) {
            _tbtn = querenBtn;
        }
        [self addSubview:querenBtn];
        if (i==0) {
            querenBtn.sd_layout.leftSpaceToView(self,autoScaleW(8)).bottomSpaceToView(self,autoScaleH(5)).widthIs(kScreenWidth-autoScaleW(16)).heightIs(autoScaleH(55));

        } else
        {
            querenBtn.sd_layout
            .leftSpaceToView(self,autoScaleW(8))
            .bottomSpaceToView(self,autoScaleH(75)+(i-1)*autoScaleH(55))
            .widthIs(kScreenWidth-autoScaleW(16))
            .heightIs(autoScaleH(55));
        }
        if (i==2) {
            UILabel * linelabel = [[UILabel alloc]init];
            linelabel.backgroundColor = [UIColor lightGrayColor];
            [querenBtn addSubview:linelabel];
            linelabel.sd_layout.leftEqualToView(querenBtn).rightEqualToView(querenBtn).bottomEqualToView(querenBtn).heightIs(1);
            
        }
    }
   }
    if (_isHave==YES)
    {
        
        _wanView = [[UIView alloc]init];
        _wanView.backgroundColor = [UIColor whiteColor];
        _wanView.layer.masksToBounds = YES;
        _wanView.layer.cornerRadius =autoScaleW(3);
        [self addSubview:_wanView];
        _wanView.sd_layout.centerXEqualToView(self).topSpaceToView(self,autoScaleH(280)).widthIs(autoScaleW(280)).heightIs(autoScaleH(140));
        
        ButtonStyle * chabtn = [ButtonStyle buttonWithType:UIButtonTypeCustom];
        [chabtn setBackgroundImage:[UIImage imageNamed:@"形状-1"] forState:UIControlStateNormal];
        [chabtn addTarget:self action:@selector(Xiaoshi) forControlEvents:UIControlEventTouchUpInside];
        [_wanView addSubview:chabtn];
        chabtn.sd_layout.rightSpaceToView(_wanView,autoScaleW(10)).topSpaceToView(_wanView,autoScaleH(5)).widthIs(autoScaleW(20)).heightIs(autoScaleH(20));
        
        NSArray * titlary = @[@"今天的提现权限已用完，",@"请次日再进行提现操作。"];
        for (int i=0; i<2; i++)
        {
            UILabel * titlabel = [[UILabel alloc]init];
            titlabel.text = titlary[i];
            titlabel.font = [UIFont systemFontOfSize:autoScaleW(15)];
            titlabel.textColor = [UIColor lightGrayColor];
            titlabel.textAlignment = NSTextAlignmentCenter;
            [_wanView addSubview:titlabel];
            titlabel.sd_layout.centerXEqualToView(_wanView).topSpaceToView(_wanView,autoScaleH(35)+i*autoScaleH(20)).widthIs(autoScaleW(180)).heightIs(autoScaleH(15));
            
        }
        ButtonStyle * querenbtn = [ButtonStyle buttonWithType:UIButtonTypeCustom];
        [querenbtn setTitle:@"确认" forState:UIControlStateNormal];
        [querenbtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        querenbtn.layer.masksToBounds = YES;
        querenbtn.layer.cornerRadius = autoScaleW(5);
        querenbtn.titleLabel.font = [UIFont systemFontOfSize:autoScaleW(15)];
        [querenbtn setBackgroundColor:RGB(142, 155, 170)];
        [querenbtn addTarget:self action:@selector(Remove) forControlEvents:UIControlEventTouchUpInside];
        
        [_wanView addSubview:querenbtn];
        querenbtn.sd_layout.centerXEqualToView(_wanView).topSpaceToView(_wanView,autoScaleH(85)).widthIs(_wanView.frame.size.width- autoScaleW(20)).heightIs(autoScaleH(30));
    }

}
-(void)getstring:(moneyblock)block
{
    self.block = block;
}
-(void)dismiss:(ButtonStyle *)btn

{
    [_fbtn removeFromSuperview];
    [_sbtn removeFromSuperview];
    [_tbtn removeFromSuperview];
    
    
    if (btn.tag==202)
    {

        
        if ([_alipaystr isNull]) {
            
            [self Creatalipay];
        }
        else
        {
            _ssinte = 1;
            [self Creatui];
        }
        
        
    }
    if (btn.tag==201)
        
    {
     
        _ssinte = 0;
        [self Creatui];
        
    }
    if (btn.tag==200) {
        
        [self removeFromSuperview];
        
        
    }
}
#pragma mark 支付宝未绑定
-(void)Creatalipay
{

    ZTAddOrSubAlertView * ztadd = [[ZTAddOrSubAlertView alloc]initWithStyle:ZTalertSheetStyleSubTitle];
    ztadd.titleLabel.text = @"您尚未绑定支付宝";
    ztadd.titleLabel.font = [UIFont systemFontOfSize:autoScaleW(11)];
    ztadd.littleLabel.text = @"是否绑定支付宝账号?";
    ztadd.littleLabel.font = [UIFont systemFontOfSize:autoScaleW(13)];
    [ztadd showView];
    ztadd.complete = ^(BOOL click)
    {
        if (click==YES)
        {
            self.block(@"push");
            
            
            [self removeFromSuperview];
            
            
            
        } else {

            [self removeFromSuperview];
        }
        
    };

}
-(void)Creatui
{
    _tishiview = [[UIView alloc]init];
    _tishiview.backgroundColor = [UIColor whiteColor];
    _tishiview.layer.masksToBounds = YES;
    _tishiview.layer.cornerRadius =autoScaleW(3);
    [self addSubview:_tishiview];
    _tishiview.sd_layout.centerXEqualToView(self).topSpaceToView(self,autoScaleH(250)).widthIs(autoScaleW(280)).heightIs(autoScaleH(160));
    
    
    _passwordView = [[LMPopInputPasswordView alloc]init];
    _passwordView.backgroundColor = [UIColor whiteColor];
    _passwordView.titleLabel.text = @"请输入提现密码：";
    _passwordView.frame = CGRectMake(autoScaleW(15), autoScaleH(15), _tishiview.width_sd-autoScaleW(30), autoScaleH(150));
    _passwordView.delegate = self;
    [_tishiview addSubview:_passwordView];
    
    ButtonStyle * chabtn = [ButtonStyle buttonWithType:UIButtonTypeCustom];
    [chabtn setBackgroundImage:[UIImage imageNamed:@"形状-1"] forState:UIControlStateNormal];
    [chabtn addTarget:self action:@selector(Quxiao) forControlEvents:UIControlEventTouchUpInside];
    [_tishiview addSubview:chabtn];
    chabtn.sd_layout.rightSpaceToView(_tishiview,autoScaleW(10)).topSpaceToView(_tishiview,autoScaleH(5)).widthIs(autoScaleW(20)).heightIs(autoScaleH(20));
    
    
    
}
-(void)Quxiao
{
    
    
    [self removeFromSuperview];
}
#pragma mark ---LMPopInputPassViewDelegate
-(void)buttonClickedAtIndex:(NSUInteger)index withText:(NSString *)text
{
    if(index==1){
        if(text.length==0){
//            NSLog(@"密码长度不正确");
        }else if(text.length<6){
//            NSLog(@"密码长度不正确");
        }else{
            
            [MBProgressHUD showMessage:@"请稍等"];
            NSString *loadUrl = [NSString stringWithFormat:@"%@api/merchant/editWithdrawPwd?token=%@&userId=%@&withdrawPwd=%@",kBaseURL,_token,_userid,[ZTMd5Security MD5ForLower32Bate:text]];
               
             [[QYXNetTool shareManager] postNetWithUrl:loadUrl urlBody:nil bodyStyle:QYXBodyString header:nil response:QYXJSON success:^(id result) {
                 [MBProgressHUD hideHUD];
                 if ([result[@"msgType"] isEqualToString:@"0"]) {
                     [_tishiview removeFromSuperview];
                     [self Moneyui];
                 } else {
                    [MBProgressHUD showError:@"密码错误，请重新输入！"];
                 }
             } failure:^(NSError *error)
             {
                 [MBProgressHUD hideHUD];
             }];
            
           
            
            
        }
    }
    
}


-(void)Moneyui
{
    
        _moneyview = [[UIView alloc]init];
        _moneyview.backgroundColor = [UIColor whiteColor];
        _moneyview.layer.masksToBounds = YES;
        _moneyview.layer.cornerRadius =autoScaleW(3);
        [self addSubview:_moneyview];
        _moneyview.sd_layout.centerXEqualToView(self).topSpaceToView(self,autoScaleH(250)).widthIs(autoScaleW(300)).heightIs(autoScaleH(160));
        
        UILabel * tishilabel = [[UILabel alloc]init];
        if (_ssinte==1) {
            tishilabel.text = @"提现到支付宝";
            
        }
        if (_ssinte==0) {
            tishilabel.text = @"提现到银行卡";
            
        }
        tishilabel.font = [UIFont systemFontOfSize:autoScaleW(15)];
        tishilabel.textColor = [UIColor blackColor];
        
        [_moneyview addSubview:tishilabel];
        tishilabel.sd_layout.centerXEqualToView(_moneyview).topSpaceToView(_moneyview,autoScaleH(5)).widthIs(autoScaleW(120)).heightIs(autoScaleH(20));
        
        ButtonStyle * chabtn = [ButtonStyle buttonWithType:UIButtonTypeCustom];
        [chabtn setTitle:@"取消" forState:UIControlStateNormal];
        chabtn.titleLabel.font = [UIFont systemFontOfSize:autoScaleW(15)];
        [chabtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        [chabtn addTarget:self action:@selector(Delet) forControlEvents:UIControlEventTouchUpInside];
        [_moneyview addSubview:chabtn];
        chabtn.sd_layout.leftSpaceToView(_moneyview,autoScaleW(10)).topSpaceToView(_moneyview,autoScaleH(5)).widthIs(autoScaleW(40)).heightIs(autoScaleH(20));
        
        _mimatext = [[UITextField alloc]init];
        _mimatext.layer.borderColor = [UIColor lightGrayColor].CGColor;
        _mimatext.layer.borderWidth = 1;
        _mimatext.keyboardType = UIKeyboardTypeDecimalPad;
        _mimatext.font = [UIFont systemFontOfSize:autoScaleW(15)];
        _mimatext.placeholder = @"请输入提现金额";
        _mimatext.textAlignment = NSTextAlignmentCenter;
        [_moneyview addSubview:_mimatext];
        _mimatext.sd_layout.leftSpaceToView(_moneyview ,autoScaleW(10)).topSpaceToView(tishilabel,autoScaleH(17)).widthIs(_moneyview.frame.size.width - autoScaleW(20)).heightIs(autoScaleH(35));
        UILabel * moneylabel = [[UILabel alloc]init];
        moneylabel.text= @"人民币/元";
        moneylabel.font = [UIFont systemFontOfSize:autoScaleW(13)];
        moneylabel.textColor = [UIColor lightGrayColor];
        [_mimatext addSubview:moneylabel];
        moneylabel.sd_layout.rightSpaceToView(_mimatext,autoScaleW(3)).topSpaceToView(_mimatext,autoScaleH(5)).widthIs(autoScaleW(60)).heightIs(autoScaleH(15));
        
        UILabel *timelabel =[[UILabel alloc]init];
        if (_ssinte==1) {
            
            timelabel.text = @"*每日可提现一次，1-2个工作日内到账";
        }
        if (_ssinte==2) {
            
            timelabel.text = @"*每日可提现一次，3-6个工作日内到账";
        }
        timelabel.font = [UIFont systemFontOfSize:autoScaleW(13)];
        timelabel.textColor = [UIColor lightGrayColor];
        [_moneyview addSubview:timelabel];
        timelabel.sd_layout.leftSpaceToView(_moneyview,autoScaleW(10)).topSpaceToView(_mimatext,autoScaleH(10)).widthIs(autoScaleW(300)).heightIs(autoScaleH(15));
        
        ButtonStyle * querenbtn = [ButtonStyle buttonWithType:UIButtonTypeCustom];
        [querenbtn setTitle:@"确认" forState:UIControlStateNormal];
        [querenbtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        querenbtn.layer.masksToBounds = YES;
        querenbtn.layer.cornerRadius = autoScaleW(5);
        querenbtn.titleLabel.font = [UIFont systemFontOfSize:autoScaleW(15)];
        [querenbtn setBackgroundColor:UIColorFromRGB(0xfd7577)];
        [querenbtn addTarget:self action:@selector(Queren) forControlEvents:UIControlEventTouchUpInside ];
        
        [_moneyview addSubview:querenbtn];
        querenbtn.sd_layout.centerXEqualToView(_moneyview).topSpaceToView(timelabel,autoScaleH(10)).widthIs(_tishiview.frame.size.width- autoScaleW(20)).heightIs(autoScaleH(30));
    
}
-(void)Delet
{
    
    [self removeFromSuperview];
    
    
}
-(void)Queren
{

    if ([_mimatext.text integerValue]>=100 && [_mimatext.text integerValue] <= [_balanceMoney integerValue]) {
                NSString * typestr= [NSString stringWithFormat:@"%ld",(long)_ssinte];
        [MBProgressHUD showMessage:@"请稍等"];
        NSString *uploadUrl = [NSString stringWithFormat:@"%@api/merchant/manualWithdraw?token=%@&userId=%@&transactionMoney=%@&cardType=%@",kBaseURL,_token,_userid,_mimatext.text,typestr];
           
         [[QYXNetTool shareManager] postNetWithUrl:uploadUrl urlBody:nil bodyStyle:QYXBodyString header:nil response:QYXJSON success:^(id result) {
             [MBProgressHUD hideHUD];
             
             if ([result[@"msgType"] integerValue] == 0) {
                 [self removeFromSuperview];
                 self.block (@"refresh");
             } else {
                 [MBProgressHUD showError:@"提现失败"];
             }
             
             
         } failure:^(NSError *error)
         {
             [MBProgressHUD hideHUD];

         }];

    } else {
        if ([_mimatext.text integerValue]<100) {
            [MBProgressHUD showError:@"最低提现金额：100"];
        } else {
            [MBProgressHUD showError:@"输入金额超出可用余额，请重新输入提现金额"];
        }

    }
}
-(void)Remove
{
    [self removeFromSuperview];
    
}
-(void)Xiaoshi
{
    
    [self removeFromSuperview];
    
    
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
