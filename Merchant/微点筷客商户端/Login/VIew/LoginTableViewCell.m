//
//  LoginTableViewCell.m
//  微点筷客商户版
//
//  Created by 张森森 on 16/9/30.
//  Copyright © 2016年 张森森. All rights reserved.
//

#import "LoginTableViewCell.h"

@interface LoginTableViewCell ()<UITextFieldDelegate>

@end
@implementation LoginTableViewCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        _leftlabel = [[UILabel alloc]init];
        _leftlabel.font = [UIFont systemFontOfSize:14];
        _leftlabel.textAlignment = NSTextAlignmentLeft;
        [self addSubview:self.leftlabel];
        self.leftlabel.sd_layout.leftSpaceToView(self,autoScaleW(15)).topSpaceToView(self,autoScaleH(0)).widthIs(autoScaleW(120)).heightIs(autoScaleH(45));
//        _leftlabel.adjustsFontSizeToFitWidth = YES;
        _textfild =[[UITextField alloc]init];
        _textfild.font = [UIFont systemFontOfSize:14];
        _textfild.delegate = self;
        [self addSubview:self.textfild];
        self.textfild.sd_layout.leftSpaceToView(self.leftlabel,0).centerYEqualToView(self.contentView).widthIs(autoScaleW(200)).heightIs(autoScaleH(45));
        [_textfild addObserver:self forKeyPath:@"text" options:NSKeyValueObservingOptionOld | NSKeyValueObservingOptionNew | NSKeyValueObservingOptionInitial context:@"phone"];

    }
    return self;
}
-(void)dealloc{
    [_textfild removeObserver:self forKeyPath:@"text"];
}
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(UITextField *)object change:(NSDictionary *)change context:(void *)context
{
    if (context == @"phone") {
        if ([_leftlabel.text containsString:@"手机号"] && ![object.text isNull]) {
             NSMutableString *tempStr = [[NSMutableString alloc]initWithString:object.text];
            if (object.text.length == 11) {
                if (![[object.text substringToIndex:6] containsString:@" "]) {
                    [tempStr insertString:@" " atIndex:3];
                     _textfild.text = tempStr;
                }
                if (![[object.text substringFromIndex:6] containsString:@" "]) {
                    [tempStr insertString:@" " atIndex:8];
                     _textfild.text = tempStr;
                }
            } else {

            }
        } else if ([_leftlabel.text containsString:@"身份证"] && ![object.text isNull]){

        }
    } else {

    }
    if ([_leftlabel.text containsString:@"验证码"]) {
        _textfild.secureTextEntry = NO;
        _textfild.keyboardType = UIKeyboardTypeNumberPad;
    }
    if ([_leftlabel.text isEqualToString:@"密码"]) {
        _textfild.secureTextEntry = YES;
        _textfild.keyboardType = UIKeyboardTypeDefault;
    }
}
-(void)layoutSubviews{                                            
    [super layoutSubviews];
    CGSize fontSize =[_leftlabel.text sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:_leftlabel.font,NSFontAttributeName, nil]];
    if ([_identify isEqualToString:@"入驻资料"]) {
        _leftlabel.sd_layout.leftSpaceToView(self,autoScaleW(15)).topEqualToView(self).widthIs(fontSize.width > autoScaleW(120) ? fontSize.width : autoScaleW(150)).heightIs(45);

        [self updateLayout];
    } else {
        self.leftlabel.sd_layout.leftSpaceToView(self,autoScaleW(15)).topSpaceToView(self,autoScaleH(0)).widthIs(fontSize.width > autoScaleW(120) ? fontSize.width :autoScaleW(120)).heightIs(autoScaleH(self.height_sd));
    }

}
-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField{

    if ([_leftlabel.text containsString:@"密码"] || [_leftlabel.text containsString:@"再次确认"]) {
        _textfild.secureTextEntry = YES;
        _textfild.keyboardType = UIKeyboardTypeDefault;
    } else {
        _textfild.secureTextEntry = NO;
    }

    if ([_leftlabel.text containsString:@"手机号"] || [_leftlabel.text containsString:@"身份证"] || [_leftlabel.text containsString:@"号"] || [_leftlabel.text containsString:@"电话号"] || [_leftlabel.text containsString:@"验证码"]) {
        textField.keyboardType = UIKeyboardTypeNumberPad;
        _textfild.clearButtonMode = UITextFieldViewModeWhileEditing;
        if ([_leftlabel.text containsString:@"验证码"]) {
            _textfild.clearsOnBeginEditing = NO;
        }
    }

    return YES;
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    return YES;
}
-(BOOL)textFieldShouldEndEditing:(UITextField *)textField{

    return YES;
}
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if ([_leftlabel.text containsString:@"手机号"]) {
        if (range.location == 3 && ![string isNull]) {
            textField.text = [NSString stringWithFormat:@"%@ ", textField.text];
        }
        if (range.location == 8 && ![string isNull]) {
            textField.text = [NSString stringWithFormat:@"%@ ", textField.text];
        }
        if ([string isNull] && range.location == 9) {
//            textField.text = [textField.text substringToIndex:range.location];
            textField.text = [textField.text substringToIndex:9];
        }
        if ([string isNull] && range.location == 4) {
            textField.text = [textField.text substringToIndex:4];
        }
        if ([textField.text deleteTabOrSpaceStr].length > 10 && ![string isNull]) {
            return NO;
        }
    }

    return YES;
}
-(void)textFieldDidEndEditing:(UITextField *)textField{
    NSString *tempStr = [textField.text deleteTabOrSpaceStr];
    if ([_leftlabel.text containsString:@"手机号"] || [_leftlabel.text containsString:@"身份证"] || [_leftlabel.text containsString:@"号"] || [_leftlabel.text containsString:@"电话号"] ) {
        textField.text = [textField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        if ([_leftlabel.text containsString:@"手机号"]  || [_leftlabel.text containsString:@"电话号"]) {
            if ([tempStr isMobileNumber]) {
                [textField resignFirstResponder];
            } else {
                [SVProgressHUD showInfoWithStatus:@"请输入正确的手机号码"];
                _textfild.text = @"";
            }
        }
        if ([_leftlabel.text containsString:@"身份证"]) {
            if (![tempStr simpleVerifyIdentityCardNum]) {
                [SVProgressHUD showInfoWithStatus:@"请输入正确的身份证号"];
                _textfild.text = @"";
            }
        }
        if ([_leftlabel.text containsString:@"卡号"]) {
            if (![tempStr bankCardluhmCheck]) {
                [SVProgressHUD showInfoWithStatus:@"请输入正确的体现卡号"];
                _textfild.text = @"";
            }
        }

    }

}
- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
