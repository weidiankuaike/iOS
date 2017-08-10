//
//  BaseButton.h
//  WDKKtest
//
//  Created by Skyer God on 16/7/22.
//  Copyright © 2016年 weiDianKuaiKe. All rights reserved.
//

#import <UIKit/UIKit.h>



@interface BaseButton : UIButton
        /** 图片的其实高度 一般取3~10就好 **/
@property (nonatomic , assign) CGFloat Image_Y;
        /** 图片的起始位置 一般取5 - 15 推荐使用10 **/
@property (nonatomic, assign) CGFloat Image_X;
        /** 图片和文字的间距 一般取 15 **/
@property (nonatomic, assign) CGFloat Title_Space;//

@end
