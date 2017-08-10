                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                             //
//  SearchViewController.m
//  wdKuaiKe_iOS
//
//  Created by Skyer God on 16/8/9.
//  Copyright © 2016年 weiDianKuaiKe. All rights reserved.
//

#import "SearchViewController.h"
#import "UIBarButtonItem+SSExtension.h"
#import "MBProgressHUD+SS.h"
#import "QYXNetTool.h"
#import "SearchdishModel.h"
#import "SearchStoreModel.h"
#import "NSObject+JudgeNull.h"
#import "SearchDishTableViewCell.h"
#import "SearchStoreTableViewCell.h"
#import "NewMerchantVC.h"
#import "HomeTableViewCell.h"
#import "SiftView.h"
#import "MJRefreshNormalHeader.h"
#import "MJRefreshAutoNormalFooter.h"
@interface SearchViewController ()<UITableViewDelegate, UITableViewDataSource,UITextFieldDelegate,UIGestureRecognizerDelegate>
{
    //数据源的表格
    UITableView * _tableView;
    //数据源
     NSMutableArray * _dataArray;
    //搜索结果的数组
    NSMutableArray * _searchArray;
    //搜索视图
    UISearchController * _searchVC;//(ios 8.0 and later)
    //搜索结果的表格视图
    UITableView * searchTableView;
    UITextField *customSearchBar;
    UIButton * searchbtn;
    NSMutableArray * historyArray;//存储数据数组
    NSArray * btnary ;
    NSMutableArray *_searTXT;
    CGFloat length;
    UIView * headview ;
    NSMutableArray * modelary;
    NSMutableArray * dishmodelary;
    NSString * searchstr;//要搜索的值
    
}
@property (nonatomic,copy)NSString * iswait;//是否排队
@property (nonatomic,copy)NSString * sorttype;//排序类型
@property (nonatomic,strong) UIView * tableheadview;
@property (nonatomic,strong)SiftView * chooseview;
@property (nonatomic,assign)NSInteger pagenum;
@property (nonatomic,strong)UIButton * daitiBtn;
@property (nonatomic,strong)NSMutableArray * btnAry;
@end
static int a=0;
@implementation SearchViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = NO;
    self.navigationController.navigationBar.translucent = NO;
    [self.navigationController.navigationBar setBarTintColor:UIColorFromRGB(0xfd7577)];
    self.tabBarController.tabBar.hidden = YES;
    searchbtn.hidden = NO;
    customSearchBar.hidden = NO;

    //    [self readNSUserDefaults];
    
   
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    searchbtn.hidden = YES;
    customSearchBar.hidden = YES;
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
   
    self.view.backgroundColor = [UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    CGRect mainViewBounds = self.navigationController.view.bounds;
    customSearchBar = [[UITextField alloc] initWithFrame:CGRectMake(CGRectGetWidth(mainViewBounds)/2-((CGRectGetWidth(mainViewBounds)-120)/2), CGRectGetMinY(mainViewBounds)+30, CGRectGetWidth(mainViewBounds)-120, 30)];
    customSearchBar.delegate = self;
    customSearchBar.backgroundColor = [UIColor whiteColor];
    customSearchBar.placeholder = @"请输入商家名或菜名";
    customSearchBar.layer.masksToBounds = YES;
    customSearchBar.layer.cornerRadius = 3;
    customSearchBar.layer.borderWidth = 1;
    customSearchBar.layer.borderColor = [UIColor whiteColor].CGColor;
    customSearchBar.textAlignment = NSTextAlignmentCenter;
    customSearchBar.font = [UIFont systemFontOfSize:autoScaleW(13)];
    customSearchBar.clearButtonMode = UITextFieldViewModeAlways;
    [self.navigationController.view addSubview: customSearchBar];
    
    searchbtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [searchbtn setBackgroundImage:[UIImage imageNamed:@"icon_search"] forState:UIControlStateNormal];
    [searchbtn addTarget:self action:@selector(Search) forControlEvents:UIControlEventTouchUpInside];
    [self.navigationController.view addSubview:searchbtn];
    searchbtn.sd_layout.leftSpaceToView(customSearchBar,10).topSpaceToView(self.navigationController.view,CGRectGetMinY(mainViewBounds)+35).widthIs(20).heightIs(20);
    
    UIBarButtonItem * backbtn = [UIBarButtonItem itemWithTarget:self Action:@selector(Back) image:@"left-1" selectImage:nil];
    self.navigationItem.leftBarButtonItem = backbtn;
    
    UITapGestureRecognizer * removetap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(RemoveChooseview)];
    removetap.delegate = self;
    [self.view addGestureRecognizer:removetap];
    
    modelary = [NSMutableArray array];
    dishmodelary = [NSMutableArray array];
    
    _iswait = @"0";
    _sorttype = @"";
    searchstr = @"";

