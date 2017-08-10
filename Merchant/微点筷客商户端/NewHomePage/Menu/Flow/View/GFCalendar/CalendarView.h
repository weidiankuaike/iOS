//
//  CalendarView.h
//  微点筷客商户端
//
//  Created by 张森森 on 16/11/18.
//  Copyright © 2016年 张森森. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^calenblock)(NSString * lstring,NSString*rstring,NSString* gstring);
@interface CalendarView : UIView
@property (nonatomic,strong)UILabel * leftlabel;
@property (nonatomic,strong)UILabel * rightlabel;
@property (nonatomic,strong)UILabel * typetwolabel;
@property (nonatomic,strong)UIView * calenview;
@property (nonatomic,assign)NSInteger typeinteger;

@property (nonatomic,copy)calenblock block;

-(void)Getsomething:(calenblock)block;
-(instancetype)initWithStyle:(NSInteger)styleint;

//-(void)ShowView;
@end
