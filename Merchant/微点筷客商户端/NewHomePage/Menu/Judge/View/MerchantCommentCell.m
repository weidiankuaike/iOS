//
//  MerchantCommentCell.m
//  微点筷客商户端
//
//  Created by Skyer God on 17/2/13.
//  Copyright © 2017年 张森森. All rights reserved.
//

#import "MerchantCommentCell.h"

@implementation MerchantCommentCell
{
    UILabel *nameLabel, *contentLabel;
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = RGB(238, 238, 238);
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self setUp];
    }
    return self;
}
- (void)setUp{
    nameLabel = [[UILabel alloc] init];
    [self.contentView addSubview:nameLabel];
    //        nameLabel.contentMode = UIControlContentVerticalAlignmentTop | UIControlContentHorizontalAlignmentLeft;
    nameLabel.font = [UIFont systemFontOfSize:12];

    contentLabel = [[UILabel alloc] init];
    [self.contentView addSubview:contentLabel];
    contentLabel.font = nameLabel.font;
    nameLabel.backgroundColor = [UIColor clearColor];
    contentLabel.backgroundColor = [UIColor clearColor];
    contentLabel.numberOfLines = 0;

    nameLabel.sd_layout
    .leftEqualToView(self.contentView)
    .topEqualToView(self.contentView)
    .heightIs(15)
    .widthIs(autoScaleW(70));
//    [nameLabel setSingleLineAutoResizeWithMaxWidth:100];

    contentLabel.sd_layout
    .leftSpaceToView(nameLabel, 0)
    .rightEqualToView(self.contentView)
    .topEqualToView(self.contentView)
    .heightRatioToView(self.contentView, 1);



}
-(void)setModel:(CommentModel *)model{
    dispatch_async(dispatch_get_main_queue(), ^{
        nameLabel.text = [model.isUser isEqualToString:@"0"] ? @" 用户回复：": @" 商户回复：";
        contentLabel.text = model.content;
        [self setupAutoHeightWithBottomViewsArray:@[nameLabel, contentLabel] bottomMargin:0];
    });

}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
