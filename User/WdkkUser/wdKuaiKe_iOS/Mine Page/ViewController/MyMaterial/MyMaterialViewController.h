//
//  MyMaterialViewController.h
//  wdKuaiKe_iOS
//
//  Created by 张森森 on 16/9/21.
//  Copyright © 2016年 weiDianKuaiKe. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^newBlock)(UIImage* image);
@interface MyMaterialViewController : UIViewController

@property (nonatomic,copy)newBlock bolck;
@property (nonatomic,strong)UIImageView * headimage;
@property (nonatomic,strong)UILabel * titlelab;
@property (nonatomic,strong)UIImage * rightimage;
@property (nonatomic,copy)NSString * namestr;
@property (nonatomic,copy)NSString * phonestr;
-(void)text:(newBlock)block;
@end
