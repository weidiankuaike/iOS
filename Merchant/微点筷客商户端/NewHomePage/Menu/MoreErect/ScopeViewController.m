//
//  ScopeViewController.m
//  微点筷客商户端
//
//  Created by 张森森 on 16/10/27.
//  Copyright © 2016年 张森森. All rights reserved.
//

#import "ScopeViewController.h"
#import "UIBarButtonItem+SSExtension.h"
#import "MBProgressHUD+SS.h"
#import "QYXNetTool.h"
@interface ScopeViewController ()
@property (nonatomic,strong)UIView * bigview;
@property (nonatomic,strong)UIView * moneyview;
@property (nonatomic,strong)UITextField*mimatext;
@property (nonatomic,strong)UIView * upview;
@property (nonatomic,strong)NSMutableArray * fwbtnary;
@property (nonatomic,strong)UIView * bottomview;
@end

@implementation ScopeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.titleView.text = @"经营范围";
    self.view.backgroundColor = RGB(242, 242, 242);
    self.automaticallyAdjustsScrollViewInsets = NO;
    

    _fwbtnary = [NSMutableArray array];
   
    NSString * _token = TOKEN;

    [MBProgressHUD showMessage:@"请稍等"];
    NSString *uploadUrl = [NSString stringWithFormat:@"%@api/merchant/searchMerchantType?token=%@",kBaseURL,_token];
       
     [[QYXNetTool shareManager] postNetWithUrl:uploadUrl urlBody:nil bodyStyle:QYXBodyString header:nil response:QYXJSON success:^(id result) {
        [MBProgressHUD hideHUD];

        NSArray * dictary = [result objectForKey:@"obj"];
        if (dictary != nil) {
            
        for (int i =0; i<dictary.count; i++) {
            
            NSString * typestr = dictary[i][@"merchantType"];
            [_fwbtnary addObject:typestr];
            
        }
//        NSLog(@"ary = %@",_fwbtnary);
        
        [self Creatview];
        [self CreatBottomui];
        }
        
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUD];
        
    }];
    
