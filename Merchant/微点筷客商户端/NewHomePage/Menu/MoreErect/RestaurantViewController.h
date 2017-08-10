//
//  RestaurantViewController.h
//  微点筷客商户端
//
//  Created by 张森森 on 16/10/27.
//  Copyright © 2016年 张森森. All rights reserved.
//

#import "BaseNaviSetVC.h"

@interface RestaurantViewController : BaseNaviSetVC
@property (nonatomic,assign)NSInteger yminteger; // 1 入驻完成 2 初始设置（入驻）
@property (nonatomic,strong)NSMutableArray * erectary;
@property (nonatomic,strong)NSDictionary * storematerialdict;
@property (nonatomic,assign)NSInteger editer;
@property (nonatomic,strong)NSMutableArray * typeary;
@property (nonatomic,copy) NSString * sdwebstr;
@end
