//
//  ZTTimerPickerView.h
//  wdKuaiKe_iOS
//
//  Created by Skyer God on 16/10/7.
//  Copyright © 2016年 weiDianKuaiKe. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ZTTimerPickerViewDelegate <NSObject>

@optional

- (void)ZTselectTimesViewSetOneLeft:(NSString *)oneLeft andOneRight:(NSString *)oneRight andTwoLeft:(NSString *)twoLeft andTwoRight:(NSString *)twoRight;

@end

@interface ZTTimerPickerView : UIView<UIPickerViewDataSource,UIPickerViewDelegate>

@property (nonatomic, assign) id <ZTTimerPickerViewDelegate> delegate;

- (void)showTime;
- (void)setOldShowTimeOneLeft:(NSString *)oneLeft andOneRight:(NSString *)oneRight andTwoLeft:(NSString *)twoLeft andTwoRight:(NSString *)twoRight;

@end
