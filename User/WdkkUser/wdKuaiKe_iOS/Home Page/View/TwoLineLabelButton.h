//
//  TwoLineLabelButton.h
//  wdKuaiKe_iOS
//
//  Created by Skyer God on 16/8/9.
//  Copyright © 2016年 weiDianKuaiKe. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TwoLineLabelButton : UIButton
@property (nonatomic, strong) UILabel *firstLabel; //顶部label
@property (nonatomic, strong) UILabel *secondLabel;//底部label
@property (nonatomic, assign) CGFloat line_Space;//上下label间距
@property (nonatomic, assign) CGFloat heightFirst;//顶部label高度
//@property (nonatomic, assign) CGFloat heightSecond;//底部label高度
@end
