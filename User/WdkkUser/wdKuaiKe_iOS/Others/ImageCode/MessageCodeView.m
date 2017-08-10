//
//  MessageCodeView.m
//  微点筷客商户端
//
//  Created by Skyer God on 2017/5/6.
//  Copyright © 2017年 张森森. All rights reserved.
//

#import "MessageCodeView.h"
#import <ImageIO/ImageIO.h>
#import "QYXNetTool.h"
#import "MBProgressHUD+SS.h"
@interface MessageCodeView ()<UITextFieldDelegate>

@end
@implementation MessageCodeView {
    UIView *maskView;
    UITextField *_textField;
    UIImageView *imageV;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self create];
    }
    return self;
}
- (void)create{

    maskView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    maskView.backgroundColor = RGBA(0, 0, 0, 0.3);
    [maskView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(maskViewTapClick:)]];
    [[UIApplication sharedApplication].keyWindow addSubview:maskView];
    [maskView addSubview:self];
    self.sd_layout
    .centerXEqualToView(maskView)
    .centerYEqualToView(maskView)
    .widthIs(autoScaleW(300))
    .heightIs(autoScaleH(260));

    UILabel *_titleLabel = [[UILabel alloc] init];
    _titleLabel.text = @"请输入验证码？";
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    _titleLabel.font = [UIFont systemFontOfSize:14];
    [self addSubview:_titleLabel];;

    _textField = [[UITextField alloc] init];
    [_textField setValue:[UIFont fontWithName:@"Arial" size:autoScaleW(12)] forKeyPath:@"_placeholderLabel.font"];
    _textField.placeholder = @"请输入图片验证码";
    _textField.clearButtonMode = UITextFieldViewModeWhileEditing;
    _textField.delegate = self;
    [self addSubview:_textField];

    _textField.layer.borderColor = [UIColor lightGrayColor].CGColor;
    _textField.layer.borderWidth = 1;

    imageV = [[UIImageView alloc] init];
    imageV.backgroundColor = [UIColor lightGrayColor];
    [self addSubview: imageV];
    UITapGestureRecognizer *tapIamgeV = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(refreshImageV)];
    [imageV addGestureRecognizer:tapIamgeV];
    imageV.userInteractionEnabled = YES;
    imageV.layer.borderWidth = _textField.layer.borderWidth;
    imageV.layer.borderColor = _textField.layer.borderColor;

    _titleLabel.sd_layout
    .centerXEqualToView(self)
    .topSpaceToView(self, 5)
    .heightIs(30);
    [_titleLabel setSingleLineAutoResizeWithMaxWidth:200];

    imageV.sd_layout
    .rightSpaceToView(self, 12)
    .topSpaceToView(_titleLabel, 20)
    .widthIs((200 / 80) * 40)
    .heightIs(40);

    _textField.sd_layout
    .rightSpaceToView(imageV, -imageV.layer.borderWidth)
    .centerYEqualToView(imageV)
    .heightRatioToView(imageV, 1)
    .leftSpaceToView(self, 15);

    _cancelBT = [UIButton buttonWithType:UIButtonTypeCustom];
    [_cancelBT setTitle:@"取消" forState:UIControlStateNormal];
    [_cancelBT setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [_cancelBT addTarget:self action:@selector(cancelAction) forControlEvents:UIControlEventTouchUpInside];
    [_cancelBT.titleLabel setFont:[UIFont systemFontOfSize:14]];
    [self addSubview:_cancelBT];
  
    _confirmBT = [UIButton buttonWithType:UIButtonTypeCustom];
    [_confirmBT setTitle:@"确定" forState:UIControlStateNormal];
    [_confirmBT setBackgroundColor:UIColorFromRGB(0xfd7d77)];
    [_confirmBT addTarget:self action:@selector(confirmAction) forControlEvents:UIControlEventTouchUpInside];
    [_confirmBT.titleLabel setFont:[UIFont systemFontOfSize:14]];
    [self addSubview:_confirmBT];

    _confirmBT.sd_layout
    .leftSpaceToView(self, 0)
    .topSpaceToView(_textField, 20)
    .widthIs(self.width_sd / 2)
    .heightIs(40);

    _cancelBT.sd_layout
    .rightSpaceToView(self, 0)
    .topEqualToView(_confirmBT)
    .widthRatioToView(_confirmBT, 1)
    .heightRatioToView(_confirmBT, 1);

    [self setupAutoHeightWithBottomView:_cancelBT bottomMargin:0];
    [self refreshImageV];


    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.colors = @[(__bridge id)RGB(238, 238, 238).CGColor, (__bridge id)RGB(238, 238, 238).CGColor, (__bridge id)RGB(238, 238, 238).CGColor];
    gradientLayer.locations = @[@0.3, @0.5, @1.0];
    gradientLayer.startPoint = CGPointMake(0, 0);
    gradientLayer.endPoint = CGPointMake(1.0, 0);
    gradientLayer.frame = CGRectMake(0, 0, self.width_sd / 2, 1);
    [_cancelBT.layer addSublayer:gradientLayer];

}
- (void)refreshImageV{
     NSString *url = [NSString stringWithFormat:@"%@/common/validateCodeMethod", isLocationConnect ? LocaltionURL : commonUrl];
    [[QYXNetTool shareManager] getNetWithUrl:url urlBody:nil header:nil response:QYXDATA success:^(id result) {

        CGImageSourceRef _incrementallyImgSource = CGImageSourceCreateIncremental(NULL);
        CGImageSourceUpdateData(_incrementallyImgSource, (CFDataRef)result, YES);
        CGImageRef imageRef = CGImageSourceCreateImageAtIndex(_incrementallyImgSource, 0, NULL);

        UIImage *image = [UIImage imageWithData:result];
        image = [UIImage imageWithCGImage:imageRef];
        CGImageRelease(imageRef);
        dispatch_async(dispatch_get_main_queue(), ^{
            imageV.image = image;
        });
    } failure:^(NSError *error) {

    }];
}

