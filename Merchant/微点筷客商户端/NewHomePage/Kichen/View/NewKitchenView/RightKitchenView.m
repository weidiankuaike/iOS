//
//  RightKitchenView.m
//  微点筷客商户端
//
//  Created by Skyer God on 16/11/10.
//  Copyright © 2016年 张森森. All rights reserved.
//

#import "RightKitchenView.h"
#define ZTMainScreen [UIScreen mainScreen].bounds

@interface RightKitchenView ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, assign) BOOL isBack;
@end
@implementation RightKitchenView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.isBack = NO;
        self.frame = CGRectMake(kScreenWidth + 1, 0, kScreenWidth * 0.75, kScreenHeight);
        self.backgroundColor = [UIColor colorWithDisplayP3Red:0 green:0 blue:0 alpha:07];

        [self createNaviView];
        [self createMainView];

        _maskView = [[UIView alloc] init];
        _maskView.backgroundColor = RGBA(0, 0, 0, 0.4);

        UIWindow *window = [UIApplication sharedApplication].keyWindow;
        [window addSubview:_maskView];
        [window addSubview:self];

        _maskView.sd_layout
        .topEqualToView(self)
        .rightEqualToView(window)
        .bottomEqualToView(self)
        .widthIs(kScreenWidth);

        _maskView.hidden = YES;

    }
    return self;
}
- (void)createMainView{
    _topNaviLabel = [[UILabel alloc] init];
    _topNaviLabel.text =  @"等级上菜";
    _topNaviLabel.textColor = [UIColor whiteColor];
    _topNaviLabel.font = [UIFont systemFontOfSize:15];
    _topNaviLabel.textAlignment = NSTextAlignmentCenter;
    _topNaviLabel.backgroundColor = UIColorFromRGB(0xfd7577);
    [self addSubview:_topNaviLabel];

    _bottomNaviView = [[UIView alloc] init];
    _bottomNaviView.backgroundColor = UIColorFromRGB(0xfd7577);
    [self addSubview:_bottomNaviView];

    _backBT = [ButtonStyle buttonWithType:UIButtonTypeCustom];
    [_backBT setTitle:@"收起餐盘" forState:UIControlStateNormal];
    [_backBT setTitleColor:UIColorFromRGB(0xfd7577) forState:UIControlStateNormal];
    [_backBT setBackgroundColor:[UIColor whiteColor]];
    [_backBT.titleLabel setFont:[UIFont systemFontOfSize:15]];
    [_backBT addTarget:self action:@selector(backBTAction:) forControlEvents:UIControlEventTouchUpInside];
    [_bottomNaviView addSubview:_backBT];

    _callDishes = [ButtonStyle buttonWithType:UIButtonTypeCustom];
    [_callDishes setTitle:@"呼叫上菜" forState:UIControlStateNormal];
    _callDishes.titleLabel.font = _backBT.titleLabel.font;
    [_bottomNaviView addSubview:_callDishes];


    _tabelV = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    _tabelV.delegate = self;
    _tabelV.dataSource = self;
    _tabelV.showsVerticalScrollIndicator = NO;
    _tabelV.showsHorizontalScrollIndicator = NO;
    _tabelV.separatorStyle = 0;
    _tabelV.backgroundColor = [UIColor whiteColor];
    [self addSubview:_tabelV];

    _topNaviLabel.sd_layout
    .leftSpaceToView(_naviView, 0)
    .topSpaceToView(self, 20)
    .rightEqualToView(self)
    .heightIs(44);

    _bottomNaviView.sd_layout
    .leftEqualToView(_topNaviLabel)
    .rightEqualToView(_topNaviLabel)
    .bottomEqualToView(self)
    .heightIs(49);

    _backBT.sd_layout
    .leftEqualToView(_bottomNaviView)
    .topSpaceToView(_bottomNaviView,0.8)
    .bottomEqualToView(_bottomNaviView)
    .widthRatioToView(_bottomNaviView, 0.5);

    _callDishes.sd_layout
    .topEqualToView(_bottomNaviView)
    .rightEqualToView(_bottomNaviView)
    .bottomEqualToView(_bottomNaviView)
    .widthRatioToView(_bottomNaviView, 0.5);

    _tabelV.sd_layout
    .leftEqualToView(_topNaviLabel)
    .topSpaceToView(_topNaviLabel, 0)
    .rightEqualToView(self)
    .bottomSpaceToView(_bottomNaviView, 0);


}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}
-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return @"11号桌";
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 10;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    NSString *str = [NSString stringWithFormat:@"dishesCell%ld%ld", (long)indexPath.section, indexPath.row];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:str];

    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:str];
    }
    cell.selectionStyle = 0;
    cell.textLabel.text = @"肉末茄子";
    return cell;
}
- (void)backBTAction:(ButtonStyle *)sender{

    [UIView animateWithDuration:.35 animations:^{
        self.maskView.alpha = 0;
        self.maskView.hidden = YES;
        self.frame = CGRectMake(kScreenWidth - _naviView.frame.size.width, 0, kScreenWidth * 0.75, kScreenHeight);


    }  completion:^(BOOL finished) {

        self.maskView.alpha = 1;
    }];

    _isBack = NO;
}
- (void)cancelButtonAction:(ButtonStyle *)sender{

    [UIView animateWithDuration:.35 animations:^{
        self.maskView.alpha = 0;
        self.maskView.hidden = YES;
        self.frame = CGRectMake(kScreenWidth + 1, 0, kScreenWidth * 0.75, kScreenHeight);


    }  completion:^(BOOL finished) {

        self.maskView.alpha = 0;
    }];
    _isBack = NO;
}
- (void)palateBTAction:(ButtonStyle *)sender{

    if (_isBack == NO) {
        self.maskView.alpha = 0;

        [UIView animateWithDuration:.35 animations:^{
            self.maskView.alpha = 1;

            self.frame = CGRectMake(kScreenWidth * 0.25, 0, kScreenWidth * 0.75, kScreenHeight);
            self.maskView.hidden = NO;
            
        }];
    }
    _isBack = YES;
}
- (void)createNaviView{

    _naviView = [[UIView alloc] init];
    _naviView.backgroundColor = RGBA(0, 0, 0, 0.8);
    [self addSubview:_naviView];
    
    _sortImageV = [[UIImageView alloc] init];
    _sortImageV.image = [UIImage imageNamed:@"白色搜索"];
    [_naviView addSubview:_sortImageV];

    _sortBT = [ButtonStyle buttonWithType:UIButtonTypeCustom];
    [_sortBT setTitle:@"菜品" forState:UIControlStateNormal];
    _sortBT.titleLabel.numberOfLines = 0;
    _sortBT.titleLabel.baselineAdjustment = UIBaselineAdjustmentAlignCenters;
    [_naviView addSubview:_sortBT];

    _midSeparaLine = [[UILabel alloc] init];
    _midSeparaLine.backgroundColor = [UIColor whiteColor];
    [_naviView addSubview:_midSeparaLine];

    _promptBT = [ButtonStyle buttonWithType:UIButtonTypeCustom];
    [_promptBT setBackgroundColor:[UIColor redColor]];
    [_promptBT setTitle:@"3" forState:UIControlStateNormal];
    [_promptBT.titleLabel setFont:[UIFont systemFontOfSize:12]];
    [_naviView addSubview:_promptBT];


    _palateBT = [ButtonStyle buttonWithType:UIButtonTypeCustom];
    [_palateBT setTitle:@"餐盘" forState:UIControlStateNormal];
    _palateBT.titleLabel.numberOfLines = 0;
    _palateBT.titleLabel.baselineAdjustment = UIBaselineAdjustmentAlignCenters;
    [_palateBT addTarget:self action:@selector(palateBTAction:) forControlEvents:UIControlEventTouchUpInside];
    [_naviView addSubview:_palateBT];

    _revokeImageV = [[UIImageView alloc] init];
    _revokeImageV.image = [UIImage imageNamed:@"撤销"];
    [_naviView addSubview:_revokeImageV];

    _revokeBT = [ButtonStyle buttonWithType:UIButtonTypeCustom];
    [_revokeBT setTitle:@"撤销" forState:UIControlStateNormal];
    _revokeBT.titleLabel.numberOfLines = 0;
    _revokeBT.titleLabel.baselineAdjustment = UIBaselineAdjustmentAlignCenters;
    [_naviView addSubview:_revokeBT];

    _bottomSeparaLine = [[UILabel alloc] init];
    _bottomSeparaLine.backgroundColor = [UIColor whiteColor];
    [_naviView addSubview:_bottomSeparaLine];

    _cancelImageV = [[UIImageView alloc] init];
    _cancelImageV.image = [UIImage imageNamed:@"取消"];
    [_naviView addSubview:_cancelImageV];

    _cancelBT = [ButtonStyle buttonWithType:UIButtonTypeCustom];
    [_cancelBT setTitle:@"取消" forState:UIControlStateNormal];
    _cancelBT.titleLabel.numberOfLines = 0;
    _cancelBT.titleLabel.baselineAdjustment = UIBaselineAdjustmentAlignCenters;
    [_cancelBT addTarget:self action:@selector(cancelButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [_naviView addSubview:_cancelBT];




    _naviView.sd_layout
    .leftEqualToView(self)
    .topEqualToView(self)
    .widthIs(50)
    .bottomEqualToView(self);

    _sortImageV.sd_layout
    .centerXEqualToView(_naviView)
    .topSpaceToView(_naviView, 40)
    .widthIs(_sortImageV.image.size.width * 1.5)
    .heightIs(_sortImageV.image.size.height * 1.5);

    _sortBT.sd_layout
    .centerXEqualToView(_naviView)
    .topSpaceToView(_sortImageV, 2)
    .widthIs(20)
    .heightIs(50);

    _midSeparaLine.sd_layout
    .leftSpaceToView(_naviView, 5)
    .rightSpaceToView(_naviView, 5)
    .heightIs(1)
    .topSpaceToView(_sortBT, 150);

    _promptBT.sd_layout
    .centerXEqualToView(_naviView)
    .topSpaceToView(_midSeparaLine, 20)
    .widthIs(15)
    .heightEqualToWidth();
    [_promptBT setSd_cornerRadiusFromWidthRatio:@(0.5)];

    _palateBT.sd_layout
    .centerXEqualToView(_naviView)
    .topSpaceToView(_promptBT, 5)
    .widthIs(20)
    .heightIs(50);

    _cancelBT.sd_layout
    .centerXEqualToView(_naviView)
    .bottomSpaceToView(_naviView, 40)
    .widthIs(20)
    .heightIs(50);

    _cancelImageV.sd_layout
    .centerXEqualToView(_naviView)
    .bottomSpaceToView(_cancelBT, 3)
    .widthIs(_cancelImageV.image.size.width * 1.5)
    .heightIs(_cancelImageV.image.size.height * 1.5);

    _bottomSeparaLine.sd_layout
    .bottomSpaceToView(_cancelImageV, 50)
    .leftEqualToView(_midSeparaLine)
    .rightEqualToView(_midSeparaLine)
    .heightRatioToView(_midSeparaLine, 1);

    _revokeBT.sd_layout
    .centerXEqualToView(_naviView)
    .bottomSpaceToView(_bottomSeparaLine, 50)
    .widthIs(20)
    .heightRatioToView(_cancelBT, 1);

    _revokeImageV.sd_layout
    .centerXEqualToView(_naviView)
    .bottomSpaceToView(_revokeBT, 3)
    .widthIs(_revokeImageV.image.size.width * 1.5)
    .heightIs(_revokeImageV.image.size.height * 1.5);


}

/** 隐藏多余的分割线 **/
-(void)setExtraCellLineHidden: (UITableView *)tableView
{
    UIView *view = [UIView new];

    view.backgroundColor = [UIColor clearColor];

    [tableView setTableFooterView:view];
}
@end
