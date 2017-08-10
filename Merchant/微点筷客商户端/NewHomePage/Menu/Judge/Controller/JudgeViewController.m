//
//  JudgeViewController.m
//  微点筷客商户端
//
//  Created by 张森森 on 16/10/19.
//  Copyright © 2016年 张森森. All rights reserved.
//

#import "JudgeViewController.h"
#import "UIBarButtonItem+SSExtension.h"
#import "JudgeTableViewCell.h"
#import "ReportViewController.h"
#import "MBProgressHUD+SS.h"
#import "QYXNetTool.h"
#import "JudgeModel.h"
#import <UIImageView+WebCache.h>
#import "ZTAlertSheetView.h"
#import "ZTSelectLabel.h"
@interface JudgeViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    NSMutableArray * showTagArr;
    UIView * headView;
    NSMutableArray * _allScoreArr;
    NSMutableArray * _tempAllScoreArr;
}
@property (nonatomic,assign)  CGFloat height;
@property (nonatomic,strong) ButtonStyle * daitibtn;
@property (nonatomic,strong) ButtonStyle * tidaibtn;
@property (nonatomic,strong) UIView * chooseView;
@property (nonatomic,retain) UITableView * commentTableV;
@property (nonatomic,copy) NSString * scorePoint;
@property (nonatomic,copy) NSString * sumstr;
@property (nonatomic,strong)NSMutableArray *dataArr;
@property (nonatomic,copy)NSString * scorestr;
//@property (nonatomic,strong)NSMutableArray * scoreary;
@property (nonatomic,strong)ZTAlertSheetView * ztalert;
@property (nonatomic,copy)NSString * judeidstr;
/** <#行注释#>   (strong) **/
@property (nonatomic, strong) ZTSelectLabel *selectView;
@end

