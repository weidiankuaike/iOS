//
//  YindaoView.h
//  wdKuaiKe_iOS
//
//  Created by 张森森 on 16/9/1.
//  Copyright © 2016年 weiDianKuaiKe. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YindaoView : UIView <UIScrollViewDelegate>
{
    int screen_width;
    int screen_hight;
    
}
@property (nonatomic,retain)UIScrollView * scrollView;
@property (nonatomic,retain)NSArray * imageAry;
+(void)ShowgudieView:(NSArray*)imageAry;
+(void)Skipguide;
-(instancetype)init:(NSArray*)imageAry;
@end
