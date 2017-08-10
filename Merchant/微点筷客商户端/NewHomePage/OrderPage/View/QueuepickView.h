//
//  QueuepickView.h
//  微点筷客商户端
//
//  Created by 张森森 on 16/12/2.
//  Copyright © 2016年 张森森. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol TimerPickerViewDelegate <NSObject>

@optional

- (void)ZTselectTimesViewSetOneLeft:(NSString *)oneLeft ;
@end
@interface QueuepickView : UIView<UIPickerViewDelegate,UIPickerViewDataSource>
@property (nonatomic, assign) id <TimerPickerViewDelegate> delegate;

- (void)showTime;
- (void)setOldShowTimeOneLeft:(NSString *)oneLeft ;
@end
