//
//  RestaurantOrderVC.m
//  wdKuaiKe_iOS
//
//  Created by Skyer God on 16/9/18.
//  Copyright © 2016年 weiDianKuaiKe. All rights reserved.
//

#import "RestaurantOrderVC.h"
#import "LeftLblRightImageButton.h"
#import "RestaurantOrderCell.h"
#import "DishesInfomationVC.h"
#import "DishesCategoryCell.h"
#import "DishesInfoModel.h"
#import "ShoppingCartView.h"

#import "ThrowLineTool.h"
#import "ViewModel.h"

#import "MJExtension.h"
#import "RestaurantHeaderFooterView.h"
#import "ShoppingCartSingletonView.h"
#import "NewMerchantVC.h"
//
#import "MBProgressHUD+SS.h"
#import "QYXNetTool.h"
#import "DishesInfomationVC.h"
#import "NSObject+JudgeNull.h"
#import "DishdetailView.h"
@interface RestaurantOrderVC ()<UITableViewDelegate, UITableViewDataSource, ThrowLineToolDelegate>
{
    
}
@property (nonatomic, strong) NSArray *dataArr;
@property (nonatomic, strong) NSMutableArray *rightTabDataArr;
@property (nonatomic, strong)UITableView *leftTableView;
@property (nonatomic, strong)UITableView *rightTableView;
@property (nonatomic, assign) BOOL isEndAnimation;
@property (nonatomic, strong) UIImageView *redView;
@property (nonatomic, strong) NSMutableArray *leftTabDataArr;
@property (nonatomic, strong) DishdetailView * detailview;//菜品详情
@property (nonatomic, assign) BOOL IsExist;
//@property (nonatomic,strong) ShoppingCartView *shoppcartview;
//订单数据
@property (nonatomic,strong) NSMutableArray *ordersArray;

@end

@implementation RestaurantOrderVC
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = YES;

}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:NO];

    self.tabBarController.tabBar.hidden = NO;
}
- (void)viewDidLoad {
    [super viewDidLoad];

//    _sum = 0;
    self.rightTabDataArr = [NSMutableArray new];

    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"堂食点餐";
            /** 联动动画结束标志  **/
    _isEndAnimation = YES;
    
    _IsExist = NO;
    [ThrowLineTool sharedTool].delegate = self;


    if (_dictary.count==0) {
        
        _dictary = [NSMutableArray array];

    }
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(UpdatemainUI:) name:@"updateUI" object:nil];
    
    _leftTabDataArr = [NSMutableArray array];
    
    [self GetData];
    //查看订单通知
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(Changedine:) name:@"changedine" object:nil];

    //提交订单通知
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(Remove) name:@"remove" object:nil];
    
}
//接受通知订单详情修改订单
- (void)Changedine:(NSNotification*)not
{
    _dictary = not.userInfo[@"ary"];
    
    NSString * change = not.userInfo[@"change"];
    
    if ([change isEqualToString:@"yes"]) {
        _sum =  [not.userInfo[@"fee"] floatValue]+_sum;
        _number = _number+1;
        
        
    }
    else if ([change isEqualToString:@"no"])
    {
        _sum = _sum-[not.userInfo[@"fee"] floatValue];
        _number = _number-1;
        
    }
    else if ([change isEqualToString:@"remove"])
    {
        _sum = 0;
        _number = 0;
    }
    
    [_rightTableView reloadData];

}
- (void)Remove
{
    [_dictary removeAllObjects];
    [_rightTableView reloadData];
}
#pragma mark 网络请求
-(void)GetData
{
    __weak NSString * userId=nil;
    if ([[NSUserDefaults standardUserDefaults]objectForKey:@"idd"]==nil) {
        
        userId = @"";
    }else{
        userId = [[NSUserDefaults standardUserDefaults]objectForKey:@"idd"];
    }
    
    NSString * urlstr = [NSString stringWithFormat:@"%@/getStoreProductData?storeId=%@&userId=%@",commonUrl,_storeid,userId];
    NSArray * urlary = [urlstr componentsSeparatedByString:@"?"];
   
    [[QYXNetTool shareManager] postNetWithUrl:urlary.firstObject urlBody:urlary.lastObject bodyStyle:QYXBodyString header:nil response:QYXJSON success:^(id result)
    {
      
        NSString * msgtype = [NSString stringWithFormat:@"%@",result[@"msgType"]];
        if ([msgtype isEqualToString:@"0"]) {
            NSArray * objdict = [result objectForKey:@"obj"];
            for (int i =0; i<objdict.count; i++) {
                
                DishesInfoModel * model = [DishesInfoModel mj_objectWithKeyValues:objdict[i]];
               
                if (model.storeProductVoList!=nil) {
                    
                    [_leftTabDataArr addObject:model.productCategory];
                    
                    [_rightTabDataArr addObject:model];

                }
                                                                                                                                                                                                                                                       
            }
             [self setupCategoryButtuon];
            
        }else{
            [MBProgressHUD showError:@"获取菜品失败"];
        }
     } failure:^(NSError *error) {
        
         [MBProgressHUD hideHUD];
    }];
}
/**
 *  抛物线小红点
 *
 *  @return
 */
