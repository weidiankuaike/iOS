//
//  ZTChartCell.m
//  merchantClient
//
//  Created by Skyer God on 2017/7/17.
//  Copyright © 2017年 张甜. All rights reserved.
//

#import "ZTChartCell.h"

@implementation ZTChartCell
{
    IBOutletCollection(UILabel) NSArray *labelArr;

}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code

    [labelArr enumerateObjectsUsingBlock:^(UILabel *label, NSUInteger idx, BOOL * _Nonnull stop) {
        CGFloat start_x = autoScaleW(12);
        CGFloat width = (kScreenWidth - start_x * 2) / 4;
        label.sd_layout
        .leftSpaceToView(self.contentView, start_x + idx * width)
        .centerYEqualToView(self.contentView)
        .widthIs(width)
        .heightRatioToView(self.contentView, 1);
    }];
}
-(void)setFlowType:(NSString *)flowType{
    [labelArr enumerateObjectsUsingBlock:^(UILabel *label, NSUInteger idx, BOOL * _Nonnull stop) {

        if (idx == 2) {
            if ([flowType isEqualToString:@"sum_fee"]) {
                //销售额
                label.text = @"销售额";
            } else if ([flowType isEqualToString:@"product_cnt"]){
                //销售量
                label.text = @"销售量";
            } else {
                //好评
                label.text = @"好评";
            }
        }
    }];

}
-(void)setModel:(DishesAnalyzeModel *)model{
    [labelArr enumerateObjectsUsingBlock:^(UILabel *label, NSUInteger idx, BOOL * _Nonnull stop) {

        switch (idx) {
            case 0:
                label.text = model.number;
                break;
            case 1:
                label.text = model.productName;
                break;
            case 2:
                if ([model.flowType isEqualToString:@"sum_fee"]) {
                    //销售额
                    label.text = model.sumFee;
                } else if ([model.flowType isEqualToString:@"product_cnt"]){
                    //销售量
                    label.text = model.productCnt;
                } else {
                    //好评
                    label.text = model.love;
                }
                break;
            case 3:
                label.text = [NSString stringWithFormat:@"%.2lf%%", [model.pct doubleValue] * 100];
                break;

            default:
                break;
        }

    }];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
