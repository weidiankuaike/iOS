//
//  NewMerchantDetailVC.m
//  wdKuaiKe_iOS
//
//  Created by Skyer God on 16/9/29.
//  Copyright © 2016年 weiDianKuaiKe. All rights reserved.
//

#import "NewMerchantDetailVC.h"

#import "PhoneTableViewCell.h"

#import "LocationTableViewCell.h"

#import "EvaluateDetailListCell.h"

#import "MerchantDetailVCModel.h"

#import "MerchantReconmendTabCell.h"

#import "BaseButton.h"
#import "RestaurantOrderVC.h"

#import "AMapRouteSearchRequestAPI.h"
//#import "route"
#import "MBProgressHUD+SS.h"
#import "QYXNetTool.h"
#import "JudgeModel.h"
#import "JudgeTableViewCell.h"
#import "UIButton+WebCache.h"
#import "UIImageView+WebCache.h"
@interface NewMerchantDetailVC ()<UITableViewDelegate, UITableViewDataSource>
{
   
}
/** tableView (strong) **/
@property (nonatomic, strong) UITableView *tableView;
        /** 数据源 **/
@property (nonatomic, strong) NSMutableArray *modelsArray;
@property (nonatomic,strong) UIView * headview;//表头
@property (nonatomic,strong)NSMutableArray * modelary;
@property (nonatomic,strong)NSMutableArray * mjAry;
@property (nonatomic,strong)NSMutableArray * zkAry;
@property (nonatomic,strong) UIImageView * subtractImage;
@property (nonatomic,strong) UILabel * subtractLabel;
@property (nonatomic,strong)UILabel * discountLabel;
@property (nonatomic,strong)UIView * firstview;
@property (nonatomic,strong)UIView * addriveview;
@property (nonatomic,strong)UIView * queueView;
@end

@implementation NewMerchantDetailVC
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:NO];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
//    [self creatModelsWithCount:11];
    
    _headview = [[UIView alloc]init];
    _headview.backgroundColor = RGB(238, 238, 238);
    _headview.frame = CGRectMake(0, 0, GetWidth, autoScaleH(325));
    [self.view addSubview:_headview];
    
    _modelary = [NSMutableArray array];
    
    [self Creatfirstview];
    [self Creatsecondview];
