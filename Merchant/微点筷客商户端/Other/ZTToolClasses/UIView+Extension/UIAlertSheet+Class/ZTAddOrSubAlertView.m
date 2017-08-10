//
//  ZTAddOrSubAlertView.m
//  微点筷客商户端
//
//  Created by Skyer God on 16/11/14.
//  Copyright © 2016年 张森森. All rights reserved.
//

#import "ZTAddOrSubAlertView.h"
#define ZTMainScreen [UIScreen mainScreen].bounds
//RGB颜色
#define RGBA(r, g, b, a)                    [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:a]

#define RGB(r, g, b)                        RGBA(r, g, b, 1.0f)

#define UIColorFromRGBA(rgbValue, a) [UIColor colorWithRed:((CGFloat)((rgbValue & 0xFF0000) >> 16))/255.0 green:((CGFloat)((rgbValue & 0xFF00) >> 8))/255.0 blue:((CGFloat)(rgbValue & 0xFF))/255.0 alpha:a]

#define originTag 10000

@interface ZTAddOrSubAlertView ()<UITextFieldDelegate>

@end
@implementation ZTAddOrSubAlertView

{

    UIView *maskView;
    ButtonStyle *_leftArrowBT;
    ButtonStyle *_rightArrowBT;
}
-(UILabel *)littleLabel{
    if (!_littleLabel) {
        //可选择显示，替换1
        _littleLabel = [[UILabel alloc] init];
        _littleLabel.text = @"菜品将下架，可在菜品管理中操作重新上架。";
        _littleLabel.textAlignment = NSTextAlignmentCenter;
        _littleLabel.font = [UIFont systemFontOfSize:13];
        _littleLabel.textColor = [UIColor redColor];
        _littleLabel.numberOfLines = 0;
        _littleLabel.adjustsFontSizeToFitWidth = YES;


        [self addSubview:_littleLabel];
    }
    return _littleLabel;
}
-(UIView *)addSubView{
    if (!_addSubView) {
        //可选择显示，替换1
        _addSubView = [[UIView alloc] init];
        _addSubView.backgroundColor = [UIColor whiteColor];
        [self addSubview:_addSubView];

        _leftArrowBT = [ButtonStyle buttonWithType:UIButtonTypeCustom];
        [_leftArrowBT setImage:[UIImage imageNamed:@"左右三角-拷贝"] forState:UIControlStateNormal];
        [_leftArrowBT addTarget:self action:@selector(leftArrowBTActiton:) forControlEvents:UIControlEventTouchUpInside];
        [_addSubView addSubview:_leftArrowBT];

        _numLabel = [[UILabel alloc] init];
        _numLabel.text = @"2份";
        _numLabel.font= [ UIFont systemFontOfSize:20];
        _numLabel.textAlignment = NSTextAlignmentCenter;
        [_addSubView addSubview:_numLabel];

        _rightArrowBT = [ButtonStyle buttonWithType:UIButtonTypeCustom];
        [_rightArrowBT setImage:[UIImage imageNamed:@"左右三角"] forState:UIControlStateNormal];
        [_rightArrowBT addTarget:self action:@selector(rightArrowBTActiton:) forControlEvents:UIControlEventTouchUpInside];
        [_addSubView addSubview:_rightArrowBT];

        _addSubViewBottoLabel = [[UILabel alloc] init];
        _addSubViewBottoLabel.text = @"菜品会同时下架，在菜品管理页面操作重新上架。";
        _addSubViewBottoLabel.numberOfLines = 0;
        _addSubViewBottoLabel.font = [UIFont systemFontOfSize:13];
        _addSubViewBottoLabel.textAlignment = NSTextAlignmentCenter;
        _addSubViewBottoLabel.textColor = [[UIColor blackColor] colorWithAlphaComponent:0.4];
        [self addSubview:_addSubViewBottoLabel];


    }
    return  _addSubView;
}
-(UITextField *)textFild{
    if (!_textFild) {
        _textFild = [[UITextField alloc] init];
        _textFild.backgroundColor = [UIColor whiteColor];

        _textFild.placeholder = @"请输入您要添加的服务";
        [_textFild setValue:[UIFont fontWithName:@"Arial" size:autoScaleW(12)] forKeyPath:@"_placeholderLabel.font"];
        _textFild.autocorrectionType = UITextAutocorrectionTypeNo;
        _textFild.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        _textFild.returnKeyType = UIReturnKeyDone;
        _textFild.delegate = self;
        _textFild.clearButtonMode = UITextFieldViewModeWhileEditing;
        _textFild.textAlignment = NSTextAlignmentCenter;
        [maskView addSubview:_textFild];
    }
    return _textFild;
}

