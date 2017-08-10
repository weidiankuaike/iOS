//
//  ZTCalender.h
//  Clendar
//
//  Created by Skyer God on 16/10/25.
//  Copyright © 2016年 weiDianKuaiKe. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol ZTPickViewDelegate <NSObject>
@optional
-(void)didFinishPickView:(NSString*)date;
-(void)pickerviewbuttonclick:(ButtonStyle *)sender;
-(void)hiddenPickerView;


@end
@interface ZTCalender : UIView
@property(nonatomic,strong)NSDate*curDate;
@property(nonatomic,strong)id<ZTPickViewDelegate>delegate;
- (void)showInView:(UIView *)view;
- (void)hiddenPickerView;
@end
