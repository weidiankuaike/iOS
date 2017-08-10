//
//  HasDineViewController.m
//  wdKuaiKe_iOS
//
//  Created by 张森森 on 17/1/4.
//  Copyright © 2017年 weiDianKuaiKe. All rights reserved.
//
#import "HasDineViewController.h"
#import "UIBarButtonItem+SSExtension.h"
#import "MBProgressHUD+SS.h"
#import "QYXNetTool.h"
#import "Dinemodel.h"
#import "NSObject+JudgeNull.h"
#import "PagingCollectionViewLayout.h"
#import "ZTPageControl.h"
#import "KitchenDishesCell.h"
@interface HasDineViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UIScrollViewDelegate>
@property (nonatomic,strong)UIButton * daitibtn;//代替按钮
@property (nonatomic,strong)NSMutableArray * modelary;//model数组
@property (nonatomic,strong)UICollectionView * dishesCollectionV;//菜品collectview
@property (nonatomic,copy)NSString * opertionstr;//网络请求判断参数
@property (nonatomic,strong)UIView * headview;//选择已上或未上的头视图
@property (nonatomic,strong)UIScrollView *orderscroll;//菜品滚动图
@property (nonatomic,strong)ZTPageControl * pagecontrol;
@property (nonatomic,assign)CGFloat height;//page高度
@end

@implementation HasDineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   
    self.view.backgroundColor = RGB(238, 238, 238);
    UILabel * titlabel = [[UILabel alloc]init];
    titlabel.frame = CGRectMake(0, 0, 80, 30);
    titlabel.textAlignment = NSTextAlignmentCenter;
    titlabel.font = [UIFont systemFontOfSize:15];
    titlabel.text = @"用餐服务";
    titlabel.textColor = [UIColor whiteColor];
    self.navigationItem.titleView = titlabel;
    UIBarButtonItem * backbtn = [UIBarButtonItem itemWithTarget:self Action:@selector(Back) image:@"left-1" selectImage:nil];
    self.navigationItem.leftBarButtonItem = backbtn;
    
    _opertionstr = @"1";
    [self CretatchooseView];
    [self Getaf];
    
    
}
-(void)CretatchooseView
{
    _headview = [[UIView alloc]init];
    _headview.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_headview];
    _headview.sd_layout.leftEqualToView(self.view).rightEqualToView(self.view).topSpaceToView(self.view,0).heightIs(autoScaleH(150));
    
    UILabel * linelabel = [[UILabel alloc]init];
    linelabel.backgroundColor = UIColorFromRGB(0xeeeeee);
    [_headview addSubview:linelabel];
    linelabel.sd_layout.leftSpaceToView(_headview,autoScaleW(10)).rightSpaceToView(_headview,autoScaleW(10)).bottomEqualToView(_headview).heightIs(0.5);
    
    NSArray * imageary = @[@"未上未选中",@"已点未选中"];
    NSArray * selectimageary = @[@"未上选中",@"菜品"];
    NSArray * titleary = @[@"未上的菜",@"已上的菜",];
    
    for (int i=0; i<2; i++)
    {
        UIButton * choosebtn = [UIButton buttonWithType:UIButtonTypeCustom];
        
        [choosebtn setBackgroundImage:[UIImage imageNamed:imageary[i]]  forState:UIControlStateNormal];
        [choosebtn setBackgroundImage:[UIImage imageNamed:selectimageary[i]]forState:UIControlStateSelected];
        if (i==0) {
            
            choosebtn.selected = YES;
            _daitibtn = choosebtn;
        }
        
        choosebtn.tag = 200 + i;
        [choosebtn addTarget:self action:@selector(Choose:) forControlEvents:UIControlEventTouchUpInside];
        [_headview addSubview:choosebtn];
        
        choosebtn.sd_layout.leftSpaceToView(_headview,((GetWidth-autoScaleW(220))/2)+i*autoScaleW(160)).topSpaceToView(_headview,autoScaleH(45)).widthIs(autoScaleW(60)).heightIs(autoScaleW(60));
        
        UILabel * btnlabel = [[UILabel alloc]init];
        btnlabel.text = titleary[i];
        btnlabel.textAlignment = NSTextAlignmentCenter;
        btnlabel.textColor = [UIColor blackColor];
        btnlabel.font = [UIFont systemFontOfSize:autoScaleW(13)];
        [_headview addSubview:btnlabel];
        btnlabel.sd_layout.leftEqualToView(choosebtn).topSpaceToView(choosebtn,autoScaleH(5)).widthIs(autoScaleW(60)).heightIs(autoScaleH(15));
        
        
    }

}
#pragma mark 创建菜品的滚动图
-(void)Getscroll
{
       //菜品滚动图
    _orderscroll = [[UIScrollView alloc]init];
    _orderscroll.backgroundColor = [UIColor whiteColor];
    _orderscroll.delegate = self;
    _orderscroll.contentSize = CGSizeMake(GetWidth*(_modelary.count/12), 0);
    [self.view addSubview:_orderscroll];
    _orderscroll.sd_layout.leftEqualToView(self.view).rightEqualToView(self.view).topSpaceToView(_headview,0).heightIs(GetHeight-autoScaleH(150));
    
    //菜品collect
    PagingCollectionViewLayout *layout = [[PagingCollectionViewLayout alloc]init];
    layout.itemSize = CGSizeMake(70, 97);
    layout.sectionInset = UIEdgeInsetsMake(30, 30, 30, 30);
    CGFloat lineSpace = (self.view.frame.size.width - layout.itemSize.width * 4 - layout.sectionInset.left - layout.sectionInset.right) / (4 - 1);
    layout.minimumLineSpacing = 10;
    layout.minimumInteritemSpacing = lineSpace;
    _height = layout.itemSize.height * 3 + layout.sectionInset.top + layout.sectionInset.bottom + layout.minimumLineSpacing*2;
    
    self.dishesCollectionV = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, _height) collectionViewLayout:layout];
    
    self.dishesCollectionV.showsVerticalScrollIndicator = NO;
    self.dishesCollectionV.showsHorizontalScrollIndicator = NO;
    self.dishesCollectionV.pagingEnabled = YES;
    self.dishesCollectionV.backgroundColor = [UIColor whiteColor];
    
    self.dishesCollectionV.dataSource = self;
    self.dishesCollectionV.delegate = self;
    
    [self.dishesCollectionV registerClass:[KitchenDishesCell class] forCellWithReuseIdentifier:@"dishesCell"];
    
    [_orderscroll addSubview:_dishesCollectionV];
    
}
#pragma mark 创建pagecontrol
- (void)Creatpage{
    if (_pagecontrol) {
        [_pagecontrol removeFromSuperview];
    }
    
    NSInteger pageCount = _modelary.count / ( 4 * 3);
    
    if (pageCount > 0) {
        pageCount++;
    }
    else if (pageCount<=0)
    {
        pageCount = 1;
    }
    
    CGRect rect = _dishesCollectionV.frame;
    //
    _pagecontrol = [[ZTPageControl alloc] initWithFrame:CGRectMake((self.view.size.width - (pageCount*10))/2,_height+autoScaleH(150), pageCount*10, 20)];
    //
    [_pagecontrol addTarget:self action:@selector(pageControlAction:) forControlEvents:UIControlEventTouchUpInside];
    
    _pagecontrol.numberOfPages = pageCount;
    _pagecontrol.currentPage = 0;
    [self.view addSubview:_pagecontrol];
}
#pragma mark 催促上菜和继续点菜
-(void)Creatbottomview
{
    UIView * bottomview = [[UIView alloc]init];
    bottomview.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:bottomview];
