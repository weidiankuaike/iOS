//
//  TextFieldViewController.m
//  微点筷客商户端
//
//  Created by Skyer God on 16/11/29.
//  Copyright © 2016年 张森森. All rights reserved.
//

#import "TextFieldViewController.h"

@interface TextFieldViewController ()<UITextFieldDelegate>

@end

@implementation TextFieldViewController
{
    ButtonStyle *saveBT;
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:YES];
    [_textFeild becomeFirstResponder];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.rightBarItem.hidden = YES;
    // Do any additional setup after loading the view.
    self.view.backgroundColor = RGB(238, 238, 238);

    [self initiwhtWindow];
}
- (void)initiwhtWindow{
    UIView *backView = [[UIView alloc] init];
    backView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:backView];

    _titleLabel = [[UILabel alloc] init];
    _titleLabel.text = @"消费满多少时可发放";
    _titleLabel.textColor = RGBA(0, 0, 0, 0.6);
    _titleLabel.font = [UIFont systemFontOfSize:15];
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    [backView addSubview:_titleLabel];

    _pointLabel = [[UILabel alloc] init];
    _pointLabel.text = @"¥";
    _pointLabel.font = [UIFont systemFontOfSize:25];
    _pointLabel.textAlignment = NSTextAlignmentCenter;
    [backView addSubview:_pointLabel];


    _textFeild = [[UITextField alloc] init];
    _textFeild.backgroundColor = [UIColor whiteColor];
    _textFeild.placeholder = @"30";
    [_textFeild setValue:[UIFont fontWithName:@"Arial" size:25] forKeyPath:@"_placeholderLabel.font"];
    _textFeild.autocorrectionType = UITextAutocorrectionTypeNo;
    _textFeild.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    _textFeild.returnKeyType = UIReturnKeyDone;
    _textFeild.delegate = self;
    _textFeild.clearButtonMode = UITextFieldViewModeWhileEditing;
    _textFeild.textAlignment = NSTextAlignmentCenter;
    _textFeild.font = [UIFont systemFontOfSize:25];
    _textFeild.keyboardType = UIKeyboardTypeDecimalPad;
    [backView addSubview:_textFeild];


    saveBT = [ButtonStyle buttonWithType:UIButtonTypeCustom];
    [saveBT setTitle:@"确定" forState:UIControlStateNormal];
    [saveBT setBackgroundColor:[UIColor grayColor]];
    [saveBT addTarget:self action:@selector(saveBTAction:) forControlEvents:UIControlEventTouchUpInside];
    saveBT.userInteractionEnabled = NO;
    [self.view addSubview:saveBT];

    backView.sd_layout
    .leftSpaceToView(self.view, 12)
    .rightSpaceToView(self.view, 12)
    .topSpaceToView(self.view, 64 + 12)
    .heightRatioToView(self.view, 0.4);

    backView.layer.borderWidth = 0.5;
    backView.layer.borderColor = RGBA(0, 0, 0, 0.3).CGColor;

    _titleLabel.sd_layout
    .topSpaceToView(backView, 15)
    .centerXEqualToView(backView)
    .heightIs(30);
    [_titleLabel setSingleLineAutoResizeWithMaxWidth:300];

    _pointLabel.sd_layout
    .leftSpaceToView(backView, 50)
    .topSpaceToView(_titleLabel, 50)
    .widthIs(40)
    .heightIs(40);

    _textFeild.sd_layout
    .centerYEqualToView(_pointLabel)
    .centerXEqualToView(backView)
    .widthIs(180)
    .heightIs(50);


    [backView setupAutoHeightWithBottomView:_textFeild bottomMargin:60];

    saveBT.sd_layout
    .leftEqualToView(backView)
    .rightEqualToView(backView)
    .topSpaceToView(backView, 25)
    .heightIs(45);




}
-(void)leftBarButtonItemAction{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)saveBTAction:(ButtonStyle *)sender{
    if (!_pushingViewController) {
        [self.navigationController popViewControllerAnimated:YES];
    } else {
//        [_pushingViewController.navigationController popViewControllerAnimated:YES];
    }
    if (_textDidFinish && ![_textFeild.text isNull] && [_textFeild.text integerValue] != 0) {
        self.textDidFinish(_textFeild.text);
    }

}
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    return [textField resignFirstResponder];
}
-(BOOL)textFieldShouldClear:(UITextField *)textField{

        saveBT.userInteractionEnabled = NO;
        [saveBT setBackgroundColor:[UIColor grayColor]];

    return YES;
}
- (void)textFieldDidBeginEditing:(UITextField *)textField{
    if ([textField hasText]) {
        saveBT.userInteractionEnabled = YES;
        [saveBT setBackgroundColor:UIColorFromRGB(0xfd7577)];
    } else {
        saveBT.userInteractionEnabled = NO;
        [saveBT setBackgroundColor:[UIColor grayColor]];
    }
    textField.attributedText = [[NSAttributedString alloc] initWithString:textField.text attributes:[self handleTextWithStyle]];
}
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if ([string isEqualToString:@""] && range.location == 0) {
        saveBT.userInteractionEnabled = NO;
        [saveBT setBackgroundColor:[UIColor grayColor]];
    } else {
        saveBT.userInteractionEnabled = YES;
        [saveBT setBackgroundColor:UIColorFromRGB(0xfd7577)];
    }
    return YES;
}

-(void)textFieldDidEndEditing:(UITextField *)textField{
    if ([textField hasText]) {
        saveBT.userInteractionEnabled = YES;
        [saveBT setBackgroundColor:UIColorFromRGB(0xfd7577)];
    } else {
        saveBT.userInteractionEnabled = NO;
        [saveBT setBackgroundColor:[UIColor grayColor]];
    }
//    if (_textDidFinish) {
//        self.textDidFinish(textField.text);
//    }
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
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
