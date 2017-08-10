//
//  QueueAddNumView.h
//  微点筷客商户端
//
//  Created by Skyer God on 2017/7/3.
//  Copyright © 2017年 张甜. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QueueAddNumView : UIView
@property (strong, nonatomic) IBOutlet UITextField *nameTextField;
@property (strong, nonatomic) IBOutlet ButtonStyle *manBT;
@property (strong, nonatomic) IBOutlet ButtonStyle *womenBT;
@property (strong, nonatomic) IBOutlet UITextField *phoneTextF;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *selectArr;

@property (strong, nonatomic) IBOutlet ButtonStyle *justQueueBT;
@property (strong, nonatomic) IBOutlet ButtonStyle *printBT;
@property (strong, nonatomic) IBOutlet UIView *backView;
@property (strong, nonatomic) IBOutlet ButtonStyle *cancelButton;
@end
