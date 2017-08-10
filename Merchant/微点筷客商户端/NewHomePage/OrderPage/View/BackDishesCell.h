//
//  BackDishesCell.h
//  微点筷客商户端
//
//  Created by Skyer God on 2017/5/12.
//  Copyright © 2017年 张森森. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OrderPrintDetailModel.h"
typedef void(^addOrsubClick)(NSString *num);
@interface BackDishesCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *priceLabel;
@property (strong, nonatomic) IBOutlet ButtonStyle *selectButton;
@property (strong, nonatomic) IBOutlet UIImageView *imageV;
@property (strong, nonatomic) IBOutlet UILabel *nameLabel;
@property (strong, nonatomic) IBOutlet UILabel *numLabel;
@property (strong, nonatomic) IBOutlet ButtonStyle *subButton;
@property (strong, nonatomic) IBOutlet ButtonStyle *addButton;
@property (strong, nonatomic) IBOutlet UILabel *sumLabel;
/** <#行注释#>   (strong) **/
@property (nonatomic, strong) addOrsubClick addOrsubClick;

/** <#行注释#>   (strong) **/
@property (nonatomic, strong) OrderPrintDetailModel *model;
@end
