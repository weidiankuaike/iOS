//
//  MoreErectViewController.m
//  微点筷客商户端
//
//  Created by 张森森 on 16/10/24.
//  Copyright © 2016年 张森森. All rights reserved.
//

#import "MoreErectViewController.h"
#import "UIBarButtonItem+SSExtension.h"
#import "ZTTimerPickerView.h"
#import "LoginTableViewCell.h"
#import "HomeVC.h"
#import "VerifyViewController.h"
#import "SafeErectViewController.h"
#import "RestaurantViewController.h"
#import "NumberViewController.h"
#import "SystemViewController.h"
#import "QYXNetTool.h"
#import "MBProgressHUD+SS.h"
#import "MoreOperationSetVC.h"
#import "PrintSetVC.h"
#import "VoiceSetVC.h"
@interface MoreErectViewController ()<UITableViewDataSource,UITableViewDelegate,ZTTimerPickerViewDelegate>
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
@property (nonatomic,strong)NSMutableArray * ssary;
@property (nonatomic,strong)NSMutableArray * ziliaoary;
@property (nonatomic,strong)NSMutableArray * numberary;
@property (nonatomic,strong)NSDictionary * materialdict;
@property (nonatomic,assign)NSString  * editstr;
@property (nonatomic,strong)NSMutableArray * stpestrary;
@property (nonatomic,strong)NSString * urlstr;
@end

@implementation MoreErectViewController
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = NO;
    self.tabBarController.tabBar.hidden = YES;
//    [self Getsomething];
}
- (void)viewDidLoad {
    [super viewDidLoad];
   
        
    self.titleView.text = @"更多设置";
   
    
    self.view.backgroundColor = RGB(242, 242, 242);
    self.automaticallyAdjustsScrollViewInsets = NO;


    
   CGFloat height = [[UIApplication sharedApplication] statusBarFrame].size.height + self.navigationController.navigationBar.frame.size.height;
    firstary = @[@"餐厅资料",@"账号管理", @"功能设置", @"打印设置", @"提醒设置", @"更多设置"];
    erecttableview = [[UITableView alloc]init];
    erecttableview.delegate = self;
    erecttableview.dataSource = self;
    erecttableview.scrollEnabled = NO;
    [self.view addSubview:erecttableview];
    erecttableview.sd_layout.leftEqualToView(self.view).topSpaceToView(self.view,height).widthIs(self.view.frame.size.width).heightIs(autoScaleH(45*firstary.count));
    
    _ssary = [NSMutableArray array];
    _ziliaoary = [NSMutableArray array];
    _numberary = [NSMutableArray array];
    _stpestrary = [NSMutableArray array];

}
-(void)leftBarButtonItemAction{
    [self Back];
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return firstary.count;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"mor"];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"mor"];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.text = firstary[indexPath.row];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row==0)
    {
        RestaurantViewController * resview = [[RestaurantViewController alloc]init];
//        if (_BaseModel.storeBase.isEdit  == 1 && _BaseModel.storeBase.isChecked == 3) {
//            resview.yminteger = 2;
//        } else {
            resview.yminteger = 1;
//        }
//        resview.editer = _BaseModel.storeBase.isEdit;
//        resview.erectary = _ziliaoary;
//        resview.storematerialdict = _materialdict;
//        resview.editer = [_editstr integerValue];
//        resview.typeary = _stpestrary;
//        resview.sdwebstr= _urlstr;
        [self.navigationController pushViewController:resview animated:YES];
        
        
    }
    if (indexPath.row==1)
    {
        
        NumberViewController * numberview = [[NumberViewController alloc]init];
//        numberview.numbary = _numberary;
        [self.navigationController pushViewController:numberview animated:YES];
        
    }
    if (indexPath.row==2)
    {
        SystemViewController * systemView = [[SystemViewController alloc]init];
//        systemView.serereary = _ssary;
        [self.navigationController pushViewController:systemView animated:YES];
    }
    if (indexPath.row == 3) {
        //打印设置
        PrintSetVC *formatVC = [[PrintSetVC alloc] init];
        [self.navigationController pushViewController:formatVC animated:YES];
    }
    if (indexPath.row == 4) {
        //提醒设置
        VoiceSetVC *formatVC = [[VoiceSetVC alloc] init];
        [self.navigationController pushViewController:formatVC animated:YES];

    }
    if (indexPath.row == firstary.count - 1) {
        MoreOperationSetVC *operationVC = [[MoreOperationSetVC alloc] init];
        [self.navigationController pushViewController:operationVC animated:YES];
    }
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
        return autoScaleH(45);
    
}
-(void)ZTselectTimesViewSetOneLeft:(NSString *)oneLeft andOneRight:(NSString *)oneRight andTwoLeft:(NSString *)twoLeft andTwoRight:(NSString *)twoRight
{
    
    [[self.view viewWithTag:1111] setTitle:[NSString stringWithFormat:@"%@:%@", oneLeft, oneRight] forState:UIControlStateNormal];
    [[self.view viewWithTag:1112] setTitle:[NSString stringWithFormat:@"%@:%@", twoLeft, twoRight] forState:UIControlStateNormal];
    
    NSString * leftstr = [NSString stringWithFormat:@"%@:%@", oneLeft, oneRight];
    NSString * rightstr = [NSString stringWithFormat:@"%@:%@", twoLeft, twoRight];
    
    timelabel.text = [NSString stringWithFormat:@"%@-%@",leftstr,rightstr];
    
    
}

-(void)Back
{
    
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
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
