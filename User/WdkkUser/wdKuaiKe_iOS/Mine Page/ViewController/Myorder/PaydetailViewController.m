//
//  PaydetailViewController.m
//  wdKuaiKe_iOS
//
//  Created by 张森森 on 17/5/17.
//  Copyright © 2017年 weiDianKuaiKe. All rights reserved.
//

#import "PaydetailViewController.h"
#import "UIBarButtonItem+SSExtension.h"
#import "MBProgressHUD+SS.h"
#import "QYXNetTool.h"
#import "CanuserTicketViewController.h"
#import "PayViewController.h"
#import "ZTAddOrSubAlertView.h"
@interface PaydetailViewController ()
{
    NSArray * dishAry;
}
@property (nonatomic,strong)NSDictionary * objDict;
@property (nonatomic,strong)UITextView * feedbackview;//备注
@property (nonatomic,strong)UILabel * pllabel;
@property (nonatomic,strong)UIButton * tbtn;
@property (nonatomic,assign)NSInteger couint;//是否有优惠券 0 没 1 有
@property (nonatomic,assign)NSInteger storeAc;//店铺是否有活动
@property (nonatomic,strong)NSMutableArray * btnAry;
@property (nonatomic,copy)NSString * actId;//优惠券 ，活动id
@property (nonatomic,strong)NSMutableArray * imageAry;
@end

@implementation PaydetailViewController
- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    self.tabBarController.tabBar.hidden = YES;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = RGB(238, 238, 238);
    UILabel * titlabel = [[UILabel alloc]init];
    titlabel.frame = CGRectMake(0, 0, 80, 30);
    titlabel.font = [UIFont systemFontOfSize:15];
    titlabel.text = @"提交订单";
    titlabel.textColor = [UIColor whiteColor];
    self.navigationItem.titleView = titlabel;
    
    UIBarButtonItem * btn = [UIBarButtonItem itemWithTarget:self Action:@selector(Back) image:@"left-1" selectImage:nil];
    self.navigationItem.leftBarButtonItem = btn;
    _couint = 0;
    _storeAc = 0;
    _actId = @"";
    
    [self getData];
    
}

- (void)getData{
    
    NSString * feestr = [NSString stringWithFormat:@"%.2f",_sum];
    [MBProgressHUD showMessage:@"请稍等"];
    NSString * url = [NSString stringWithFormat:@"%@/api/order/orderPayData?token=%@&orderId=%@&storeId=%@&totalFee=%@",commonUrl,Token,_orderId,_storeId,feestr];
    
    NSArray * urlary = [url componentsSeparatedByString:@"?"];
    
    [[QYXNetTool shareManager]postNetWithUrl:urlary.firstObject urlBody:urlary.lastObject bodyStyle:QYXBodyString header:nil response:QYXJSON success:^(id result) {
        [MBProgressHUD hideHUD];
        NSLog(@"<><>><><>%@",result);
        
        NSString * msgtype = [NSString stringWithFormat:@"%@",result[@"msgType"]];
        if ([msgtype isEqualToString:@"0"]) {
            
            _objDict = result[@"obj"];
            dishAry = _objDict[@"orderDets"];
            [self CreatScrollview];
            
        }
        
        
    } failure:^(NSError *error) {
        
        [MBProgressHUD hideHUD];
        [MBProgressHUD showError:@"网络错误"];
    }];
    
    
}

