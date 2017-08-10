//
//  OrderModel.m
//  微点筷客商户端
//
//  Created by 张森森 on 16/12/16.
//  Copyright © 2016年 张森森. All rights reserved.
//

#import "OrderModel.h"
#import "NSObject+JudgeNull.h"
@implementation OrderModel
-(id)initWithgetsomethingwithdict:(NSDictionary*)dict
{
    self = [super init];
    if (self)
    {
        NSString * time = [dict objectForKey:@"createTime"];
        NSString * arrvetime = [dict objectForKey:@"arrivalTime"];
        _ordertype = [NSString stringWithFormat:@"%@",[dict objectForKey:@"orderType"]];
        _peoplenumstr = [dict objectForKey:@"mealsNo"];
        _imagestr = [dict objectForKey:@"userImg"];
        _namestr = [dict objectForKey:@"userName"];
        _totalmoney = [dict objectForKey:@"totalFee"];
        _phonestr = [dict objectForKey:@"userPhone"];
        _severalStore = [dict objectForKey:@"severalStore"];
        _ddbhstr = [dict objectForKey:@"orderId"];
        _remarkstr = [dict objectForKey:@"remark"];
        _orderid = [dict objectForKey:@"orderId"];
        _cardTitle = dict[@"cardTitle"];
        _cardType = dict[@"cardType"];
        _realTotalFee = dict[@"realTotalFee"];
        _discountedPrice = [NSString stringWithFormat:@"%.2lf", [dict[@"discountedPrice"] doubleValue]];
        _consumptionOver = dict[@"consumptionOver"];
        _boardNum = dict[@"boardNum"];
        _extraFee = dict[@"extraFee"];
        _disOrderType = dict[@"disOrderType"];
        _activitiesId = dict[@"activitiesId"];
        NSTimeInterval timestr = [time doubleValue]/1000.0;
        NSDate * detaild = [NSDate dateWithTimeIntervalSince1970:timestr];
        NSDateFormatter * dateformatter = [[NSDateFormatter alloc]init];
        [dateformatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        NSString * creatstr = [dateformatter stringFromDate:detaild];
        
        _creattime = [creatstr substringFromIndex:5];
        
        
        NSTimeInterval arrveltime = [arrvetime doubleValue]/1000.0;
         _timeld = [NSDate dateWithTimeIntervalSince1970:arrveltime];
        NSDateFormatter * dateformatte = [[NSDateFormatter alloc]init];
        [dateformatte setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        NSString * arravestr = [dateformatte stringFromDate:_timeld];
        _arrivaltime = [arravestr substringFromIndex:5];
        _arrivalTime = arrvetime;
        NSArray * caiary = [dict objectForKey:@"orderDets"];
        _orderDets = [OrderPrintDetailModel mj_objectArrayWithKeyValuesArray:caiary];

        CGFloat backMoney = 0;
        if (![caiary isNull])
        {

            _caimoneyary = [NSMutableArray array];
            _caipinary = [NSMutableArray array];
            _numary = [NSMutableArray array];
            _beBackDets = [NSMutableArray array];
            _hasBackDets = [NSMutableArray array];
            for (int i =0; i<caiary.count; i++) {
                NSMutableDictionary *mulDic = [NSMutableDictionary dictionaryWithDictionary:caiary[i]];
                NSString * cai = mulDic[@"productName"];
                NSString * numstr = mulDic[@"quantity"];
                NSString * money = caiary[i][@"pfee"];
                CGFloat sum = [numstr integerValue] * [money doubleValue];
                NSString * sumstr = [NSString stringWithFormat:@"%.2lf",sum];

                [_caipinary addObject:cai];
                [_numary addObject:numstr];
                [_caimoneyary addObject:sumstr];


                if ([mulDic[@"isRetreat"] isNull]) {
                    [mulDic setValue:@(0) forKey:@"isRetreat"];
                }
                if ([mulDic[@"isRetreat"] integerValue] > 0) {
                    backMoney += [money doubleValue] * [mulDic[@"isRetreat"] integerValue];
                    [mulDic setValue:@([mulDic[@"isRetreat"] integerValue]) forKey:@"quantity"];
                    [_hasBackDets addObject:[mulDic mutableCopy]];
                }
                NSInteger sub = [numstr integerValue] - [mulDic[@"isRetreat"] integerValue];
                if (sub > 0) {
                    [mulDic setValue:@(sub) forKey:@"quantity"];
                    [_beBackDets addObject:[mulDic mutableCopy]];

                }
            }
            _beBackDets = [OrderPrintDetailModel mj_objectArrayWithKeyValuesArray:_beBackDets];
            _hasBackDets = [OrderPrintDetailModel mj_objectArrayWithKeyValuesArray:_hasBackDets];
            _backMoneyCondition = [NSString stringWithFormat:@"%.2lf", [_totalmoney doubleValue] - backMoney];
        }

    }
    
    
    return self;
}
@end
