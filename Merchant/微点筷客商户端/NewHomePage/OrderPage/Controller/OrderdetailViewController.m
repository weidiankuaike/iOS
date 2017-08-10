//
//  OrderdetailViewController.m
//  微点筷客商户端
//
//  Created by 张森森 on 16/10/10.
//  Copyright © 2016年 张森森. All rights reserved.
//

#import "OrderdetailViewController.h"
#import "UIBarButtonItem+SSExtension.h"
#import <UIImageView+WebCache.h>
#import "NSObject+JudgeNull.h"
#import "ZTPrintFormatVC.h"
#import "CancleOrderViewController.h"
#import "ZTAddOrSubAlertView.h"
#import "NSString+TimeHandle.h"
#import "BackDishesVC.h"
#import "UIView+DrawLayer.h"
@interface OrderdetailViewController ()
@property (nonatomic,strong)UIView * bigview;
@property (nonatomic,strong)NSArray * moneyary;
@property (nonatomic,strong)NSArray * rmoneyary;
/** 背景scrollView   (strong) **/
@property (nonatomic, strong) UIScrollView *scrollView;
@end

@implementation OrderdetailViewController

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    self.tabBarController.tabBar.hidden = YES;
}

-(UIScrollView *)scrollView{
    if (!_scrollView) {
        self.automaticallyAdjustsScrollViewInsets = NO;
        _scrollView = [[UIScrollView alloc] initWithFrame:self.view.frame];
        _scrollView.backgroundColor = self.view.backgroundColor;
        //        _scrollView.delegate = self;
        _scrollView.scrollEnabled = YES;
        _scrollView.scrollsToTop = NO;
        _scrollView.bounces = NO;
        [self.view addSubview:_scrollView];
        _scrollView.sd_layout.spaceToSuperView(UIEdgeInsetsMake(0, 0, autoScaleH(40), 0));
    }
    return _scrollView;
}
- (void)viewDidLoad {

    [super viewDidLoad];

    self.titleView.text = @"订单编号";
    self.view.backgroundColor = [UIColor whiteColor];
    self.scrollView.backgroundColor = self.view.backgroundColor;

    //打印
    UIBarButtonItem *rightBarItem = [UIBarButtonItem itemWithTarget:self Action:@selector(rightBarClick:) image:@"white_print" selectImage:nil];

    UIBarButtonItem *backRightBarItem = [UIBarButtonItem itemWithTarget:self Action:@selector(backRightBarItemClick:) image:@"back_icon" selectImage:nil];
    self.navigationItem.rightBarButtonItems = @[rightBarItem,backRightBarItem];
    if (_model.beBackDets.count > 0 && (_ztingeger == 1 || _ztingeger == 2)) {
        backRightBarItem.enabled = YES;
    } else {
        backRightBarItem.enabled = NO;
    }
    CGFloat height = [[UIApplication sharedApplication] statusBarFrame].size.height + self.navigationController.navigationBar.frame.size.height;
    UIImageView * headimage = [[UIImageView alloc]init];
    [headimage sd_setImageWithURL:[NSURL URLWithString:_model.imagestr]placeholderImage:[UIImage imageNamed:@"loadingIcon"]];
    [_scrollView addSubview:headimage];
    headimage.sd_layout.leftSpaceToView(_scrollView,autoScaleW(35)).topSpaceToView(_scrollView,autoScaleH(15)+height).widthIs(autoScaleW(38)).heightIs(autoScaleH(38));
    [headimage setSd_cornerRadiusFromHeightRatio:@(0.5)];

    UILabel * firstlabel = [[UILabel alloc]init];
    firstlabel.text = _model.namestr;
    firstlabel.textAlignment = NSTextAlignmentCenter;
    firstlabel.font = [UIFont systemFontOfSize:autoScaleW(11)];
    [_scrollView addSubview:firstlabel];
    firstlabel.textColor = [UIColor lightGrayColor];

    firstlabel.sd_layout.centerXEqualToView(headimage).topSpaceToView(headimage,autoScaleH(8)).heightIs(autoScaleH(15));
    [firstlabel setSingleLineAutoResizeWithMaxWidth:80];


    NSString * string = @"";
    if ([_model.disOrderType integerValue] == 1) {
        string = [NSString stringWithFormat:@"到店下单时间:%@",_model.arrivaltime];
    } else {
        string = [NSString stringWithFormat:@"预定时间:%@",_model.arrivaltime];
    }
    NSString * personstr = [NSString stringWithFormat:@"用餐人数:%@",_model.peoplenumstr];
 
    NSArray * xinxiary = @[string,personstr,];
    
    for (int i=0; i<2; i++)
    {
        UILabel * xinxilabel = [[UILabel alloc]init];
        xinxilabel.text = xinxiary[i];
        xinxilabel.textAlignment = NSTextAlignmentLeft;
        xinxilabel.font = [UIFont systemFontOfSize:autoScaleW(13)];
        [_scrollView addSubview:xinxilabel];
        xinxilabel.sd_layout.leftSpaceToView(_scrollView,autoScaleW(95)).topSpaceToView(_scrollView,height+autoScaleH(25)+i*(autoScaleH(25))).widthIs(autoScaleW(170)).heightIs(autoScaleH(15));
        xinxilabel.adjustsFontSizeToFitWidth = YES;
    }
    
    UILabel * ztlabel = [[UILabel alloc]init];
    ztlabel.font = [UIFont systemFontOfSize:autoScaleW(15)];
    if ([_model.ordertype isEqualToString:@"1"]||[_model.ordertype isEqualToString:@"11"]) {
        ztlabel.text = @"等待确认";
    }
    else if ([_model.ordertype isEqualToString:@"4"]||[_model.ordertype isEqualToString:@"14"]) {
        ztlabel.text = @"已预订";
    }
    else if ([_model.ordertype isEqualToString:@"18"]) {
        ztlabel.text = @"进行中";
    }
    else {
        ztlabel.text = @"已结束";
    }
    
    ztlabel.textColor = UIColorFromRGB(0xfd7577);
    [_scrollView addSubview:ztlabel];
    ztlabel.sd_layout.rightSpaceToView(_scrollView,autoScaleW(20)).topSpaceToView(_scrollView,autoScaleH(30)+height).widthIs(autoScaleW(80)).heightIs(autoScaleH(20));

    NSString * fstr = [NSString stringWithFormat:@"%@:%@",@"联系方式",_model.phonestr];
    NSString * sstr = [NSString stringWithFormat:@"%@:%@",@"订单编号",_model.ddbhstr];
    NSString * tstr = [NSString stringWithFormat:@"到店次数:第%@次到店吃饭",_model.severalStore];
    NSString * zstr = [NSString stringWithFormat:@"备注信息:"];
    NSArray * titleary = @[fstr,sstr,tstr,zstr];

    for (int i =0; i<4; i++)
    {

        UILabel * linelabel = [[UILabel alloc]init];
        linelabel.backgroundColor = RGB(228, 228, 228);
        [_scrollView addSubview:linelabel];
        linelabel.sd_layout.leftSpaceToView(_scrollView,autoScaleW(15)).rightSpaceToView(_scrollView,autoScaleW(15)).topSpaceToView(firstlabel,autoScaleH(10)+i*autoScaleH(32)).heightIs(autoScaleH(1));
        UILabel * lianxilabel = [[UILabel alloc]init];
        lianxilabel.text = titleary[i];
        if (i == 0) {
            lianxilabel.textColor = [UIColor orangeColor];
        } else {
            lianxilabel.textColor = [UIColor blackColor];
        }

        lianxilabel.font  =[UIFont systemFontOfSize:autoScaleW(13)];
        [_scrollView addSubview:lianxilabel];
        lianxilabel.sd_layout.leftSpaceToView(_scrollView,autoScaleW(15)).topSpaceToView(linelabel,autoScaleH(8)).heightIs(autoScaleH(15)).widthIs(kScreenWidth-autoScaleW(30)-autoScaleW(160));

        if (i==0) {

            ButtonStyle * phonebtn = [ButtonStyle buttonWithType:UIButtonTypeCustom];
            [phonebtn setBackgroundImage:[UIImage imageNamed:@"电话"] forState:UIControlStateNormal];
            [phonebtn addTarget:self action:@selector(Phone) forControlEvents:UIControlEventTouchUpInside];
            [_scrollView addSubview:phonebtn];
            phonebtn.sd_layout.rightSpaceToView(_scrollView,autoScaleW(35)).topSpaceToView(linelabel,autoScaleH(4)).widthIs(autoScaleW(20)).heightIs(autoScaleH(20));
        }
        if (i==1) {

            UILabel * lianxilabel = [[UILabel alloc]init];
            lianxilabel.text = [NSString stringWithFormat:@"%@:%@",@"下单时间",_model.creattime];
            lianxilabel.textColor = [UIColor blackColor];
            lianxilabel.textAlignment = NSTextAlignmentRight;
            lianxilabel.font  =[UIFont systemFontOfSize:autoScaleW(13)];
            [_scrollView addSubview:lianxilabel];
            lianxilabel.sd_layout.rightSpaceToView(_scrollView,autoScaleW(15)).topSpaceToView(linelabel,autoScaleH(8)).widthIs(autoScaleW(160)).heightIs(autoScaleH(15));
        }

    
    }

    UILabel * beizhulabel = [[UILabel alloc]init];
    if (![_model.remarkstr isNull])
    {

        beizhulabel.text = _model.remarkstr;
        NSMutableAttributedString * str = [[NSMutableAttributedString alloc]initWithString:beizhulabel.text];
        NSMutableParagraphStyle * parastyle = [[NSMutableParagraphStyle alloc]init];
        [parastyle setFirstLineHeadIndent:10];
        [parastyle setParagraphSpacingBefore:10];
        [str addAttribute:NSParagraphStyleAttributeName value:parastyle range:NSMakeRange(0, beizhulabel.text.length)];
        beizhulabel.attributedText = str;
    } else {
        beizhulabel.text = @"     暂无备注信息.";
    }
    beizhulabel.numberOfLines = 0;
    beizhulabel.layer.borderWidth = 1;
    beizhulabel.layer.borderColor = RGB(228, 228, 228).CGColor;
    beizhulabel.textColor = [UIColor lightGrayColor];
    beizhulabel.backgroundColor = RGB(248, 248, 248);
    beizhulabel.font = [UIFont systemFontOfSize:autoScaleW(13)];
    [_scrollView addSubview:beizhulabel];
    beizhulabel.sd_layout
    .leftSpaceToView(_scrollView,autoScaleW(15))
    .topSpaceToView(firstlabel,autoScaleH(33)*4)
    .widthIs(kScreenWidth-autoScaleW(30))
    .autoHeightRatio(0);

    beizhulabel.sd_layout
    .minHeightIs(30);

    /***************************************************/
    /********************菜单menu***************************/
    /***************************************************/
    UILabel *firstMenuLabel = nil;
    NSArray *dishesArr = @[@"菜品", @"数量", @"价格"];
    CGFloat start_x = 0;
    CGFloat width = (self.view.size.width - start_x * 2) / 3;
    for (NSInteger i = 0; i < dishesArr.count; i++) {
        UILabel * menuLabel = [[UILabel alloc]init];
        menuLabel.text = dishesArr[i];
        menuLabel.textColor = [UIColor grayColor];
        menuLabel.textAlignment = NSTextAlignmentCenter;
        menuLabel.font  =[UIFont systemFontOfSize:autoScaleW(13)];
        [_scrollView addSubview:menuLabel];
        menuLabel.sd_layout
        .leftSpaceToView(_scrollView,start_x + i * width)
        .topSpaceToView(beizhulabel,autoScaleH(15))
        .widthIs(width)
        .heightIs(autoScaleH(25));
        if (i == 0) {
            firstMenuLabel = menuLabel;
        }
    }
    UILabel * topMenuLine = [[UILabel alloc]init];
    topMenuLine.backgroundColor = [UIColor blackColor];
    [_scrollView addSubview:topMenuLine];
    topMenuLine.sd_layout
    .leftSpaceToView(_scrollView,autoScaleW(15))
    .rightSpaceToView(_scrollView,autoScaleW(15))
    .topSpaceToView(firstMenuLabel,autoScaleH(5))
    .heightIs(autoScaleH(0.6));

    /****************                               ********/
    /*********              菜单详情                 *******/
    /****************                               ********/
    if (_model.caipinary) {
        for (int i=0; i<_model.caipinary.count; i++) {
            UIColor *commanColor = [UIColor blackColor];
            UILabel * caidanlabel = [[UILabel alloc]init];
            [_scrollView addSubview:caidanlabel];
            caidanlabel.textColor = commanColor;


            UILabel * namelabel = [[UILabel alloc]init];
            namelabel.text = _model.caipinary[i];
            namelabel.font = [UIFont systemFontOfSize:autoScaleW(13)];
            [caidanlabel addSubview:namelabel];
            namelabel.textColor = commanColor;


            UILabel * sllabel = [[UILabel alloc]init];
            sllabel.text = [NSString stringWithFormat:@"%@份",_model.numary[i]];
            sllabel.font = [UIFont systemFontOfSize:autoScaleW(13)];
            sllabel.textColor = commanColor;
            [caidanlabel addSubview:sllabel];

            UILabel * moneylabel = [[UILabel alloc]init];
            moneylabel.textAlignment = NSTextAlignmentRight;
            CGFloat money = [_model.caimoneyary[i] floatValue];
            if (floor(money) == money) {
                moneylabel.text = [NSString stringWithFormat:@"￥%.0lf",money];
            } else {
                moneylabel.text = [NSString stringWithFormat:@"￥%.2lf",money];
            }

            moneylabel.font = [UIFont systemFontOfSize:autoScaleW(13)];
            moneylabel.textColor = commanColor;
            [caidanlabel addSubview:moneylabel];
            caidanlabel.sd_layout
            .leftSpaceToView(_scrollView,autoScaleW(15))
            .topSpaceToView(topMenuLine,autoScaleH(5)+i*autoScaleH(20))
            .widthIs(kScreenWidth-autoScaleW(30))
            .heightIs(15);

            namelabel.sd_layout
            .leftSpaceToView(caidanlabel,autoScaleW(28))
            .topSpaceToView(caidanlabel,0)
            .widthIs(autoScaleW(150))
            .heightIs(autoScaleH(15));

            sllabel.sd_layout
            .centerXEqualToView(caidanlabel)
            .topSpaceToView(caidanlabel,0)
            .widthIs(autoScaleW(30))
            .heightIs(autoScaleH(15));

            moneylabel.sd_layout
            .rightSpaceToView(caidanlabel,autoScaleW(28))
            .topSpaceToView(caidanlabel,0)
            .widthIs(autoScaleW(60))
            .heightIs(autoScaleH(15));

        }

    }

    UILabel * menuBottomLine = [[UILabel alloc]init];
    menuBottomLine.backgroundColor = RGB(208, 208, 208);
    [_scrollView addSubview:menuBottomLine];

    menuBottomLine.sd_layout
    .leftSpaceToView(_scrollView,autoScaleW(15))
    .rightSpaceToView(_scrollView,autoScaleW(15))
    .topSpaceToView(topMenuLine, autoScaleH(20)*_model.caipinary.count+autoScaleH(10))
    .heightRatioToView(topMenuLine, 1);

    UILabel * hasBackMoneyLB = [[UILabel alloc]init];
    hasBackMoneyLB.textColor = [UIColor orangeColor];
    hasBackMoneyLB.textAlignment = NSTextAlignmentRight;
    hasBackMoneyLB.font  =[UIFont systemFontOfSize:autoScaleW(13)];
    [_scrollView addSubview:hasBackMoneyLB];

    /****************                               ********/
    /*********              退菜菜单详情                 *******/
    /****************                               ********/

    CGFloat hasBackMoney = 0.00f;

    if (_model.hasBackDets.count > 0) {
        [menuBottomLine updateLayout];
        menuBottomLine.backgroundColor = [UIColor clearColor];
        [menuBottomLine drawDashLine:menuBottomLine lineLength:3 lineSpacing:2 lineColor:[UIColor blackColor]];

        UILabel *secMenuLabel = [[UILabel alloc] init];
        secMenuLabel.textAlignment = NSTextAlignmentCenter;
        secMenuLabel.text = @"已退菜品";
        secMenuLabel.font = [UIFont systemFontOfSize:autoScaleW(16)];
        [_scrollView addSubview:secMenuLabel];

        UILabel * secMenuTopLine = [[UILabel alloc]init];
        secMenuTopLine.backgroundColor = [UIColor blackColor];
        [_scrollView addSubview:secMenuTopLine];

        secMenuLabel.sd_layout
        .leftEqualToView(menuBottomLine)
        .rightEqualToView(menuBottomLine)
        .topSpaceToView(menuBottomLine, autoScaleH(10))
        .heightIs(autoScaleH(40));

        secMenuTopLine.sd_layout
        .leftEqualToView(menuBottomLine)
        .rightEqualToView(menuBottomLine)
        .topSpaceToView(secMenuLabel, 0)
        .heightRatioToView(menuBottomLine, 1);

        for (NSInteger i = 0 ; i < _model.hasBackDets.count; i++) {


            OrderPrintDetailModel *model = _model.hasBackDets[i];
            hasBackMoney += [model.pfee floatValue] * [model.quantity floatValue];
            UIColor *commanColor = [UIColor blackColor];
            UILabel * everyDishesBGD = [[UILabel alloc]init];
            [_scrollView addSubview:everyDishesBGD];
            everyDishesBGD.textColor = commanColor;


            UILabel * nameLabel = [[UILabel alloc]init];
            nameLabel.text = model.productName;
            nameLabel.font = [UIFont systemFontOfSize:autoScaleW(13)];
            [everyDishesBGD addSubview:nameLabel];
            nameLabel.textColor = commanColor;


            UILabel * numLabel = [[UILabel alloc]init];
            numLabel.text = [NSString stringWithFormat:@"%@份",model.quantity];
            numLabel.font = [UIFont systemFontOfSize:autoScaleW(13)];
            numLabel.textColor = commanColor;
            [everyDishesBGD addSubview:numLabel];

            UILabel * priceLabel = [[UILabel alloc]init];
            priceLabel.textAlignment = NSTextAlignmentRight;
            CGFloat money = [model.pfee doubleValue] * [model.quantity integerValue];
            priceLabel.textColor = [[UIColor redColor] colorWithAlphaComponent:0.5];
            if (floor(money) == money) {
                priceLabel.text = [NSString stringWithFormat:@"-￥%.0lf",money];
            } else {
                priceLabel.text = [NSString stringWithFormat:@"-￥%.2lf",money];
            }

            priceLabel.font = [UIFont systemFontOfSize:autoScaleW(13)];
            [everyDishesBGD addSubview:priceLabel];
            everyDishesBGD.sd_layout
            .leftEqualToView(menuBottomLine)
            .topSpaceToView(secMenuTopLine,autoScaleH(5)+i*autoScaleH(20))
            .widthIs(kScreenWidth-autoScaleW(30))
            .heightIs(15);

            nameLabel.sd_layout
            .leftSpaceToView(everyDishesBGD,autoScaleW(28))
            .topSpaceToView(everyDishesBGD,0)
            .widthIs(autoScaleW(150))
            .heightIs(autoScaleH(15));

            numLabel.sd_layout
            .centerXEqualToView(everyDishesBGD)
            .topSpaceToView(everyDishesBGD,0)
            .widthIs(autoScaleW(30))
            .heightIs(autoScaleH(15));

            priceLabel.sd_layout
            .rightSpaceToView(everyDishesBGD,autoScaleW(28))
            .topSpaceToView(everyDishesBGD,0)
            .widthIs(autoScaleW(60))
            .heightIs(autoScaleH(15));


        }
        UILabel * secmMenuBottomLine = [[UILabel alloc]init];
        secmMenuBottomLine.backgroundColor = RGB(208, 208, 208);
        [_scrollView addSubview:secmMenuBottomLine];
        
        secmMenuBottomLine.sd_layout
        .leftSpaceToView(_scrollView,autoScaleW(15))
        .rightSpaceToView(_scrollView,autoScaleW(15))
        .topSpaceToView(secMenuTopLine, autoScaleH(20)*_model.hasBackDets.count+autoScaleH(10))
        .heightIs(autoScaleH(1));

        hasBackMoneyLB.sd_layout
        .rightEqualToView(menuBottomLine)
        .topSpaceToView(secmMenuBottomLine,autoScaleH(8))
        .heightIs(autoScaleH(15));

    } else {
        hasBackMoneyLB.sd_layout
        .rightSpaceToView(_scrollView,autoScaleW(15))
        .topSpaceToView(menuBottomLine,autoScaleH(8))
        .heightIs(autoScaleH(15));
    }
    [hasBackMoneyLB setSingleLineAutoResizeWithMaxWidth:200];
    //[_model.totalmoney floatValue] - hasBackMoney]  菜总额 - 已退菜金额  计算完不包含优惠金额

    CGFloat realPayMoney = [_model.realTotalFee floatValue] - hasBackMoney;
    hasBackMoneyLB.text = hasBackMoney > 0 ? [NSString stringWithFormat:@"退菜金额共计：￥%.2f", hasBackMoney] : [NSString stringWithFormat:@"菜品金额共计：￥%.2f", [_model.totalmoney doubleValue]];
    if (_ztingeger==0||_ztingeger==1||_ztingeger==5) {
        if ([_model.cardTitle isNull]) {
            _moneyary = @[@"在线支付",];
            _rmoneyary = @[[NSString stringWithFormat:@"¥%.2f",realPayMoney]];
        } else {
            _moneyary = @[_model.cardTitle,@"在线支付",];
            _rmoneyary = @[_model.discountedPrice,[NSString stringWithFormat:@"¥%.2f",realPayMoney]];
        }
    }
    if (_ztingeger==2||_ztingeger==3||_ztingeger==4) {
        if ([_model.cardTitle isNull]) {
            _moneyary = @[@"在线支付",];
            _rmoneyary = @[[NSString stringWithFormat:@"¥%.2f",realPayMoney]];
        } else {
            _moneyary = @[_model.cardTitle,@"在线支付",];
            _rmoneyary = @[_model.discountedPrice,[NSString stringWithFormat:@"¥%.2f",realPayMoney]];
        }
    }
    /****************                               ********/
    /*********          在线支付 scrollView最底部      *******/
    /*********          在这里判断是否有退菜              *******/
    /****************                               ********/
    for (int i =0; i<_moneyary.count; i++)
    {

        UILabel * linelabel = [[UILabel alloc]init];
        linelabel.backgroundColor = RGB(228, 228, 228);
        [_scrollView addSubview:linelabel];

        UILabel * lianxilabel = [[UILabel alloc]init];
        lianxilabel.text = _moneyary[i];
        lianxilabel.textColor = [UIColor blackColor];
        lianxilabel.font  =[UIFont systemFontOfSize:autoScaleW(13)];
        [_scrollView addSubview:lianxilabel];


        UILabel * rlianxilabel = [[UILabel alloc]init];
        rlianxilabel.text = [NSString stringWithFormat:@"%@", _rmoneyary[i]];
        rlianxilabel.textColor = UIColorFromRGB(0xfd7577);
        rlianxilabel.textAlignment = NSTextAlignmentRight;
        rlianxilabel.font  =[UIFont systemFontOfSize:autoScaleW(13)];
        [_scrollView addSubview:rlianxilabel];

        linelabel.sd_layout
        .leftSpaceToView(_scrollView,autoScaleW(15))
        .rightSpaceToView(_scrollView,autoScaleW(15))
        .topSpaceToView(hasBackMoneyLB,autoScaleH(10)+i*autoScaleH(32))
        .heightIs(autoScaleH(1));
        lianxilabel.sd_layout
        .leftSpaceToView(_scrollView,autoScaleW(15))
        .topSpaceToView(linelabel,autoScaleH(8))
        .widthIs(autoScaleW(128))
        .heightIs(autoScaleH(15));
        rlianxilabel.sd_layout
        .rightSpaceToView(_scrollView,autoScaleW(15))
        .topSpaceToView(linelabel,autoScaleH(8))
        .widthIs(autoScaleW(128))
        .heightIs(autoScaleH(15));
        if (i == _moneyary.count -1) {
            [_scrollView setupAutoHeightWithBottomView:rlianxilabel bottomMargin:10];
        }
    }

    if (_ztingeger==1||_ztingeger==2||_ztingeger==4) {
        NSDateComponents *components = [NSString getDateSubFromNowTime:nil endTime:_model.arrivalTime];
        UILabel * konglabel = [[UILabel alloc]init];
        konglabel.backgroundColor = RGB(228, 228, 228);

        UILabel * bottomLabel = [[UILabel alloc]init];
        if (_ztingeger==1) {
            NSString *tempLateTitle = [NSString stringWithFormat:@"客人已迟到：%ld小时%ld分钟", (long)components.hour,  (long)components.minute];
            bottomLabel.hidden = YES;
            if (components.second < 0) {
                bottomLabel.hidden = NO;
                tempLateTitle = [NSString stringWithFormat:@"客人预计还需%ld小时%ld分钟到店", components.hour > 0 ? : - components.hour,  components.minute > 0 ?:-components.minute];
            } else if (components.hour == 0 && components.day == 0) {
                tempLateTitle = [NSString stringWithFormat:@"客人已迟到%ld分钟", (long)components.minute];
            } else if (components.day > 0) {
                tempLateTitle = [NSString stringWithFormat:@"客人已迟到%ld天%ld小时%ld分钟", (long)components.day, (long)components.hour, components.minute];
            } else {
                tempLateTitle = [NSString stringWithFormat:@"客人已迟到%ld小时%ld分钟", (long)components.hour, (long)components.minute];
            }
            bottomLabel.text = tempLateTitle;

        }
        if (_ztingeger==2) {
            bottomLabel.text = [NSString stringWithFormat:@"客人已用餐：%ld小时%ld分钟", (long)components.hour,  (long)components.minute];
        }
        if (_ztingeger==4) {

            bottomLabel.text = @"客人迟到30分钟";
        }

        bottomLabel.backgroundColor = [UIColorFromRGB(0xfd7577) colorWithAlphaComponent:0.6];
        bottomLabel.textColor = [UIColor whiteColor];
        bottomLabel.textAlignment = NSTextAlignmentCenter;
        bottomLabel.font = [UIFont systemFontOfSize:autoScaleW(13)];
        [self.view addSubview:bottomLabel];
        bottomLabel.sd_layout
        .leftEqualToView(self.view)
        .rightEqualToView(self.view)
        .bottomEqualToView(self.view)
        .heightIs(autoScaleH(40));
    }
    if (_ztingeger==3) {

        ButtonStyle * bottombtn = [ButtonStyle buttonWithType:UIButtonTypeCustom];
        [bottombtn setBackgroundColor:[UIColor blackColor]];
        [bottombtn setTitle:@"打印订单" forState:UIControlStateNormal];
        [bottombtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [bottombtn addTarget:self action:@selector(Dayin) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:bottombtn];
        bottombtn.sd_layout.leftEqualToView(self.view).rightEqualToView(self.view).bottomEqualToView(self.view).heightIs(autoScaleH(40));

    }
    NSDateComponents *components = [NSString getDateSubFromNowTime:nil endTime:_model.arrivalTime];
    NSString *tempLateTitle = [NSString stringWithFormat:@"客人已迟到：%ld小时%ld分钟", (long)components.hour,  (long)components.minute];
    if (components.second < 0) {
        tempLateTitle = [NSString stringWithFormat:@"客人预计还需%ld小时%ld分钟到店", components.hour > 0 ? : - components.hour,  components.minute > 0 ?:-components.minute];
    } else if (components.hour == 0 && components.day == 0) {
        tempLateTitle = [NSString stringWithFormat:@"客人已迟到%ld分钟", (long)components.minute];
    } else if (components.day > 0) {
        tempLateTitle = [NSString stringWithFormat:@"客人已迟到%ld天%ld小时%ld分钟", (long)components.day, (long)components.hour, components.minute];
    } else if (components.second >= 1){
        tempLateTitle = [NSString stringWithFormat:@"客人已迟到%ld小时%ld分钟", (long)components.hour, (long)components.minute];
    } else {
        tempLateTitle = @"客人已迟到";
    }

    NSArray * ddary = @[@"不接单",@"接单",];
    NSArray * ydary = @[tempLateTitle,@"取消订单",];

    if (_ztingeger==0||_ztingeger==5 || _ztingeger == 1) {

        for (int i=0; i<2; i++) {

            ButtonStyle * ddbtn = [ButtonStyle buttonWithType:UIButtonTypeCustom];
            if (_ztingeger==0) {
                [ddbtn setTitle:ddary[i] forState:UIControlStateNormal];

            }
            if (_ztingeger == 5 || _ztingeger == 1) {

                [ddbtn setTitle:ydary[i] forState:UIControlStateNormal];
                if (components.second < 0 && _ztingeger == 1) {
                    ddbtn.hidden = YES;
                } else {
                    ddbtn.hidden = NO;
                    ddbtn.titleLabel.adjustsFontSizeToFitWidth = YES;
                }
            }
            if (i==0) {

                [ddbtn setBackgroundColor:[UIColor whiteColor]];
                [ddbtn setTitleColor:UIColorFromRGB(0xfd7577) forState:UIControlStateNormal];
                ddbtn.layer.borderColor = UIColorFromRGB(0xfd7577).CGColor;
                ddbtn.layer.borderWidth = 0.8;
            }
            if (i==1) {
                [ddbtn setBackgroundColor:UIColorFromRGB(0xfd7577)];
                if (components.second < 0) {
                    [ddbtn setBackgroundColor:[UIColorFromRGB(0xfd7577) colorWithAlphaComponent:0.5]];
                }
            }
            ddbtn.tag=300+i;
            ddbtn.titleLabel.font = [UIFont systemFontOfSize:autoScaleW(13)];

            [ddbtn addTarget:self action:@selector(BottomBtn:) forControlEvents:UIControlEventTouchUpInside];
            [self.view addSubview:ddbtn];
            ddbtn.sd_layout.leftSpaceToView(self.view,i*(kScreenWidth/2)).bottomEqualToView(self.view).widthIs(kScreenWidth/2).heightIs(autoScaleH(40));
            //如果是订单记录，则没有接单不接单一说
            if (_isOrderRecord || (_ztingeger ==1 && components.second < 0)) {
                ddbtn.hidden = YES;
            } else {
                ddbtn.hidden = NO;
            }
        }
    }


}
#pragma mark 打印
-(void)Dayin
{

}
#pragma mark 取消订单
-(void)BottomBtn:(ButtonStyle *)btn {
    if (_clickReceiveOrderBT) {
        if (btn.tag == 300 || (_ztingeger == 1 && btn.tag == 301)) {
            if (btn.tag == 300 && _ztingeger == 1) {
                return;
            }
            NSDateComponents *components = [NSString getDateSubFromNowTime:nil endTime:_model.arrivalTime];
            if ((_ztingeger == 1 && btn.tag == 301) && components.second > 0) {//秒数  > 0 说明迟到
                [self showCancelOrderLateView];
                return;
            }
            CancleOrderViewController *cancel = [[CancleOrderViewController alloc] init];
            cancel.orderid = _model.ddbhstr;
            cancel.phoneNum = _model.phonestr;
            cancel.orderType = _ztingeger;

            cancel.NetUploadSuccess = ^(BOOL success){
                if (success) {
                    _clickReceiveOrderBT(NO);
                    [self.navigationController popViewControllerAnimated:YES];
                }
            };
            [self.navigationController pushViewController:cancel animated:YES];

        } else {
            _clickReceiveOrderBT(YES);
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
    if (_ztingeger==5) {
        if (btn.tag==301) {
            [self Creatui];
        }

    }

}
- (void)showCancelOrderLateView{
    ZTAddOrSubAlertView *alert = [[ZTAddOrSubAlertView alloc] initWithStyle:ZTalertSheetStyleSubTitle];
    alert.titleLabel.text = @"超时取消订单？";
    alert.littleLabel.text = [NSString stringWithFormat:@"退款说明：迟到预留时间最大为30分钟，超出后系统自动取消此订单，并扣除用户实付金额%@的手续费。", TAX];
    [alert.cancelBT setTitle:@"否" forState:UIControlStateNormal];
    [alert.confirmBT setTitle:@"是" forState:UIControlStateNormal];
    [alert showView];
    alert.complete = ^(BOOL complete){
        if (complete) {
            NSString *cancelReason = @"逾时过久，商家已取消此订单";
            [SVProgressHUD showWithStatus:@"加载中..."];
            NSString *uploadUrl = [NSString stringWithFormat:@"%@api/merchant/orderManage?token=%@&storeId=%@&orderId=%@&remark=%@&status=&operType=2&userId=%@&androidOrIos=ios&account=m%@",kBaseURL, TOKEN,storeID, _model.orderid, cancelReason, _BaseModel.id, LoginName];
              
            [[QYXNetTool shareManager] postNetWithUrl:uploadUrl urlBody:nil bodyStyle:QYXBodyString header:nil response:QYXJSON success:^(id result) {
                if ([result[@"msgType"] integerValue] == 0) {

                    [SVProgressHUD showSuccessWithStatus:@"取消成功"];
                    _clickReceiveOrderBT(NO);
                    [self.navigationController popViewControllerAnimated:YES];
                } else {
                    [SVProgressHUD showInfoWithStatus:@"操作失败"];
                }

            } failure:^(NSError *error) {
                [SVProgressHUD showErrorWithStatus:@"网络异常"];
            }];
        }
    };
}

#pragma  mark 打电话
-(void)Phone {
    [self showOkayCancelAlert];

}
- (void)showOkayCancelAlert {
    NSString *message = NSLocalizedString(_model.phonestr, nil);
    NSString *cancelButtonTitle = NSLocalizedString(@"取消", nil);
    NSString *otherButtonTitle = NSLocalizedString(@"拨打", nil);

    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:message preferredStyle:UIAlertControllerStyleAlert];

    // Create the actions.
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:cancelButtonTitle style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        [alertController dismissViewControllerAnimated:YES completion:^{


        }];
    }];

    UIAlertAction *otherAction = [UIAlertAction actionWithTitle:otherButtonTitle style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        NSMutableString *str=[[NSMutableString alloc] initWithFormat:@"tel:%@",_model.phonestr];
        UIWebView *callWebview = [[UIWebView alloc] init];
        [callWebview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:str]]];
        [_scrollView addSubview:callWebview];

    }];

    // Add the actions.
    [alertController addAction:cancelAction];
    [alertController addAction:otherAction];

    [self presentViewController:alertController animated:YES completion:nil];
}
#pragma mark ----------- 打印 ---------------------
-(void)rightBarClick:(UIBarButtonItem *)sender{
    ZTPrintFormatVC *printVC = [[ZTPrintFormatVC alloc] init];
    printVC.orderId = _model.ddbhstr;
    [self.navigationController pushViewController:printVC animated:YES];
}
//返回
-(void)leftBarButtonItemAction {
    [self.navigationController popViewControllerAnimated:YES];
}
//退菜
- (void)backRightBarItemClick:(UIBarButtonItem *)sender{

    BackDishesVC *backVC = [[BackDishesVC alloc] init];
    backVC.orderId = _model.orderid;
    backVC.orderModel = _model;
    [self.navigationController pushViewController:backVC animated:YES];
    
}
-(void)Creatui
{
    UIWindow * window = [UIApplication sharedApplication].keyWindow;
    _bigview = [[UIView alloc]init];
    _bigview.frame = CGRectMake(0, 1000, kScreenWidth, kScreenHeight);
    _bigview.backgroundColor = RGBA(0, 0, 0, 0.3);
    [window addSubview:_bigview];

    UIView * chooseview = [[UIView alloc]init];
    chooseview.backgroundColor = [UIColor whiteColor];
    chooseview.layer.masksToBounds = YES;
    chooseview.layer.cornerRadius = autoScaleW(5);
    [_bigview addSubview:chooseview];
    chooseview.sd_layout.centerXEqualToView(_bigview).centerYEqualToView(_bigview).widthIs(autoScaleW(200)).heightIs(autoScaleH(150));

    UILabel * flabel = [[UILabel alloc]init];
    flabel.text = @"超时取消订单";
    flabel.font = [UIFont systemFontOfSize:autoScaleW(11)];
    flabel.textAlignment = NSTextAlignmentCenter;
    flabel.textColor = [UIColor grayColor];
    [chooseview addSubview:flabel];
    flabel.sd_layout.centerXEqualToView(chooseview).topSpaceToView(chooseview,autoScaleH(10)).widthIs(autoScaleW(100)).heightIs(autoScaleH(15));

    UILabel * slabel = [[UILabel alloc]init];
    slabel.text = @"请尝试与客人联系后取消订单";
    slabel.textAlignment = NSTextAlignmentCenter;
    slabel.font = [UIFont systemFontOfSize:autoScaleW(13)];
    slabel.textColor = [UIColor grayColor];
    [chooseview addSubview:slabel];
    slabel.sd_layout.centerXEqualToView(chooseview).topSpaceToView(flabel,autoScaleH(15)).widthIs(autoScaleW(300)).heightIs(autoScaleH(15));

    NSMutableAttributedString * fstr = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"取消原因:客人迟到太久" ]];
    [fstr addAttribute:NSForegroundColorAttributeName value:[UIColor lightGrayColor] range:NSMakeRange(0, 11)];
    NSMutableAttributedString * sstr = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"退款原因:￥%@(预付款1/2)",@"230"]];

    [sstr addAttribute:NSForegroundColorAttributeName value:[UIColor lightGrayColor] range:NSMakeRange(0, 5)];
    [sstr addAttribute:NSForegroundColorAttributeName value:UIColorFromRGB(0xfd7577) range:NSMakeRange(5, 4)];
    [sstr addAttribute:NSForegroundColorAttributeName value:[UIColor lightGrayColor] range:NSMakeRange(9, 8)];
    NSArray * ssary = @[fstr,sstr];

    for (int i=0; i<2; i++) {

        UILabel * tishilabel = [[UILabel alloc]init];
        tishilabel.font = [UIFont systemFontOfSize:autoScaleW(9)];
        tishilabel.attributedText = ssary[i];
        [chooseview addSubview:tishilabel];
        tishilabel.sd_layout.leftSpaceToView(chooseview,autoScaleW(15)).topSpaceToView(slabel,autoScaleH(20)+i*autoScaleH(13)).widthIs(chooseview.frame.size.width-autoScaleW(30)).heightIs(autoScaleH(11));

    }
    UILabel * linelabel = [[UILabel alloc]init];
    linelabel.backgroundColor = RGB(228, 228, 228);
    [chooseview addSubview:linelabel];
    linelabel.sd_layout.leftSpaceToView(chooseview,0).rightSpaceToView(chooseview,0).topSpaceToView(slabel,autoScaleH(62)).heightIs(autoScaleH(1));

    NSArray * llary = @[@"先不取消",@"取消"];
    for (int i=0; i<2; i++) {

        ButtonStyle * choosebtn = [ButtonStyle buttonWithType:UIButtonTypeCustom];
        [choosebtn setTitle:llary[i] forState:UIControlStateNormal];
        choosebtn.titleLabel.font = [UIFont systemFontOfSize:autoScaleW(13)];
        [choosebtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        [choosebtn addTarget:self action:@selector(Remove:) forControlEvents:UIControlEventTouchUpInside];
        [chooseview addSubview:choosebtn];
        choosebtn.sd_layout.topSpaceToView(linelabel,0).leftSpaceToView(chooseview,i*autoScaleW(chooseview.frame.size.width/2)).widthIs(chooseview.frame.size.width/2).heightIs(autoScaleH(30));
        if (i==0) {

            UILabel * linelabel = [[UILabel alloc]init];
            linelabel.backgroundColor = RGB(228, 228, 228);
            [choosebtn addSubview:linelabel];
            linelabel.sd_layout.rightSpaceToView(choosebtn,0).topSpaceToView(choosebtn,0).heightIs(choosebtn.frame.size.height).widthIs(1);
        }

    }
    [UIView animateWithDuration:0.5 animations:^{
        _bigview.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
        
    }];
    
}
-(void)Remove:(ButtonStyle *)btn
{
    [_bigview removeFromSuperview];
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