//    NSLog(@"__%ld",_ztinteger);
    if (_ztinteger==1) {
        
         _btnary = [NSMutableArray array];
    }
    
}
-(void)leftBarButtonItemAction{
    [self Back];
}
-(void)Creatview
{
    CGFloat height = [[UIApplication sharedApplication] statusBarFrame].size.height + self.navigationController.navigationBar.frame.size.height;
    
        _upview = [[UIView alloc]init];
        _upview.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:_upview];
        _upview.sd_layout.leftEqualToView(self.view).rightEqualToView(self.view).topSpaceToView(self.view,height+autoScaleH(10)).heightIs(autoScaleH(200));
    
    
    
        
        UILabel * _firstlabel = [[UILabel alloc]init];
        _firstlabel.text = @"请选择经营品种";
        _firstlabel.font = [UIFont systemFontOfSize:autoScaleW(15)];
        _firstlabel.textColor = [UIColor blackColor];
        CGSize size = [_firstlabel.text sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:_firstlabel.font,NSFontAttributeName, nil]];
        CGFloat wind = size.width;
        [_upview addSubview:_firstlabel];
        _firstlabel.sd_layout.leftSpaceToView(_upview,autoScaleW(100)).topSpaceToView(_upview,autoScaleH(20)).heightIs(autoScaleH(20)).widthIs(wind);
    
    
        
        UILabel * _rightlabel = [[UILabel alloc]init];
        _rightlabel.text = @"(最多添加3个)";
        _rightlabel.textColor = [UIColor blackColor];
        _rightlabel.font = [UIFont systemFontOfSize:autoScaleW(13)];
        
        [_upview addSubview:_rightlabel];
        _rightlabel.sd_layout.leftSpaceToView(_firstlabel,autoScaleW(5)).topSpaceToView(_upview,autoScaleH(20)).heightIs(autoScaleH(20));
    

    
    
    

    
    
    
        ButtonStyle * addbtn = [[ButtonStyle alloc]init];
 		[addbtn setTitle:@"自定义添加+" forState:UIControlStateNormal];
        [addbtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        addbtn.backgroundColor = UIColorFromRGB(0xfd7577);
        addbtn.titleLabel.font = [UIFont systemFontOfSize:autoScaleW(13)];
        addbtn.layer.masksToBounds = YES;
        addbtn.layer.cornerRadius = autoScaleW(3);
        [addbtn addTarget:self action:@selector(Add) forControlEvents:UIControlEventTouchUpInside];
        [_upview addSubview:addbtn];
        addbtn.sd_layout.centerXEqualToView(_upview).topSpaceToView(_firstlabel,autoScaleH(20)).widthIs(kScreenWidth-autoScaleW(30)).heightIs(autoScaleH(30));
    if (_btnary.count == 3) {
        addbtn.hidden = YES;
    } else {
        addbtn.hidden = NO;
    }
    if (_btnary.count!=0) {
        
        for (int i= 0; i<_btnary.count; i++) {
            
            UILabel * querenbtn = [[UILabel alloc]init];
            querenbtn.text = _btnary[i];
            querenbtn.font = [UIFont systemFontOfSize:autoScaleW(15)];
            querenbtn.textColor = [UIColor whiteColor];
            querenbtn.textAlignment = NSTextAlignmentCenter;
            querenbtn.layer.masksToBounds = YES;
            querenbtn.layer.cornerRadius = autoScaleW(5);
            [querenbtn setBackgroundColor:RGB(142, 155, 170)];
            
            [_upview addSubview:querenbtn];
            querenbtn.sd_layout.leftSpaceToView(_upview,autoScaleW(15)+i*((kScreenWidth- autoScaleW(60))/3+autoScaleW(15))).topSpaceToView(addbtn,autoScaleH(25)).widthIs((kScreenWidth- autoScaleW(60))/3).heightIs(autoScaleH(30));
            querenbtn.userInteractionEnabled = YES;
            
            ButtonStyle * chabtn = [ButtonStyle buttonWithType:UIButtonTypeCustom];
            [chabtn setImage:[UIImage imageNamed:@"小红点"] forState:UIControlStateNormal];
            chabtn.titleLabel.font = [UIFont systemFontOfSize:autoScaleW(15)];
            [chabtn addTarget:self action:@selector(Delet:) forControlEvents:UIControlEventTouchUpInside];
            chabtn.tag = 200 + i;
            [querenbtn addSubview:chabtn];
            chabtn.sd_layout.topEqualToView(querenbtn).rightEqualToView(querenbtn).widthIs(autoScaleW(15)).heightIs(autoScaleH(15));
        }

    }
    
    
    
 }
