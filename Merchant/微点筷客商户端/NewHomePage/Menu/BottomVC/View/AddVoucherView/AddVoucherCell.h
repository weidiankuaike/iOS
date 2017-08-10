//
//  AddVoucherCell.h
//  微点筷客商户端
//
//  Created by Skyer God on 16/10/24.
//  Copyright © 2016年 张森森. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddVoucherCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *subLabel;
@property (strong, nonatomic) IBOutlet UILabel *sumLabel;
@property (strong, nonatomic) IBOutlet UITextField *firstTextField;
@property (strong, nonatomic) IBOutlet UITextField *secTextField;
/** <#行注释#>   (strong) **/
@property (nonatomic, strong) NSArray *chooseTitleArr;
@property (strong, nonatomic) IBOutlet UILabel *symbolLabel;
@end
