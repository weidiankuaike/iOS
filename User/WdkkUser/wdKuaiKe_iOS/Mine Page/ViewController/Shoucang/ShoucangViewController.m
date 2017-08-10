//
//  ShoucangViewController.m
//  WDKKtest
//
//  Created by 张森森 on 16/8/4.
//  Copyright © 2016年 weiDianKuaiKe. All rights reserved.
//

#import "ShoucangViewController.h"
#import "UIBarButtonItem+SSExtension.h"
#import "MerchantListCell.h"
#import "LLHConst.h"
#import "ShouCangTableViewCell.h"
#import "MBProgressHUD+SS.h"
#import "QYXNetTool.h"
#import "ShoucangModel.h"
#import "NSObject+JudgeNull.h"
#import <UIImageView+WebCache.h>
#import "ZTAddOrSubAlertView.h"
#import "NewMerchantVC.h"
@interface ShoucangViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong)UITableView * shoucangtable;
@property (nonatomic,strong)UIImageView * ximage;
@property (nonatomic,strong)NSMutableArray * modelary;
@property (nonatomic,copy) NSString * token;
@property (nonatomic,copy) NSString * userid;
@property (nonatomic,strong)UILabel * sumlabel;
@property (nonatomic,copy) NSString * storesum;
@property (nonatomic,copy) NSString * prodectsum;
@end

@implementation ShoucangViewController
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = NO;
    self.navigationController.navigationBar.translucent = NO;
    [self.navigationController.navigationBar setBarTintColor:UIColorFromRGB(0xfd7577)];
    self.tabBarController.tabBar.hidden = YES;
    [self getData];
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = RGB(238, 238, 238);
    UILabel * titlabel = [[UILabel alloc]init];
    titlabel.frame = CGRectMake(0, 0, 80, 30);
    titlabel.textAlignment = NSTextAlignmentCenter;
    titlabel.font = [UIFont systemFontOfSize:15];
    titlabel.text = @"我的收藏";
    titlabel.textColor = [UIColor whiteColor];
    self.navigationItem.titleView = titlabel;
    UIBarButtonItem * backbtn = [UIBarButtonItem itemWithTarget:self Action:@selector(Back) image:@"left-1" selectImage:nil];
    self.navigationItem.leftBarButtonItem = backbtn;
    
    _modelary = [NSMutableArray array];
    
}
   