#pragma mark  textfield delegate 
- (void)textFieldDidBeginEditing:(UITextField *)textField{
    _textField.attributedText = [[NSAttributedString alloc] initWithString:textField.text attributes:[self handleTextWithStyle]];
}
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{

    if (range.location > 3) {
        return NO;
    }
    _textField.attributedText = [[NSAttributedString alloc] initWithString:textField.text attributes:[self handleTextWithStyle]];
    return YES;
}
- (NSDictionary *)handleTextWithStyle{
    //首行缩进
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = 3;    //行间距
    paragraphStyle.firstLineHeadIndent = 8;    /**首行缩进宽度*/
    paragraphStyle.alignment = NSTextAlignmentJustified;
    NSDictionary *attributes = @{
                                 NSFontAttributeName:[UIFont systemFontOfSize:13],
                                 NSParagraphStyleAttributeName:paragraphStyle
                                 };
    return attributes;
}
- (void)confirmAction{
    if ([_textField.text isNull] || [_textField.text isEqualToString:@""]) {
        [MBProgressHUD showError:@"请输入图片验证码"];
    } else {
        [self dismiss];
        if (_complete) {
            self.complete(_textField.text);
        }
    }
}
- (void)cancelAction{
    [self dismiss];
}
- (void)dismiss{
    [maskView removeFromSuperview];
    [UIView animateWithDuration:.35 animations:^{
        maskView.alpha = 0;
        maskView.hidden = YES;
    }];
}
- (void)showView{
    maskView.alpha = 0;
    self.transform = CGAffineTransformMakeScale(0.2, 0.2);
    [UIView animateWithDuration:.35 animations:^{
        maskView.alpha = 1;
        maskView.hidden = NO;
        self.transform = CGAffineTransformMakeScale(1, 1);
    }];
}
- (void)maskViewTapClick:(UITapGestureRecognizer *)tapGR{
    [self dismiss];
}
@end
