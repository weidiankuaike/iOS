//
//  ZTPageControl.h
//  自定义collectionView
//
//  Created by Skyer God on 16/11/3.
//  Copyright © 2016年 weiDianKuaiKe. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZTPageControl : UIPageControl
{
    UIImage *imagePageStateNormal;
    UIImage *imagePageStateHighlighted;
}
- (id)initWithFrame:(CGRect)frame;
@property (nonatomic, retain) UIImage *imagePageStateNormal;
@property (nonatomic, retain) UIImage *imagePageStateHighlighted;
@end
