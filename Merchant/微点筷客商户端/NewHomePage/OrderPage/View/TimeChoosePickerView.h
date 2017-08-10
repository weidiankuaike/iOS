//
//  TimeChoosePickerView.h
//  微点筷客商户端
//
//  Created by 张森森 on 16/10/13.
//  Copyright © 2016年 张森森. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol ZTTimerPickerViewDelegate <NSObject>

- (void)ZTselectTimesViewSetOneLeft:(NSString *)oneLeft andOneRight:(NSString *)oneRight;

@end

@interface TimeChoosePickerView : UIView <UIPickerViewDataSource,UIPickerViewDelegate>
@property (nonatomic, assign) id <ZTTimerPickerViewDelegate> delegate;

- (void)showTime;
- (void)setOldShowTimeOneLeft:(NSString *)oneLeft andOneRight:(NSString *)oneRight;
@end