//    searchTableView.header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
    
    // 马上进入刷新状态
    
    searchTableView.mj_footer.hidden = YES;

    
    if (_pushinteger==2) {
        
        headview.hidden = YES;
        [self Creatsiftbtn];
        [self Creattable];

        [self GetDate:YES];
        [searchTableView.mj_header beginRefreshing];
    }
    searchTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self GetDate:YES];
    }];
    searchTableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        [self GetDate:NO];
        
    }];
    
}
#pragma mark 点击搜索
- (void)Search
{
    if (customSearchBar.text.length==0) {
        
        [MBProgressHUD showError:@"搜索内容不能为空"];
        
    }
    else
    {
        [self SearchText:customSearchBar.text];
        [customSearchBar resignFirstResponder];
        
        headview.hidden = YES;
        searchstr = customSearchBar.text;
        _typestr = @"";
        [self GetDate:YES];
    }
}
-(void)SearchText:(NSString *)seaTxt
{
       if (_searTXT.count==0) {
        
        [_searTXT addObject:seaTxt];
        NSLog(@",.,%@",_searTXT);
        //将上述数据全部存储到NSUserDefaults中
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        [userDefaults setObject:_searTXT forKey:@"searchHistory"];

    }
    else
    {
            [_searTXT enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
                if (![obj isEqualToString:seaTxt]) {
        
                    [_searTXT addObject:seaTxt];
                    NSLog(@",.,%@",_searTXT);
                    //将上述数据全部存储到NSUserDefaults中
                    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
                    [userDefaults setObject:_searTXT forKey:@"searchHistory"];
                    
                    *stop = YES;
                }
            }];
    }
    
}
- (void)textFieldDidBeginEditing:(UITextField *)textField{
    
     //搜索历史显示，搜索结果和筛选按钮隐藏
    _chooseview.hidden = YES;
    _tableheadview.hidden = YES;
    searchTableView.hidden = YES;
    
//    if (headview) {
//        [headview removeFromSuperview];
//    }
    
    [self readNSUserDefaults];
    
    if (historyArray) {
        
        _searTXT = [historyArray mutableCopy];
    }
    else
    {
        _searTXT = [NSMutableArray array];
    }
   

}
-(void)readNSUserDefaults
{
    NSUserDefaults *userDefaultes = [NSUserDefaults standardUserDefaults];
    //读取数组NSArray类型的数据
    //    NSArray *myArray = [userDefaultes arrayForKey:@"searchHistory"];
    //    NSLog(@"myArray======%@",myArray);
    historyArray = [userDefaultes arrayForKey:@"searchHistory"];
    
    if (historyArray.count<=10) {
        
        historyArray = (NSMutableArray*)[[historyArray reverseObjectEnumerator] allObjects];
        btnary = (NSArray *)historyArray ;
    }
    else
    {
        historyArray = (NSMutableArray*)[[historyArray reverseObjectEnumerator] allObjects];
        btnary = [historyArray subarrayWithRange:NSMakeRange(0, 10)];
       
    }
    if (btnary.count!=0) {
        [self Createheadview];
    }
    
}
#pragma mark 历史搜索记录视图
- (void)Createheadview
{
    headview = [[UIView alloc]init];
    headview.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:headview];
    headview.sd_layout.leftEqualToView(self.view).rightEqualToView(self.view).topSpaceToView(self.view,0).heightIs(GetHeight/2);
    
    CGFloat w = 0;//保存前一个button的宽以及前一个button距离屏幕边缘的距离
    CGFloat h = 15;//用来控制button距离父视图的高
    for (int i = 0; i < btnary.count; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
        button.tag = 100 + i;
        button.backgroundColor = [UIColor clearColor];
        
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        //根据计算文字的大小
        button.titleLabel.font = [UIFont systemFontOfSize:13];
        NSDictionary *attributes = @{NSFontAttributeName:[UIFont systemFontOfSize:13]};
        length = [btnary[i] boundingRectWithSize:CGSizeMake(320, 2000) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size.width;
        //为button赋值
        [button setTitle:btnary[i] forState:UIControlStateNormal];
        //设置button的frame
        button.frame = CGRectMake(10 + w, h, length + 15 , 30);
        //当button的位置超出屏幕边缘时换行 320 只是button所在父视图的宽度
        if(10 + w + length + 15 > GetWidth){
            w = 0; //换行时将w置为0
            h = h + button.frame.size.height + 10;//距离父视图也变化
            button.frame = CGRectMake(10 + w, h, length + 15, 30);//重设button的frame
        }
        w = button.frame.size.width + button.frame.origin.x;
        [button addTarget:self action:@selector(handleClick:) forControlEvents:UIControlEventTouchUpInside];
        [headview addSubview:button];
    
    }
    UILabel * linelabel = [[UILabel alloc]init];
    linelabel.backgroundColor = [UIColor lightGrayColor];
    [headview addSubview:linelabel];
    linelabel.sd_layout.leftEqualToView(headview).rightEqualToView(headview).topSpaceToView(headview,h+45).heightIs(1);
    
    UIButton * leftbtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [leftbtn addTarget:self action:@selector(Clear) forControlEvents:UIControlEventTouchUpInside];
    [headview addSubview:leftbtn];
    leftbtn.sd_layout.centerXEqualToView(self.view).topSpaceToView(linelabel,autoScaleH(10)).widthIs(autoScaleW(50)).heightIs(autoScaleH(15));
    
    UILabel * qklabel = [[UILabel alloc]init];
    qklabel.text = @"清空";
    qklabel.textColor = [UIColor blackColor];
    qklabel.font =  [UIFont systemFontOfSize:autoScaleW(13)];
    [leftbtn addSubview:qklabel];
    qklabel.sd_layout.leftEqualToView(leftbtn).topEqualToView(leftbtn).widthIs(30).heightIs(15);
    
    UIImageView * qkimage = [[UIImageView alloc]init];
    qkimage.image = [UIImage imageNamed:@"垃圾桶"];
    [leftbtn addSubview:qkimage];
    qkimage.sd_layout.leftSpaceToView(qklabel,autoScaleW(3)).topEqualToView(qklabel).widthIs(15).heightIs(15);
  
//    headview.hidden = YES;
    
    
}
#pragma mark 历史搜索记录点击方法
- (void)handleClick:(UIButton * )btn
{
    [customSearchBar resignFirstResponder];
    searchstr = btn.titleLabel.text;
    _typestr = @"";
    [self GetDate:YES];
    //搜索历史隐藏，搜索结果和筛选按钮显示
    

}
#pragma mark 清空
- (void)Clear{
    
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"searchHistory"];
    [headview removeFromSuperview];
      
    
}
-(void)endRefresh
{
    if (_pagenum == 1) {
        [searchTableView.mj_header endRefreshing];
    }
    [searchTableView.mj_footer endRefreshing];
}


