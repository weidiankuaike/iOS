//
//  PrinterModel.m
//  微点筷客商户端
//
//  Created by Skyer God on 17/1/3.
//  Copyright © 2017年 张森森. All rights reserved.
//

#import "PrinterModel.h"
#import <MJExtension.h>
@implementation PrinterModel
+ (NSDictionary *)mj_objectClassInArray{
    return @{
             @"orderDets" : @"OrderPrintDetailModel"
             };
}

-(void)mj_keyValuesDidFinishConvertingToObject{

}
@end
