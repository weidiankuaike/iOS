//
//  AddOrderViewController.m
//  wdKuaiKe_iOS
//
//  Created by 张森森 on 17/2/28.
//  Copyright © 2017年 weiDianKuaiKe. All rights reserved.
//

#import "AddOrderViewController.h"
#import "RestaurantOrderCell.h"
#import "DishesCategoryCell.h"
#import "RestaurantHeaderFooterView.h"
#import "DishesInfoModel.h"
#import "MBProgressHUD+SS.h"
#import "QYXNetTool.h"
#import "NSObject+JudgeNull.h"
#import "PayViewController.h"
#import "PaydetailViewController.h"
#import "DishdetailView.h"
@interface AddOrderViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) NSMutableArray *dictary;
@property (nonatomic, strong) NSMutableArray *rightTabDataArr;
@property (nonatomic, strong)UITableView *leftTableView;
@property (nonatomic, strong)UITableView *rightTableView;
@property (nonatomic, assign) BOOL isEndAnimation;
@property (nonatomic, strong) UIImageView *redView;
@property (nonatomic, strong) NSMutableArray *leftTabDataArr;
//@property (nonatomic,strong) ShoppingCartView *shoppcartview;
//订单数据
@property (nonatomic,strong) NSMutableArray *ordersArray;
@property (nonatomic,strong) UIButton * addOrderbtn;
@property (nonatomic,assign) float sum;
@property (nonatomic,assign) NSInteger number;
@property (nonatomic,assign) BOOL IsExit;
@end

@implementation AddOrderViewController
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
    
    self.title = @"加菜";
    self.view.backgroundColor = [UIColor whiteColor];
    _isEndAnimation = YES;
    _IsExit = YES;
    self.rightTabDataArr = [NSMutableArray new];
    _dictary = [NSMutableArray array];
    _leftTabDataArr = [NSMutableArray array];
    [self GetData];
    [self Creatbottom];
    
}
#pragma mark 网络请求
-(void)GetData
{
    
    NSString * urlstr = [NSString stringWithFormat:@"%@/getStoreProductData?token=%@&storeId=%@&userId=%@",commonUrl,Token,_storeid,Userid];
    NSArray * urlary = [urlstr componentsSeparatedByString:@"?"];
    [MBProgressHUD showMessage:@"请稍等"];
    [[QYXNetTool shareManager] postNetWithUrl:urlary.firstObject urlBody:urlary.lastObject bodyStyle:QYXBodyString header:nil response:QYXJSON success:^(id result)
     {
         
         [MBProgressHUD hideHUD];
         if (![[result objectForKey:@"obj"] isNull]) {
             NSArray * objdict = [result objectForKey:@"obj"];
             for (int i =0; i<objdict.count; i++) {
                 
                 DishesInfoModel * model = [DishesInfoModel mj_objectWithKeyValues:objdict[i]];
                 
                 if (model.storeProductVoList!=nil) {
                     
                     [_leftTabDataArr addObject:model.productCategory];
                     
                     [_rightTabDataArr addObject:model];
                 }
                 
             }
             [self setupCategoryButtuon];
             
         }
     } failure:^(NSError *error) {
         [MBProgressHUD hideHUD];
         [MBProgressHUD showError:@"网络请求错误"];
     }];
}