-(void)CreatBottomui
{
    
    _bottomview = [[UIView alloc]init];
    _bottomview.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_bottomview];
    if (_fwbtnary.count%3==0) {
        
        _bottomview.sd_layout.leftEqualToView(self.view).rightEqualToView(self.view).topSpaceToView(_upview,autoScaleH(10)).heightIs(autoScaleH(50)+autoScaleH(45)*(_fwbtnary.count/3));
    }
    else
    {
        _bottomview.sd_layout.leftEqualToView(self.view).rightEqualToView(self.view).topSpaceToView(_upview,autoScaleH(10)).heightIs(autoScaleH(50)+autoScaleH(45)*(_fwbtnary.count/3+1));
    }
    
    UILabel * tishilabel = [[UILabel alloc]init];
    tishilabel.text = @"点击快速添加";
    tishilabel.font = [UIFont systemFontOfSize:autoScaleW(13)];
    tishilabel.textColor = [UIColor blackColor];
    [_bottomview addSubview:tishilabel];
    tishilabel.sd_layout.leftSpaceToView(_bottomview,autoScaleW(15)).topSpaceToView(_bottomview,autoScaleH(15)).widthIs(autoScaleW(150)).heightIs(autoScaleH(20));

    for (int i=0; i<_fwbtnary.count; i++)
    {
      
        ButtonStyle * querenbtn = [ButtonStyle buttonWithType:UIButtonTypeCustom];
        [querenbtn setTitle:_fwbtnary[i] forState:UIControlStateNormal];
        [querenbtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        querenbtn.layer.masksToBounds = YES;
        querenbtn.layer.cornerRadius = autoScaleW(5);
        querenbtn.titleLabel.font = [UIFont systemFontOfSize:autoScaleW(15)];
        [querenbtn setBackgroundColor:RGB(142, 155, 170)];
        
        querenbtn.tag = 300 + i;
        [querenbtn addTarget:self action:@selector(Click:) forControlEvents:UIControlEventTouchUpInside ];
        
        [_bottomview addSubview:querenbtn];
        querenbtn.sd_layout.leftSpaceToView(_bottomview,autoScaleW(15)+i%3*(((kScreenWidth-autoScaleW(60))/3)+autoScaleW(15))).topSpaceToView(tishilabel,autoScaleH(15)+i/3*autoScaleH(45)).widthIs((kScreenWidth- autoScaleW(60))/3).heightIs(autoScaleH(30));
        
      }
    
    UIButton * finishBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [finishBtn setTitle:@"完成" forState:UIControlStateNormal];
    finishBtn.titleLabel.font = [UIFont systemFontOfSize:autoScaleW(15)];
    [finishBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    finishBtn.backgroundColor = UIColorFromRGB(0xfd7577);
    [finishBtn addTarget:self action:@selector(scopeFinish) forControlEvents:UIControlEventTouchUpInside];
    finishBtn.layer.masksToBounds = YES;
    finishBtn.layer.cornerRadius = 3;
    [self.view addSubview:finishBtn];
    finishBtn.sd_layout.leftSpaceToView(self.view,autoScaleW(10)).rightSpaceToView(self.view,autoScaleW(10)).bottomSpaceToView(self.view,autoScaleH(20)).heightIs(autoScaleH(33));

    
}
#pragma mark 快速添加按钮
-(void)Click:(ButtonStyle *)btn
{
    if (_btnary.count<=2) {
        
        
        [_fwbtnary removeObjectAtIndex:btn.tag-300];
        [_btnary addObject:btn.titleLabel.text];
        for (UIView *view in _bottomview.subviews) {
            [view removeFromSuperview];
        }
        
        [self CreatBottomui];
        [self Creatview];
        
    }
    
    
}
#pragma mark 删除按钮
-(void)Delet:(ButtonStyle *)btn
{
    [_btnary enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        if (obj  == [_btnary objectAtIndex:btn.tag-200]) {
            
            *stop = YES;
            if (*stop==YES) {
                
                [_btnary removeObject:obj];
                [_fwbtnary addObject:obj];
            }
        }
    }];
    
    for (UIView *view in _upview.subviews) {
        [view removeFromSuperview];
    }

    [self Creatview];
    [self CreatBottomui];
    
}

