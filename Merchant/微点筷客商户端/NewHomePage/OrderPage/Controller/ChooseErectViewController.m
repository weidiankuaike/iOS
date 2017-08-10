//
//  ChooseErectViewController.m
//  微点筷客商户端
//
//  Created by 张森森 on 16/10/17.
//  Copyright © 2016年 张森森. All rights reserved.
//

#import "ChooseErectViewController.h"

@interface ChooseErectViewController ()
@property (nonatomic,strong)ButtonStyle * choosebtn;
@end

@implementation ChooseErectViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = RGBA(0, 0, 0, 0.3);
   
    UIView * tishiview = [[UIView alloc]init];
    tishiview.backgroundColor = [UIColor whiteColor];
    tishiview.layer.masksToBounds = YES;
    tishiview.layer.cornerRadius =autoScaleW(3);
    [self.view addSubview:tishiview];
    tishiview.sd_layout.centerXEqualToView(self.view).topSpaceToView(self.view,autoScaleH(280)).widthIs(autoScaleW(250)).heightIs(autoScaleH(120));
    if (_chooseinteger==1) {
        _array = @[@"是否设置该时段为繁忙状态",@"客人将无法进行该时段的用餐预定",];

    }
    if (_chooseinteger==2) {
        
        _array = @[@"是否设置该时段为休业状态",@"该时段餐厅将不显示在用户端首页",];
    }
    NSArray * btnary = @[@"否",@"是",];
    for (int i =0; i<2; i++) {


        UILabel * tishilabel = [[UILabel alloc]init];
        tishilabel.text = _array[i];
        tishilabel.textAlignment = NSTextAlignmentCenter;
        tishilabel.font = [UIFont systemFontOfSize:autoScaleW(13)];
        [tishiview addSubview:tishilabel];
        tishilabel.sd_layout.leftSpaceToView(tishiview,autoScaleW(10)).rightSpaceToView(tishiview,autoScaleW(10)).topSpaceToView(tishiview,autoScaleH(10)+i*autoScaleH(30)).heightIs(autoScaleH(17));
        if (i == 1) {
            ButtonStyle *selectBT = [ButtonStyle buttonWithType:UIButtonTypeCustom];
            NSNumber *chooseStatus = [[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"%@-%ld", storeID,(long)_chooseinteger]];
            if ([chooseStatus isEqualToNumber:@(_chooseinteger)]) {
                selectBT.selected = YES;
            }
            [selectBT setImage:[UIImage imageNamed:@"圆角矩形-2"] forState:UIControlStateNormal];
            [selectBT setImage:[UIImage imageNamed:@"gou-1"] forState:UIControlStateSelected];
            [selectBT addTarget:self action:@selector(selectBTClick:) forControlEvents:UIControlEventTouchUpInside];
            [tishiview addSubview:selectBT];

            UILabel *promptLabel = [[UILabel alloc] init];
            promptLabel.text = @"选中后下次将不再提醒";
            promptLabel.textColor = [UIColor lightGrayColor];
            promptLabel.font = [UIFont systemFontOfSize:tishilabel.font.pointSize - 2];
            [tishiview addSubview:promptLabel];

            selectBT.sd_layout
            .leftSpaceToView(tishiview, autoScaleW(45))
            .topSpaceToView(tishilabel, 10)
            .widthIs(15)
            .heightIs(15);

            promptLabel.sd_layout
            .leftSpaceToView(selectBT, 5)
            .centerYEqualToView(selectBT)
            .heightIs(20);
            [promptLabel setSingleLineAutoResizeWithMaxWidth:200];

        }
        ButtonStyle * quedingbtn = [ButtonStyle buttonWithType:UIButtonTypeCustom];
        [quedingbtn setTitle:btnary[i] forState:UIControlStateNormal];
        [quedingbtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        quedingbtn.titleLabel.font = [UIFont systemFontOfSize:autoScaleW(15)];
        quedingbtn.tag = 200+i;
        [quedingbtn addTarget:self action:@selector(queding:) forControlEvents:UIControlEventTouchUpInside];
        [tishiview addSubview:quedingbtn];
        quedingbtn.sd_layout.leftSpaceToView(tishiview,i*(tishiview.frame.size.width/2)).topSpaceToView(tishiview,autoScaleH(93)).heightIs(autoScaleH(25)).widthIs(tishiview.frame.size.width/2);
        if (i==1) {
            [quedingbtn setTitleColor:RGB(234, 158, 56) forState:UIControlStateNormal];
            UILabel * sulabel = [[UILabel alloc]init];
            sulabel.backgroundColor = [UIColor lightGrayColor];
            [quedingbtn addSubview:sulabel];
            sulabel.sd_layout.leftEqualToView(quedingbtn).topEqualToView(quedingbtn).widthIs(0.5).heightIs(quedingbtn.frame.size.height);
        }

    }
    
//    if (_chooseinteger==2) {
//        
//        UILabel * slabel = [[UILabel alloc]init];
//        slabel.text = @"休业状态需在订单设置里手动修改";
//        slabel.font = [UIFont systemFontOfSize:autoScaleW(11)];
//        slabel.textColor = RGB(194, 60, 53);
//        [tishiview addSubview:slabel];
//        slabel.sd_layout.leftSpaceToView(tishiview,autoScaleW(22)).topSpaceToView(tishiview,autoScaleH(68)).widthIs(autoScaleW(200)).heightIs(autoScaleH(15));
//    }

    UILabel * linelabel = [[UILabel alloc]init];
    linelabel.backgroundColor = [UIColor lightGrayColor];
    [tishiview addSubview:linelabel];
    linelabel.sd_layout.leftSpaceToView(tishiview,0).rightSpaceToView(tishiview,0).topSpaceToView(tishiview,autoScaleH(92)).heightIs(0.5);
    
}
- (void)selectBTClick:(ButtonStyle *)sender{
    sender.selected = !sender.selected;
    NSNumber *chooseStatus = [[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"%@-%ld", storeID,(long)_chooseinteger]];
    if ([chooseStatus isEqualToNumber:@(_chooseinteger)]) {
        [[NSUserDefaults standardUserDefaults] setObject:@(404) forKey:[NSString stringWithFormat:@"%@-%ld", storeID,(long)_chooseinteger]];
    } else {
        [[NSUserDefaults standardUserDefaults] setObject:@(_chooseinteger) forKey:[NSString stringWithFormat:@"%@-%ld", storeID,(long)_chooseinteger]];
    }
}
-(void)getstring:(cleblock)block
{
    self.block = block;
}
-(void)queding:(ButtonStyle *)btn
{
    if (_chooseinteger==1) {
        
        if (btn.tag==200) {
            
           [self dismissViewControllerAnimated:YES completion:^{
               if (self.block) {
                   self.block(@"2",@"2");
               }
               
               
           }];
        }
        if (btn.tag==201) {
            [self dismissViewControllerAnimated:YES completion:^{
                if (self.block) {
                    self.block(@"2",@"1");
                }
            }];
        }
    }
    if (_chooseinteger==2) {
        if (btn.tag==200) {
            
            [self dismissViewControllerAnimated:YES completion:^{
                if (self.block) {
                    
                    self.block(@"0",@"2");
                }
            }];
        }
        if (btn.tag==201) {
            [self dismissViewControllerAnimated:YES completion:^{
                
                if (self.block) {
                    
                    self.block(@"0",@"1");
                }
            }];
        }
    }
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
