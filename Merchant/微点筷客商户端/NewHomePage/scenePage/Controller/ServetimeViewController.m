//
//  ServetimeViewController.m
//  微点筷客商户端
//
//  Created by 张森森 on 16/10/14.
//  Copyright © 2016年 张森森. All rights reserved.
//

#import "ServetimeViewController.h"
#import "UIBarButtonItem+SSExtension.h"
#import "CircularProgressBar.h"
#import "ServeTableViewCell.h"
#import "UINavigationController+FDFullscreenPopGesture.h"
@interface ServetimeViewController ()<CircularProgressDelegate,UITableViewDelegate,UITableViewDataSource>

{
    CircularProgressBar * M_circular;
    UILabel * circlelabel;
    ButtonStyle * daitibtn;
    NSInteger  qhinterger;
    NSArray * caidanary;
    NSArray * haoary;
    NSArray * fenary;
    BOOL isXian ;
}

@end

@implementation ServetimeViewController

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
    self.tabBarController.tabBar.hidden = YES;
    
    
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.hidden = YES;
    self.tabBarController.tabBar.hidden = YES;
    
    
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    isXian = NO;
    qhinterger =1;
    self.view.backgroundColor = UIColorFromRGB(0xffffff);
   
    CGFloat height = [[UIApplication sharedApplication] statusBarFrame].size.height+self.navigationController.navigationBar.frame.size.height;
    UILabel * namelabel = [[UILabel alloc]init];
   namelabel.text = [NSString stringWithFormat:@"勤劳的%@，您正在清理", _BaseModel.name];
    namelabel.font = [UIFont systemFontOfSize:autoScaleW(15)];
    namelabel.textColor = RGB(171, 171, 171);
    namelabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:namelabel];
    namelabel.sd_layout.centerXEqualToView(self.view).topSpaceToView(self.view,autoScaleH(70)+height).widthIs(autoScaleW(400)).heightIs(autoScaleH(15));
    
    UILabel * biglabel = [[UILabel alloc]init];
    if (qhinterger==1) {
        
        NSString * string = [NSString stringWithFormat :@"%@号桌的%@服务",_model.boardNum, _model.service];
        NSRange range = NSRangeFromString(string);
        NSRange range1 = [string rangeOfString:_model.boardNum];
        NSRange range2 = [string rangeOfString:_model.service];
        NSMutableAttributedString *att = [[NSMutableAttributedString alloc] initWithString:string];
        [att addAttribute:NSForegroundColorAttributeName value:RGB(112, 112, 112) range:range];
        [att addAttribute:NSForegroundColorAttributeName value:UIColorFromRGB(0xfd7577) range:range1];
        [att addAttribute:NSForegroundColorAttributeName value:UIColorFromRGB(0xfd7577) range:range2];

        biglabel.attributedText = att;
        
    }
    if (qhinterger==2) {
        
        NSString * string  = [NSString stringWithFormat :@"%@号桌的%@服务",_model.boardNum, _model.service];
        NSRange range = NSRangeFromString(string);
        NSRange range1 = [string rangeOfString:_model.boardNum];
        NSRange range2 = [string rangeOfString:_model.service];
        NSMutableAttributedString *att = [[NSMutableAttributedString alloc] initWithString:string];
        [att addAttribute:NSForegroundColorAttributeName value:RGB(112, 112, 112) range:range];
        [att addAttribute:NSForegroundColorAttributeName value:UIColorFromRGB(0xfd7577) range:range1];
        [att addAttribute:NSForegroundColorAttributeName value:UIColorFromRGB(0xfd7577) range:range2];

        biglabel.attributedText = att;
        
    }
    
    biglabel.font = [UIFont systemFontOfSize:autoScaleW(20)];
    biglabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:biglabel];
    biglabel.sd_layout.centerXEqualToView(self.view).topSpaceToView(namelabel,autoScaleH(27)).widthIs(autoScaleW(400)).heightIs(autoScaleH(30));
   
    if (qhinterger==1) {
        
        circlelabel = [[UILabel alloc]init];
        circlelabel.backgroundColor = RGB(191, 191, 191);
        circlelabel.layer.masksToBounds = YES;
        circlelabel.layer.cornerRadius = autoScaleW(115)/2;
        [self.view addSubview:circlelabel];
        circlelabel.sd_layout.centerXEqualToView(self.view).topSpaceToView(self.view, autoScaleH(70)+height+autoScaleH(27)+autoScaleH(15)+autoScaleH(35)+autoScaleH(20)).widthIs(autoScaleW(115)).heightIs(autoScaleW(115));
        
        M_circular = [[CircularProgressBar alloc]init];
        M_circular.frame = CGRectMake(kScreenWidth/2-autoScaleW(155)/2, autoScaleH(70)+height+autoScaleH(27)+autoScaleH(15)+autoScaleH(35), autoScaleW(155), autoScaleH(155));
        M_circular.delegate = self;
        [self.view addSubview:M_circular];
        //    M_circular.sd_layout.centerXEqualToView(self.view).topSpaceToView(biglabel,autoScaleH(35)).widthIs(autoScaleW(155)).heightIs(autoScaleH(155));
        [M_circular setTotalSecondTime:30];
        [M_circular startTimer];
        
        daitibtn = [ButtonStyle buttonWithType:UIButtonTypeCustom];
        [daitibtn setBackgroundColor:UIColorFromRGB(0xfd7577)];
        [daitibtn setTitle:@"完成" forState:UIControlStateNormal];
        [daitibtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        daitibtn.layer.masksToBounds=YES;
        daitibtn.layer.cornerRadius = autoScaleW(115)/2;
        [daitibtn addTarget:self action:@selector(leftBarButtonItemAction) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:daitibtn];
        daitibtn.sd_layout.centerXEqualToView(self.view).topSpaceToView(self.view, autoScaleH(70)+height+autoScaleH(27)+autoScaleH(15)+autoScaleH(35)+autoScaleH(20)).widthIs(autoScaleW(115)).heightIs(autoScaleW(115));
        daitibtn.hidden = YES;

    }
    
    
    if (qhinterger==2) {
        UILabel * linlabel = [[UILabel alloc]init];
        linlabel.backgroundColor = RGB(191, 191, 191);
        [self.view addSubview:linlabel];
        linlabel.sd_layout.leftSpaceToView(self.view,autoScaleW(20)).rightSpaceToView(self.view,autoScaleW(20)).topSpaceToView(biglabel,autoScaleH(23)).heightIs(autoScaleH(0.5));
        
        UITableView * houcutable = [[UITableView alloc]init];
        houcutable.backgroundColor = RGB(245, 244, 244);
        houcutable.separatorStyle = UITableViewCellSeparatorStyleNone;
        houcutable.delegate = self;
        houcutable.dataSource = self;
        [self.view addSubview:houcutable];
        houcutable.sd_layout.leftSpaceToView(self.view,autoScaleW(20)).rightSpaceToView(self.view,autoScaleW(20)).topSpaceToView(linlabel,autoScaleH(13)).heightIs(autoScaleH(35)*9);
        
        
        ButtonStyle * finishbtn = [ButtonStyle buttonWithType:UIButtonTypeCustom];
        [finishbtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        finishbtn.titleLabel.font = [UIFont systemFontOfSize:autoScaleW(13)];
        finishbtn.layer.borderWidth = 1;
        finishbtn.layer.borderColor = RGB(191, 191, 191).CGColor;
        finishbtn.layer.masksToBounds = YES;
        finishbtn.layer.cornerRadius = autoScaleW(3);
        [finishbtn addTarget:self action:@selector(leftBarButtonItemAction) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:finishbtn];
        finishbtn.sd_layout.centerXEqualToView(self.view).topSpaceToView(houcutable,autoScaleH(25)).widthIs(autoScaleW(88)).heightIs(autoScaleH(30));
        
        UILabel * timelabel = [[UILabel alloc]init];
        timelabel.text = @"(120s)";
        timelabel.textAlignment = NSTextAlignmentCenter;
        timelabel.textColor = [UIColor blackColor];
        timelabel.font = [UIFont systemFontOfSize:autoScaleW(13)];
        [finishbtn addSubview:timelabel];
        timelabel.sd_layout.centerXEqualToView(finishbtn).topSpaceToView(finishbtn,autoScaleH(8)).widthIs(autoScaleW(50)).heightIs(autoScaleH(15));
        
        __block int timeout=20; //倒计时时间
        dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
        dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
        dispatch_source_set_event_handler(_timer, ^{
            if(timeout==0){ //倒计时结束，关闭
                dispatch_source_cancel(_timer);
                dispatch_async(dispatch_get_main_queue(), ^{
                    //设置界面的按钮显示 根据自己需求设置
//                    timelabel.hidden = YES;
                    timelabel.text = @"完成";
                    timelabel.textColor = [UIColor whiteColor];
                    finishbtn.userInteractionEnabled = YES;
                    finishbtn.backgroundColor = UIColorFromRGB(0xfd7577);
                    [finishbtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                    finishbtn.layer.borderColor = [UIColor clearColor].CGColor;
                });
            }else
            {
//                int seconds = timeout % 60;
//                NSString *strTime = [NSString stringWithFormat:@"%.2d", seconds];
                dispatch_async(dispatch_get_main_queue(), ^{
                    //设置界面的按钮显示 根据自己需求设置
                    [UIView beginAnimations:nil context:nil];
                    [UIView setAnimationDuration:1];
                    timelabel.hidden = NO;
                    timelabel.text = [NSString stringWithFormat:@"(%ds)",timeout];
                    finishbtn.userInteractionEnabled = NO;
                    [UIView commitAnimations];
                    
                });
                timeout--;
            }
        });
        dispatch_resume(_timer);

        
        
        caidanary = @[@"肉末茄子",@"剁椒鱼头",@"肉末茄子",@"剁椒鱼头",@"剁椒鱼头",@"剁椒鱼头",@"剁椒鱼头",@"剁椒鱼头",@"剁椒鱼头",@"剁椒鱼头",];
        
        haoary = @[@"56",@"12",@"12",@"12",@"12",@"12",@"12",@"12",@"12",@"12",@"12",];
        
        fenary = @[@"6",@"6",@"6",@"6",@"6",@"6",@"6",@"6",@"6",@"6",@"6",];

    }
    
    
    
    
}
-(void)Caidan
{
    
}
-(void)Shezhi
{
    
    
    
    
    
    
}
#pragma mark 倒计时代理方法
- (void)CircularProgressEnd
{
    [M_circular stopTimer];
    [M_circular setTotalSecondTime:0];
    daitibtn.hidden = NO;
    
    
    
}
-(void)Gettime:(NSString *)timestring
{
    if ([timestring isEqualToString:@"00"]) {
        M_circular.textContent = @"完成";
    }
    
    
}
#pragma mark 完成方法
-(void)leftBarButtonItemAction
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return caidanary.count;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ServeTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"houchu"];
    if (!cell) {
        
        cell = [[ServeTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"houchu"];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor = RGB(245, 244, 244);
    cell.firstlabel.sd_layout.leftSpaceToView(cell,autoScaleW(37)).topSpaceToView(cell,autoScaleH(10)).widthIs(autoScaleW(40)).heightIs(autoScaleH(15));
    cell.secondlabel.sd_layout.leftSpaceToView(cell,autoScaleW(127)).topSpaceToView(cell,autoScaleW(10)).widthIs(autoScaleW(50)).heightIs(autoScaleH(15));
    cell.timelabel.sd_layout.rightSpaceToView(cell,autoScaleW(37)).topSpaceToView(cell,autoScaleH(10)).widthIs(autoScaleW(25)).heightIs(autoScaleH(15));
    cell.firstlabel.text = [NSString stringWithFormat:@"%@号",haoary[indexPath.row]];
    cell.secondlabel.text = caidanary[indexPath.row];
    cell.timelabel.text = [NSString stringWithFormat:@"%@",fenary[indexPath.row]];
    
    
    return cell;
    
}


- (void)didReceiveMemoryWarning {
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
