//
//  MerchantCommentView.m
//  微点筷客商户端
//
//  Created by Skyer God on 17/2/10.
//  Copyright © 2017年 张森森. All rights reserved.
//

#import "MerchantCommentView.h"
#import "CommentModel.h"
@interface MerchantCommentView ()
/** 存储所有评论的label   (strong) **/
@property (nonatomic, strong) NSArray *tempCommentVArr;
/** <#行注释#>   (strong) **/
@property (nonatomic, strong) NSArray *tempNameArr;

@end
static NSInteger COUNT = 15;
@implementation MerchantCommentView
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
+(void)getCommentArrCount:(NSInteger)count{
    COUNT = count;
}
- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor lightGrayColor];
        [self setup];
    }
    return self;
}

- (void)setup
{
    NSMutableArray *temp = [NSMutableArray new];
    NSMutableArray *tempName = [NSMutableArray new];

    for (int i = 0; i < COUNT; i++) {
        UILabel *nameLabel = [[UILabel alloc] init];
        [self addSubview:nameLabel];
//        nameLabel.contentMode = UIControlContentVerticalAlignmentTop | UIControlContentHorizontalAlignmentLeft;
        nameLabel.font = [UIFont systemFontOfSize:12];
        [tempName addObject:nameLabel];

        UILabel *contentLabel = [[UILabel alloc] init];
        [self addSubview:contentLabel];
        contentLabel.font = nameLabel.font;
        [temp addObject:contentLabel];
        contentLabel.numberOfLines = 0;


        nameLabel.backgroundColor = [UIColor redColor];
        contentLabel.backgroundColor = [UIColor purpleColor];
    }
    self.tempCommentVArr = [temp copy];
    self.tempNameArr = [tempName copy];
}
-(void)setCommentArr:(NSArray *)commentArr{
    _commentArr = commentArr;
    CGFloat sumWidth =   [UIScreen mainScreen].bounds.size.width - 50 * 2;
//    CGFloat sumHeight = 0;
    [_commentArr enumerateObjectsUsingBlock:^(CommentModel * model, NSUInteger idx, BOOL * _Nonnull stop) {

        UILabel *contentLabel = _tempCommentVArr[idx];
        UILabel *nameLabel = _tempNameArr[idx];
        nameLabel.text = [model.isUser isEqualToString:@"0"] ? @"用户回复：": @"商户回复：";
        if ([model.content isNull]) {
            model.content = @"       ";
        }
        contentLabel.text = model.content;


        CGFloat width = autoScaleW(70);
        CGFloat contentWidth = sumWidth - width;
        CGFloat contentHeight = [model.content sizeWithFont:nameLabel.font constrainedToWidth:contentWidth].height;
        CGFloat space = 2;
        CGFloat margin = 5;
//        ZTLog(@"%lf", contentHeight);

        self.sd_layout
        .widthIs(sumWidth);

        nameLabel.frame = CGRectMake((contentHeight + space ) * idx + margin, 0, width, contentHeight);
        contentLabel.frame = CGRectMake(width, (contentHeight + space ) * idx + margin, contentWidth, contentHeight);
//        [nameLabel updateLayout];
//        contentLabel.sd_layout
//        .leftSpaceToView(nameLabel, 2)
//        .rightSpaceToView(self, 0)
//        .topSpaceToView(self, (contentHeight + space ) * idx + margin)
//        .heightIs(contentHeight);
//        [contentLabel updateLayout];

        if (_commentArr.count - 1 == idx) {
//            [self setupAutoHeightWithBottomView:contentLabel bottomMargin:margin];
//            self.fixedWidth = @()
//            [self updateLayout];
        }


    }];


}

@end
