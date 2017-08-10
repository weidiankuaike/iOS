//
//  MyorderTableViewCell.m
//  WDKKtest
//
//  Created by 张森森 on 16/8/7.
//  Copyright © 2016年 weiDianKuaiKe. All rights reserved.
//

#import "MyorderTableViewCell.h"
#import "ZTAddOrSubAlertView.h"
@implementation MyorderTableViewCell


-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        _headimage = [[UIImageView alloc]init];
        [self.contentView addSubview:_headimage];
        _headimage.sd_layout.leftSpaceToView(self.contentView,autoScaleW(10)).topSpaceToView(self.contentView,autoScaleH(10)).widthIs(autoScaleW(30)).heightIs(autoScaleW(30));
        
        _namelabel = [[UILabel alloc]init];
        _namelabel.font = [UIFont systemFontOfSize:15];
        _namelabel.textColor = UIColorFromRGB(0x000000);
        [self.contentView addSubview:_namelabel];
        _namelabel.sd_layout.leftSpaceToView(_headimage,autoScaleW(5)).topSpaceToView(self.contentView,autoScaleH(20)).heightIs(15);
        [_namelabel setSingleLineAutoResizeWithMaxWidth:200];
        
        _firstlabel = [[UILabel alloc]init];
        _firstlabel.textAlignment = NSTextAlignmentRight;
        _firstlabel.font = [UIFont systemFontOfSize:15];
        _firstlabel.textColor = UIColorFromRGB(0x727272);
        [self.contentView addSubview:_firstlabel];
        _firstlabel.sd_layout.rightSpaceToView(self.contentView,10).topSpaceToView(self.contentView,15).heightIs(15).widthIs(120);
        
        UILabel * linlabel = [[UILabel alloc]init];
        linlabel.backgroundColor = UIColorFromRGB(0xfd7577);
        [self.contentView addSubview:linlabel];
        linlabel.sd_layout.topSpaceToView(_headimage,10).leftSpaceToView(self.contentView,10).rightSpaceToView(self.contentView,10).heightIs(1);
        //几人用餐
        _xinxilabel = [[UILabel alloc]init];
        _xinxilabel.font = [UIFont systemFontOfSize:13];
        [self.contentView addSubview:_xinxilabel];
        _xinxilabel.sd_layout.leftSpaceToView(self.contentView,20).topSpaceToView(_firstlabel,30).heightIs(15);
        [_xinxilabel setSingleLineAutoResizeWithMaxWidth:200];
        
        //订单状态
        _ztlabel = [[UILabel alloc]init];

        _ztlabel.font = [UIFont systemFontOfSize:13];
        [self.contentView addSubview:_ztlabel];
        _ztlabel.sd_layout.leftSpaceToView(self.contentView,20).topSpaceToView(_firstlabel,60).heightIs(15);
        [_ztlabel setSingleLineAutoResizeWithMaxWidth:200];
        //价钱
         _moneylabel = [[UILabel alloc]init];
        _moneylabel.font = [UIFont systemFontOfSize:13];
        [self.contentView addSubview:_moneylabel];
        _moneylabel.sd_layout.leftSpaceToView(self.contentView,20).topSpaceToView(_firstlabel,90).heightIs(15);
        [_moneylabel setSingleLineAutoResizeWithMaxWidth:200];
