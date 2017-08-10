//
//  ViewController.m
//  wdKuaiKe_iOS
//
//  Created by Skyer God on 16/8/3.
//  Copyright © 2016年 weiDianKuaiKe. All rights reserved.
//

#import "ViewController.h"
@interface ViewController ()
@property (nonatomic, retain) UITabBarController *tabController;

@end

@implementation ViewController

-(void)viewWillAppear:(BOOL)animated
{

    [super viewWillAppear:NO];

    self.navigationController.navigationBar.hidden = YES;
    self.navigationItem.hidesBackButton = YES;

}
  
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.view.backgroundColor = [UIColor whiteColor];
  }
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
