//
//  SystemViewController.m
//  微点筷客商户端
//
//  Created by 张森森 on 16/10/28.
//  Copyright © 2016年 张森森. All rights reserved.
//

#import "SystemViewController.h"
#import "UIBarButtonItem+SSExtension.h"
#import "LoginTableViewCell.h"
#import "MBProgressHUD+SS.h"
#import "QYXNetTool.h"
#import "NSObject+JudgeNull.h"
typedef void(^complete)(BOOL success);
@interface SystemViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong)UITableView * erecttableview;
@property (nonatomic,strong)NSArray * fourary;
@property (nonatomic,strong)UISwitch * mySwitth;
@property (nonatomic,copy)NSString * iddd;
@property (nonatomic,strong) NSString * token;
@end

@implementation SystemViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.titleView.text = @"功能设置";
    self.view.backgroundColor = RGB(242, 242, 242);
    self.automaticallyAdjustsScrollViewInsets = NO;




    CGFloat height = [[UIApplication sharedApplication] statusBarFrame].size.height + self.navigationController.navigationBar.frame.size.height;


    _fourary = @[@"接受用餐预定",@"接受排队领号",@"开启现场服务管理",@"开启排队管理", @"到店是否自动接单", @"预订是否开启自动接单"];

    //    NSString * idd = UserId;
    //    _iddd = [idd integerValue];

    _functionCategoryArr = [NSMutableArray array];
    _token = TOKEN;
    _iddd = UserId;
    [MBProgressHUD showMessage:@"请稍等"];
    NSString *uploadUrl = [NSString stringWithFormat:@"%@api/merchant/searchMUserInfo?token=%@&userId=%@",kBaseURL,_token,_iddd];
      
    [[QYXNetTool shareManager] postNetWithUrl:uploadUrl urlBody:nil bodyStyle:QYXBodyString header:nil response:QYXJSON success:^(id result) {
        [MBProgressHUD hideHUD];
        //         NSLog(@"resulttt%@",result);

        id objectvalue = [result objectForKey:@"obj"];
        if (![objectvalue isNull])
        {

            NSDictionary * datadict = [result objectForKey:@"obj"];

            NSString * isbook = [datadict objectForKey:@"isBook"];
            NSString * isKitchen = [datadict objectForKey:@"isKitchen"];
            NSString * isline = [datadict objectForKey:@"isLine"];
            NSString * isService = [datadict objectForKey:@"isService"];

            [_functionCategoryArr addObject:isbook];
            [_functionCategoryArr addObject:isline];
            [_functionCategoryArr addObject:isService];
            [_functionCategoryArr addObject:isKitchen];
            [_functionCategoryArr addObject:datadict[@"isAutomaticOrder"]];//isAutomaticOrder	到店是否自动接单
            [_functionCategoryArr addObject:datadict[@"isReserveOrders"]];//isReserveOrders	预订是否开启自动接单
//            [_functionCategoryArr addObject:datadict[@"isReturnDish"]];//isReturnDish	预订是否开启自动接单

            _erecttableview = [[UITableView alloc]init];
            _erecttableview.separatorStyle = UITableViewCellSeparatorStyleNone;
            _erecttableview.delegate = self;
            _erecttableview.dataSource = self;
            _erecttableview.scrollEnabled = NO;
            [self.view addSubview:_erecttableview];
            _erecttableview.sd_layout.leftEqualToView(self.view).topSpaceToView(self.view,height).widthIs(self.view.frame.size.width).heightIs(autoScaleH(35) + autoScaleH(45)*_functionCategoryArr.count);
        }

    } failure:^(NSError *error) {

         [MBProgressHUD hideHUD];

     }];

}
-(void)leftBarButtonItemAction{
    [self Back];
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _functionCategoryArr.count + 2;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    LoginTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"sys"];
    if (!cell) {

        cell = [[LoginTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"sys"];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textfild.hidden = YES;

    UILabel * linelabel = [[UILabel alloc]init];
    linelabel.backgroundColor = UIColorFromRGB(0xeeeeee);
    [cell addSubview:linelabel];
    linelabel.sd_layout.leftEqualToView(cell).rightEqualToView(cell).bottomEqualToView(cell).heightIs(0.5);

    if (indexPath.row==0) {
        cell.backgroundColor = RGB(242, 242, 242);
    }
    if (indexPath.row==1) {

        UILabel * leftlabel = [[UILabel alloc]init];
        leftlabel.frame = CGRectMake(autoScaleW(15), autoScaleH(4), autoScaleW(50), autoScaleH(15));
        leftlabel.font = [UIFont systemFontOfSize:autoScaleW(11)];
        leftlabel.textColor = [UIColor lightGrayColor];
        leftlabel.text = @"功能设置";
        [cell addSubview:leftlabel];
    }
    if (indexPath.row >= 2)
    {

        cell.leftlabel.text = _fourary[indexPath.row - 2];
        [cell.leftlabel setSingleLineAutoResizeWithMaxWidth:200];

        _mySwitth = [[UISwitch alloc]init];
        _mySwitth.on = [_functionCategoryArr[indexPath.row - 2] integerValue];
        [_mySwitth setOnTintColor:UIColorFromRGB(0xfd7577)];

        _mySwitth.tag = 300+indexPath.row;
        [_mySwitth addTarget:self action:@selector(swChange:) forControlEvents:UIControlEventValueChanged];
        [cell addSubview:_mySwitth];
        _mySwitth.sd_layout.rightSpaceToView(cell,autoScaleW(15)).topSpaceToView(cell,autoScaleH(8)).widthIs(autoScaleW(8)).heightIs(autoScaleH(11));
        if (indexPath.row == _fourary.count + 2 - 1 - 2) {
            _mySwitth.on = NO;
        }
    }
    if (indexPath.row == _fourary.count + 2 - 1) {
        UILabel *detailLabel = [self.view viewWithTag:10001];
        if (detailLabel == nil) {
            detailLabel = [[UILabel alloc] init];
        }
        detailLabel.tag = 10001;
        detailLabel.font = [UIFont systemFontOfSize:13];
        detailLabel.textColor = [UIColor lightGrayColor];
        [cell addSubview:detailLabel];
        detailLabel.sd_layout
        .rightSpaceToView(_mySwitth, 5)
        .topEqualToView(cell)
        .bottomEqualToView(cell);
        [detailLabel setSingleLineAutoResizeWithMaxWidth:120];
        detailLabel.adjustsFontSizeToFitWidth = YES;
        detailLabel.text = @"不包含未点菜的新订单";
    }
    return cell;
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
-(void)swChange:(UISwitch*)sw
{

    if (sw.tag==302) {
        if (sw.on==YES) {
            [self uploadFouctionStatus:@"isBook=1" keyUrl:@"Book" complete:^(BOOL success) {
                if (success) {
                    sw.on = success;
                }
            }];
        } else {
            [self uploadFouctionStatus:@"isBook=0" keyUrl:@"Book" complete:^(BOOL success) {
                if (success) {
                    sw.on = success;
                }
            }];
        }
    } else if (sw.tag==303) {

        if (sw.on==YES) {
            [self uploadFouctionStatus:@"isLine=1" keyUrl:@"Line" complete:^(BOOL success) {
                if (success) {
                    sw.on = success;
                }
            }];
        } else {
            [self uploadFouctionStatus:@"isLine=0" keyUrl:@"Line" complete:^(BOOL success) {
                if (success) {
                    sw.on = success;
                }
            }];
        }
    } else if (sw.tag==304) {
        if (sw.on==YES) {
            [self uploadFouctionStatus:@"isService=1" keyUrl:@"Service" complete:^(BOOL success) {
                if (success) {
                    sw.on = success;
                }
            }];
        } else {
            [self uploadFouctionStatus:@"isService=0" keyUrl:@"Service" complete:^(BOOL success) {
                if (success) {
                    sw.on = success;
                }
            }];
        }
    } else if (sw.tag == 305){
#warning 暂时关闭后厨功能，此按钮点击提示暂未开启后厨功能 , 如果需要 把＃if 0 改为 1.
        sw.on = NO;
        [SVProgressHUD showInfoWithStatus:@"功能暂未开启"];
#if 0
        if (sw.on==YES) {
            [self uploadFouctionStatus:@"isKitchen=1" keyUrl:@"Kitchen" complete:^(BOOL success) {
                if (success) {
                    sw.on = success;
                }
            }];
        } else {
            [self uploadFouctionStatus:@"isKitchen=0" keyUrl:@"Kitchen" complete:^(BOOL success) {
                if (success) {
                    sw.on = success;
                }
            }];
        }
#endif
    } else if (sw.tag == 306) {
        //到店是否自动接单
        [self loadDataWithOperType:@"1" changeKey:@"0" changeValue:[NSString stringWithFormat:@"%d", sw.on] complete:^(BOOL success) {
            if (!success) {
                sw.on = !sw.on;
            }
        }];
    } else if (sw.tag == 307) {
        //预订是否开启自动接单
        [self loadDataWithOperType:@"1" changeKey:@"1" changeValue:[NSString stringWithFormat:@"%d", sw.on] complete:^(BOOL success) {
            if (!success) {
                sw.on = !sw.on;
            }
        }];
    } else if (sw.tag == 308) {
        //预订是否开启自动接单
        [self loadDataWithOperType:@"1" changeKey:@"7" changeValue:[NSString stringWithFormat:@"%d", sw.on] complete:^(BOOL success) {
            if (!success) {
                sw.on = !sw.on;
            }
        }];
    } else {

    }
}
//上传功能状态void(^BLOCKOFSuccess)(id result)
- (void)uploadFouctionStatus:(NSString *)functionStatus keyUrl:(NSString *)keyUrl complete:(complete)complete{
    NSString *uploadUrl = [NSString stringWithFormat:@"%@api/merchant/update%@?token=%@&userId=%@&%@",kBaseURL,keyUrl, _token, _iddd, functionStatus];
      

    [MBProgressHUD showMessage:@"修改中"];
    [[QYXNetTool shareManager] postNetWithUrl:uploadUrl urlBody:nil bodyStyle:QYXBodyString header:nil response:QYXJSON success:^(id result) {
        [MBProgressHUD hideHUD];

        if ([result[@"msgType"] isEqualToString:@"2"]) {
            [SVProgressHUD showInfoWithStatus:result[@"msg"]];
            complete(YES);
        } else if ([result[@"msgType"] isEqualToString:@"0"]) {
            [SVProgressHUD showSuccessWithStatus:@"修改成功"];
            complete(NO);
        } else {
            [SVProgressHUD showErrorWithStatus:@"修改失败"];
            complete(YES);
        }

    } failure:^(NSError *error) {
        [MBProgressHUD hideHUD];
        [MBProgressHUD showError:@"网络错误，修改失败"];
        complete(YES);
    }];
}
//参数名	中文名	类型	说明
//isAutomaticOrder	到店是否自动接单	String	无
//isReserveOrders	预订是否开启自动接单	String	无
//isPrint	是否自动打印	String	无
//printPage	打印联数	String	无
//isNewOrderRmd	新订单提醒	String	无
//isArriveRmd	到店扫码新订单提醒	String	无
//isSeviceRmd	现场新服务提醒	String	无

/*    方法调用  */
//operaType－operation 0 查询 1修改
//changeKey－type 0:到店是否自动接单 1:是否自动打印 2:是否开启语音提醒 3:预订是否开启自动接单 4:
//typeVal－changeValue 0：关闭 1:开启
- (void)loadDataWithOperType:(NSString *)operaType changeKey:(NSString *)changeKey changeValue:(NSString *)changeValue complete:(complete)complete{
    NSString *keyUrl = @"api/merchant/editAutomatic";
    NSString *loadUrl = [NSString stringWithFormat:@"%@%@?token=%@&storeId=%@&operation=%@&type=%@&typeVal=%@&userId=%@", kBaseURL, keyUrl, TOKEN, storeID, operaType, changeKey, changeValue, UserId];
      
    [SVProgressHUD showWithStatus:@"请稍后"];
    [[QYXNetTool shareManager] postNetWithUrl:loadUrl urlBody:nil bodyStyle:QYXBodyString header:nil response:QYXJSON success:^(id result) {
        if ([result[@"msgType"] isEqualToString:@"0"]) {
            if ([operaType isEqualToString:@"0"]) {//查询
            } else {
                //修改
                ZTLog(@"%@", result);
                complete(YES);
            }
            [SVProgressHUD dismiss];
        } else {
            [SVProgressHUD showErrorWithStatus:@"操作异常"];
            complete(YES);
        }
    } failure:^(NSError *error) {

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