- (void)getData{
    NSString * urlstr = [NSString stringWithFormat:@"%@/api/user/myCollectManage?token=%@&userId=%@&operation=0",commonUrl,Token,Userid];
    NSArray * urlary = [urlstr componentsSeparatedByString:@"?"];
    
    [MBProgressHUD showMessage:@"请稍等"];
    [[QYXNetTool shareManager]postNetWithUrl:urlary.firstObject urlBody:urlary.lastObject bodyStyle:QYXBodyString header:nil response:QYXJSON success:^(id result)
     {        [MBProgressHUD hideHUD];
         
         if (![[result objectForKey:@"obj"] isNull]) {
             
             NSDictionary * datadict = [result objectForKey:@"obj"];
             _storesum = [datadict objectForKey:@"totalStoreCnt"];
             _prodectsum = [datadict objectForKey:@"totalFoodCnt"];
             
             if (![[datadict objectForKey:@"myCollect"] isNull]) {
                 [_modelary removeAllObjects];
                 NSArray * dataary = [datadict objectForKey:@"myCollect"];
                 for (int i =0; i<dataary.count; i++) {
                     
                     ShoucangModel * model = [[ShoucangModel alloc]initWithgetsomethingwithdict:dataary[i]];
                     
                     [_modelary addObject:model];
                 }
                 
                 [self Creattable];
                 _sumlabel.text = [NSString stringWithFormat:@"%@个餐厅 %@道菜",_storesum,_prodectsum];
             }
             
         }
         
     } failure:^(NSError *error)
     {
         [MBProgressHUD hideHUD];
         [MBProgressHUD showError:@"网络参数错误"];
         
     }];

}
-(void)Creattable
{
    UIView * headview = [[UIView alloc]init];
    headview.backgroundColor = RGB(238, 238, 238);
    headview.frame = CGRectMake(0, 0, GetWidth, autoScaleH(25));
    [self.view addSubview:headview];
    //    headview.sd_layout.leftEqualToView(self.view).rightEqualToView(self.view).topSpaceToView(self.view,autoScaleH(66)).heightIs(autoScaleH(25));
    
    _sumlabel = [[UILabel alloc]init];
    _sumlabel.textAlignment = NSTextAlignmentRight;
    _sumlabel .font =[UIFont systemFontOfSize:autoScaleW(11)];
    [headview addSubview:_sumlabel];
    _sumlabel.sd_layout.rightSpaceToView(headview,autoScaleW(15)).topSpaceToView(headview,autoScaleH(10)).widthIs(autoScaleW(300));
    
    _shoucangtable = [[UITableView alloc]init];
    _shoucangtable.delegate = self;
    _shoucangtable.dataSource = self;
    _shoucangtable.tableHeaderView = headview;
    _shoucangtable.showsVerticalScrollIndicator = NO;
    _shoucangtable.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_shoucangtable];
    _shoucangtable.sd_layout.leftEqualToView(self.view).rightEqualToView(self.view).topEqualToView(self.view).heightIs(GetHeight);
    
    
}
#pragma mark 清楚记录的回掉
-(void)Clear
{
    
}
#pragma mark 返回的回调
-(void)Back
{
    [self.navigationController popViewControllerAnimated:NO];
}
#pragma mark 表的数据源方法

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _modelary.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    ShoucangModel * model = _modelary[section];
    
    return model.modelarray.count+1;
    
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    MerchantListCell *cell                         = [[MerchantListCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"homeTableViewCell"];
    static NSString *celldent = @"shou";
    
    ShouCangTableViewCell * cell =[tableView cellForRowAtIndexPath:indexPath];
    if (!cell) {
        
        cell = [[ShouCangTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:celldent];
        //添加阴影
    }
    UILabel * linelabel = [[UILabel alloc]init];
    linelabel.backgroundColor = UIColorFromRGB(0xeeeeee);
    [cell addSubview:linelabel];
    linelabel.sd_layout.leftSpaceToView(cell,0).bottomSpaceToView(cell,0).widthIs(self.view.frame.size.width).heightIs(autoScaleH(1));
    cell.selectionStyle                            = UITableViewCellSelectionStyleNone;
    ShoucangModel * model = _modelary[indexPath.section];
    
//    
//    if (indexPath.section!=_modelary.count-1)
//    {
//
//        if (indexPath.row == model.modelarray.count+1) {
//            
//            cell.backgroundColor = RGB(242, 242, 242);
//        }
//        else if (indexPath.row==0)
//        {
//            [cell.headimage sd_setImageWithURL:[NSURL URLWithString:model.storeimage]];
//            cell.headimage.sd_layout.leftSpaceToView(self,autoScaleW(15)).topSpaceToView(self,autoScaleH(7)).widthIs(autoScaleW(30)).heightIs(autoScaleH(30));
//            
//            cell.xqlabel.text = model.storenamestr;
//            cell.xqlabel.textAlignment = NSTextAlignmentLeft;
//            cell.xqlabel.sd_layout.leftSpaceToView(cell.headimage,autoScaleW(15)).topSpaceToView(self,autoScaleH(10)).widthIs(autoScaleW(300)).heightIs(autoScaleH(22));
//            
//            cell.number.hidden = YES;
//        }
//        else
//        {
//            Shoucangcellmodel * cellmodel = model.modelarray[indexPath.row-1];
//            [cell.headimage sd_setImageWithURL:[NSURL URLWithString:cellmodel.imagestr] placeholderImage:[UIImage imageNamed:@"1"]];
//            cell.xqlabel.text = cellmodel.namestr;
//            cell.number.text = [NSString stringWithFormat:@"￥%@",cellmodel.moneystr];
//        }
//    }
//    else
//    {

        if (indexPath.row==0)
        {
            [cell.headimage sd_setImageWithURL:[NSURL URLWithString:model.storeimage]];
            cell.headimage.sd_layout.leftSpaceToView(self,autoScaleW(15)).topSpaceToView(self,autoScaleH(7)).widthIs(autoScaleW(30)).heightIs(autoScaleH(30));
            cell.xqlabel.text = model.storenamestr;
            cell.xqlabel.textAlignment = NSTextAlignmentLeft;
            cell.xqlabel.sd_layout.leftSpaceToView(cell.headimage,autoScaleW(15)).topSpaceToView(self,autoScaleH(10)).heightIs(autoScaleH(22));
            [cell.xqlabel setSingleLineAutoResizeWithMaxWidth:300];
            cell.number.hidden = YES;
        }
        else
        {
            Shoucangcellmodel * cellmodel = model.modelarray[indexPath.row-1];
            [cell.headimage sd_setImageWithURL:[NSURL URLWithString:cellmodel.imagestr] placeholderImage:[UIImage imageNamed:@"1"]];
           cell.xqlabel.text = cellmodel.namestr;
           cell.number.text = [NSString stringWithFormat:@"￥%@",cellmodel.moneystr] ;
            
        }
//    }
     return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ShoucangModel * model = _modelary[indexPath.section];

    if (indexPath.section==_modelary.count-1) {
        if (indexPath.row==0) {
            
            return autoScaleH(53);
        }
        
    }
    else
    {
        if (indexPath.row==0) {
            
            return autoScaleH(53);
        }
       else if (indexPath.row == model.modelarray.count+1) {
            
            return autoScaleH(10);
        }
    }
    
    return autoScaleH(86);
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return autoScaleH(15);
    
}
- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    UIView * sectionview = [[UIView alloc]init];
    sectionview.backgroundColor = RGB(242, 242, 242);
    
    return sectionview;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row==0) {
        ShoucangModel * model = _modelary[indexPath.section];
        NewMerchantVC * storeDetail = [[NewMerchantVC alloc]init];
        storeDetail.idstr = model.storeid;
        [self.navigationController pushViewController:storeDetail animated:YES];
        
    }
    
    
}
#pragma mark 自定义编辑删除的方法
-(nullable NSArray<UITableViewRowAction *> * )tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewRowAction *deleteRoWAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"删除" handler:^(UITableViewRowAction *action, NSIndexPath *indexPath)
    {//title可自已定义
        
        UITableViewCellEditingStyle UITableViewCellEditingStyleDelete;
        ShoucangModel * model = _modelary[indexPath.section];

        if (indexPath.row==0)
        {
            ZTAddOrSubAlertView * ztlaertview = [[ZTAddOrSubAlertView alloc]initWithStyle:ZTalertSheetStyleSubTitle];
            ztlaertview.titleLabel.text = @"确认要删除该餐厅吗？";
            ztlaertview.littleLabel.text = @"同时会清空已收藏的该店的菜品";
            ztlaertview.complete = ^(BOOL choose)
            {
                
                if (choose==YES) {
                    
                    [MBProgressHUD showMessage:@"请稍等"];
                    
                    NSString * url = [NSString stringWithFormat:@"%@/api/user/myCollectManage?token=%@&userId=%@&storeId=%@&operation=1",commonUrl,Token,Userid,model.storeid];
                     NSArray * urlary = [url componentsSeparatedByString:@"?"];
                     
                     [[QYXNetTool shareManager]postNetWithUrl:urlary.firstObject urlBody:urlary.lastObject bodyStyle:QYXBodyString header:nil response:QYXJSON success:^(id result)
                     {
                         [MBProgressHUD hideHUD];
                         NSString * codestr = [NSString stringWithFormat:@"%@",[result objectForKey:@"msgType"]];
                         if ([codestr isEqualToString:@"0"]) {
                             
//                             [tableView beginUpdates];
                             //        1.数据源删除
                             [model.modelarray removeAllObjects];
                             [_modelary removeObjectAtIndex:indexPath.section];
                             
                             //        2.UI上删除
                             
                             //删除表视图的某个cell
                             
                             /*
                              
                              第一个参数：将要删除的所有的cell的indexPath组成的数组
                              
                              第二个参数：动画
                              
                              */
                            
                             [tableView deleteSections:[NSIndexSet indexSetWithIndex:indexPath.section] withRowAnimation:UITableViewRowAnimationRight];
                             //将整个表格视图刷新也可以实现在UI上删除的效果，只不过它要重新执行一遍所有的方法，效率很低
                            
                             NSInteger storesumint = [_storesum integerValue]-1;
                             NSInteger prodectsum = [_prodectsum integerValue]-model.modelarray.count;
                             _storesum = [NSString stringWithFormat:@"%ld",storesumint];
                             _prodectsum = [NSString stringWithFormat:@"%ld",prodectsum];
                             _sumlabel.text = [NSString stringWithFormat:@"%@个餐厅 %@道菜",_storesum,_prodectsum];
                             
                               [_shoucangtable endUpdates];
                                                          
                         }
                         
                         
                     } failure:^(NSError *error)
                     {
                         [MBProgressHUD hideHUD];
                         [MBProgressHUD showError:@"删除失败"];

                         
                     }];


                    
                }
                
            };
            
        }
        else
        {
            Shoucangcellmodel * cellmodel = model.modelarray[indexPath.row-1];

            NSString * urlstr =  [NSString stringWithFormat:@"%@/api/user/myCollectManage?token=%@&userId=%@&storeId=%@&operation=1&productId=%@",commonUrl,Token,Userid,model.storeid,cellmodel.caiid];
            NSArray * urlary = [urlstr componentsSeparatedByString:@"?"];
            
            [MBProgressHUD showMessage:@"请稍等"];
            [[QYXNetTool shareManager]postNetWithUrl:urlary.firstObject urlBody:urlary.lastObject bodyStyle:QYXBodyString header:nil response:QYXJSON success:^(id result)
             {

                [MBProgressHUD hideHUD];
                NSString * codestr = [NSString stringWithFormat:@"%@",[result objectForKey:@"msgType"]];
                if ([codestr isEqualToString:@"0"]) {
                    //        1.数据源删除
                    [model.modelarray removeObjectAtIndex:indexPath.row-1];
                                       //        2.UI上删除
                    
                    //删除表视图的某个cell
                    
                    /*
                     
                     第一个参数：将要删除的所有的cell的indexPath组成的数组
                     
                     第二个参数：动画
                     
                     */
                    
                    [tableView deleteRowsAtIndexPaths:@[indexPath]withRowAnimation:UITableViewRowAnimationAutomatic];
                   
                    

                    //将整个表格视图刷新也可以实现在UI上删除的效果，只不过它要重新执行一遍所有的方法，效率很低
                    
                    NSInteger prodectsum = [_prodectsum integerValue]-1;
                    _prodectsum = [NSString stringWithFormat:@"%ld",prodectsum];
                     _sumlabel.text = [NSString stringWithFormat:@"%@个餐厅 %@道菜",_storesum,_prodectsum];
                    
                            [_shoucangtable reloadData];
                    

                }
                
                
            } failure:^(NSError *error)
            {
                [MBProgressHUD hideHUD];
                [MBProgressHUD showError:@"删除失败"];
                
            }];
            
            
            
            
        }
        
        
    }];//此处是iOS8.0以后苹果最新推出的api，UITableViewRowAction，Style是划出的标签颜色等状态的定义，这里也可自行定义
    deleteRoWAction.backgroundColor = UIColorFromRGB(0xFD7577);
    //可以定义RowAction的颜色
    return @[deleteRoWAction];//最后返回这俩个RowAction 的数组
}





- (void)didReceiveMemoryWarning
{
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
