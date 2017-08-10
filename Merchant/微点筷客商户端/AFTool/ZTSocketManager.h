//
//  ZTSocketManager.h
//  微点筷客商户端
//
//  Created by Skyer God on 17/2/3.
//  Copyright © 2017年 张森森. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <GCDAsyncSocket.h>
@interface ZTSocketManager : NSObject
/** 创建socket   (strong) **/
@property (nonatomic, strong) GCDAsyncSocket *socket;
+ (instancetype)sharedSocketManager;
- (void)connectToServer;
//- (void)disConnectToServer;

@end