#pragma mark 网络请求
- (void)GetDate:(BOOL)isrefresh
{
    if (isrefresh) {
        _pagenum = 1;
        //        isFirstCome = YES;
       [modelary removeAllObjects];
    }else{
        _pagenum++;
    }
    [MBProgressHUD showMessage:@"请稍等"];
    NSString * urlstr = [NSString stringWithFormat:@"%@/searchByContent?content=%@&pageNum=%ld&lat=%@&lng=%@&iswalt=%@&sortType=%@&catagory=%@",commonUrl,searchstr,_pagenum,_latstr,_lngstr,_iswait,_sorttype,_typestr];
    
    NSArray * urlary = [urlstr componentsSeparatedByString:@"?"];
    
    [[QYXNetTool shareManager]postNetWithUrl:urlary.firstObject urlBody:urlary.lastObject bodyStyle:QYXBodyString header:nil response:QYXJSON success:^(id result){
        NSLog(@",.,.,.,.,,.,.%@",result);
        [MBProgressHUD hideHUD];
        [self endRefresh];
        
        if (![[result objectForKey:@"obj"] isNull]) {
            
            
            [headview removeFromSuperview];
           
            NSString * pagestr = [result objectForKey:@"flag"];
            if ([pagestr integerValue]<=_pagenum) {
                
                searchTableView.mj_footer.hidden = YES;
            }

            _pushinteger = 2;
            
            NSArray * objary = [result objectForKey:@"obj"];
            
            for (int i =0; i<objary.count; i++) {
                
                SearchStoreModel * model = [SearchStoreModel mj_objectWithKeyValues:objary[i]];
                
                [modelary addObject:model];
                
            }
            
            if (_tableheadview) {
                
                _tableheadview.hidden = NO;
            }
            else
            {
                [self Creatsiftbtn];

            }
            if (searchTableView) {
                
                searchTableView.hidden = NO;
                
                [searchTableView reloadData];
                
            }
            else
            {
                [self Creattable];
            }
        }else
        {
            [MBProgressHUD showError:@"没有匹配的商家"];
            headview.hidden = YES;
            [modelary removeAllObjects];
            if (searchTableView) {
                
                searchTableView.hidden = NO;
                [searchTableView reloadData];
                
            }
            else
            {
                [self Creattable];
            }
            
            
        }
        
    } failure:^(NSError *error) {
        
        [MBProgressHUD hideHUD];
        [self endRefresh];
    }];
    
    
}
#pragma mark 筛选按钮
- (void)Creatsiftbtn
{
    _tableheadview = [[UIView alloc]init];
    [self.view addSubview:_tableheadview];
    _tableheadview.sd_layout.leftEqualToView(self.view).rightEqualToView(self.view).topEqualToView(self.view).heightIs(autoScaleH(40));
    
    _btnAry = [NSMutableArray array];
    NSArray * choosetitle = @[@"全部分类",@"全部餐厅",@"离我最近"];
    for (int i=0; i<choosetitle.count; i++) {
        UIButton * choosebtn = [[UIButton alloc]init];
        choosebtn.titleLabel.font = [UIFont systemFontOfSize:autoScaleW(15)];
        [choosebtn setTitle:choosetitle[i] forState:UIControlStateNormal];
        [choosebtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [choosebtn setTitleColor:UIColorFromRGB(0xfd7577) forState:UIControlStateSelected];
        [choosebtn setBackgroundColor:RGB(238, 238, 238)];
        choosebtn.tag = 600+i;
        [choosebtn addTarget:self action:@selector(Sift:) forControlEvents:UIControlEventTouchUpInside];
        
        
        if (i==0||i==1) {
            
            UILabel * linelabel = [[UILabel alloc]init];
            linelabel.backgroundColor = [UIColor blackColor];
            [choosebtn addSubview:linelabel];
            linelabel.sd_layout.rightSpaceToView(choosebtn,0).topSpaceToView(choosebtn,autoScaleH(10)).widthIs(1).heightIs(30);
            
        }

        [_tableheadview addSubview:choosebtn];
        choosebtn.sd_layout.leftSpaceToView(_tableheadview,i*(GetWidth/3)).topSpaceToView(_tableheadview,0).widthIs(GetWidth/3).heightIs(autoScaleH(50));
        
        [_btnAry addObject:choosebtn];
        
    }
    if (_pushinteger!=2) {
        
        _tableheadview.hidden = YES;
    }
}
#pragma mark 创建表
- (void)Creattable
{
    searchTableView = [[UITableView alloc]init];
    searchTableView.delegate = self;
    searchTableView.dataSource = self;
    searchTableView.separatorStyle = 0;
    searchTableView.showsVerticalScrollIndicator = NO;
//    [searchTableView registerClass:[HomeTableViewCell class] forCellReuseIdentifier:@"store"];
    [searchTableView registerClass:[SearchDishTableViewCell class] forCellReuseIdentifier:@"dish"];
    
    [self.view addSubview:searchTableView];
    searchTableView.sd_layout.leftEqualToView(self.view).rightEqualToView(self.view).topSpaceToView(self.view,autoScaleH(50)).heightIs(self.view.frame.size.height - autoScaleH(100));
}
#pragma mark 判断手势跟cell方法是否冲突
-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    if ([NSStringFromClass([touch.view class]) isEqualToString:@"UITableViewCellContentView"]) {
        //返回为NO则屏蔽手势事件
        return NO;
    }
    return YES;

}

