//
//  AuthcodeView.h
//  微点筷客商户端
//
//  Created by 张森森 on 16/10/8.
//  Copyright © 2016年 张森森. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface AuthcodeView : UIView
@property (strong, nonatomic) NSArray *dataArray;//字符素材数组

@property (strong, nonatomic) NSMutableString *authCodeStr;//验证码字符串
@end
