//
//  QueueDetailViewController.m
//  wdKuaiKe_iOS
//
//  Created by 张森森 on 2017/7/3.
//  Copyright © 2017年 weiDianKuaiKe. All rights reserved.
//

#import "QueueDetailViewController.h"
#import "UIBarButtonItem+SSExtension.h"
@interface QueueDetailViewController ()
@property (nonatomic,assign)NSInteger typeInt;
@end

@implementation QueueDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = RGB(238, 238, 238);
    UILabel * titlabel = [[UILabel alloc]init];
    titlabel.frame = CGRectMake(0, 0, 80, 30);
    titlabel.textAlignment = NSTextAlignmentCenter;
    titlabel.font = [UIFont systemFontOfSize:15];
    titlabel.text = @"排号详情";
    titlabel.textColor = [UIColor whiteColor];
    self.navigationItem.titleView = titlabel;
    UIBarButtonItem * backbtn = [UIBarButtonItem itemWithTarget:self Action:@selector(Back) image:@"left-1" selectImage:nil];
    self.navigationItem.leftBarButtonItem = backbtn;
    _typeInt = 1;
    [self creatView];
}
- (void)creatView{
    
    if (_typeInt==1) {
        
        UIView * promptView = [[UIView alloc]init];
        promptView.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:promptView];
        promptView.sd_layout.leftEqualToView(self.view).rightEqualToView(self.view).topEqualToView(self.view).heightIs(autoScaleH(30));
        
        UIImageView * gtImage = [[UIImageView alloc]init];
        gtImage.image = [UIImage imageNamed:@"感叹号"];
        [promptView addSubview:gtImage];
        gtImage.sd_layout.leftSpaceToView(promptView,autoScaleW(15)).topSpaceToView(promptView,autoScaleH(5)).widthIs(autoScaleW(15)).heightEqualToWidth();
        
        UILabel * promptLabel = [[UILabel alloc]init];
        promptLabel.text = @"您的号码已过期，请重新排号";
        promptLabel.textColor = UIColorFromRGB(0x505050);
        promptLabel.font = [UIFont systemFontOfSize:autoScaleW(13)];
        [promptView addSubview:promptLabel];
        promptLabel.sd_layout.leftSpaceToView(promptView, autoScaleW(38)).topSpaceToView(promptView, autoScaleH(5)).heightIs(autoScaleH(20));
        [promptLabel setSingleLineAutoResizeWithMaxWidth:200];
    }
    
    
    
    UIImageView * queueDetailimage = [[UIImageView alloc]init];
    queueDetailimage.image = [UIImage imageNamed:@"排详背"];
    [self.view addSubview:queueDetailimage];
    queueDetailimage.sd_layout.leftSpaceToView(self.view, 5).rightSpaceToView(self.view,5).heightIs(autoScaleH(125));
    if (_typeInt==1) {
        
        queueDetailimage.sd_layout.topSpaceToView(self.view,autoScaleH(40));
    }else{
        
        queueDetailimage.sd_layout.topSpaceToView(self.view, autoScaleH(10));
    }
    
    UILabel * nameLabel = [[UILabel alloc]init];
    nameLabel.text = @"大丰收鱼庄万达店";
    nameLabel.textColor = UIColorFromRGB(0x000000);
    nameLabel.font = [UIFont systemFontOfSize:autoScaleW(13)];
    
    [queueDetailimage addSubview:nameLabel];
    nameLabel.sd_layout.leftSpaceToView(queueDetailimage,autoScaleW(11)).topSpaceToView(queueDetailimage,autoScaleH(7)).heightIs(autoScaleH(20)).widthIs(GetWidth/2);
    
    UILabel * timeLabel = [[UILabel alloc]init];
    timeLabel.text = @"06/22 20:20取号";
    timeLabel.textColor = UIColorFromRGB(0xfd7577);
    timeLabel.textAlignment = NSTextAlignmentRight;
    timeLabel.font = [UIFont systemFontOfSize:autoScaleW(13)];
    [queueDetailimage addSubview:timeLabel];
    timeLabel.sd_layout.rightSpaceToView(queueDetailimage,autoScaleW(11)).topEqualToView(nameLabel).heightIs(autoScaleH(20)).widthIs(GetWidth/2);
   
    UIImageView * tabletypeimage = [[UIImageView alloc]init];
    tabletypeimage.image = [UIImage imageNamed:@"2-人桌"];
    [queueDetailimage addSubview:tabletypeimage];
    tabletypeimage.sd_layout.leftSpaceToView(queueDetailimage, autoScaleW(15)).topSpaceToView(queueDetailimage,autoScaleH(37)).widthIs(autoScaleW(57)).heightEqualToWidth();
    
    UILabel * waitLabel = [[UILabel alloc]init];
    waitLabel.text = @"前方8人等待";
    waitLabel.textColor = UIColorFromRGB(0x8d8d8d);
    waitLabel.textAlignment = NSTextAlignmentCenter;
    waitLabel.font = [UIFont systemFontOfSize:autoScaleW(13)];
    [queueDetailimage addSubview:waitLabel];
    waitLabel.sd_layout.topSpaceToView(queueDetailimage, autoScaleH(99)).centerXEqualToView(tabletypeimage).heightIs(autoScaleH(20));
    [waitLabel setSingleLineAutoResizeWithMaxWidth:100];
    
    UILabel * numberLabel = [[UILabel alloc]init];
    numberLabel.text = @"A0001";
    numberLabel.textColor = UIColorFromRGB(0x000000);
    numberLabel.font = [UIFont systemFontOfSize:autoScaleW(19)];
    [queueDetailimage addSubview:numberLabel];
    numberLabel.sd_layout.topSpaceToView(queueDetailimage, autoScaleH(59)).centerXEqualToView(queueDetailimage).heightIs(autoScaleH(25));
    [numberLabel setSingleLineAutoResizeWithMaxWidth:150];
    
    UILabel * typeLabel = [[UILabel alloc]init];
    typeLabel.text = @"号码过期";
    typeLabel.textColor = UIColorFromRGB(0x8d8d8d);
    typeLabel.textAlignment = NSTextAlignmentCenter;
    typeLabel.font = [UIFont systemFontOfSize:autoScaleW(13)];
    [queueDetailimage addSubview:typeLabel];
    typeLabel.sd_layout.topEqualToView(waitLabel).centerXEqualToView(numberLabel).heightIs(autoScaleH(20)).widthIs(autoScaleW(70));
    
    UIButton * cancleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [cancleBtn setTitle:@"取消排号" forState:UIControlStateNormal];
    [cancleBtn setTitleColor:UIColorFromRGB(0xffffff) forState:UIControlStateNormal];
    cancleBtn.titleLabel.font = [UIFont systemFontOfSize:autoScaleW(13)];
    cancleBtn.layer.masksToBounds = YES;
    cancleBtn.layer.cornerRadius = 3;
    if (_typeInt==1) {
        
        [cancleBtn setBackgroundColor:RGB(191, 191, 191)];
        cancleBtn.userInteractionEnabled = NO;
    }else{
        [cancleBtn setBackgroundColor:UIColorFromRGB(0xfd7577)];
        cancleBtn.userInteractionEnabled = YES;
    }
    [cancleBtn addTarget:self action:@selector(cancleQueue) forControlEvents:UIControlEventTouchUpInside];
    [queueDetailimage addSubview:cancleBtn];
    cancleBtn.sd_layout.topSpaceToView(queueDetailimage,autoScaleH(55)).leftSpaceToView(queueDetailimage,autoScaleW(277)).widthIs(autoScaleW(71)).heightIs(autoScaleH(24));
    
    UILabel * distanceLabel = [[UILabel alloc]init];
    distanceLabel.text = [NSString stringWithFormat:@"当前距离:%@",@"1km"];
    distanceLabel.textColor = UIColorFromRGB(0x8d8d8d);
    distanceLabel.textAlignment = NSTextAlignmentCenter;
    distanceLabel.font = [UIFont systemFontOfSize:autoScaleW(13)];
    [queueDetailimage addSubview:distanceLabel];
    distanceLabel.sd_layout.topEqualToView(typeLabel).centerXEqualToView(cancleBtn).heightIs(autoScaleH(20));
    [distanceLabel setSingleLineAutoResizeWithMaxWidth:200];
    
    if (_typeInt==1) {
        
        UIButton * againBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [againBtn setTitle:@"重新排号" forState:UIControlStateNormal];
        againBtn.titleLabel.font = [UIFont systemFontOfSize:autoScaleW(16)];
        [againBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [againBtn setBackgroundColor:UIColorFromRGB(0xfd7577)];
        againBtn.layer.masksToBounds = YES;
        againBtn.layer.cornerRadius = 3;
        [againBtn addTarget:self action:@selector(againQueue) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:againBtn];
        againBtn.sd_layout.topSpaceToView(queueDetailimage,autoScaleH(25)).centerXEqualToView(self.view).heightIs(autoScaleH(37)).widthIs(autoScaleW(220));
    }
    
}



- (void)Back{
    
    [self.navigationController popViewControllerAnimated:YES];
    
}
#pragma mark 取消排号
- (void)cancleQueue{
    
    
    
}
#pragma mark 重新排号
- (void)againQueue{
    
    
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