#pragma mark 数据源方法
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return modelary.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    SearchStoreModel * model = modelary[section];
    if (model.voList.count==0) {
        
        return 1;
        
    }
    
    return model.voList.count +1;
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row==0) {
        NSString *str = [NSString stringWithFormat:@"%ld", indexPath.section];
        HomeTableViewCell * storecell = [tableView dequeueReusableCellWithIdentifier:str];
        if (!storecell) {
            
            storecell = [[HomeTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:str];
        }
    if (_latstr ==nil) {
            
            storecell.distancelabel.hidden = YES;
        }
        SearchStoreModel * model = modelary[indexPath.section];
        storecell.model = model;
        
        storecell.selectionStyle = 0;
        
        UILabel * linelabel = [[UILabel alloc]init];
        linelabel.backgroundColor = UIColorFromRGB(0xeeeeee);
        [storecell addSubview:linelabel];
        linelabel.sd_layout.leftEqualToView(storecell).rightEqualToView(storecell).bottomEqualToView(storecell).heightIs(1);
        
        return storecell;
    }
    else
    {
        SearchDishTableViewCell * dishcell = [tableView dequeueReusableCellWithIdentifier:@"dish" forIndexPath:indexPath];
        dishcell.selectionStyle = 0;
        
        SearchStoreModel *model = modelary[indexPath.section];
        SearchdishModel * cellmodel = model.voList[indexPath.row -1];
        dishcell.model = cellmodel;
        
        UILabel * linelabel = [[UILabel alloc]init];
        linelabel.backgroundColor = UIColorFromRGB(0xeeeeee);
        [dishcell addSubview:linelabel];
        linelabel.sd_layout.leftEqualToView(dishcell).rightEqualToView(dishcell).bottomEqualToView(dishcell).heightIs(1);
        
        return dishcell;
    }
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row==0) {
        
        SearchStoreModel * model = modelary[indexPath.section];
        NewMerchantVC * merVc = [[NewMerchantVC alloc]init];
        merVc.idstr = model.storeId;
        merVc.titlestr = model.storeName;
        merVc.starstr = model.avgScore;
        merVc.orderCount = 1;
        [self.navigationController pushViewController:merVc animated:YES];
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row!=0) {
        
        return 60;
    }else{
        
        return [tableView cellHeightForIndexPath:indexPath cellContentViewWidth:[self cellContentViewWith] tableView:tableView];
    }
 }