- (UIImageView *)redView
{
    if (!_redView) {
        _redView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 10, 10)];
        _redView.image = [UIImage imageNamed:@"红色"];
        _redView.layer.cornerRadius = 10;
    }
    return _redView;
}
/**
 *  存放用户添加到购物车的商品数组
 *
 *  @return
 */
-(NSMutableArray *)ordersArray
{
    if (!_ordersArray) {
        _ordersArray = [NSMutableArray new];
    }
    return _ordersArray;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.


}
//- (void)createMOdelWithCount:(NSInteger)count{
//
//    [ViewModel GetShoppdata:^(NSMutableArray *array){
////        array = [DishesInfoModel mj_objectArrayWithKeyValuesArray:array];
//
//        self.rightTabDataArr = array;
//
//    }];
//
//
//
//}


- (void)setupCategoryButtuon{

    UIView *topSeparator = [[UIView alloc] init];
    topSeparator.backgroundColor = RGB(238, 238, 238);
    [self.view addSubview:topSeparator];

    topSeparator.sd_layout
    .leftEqualToView(self.view)
    .topEqualToView(self.view)
    .rightEqualToView(self.view)
    .heightIs(autoScaleH(3));
    
    /** 左边tableView **/
    _leftTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    [self.view addSubview:_leftTableView];


    _leftTableView.sd_layout
    .leftEqualToView(self.view)
    .topSpaceToView(topSeparator, 0)
    .widthIs(100)
    .bottomSpaceToView(self.view, autoScaleH(0));

    
    _leftTableView.separatorStyle = 0;
    _leftTableView.backgroundColor = RGB(238, 238, 238);
    _leftTableView.delegate = self;
    _leftTableView.dataSource = self;
    _leftTableView.showsVerticalScrollIndicator = NO;
//    _leftTableView.contentInset = UIEdgeInsetsMake(-35, 0, 0, 0);
    _leftTableView.bounces = NO;


    [_leftTableView registerClass:[DishesCategoryCell class] forCellReuseIdentifier:NSStringFromClass([DishesCategoryCell class])];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    [_leftTableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionTop];



    /** 右边tableView **/

    _rightTableView = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStylePlain];
    [self.view addSubview:_rightTableView];

    _rightTableView.sd_layout
    .leftSpaceToView(_leftTableView, 0)
    .rightEqualToView(self.view)
    .topSpaceToView(topSeparator, 0)
    .bottomSpaceToView(self.view, autoScaleH(0));

    _rightTableView.separatorStyle = 0;
    _rightTableView.backgroundColor = _leftTableView.backgroundColor;
    _rightTableView.delegate = self;
    _rightTableView.dataSource = self;
    _rightTableView.showsVerticalScrollIndicator = NO;

    [_rightTableView registerClass:[RestaurantOrderCell class] forCellReuseIdentifier:NSStringFromClass([RestaurantOrderCell class])];
    [_rightTableView registerClass:[RestaurantHeaderFooterView class] forHeaderFooterViewReuseIdentifier:NSStringFromClass([RestaurantHeaderFooterView class])];


}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (tableView == _leftTableView) {
        return 1;
    }
    else {
        return _rightTabDataArr.count;
    }
}
//-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
//    return _leftTabDataArr[section];
//}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (tableView == _leftTableView) {
        return nil;
    } else {

        RestaurantHeaderFooterView *header = [tableView dequeueReusableHeaderFooterViewWithIdentifier:NSStringFromClass([RestaurantHeaderFooterView class])];
        header.textLabel.text = _leftTabDataArr[section];

        return header;
    }
}


