//
//  DishdetailView.h
//  wdKuaiKe_iOS
//
//  Created by 张森森 on 17/4/28.
//  Copyright © 2017年 weiDianKuaiKe. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DishesDetailModel.h"
typedef void(^dishblock)(NSInteger num,float sum,NSMutableArray * dictary,BOOL click,BOOL isexit);

@interface DishdetailView : UIView
@property (nonatomic,strong)DishesDetailModel * model;
@property (nonatomic,strong)  UIView * bigView;
@property (nonatomic,strong)UIImageView * headimage;
@property (nonatomic,strong)UILabel * namelabel;
@property (nonatomic,strong)UILabel * numberLabel;
@property (nonatomic,strong)UILabel * priceLabel;
@property (nonatomic,strong)UILabel * linelabel;//分割线
@property (nonatomic,strong)UILabel * goodslabel;//商品
@property (nonatomic,strong)UILabel * goodsdetailLabel;//商品信息
@property (nonatomic,strong)UIButton * cancelBtn;//取消按钮
@property (nonatomic,strong)UIButton * addBtn;// 加
@property (nonatomic,strong)UIButton * subtract;// 减
@property (nonatomic,strong)UILabel * dishnumlabel;//菜品数量
@property (nonatomic,assign)NSInteger number;
@property (nonatomic,retain)UIImageView * redView;
@property (nonatomic,assign)float sum;//传值，总价格
@property (nonatomic,retain)NSMutableArray * dishdict;//传值 菜品信息字典
@property (nonatomic,assign)NSInteger num ;//传值，总数
@property (nonatomic,copy)dishblock block;
@property (nonatomic,copy)NSString * indexstr;
@property (nonatomic,copy)NSString * numberstr;//传值过来的数量
@property (nonatomic,assign)NSInteger pushint;//加菜不需要动画 预定需要
@property (nonatomic,assign)BOOL IsExist;
- (void)CreatView;
- (id)initWithFrame:(CGRect)frame withString:(NSString *)string;
@end