- (void)CreatScrollview{
    
    UIScrollView * payDetailScroll = [[UIScrollView alloc]init];
    payDetailScroll.contentSize = CGSizeMake(GetWidth, autoScaleW(70)+autoScaleH(40)*2+autoScaleH(70)+_dishesAry.count*autoScaleH(20)+autoScaleH(40)*2+autoScaleH(120)+autoScaleH(50));
    payDetailScroll.frame = self.view.bounds;
    [self.view addSubview:payDetailScroll];

    
    NSString * namestr = [NSString stringWithFormat:@"用户名：%@",_objDict[@"orderName"]];
    
    UIView * xinxiLabel = [[UIView alloc]init];
    xinxiLabel.backgroundColor = [UIColor whiteColor];
    [payDetailScroll addSubview:xinxiLabel];
    xinxiLabel.sd_layout.leftEqualToView(payDetailScroll).rightEqualToView(payDetailScroll).topSpaceToView(payDetailScroll,autoScaleH(10)).heightIs(autoScaleH(40));

    UILabel * orderidLabel = [[UILabel alloc]init];
    orderidLabel.text = namestr;
    orderidLabel.font = [UIFont systemFontOfSize:15];
    orderidLabel.textColor = [UIColor blackColor];
    [xinxiLabel addSubview:orderidLabel];
    orderidLabel.sd_layout.leftSpaceToView(xinxiLabel,autoScaleW(15)).topSpaceToView(xinxiLabel,autoScaleH(10)).heightIs(autoScaleH(20)).widthIs(GetWidth - autoScaleW(30));
    
//    for (int i =0; i<2; i++) {
//        UIView * xinxiLabel = [[UIView alloc]init];
//        xinxiLabel.backgroundColor = [UIColor whiteColor];
//        xinxiLabel.tag = 3000+i;
//        [payDetailScroll addSubview:xinxiLabel];
//        xinxiLabel.sd_layout.leftEqualToView(payDetailScroll).rightEqualToView(payDetailScroll).topSpaceToView(payDetailScroll,autoScaleH(10)+i*autoScaleH(40)).heightIs(autoScaleH(40));
//        
//        UILabel * linelabel = [[UILabel alloc]init];
//        linelabel.backgroundColor = UIColorFromRGB(0xeeeeee);
//        [xinxiLabel addSubview:linelabel];
//        linelabel.sd_layout.leftEqualToView(xinxiLabel).rightEqualToView(xinxiLabel).bottomEqualToView(xinxiLabel).heightIs(1);
//        
//       
//        
//    }

//    UIView * orderidLabel = (UIView*)[payDetailScroll viewWithTag:3001];
    
    //菜品信息
    if (_dishesAry.count!=0) {
        
        
        UIView * dishView = [[UIView alloc]init];
        dishView.backgroundColor = [UIColor whiteColor];
        [payDetailScroll addSubview:dishView];
       dishView.sd_layout.leftEqualToView(payDetailScroll).rightEqualToView(payDetailScroll).topSpaceToView(xinxiLabel,autoScaleH(10)).heightIs(autoScaleH(70)+_dishesAry.count*autoScaleH(20));
        
        
        UILabel * lianxilabel = [[UILabel alloc]init];
        lianxilabel.text = @"菜品信息:";
        lianxilabel.textColor = [UIColor blackColor];
        lianxilabel.font  = [UIFont systemFontOfSize:autoScaleW(13)];
        [dishView addSubview:lianxilabel];
        lianxilabel.sd_layout.leftSpaceToView(dishView,autoScaleW(15)).topSpaceToView(dishView,autoScaleH(10)).widthIs(autoScaleW(128)).heightIs(autoScaleH(15));
        
        UILabel * linelabel = [[UILabel alloc]init];
        linelabel.backgroundColor = RGB(228, 228, 228);
        [dishView addSubview:linelabel];
        linelabel.sd_layout.leftSpaceToView(dishView,autoScaleW(15)).rightSpaceToView(dishView,autoScaleW(15)).topSpaceToView(lianxilabel,autoScaleH(5)).heightIs(autoScaleH(1));
            for (int i=0; i<_dishesAry.count; i++)
            {
                
                UILabel * caidanlabel = [[UILabel alloc]init];
                [dishView addSubview:caidanlabel];
                caidanlabel.sd_layout.leftSpaceToView(dishView,autoScaleW(15)).topSpaceToView(linelabel,autoScaleH(5)+i*autoScaleH(20)).widthIs(GetWidth-autoScaleW(30)).heightIs(15);
                
                UILabel * namelabel = [[UILabel alloc]init];
                namelabel.text = _dishesAry[i][@"name"];
                namelabel.font = [UIFont systemFontOfSize:autoScaleW(13)];
                namelabel.textColor = [UIColor lightGrayColor];
                [caidanlabel addSubview:namelabel];
                namelabel.sd_layout.leftSpaceToView(caidanlabel,autoScaleW(28)).topSpaceToView(caidanlabel,0).widthIs(GetWidth/2-autoScaleW(30)).heightIs(autoScaleH(15));
                
                UILabel * sllabel = [[UILabel alloc]init];
                sllabel.text = [NSString stringWithFormat:@"%@份",_dishesAry[i][@"number"]];
                sllabel.font = [UIFont systemFontOfSize:autoScaleW(13)];
                [caidanlabel addSubview:sllabel];
                sllabel.sd_layout.leftSpaceToView(namelabel,autoScaleW(20)).topSpaceToView(caidanlabel,0).widthIs(autoScaleW(30)).heightIs(autoScaleH(15));
                
                UILabel * moneylabel = [[UILabel alloc]init];
                moneylabel.text = [NSString stringWithFormat:@"￥%@",_dishesAry[i][@"fee"]];
                moneylabel.font = [UIFont systemFontOfSize:autoScaleW(13)];
                [caidanlabel addSubview:moneylabel];
                moneylabel.sd_layout.rightSpaceToView(caidanlabel,autoScaleW(28)).topSpaceToView(caidanlabel,0).widthIs(autoScaleW(50)).heightIs(autoScaleH(15));
                
            }
            
            UILabel * slinelabel = [[UILabel alloc]init];
            slinelabel.backgroundColor = RGB(228, 228, 228);
            [dishView addSubview:slinelabel];
            slinelabel.sd_layout.leftSpaceToView(dishView,autoScaleW(15)).rightSpaceToView(dishView,autoScaleW(15)).topSpaceToView(linelabel,autoScaleH(20)*_dishesAry.count+autoScaleH(10)).heightIs(autoScaleH(1));
            
            UILabel * zonglabel = [[UILabel alloc]init];
            zonglabel.text = [NSString stringWithFormat:@"共计￥%.2f",_sum];
            zonglabel.textColor = [UIColor blackColor];
            zonglabel.textAlignment = NSTextAlignmentRight;
            [dishView addSubview:zonglabel];
            zonglabel.sd_layout.rightSpaceToView(dishView,autoScaleW(15)).topSpaceToView(slinelabel,0).widthIs(autoScaleW(200)).heightIs(autoScaleH(20));
            
    }
    
    
    NSDictionary * aclistdict = _objDict[@"acList"];//优惠券和活动 二选一
    __weak NSString * coupon = nil;
    __weak NSString * activity = nil;
    if (![aclistdict[@"coupon"] isKindOfClass:[NSArray class]]) {
        
        coupon = @"您没有可使用的优惠券";
        
        
    }else{
        
        coupon = @"可选择一张优惠券";
        _couint = 1;
    }
    
    
    if ([aclistdict[@"storeActivity"]isKindOfClass:[NSDictionary class]]) {
        
        activity = aclistdict[@"storeActivity"][@"cardTitle"];
        _storeAc = 1;
    }else{
        
        activity = @"优惠活动不可用";
    }

    NSArray * btnTitleary = @[coupon,activity];
    _btnAry = [NSMutableArray array];
    _imageAry = [NSMutableArray array];
    for (int i =0; i<2; i++) {
        
        UIButton * preferentialBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [preferentialBtn setBackgroundColor: [UIColor whiteColor]];
        [preferentialBtn addTarget:self action:@selector(Chooseyh:) forControlEvents:UIControlEventTouchUpInside];
        [preferentialBtn setTitle:btnTitleary[i] forState:UIControlStateNormal];
        [preferentialBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        preferentialBtn.titleLabel.font = [UIFont systemFontOfSize:autoScaleW(15)];
        
        preferentialBtn.tag = 5000+i;
        
//        if ([aclistdict[@"firstSelect"] integerValue]<2) {
//            
//            if (i==[aclistdict[@"firstSelect"] integerValue]) {
//                preferentialBtn.selected = YES;
//                _tbtn = preferentialBtn;
//            }
//            
//        }
//        else{
//            preferentialBtn.userInteractionEnabled = NO;
//        }
//        
        [payDetailScroll addSubview:preferentialBtn];
        preferentialBtn.sd_layout.leftSpaceToView(payDetailScroll,0).rightEqualToView(payDetailScroll).topSpaceToView(xinxiLabel,autoScaleH(70)+_dishesAry.count*autoScaleH(20)+autoScaleH(20)+i*autoScaleH(40)).heightIs(autoScaleH(40));
        
        UILabel * linelabel = [[UILabel alloc]init];
        linelabel.backgroundColor = UIColorFromRGB(0xeeeeee);
        [preferentialBtn addSubview:linelabel];
        linelabel.sd_layout.leftEqualToView(preferentialBtn).rightEqualToView(preferentialBtn).bottomEqualToView(preferentialBtn).heightIs(1);
        
        if (i==0) {
            UIButton * rightimage = [[UIButton alloc]init];
           
//                rightimage.image = [UIImage imageNamed:@"形状-1-拷贝"];
            [rightimage setBackgroundImage:[UIImage imageNamed:@"形状-1-拷贝"] forState:UIControlStateNormal];
          
            [preferentialBtn addSubview:rightimage];
            rightimage.sd_layout.rightSpaceToView(preferentialBtn,kWidth(15)).topSpaceToView(preferentialBtn,kHeight(15)).widthIs(kWidth(8)).heightIs(kHeight(11));
            
        }
        
        UIImageView * chooseimage = [[UIImageView alloc]init];
        if (i==[aclistdict[@"firstSelect"] integerValue]) {
            
            chooseimage.image = [UIImage imageNamed:@"单选按钮_选中"];
            [self Chooseyh:preferentialBtn];

        }
       else{
            chooseimage.image = [UIImage imageNamed:@"单选按钮_选中-拷贝"];
            
        }

        chooseimage.tag = 8000 +i;
        [preferentialBtn addSubview:chooseimage];
        chooseimage.sd_layout.leftSpaceToView(preferentialBtn,autoScaleW(15)).topSpaceToView(preferentialBtn,autoScaleH(10)).widthIs(autoScaleW(20)).heightIs(autoScaleW(20));
        [_imageAry addObject:chooseimage];
        [_btnAry addObject:preferentialBtn];
    }
    
    UIButton * chooseBtn = (UIButton*)[payDetailScroll viewWithTag:5001];
    //备注
    UIView * remarksview = [[UIView alloc]init];
    remarksview.backgroundColor = [UIColor whiteColor];
    [payDetailScroll addSubview:remarksview];
    remarksview.sd_layout.leftEqualToView(payDetailScroll).rightEqualToView(payDetailScroll).topSpaceToView(chooseBtn,autoScaleH(10)).heightIs(autoScaleH(120) );
    
    UILabel * remarklabel = [[UILabel alloc]init];
    remarklabel.textColor = [UIColor blackColor];
    remarklabel.font = [UIFont systemFontOfSize:autoScaleW(13)];
    remarklabel.text = @"备注信息:";
    [remarksview addSubview:remarklabel];
    remarklabel.sd_layout.leftSpaceToView(remarksview,autoScaleW(15)).topSpaceToView(remarksview,autoScaleH(5)).widthIs(autoScaleW(60)).heightIs(autoScaleH(15));
    
    _feedbackview = [[UITextView alloc]init];
    _feedbackview.font = [UIFont systemFontOfSize:autoScaleW(13)];
    _feedbackview.delegate = self;
    _feedbackview.backgroundColor = RGB(238, 238, 238);
    [remarksview addSubview:_feedbackview];
    _feedbackview.sd_layout.leftSpaceToView(remarksview,autoScaleW(15)).rightSpaceToView(remarksview,autoScaleW(15)).topSpaceToView(remarklabel,autoScaleH(10)).heightIs(autoScaleH(70));

    
    _pllabel = [[UILabel alloc]init];
    _pllabel.enabled = NO;
    _pllabel.text = @"点此填写备注信息";
    _pllabel.font =[UIFont systemFontOfSize:autoScaleW(13)];
    _pllabel.backgroundColor = [UIColor clearColor];
    CGSize size = [_pllabel.text sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:_pllabel.font,NSFontAttributeName, nil]];
    CGFloat wind = size.width;
    [_feedbackview addSubview:_pllabel];
    _pllabel.sd_layout.centerXEqualToView(_feedbackview).centerYEqualToView(_feedbackview).widthIs(wind).heightIs(autoScaleH(15));

    UIButton * submitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [submitBtn setTitle:@"提交订单" forState:UIControlStateNormal];
    submitBtn.titleLabel.font = [UIFont systemFontOfSize:autoScaleW(15)];
    [submitBtn setBackgroundColor:UIColorFromRGB(0xfd7577)];
    submitBtn.layer.masksToBounds = YES;
    submitBtn.layer.cornerRadius = 3;
    [submitBtn addTarget:self action:@selector(Submit) forControlEvents:UIControlEventTouchUpInside];
    [payDetailScroll addSubview:submitBtn];
    submitBtn.sd_layout.leftSpaceToView(payDetailScroll,autoScaleW(10)).rightSpaceToView(payDetailScroll,autoScaleW(10)).topSpaceToView(remarksview,autoScaleH(30)).heightIs(autoScaleH(40));
    
}
- (void)Chooseyh:(UIButton*)btn{
    
    if (btn.tag-5000==0) {
        
        if (_couint==1) {//有优惠券可用
            
            for (UIImageView * imageview in _imageAry) {
                if (imageview.tag - 8000 == btn.tag - 5000) {
                    
                        imageview.image = [UIImage imageNamed:@"单选按钮_选中"];
                    
                    CanuserTicketViewController * canuserview = [[CanuserTicketViewController alloc]init];
                    canuserview.listary = _objDict[@"acList"][@"coupon"];
                    canuserview.blck = ^(NSString * namestr,NSString * moneystr,NSString * idstr)
                    {
                        [btn setTitle:[NSString stringWithFormat:@"%@:%@",namestr,moneystr] forState:UIControlStateNormal];
                        _actId = [NSString stringWithFormat:@"%@",idstr];
                    };
                    
                    
                    [self.navigationController pushViewController:canuserview animated:YES];
                    
                }else{
                    
                    imageview.image = [UIImage imageNamed:@"单选按钮_选中-拷贝"];

                    
                }
                
            }
        }
        
        
    }else if (btn.tag - 5000==1){
        
        
        if (_storeAc ==1) {
            
            for (UIImageView * imageview in _imageAry) {
                
                if (imageview.tag - 8000 == btn.tag - 5000) {
                    
                        imageview.image = [UIImage imageNamed:@"单选按钮_选中"];
                
                }else{
                    
                        imageview.image = [UIImage imageNamed:@"单选按钮_选中-拷贝"];
                   
                }
            }
            
                _actId = [NSString stringWithFormat:@"%@",_objDict[@"acList"][@"storeActivity"][@"id"]];
        }
        
    }
    
}
#pragma mark 判断提示词的消失
-(void)textViewDidChange:(UITextView *)textView
{
    if (textView.text.length ==0) {
        
        _pllabel.text = @"点此填写备注信息";
    }
    else
    {
        _pllabel.text = @"";
    }
}
- (void)Back{
    
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark 提交订单
- (void)Submit{
    
    if ([_objDict[@"acList"][@"firstSelect"] integerValue]<2&&[_actId isEqualToString:@""]) {
        ZTAddOrSubAlertView * subalert = [[ZTAddOrSubAlertView alloc]initWithStyle:ZTalertSheetStyleTitle];
        subalert.titleLabel.text = @"您未选择优惠，是否提交";
        subalert.complete = ^(BOOL choose){
            if (choose==YES) {
                
                [self SubmitData];
                
            }
        };

        
        
    }else{
        [self SubmitData];
    }
}
- (void)SubmitData{
    
    
    if (_dishesAry.count!=0) {
        
        NSMutableArray * idary = [NSMutableArray array];
        NSMutableArray * numary = [NSMutableArray array];
        
        for (int i=0; i<_dishesAry.count; i++) {
            
            NSMutableDictionary * dict = _dishesAry[i];
            NSString * idstr = dict[@"id"];
            NSString * numstr = dict[@"number"];
            
            [idary addObject:idstr];
            [numary addObject:numstr];
            
        }
        
        NSString * upidstr = [idary componentsJoinedByString:@","];//上传的菜品id
        NSString * upnumstr = [numary componentsJoinedByString:@","];
        NSString * numstr = [NSString stringWithFormat:@"%@,",upnumstr];//数量
       
        NSString * urlstr = [NSString stringWithFormat:@"%@/api/user/addExtraFood?token=%@&orderId=%@&productIds=%@&productNums=%@&actId=%@&remark=%@",commonUrl,Token,_orderId,upidstr,numstr,_actId,_feedbackview.text];
        NSArray * urlary= [urlstr componentsSeparatedByString:@"?"];
        
        [MBProgressHUD showMessage:@"请稍等"];
        [[QYXNetTool shareManager]postNetWithUrl:urlary.firstObject urlBody:urlary.lastObject bodyStyle:QYXBodyString header:nil response:QYXJSON success:^(id result) {
            [MBProgressHUD hideHUD];
            NSString * msgtype = [NSString stringWithFormat:@"%@",result[@"msgType"]];
            if ([msgtype isEqualToString:@"0"]) {
                
                NSDictionary * objdict = result[@"obj"];
                NSString * orderstr = [NSString stringWithFormat:@"%@",objdict[@"orderId"]];
                PayViewController * payview = [[PayViewController alloc]init];
                payview.orderid = orderstr;
                payview.storeid = _storeId;
                payview.actId = _actId;
                payview.pushint = 1;
                [self.navigationController pushViewController:payview animated:YES];
                
            }else
            {
                [MBProgressHUD showError:@"请求失败，加菜失败"];
            }
            
        } failure:^(NSError *error) {
            [MBProgressHUD hideHUD];
            [MBProgressHUD showError:@"网络参数错误"];
        }];
        
    }

}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
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