//    bottomview.sd_layout
    
    
    
    
}
#pragma mark 选择已上或未上按钮
-(void)Choose:(UIButton*)btn
{
    _daitibtn.selected = NO;
    btn.selected = YES;
    _daitibtn = btn;
    
    
    if (btn.tag==200) {
        
        _opertionstr = @"1";
       
    }
    else if (btn.tag==201)
    {
        _opertionstr = @"0";
    }
    
     [self Getaf];
    
}
-(void)Getaf
{
    _modelary = [NSMutableArray array];
    
    NSString * urlstr = [NSString stringWithFormat:@"%@/api/user/scanCodeFoodManage?token=%@&orderId=%@&operation=%@",commonUrl,Token,_orderid,_opertionstr];
    
    [MBProgressHUD showMessage:@"请稍等"];
    NSArray * urlary = [urlstr componentsSeparatedByString:@"?"];
    
    [[QYXNetTool shareManager]postNetWithUrl:urlary.firstObject urlBody:urlary.lastObject bodyStyle:QYXBodyString header:nil response:QYXJSON success:^(id result)    {
        NSLog(@">>>>%@",result);
        [MBProgressHUD hideHUD];
        NSString * msgstr = [NSString stringWithFormat:@"%@",result[@"msgType"]];
        if ([msgstr isEqualToString:@"0"]) {
            
            if (![[result objectForKey:@"obj"] isNull]) {
                
                //            NSDictionary * objdict = [result objectForKey:@"obj"];
                NSArray * objary = [result objectForKey:@"obj"];
                [_modelary removeAllObjects];
                for (int i=0; i<objary.count; i++)
                {
                    Dinemodel * model = [[Dinemodel alloc]initWithgetsomethingwithdict:objary[i]];
                    NSLog(@">>>%@",model.productname);
                    [_modelary addObject:model];
                    
                    
                }
                //便利数组，去除不符合条件的
                NSArray * modelarray = [NSArray arrayWithArray:_modelary];
                for (Dinemodel * model in modelarray) {
                    
                    if (model.served==0&&model.islack==0)
                    {
                        [_modelary removeObject:model];
                        
                    }
                }
                //scroll
                if (_orderscroll)
                {
                    
                    [_dishesCollectionV reloadData];
                    
                }
                else
                {
                    [self Getscroll];
                }
                //page
                [self Creatpage];
            }
           

        }
        else if([msgstr isEqualToString:@"3"])
        {
            [_modelary removeAllObjects];
            //page
            if (_pagecontrol) {
                
                [_pagecontrol removeFromSuperview];
            }
            //scroller
            if (_orderscroll)
            {
                
                [_dishesCollectionV reloadData];
                
            }
            else
            {
                [self Getscroll];
            }
            
            if ([_opertionstr isEqualToString:@"1"]) {
                [MBProgressHUD showError:@"您的菜已上完"];
            }else{
                [MBProgressHUD showError:@"菜还没做好，请稍等片刻"];
                
            }
        }
        
    } failure:^(NSError *error)
     {
         [MBProgressHUD hideHUD];
         
    }];
    
    
    
}
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return _modelary.count;
    
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
        KitchenDishesCell *cell = [_dishesCollectionV dequeueReusableCellWithReuseIdentifier:@"dishesCell" forIndexPath:indexPath];
    
    cell.model = _modelary[indexPath.row];
    
    
        return cell;
        
}
#pragma mark 滑动代理
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    _pagecontrol.currentPage = scrollView.contentOffset.x/self.view.frame.size.width;
    
    
    
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