//    [self creatQueueView];
    [self Creatthreeview];
    [self setupTableView];
    [self getData];

    
}
- (void)getData{
    
    NSString * urlstr = [NSString stringWithFormat:@"%@/getStoreEvalData?storeId=%@",commonUrl,_dict[@"storeId"]];
    NSArray * urlary = [urlstr componentsSeparatedByString:@"?"];
    [MBProgressHUD showMessage:@"请稍等"];
    [[QYXNetTool shareManager]postNetWithUrl:urlary.firstObject urlBody:urlary.lastObject bodyStyle:QYXBodyString header:nil response:QYXJSON success:^(id result) {
        
        [ MBProgressHUD hideHUD];
        NSString * typestr = [NSString stringWithFormat:@"%@",result[@"msgType"]];
        if ([typestr isEqualToString:@"0"]) {
            
            NSArray * objdict = result[@"obj"];
            
            for (int i=0; i<objdict.count; i++) {
                
                JudgeModel * model = [JudgeModel mj_objectWithKeyValues:objdict[i]];
                
                [_modelary addObject:model];
                
            }
            if (_tableView) {
                
                [_tableView reloadData];
            }else{
                [self setupTableView];
            }

        }else if([typestr isEqualToString:@"1"]){
            [MBProgressHUD showError:@"评论加载失败"];
        }else{
            [MBProgressHUD showError:@"该店铺暂无评论"];
        }
        
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUD];
        [MBProgressHUD showError:@"网络错误"];
    }];
}
//第一个
-(void)Creatfirstview
{
    _firstview = [[UIView alloc]init];
    _firstview.frame =CGRectMake(0, autoScaleH(10), GetWidth, autoScaleH(100));
    _firstview.backgroundColor = [UIColor whiteColor];

    [_headview addSubview:_firstview];
//    _firstview.sd_layout.leftEqualToView(_headview).rightEqualToView(_headview).topSpaceToView(_headview,autoScaleH(10)).heightIs(autoScaleH(100));
    
    UILabel * firstlabel = [[UILabel alloc]init];
    firstlabel.text = @"人均";
    firstlabel.textColor = [UIColor lightGrayColor];
    firstlabel.font = [UIFont systemFontOfSize:autoScaleW(15)];
    [_firstview addSubview:firstlabel];
    firstlabel.sd_layout.leftSpaceToView(_firstview,autoScaleW(20)).topSpaceToView(_firstview,autoScaleH(30)).widthIs(autoScaleW(35)).heightIs(autoScaleH(20));
    
    UILabel * secondlabel = [[UILabel alloc]init];
    secondlabel.font = [UIFont systemFontOfSize:autoScaleW(30)];
    secondlabel.text = [NSString stringWithFormat:@"￥%@",_dict[@"perCapitaPrice"]];
    secondlabel.textColor = [UIColor blackColor];
    [_firstview addSubview:secondlabel];
    secondlabel.sd_layout.leftSpaceToView(firstlabel,autoScaleW(10)).topSpaceToView(_firstview,autoScaleH(20)).heightIs(autoScaleH(40));
    [secondlabel setSingleLineAutoResizeWithMaxWidth:300];
    
    UILabel * threelabel = [[UILabel alloc]init];
    threelabel.font = [UIFont systemFontOfSize:autoScaleW(13)];
    threelabel.text = [NSString stringWithFormat:@"已售单%@",_dict[@"orderSales"]];
    threelabel.textColor = [UIColor lightGrayColor];
    threelabel.textAlignment = NSTextAlignmentRight;
    [_firstview addSubview:threelabel];
    threelabel.sd_layout.rightSpaceToView(_firstview,autoScaleW(15)).topEqualToView(firstlabel).heightIs(autoScaleH(15));
    [threelabel setSingleLineAutoResizeWithMaxWidth:200];
    
    UILabel * linelabel = [[UILabel alloc]init];
    linelabel.backgroundColor = [UIColor lightGrayColor];
    [_firstview addSubview:linelabel];
    linelabel.sd_layout.leftEqualToView(_firstview).rightEqualToView(_firstview).topSpaceToView(firstlabel,autoScaleH(15)).heightIs(1);
    
    if (![_dict[@"activitiesCardVOList"] isNull]) {
        
        NSArray * cardAry = _dict[@"activitiesCardVOList"];
        
        for (int i=0; i<cardAry.count; i++) {
            
            _mjAry = [NSMutableArray array];
            _zkAry = [NSMutableArray array];
            for (NSDictionary * cardDict in cardAry) {
                
                if ([cardDict[@"cardType"] integerValue]==2) {
                    
                    NSString * cardStr = [NSString stringWithFormat:@"满%@元减%@元",cardDict[@"consumptionOver"],cardDict[@"discountedPrice"]];
                    
                    [_mjAry addObject:cardStr];
                }else if ([cardDict[@"cardType"] integerValue]==3){
                    
                    NSString * discountStr = [NSString stringWithFormat:@"%@",cardDict[@"discount"]];
                    double discout = [discountStr doubleValue];
                    NSString * disStr = [NSString stringWithFormat:@"%.f",discout];
                    NSString * zkStr = [NSString stringWithFormat:@"满%@元打%@折",cardDict[@"consumptionOver"],disStr];
                    [_zkAry addObject:zkStr];
                }
                
            }

            
        }
        
        if (_mjAry.count!=0) {
            
            _subtractImage = [[UIImageView alloc]init];
            _subtractImage.image = [UIImage imageNamed:@"减"];
            [_firstview addSubview:_subtractImage];
            _subtractImage.sd_layout.leftSpaceToView(_firstview,autoScaleW(15)).topSpaceToView(linelabel,autoScaleH(10)).widthIs(autoScaleW(15)).heightIs(autoScaleW(15));
            
            NSString * mjstr = [_mjAry componentsJoinedByString:@","];
             _subtractLabel = [[UILabel alloc]init];
            _subtractLabel.text = mjstr;
            _subtractLabel.font = [UIFont systemFontOfSize:13];
            [_firstview addSubview:_subtractLabel];
            _subtractLabel.sd_layout.leftSpaceToView(_subtractImage,5).topEqualToView(_subtractImage).widthIs(GetWidth-autoScaleW(15)-_subtractImage.width_sd).autoHeightRatio(0);
            [_subtractLabel updateLayout];
            CGFloat height = _firstview.frame.size.height+ _subtractLabel.height_sd;
            [_firstview setHeight:height];
            
        }
        if (_zkAry.count!=0) {
            
            UIImageView * discountimage = [[UIImageView alloc]init];
            discountimage.image = [UIImage imageNamed:@"折"];
            [_firstview addSubview:discountimage];
            discountimage.sd_layout.leftSpaceToView(_firstview,autoScaleW(15)).widthIs(autoScaleW(15)).heightIs(autoScaleH(15));
            if (_mjAry.count!=0) {
                
                discountimage.sd_layout.topSpaceToView(_subtractLabel,5);
            }
            else{
                discountimage.sd_layout.topSpaceToView(linelabel,10);
            }
            
            NSString * zkstr = [_zkAry componentsJoinedByString:@","];
            
            _discountLabel = [[UILabel alloc]init];
            _discountLabel.text = zkstr;
            _discountLabel.font = [UIFont systemFontOfSize:13];
            [_firstview addSubview:_discountLabel];
            _discountLabel.sd_layout.leftSpaceToView(discountimage,5).topEqualToView(discountimage).widthIs(GetWidth - autoScaleW(20)- discountimage.width_sd).autoHeightRatio(0);
            [_discountLabel updateLayout];
            CGFloat height = _firstview.frame.size.height+ _discountLabel.height_sd;
            [_firstview setHeight:height];
        }
     }

}
//第二个
- (void)Creatsecondview
{
    
    _addriveview = [[UIView alloc]init];
    _addriveview.backgroundColor = [UIColor whiteColor];
    [_headview addSubview:_addriveview];
    _addriveview.sd_layout.leftEqualToView(_headview).rightEqualToView(_headview).topSpaceToView(_headview,_firstview.frame.size.height+autoScaleH(20)).heightIs(autoScaleH(75));
    
    
    UILabel * sblabel = [[UILabel alloc]init];
    sblabel.text = @"商家信息";
    sblabel.textColor = [UIColor blackColor];
    sblabel.font = [UIFont systemFontOfSize:autoScaleW(13)];
    [_addriveview addSubview:sblabel];
    sblabel.sd_layout.leftSpaceToView(_addriveview,autoScaleW(15)).topSpaceToView(_addriveview,autoScaleH(5)).widthIs(autoScaleW(60)).heightIs(autoScaleH(15));
    
    UILabel * linelabel = [[UILabel alloc]init];
    linelabel.backgroundColor = [UIColor lightGrayColor];
    [_addriveview addSubview:linelabel];
    linelabel.sd_layout.leftEqualToView(_addriveview).rightEqualToView(_addriveview).topSpaceToView(sblabel,autoScaleH(5)).heightIs(1);
    
    
    UIButton * addressbtn = [UIButton buttonWithType:UIButtonTypeCustom];
    addressbtn.backgroundColor = [UIColor whiteColor];
    [addressbtn addTarget:self action:@selector(Navigat) forControlEvents:UIControlEventTouchUpInside];
    [_addriveview addSubview:addressbtn];
    addressbtn.sd_layout.leftEqualToView(_addriveview).rightSpaceToView(_addriveview,autoScaleW(65)).topSpaceToView(linelabel,0).heightIs(autoScaleH(50));
    
    
    NSString * addresstr = [NSString stringWithFormat:@"%@",_dict[@"address"]];
    NSString * address = [addresstr stringByReplacingOccurrencesOfString:@"," withString:@""];
    UILabel * addresslabel = [[UILabel alloc]init];
    addresslabel.textColor = [UIColor lightGrayColor];
    addresslabel.text = address;
    addresslabel.font = [UIFont systemFontOfSize:autoScaleW(13)];
    addresslabel.numberOfLines = 0 ;
    [addressbtn addSubview:addresslabel];
    addresslabel.sd_layout.leftSpaceToView(addressbtn,autoScaleW(15)).topSpaceToView(addressbtn,autoScaleH(5)).widthIs(autoScaleW(200)).heightIs(autoScaleH(40));
    UIImageView * positonimage = [[UIImageView alloc]init];
    positonimage.image = [UIImage imageNamed:@"定位"];
    [addressbtn addSubview:positonimage];
    positonimage.sd_layout.rightSpaceToView(addressbtn,autoScaleW(15)).topSpaceToView(addressbtn,autoScaleH(10)).widthIs(autoScaleW(25)).heightIs(autoScaleH(25));
    
    UIButton * phonebtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [phonebtn setImage:[UIImage imageNamed:@"电话"] forState:UIControlStateNormal];
    [phonebtn addTarget:self action:@selector(Callphone) forControlEvents:UIControlEventTouchUpInside];
    [_addriveview addSubview:phonebtn];
    phonebtn.sd_layout.rightSpaceToView(_addriveview,0).topEqualToView(addressbtn).widthIs(autoScaleW(65)).heightIs(autoScaleH(50));
    
    UILabel * sulinelabel = [[UILabel alloc]init];
    sulinelabel.backgroundColor = [UIColor lightGrayColor];
    [phonebtn addSubview:sulinelabel];
    sulinelabel.sd_layout.leftEqualToView(sulinelabel).topEqualToView(sulinelabel).widthIs(1).heightIs(50);
    
}
- (void)creatQueueView{
    
    _queueView = [[UIView alloc]init];
    _queueView.backgroundColor = [UIColor whiteColor];
    [_headview addSubview:_queueView];
    _queueView.sd_layout.leftEqualToView(_headview).rightEqualToView(_headview).topSpaceToView(_addriveview, autoScaleH(10)).heightIs(autoScaleH(40)+autoScaleH(10)+autoScaleH(35)*3+autoScaleH(10)+autoScaleH(25)+autoScaleH(12)+autoScaleH(35)+autoScaleH(10));
    
    NSArray * titleAry = @[@"餐桌类型",@"当前叫号",@"等待桌数"];

    for (int i = 0 ; i<titleAry.count; i++) {
        
        UILabel * titleLabel = [[UILabel alloc]init];
        titleLabel.textColor = UIColorFromRGB(0x000000);
        titleLabel.font = [UIFont systemFontOfSize:autoScaleH(14)];
        titleLabel.text = titleAry[i];
        [_queueView addSubview:titleLabel];
        titleLabel.sd_layout.leftSpaceToView(_queueView,autoScaleW(30)+i*((GetWidth-autoScaleW(60)-autoScaleW(60)*3)/2+autoScaleW(60))).topSpaceToView(_queueView,autoScaleH(10)).widthIs(autoScaleW(60)).heightIs(autoScaleH(20));
        
    }
    UILabel * queueLinelabel = [[UILabel alloc]init];
    queueLinelabel.backgroundColor = UIColorFromRGB(0xdcdcdc);
    [_queueView addSubview:queueLinelabel];
    queueLinelabel.sd_layout.leftSpaceToView(_queueView, autoScaleW(30)).topSpaceToView(_queueView, autoScaleH(40)).rightSpaceToView(_queueView, autoScaleW(30)).heightIs(1);
    
    for (int i=0; i<3; i++)
    {
        
        UILabel * queuelabel = [[UILabel alloc]init];
        [_queueView addSubview:queuelabel];
        queuelabel.sd_layout.leftSpaceToView(_queueView,autoScaleW(30)).topSpaceToView(queueLinelabel,autoScaleH(10)+i*autoScaleH(35)).widthIs(GetWidth-autoScaleW(60)).heightIs(30);
        
        UILabel * namelabel = [[UILabel alloc]init];
        namelabel.font = [UIFont systemFontOfSize:autoScaleW(13)];
        namelabel.textAlignment = NSTextAlignmentCenter;
        [queuelabel addSubview:namelabel];
        namelabel.sd_layout.leftSpaceToView(queuelabel,autoScaleW(28)).topSpaceToView(queuelabel,autoScaleH(5)).widthIs(autoScaleW(50)).heightIs(autoScaleH(20));
        
        UILabel * sllabel = [[UILabel alloc]init];
        sllabel.font = [UIFont systemFontOfSize:autoScaleW(13)];
        sllabel.textAlignment = NSTextAlignmentCenter;
        [queuelabel addSubview:sllabel];
        sllabel.sd_layout.centerXEqualToView(queuelabel).topSpaceToView(queuelabel,autoScaleH(5)).widthIs(autoScaleW(100)).heightIs(autoScaleH(20));
        
        UILabel * moneylabel = [[UILabel alloc]init];
        moneylabel.font = [UIFont systemFontOfSize:autoScaleW(13)];
        moneylabel.textAlignment = NSTextAlignmentCenter;
        [queuelabel addSubview:moneylabel];
        moneylabel.sd_layout.rightSpaceToView(queuelabel,0).topSpaceToView(queuelabel,autoScaleH(5)).widthIs(autoScaleW(50)).heightIs(autoScaleH(20));
        
    }
 
    UILabel * secondLinelabel = [[UILabel alloc]init];
    secondLinelabel.backgroundColor = UIColorFromRGB(0xdcdcdc);
    [_queueView addSubview:secondLinelabel];
    secondLinelabel.sd_layout.leftEqualToView(queueLinelabel).rightEqualToView(queueLinelabel).topSpaceToView(_queueView,autoScaleH(40)+autoScaleH(35)*3+autoScaleH(10)).heightIs(1);
    
    
    NSArray * distanceAry = @[@"当前距离:5km",@"限制距离:5km"];
    
    for (int i =0; i<2; i++) {
        
        UILabel * distanceLabel = [[UILabel alloc]init];
        distanceLabel.text = distanceAry[i];
        distanceLabel.font = [UIFont systemFontOfSize:autoScaleW(12)];
        distanceLabel.textColor = UIColorFromRGB(0x1c1c1c);
        [_queueView addSubview:distanceLabel];
        distanceLabel.sd_layout.leftSpaceToView(_queueView,autoScaleW(30)).topSpaceToView(secondLinelabel,autoScaleH(8)+i*autoScaleH(12)).heightIs(autoScaleH(12)).widthIs(GetWidth-autoScaleW(60)-autoScaleW(220));
    }
   
    UITextField * peopleNum = [[UITextField alloc]init];
    peopleNum.textColor = UIColorFromRGB(0xffffff);
    peopleNum.font = [UIFont systemFontOfSize:autoScaleW(13)];
    peopleNum.textAlignment = NSTextAlignmentCenter;
    peopleNum.placeholder = @"请输入用餐人数";
    peopleNum.layer.borderWidth = 1;
    peopleNum.layer.borderColor = RGB(197, 197, 197).CGColor;
    peopleNum.layer.masksToBounds = YES;
    peopleNum.layer.cornerRadius = 3;
    [_queueView addSubview:peopleNum];
    peopleNum.sd_layout.topSpaceToView(secondLinelabel,autoScaleH(6)).rightSpaceToView(_queueView,autoScaleW(30)).widthIs(autoScaleW(220)).heightIs(autoScaleH(25));
    
    UIButton * typeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [typeBtn setTitle:@"立即取票" forState:UIControlStateNormal];
    [typeBtn setBackgroundColor:UIColorFromRGB(0x00cc99)];
    [typeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    typeBtn.titleLabel.font = [UIFont systemFontOfSize:autoScaleW(15)];
    typeBtn.layer.masksToBounds = YES;
    typeBtn.layer.cornerRadius = 3;
    [_queueView addSubview:typeBtn];
    typeBtn.sd_layout.leftSpaceToView(_queueView, autoScaleW(30)).rightSpaceToView(_queueView,autoScaleW(30)).topSpaceToView(peopleNum,autoScaleH(12)).heightIs(autoScaleH(35));
    
}
//第三个
 - (void)Creatthreeview
{
    UIView * threeview = [[UIView alloc]init];
    threeview.backgroundColor = [UIColor whiteColor];
    [_headview addSubview:threeview];
    threeview.sd_layout.leftEqualToView(_headview).rightEqualToView(_headview).topSpaceToView(_headview,_firstview.frame.size.height+_addriveview.height_sd+autoScaleH(30)).heightIs(autoScaleH(110));
    
    
    UILabel * sblabel = [[UILabel alloc]init];
    sblabel.text = @"推荐菜品";
    sblabel.textColor = [UIColor blackColor];
    sblabel.font = [UIFont systemFontOfSize:autoScaleW(13)];
    [threeview addSubview:sblabel];
    sblabel.sd_layout.leftSpaceToView(threeview,autoScaleW(15)).topSpaceToView(threeview,autoScaleH(5)).widthIs(autoScaleW(60)).heightIs(autoScaleH(15));
    UILabel * linelabel = [[UILabel alloc]init];
    linelabel.backgroundColor = [UIColor lightGrayColor];
    [threeview addSubview:linelabel];
    linelabel.sd_layout.leftEqualToView(threeview).rightEqualToView(threeview).topSpaceToView(sblabel,autoScaleH(5)).heightIs(1);
    
    NSArray * productAry = _dict[@"storeProductVoList"];
    if (productAry.count!=0) {
        
        for (int i =0; i<productAry.count; i++) {
            BaseButton * btn = [BaseButton buttonWithType:UIButtonTypeCustom];
            btn.frame = CGRectMake(autoScaleW(15)+i*((GetWidth - autoScaleW(75))/4+autoScaleW(20)), autoScaleH(30), (GetWidth - autoScaleW(75))/4, autoScaleH(90));
            if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:productAry[i][@"images"]]]) {
                
                [btn sd_setImageWithURL:[NSURL URLWithString:productAry[i][@"images"]] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"1"]];
            }else{
                
                NSString * imageStr = [productAry[i][@"images"] stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
                [btn sd_setImageWithURL:[NSURL URLWithString:imageStr] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"1"]];
            }
            
            [btn setTitle:productAry[i][@"productName"] forState:UIControlStateNormal];
            [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            btn.titleLabel.font = [UIFont systemFontOfSize:autoScaleW(10)];
            [threeview addSubview:btn];
            [btn setImage_X:8];
            [btn setImage_Y:10];
            [btn setTitle_Space:5];
        }

    }
    
    CGFloat height = _firstview.frame.size.height + _addriveview.frame.size.height+ threeview.frame.size.height+autoScaleH(30);
    [_headview setHeight:height];
    