//
//        
         _arrvaltimelabel = [[UILabel alloc]init];
        
        _arrvaltimelabel.textColor = UIColorFromRGB(0x000000);
        _arrvaltimelabel.font = [UIFont systemFontOfSize:13];
        [self.contentView addSubview:_arrvaltimelabel];
        _arrvaltimelabel.sd_layout.rightSpaceToView(self.contentView,20).topSpaceToView(_firstlabel,30).heightIs(15);
        [_arrvaltimelabel setSingleLineAutoResizeWithMaxWidth:200];
        
        _timelabel = [[UILabel alloc]init];
        _timelabel.textColor = UIColorFromRGB(0x000000);
        _timelabel.font = [UIFont systemFontOfSize:13];
        [self.contentView addSubview:_timelabel];
        _timelabel.sd_layout.rightSpaceToView(self.contentView,20).topSpaceToView(_firstlabel,60).heightIs(15);
        [_timelabel setSingleLineAutoResizeWithMaxWidth:200];
        
        _btn = [UIButton buttonWithType:UIButtonTypeCustom];
        _btn.layer.masksToBounds = YES;
        _btn.layer.cornerRadius = 3;
        _btn.titleLabel.font = [UIFont systemFontOfSize:13];
        _btn.backgroundColor = UIColorFromRGB(0xfd7577);
        [_btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_btn addTarget:self action:@selector(Click:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_btn];
        _btn.sd_layout.rightSpaceToView(self,10).bottomSpaceToView(self,10 ).widthIs(80).heightIs(25);
        
        _deletbtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_deletbtn setTitle:@"取消订单" forState:UIControlStateNormal];
        _deletbtn.titleLabel.font = [UIFont systemFontOfSize:13];
        _deletbtn.backgroundColor = UIColorFromRGB(0xfd7577);
        _deletbtn.layer.masksToBounds = YES;
        _deletbtn.layer.cornerRadius = 3;
        [_deletbtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_deletbtn addTarget:self action:@selector(Delet) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_deletbtn];
        _deletbtn.sd_layout.rightSpaceToView(_btn,10).bottomEqualToView(_btn).widthIs(80).heightIs(25);
        _deletbtn.hidden = YES;
        
     }
    
    return self;
}
-(void)setModel:(Myordermodel *)model
{
    _model = model;
    
    [_headimage sd_setImageWithURL:[NSURL URLWithString:_model.storeimage] placeholderImage:[UIImage imageNamed:@"1"]];
    _namelabel.text = _model.storename;
    _timelabel.text = [NSString stringWithFormat:@"下单时间%@",_model.creattime];
    
    if ([model.disorderType isEqualToString:@"1"]) {
        
        _xinxilabel.text = @"到店用餐";
        if ([_model.moneystr floatValue]==0) {
            
            _moneylabel.text = @"未点餐";
        }else{
            double realtotal = [_model.moneystr doubleValue];
            NSString * realtotalStr = [NSString stringWithFormat:@"￥%.2f",realtotal];
            _moneylabel.text = realtotalStr;

        }
        
    }else{
        _xinxilabel.text = [NSString stringWithFormat:@"%@用餐/餐桌待定",_model.mealsno];
        double realtotal = [_model.moneystr doubleValue];
        NSString * realtotalStr = [NSString stringWithFormat:@"￥%.2f",realtotal];
        _moneylabel.text = realtotalStr;

    }
    _arrvaltimelabel.text = [NSString stringWithFormat:@"预定时间%@",_model.arrivaltime];
    
    _btn.hidden = NO;
    __weak NSString * typestr = nil;
    if ([_model.ordertype isEqualToString:@"4"]) {
        
        _firstlabel.text = @"预定成功";
        _ztlabel.text = @"预定成功，等待用餐";
        [_btn setTitle:@"扫码用餐" forState:UIControlStateNormal];

    }
    else if ([_model.ordertype isEqualToString:@"19"]) {
        
        _firstlabel.text = @"已结束";
        _ztlabel.text = @"已结束";
        
        if ([_model.moneystr floatValue]==0) {
            
            [_btn setTitle:@"再次预订" forState:UIControlStateNormal];
        }else{
            [_btn setTitle:@"去评价" forState:UIControlStateNormal];
            
        }
        

    }
    else if ([_model.ordertype isEqualToString:@"5"]) {
        
        _firstlabel.text = @"已取消";
        _ztlabel.text = @"用户取消";
        [_btn setTitle:@"再次预定" forState:UIControlStateNormal];

    }
    else if ([_model.ordertype isEqualToString:@"0"]) {
        if ([model.disorderType integerValue] == 1&&[model.moneystr floatValue]==0) {
            //扫码用餐加菜 不用再次扫码 直接进服务
            _firstlabel.text = @"正在用餐";
            _ztlabel.text = @"您正在用餐";
            [_btn setTitle:@"进入服务" forState:UIControlStateNormal];
        }else{
        _firstlabel.text = @"待支付";
        _ztlabel.text = @"等待支付";
        [_btn setTitle:@"去支付" forState:UIControlStateNormal];
        }
        
    }
    else if ([_model.ordertype isEqualToString:@"20"]) {
        _firstlabel.text = @"已取消";
        _ztlabel.text = @"支付超时，订单取消";
        [_btn setTitle:@"再次预定" forState:UIControlStateNormal];

    }
    else if ([_model.ordertype isEqualToString:@"2"]) {
        
        _firstlabel.text = @"已取消";
        _ztlabel.text = @"商家未接单";
        [_btn setTitle:@"再次预定" forState:UIControlStateNormal];

    }
    else if ([_model.ordertype isEqualToString:@"18"]) {
        
        _firstlabel.text = @"进行中";
        _ztlabel.text = @"正在用餐";
        [_btn setTitle:@"进入服务" forState:UIControlStateNormal];
    }
    else if ([_model.ordertype isEqualToString:@"1"])
    {
        _firstlabel.text = @"已支付";
        _ztlabel.text = @"等待商家确认接单";
        [_btn setTitle:@"取消订单" forState:UIControlStateNormal];

    }
    else if ([_model.ordertype isEqualToString:@"3"])
    {
        _firstlabel.text = @"已取消";
        _ztlabel.text = @"商家手动取消";
        [_btn setTitle:@"再次预定" forState:UIControlStateNormal];

    }
    else if ([_model.ordertype isEqualToString:@"6"]||[_model.ordertype isEqualToString:@"7"]||[_model.ordertype isEqualToString:@"8"])
    {
        _firstlabel.text = @"已取消";
        _ztlabel.text = @"商家接单，用户取消";
        [_btn setTitle:@"再次预定" forState:UIControlStateNormal];

    }
    else if ([_model.ordertype isEqualToString:@"9"]||[_model.ordertype isEqualToString:@"10"])
    {
        _firstlabel.text = @"已取消";
        _ztlabel.text = @"用户已支付,商家取消";
        [_btn setTitle:@"再次预定" forState:UIControlStateNormal];

    }
    else if ([_model.ordertype isEqualToString:@"11"])
    {
        _firstlabel.text = @"已提交";
        _ztlabel.text = @"预订座位，等待商家确认";
        [_btn setTitle:@"取消订单" forState:UIControlStateNormal];

    }
    else if ([_model.ordertype isEqualToString:@"12"])
    {
        _firstlabel.text = @"已取消";
        _ztlabel.text = @"商家未接单,用户取消";
        [_btn setTitle:@"再次预定" forState:UIControlStateNormal];

    }
    else if ([_model.ordertype isEqualToString:@"13"])
    {
        _firstlabel.text = @"已取消";
        _ztlabel.text = @"预定座位,商家取消";
        [_btn setTitle:@"再次预定" forState:UIControlStateNormal];

    }
    else if ([_model.ordertype isEqualToString:@"14"])
    {
        _firstlabel.text = @"已提交";
        _ztlabel.text = @"预定成功";
        [_btn setTitle:@"扫码用餐" forState:UIControlStateNormal];
    }
    else if ([_model.ordertype isEqualToString:@"15"]||[_model.ordertype isEqualToString:@"16"])
    {
        _firstlabel.text = @"已取消";
        _ztlabel.text = @"商家接单，用户取消";
        [_btn setTitle:@"再次预定" forState:UIControlStateNormal];

    }
    else if ([_model.ordertype isEqualToString:@"17"])
    {
        _firstlabel.text = @"已取消";
        _ztlabel.text = @"商家接单，迟到取消";
        [_btn setTitle:@"再次预定" forState:UIControlStateNormal];

    }
    else if ([_model.ordertype isEqualToString:@"21"])
    {
        _firstlabel.text = @"已结束";
        _ztlabel.text = @"评价完毕";
        [_btn setTitle:@"再次预定" forState:UIControlStateNormal];

    }
    else if ([_model.ordertype isEqualToString:@"22"]||[_model.ordertype isEqualToString:@"23"])
    {
        _firstlabel.text = @"已结束";
        _ztlabel.text = @"商家未确认，用户取消";
        [_btn setTitle:@"再次预定" forState:UIControlStateNormal];

    }else if ([_model.ordertype isEqualToString:@"24"]){
        
        _firstlabel.text = @"已作废";
        _ztlabel.text = @"该订单已作废";
        _btn.hidden = YES;
    }
    
    if ([_model.ordertype isEqualToString:@"4"]||[_model.ordertype isEqualToString:@"14"]||[_model.ordertype isEqualToString:@"0"]) {
        if ([_model.ordertype isEqualToString:@"0"]&&[_model.disorderType integerValue]==1) {
            
            _deletbtn.hidden = YES;//进入服务，正在用餐后没有取消按钮；
        }else{
        _deletbtn.hidden = NO;
        }
    }
    else{
        if (_deletbtn) {
            _deletbtn.hidden = YES; 
        }
    }
    
    
    if ([_model.ordertype isEqualToString:@"0"]&&[_model.disorderType integerValue]!=1||[_model.ordertype isEqualToString:@"1"]||[_model.ordertype isEqualToString:@"11"]) {//需要用倒计时的三种状态 待支付、等待商家接单
        UILabel * label = (UILabel*)[self viewWithTag:1000];
        if (label) {
            [label removeFromSuperview];
            
        }
            UILabel * endtimelabel = [[UILabel alloc]init];
            endtimelabel.tag = 1000;
            endtimelabel.text = @"";
            endtimelabel.textAlignment = NSTextAlignmentRight;
            endtimelabel.textColor = [UIColor blackColor];
            endtimelabel.font = [UIFont systemFontOfSize:autoScaleW(13)];
            [self addSubview:endtimelabel];
          endtimelabel.sd_layout.rightSpaceToView(_deletbtn,autoScaleW(10)).topEqualToView(_btn).heightIs(autoScaleH(15)).widthIs(autoScaleW(140));
        
            [self timerWithUIlabel:endtimelabel timeterval:[_model.timers integerValue]];
        
    }else{
        
        UILabel * label = (UILabel*)[self viewWithTag:1000];
        if (label) {
            [label removeFromSuperview];

        }
    }
    
   
}
- (void)timerWithUIlabel:(UILabel*)label timeterval:(NSInteger)timeval{
    
    UIApplication*   app = [UIApplication sharedApplication];
    __block    UIBackgroundTaskIdentifier bgTask;
    bgTask = [app beginBackgroundTaskWithExpirationHandler:^{
        dispatch_async(dispatch_get_main_queue(), ^{
            if (bgTask != UIBackgroundTaskInvalid)
            {
                bgTask = UIBackgroundTaskInvalid;
            }
        });
    }];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            if (bgTask != UIBackgroundTaskInvalid)
            {
                bgTask = UIBackgroundTaskInvalid;
            }
        });
    });

    
        __block int timeout = timeval; //倒计时时间
        
        if (timeout!=0) {
            dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
            dispatch_source_t timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
            dispatch_source_set_timer(timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
            dispatch_source_set_event_handler(timer, ^{
                if(timeout<=0){ //倒计时结束，关闭
                    dispatch_source_cancel(timer);
                    
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [self cancleOrderwithop:@"2"];
                
                [label removeFromSuperview];
                
                        });
                    
                }else{
                    int days = (int)(timeout/(3600*24));
                    
                    int hours = (int)((timeout-days*24*3600)/3600);
                    int minute = (int)(timeout-days*24*3600-hours*3600)/60;
                    int second = timeout-days*24*3600-hours*3600-minute*60;
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        
                        if ([_model.ordertype isEqualToString:@"1"]||[_model.ordertype isEqualToString:@"0"]&&[_model.disorderType integerValue]!=1||[_model.ordertype isEqualToString:@"11"]) {
                            if (minute>=1) {
                                
                                label.text = [NSString stringWithFormat:@"(剩余时间%dm:%ds)",minute,second];
                            }
                            else
                            {
                                label.text = [NSString stringWithFormat:@"(剩余时间%ds)",second];
                            }
                            
                        }else{
                            dispatch_source_cancel(timer);

                            [label removeFromSuperview];

                        }
                    });
  
                    timeout--;
                }
            });
            dispatch_resume(timer);
        }
    

}
- (void)Click:(UIButton*)btn
{
    if ([_model.ordertype isEqualToString:@"1"]||
        [_model.ordertype isEqualToString:@"11"]) {//只有取消订单按钮
        
         [self Delet];
    }
    else{
    if (self.block) {
        
        self.block(@"click");
    }
}
    
}
#pragma mark 取消

