//
//  ShoppingCartSingletonView.m
//  wdKuaiKe_iOS
//
//  Created by Skyer God on 16/9/20.
//  Copyright © 2016年 weiDianKuaiKe. All rights reserved.
//

#import "ShoppingCartSingletonView.h"

#import "ShoppingCartView.h"

@implementation ShoppingCartSingletonView

static id tempView;
+(ShoppingCartView *)shareManagerWithParentView:(UIView *)parentView{

    static ShoppingCartView *shareShoppingCart = nil;
    static dispatch_once_t predicate;
        CGRect mainScreen = [[UIScreen mainScreen] bounds];
    dispatch_once(&predicate, ^{

        shareShoppingCart = [[ShoppingCartView alloc] initWithFrame:CGRectMake(0, mainScreen.size.height - 50, mainScreen.size.width, 50) inView:parentView];
            tempView = parentView;
    });

    if (shareShoppingCart.nTotal != 0 && tempView != parentView) {
    [parentView addSubview:shareShoppingCart.OverlayView];

    }
    [parentView addSubview:shareShoppingCart.OverlayView];
    [parentView bringSubviewToFront:shareShoppingCart.OverlayView.ShoppingCartView];
    
    tempView = parentView;
    return shareShoppingCart;
}

- (void)addShoppingCartView:(ShoppingCartView *)cartView toView:(UIView *)parentView{

    self.shoppingCart.backgroundColor = [UIColor whiteColor];
    cartView = _shoppingCart;
    [parentView addSubview:cartView];

}
-(ShoppingCartView *)getCartView{
        return _shoppingCart;
}
@end
