//
//  InnerKitchenCell.m
//  微点筷客商户端
//
//  Created by Skyer God on 16/11/9.
//  Copyright © 2016年 张森森. All rights reserved.
//

#import "InnerKitchenCell.h"
#import "NSObject+JudgeNull.h"
static CGFloat cellHeight = 0;

@interface InnerKitchenCell ()<UIGestureRecognizerDelegate>

@end
@implementation InnerKitchenCell
+(CGFloat)cellHeight{
    return cellHeight;
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (UIImageView *)imageV{
    if (!_imageV) {
        _imageV = [[UIImageView alloc] init];
        _imageV.image = [UIImage imageNamed:@"loadingIcon"];
        [self.contentView addSubview:_imageV];

        _imageV.sd_layout
        .leftSpaceToView(self.contentView, 35)
        .centerYEqualToView(self.contentView)
        .widthIs(50)
        .heightEqualToWidth(0);
    }
    return _imageV;
}
-(UILabel *)nameLabel{
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.text = @"13号桌";
        _nameLabel.font = [UIFont systemFontOfSize:13];
        [self.contentView addSubview:_nameLabel];

        _nameLabel.sd_layout
        .leftSpaceToView(self.imageV, 15)
        .centerYEqualToView(self.imageV)
        .heightIs(20);
        [_nameLabel setSingleLineAutoResizeWithMaxWidth:200];
    }
    return _nameLabel;
}
- (UILabel *)numLabel{
    if (!_numLabel) {
        _numLabel = [[UILabel alloc] init];
        _numLabel.text = @"XXXX";
        _numLabel.font = [UIFont systemFontOfSize:13];
        [self.contentView addSubview:_numLabel];

        _numLabel.sd_layout
        .centerYEqualToView(self.contentView)
        .centerXIs(self.contentView.centerX + 60)
        .heightIs(20);
        [_numLabel setSingleLineAutoResizeWithMaxWidth:100];
    }
    return _numLabel;
}
- (UILabel *)promptLabel{
    if (!_promptLabel) {
        _promptLabel = [[UILabel alloc] init];
        _promptLabel.text = @"右滑上菜";
        _promptLabel.textColor = [UIColor lightGrayColor];
        _promptLabel.font = [UIFont systemFontOfSize:13];
        [self.contentView addSubview:_promptLabel];

        _promptLabel.sd_layout
        .centerYEqualToView(self.contentView)
        .centerXIs(self.contentView.center.x * 3.5 / 2)
        .heightIs(20);
        [_promptLabel setSingleLineAutoResizeWithMaxWidth:100];
    }
    return _promptLabel;
}
- (UILabel *)deleteLineLabel{
    if (!_deleteLineLabel) {
        _deleteLineLabel = [[UILabel alloc] init];
        [self.contentView addSubview:_deleteLineLabel];

        _deleteLineLabel.sd_layout
        .leftSpaceToView(self.contentView, 20)
        .centerYEqualToView(self.contentView)
        .rightSpaceToView(self.contentView, 20)
        .heightIs(1.5);

        _deleteLineLabel.hidden = YES;
    }
    return _deleteLineLabel;

}
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {


        UIPanGestureRecognizer *swipRight = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(swipRightAction:)];
//        swipRight.direction = UISwipeGestureRecognizerDirectionRight;
        [self.contentView addGestureRecognizer:swipRight];
        swipRight.delegate = self;



        self.imageV.backgroundColor = [UIColor whiteColor];
        self.nameLabel.backgroundColor = [UIColor whiteColor];
        self.numLabel.backgroundColor = [UIColor whiteColor];
        self.promptLabel.backgroundColor = [UIColor whiteColor];
        self.deleteLineLabel.backgroundColor = UIColorFromRGB(0xfd7577);

    }
    return self;
}
- (void)swipRightAction:(UIPanGestureRecognizer *)swipRight{
    CGPoint point = [swipRight translationInView:self.contentView];
    CGFloat limitDistance = [UIScreen mainScreen].bounds.size.width * 1.3 / 4.0;
    if (swipRight.state == UIGestureRecognizerStateEnded && point.x > limitDistance && _deleteLineLabel.hidden == YES) {
        if (_swipRightComplete) {
            self.swipRightComplete(YES);
        }
    } else if (swipRight.state == UIGestureRecognizerStateEnded && point.x < -limitDistance){
        if (_swipRightComplete) {
        self.swipRightComplete(NO);
        }
    }
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer{
    return YES;
}
- (void)setModel:(InnerKitchenModel *)model{

    NSString *url = [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:model.images]] ? model.images : [model.images stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [_imageV sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:[UIImage imageNamed:@"loadingIcon"]];
    if (!_isDeskSearch) {
        _nameLabel.text = [NSString stringWithFormat:@"%@号桌", model.boardNum];
    } else {
        _nameLabel.text = model.productName;
    }
    if (model.isServed) {
        _numLabel.text = [NSString stringWithFormat:@"x %@", model.unserved];
        _deleteLineLabel.hidden = YES;
    } else {
        _numLabel.text = [NSString stringWithFormat:@"x %@", model.served];
        _deleteLineLabel.hidden = NO;
    }

    cellHeight = 0;
    _model = model;

    CGFloat height = 30;

    height = height >20?height:20;

    cellHeight =  height + 5;

    _model.height = cellHeight;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
