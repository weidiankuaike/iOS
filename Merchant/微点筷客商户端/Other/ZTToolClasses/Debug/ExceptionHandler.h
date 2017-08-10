//
//  ExceptionHandler.h
//  微点筷客商户端
//
//  Created by Skyer God on 17/3/23.
//  Copyright © 2017年 张森森. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ExceptionHandler : NSObject{
    BOOL dismissed;
}

@end
void HandleException(NSException *exception);
void SignalHandler(int signal);


void InstallUncaughtExceptionHandler(void);
