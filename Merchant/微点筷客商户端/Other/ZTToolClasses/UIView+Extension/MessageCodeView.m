//
//  MessageCodeView.m
//  微点筷客商户端
//
//  Created by Skyer God on 2017/5/6.
//  Copyright © 2017年 张森森. All rights reserved.
//

#import "MessageCodeView.h"
#import <ImageIO/ImageIO.h>

@interface MessageCodeView ()<UITextFieldDelegate>

@end
@implementation MessageCodeView {
    UIView *maskView;
    UITextField *_textField;
    UIImageView *imageV;
    BOOL isFinish;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (instancetype)initShouldVertifyPhoneNum:(BOOL)vertify phoneNumber:(NSString *)phoneNumber
{
    if (vertify) {
        if (![phoneNumber isMobileNumber]) {
            [SVProgressHUD showInfoWithStatus:@"请输入正确的手机号"];
            return nil;
        }
        @weakify(self);
        dispatch_group_t group = dispatch_group_create();
        dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        dispatch_group_async(group, queue, ^{
            dispatch_group_enter(group);
            [[QYXNetTool shareManager] postNetWithUrl:[NSString stringWithFormat:@"%@/merchantIsDatabase?phone=%@", kBaseURL, phoneNumber] urlBody:nil bodyStyle:QYXBodyString header:nil response:QYXJSON success:^(id result) {
                if ([result[@"msgType"] isEqualToString:@"0"]) {
                    isFinish = YES;
                } else {
                    [SVProgressHUD showInfoWithStatus:@"手机号不存在"];
                    isFinish = NO;
                }
                dispatch_group_leave(group);
            } failure:^(NSError *error) {
                isFinish = NO;
                dispatch_group_leave(group);
            }];
        });
        dispatch_group_notify(group, dispatch_get_main_queue(), ^{
            @strongify(self);
            if (isFinish) {
                self = [super init];
                if (self) {
                    self.backgroundColor = [UIColor whiteColor];
                    [self create];
                }
            } else {
                self = nil;
                [SVProgressHUD showInfoWithStatus:@"无此用户"];
                return;
            }
        });

    } else {
        self = [super init];
        if (self) {
            self.backgroundColor = [UIColor whiteColor];
            [self create];
        }

    }
        return self;
}
- (void)create{



    maskView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    maskView.backgroundColor = RGBA(0, 0, 0, 0.2);
    [maskView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(maskViewTapClick:)]];

    [[UIApplication sharedApplication].keyWindow addSubview:maskView];
    [maskView addSubview:self];
    self.sd_layout
    .centerXEqualToView(maskView)
    .centerYEqualToView(maskView)
    .widthIs(300)
    .heightIs(260);

    UILabel *_titleLabel = [[UILabel alloc] init];
    _titleLabel.text = @"请输入验证码？";
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    _titleLabel.font = [UIFont systemFontOfSize:14];
    [self addSubview:_titleLabel];;

    _textField = [[UITextField alloc] init];
    [_textField setValue:[UIFont fontWithName:@"Arial" size:autoScaleW(12)] forKeyPath:@"_placeholderLabel.font"];
    _textField.placeholder = @"  请输入图片验证码";
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

    _cancelBT = [ButtonStyle buttonWithType:UIButtonTypeCustom];
    [_cancelBT setTitle:@"取消" forState:UIControlStateNormal];
    [_cancelBT setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [_cancelBT addTarget:self action:@selector(cancelAction) forControlEvents:UIControlEventTouchUpInside];
    [_cancelBT.titleLabel setFont:[UIFont systemFontOfSize:14]];
    [self addSubview:_cancelBT];

    _confirmBT = [ButtonStyle buttonWithType:UIButtonTypeCustom];
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

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];

    //增加监听，当键退出时收出消息

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    [_textField becomeFirstResponder];

    //增加监听，当键盘出现或改变时收出消息
    [self updateLayout];

    

}
- (void)refreshImageV{
    NSString *url = [NSString stringWithFormat:@"%@common/validateCodeMethod", isLocationConnect ? LocaltionURL : kBaseURL];
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
    _confirmBT.selected =!_confirmBT.selected;
    if ([_textField.text isNull] || [_textField.text isEqualToString:@""]) {
        [SVProgressHUD showInfoWithStatus:@"请输入图片验证码"];
    } else {
        [self dismiss];
        if (_complete) {
            self.complete(_textField.text);
        }
    }
}
- (void)cancelAction{
    _confirmBT.selected = !_confirmBT.selected;
    [self dismiss];
}
- (void)dismiss{

    [UIView animateWithDuration:.35 animations:^{
        maskView.alpha = 0;
        maskView.hidden = YES;
        [maskView removeFromSuperview];
        maskView = nil;
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
    if (tapGR.state == UIGestureRecognizerStateEnded) {
        CGPoint point = [tapGR locationInView:maskView];
        if (!CGRectContainsPoint(self.frame, point)) {
            [self cancelAction];
        }
    }

}

//当键盘出现或改变时调用

- (void)keyboardWillShow:(NSNotification *)aNotification
{

    //获取键盘的高度

    NSDictionary *userInfo = [aNotification userInfo];
    NSValue *aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [aValue CGRectValue];
    int height = keyboardRect.size.height;

    [UIView animateWithDuration:.35 delay:.0 options:UIViewAnimationOptionLayoutSubviews animations:^{

    } completion:^(BOOL finished) {
        if (finished) {
            self.sd_layout.bottomSpaceToView(maskView, height);
            [self updateLayout];
        }
    }];
}
-(void)textFieldDidEndEditing:(UITextField *)textField reason:(UITextFieldDidEndEditingReason)reason{
    if (reason == UITextFieldDidEndEditingReasonCommitted && !_confirmBT.selected && !_confirmBT.selected) {
        [UIView animateWithDuration:.35 animations:^{
            self.center = maskView.center;
        }];
        if (_textField.text.length == 4 && ![_textField.text isNull] ) {
            [self confirmAction];
        }
    }
}

//当键退出时调用
- (void)keyboardWillHide:(NSNotification *)aNotification
{

}
@end
