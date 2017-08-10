//
//  AddVoucherCell.m
//  微点筷客商户端
//
//  Created by Skyer God on 16/10/24.
//  Copyright © 2016年 张森森. All rights reserved.
//

#import "AddVoucherCell.h"
@interface AddVoucherCell ()<UITextFieldDelegate>

@end
@implementation AddVoucherCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
     [self create];
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {

    }
    return self;
}
- (void)create{
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.backgroundColor = [UIColor blackColor].CGColor;

    gradientLayer.frame = CGRectMake(0, _firstTextField.frame.size.height - 1, _firstTextField.frame.size.width, 1);
    [_firstTextField.layer addSublayer:gradientLayer];


    CAGradientLayer *secGradientLayer = [CAGradientLayer layer];
    secGradientLayer.backgroundColor = [UIColor blackColor].CGColor;

    secGradientLayer.frame = CGRectMake(0, _secTextField.frame.size.height - 1, _secTextField.frame.size.width, 1);
    [_secTextField.layer addSublayer:secGradientLayer];

    _subLabel.contentMode = UIControlContentVerticalAlignmentBottom | UIControlContentHorizontalAlignmentRight;
    _sumLabel.contentMode = _subLabel.contentMode;

}
- (void)setChooseTitleArr:(NSArray *)chooseTitleArr{
    _chooseTitleArr = chooseTitleArr;

    _subLabel.text = chooseTitleArr[0];
    _symbolLabel.text = chooseTitleArr[1];
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    return [textField resignFirstResponder];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