//    [_headview setupAutoHeightWithBottomView:threeview bottomMargin:20];
}
- (void)setupTableView{
    
   
    
    self.tableView = [[UITableView alloc]init];
    self.tableView.delegate = self;
    self.tableView.dataSource =self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = RGB(238, 238, 238);
    self.tableView.tableHeaderView = _headview;
    [self.tableView registerClass:[JudgeTableViewCell class] forCellReuseIdentifier:@"storejudge"];
    [self.view addSubview:_tableView];
    
    self.tableView.sd_layout
    .leftSpaceToView(self.view, 0)
    .topEqualToView(self.view)
    .rightEqualToView(self.view)
    .bottomSpaceToView(self.view, autoScaleH(10));

}
#pragma mark 数据源
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _modelary.count;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *CellIdentifier = [NSString stringWithFormat:@"cell%ld%ld",indexPath.section,indexPath.row];
    // 通过不同标识创建cell实例
    JudgeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    // 判断为空进行初始化  --（当拉动页面显示超过主页面内容的时候就会重用之前的cell，而不会再次初始化）
    if (!cell) {
        cell = [[JudgeTableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    
    UILabel * linelabel = [[UILabel alloc]init];
    linelabel.backgroundColor = [UIColor blackColor];
    [cell addSubview:linelabel];
    linelabel.sd_layout.leftEqualToView(cell).rightEqualToView(cell).bottomEqualToView(cell).heightIs(0.5);
    
    JudgeModel * model = _modelary[indexPath.row];
    cell.model = model;
    
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    JudgeModel * model = _modelary[indexPath.row];
//    
//     CGFloat height = [_tableView cellHeightForIndexPath:indexPath model:model keyPath:@"model" cellClass:[JudgeTableViewCell class] contentViewWidth:GetWidth];
    
    return [tableView cellHeightForIndexPath:indexPath cellContentViewWidth:[self cellContentViewWith] tableView:tableView];
}
- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView * headview = [[UIView alloc]init];
    headview.backgroundColor = [UIColor whiteColor];
    
    UILabel * headLabel = [[UILabel alloc]init];
    headLabel.backgroundColor = RGB(238, 238, 238);
    [headview addSubview:headLabel];
    headLabel.sd_layout.leftEqualToView(headview).rightEqualToView(headview).topEqualToView(headview).heightIs(autoScaleH(10));
    
    UILabel * sblabel = [[UILabel alloc]init];
    sblabel.text = @"餐厅评价";
    sblabel.textColor = [UIColor blackColor];
    sblabel.font = [UIFont systemFontOfSize:autoScaleW(13)];
    [headview addSubview:sblabel];
    sblabel.sd_layout.leftSpaceToView(headview,autoScaleW(15)).topSpaceToView(headLabel        ,autoScaleH(5)).widthIs(autoScaleW(60)).heightIs(autoScaleH(15));
    
    UILabel * rightlabel = [[UILabel alloc]init];
    rightlabel.text = [NSString stringWithFormat:@"%@条评价",_dict[@"evalCount"]];
    rightlabel.font = [UIFont systemFontOfSize:13];
    rightlabel.textColor = [UIColor lightGrayColor];
    rightlabel.textAlignment = NSTextAlignmentRight;
    [headview addSubview:rightlabel];
    rightlabel.sd_layout.rightSpaceToView(headview,autoScaleW(15)).topEqualToView(sblabel).heightIs(autoScaleH(15));
    [rightlabel setSingleLineAutoResizeWithMaxWidth:200];
    
    
    UILabel * linelabel = [[UILabel alloc]init];
    linelabel.backgroundColor = [UIColor lightGrayColor];
    [headview addSubview:linelabel];
    linelabel.sd_layout.leftEqualToView(headview).rightEqualToView(headview).topSpaceToView(sblabel,autoScaleH(5)).heightIs(1);
    
    if (![_dict[@"tagMaps"] isNull]) {
        NSDictionary * tagsdict = _dict[@"tagMaps"];
        NSArray * values = tagsdict.allValues;
        NSArray * keys = tagsdict.allKeys;
        
        for (int i=0; i<keys.count; i++) {
            
            UIButton * yhbtn = [UIButton buttonWithType:UIButtonTypeCustom];
            [yhbtn setTitle:[NSString stringWithFormat:@"%@  %@",keys[i],values[i]] forState:UIControlStateNormal];
            [yhbtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
            yhbtn.layer.masksToBounds = YES;
            yhbtn.layer.cornerRadius = 5;
            yhbtn.layer.borderWidth = 1;
            yhbtn.layer.borderColor = [UIColor lightGrayColor].CGColor;
            yhbtn.titleLabel.font = [UIFont systemFontOfSize:autoScaleW(11)];
            [headview addSubview:yhbtn];
            yhbtn.sd_layout.leftSpaceToView(headview,autoScaleW(10)+i*((GetWidth - autoScaleW(75))/4+autoScaleW(20))).topSpaceToView(linelabel,autoScaleH(10)).widthIs((GetWidth - autoScaleW(75))/4).heightIs(autoScaleH(15));
            
            
        }
    
    }
    
    return headview;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return autoScaleH(65);
}
#pragma mark 打电话

- (void)Callphone
{
    NSString *message = NSLocalizedString(_dict[@"cellphone"], nil);
    NSString *cancelButtonTitle = NSLocalizedString(@"取消", nil);
    NSString *otherButtonTitle = NSLocalizedString(@"拨打", nil);
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:message preferredStyle:UIAlertControllerStyleAlert];
    
    // Create the actions.
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:cancelButtonTitle style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        [alertController dismissViewControllerAnimated:YES completion:^{
            
            
        }];
    }];
    
    UIAlertAction *otherAction = [UIAlertAction actionWithTitle:otherButtonTitle style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        NSMutableString *str=[[NSMutableString alloc] initWithFormat:@"tel:%@",_dict[@"cellphone"]];
        UIWebView *callWebview = [[UIWebView alloc] init];
        [callWebview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:str]]];
        [self.view addSubview:callWebview];
        
    }];
    
    // Add the actions.
    [alertController addAction:cancelAction];
    [alertController addAction:otherAction];
    
    [self presentViewController:alertController animated:YES completion:nil];
}
#pragma mark 导航
- (void)Navigat
{

    AMapRouteSearchRequestAPI *routeMap = [[AMapRouteSearchRequestAPI alloc] init];
    routeMap.latstr = _dict[@"lat"];
    routeMap.lngstr = _dict[@"lng"];
    [self.navigationController pushViewController:routeMap animated:YES];
    
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
