//
//  AssignViewController.m
//  微点筷客商户端
//
//  Created by 张森森 on 16/10/14.
//  Copyright © 2016年 张森森. All rights reserved.
//

#import "AssignViewController.h"

@interface AssignViewController ()

@end

@implementation AssignViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = RGBA(0, 0, 0, 0.3);
    
    
    
    NSArray * ary = @[@"取消",@"切换为分配模式",];
    
    for (int i=0; i<2; i++) {
        
        ButtonStyle * querenBtn = [ButtonStyle buttonWithType:UIButtonTypeCustom];
        querenBtn.layer.masksToBounds = YES;
        querenBtn.tag = 200 +i;
        querenBtn.layer.cornerRadius = autoScaleW(10);
        querenBtn.titleLabel.font = [UIFont systemFontOfSize:autoScaleW(20)];
        [querenBtn setTitle:ary[i] forState:UIControlStateNormal];
        [querenBtn setTitleColor:UIColorFromRGB(0xfd7577) forState:UIControlStateNormal];
        [querenBtn setBackgroundColor:[UIColor whiteColor]];
        
        [querenBtn addTarget:self action:@selector(Clickbtn:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:querenBtn];
        
        querenBtn.sd_layout.leftSpaceToView(self.view,autoScaleW(8)).bottomSpaceToView(self.view,autoScaleH(10)+i*autoScaleH(64)).widthIs(self.view.frame.size.width-autoScaleW(16)).heightIs(autoScaleH(55));

    }


}
-(void)getstring:(xianblack)block
{
    self.block = block;
}
- (void)Clickbtn:(ButtonStyle *)btn
{
    
    
    
    if (btn.tag==201)
    {
        
       
       
        UIView * tishiview = [[UIView alloc]init];
        tishiview.backgroundColor = [UIColor whiteColor];
        tishiview.layer.masksToBounds = YES;
        tishiview.layer.cornerRadius =autoScaleW(3);
        [self.view addSubview:tishiview];
        tishiview.sd_layout.centerXEqualToView(self.view).topSpaceToView(self.view,autoScaleH(280)).widthIs(autoScaleW(250)).heightIs(autoScaleH(105));
        
        UILabel * tishilabel = [[UILabel alloc]init];
        NSMutableAttributedString * string = [[NSMutableAttributedString alloc]initWithString:@"服务任务分配模式将于2.0版本上线，敬请期待"];
        
        [string addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:NSMakeRange(0, 10)];
        [string addAttribute:NSForegroundColorAttributeName value:UIColorFromRGB(0xfd7577) range:NSMakeRange(10, 5)];
        [string addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:NSMakeRange(15, 7)];
        tishilabel.font = [UIFont systemFontOfSize:autoScaleW(15)];
        tishilabel.attributedText =string;
        tishilabel.numberOfLines = 0;

        [tishiview addSubview:tishilabel];
        tishilabel.sd_layout.leftSpaceToView(tishiview,autoScaleW(10)).rightSpaceToView(tishiview,autoScaleW(10)).topSpaceToView(tishiview,autoScaleH(5)).heightIs(autoScaleH(50));
        
        UILabel * linelabel = [[UILabel alloc]init];
        linelabel.backgroundColor = [UIColor lightGrayColor];
        [tishiview addSubview:linelabel];
        linelabel.sd_layout.leftSpaceToView(tishiview,0).rightSpaceToView(tishiview,0).topSpaceToView(tishilabel,autoScaleH(12)).heightIs(0.5);
        
        ButtonStyle * quedingbtn = [ButtonStyle buttonWithType:UIButtonTypeCustom];
        [quedingbtn setTitle:@"确定" forState:UIControlStateNormal];
        [quedingbtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        quedingbtn.titleLabel.font = [UIFont systemFontOfSize:autoScaleW(15)];
        [quedingbtn addTarget:self action:@selector(queding) forControlEvents:UIControlEventTouchUpInside];
        [tishiview addSubview:quedingbtn];
        quedingbtn.sd_layout.leftEqualToView(tishiview).rightEqualToView(tishiview).topSpaceToView(linelabel,autoScaleH(5)).heightIs(autoScaleH(25));
        
        
    }
    if (btn.tag==200)
    {
        
        [self dismissViewControllerAnimated:YES completion:^{
            
            self.block(@"xian");
        }];
    }
    
    
}
-(void)queding
{
    
    [self dismissViewControllerAnimated:YES completion:^{
        self.block(@"xian");
    }];
    
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