-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (tableView == _leftTableView) {
        return 0;
    } else {
        return 30;
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (tableView == _leftTableView) {
        return 0;
    } else {
        return 0.001;
    }
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView == _leftTableView) {
        return _leftTabDataArr.count;
    } else {
        
         DishesInfoModel *  model = _rightTabDataArr[section];
        
        
        return model.storeProductVoList.count;
    }

}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == _leftTableView) {
        return 60;
    } else  {
//        Class currentClass = [RestaurantOrderCell class];
//
//        DishesDetailModel *model =  [DishesDetailModel mj_objectWithKeyValues:self.rightTabDataArr[indexPath.row]];
//
//        return [_rightTableView cellHeightForIndexPath:indexPath model:model keyPath:@"model" cellClass:currentClass contentViewWidth:[self cellContentViewWith]];
        return 100;
    }

}
- (CGFloat)cellContentViewWith
{
    CGFloat width = [UIScreen mainScreen].bounds.size.width;

    // 适配ios7横屏
    if ([UIApplication sharedApplication].statusBarOrientation != UIInterfaceOrientationPortrait && [[UIDevice currentDevice].systemVersion floatValue] < 8) {
        width = [UIScreen mainScreen].bounds.size.height;
    }
    return width;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == _leftTableView) {

        DishesCategoryCell *menuCell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([DishesCategoryCell class]) forIndexPath:indexPath];

                 
                menuCell.categoryLabel.text = _leftTabDataArr[indexPath.row];
                menuCell.backgroundColor = _leftTableView.backgroundColor;
        
        return menuCell;
    } else {

        // 定义cell标识  每个cell对应一个自己的标识
        NSString *CellIdentifier = [NSString stringWithFormat:@"cell%ld%ld",indexPath.section,indexPath.row];
        // 通过不同标识创建cell实例
        RestaurantOrderCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        // 判断为空进行初始化  --（当拉动页面显示超过主页面内容的时候就会重用之前的cell，而不会再次初始化）
        if (!cell) {
            cell = [[RestaurantOrderCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
        }
         DishesInfoModel *model = _rightTabDataArr[indexPath.section];
        DishesDetailModel * cellmodel = model.storeProductVoList[indexPath.row];
        cell.model = cellmodel;
        
        if ([_isbook isEqualToString:@"1"]) {
            
            //判断每道菜的数量
            if (_dictary.count!=0) {
                
                for (int i =0; i<_dictary.count; i++) {
                    
                    NSDictionary * dict = _dictary[i];
                    NSString * indexstr = dict[@"index"];
                    
                    if ([indexstr isEqualToString:[NSString stringWithFormat:@"%ld%ld",indexPath.section,indexPath.row]]) {
                        
                        cell.numLabel.hidden = NO;
                        cell.subtractBT.hidden = NO;
                        cell.numLabel.text = dict[@"number"];
                    }
                    
                }
                
            }else
            {
                cell.numLabel.hidden = YES;
                cell.subtractBT.hidden = YES;
                cell.numLabel.text = @"0";
            }
            
        }else{
            
            cell.numLabel.hidden = YES;
            cell.subtractBT.hidden = YES;
            cell.addBT.hidden = YES;
        }

        /** 通过左边转换得到抛物线的起点和终点 **/
        __weak __typeof(&*cell)weakCell = cell;
        __block __typeof(self)bself = self;
        cell.plusBlock = ^(NSInteger nCount, BOOL animated){
            /**
             *   给当前选中商品添加一个数量
             */
//            NSMutableDictionary *dic  = [self.rightTabDataArr[indexPath.row] mj_keyValues];
//            [dic setObject:[NSNumber numberWithInteger:nCount] forKey:@"orderCount"];
            /** 通过左边转换得到抛物线的起点和终点 **/
            CGRect parentRectA = [weakCell convertRect:weakCell.addBT.frame toView:self.view];
            CGRect parentRectB = [[ShoppingCartSingletonView shareManagerWithParentView:self.parentViewController.view] convertRect:[ShoppingCartSingletonView shareManagerWithParentView:self.parentViewController.view].shoppingCartBtn.frame toView:self.view];
            /**
             *  是否执行添加的动画
             */
            if (animated) {
                [bself.view addSubview:self.redView];
                [[ThrowLineTool sharedTool] throwObject:self.redView from:parentRectA.origin to:parentRectB.origin];
                
                if (_sum==0) {
                    
                    _sum = [cellmodel.fee floatValue];
                    
                }
                else
                {
                    _sum = _sum + [cellmodel.fee floatValue];
                }
                
                _number +=1;
               
                NSMutableDictionary * dict = [NSMutableDictionary dictionary];
                [dict setObject:cellmodel.images forKey:@"image"];
                [dict setObject:cellmodel.productName forKey:@"name"];
                [dict setObject:cellmodel.fee forKey:@"fee"];
                [dict setObject:[NSString stringWithFormat:@"%ld",cell.number] forKey:@"number"];
                 [dict setObject:[NSString stringWithFormat:@"%ld%ld",indexPath.section,indexPath.row] forKey:@"index"];
                
                [dict setObject:cellmodel.productId forKey:@"id"];
               
                
                    [_dictary enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                       
                        if ([_dictary[idx][@"name"] isEqualToString:cellmodel.productName]) {
                            
                            [_dictary removeObjectAtIndex:idx];
                        }
                        
                    }];
                
                    [_dictary addObject:dict];
                    
                     
            } else{
                _sum = _sum - [cellmodel.fee floatValue];
                _number -=1;
                
                
                NSMutableDictionary * dict = [NSMutableDictionary dictionary];
                [dict setObject:cellmodel.images forKey:@"image"];
                [dict setObject:cellmodel.productName forKey:@"name"];
                [dict setObject:cellmodel.fee forKey:@"fee"];
                [dict setObject:[NSString stringWithFormat:@"%ld",cell.number] forKey:@"number"];
                [dict setObject:cellmodel.productId forKey:@"id"];
                
                [dict setObject:[NSString stringWithFormat:@"%ld%ld",indexPath.section,indexPath.row] forKey:@"index"];
                
                for (int i =0; i<_dictary.count; i++) {
                    
                    NSMutableDictionary * dictt = _dictary[i];
                    
                    NSString * namestr = dictt[@"name"];
                    if ([namestr isEqualToString:cellmodel.productName]) {
                        
                        [_dictary removeObject:dictt];
                    }
                    
                }
     
                
                if (cell.number!=0) {
                    
                    [_dictary addObject:dict];

                }
                if (self.block) {
                    
                    self.block (_number,_sum,_dictary);
                }
            }
            

           
        };

        ////// 此步设置用于实现cell的frame缓存，可以让tableview滑动更加流畅 //////

//        [cell useCellFrameCacheWithIndexPath:indexPath tableView:tableView];
        return cell;
    }

}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == _leftTableView) {
        
        
        NSIndexPath *moveToIndexPath = [NSIndexPath indexPathForRow:0 inSection:indexPath.row];

        [_rightTableView selectRowAtIndexPath:moveToIndexPath animated:YES scrollPosition:UITableViewScrollPositionTop];
        _isEndAnimation = NO;
        [self.rightTableView deselectRowAtIndexPath:moveToIndexPath animated:YES];


    } else if (tableView ==_rightTableView){
        
        RestaurantOrderCell * cell = [_rightTableView cellForRowAtIndexPath:indexPath];
        
         DishesInfoModel *model = _rightTabDataArr[indexPath.section];
        
        __weak NSString * numlabelstr = nil;
        
        if (cell.numLabel.text==nil) {
            numlabelstr = @"0";
        }
        else{
            numlabelstr = cell.numLabel.text;
        }
        CGRect rect =  CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
        if (_IsExist==NO) {
            _IsExist = YES;

            _detailview = [[DishdetailView alloc]initWithFrame:rect withString:numlabelstr];
            _detailview.block = ^(NSInteger num,float sum,NSMutableArray * dictary,BOOL click,BOOL Isexit){
                
                if (Isexit==YES) {
                    
                    _number = num;
                    _sum = sum;
                    _dictary = dictary;//获取信息 在本页面加菜时候继续添加
                    
                    //根据菜品详情页面返回值刷新cell
                    __weak NSString * numm = nil;
                    for (NSDictionary * dict in dictary) {
                        
                        if ([dict[@"name"] isEqualToString:cell.titleLabel.text]) {
                            
                            numm = dict[@"number"];
                        }
                        
                    }
                    cell.numLabel.text = numm;
                    
                    [_rightTableView reloadRowsAtIndexPaths:
                     @[indexPath]withRowAnimation:UITableViewRowAnimationAutomatic];
                    
                    
                    [_dictary enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                        if ([_dictary[idx][@"number"] isEqualToString:@"0"]) {
                            
                            [_dictary removeObjectAtIndex:idx];
                        }
                        
                        
                    }];
                    
                    
                    if (click==NO) {//减得时候 传， 加菜放在动画结束传值
                        if (self.block) {
                            
                            self.block(_number,_sum,_dictary);//将获取到的菜品信息传给购物车
                        }
                        
                    }

                }else{
                    _IsExist = Isexit;
                }
                
                
            };
            _detailview.model = model.storeProductVoList[indexPath.row];
            //        detailview.dishnumlabel.text = cell.numLabel.text;
            _detailview.num = _number;
            _detailview.sum = _sum;
            _detailview.pushint = 1;
            _detailview.IsExist = _IsExist;
            _detailview.indexstr = [NSString stringWithFormat:@"%ld%ld",indexPath.section,indexPath.row];//model取不到，传过去
            if (_dictary.count!=0) {
                _detailview.dishdict = _dictary;
                
            }
            [self.view addSubview:_detailview];
            [_detailview updateLayout];
            _detailview.transform = CGAffineTransformMakeScale(0.2, 0.2);
            _detailview.alpha = 0;
            self.view.userInteractionEnabled = NO;
            [UIView animateWithDuration:.35 animations:^{
                _detailview.alpha = 1;
                _detailview.transform = CGAffineTransformMakeScale(1, 1);
                self.view.userInteractionEnabled = YES;
                
            }];
            //        

        }
      
    }
}

