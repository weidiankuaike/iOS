//
//  BackDishesCell.m
//  微点筷客商户端
//
//  Created by Skyer God on 2017/5/12.
//  Copyright © 2017年 张森森. All rights reserved.
//

#import "BackDishesCell.h"

@implementation BackDishesCell{


}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [_selectButton setBackgroundImage:[UIImage imageNamed:@"back_select_icon"] forState:UIControlStateSelected];
    _nameLabel.adjustsFontSizeToFitWidth = YES;
    //这个是狗屎异常，在iOS9的设备上运行就会出现这个异常全屏contentView，初步估计是因为创建xib有问题，先强制删除解决异常
    if (self.contentView.frame.size.height > 120) {
        [self.contentView removeFromSuperview];
    }
}
-(void)setModel:(OrderPrintDetailModel *)model{
    _model = model;

    NSString *url = [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:model.productImage]] ? model.productImage : [model.productImage stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [_imageV sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:[UIImage imageNamed:@"loadingIcon"]];
    _nameLabel.text = model.productName;
    _sumLabel.text = [NSString stringWithFormat:@"x %@", model.quantity];
    _priceLabel.text = [NSString stringWithFormat:@"%@元/份", model.pfee];

}
//选中方法
- (IBAction)selectDishesClick:(ButtonStyle *)sender {
    sender.selected = !sender.selected;

}
//加号方法
- (IBAction)rightButtonClick:(ButtonStyle *)sender {
    NSInteger num = [_numLabel.text integerValue];
    NSInteger tempNum = num;
    tempNum++;
    if (tempNum > [[[_sumLabel.text componentsSeparatedByString:@"x "] lastObject] integerValue]) {
//        [SVProgressHUD showInfoWithStatus:@"超出菜品数量总额"];
    } else {
        _numLabel.text = [NSString stringWithFormat:@"%ld", (long)tempNum];
    }
    if (_addOrsubClick) {
        _addOrsubClick(_numLabel.text);
    }
}
//减号方法
- (IBAction)leftButtonClick:(ButtonStyle *)sender {
    NSInteger num = [_numLabel.text integerValue];
    NSInteger tempNum = num;
    tempNum--;
    if (tempNum < 0) {
        _numLabel.text = [NSString stringWithFormat:@"%ld", (long)num];
    } else {
        _numLabel.text = [NSString stringWithFormat:@"%ld", (long)tempNum];
    }

    if (_addOrsubClick) {
        _addOrsubClick(_numLabel.text);
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
