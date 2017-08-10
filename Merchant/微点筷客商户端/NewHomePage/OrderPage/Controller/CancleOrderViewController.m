//
//  CancleOrderViewController.m
//  微点筷客商户端
//
//  Created by 张森森 on 16/10/13.
//  Copyright © 2016年 张森森. All rights reserved.
//

#import "CancleOrderViewController.h"
#import "UIBarButtonItem+SSExtension.h"
#import "ChooseErectViewController.h"
#import "MBProgressHUD+SS.h"
#import "QYXNetTool.h"
#import "CancelReasonCell.h"
@interface CancleOrderViewController ()<UITableViewDelegate,UITableViewDataSource, UITextViewDelegate>
{
    NSArray * titleary;
    NSInteger cellRow;
}
@property (nonatomic,strong)ButtonStyle * daitibtn;
@property (nonatomic,strong)NSMutableArray * chooseary;
@property (nonatomic,copy) NSString * yuanyinstr;
@property (nonatomic,copy) NSString * status;
@property (nonatomic,copy) NSString * opertype;
@property (nonatomic,assign) NSInteger typeint;
@property (nonatomic,copy) NSString * textstr;
@end

@implementation CancleOrderViewController{
    UITableView * cancelTabelV;
    UITextView * reasonTextV;
    BOOL isInput;
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = YES;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    cellRow = -1;
    _textstr = @"";
    self.titleView.text = @"取消原因";
    self.automaticallyAdjustsScrollViewInsets = NO;

    self.view.backgroundColor = UIColorFromRGB(0xffffff);
    
    cancelTabelV = [[UITableView alloc]init];
    cancelTabelV.separatorStyle = UITableViewCellSeparatorStyleNone;
    cancelTabelV.delegate = self;
    cancelTabelV.dataSource = self;
    [self.view addSubview:cancelTabelV];
    CGFloat height = [[UIApplication sharedApplication] statusBarFrame].size.height + self.navigationController.navigationBar.frame.size.height;
    cancelTabelV.sd_layout.leftEqualToView(self.view).rightEqualToView(self.view).topSpaceToView(self.view,height).heightIs(autoScaleH(45*4+110));
    
    titleary = @[@"先联系客人",@"该时段餐厅繁忙",@"该时段餐厅休业",@"其他原因:"];
    
    NSArray * chooseary = @[@"取消",@"确认",];
    for (int i=0; i<2; i++) {
        ButtonStyle * choosebtn = [ButtonStyle buttonWithType:UIButtonTypeCustom];
        [choosebtn setTitle:chooseary[i] forState:UIControlStateNormal];
        choosebtn.titleLabel.font = [UIFont systemFontOfSize:autoScaleW(15)];
        [choosebtn setTitleColor:UIColorFromRGB(0xfd7577) forState:UIControlStateNormal];
        choosebtn.layer.borderWidth = 1;
        choosebtn.layer.borderColor = UIColorFromRGB(0xfd7577).CGColor;
        if (i==1) {
            choosebtn.backgroundColor = UIColorFromRGB(0xfd7577);
            [choosebtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];

            _daitibtn = choosebtn;
        }
        choosebtn.tag = 200 +i;
        [choosebtn addTarget:self action:@selector(Choose:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:choosebtn];
        choosebtn.sd_layout.leftSpaceToView(self.view,i*(kScreenWidth/2)).bottomSpaceToView(self.view, -1).widthIs(kScreenWidth/2).heightIs(autoScaleH(45));

    }
    _chooseary = [NSMutableArray array];


}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    return 4;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CancelReasonCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cencle"];
    if (!cell) {
        cell = [[CancelReasonCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cencle"];

    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;


    cell.leftTitleL.text = titleary[indexPath.row];
    if (indexPath.row==0) {
        cell.phoneImage.hidden = NO;
    } else {

        cell.rightBT.hidden = NO;
        cell.rightBT.tag = 200 + indexPath.row;
        [_chooseary addObject:cell.rightBT];
        [cell.rightBT addTarget:self action:@selector(ChooseBtn:) forControlEvents:UIControlEventTouchUpInside];
    }
    if (indexPath.row == 3 && isInput) {
        if (!reasonTextV) {
             reasonTextV = [[UITextView alloc]init];
            reasonTextV.backgroundColor = RGB(238, 238, 238);
            reasonTextV.font = [UIFont systemFontOfSize:autoScaleW(13)];

        }
        reasonTextV.delegate = self;
        [cell addSubview:reasonTextV];

        reasonTextV.sd_layout
        .leftSpaceToView(cell,autoScaleW(10))
        .rightSpaceToView(cell,autoScaleW(10))
        .topSpaceToView(cell,autoScaleH(45))
        .heightIs(autoScaleH(112 - 12));
    }
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row==3 && isInput) {

        return autoScaleH(112 + 45);
    }

    return autoScaleH(45);
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row==0) {

        NSString *message = NSLocalizedString(_phoneNum, nil);
        NSString *cancelButtonTitle = NSLocalizedString(@"取消", nil);
        NSString *otherButtonTitle = NSLocalizedString(@"拨打", nil);

        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:message preferredStyle:UIAlertControllerStyleAlert];

        // Create the actions.
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:cancelButtonTitle style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
            [alertController dismissViewControllerAnimated:YES completion:^{


            }];
        }];

        UIAlertAction *otherAction = [UIAlertAction actionWithTitle:otherButtonTitle style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            NSMutableString *str=[[NSMutableString alloc] initWithFormat:@"tel:%@",_phoneNum];
            UIWebView *callWebview = [[UIWebView alloc] init];
            [callWebview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:str]]];
            [self.view addSubview:callWebview];

        }];

        // Add the actions.
        [alertController addAction:cancelAction];
        [alertController addAction:otherAction];

        [self presentViewController:alertController animated:YES completion:nil];
    }



    if (indexPath.row == 3) {
        isInput = YES;
        reasonTextV.hidden = !isInput;
    } else {
        isInput = NO;
        reasonTextV.hidden = !isInput;
    }
    [cancelTabelV reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:3 inSection:0]] withRowAnimation:UITableViewRowAnimationAutomatic];
    ButtonStyle *button = [self.view viewWithTag:200 + indexPath.row];
    [self ChooseBtn:button];
}
#pragma mark 选择按钮
-(void)ChooseBtn:(ButtonStyle *)btn
{
    for (ButtonStyle * choosebtn in _chooseary) {

        if (choosebtn.tag == btn.tag) {
            choosebtn.selected = YES;
        }
        else
        {
            choosebtn.selected = NO;
        }
    }
    if (btn.tag==201||btn.tag==202) {

        _typeint = 1;
    }
    else
    {
        _typeint = 2;
    }
    cellRow = btn.tag - 200;

//    if (cellRow == 3) {
//        [cancelTabelV selectRowAtIndexPath:[NSIndexPath indexPathForRow:cellRow inSection:0] animated:YES scrollPosition:UITableViewScrollPositionNone];
//    }

}
-(void)Choose:(ButtonStyle *)btn
{

    if (btn.tag==201)
    {
        NSNumber *chooseStatus = [[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"%@-%ld", storeID,(long)cellRow]];
        if ([chooseStatus isEqualToNumber:@(cellRow)]) {
            _status = cellRow == 1 ? @"2":@"0";
            _opertype = @"2";
            [self uploadCancelOrderReaseon];
        } else if (cellRow == 3 || _typeint == 2 || cellRow == -1){
            {
                if ([_textstr isNull] || !_textstr) {
                    [MBProgressHUD showError:@"请填写原因"];
                } else {
                    _status = @"";
                    _opertype = @"2";
                    [self uploadCancelOrderReaseon];
                }
            }
        } else {
            ChooseErectViewController * chooseview = [[ChooseErectViewController alloc]init];
            chooseview.modalPresentationStyle = UIModalPresentationOverCurrentContext;
            chooseview.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
            chooseview.chooseinteger = cellRow;
            chooseview.block = ^(NSString * typestr,NSString*operstr)
            {
                _status = typestr;
                _opertype = operstr;

                if (_typeint==1) {
                    _textstr = @"";
                    [self uploadCancelOrderReaseon];
                }
            };
            [self presentViewController:chooseview animated:YES completion:nil];
        }
    } else {
        [self.navigationController popViewControllerAnimated:YES];

    }

}
- (void)uploadCancelOrderReaseon{

    NSString * storeid = storeID;
    [MBProgressHUD showMessage:@"请稍等"];
    // operType 0接受 1真取消 2 伪取消，不改变营业状态
    NSString *loadUrl = [NSString stringWithFormat:@"%@api/merchant/orderManage?token=%@&storeId=%@&orderId=%@&whyCancel=%@&status=%@&operType=%@&userId=%@",kBaseURL,TOKEN,storeid,_orderid,_textstr,_status,_opertype, _BaseModel.id];
      
    [[QYXNetTool shareManager] postNetWithUrl:loadUrl urlBody:nil bodyStyle:QYXBodyString header:nil response:QYXJSON success:^(id result) {
        [MBProgressHUD hideHUD];
        if ([result[@"msgType"] integerValue] == 0) {
            [SVProgressHUD showSuccessWithStatus:@"取消成功"];
            //                    NSLog(@"....%@%@",result,[result objectForKey:@"msg"]);
            [self.navigationController popViewControllerAnimated:YES];
            if (_NetUploadSuccess) {
                _NetUploadSuccess(YES);
            }
            if ([_opertype integerValue] == 1) {//真取消
                if ([_status integerValue] == 0) {
                    [self sendStoreStatusToLeftViewController:@{@"isBusy":@"0"}];//休业
                } else {
                    [self sendStoreStatusToLeftViewController:@{@"isBusy":@"1"}];//繁忙
                }
            }
        } else {
            [SVProgressHUD showErrorWithStatus:@"操作异常"];
        }
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUD];
    }];
}
- (void)sendStoreStatusToLeftViewController:(NSDictionary *)userInfo{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"StoreStatusChanged" object:self userInfo:userInfo];
}
- (void)createTextView{

}
-(void)leftBarButtonItemAction
{
    [self.navigationController popViewControllerAnimated:YES];


}
-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    _textstr = textView.text;
    return YES;
}
- (void)textViewDidEndEditing:(UITextView *)textView{
    _textstr = textView.text;
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
