//
//  ShoppingCartSingletonView.h
//  wdKuaiKe_iOS
//
//  Created by Skyer God on 16/9/20.
//  Copyright © 2016年 weiDianKuaiKe. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ShoppingCartView;

@interface ShoppingCartSingletonView : NSObject
@property (nonatomic, strong) ShoppingCartView *shoppingCart;
+(ShoppingCartView *)shareManagerWithParentView:(UIView *)parentView;

        /** 添加cartView 到parentView **/
- (void)addShoppingCartView:(ShoppingCartView *)cartView toView:(UIView *)parentView;
        /** 使用前必须先调用- (void)addShoppingCartView:(ShoppingCartView *)cartView toView:(UIView *)parentView; **/
- (ShoppingCartView *)getCartView;
@end