- (instancetype)initWithStyle:(ZTalertSheetStyle)style{
    self = [super init];
    if (self) {
        _shouldHiddenMaskView = YES;
        maskView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
        [maskView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(maskTapClick:)]];
        maskView.backgroundColor = RGBA(0, 0, 0, 0.3);
        [[UIApplication sharedApplication].keyWindow addSubview:maskView];

        self.backgroundColor = [UIColor whiteColor];
        [maskView addSubview:self];


        if (ZTalertSheetStyleTextFiled == style) {

            self.textFild.backgroundColor = [UIColor whiteColor];
            maskView.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
            self.textFild.sd_layout
            .leftSpaceToView(maskView, autoScaleW(12))
            .rightSpaceToView(maskView, autoScaleW(12))
            .topSpaceToView(maskView,  autoScaleH(64 + 6))
            .heightIs(autoScaleH(45));

            self.textFild.sd_cornerRadiusFromHeightRatio = @(0.1);
            [self.textFild becomeFirstResponder];


        } else if (ZTalertSheetStyleSingleSelectList == style) {
//        case ZTalertSheetStyleSingleSelectList:
            [self showAlertViewWithSubView];

        } else {

            _titleLabel = [[UILabel alloc] init];
            _titleLabel.text = @"确定要登记该菜品缺货？";
            _titleLabel.textAlignment = NSTextAlignmentCenter;
            _titleLabel.font = [UIFont systemFontOfSize:14];
            [self addSubview:_titleLabel];



            UILabel *separatorLine = [[UILabel alloc]init];
            separatorLine.backgroundColor = [UIColor lightGrayColor];
            [self addSubview:separatorLine];

            UILabel *midSeparator = [[UILabel alloc] init];
            midSeparator.backgroundColor = [UIColor lightGrayColor];
            [self addSubview:midSeparator];

            _cancelBT = [ButtonStyle buttonWithType:UIButtonTypeCustom];
            [_cancelBT setTitle:@"取消" forState:UIControlStateNormal];
            [_cancelBT setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
            [_cancelBT addTarget:self action:@selector(cancelAction) forControlEvents:UIControlEventTouchUpInside];
            [_cancelBT.titleLabel setFont:[UIFont systemFontOfSize:14]];
            [self addSubview:_cancelBT];

            _confirmBT = [ButtonStyle buttonWithType:UIButtonTypeCustom];
            [_confirmBT setTitle:@"确定" forState:UIControlStateNormal];
            [_confirmBT setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [_confirmBT addTarget:self action:@selector(confirmAction) forControlEvents:UIControlEventTouchUpInside];
            [_confirmBT.titleLabel setFont:[UIFont systemFontOfSize:14]];
            [self addSubview:_confirmBT];




            self.sd_layout
            .centerXEqualToView(maskView)
            .centerYEqualToView(maskView)
            .widthRatioToView(maskView, 0.65);

            [self setSd_cornerRadiusFromHeightRatio:@(0.05)];

            _titleLabel.sd_layout
            .leftEqualToView(self)
            .rightEqualToView(self)
            .topSpaceToView(self, autoScaleH(7))
            .heightIs(autoScaleH(40));

            switch (style) {
                case ZTalertSheetStyleTitle:
                    self.littleLabel.backgroundColor = [UIColor whiteColor];
                    separatorLine.sd_layout
                    .leftEqualToView(self)
                    .rightEqualToView(self)
                    .topSpaceToView(_titleLabel, 8)
                    .heightIs(0.8);
                    break;
                case ZTalertSheetStyleSubTitle:
                    self.littleLabel.backgroundColor = [UIColor whiteColor];
                    _littleLabel.sd_layout
                    .topSpaceToView(_titleLabel, 0)
                    .centerXEqualToView(self)
                    .widthIs(maskView.size.width * 0.55)
                    .minHeightIs(autoScaleH(45))
                    .maxHeightIs(autoScaleH(70));

                    separatorLine.sd_layout
                    .leftEqualToView(self)
                    .rightEqualToView(self)
                    .topSpaceToView(_littleLabel, autoScaleH(5))
                    .heightIs(0.8);

                    break;
                case ZTalertSheetStyleAddSubSelectTitle:
                    self.addSubView.backgroundColor = [UIColor whiteColor];
                    _addSubView.sd_layout
                    .leftEqualToView(_titleLabel)
                    .topSpaceToView(_titleLabel, 0)
                    .rightEqualToView(_titleLabel)
                    .heightIs(autoScaleH(50));

                    _numLabel.sd_layout
                    .centerXEqualToView(_addSubView)
                    .centerYEqualToView(_addSubView)
                    .heightIs(autoScaleH(40));
                    [_numLabel setSingleLineAutoResizeWithMaxWidth:autoScaleW(100)];

                    _leftArrowBT.sd_layout
                    .rightSpaceToView(_numLabel, autoScaleW(10))
                    .centerYEqualToView(_numLabel)
                    .widthIs(_leftArrowBT.currentImage.size.width * 2.5
                             )
                    .heightIs(_leftArrowBT.currentImage.size.height * 2.5);

                    _rightArrowBT.sd_layout
                    .leftSpaceToView(_numLabel, autoScaleW(10))
                    .centerYEqualToView(_numLabel)
                    .widthIs(_rightArrowBT.currentImage.size.width * 2.5)
                    .heightIs(_rightArrowBT.currentImage.size.height * 2.5);

                    _addSubViewBottoLabel.sd_layout
                    .leftSpaceToView(self, autoScaleW(20))
                    .rightSpaceToView(self, autoScaleW(20))
                    .topSpaceToView(_addSubView, 0)
                    .heightIs(autoScaleH(40));

                    separatorLine.sd_layout
                    .leftEqualToView(self)
                    .rightEqualToView(self)
                    .topSpaceToView(_addSubViewBottoLabel, 0)
                    .heightIs(0.8);

                    break;

                default:
                    break;
            }
            if (ZTalertSheetStyleTextFiled == style) {

            }{
                midSeparator.sd_layout
                .centerXEqualToView(self)
                .topSpaceToView(separatorLine, 0)
                .widthIs(0.8)
                .heightIs(autoScaleH(40));

                _cancelBT.sd_layout
                .leftEqualToView(self)
                .topEqualToView(midSeparator)
                .rightSpaceToView(midSeparator, 0)
                .bottomEqualToView(midSeparator);

                _confirmBT.sd_layout
                .leftSpaceToView(midSeparator, 0)
                .topEqualToView(_cancelBT)
                .rightEqualToView(self)
                .bottomEqualToView(_cancelBT);

                [self setupAutoHeightWithBottomViewsArray:@[_cancelBT, midSeparator] bottomMargin:0];
            }

            UILabel *topSeparatorLine = [[UILabel alloc] init];
            topSeparatorLine.backgroundColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.3];
            [self addSubview:topSeparatorLine];

            topSeparatorLine.sd_layout
            .leftSpaceToView(self, 20)
            .rightSpaceToView(self, 20)
            .topSpaceToView(_titleLabel, 0)
            .heightIs(0.6);
        }

    }

    return self;
}


