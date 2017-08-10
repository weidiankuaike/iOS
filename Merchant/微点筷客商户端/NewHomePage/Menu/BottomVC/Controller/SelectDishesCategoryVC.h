//
//  SelectDishesCategoryVC.h
//  merchantClient
//
//  Created by Skyer God on 2017/7/27.
//  Copyright © 2017年 张甜. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseNaviSetVC.h"
typedef void(^dimissBlock)(NSString *text);
@interface SelectDishesCategoryVC : BaseNaviSetVC
/** <#行注释#>   (strong) **/
@property (nonatomic, strong) NSMutableArray *getKeyArray;
/** uit   (strong) **/
@property (nonatomic, strong) UITextField *textField;
/** <#行注释#>   (strong) **/
@property (nonatomic, strong) dimissBlock dismissBlock;
@end