-(void)Delet
{
    if ([_model.ordertype isEqualToString:@"4"]||[_model.ordertype isEqualToString:@"14"]) {
        
        
    NSDateFormatter *formatter=[[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"MM-dd HH:mm"];
    NSString *dateTime=[formatter stringFromDate:[NSDate date]];
    NSDate *date = [formatter dateFromString:dateTime];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MM-dd HH:mm"];
    NSString *oneDayStr = [dateFormatter stringFromDate:date];
    NSString *anotherDayStr = [dateFormatter stringFromDate:_model.arrivedate];
    NSDate *dateA = [dateFormatter dateFromString:oneDayStr];
    NSDate *dateB = [dateFormatter dateFromString:anotherDayStr];
    NSComparisonResult result = [dateA compare:dateB];
    if (result == NSOrderedAscending) {
        
        ZTAddOrSubAlertView * subalert = [[ZTAddOrSubAlertView alloc]initWithStyle:ZTalertSheetStyleTitle];
        subalert.titleLabel.text = @"您确定要取消订单？";
        subalert.complete = ^(BOOL choose){
            if (choose==YES) {
                
                [self cancleOrderwithop:@"1"];
            }
        };
    }
    else if (result == NSOrderedDescending){
        [MBProgressHUD showMessage:@"请稍等"];
        NSString * deletUrl = [NSString stringWithFormat:@"%@/common/getPer?",commonUrl];
        [[QYXNetTool shareManager]getNetWithUrl:deletUrl urlBody:nil header:nil response:QYXJSON success:^(id result) {
            [MBProgressHUD hideHUD];
            NSLog(@"<><><%@",result);
            NSString * msgType = [NSString stringWithFormat:@"%@",result[@"msgType"]];
            if ([msgType isEqualToString:@"0"]) {
                NSString * objdstr = result[@"obj"];
                ZTAddOrSubAlertView * subalert = [[ZTAddOrSubAlertView alloc]initWithStyle:ZTalertSheetStyleTitle];
                subalert.titleLabel.text = [NSString stringWithFormat:@"若迟到超三十分钟取消订单要扣%@的商家损失费",objdstr];
                subalert.complete = ^(BOOL choose){
                    if (choose==YES) {
                        
                        [self cancleOrderwithop:@"1"];
                    }
                };
                
            }else{
                [MBProgressHUD showMessage:@"请求失败"];
            }
            
        } failure:^(NSError *error) {
            [MBProgressHUD hideHUD];
            [MBProgressHUD showError:@"请求失败"];
        }];
    }
    }else{
        ZTAddOrSubAlertView * subalert = [[ZTAddOrSubAlertView alloc]initWithStyle:ZTalertSheetStyleTitle];
        subalert.titleLabel.text = @"您确定要取消订单？";
        subalert.complete = ^(BOOL choose){
            if (choose==YES) {
                [self cancleOrderwithop:@"1"];
            }
        };
    }
}
- (void)cancleOrderwithop:(NSString*)operation {
    [MBProgressHUD showMessage:@"请稍等"];
    
    NSString * url = [NSString stringWithFormat:@"%@/api/user/myOrderManage?token=%@&userId=%@&operation=%@&orderId=%@&orderType=%@",commonUrl,Token,Userid,operation,_model.orderid,_model.ordertype];
    NSArray * urlary = [url componentsSeparatedByString:@"?"];
    
    [[QYXNetTool shareManager]postNetWithUrl:urlary.firstObject urlBody:urlary.lastObject bodyStyle:QYXBodyString header:nil response:QYXJSON success:^(id result)
     
     {
         [MBProgressHUD hideHUD];
         NSString * msgtype = [NSString stringWithFormat:@"%@",result[@"msgType"]];
         if ([msgtype isEqualToString:@"0"]) {
             [MBProgressHUD showSuccess:@"取消成功"];
             
             if (self.block) {
                 self.block(@"reload");
             }
             
         }else{
             [MBProgressHUD showError:@"取消失败"];
         }
         
     } failure:^(NSError *error)
     {
         [MBProgressHUD hideHUD];
         [MBProgressHUD showError:@"请求失败"];

         
     }];
}
-(void)layoutSubviews{
    [super layoutSubviews];
    self.layer.shadowColor = [UIColor blackColor].CGColor;
    self.layer.shadowOpacity = 1.75f;
    self.layer.shadowRadius = 4.0;
    self.layer.shouldRasterize = YES;
    self.layer.rasterizationScale = [UIScreen mainScreen].scale;
    CGPathRef path = [UIBezierPath bezierPathWithRect:CGRectMake(0, self.bounds.size.height, [UIScreen mainScreen].bounds.size.width,2)].CGPath;
    [self.layer setShadowPath:path];
    
}



- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