- (void)leftArrowBTActiton:(ButtonStyle *)sender{

    NSArray *compontArr = [_numLabel.text componentsSeparatedByString:@"份"];
    NSInteger count = [[compontArr firstObject] integerValue];
    count --;
    if (count <=1) {
        count = 1;
        sender.hidden = YES;
    } else {
        sender.hidden = NO;
    }
    if (self.plus) {
        self.plus(count);

    }
}
- (void)rightArrowBTActiton:(ButtonStyle *)sender{

    NSArray *compontArr = [_numLabel.text componentsSeparatedByString:@"份"];
    NSInteger count = [[compontArr firstObject] integerValue];

    count ++;
    if (count > 1) {
        _leftArrowBT.hidden = NO;
    }
    if (self.plus) {
        self.plus(count);
    }
}


#pragma mark -- 基础处理 －－－轻易不动 －－!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!-------------!!!!!!!!!!!!!!!!!!!!!!!!!!
- (void)maskTapClick:(UITapGestureRecognizer *)tapGR{
    if (tapGR.state == UIGestureRecognizerStateEnded && _shouldHiddenMaskView) {
        CGPoint point = [tapGR locationInView:maskView];
        if (!CGRectContainsPoint(self.frame, point)) {
            [self dismiss];
        }
    }
}
- (void)showView{
    maskView.alpha = 0;
    [UIView animateWithDuration:.15 animations:^{
        maskView.alpha = 1;
        maskView.hidden = NO;
    }];

}
- (void)cancelAction{
    [self dismiss];
    if (_complete) {
        _complete(NO);
    }
}
- (void)dismiss{

    [UIView animateWithDuration:.15 animations:^{
        maskView.alpha = 0;
        maskView.hidden = YES;
        [maskView removeFromSuperview];
    }];
}
- (void)confirmAction{
    [self dismiss];
    if (_complete) {
        _complete(YES);
    }

}
#pragma mark -- uitextField delegate ----
- (void)textFieldDidEndEditing:(UITextField *)textField{

    [_textFild resignFirstResponder];

    if (_textInputEnd) {
        self.textInputEnd(textField.text);
    }
}
-(void)textFieldDidBeginEditing:(UITextField *)textField{
    textField.attributedText = [[NSAttributedString alloc] initWithString:textField.text attributes:[self handleTextWithStyle]];
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField{


    return [textField resignFirstResponder];
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
#pragma mark       /** 中间列表单选 **/
- (void)showAlertViewWithSubView{

    UIView *_midVoucherAlert = [[UIView alloc] init];
    _midVoucherAlert.backgroundColor = [UIColor whiteColor];
    [maskView addSubview:_midVoucherAlert];

    ButtonStyle *cancelBT = [ButtonStyle buttonWithType:UIButtonTypeCustom];
    [cancelBT setTitle:@"取消" forState:UIControlStateNormal];
    [cancelBT setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [cancelBT.titleLabel setFont:[UIFont systemFontOfSize:14]];
    [_midVoucherAlert addSubview:cancelBT];
    cancelBT.tag = 450;
    [cancelBT addTarget:self action:@selector(midCancelBTAction:) forControlEvents:UIControlEventTouchUpInside];

    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.text = @"请选择卡券类型";
    titleLabel.textColor = RGBA(0, 0, 0, 0.7);
    titleLabel.font = [UIFont systemFontOfSize:15];
    [_midVoucherAlert addSubview:titleLabel];

    _midVoucherAlert.sd_layout
    .centerYEqualToView(maskView)
    .centerXEqualToView(maskView)
    .widthRatioToView(maskView, 0.65);

    cancelBT.sd_layout
    .leftSpaceToView(_midVoucherAlert, autoScaleW(10))
    .topSpaceToView(_midVoucherAlert, autoScaleH(5));
    [cancelBT setupAutoSizeWithHorizontalPadding:0 buttonHeight:autoScaleH(40)];


    titleLabel.sd_layout
    .centerXEqualToView(_midVoucherAlert)
    .topSpaceToView(_midVoucherAlert, 4)
    .heightIs(40);
    [titleLabel setSingleLineAutoResizeWithMaxWidth:autoScaleW(120)];

    if (_singleListArr == nil) {
        NSArray *arr = @[@"满减优惠",@"折扣优惠"];
        _singleListArr = [NSMutableArray arrayWithArray:arr];
    }

    for (NSInteger i = 0; i < _singleListArr.count; i++) {
        UILabel *separatorLine = [[UILabel alloc] init];
        separatorLine.backgroundColor = RGB(238, 238, 238);
        [_midVoucherAlert addSubview:separatorLine];

        ButtonStyle *button = [ButtonStyle buttonWithType:UIButtonTypeCustom];
        [button setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        [button setTitle:_singleListArr[i] forState:UIControlStateNormal];
        [button.titleLabel setFont:[UIFont systemFontOfSize:15]];
        [_midVoucherAlert addSubview:button];

        [button addTarget:self action:@selector(midButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        button.tag = originTag * ZTalertSheetStyleSingleSelectList + i;

        separatorLine.sd_layout
        .leftEqualToView(_midVoucherAlert)
        .topSpaceToView(titleLabel, autoScaleH(4) + (0.8 + autoScaleH(45)) * i)
        .rightEqualToView(_midVoucherAlert)
        .heightIs(0.8);

        button.sd_layout
        .leftEqualToView(_midVoucherAlert)
        .rightEqualToView(_midVoucherAlert)
        .topSpaceToView(separatorLine, 0 )
        .heightIs(autoScaleH(45));
        [_midVoucherAlert setupAutoHeightWithBottomView:button bottomMargin:0];
    }
    
    [maskView addSubview:_midVoucherAlert];
    
    _midVoucherAlert.transform = CGAffineTransformMakeScale(0.2, 0.2);
    [UIView animateWithDuration:.35 animations:^{
        _midVoucherAlert.transform = CGAffineTransformMakeScale(1, 1);
    }];
    
}
-(void)setSingleListArr:(NSMutableArray *)singleListArr{
    _singleListArr = singleListArr;

    for (NSInteger i = 0; i < singleListArr.count; i++) {
        ButtonStyle *button = [self viewWithTag:originTag * ZTalertSheetStyleSingleSelectList + i];
        [button setTitle:singleListArr[i] forState:UIControlStateNormal];
    }
}
- (void)midCancelBTAction:(ButtonStyle *)sender{
    if (_singleSelectIndex) {
        self.singleSelectIndex(_singleListArr.count, nil);
    }
    [self dismiss];
}
- (void)midButtonAction:(ButtonStyle *)sender{
    if (_singleSelectIndex) {
        self.singleSelectIndex(sender.tag  - ZTalertSheetStyleSingleSelectList * originTag, sender.titleLabel.text);
//        ZTLog(@"%ld", sender.tag - ZTalertSheetStyleSingleSelectList * originTag);
    }

    [self dismiss];

}

@end