#pragma mark 添加按钮方法
-(void)Add
{
    [self CreatScopeui];
}
#pragma mark 弹出窗
-(void)CreatScopeui
{
    CGFloat height = [[UIApplication sharedApplication] statusBarFrame].size.height + self.navigationController.navigationBar.frame.size.height;
    _bigview = [[UIView alloc]init];
    _bigview.backgroundColor = RGBA(0, 0, 0, 0.3);
    _bigview.frame = CGRectMake(0, 1000, kScreenWidth, kScreenHeight+height);
    [self.navigationController.view addSubview:_bigview];
    
    UITapGestureRecognizer * tap2 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(Remove)];
    [_bigview addGestureRecognizer:tap2];
    
    
    
    _moneyview = [[UIView alloc]init];
    _moneyview.backgroundColor = [UIColor whiteColor];
    _moneyview.layer.masksToBounds = YES;
    _moneyview.layer.cornerRadius =autoScaleW(3);
    [_bigview addSubview:_moneyview];
    _moneyview.sd_layout.centerXEqualToView(_bigview).bottomSpaceToView(_bigview,0).widthIs(kScreenWidth).heightIs(autoScaleH(260));
    
    UILabel * tishilabel = [[UILabel alloc]init];
    tishilabel.text = @"请输入要添加的经营范围";
    tishilabel.textAlignment =NSTextAlignmentCenter;
    tishilabel.font = [UIFont systemFontOfSize:autoScaleW(15)];
    tishilabel.textColor = [UIColor blackColor];
    
    [_moneyview addSubview:tishilabel];
    tishilabel.sd_layout.centerXEqualToView(_moneyview).topSpaceToView(_moneyview,autoScaleH(5)).widthIs(kScreenWidth-autoScaleW(30)).heightIs(autoScaleH(20));
    
    ButtonStyle * chabtn = [ButtonStyle buttonWithType:UIButtonTypeCustom];
    [chabtn setTitle:@"取消" forState:UIControlStateNormal];
    chabtn.titleLabel.font = [UIFont systemFontOfSize:autoScaleW(13)];
    [chabtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [chabtn addTarget:self action:@selector(Delet) forControlEvents:UIControlEventTouchUpInside];
    [_moneyview addSubview:chabtn];
    chabtn.sd_layout.leftSpaceToView(_moneyview,autoScaleW(15)).topSpaceToView(_moneyview,autoScaleH(5)).widthIs(autoScaleW(30)).heightIs(autoScaleH(20));
    
    _mimatext = [[UITextField alloc]init];
    _mimatext.layer.borderColor = [UIColor lightGrayColor].CGColor;
    _mimatext.layer.borderWidth = 1;
    _mimatext.layer.masksToBounds = YES;
    _mimatext.layer.cornerRadius = autoScaleW(3);
    _mimatext.textAlignment = NSTextAlignmentCenter;
    _mimatext.keyboardType = UIKeyboardTypeDefault;
    _mimatext.font = [UIFont systemFontOfSize:autoScaleW(13)];
    [_moneyview addSubview:_mimatext];
    _mimatext.sd_layout.leftSpaceToView(_moneyview ,autoScaleW(15)).topSpaceToView(tishilabel,autoScaleH(27)).widthIs(_moneyview.frame.size.width - autoScaleW(30)).heightIs(autoScaleH(35));
    
    
    ButtonStyle * querenbtn = [ButtonStyle buttonWithType:UIButtonTypeCustom];
    [querenbtn setTitle:@"确定" forState:UIControlStateNormal];
    [querenbtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    querenbtn.layer.masksToBounds = YES;
    querenbtn.layer.cornerRadius = autoScaleW(5);
    querenbtn.titleLabel.font = [UIFont systemFontOfSize:autoScaleW(15)];
    [querenbtn setBackgroundColor:UIColorFromRGB(0xfd7577)];
    
    [querenbtn addTarget:self action:@selector(Queren:) forControlEvents:UIControlEventTouchUpInside ];
    
    [_moneyview addSubview:querenbtn];
    querenbtn.sd_layout.leftSpaceToView(_moneyview,autoScaleW(15)).topSpaceToView(_mimatext,autoScaleH(30)).widthIs((_moneyview.frame.size.width- autoScaleW(30))).heightIs(autoScaleH(40));
    

    [UIView animateWithDuration:0.3 animations:^{
        
        _bigview.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight+height);
       
    } completion:^(BOOL finished) {
        
        
    }];

    
    
}
#pragma mark 弹窗取消按钮
-(void)Delet
{
    [_bigview removeFromSuperview];
}
#pragma mark 弹出窗确认按钮
-(void)Queren:(ButtonStyle *)btn
{
    if ([_mimatext.text isEqualToString:@""]) {
        
        
        [MBProgressHUD showError:@"请输入范围"];
        
    }
    else
    {
        if (_btnary.count<3) {
            
            [_btnary addObject:_mimatext.text];
            [self Creatview];
        }
        
        [_bigview removeFromSuperview];
    }
    self.navigationController.navigationBar.hidden = NO;
    
    
    
}
#pragma mark 弹出窗取消按钮
-(void)Remove
{
    [self.view endEditing:YES];
    
}




-(void)getstring:(sblock)block
{
    self.block = block;
}
//完成
- (void)scopeFinish{
    
    [self Back];
}
-(void)Back
{
    [self.navigationController popViewControllerAnimated:YES];
    if (_btnary !=nil) {
        NSString * zstr = [_btnary componentsJoinedByString:@","];
        self.block(zstr);
        
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