- (void)Sift:(UIButton*)btn
{
    
    for (UIButton * selectBtn in _btnAry) {
        
        if (selectBtn.tag == btn.tag) {
            
            selectBtn.selected = YES;
        }else{
            
            selectBtn.selected = NO;
        }
    }
    
    
    if (a==0) {
        searchstr = @"";
        _pagenum = 1;
        searchTableView.mj_footer.hidden = NO;
        _daitiBtn = btn;
        [self creatChooseviewWithbtn:btn];
    }else{
        
        if (btn.tag== _daitiBtn.tag) {
            
            if (self.chooseview) {
                
                [self.chooseview removeFromSuperview];
            }
            a = 0;
            btn.selected = NO;
        }
        else{
            _daitiBtn = btn;
            [self creatChooseviewWithbtn:btn];
        }
    
    }
}
- (void)creatChooseviewWithbtn:(UIButton*)btn{//选择 视图
    
    NSArray * choosetitleary = nil;
    
    __weak typeof (self)weakself = self;
    
    if (btn.tag==600) {
        
        choosetitleary = @[@"全部",@"中餐", @"西餐", @"甜点饮品", @"烧烤烤肉", @"自助餐",
                           @"日韩料理", @"小吃快餐", @"特色炒菜"];
    }
    else if (btn.tag==601) {
        
        choosetitleary = @[@"当前不需要排队",@"全部商家"];
        
    }
    else if (btn.tag==602)
    {
        choosetitleary = @[@"默认排序",@"离我最近",@"评价最高",@"最新餐厅",@"价格最低",@"价格最高",@"成交最多"];
        
    }
    if (weakself.chooseview) {
        
        [weakself.chooseview removeFromSuperview];
    }
    weakself.chooseview = [[SiftView alloc]initWithary:choosetitleary];
    weakself.chooseview.block = ^(NSString *imtdtr)
    {
        weakself.chooseview.hidden = YES;
        if (btn.tag==600) {
            
            if ([imtdtr isEqualToString:@"全部"]) {
                
                _typestr = @"";
            }
            
            else
            {
                _typestr = imtdtr;
            }
            
            [self GetDate:YES];
        }
        if (btn.tag==601) {
            
            if ([imtdtr isEqualToString:@"全部"]) {
                
                _iswait = @"0";
            }
            else
            {
                _iswait = @"1";
            }
            [self GetDate:YES];
        }
        if (btn.tag==602) {
            
            _sorttype = imtdtr;
            if (![_sorttype isEqualToString:@"离我最近"]) {
                [self GetDate:YES];
                
            }
            else
            {
                if ([_lngstr isEqualToString:@""]) {
                    
                    UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"请在设置中打开您的位置" preferredStyle:UIAlertControllerStyleAlert];
                    __weak UIAlertAction * cancel = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:nil];
                    
                    [alert addAction:cancel];
                    
                    [self presentViewController:alert animated:YES completion:nil];
                }else{
                    [self GetDate:YES];
                }
                
            }
        }
        
        
        
    };
    
    weakself.chooseview.frame = CGRectMake(0,autoScaleH(40), GetWidth, choosetitleary.count*autoScaleH(35));
    
    [self.view addSubview:weakself.chooseview];
    
    a+=1;

}
#pragma mark 移除选择视图
- (void)RemoveChooseview
{
    if (_chooseview) {
        
        [_chooseview removeFromSuperview];
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
- (void)Back
{
    [customSearchBar resignFirstResponder];
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
