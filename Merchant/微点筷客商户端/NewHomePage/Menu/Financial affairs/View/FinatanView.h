//
//  FinatanView.h
//  微点筷客商户端
//
//  Created by 张森森 on 16/11/16.
//  Copyright © 2016年 张森森. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LMPopInputPasswordView.h"
typedef void (^moneyblock)(NSString * push);

@interface FinatanView : UIView<UITextFieldDelegate,LMPopInputPassViewDelegate>
@property (nonatomic,strong)UIView * tishiview;
@property (nonatomic,assign)NSInteger ssinte;
@property (nonatomic,strong)UIView * moneyview;
@property (nonatomic,assign)BOOL isHave;
@property (nonatomic,strong)UIView * wanView;
@property (nonatomic,strong)LMPopInputPasswordView * passwordView;
@property (nonatomic,strong)ButtonStyle * fbtn;
@property (nonatomic,strong)ButtonStyle * sbtn;
@property (nonatomic,strong)ButtonStyle * tbtn;
@property (nonatomic,copy)moneyblock block;
@property  (nonatomic,copy) NSString * alipaystr,*token,*userid;
@property (nonatomic,strong) UITextField * mimatext;
/** 帐号余额  (NSString) **/
@property (nonatomic, copy) NSString *balanceMoney;
-(instancetype)initWithHave:(BOOL)have str:(NSString *)alipay;

-(void)getstring:(moneyblock)block;
@end