/** 右侧滑动左侧联动 **/
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{

    if (scrollView == _rightTableView) {

        if (_isEndAnimation == YES) {

            NSIndexPath *topHeaderViewIndexpath  = [[_rightTableView indexPathsForVisibleRows] firstObject];
            NSIndexPath *moveToIndexPath = [NSIndexPath indexPathForRow:topHeaderViewIndexpath.section inSection:0];
            [self.leftTableView selectRowAtIndexPath:moveToIndexPath animated:YES scrollPosition:UITableViewScrollPositionMiddle];

        }
    }
    if (scrollView == self.leftTableView) {
        return;
    }
    
}
-(void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView{
    _isEndAnimation = YES;
}
#pragma mark - 设置购物车动画
- (void)animationDidFinish
{

    [self.redView removeFromSuperview];
//    [UIView animateWithDuration:0.1 animations:^{
//        [ShoppingCartSingletonView shareManagerWithParentView:self.parentViewController.view].shoppingCartBtn.transform = CGAffineTransformMakeScale(0.8, 0.8);
//    } completion:^(BOOL finished) {
//        [UIView animateWithDuration:0.1 animations:^{
//            [ShoppingCartSingletonView shareManagerWithParentView:self.parentViewController.view].shoppingCartBtn.transform = CGAffineTransformMakeScale(1, 1);
//        } completion:^(BOOL finished) {
//
//        }];
//
//    }];
    
    if (self.block) {
        
        self.block (_number,_sum,_dictary);
    }
    
    
    
    
}

#pragma mark - 通知更新
-(void)UpdatemainUI:(NSNotification *)Notification{

    NSMutableDictionary *dic =[NSMutableDictionary dictionaryWithDictionary: Notification.userInfo];
    //重新计算订单数组。

    DishesInfomationVC *dishesVC = [[DishesInfomationVC alloc] init];

    self.ordersArray = [ViewModel storeOrders:dic[@"update"] OrderData:self.ordersArray isAdded:[dic[@"isAdd"] boolValue]];
    [ShoppingCartSingletonView shareManagerWithParentView:dishesVC.view].OrderList.objects = self.ordersArray;
    //设置高度。
    [[ShoppingCartSingletonView shareManagerWithParentView:dishesVC.view] updateFrame:[ShoppingCartSingletonView shareManagerWithParentView:self.parentViewController.view].OrderList];
    [[ShoppingCartSingletonView shareManagerWithParentView:dishesVC.view].OrderList.tableView reloadData];
    //设置数量、价格
    [ShoppingCartSingletonView shareManagerWithParentView:dishesVC.view].badgeValue =  [ViewModel CountOthersWithorderData:self.ordersArray];
    double price = [ViewModel GetTotalPrice:self.ordersArray];
    [[ShoppingCartSingletonView shareManagerWithParentView:dishesVC.view] setTotalMoney:price];
    //重新设置数据源
    self.rightTabDataArr = [ViewModel UpdateArray:self.rightTabDataArr atSelectDictionary:dic[@"update"]];
    [self.rightTableView reloadData];

}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self forKeyPath:@"updateUI"];
//    [[NSNotificationCenter defaultCenter] removeObserver:self forKeyPath:@"changedine"];
//    [[NSNotificationCenter defaultCenter] removeObserver:self forKeyPath:@"remove"];
    
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