@implementation JudgeViewController{
    ButtonStyle * rightBarItem;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [ReloadVIew registerReloadView:self];
    [IQKeyboardManager sharedManager].shouldResignOnTouchOutside = YES;
    [IQKeyboardManager sharedManager].enableAutoToolbar = NO;
    self.navigationController.navigationBar.hidden = NO;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self createNaviView];

}
- (void)createNaviView{
    _scorePoint = @"4.5";
    self.titleView.text = @"评价反馈";
    self.view.backgroundColor = [UIColor whiteColor];
        self.automaticallyAdjustsScrollViewInsets = NO;
    _height = [[UIApplication sharedApplication] statusBarFrame].size.height + self.navigationController.navigationBar.frame.size.height;

    [self.rightBarItem setImage:[UIImage imageNamed:@"bottom_arrow"] forState:UIControlStateNormal];
    [self.rightBarItem setTitle:@"筛选" forState:UIControlStateNormal];
    self.rightBarItem.hidden = NO;
    self.rightBarItem.ztButtonStyle = ZTButtonStyleTextLeftImageRight;

    [self getDataWithType:@"2"];
}
- (void)getDataWithType:(NSString *)type{
    [MBProgressHUD showMessage:@"请稍等"];
    NSString *tempStoreId = storeID;
    NSString *loadUrl = [NSString stringWithFormat:@"%@api/merchant/searchStoreEvaluation?token=%@&storeId=%@&type=%@",kBaseURL, TOKEN, tempStoreId, type];
      
    [[QYXNetTool shareManager] postNetWithUrl:loadUrl urlBody:nil bodyStyle:QYXBodyString header:nil response:QYXJSON success:^(id result) {
        [MBProgressHUD hideHUD];

        ZTLog(@"result==%@",result);
        NSDictionary * firstDic = [result objectForKey:@"obj"][0];
        _sumstr = [NSString stringWithFormat:@"%@",[firstDic objectForKey:@"cnt"]];


        if ([_sumstr integerValue] != 0) {
            _dataArr = [NSMutableArray array];
            _allScoreArr = [NSMutableArray array];

            rightBarItem.userInteractionEnabled = YES;
            NSArray * commentArr = [firstDic objectForKey:@"myEvaluationEntity"];
            [commentArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                JudgeModel *model = [JudgeModel mj_objectWithKeyValues:obj];
                [_dataArr addObject:model];
                [_allScoreArr addObject:model.score];
            }];
            //星星评价展示
            _tempAllScoreArr = [NSMutableArray arrayWithArray:_allScoreArr];
            //星星总评价 和 标签排序
            _scorePoint = [NSString stringWithFormat:@"%@",[firstDic objectForKey:@"avgScore"]];
            NSDictionary * mapdict = [firstDic objectForKey:@"tagMap"];
            NSArray * keys = mapdict.allKeys;

            keys = [keys sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
                NSComparisonResult result = [obj1 compare:obj2];
                return result==NSOrderedDescending;
            }];
            showTagArr = [NSMutableArray new];
            for (int i=0; i<keys.count;i++) {
                NSString * key = [keys objectAtIndex:i];
                NSString * value = [mapdict valueForKey:key];

                NSString * plstr = [NSString stringWithFormat:@"%@%@",key,value];

                [showTagArr addObject:plstr];

            }
            [self Creattable];
        } else {
            [self Creatimge];
            rightBarItem.userInteractionEnabled = NO;

        }
    } failure:^(NSError *error) {

        [MBProgressHUD hideHUD];

    }];
}
#pragma  mark 猫
-(void)Creatimge {
    UIImageView * catimage = [[UIImageView alloc]init];
    catimage.image = [UIImage imageNamed:@"暂无数据"];
    [self.view addSubview:catimage];
    catimage.sd_layout.centerXEqualToView(self.view).centerYEqualToView(self.view).widthIs(catimage.image.size.width * 2).heightIs(catimage.image.size.width * 2);



}
-(void)Creattable {
    headView = nil;
    [headView removeFromSuperview];
    if (!headView) {
        headView = [[UIView alloc]init];
        headView.backgroundColor = [UIColor whiteColor];
        headView.frame = CGRectMake(0, _height, kScreenWidth, autoScaleH(170));
        [self.view addSubview:headView];

    }
    UILabel * headlabel = [[UILabel alloc]init];
    headlabel.text = @"综合评分";
    headlabel.font = [UIFont systemFontOfSize:autoScaleW(17)];
    headlabel.textColor = [UIColor blackColor];
    headlabel.textAlignment = NSTextAlignmentCenter;
    [headView addSubview:headlabel];
    headlabel.sd_layout.centerXEqualToView(headView).topSpaceToView(headView,autoScaleH(30)).widthIs(autoScaleW(100)).heightIs(autoScaleH(20));

    for (int i=0; i<5; i++) {

        UIImageView * xingimage = [[UIImageView alloc]init];
        xingimage.image = [UIImage imageNamed:@"56"];
        [headView addSubview:xingimage];

        xingimage.sd_layout.leftSpaceToView( headView,(kScreenWidth-5*autoScaleW(35))/2+i*autoScaleW(35)).topSpaceToView(headlabel,autoScaleH(20)).widthIs(autoScaleW(25)).heightIs(autoScaleH(25));

    }

    if ([_scorePoint rangeOfString:@"."].location!=NSNotFound) {


        float x = [_scorePoint floatValue];
        int v = ceilf(x);
        if ([[_scorePoint substringWithRange:NSMakeRange(2, 1)] integerValue]<5) {
            for (int i=0; i<v; i++) {

                UIImageView * xingimage = [[UIImageView alloc]init];
                if (i!=(v-1)) {
                    xingimage.image = [UIImage imageNamed:@"x"];
                }
                else {
                    xingimage.image = [UIImage imageNamed:@"半"];
                }
                [headView addSubview:xingimage];

                xingimage.sd_layout.leftSpaceToView( headView,(kScreenWidth-5*autoScaleW(35))/2+i*autoScaleW(35)).topSpaceToView(headlabel,autoScaleH(20)).widthIs(autoScaleW(25)).heightIs(autoScaleH(25));
            }

        } else {
            for (int i=0; i<v; i++) {

                UIImageView * xingimage = [[UIImageView alloc]init];

                xingimage.image = [UIImage imageNamed:@"x"];
                [headView addSubview:xingimage];

                xingimage.sd_layout.leftSpaceToView( headView,(kScreenWidth-5*autoScaleW(35))/2+i*autoScaleW(35)).topSpaceToView(headlabel,autoScaleH(20)).widthIs(autoScaleW(25)).heightIs(autoScaleH(25));
            }

        }


    } else {

        for (int i=0; i<[_scorePoint integerValue]; i++) {
            UIImageView * xingimage = [[UIImageView alloc]init];
            xingimage.image = [UIImage imageNamed:@"x"];
            [headView addSubview:xingimage];

            xingimage.sd_layout.leftSpaceToView( headView,(kScreenWidth-[_scorePoint integerValue]*autoScaleW(35))/2+i*autoScaleW(35)).topSpaceToView(headlabel,autoScaleH(20)).widthIs(autoScaleW(25)).heightIs(autoScaleH(25));
        }



    }



    for (int i =0; i<showTagArr.count ; i++) {
        UILabel * bqlabel = [[UILabel alloc]init];
        bqlabel.text = showTagArr[i];
        bqlabel.textColor = [UIColor grayColor];
        bqlabel.layer.borderWidth = 0.5;
        bqlabel.textAlignment = NSTextAlignmentCenter;
        bqlabel.font= [UIFont systemFontOfSize:autoScaleW(9)];
        bqlabel.layer.borderColor = RGB(205, 205, 205).CGColor;
        bqlabel.layer.masksToBounds = YES;
        bqlabel.layer.cornerRadius = autoScaleW(3);
        [headView addSubview:bqlabel];
        bqlabel.sd_layout.leftSpaceToView(headView,(kScreenWidth-showTagArr.count*autoScaleW(75))/2+i*autoScaleW(75)).topSpaceToView(headlabel,autoScaleH(57)).widthIs(autoScaleW(65)).heightIs(autoScaleH(15));
        if (i == showTagArr.count - 1) {
            [headView setupAutoHeightWithBottomView:bqlabel bottomMargin:13];
        }


    }
    UILabel* linlabel = [[UILabel alloc]init];
    linlabel.backgroundColor = [UIColor lightGrayColor];
    [headView addSubview:linlabel];
    linlabel.sd_layout.leftEqualToView(headView).rightEqualToView(headView).topSpaceToView(headlabel,autoScaleH(80)).heightIs(0.5);

    UILabel * sslabel = [[UILabel alloc]init];
    sslabel.text = @"餐厅评价";
    sslabel.textColor = [UIColor blackColor];
    sslabel.font =[UIFont systemFontOfSize:autoScaleW(13)];
    [headView addSubview:sslabel];
    sslabel.sd_layout.leftSpaceToView(headView,autoScaleW(15)).topSpaceToView(linlabel,autoScaleH(10)).widthIs(autoScaleW(80)).heightIs(autoScaleH(15));
    UILabel * ssslabel = [[UILabel alloc]init];
    ssslabel.text = [NSString stringWithFormat:@"%@条评价",_sumstr];
    ssslabel.textColor = [UIColor blackColor];
    ssslabel.font =[UIFont systemFontOfSize:autoScaleW(13)];
    [headView addSubview:ssslabel];
    ssslabel.sd_layout.rightSpaceToView(headView,autoScaleW(15)).topSpaceToView(linlabel,autoScaleH(10)).widthIs(autoScaleW(80)).heightIs(autoScaleH(15));

    UILabel* llinlabel = [[UILabel alloc]init];
    llinlabel.backgroundColor = [UIColor lightGrayColor];
    [headView addSubview:llinlabel];
    llinlabel.sd_layout.leftEqualToView(headView).rightEqualToView(headView).topSpaceToView(linlabel,autoScaleH(30)).heightIs(0.5);

    [headView setupAutoHeightWithBottomView:linlabel bottomMargin:10];
    [headView updateLayout];
    _commentTableV =[[UITableView alloc]init];
    _commentTableV.separatorStyle = UITableViewCellSeparatorStyleNone;
    _commentTableV.delegate = self;
    _commentTableV.dataSource = self;
    _commentTableV.tableHeaderView = headView;
    //    _commentTableV.estimatedRowHeight = 250;
    //    _commentTableV.rowHeight = UITableViewAutomaticDimension ;
    [self.view addSubview:_commentTableV];
    _commentTableV.sd_layout.leftSpaceToView(self.view,0).topSpaceToView(self,_height).widthIs(kScreenWidth).heightIs(kScreenHeight-_height);


}
-(void)leftBarButtonItemAction
{
    [self dismissViewControllerAnimated:YES completion:^{

    }];
}
#pragma mark 筛选按钮
-(void)rightBarButtonItemAction:(ButtonStyle *)sender
{
    sender.selected = !sender.selected;
    if (sender.selected == YES) {
         [sender setImage:[UIImage imageNamed:@"top_arrow"] forState:UIControlStateNormal];
    } else {
         [sender setImage:[UIImage imageNamed:@"bottom_arrow"] forState:UIControlStateNormal];
    }
    if (_selectView == nil) {
        _selectView = [[ZTSelectLabel alloc] initWithTitleArr:@[@"等级"] TopArr:@[@"全部",@"好评",@"差评",] BottomArr:nil formatOptions:@{ZTTouchObject:sender}];
    }
    [_selectView showSelectButtonView];

    @weakify(self);

    _selectView.buttonClickBlock = ^(NSInteger type, NSInteger index, NSArray<NSString *> *timeArr, ButtonStyle *sender) {

        @strongify(self);

        if (type == 0) {

            switch (index) {
                case 0:
                   [self getDataWithType:@"2"];;
                    break;
                case 1:
                    [self getDataWithType:@"1"];
                    break;
                case 2:
                    [self getDataWithType:@"0"];
                    break;
                default:
                    break;
            }
        }
    };

}

