//
//  RevisePhoneViewController.h
//  微点筷客商户端
//
//  Created by 张森森 on 16/10/25.
//  Copyright © 2016年 张森森. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^reviseBlock)(NSString*phonestring);

@interface RevisePhoneViewController : UIViewController
@property (nonatomic,copy)reviseBlock block;
@property (nonatomic,assign)NSInteger pushint;


-(void)text:(reviseBlock)block;
@end
