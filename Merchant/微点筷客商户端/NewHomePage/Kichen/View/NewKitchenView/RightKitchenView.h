//
//  RightKitchenView.h
//  微点筷客商户端
//
//  Created by Skyer God on 16/11/10.
//  Copyright © 2016年 张森森. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol RightKitchenViewDelegate <NSObject>


@end

@interface RightKitchenView : UIView
/** 侧边导航栏   (strong) **/
@property (nonatomic, strong) UIView *naviView;
/** 排序查看按钮   (strong) **/
@property (nonatomic, strong) UIImageView *sortImageV;
/** 排序查看label   (strong) **/
@property (nonatomic, strong) ButtonStyle *sortBT;
/**  中间分隔线  (strong) **/
@property (nonatomic, strong) UILabel *midSeparaLine;
/** 提示图标BT   (strong) **/
@property (nonatomic, strong) ButtonStyle *promptBT;
/** 餐盘Buutton   (strong) **/
@property (nonatomic, strong) ButtonStyle *palateBT;
/** 撤销图片   (strong) **/
@property (nonatomic, strong) UIImageView *revokeImageV;
/** 撤销按钮   (strong) **/
@property (nonatomic, strong) ButtonStyle *revokeBT;
/** 底部分割线   (strong) **/
@property (nonatomic, strong) UILabel *bottomSeparaLine;
/** 取消按钮图片   (strong) **/
@property (nonatomic, strong)  UIImageView  *cancelImageV;
/** 取消按钮   (strong) **/
@property (nonatomic, strong) ButtonStyle *cancelBT;






        /** 主页面 **/
/** 顶部导航栏   (strong) **/
@property (nonatomic, strong) UILabel *topNaviLabel;
/** <#行注释#>   (strong) **/
@property (nonatomic, strong) UITableView *tabelV;
/** 底部导航栏   (strong) **/
@property (nonatomic, strong) UIView *bottomNaviView;
/** 收起餐盘按钮   (strong) **/
@property (nonatomic, strong) ButtonStyle *backBT;
/** 呼叫上菜   (strong) **/
@property (nonatomic, strong) ButtonStyle *callDishes;




        /** 遮罩view **/
/** 遮罩view   (strong) **/
@property (nonatomic, strong) UIView *maskView;
@end