#pragma mark 第二行
-(void)Bian:(ButtonStyle *)bbtn
{
    _tidaibtn.selected = NO;
    _tidaibtn.layer.borderColor = RGB(181, 181, 181).CGColor;
    bbtn.selected = YES;
    bbtn.layer.borderColor = UIColorFromRGB(0xfd7577).CGColor;

    _tidaibtn = bbtn;

    if (bbtn.tag==300) {
        [self getDataWithType:@"2"];
    }
    if (bbtn.tag==301) {
        [self getDataWithType:@"1"];
    }
    if (bbtn.tag==302) {
        [self getDataWithType:@"0"];
    }

}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [tableView cellHeightForIndexPath:indexPath cellContentViewWidth:[self cellContentViewWith] tableView:tableView];
//    return  [tableView cellHeightForIndexPath:indexPath model: _dataArr[indexPath.row] keyPath:@"model" cellClass:[JudgeTableViewCell class] contentViewWidth:[self  cellContentViewWith]];
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArr.count;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *CellIdentifier = [NSString stringWithFormat:@"out%@", indexPath];
    // 通过不同标识创建cell实例
    JudgeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    // 判断为空进行初始化  --（当拉动页面显示超过主页面内容的时候就会重用之前的cell，而不会再次初始化）
    if (!cell) {
        cell = [[JudgeTableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
    }
    cell.model = _dataArr[indexPath.row];
    cell.reloadBlock = ^(BOOL reload){
        if (reload) {
            [self getDataWithType:[NSString stringWithFormat:@"%ld", 302 - _tidaibtn.tag]];
        }
    };
    [cell useCellFrameCacheWithIndexPath:indexPath tableView:tableView];
    return cell;
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