#pragma mark 创建底部视图
- (void)Creatbottom{
    
    _addOrderbtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_addOrderbtn setTitle:@"加菜" forState:UIControlStateNormal];
    [_addOrderbtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _addOrderbtn.backgroundColor = [UIColor lightGrayColor];
    _addOrderbtn.userInteractionEnabled = NO;
    [_addOrderbtn addTarget:self action:@selector(addOrder) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_addOrderbtn];
    _addOrderbtn.sd_layout.leftSpaceToView(self.view,0).rightSpaceToView(self.view,0).bottomSpaceToView(self.view,0).heightIs(autoScaleH(40));
}
//创建两个表
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
    .bottomSpaceToView(self.view, autoScaleH(40));
    
    _leftTableView.separatorStyle = 0;
    _leftTableView.backgroundColor = RGB(238, 238, 238);
    _leftTableView.delegate = self;
    _leftTableView.dataSource = self;
    
    //    _leftTableView.contentInset = UIEdgeInsetsMake(-35, 0, 0, 0);
    _leftTableView.bounces = NO;
    
    
    [_leftTableView registerClass:[DishesCategoryCell class] forCellReuseIdentifier:NSStringFromClass([DishesCategoryCell class])];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    [_leftTableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionTop];
    
    
    
    /** 右边tableView **/
    
    _rightTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    [self.view addSubview:_rightTableView];
    
    _rightTableView.sd_layout
    .leftSpaceToView(_leftTableView, 0)
    .rightEqualToView(self.view)
    .topSpaceToView(topSeparator, 0)
    .bottomSpaceToView(self.view, autoScaleH(40));
    
    _rightTableView.separatorStyle = 0;
    _rightTableView.backgroundColor = _leftTableView.backgroundColor;
    _rightTableView.delegate = self;
    _rightTableView.dataSource = self;
    
    
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

        
        /** 通过左边转换得到抛物线的起点和终点 **/
        __weak __typeof(&*cell)weakCell = cell;
        __block __typeof(self)bself = self;
        cell.plusBlock = ^(NSInteger nCount, BOOL animated){
                        /**
             *  是否执行添加的动画
             */
            if (animated) {
               
                
                if (_sum==0) {
                    
                    _sum = [cellmodel.fee floatValue];
                    
                }
                else
                {
                    _sum = _sum + [cellmodel.fee floatValue];
                }
                
                _number +=1;
                NSMutableDictionary * dict = [NSMutableDictionary dictionary];
                                [dict setObject:cellmodel.fee forKey:@"fee"];
                [dict setObject:[NSString stringWithFormat:@"%ld",cell.number] forKey:@"number"];
                
                [dict setObject:cellmodel.productName forKey:@"name"];
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
                
                [dict setObject:[NSString stringWithFormat:@"%ld",indexPath.row] forKey:@"index"];
                
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
                

            }
            
            if (_sum!=0) {
                
                [_addOrderbtn setTitle:[NSString stringWithFormat:@"加菜(￥%.2f)",_sum] forState:UIControlStateNormal];
                [_addOrderbtn setBackgroundColor:UIColorFromRGB(0xfd7577)];
                _addOrderbtn.userInteractionEnabled = YES;
                
            }else{
                [_addOrderbtn setTitle:@"加菜" forState:UIControlStateNormal];
                [_addOrderbtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                _addOrderbtn.backgroundColor = [UIColor lightGrayColor];
            }
        
        };
        
     return cell;
    }
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == _leftTableView) {
        
        
        NSIndexPath *moveToIndexPath = [NSIndexPath indexPathForRow:0 inSection:indexPath.row];
        
        [_rightTableView selectRowAtIndexPath:moveToIndexPath animated:YES scrollPosition:UITableViewScrollPositionTop];
        _isEndAnimation = NO;
        [self.rightTableView deselectRowAtIndexPath:moveToIndexPath animated:YES];
        
        
    }else if (tableView ==_rightTableView){
        
        if (_IsExit==NO) {
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
            _IsExit = YES;
            DishdetailView * detailview = [[DishdetailView alloc]initWithFrame:rect withString:numlabelstr];
            detailview.block = ^(NSInteger num,float sum,NSMutableArray * dictary,BOOL click,BOOL Isexit){
                
                
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
                    
                    
                    for (NSMutableDictionary * dict in _dictary) {//如果数量为零 清除
                        
                        if ([dict[@"number"] isEqualToString:@"0"]) {
                            
                            [_dictary removeObject:dict];
                        }
                    }
                    //根据回调 改变底部按钮状态
                    if (_sum!=0) {
                        
                        [_addOrderbtn setTitle:[NSString stringWithFormat:@"加菜(￥%.2f)",_sum] forState:UIControlStateNormal];
                        [_addOrderbtn setBackgroundColor:UIColorFromRGB(0xfd7577)];
                        _addOrderbtn.userInteractionEnabled = YES;
                        
                    }else{
                        [_addOrderbtn setTitle:@"加菜" forState:UIControlStateNormal];
                        [_addOrderbtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                        _addOrderbtn.backgroundColor = [UIColor lightGrayColor];
                    }
                    
                }else{
                    
                    _IsExit = Isexit;
                }
                
            };
            detailview.model = model.storeProductVoList[indexPath.row];
            //        detailview.dishnumlabel.text = cell.numLabel.text;
            detailview.num = _number;
            detailview.sum = _sum;
            detailview.IsExist = _IsExit;
            detailview.indexstr = [NSString stringWithFormat:@"%ld%ld",indexPath.section,indexPath.row];//model取不到，传过去
            if (_dictary.count!=0) {
                detailview.dishdict = _dictary;
                
            }
            [self.view addSubview:detailview];
            [detailview updateLayout];
            detailview.transform = CGAffineTransformMakeScale(0.2, 0.2);
            detailview.alpha = 0;
            self.view.userInteractionEnabled = NO;
            [UIView animateWithDuration:.35 animations:^{
                detailview.alpha = 1;
                detailview.transform = CGAffineTransformMakeScale(1, 1);
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
             // 取出显示在 视图 且最靠上 的 cell 的 indexPath
            NSIndexPath *topHeaderViewIndexpath  = [[_rightTableView indexPathsForVisibleRows] firstObject];
            // 左侧 talbelView 移动的 indexPath
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
- (void)addOrder
{
    PaydetailViewController * payDetsailVc = [[PaydetailViewController alloc]init];
    payDetsailVc.orderId = _orderid;
    payDetsailVc.storeId = _storeid;
    payDetsailVc.dishesAry = _dictary;
    payDetsailVc.sum = _sum;
    [self.navigationController pushViewController:payDetsailVc animated:YES];

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
