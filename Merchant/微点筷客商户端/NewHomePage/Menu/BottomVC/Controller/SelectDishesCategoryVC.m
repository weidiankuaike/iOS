//
//  SelectDishesCategoryVC.m
//  merchantClient
//
//  Created by Skyer God on 2017/7/27.
//  Copyright © 2017年 张甜. All rights reserved.
//

#import "SelectDishesCategoryVC.h"

@interface SelectDishesCategoryVC ()<UIGestureRecognizerDelegate, UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UIView *backScrollV;
@property (nonatomic, strong) UITableView *tableV;
@end

@implementation SelectDishesCategoryVC
{
    UITextField *alertTextField;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = RGBA(0, 0, 0, 0.3);
    [self createCategoryAlertView:_textField];
}
- (void)createCategoryAlertView:(UITextField *)textField{


        _backScrollV = [[UIView alloc] init];
        _backScrollV.backgroundColor = RGBA(0, 0, 0, 0.4);
        [self.view addSubview:_backScrollV];
        UITapGestureRecognizer *tapGR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(backScrollVClick:)];
        tapGR.delegate = self;
        [_backScrollV addGestureRecognizer:tapGR];
        _backScrollV.sd_layout
        .leftEqualToView(self.view)
        .topSpaceToView(self.view, 64)
        .rightEqualToView(self.view)
        .bottomSpaceToView(self.view, 0);

        alertTextField = [[UITextField alloc] init];
        alertTextField.placeholder = @"请编辑菜品分类";
        alertTextField.backgroundColor = [UIColor whiteColor];
        [alertTextField setValue:[UIFont fontWithName:@"Arial" size:autoScaleW(12)] forKeyPath:@"_placeholderLabel.font"];
        alertTextField.autocorrectionType = UITextAutocorrectionTypeNo;
        alertTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        alertTextField.returnKeyType = UIReturnKeyDone;
        alertTextField.delegate = self;
        alertTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
        alertTextField.textAlignment = NSTextAlignmentCenter;
        [_backScrollV addSubview:alertTextField];

        [alertTextField becomeFirstResponder];


        UILabel *topSeparator = [[UILabel alloc] init];
        topSeparator.backgroundColor = [UIColor lightGrayColor];
        [_backScrollV addSubview:topSeparator];

        UILabel *hasCatrgoryLabel = [[UILabel alloc] init];
        hasCatrgoryLabel.textColor = RGBA(0, 0, 0, 0.5);
        hasCatrgoryLabel.font = [UIFont systemFontOfSize:15];
        hasCatrgoryLabel.text = @"   已有品类";
        hasCatrgoryLabel.backgroundColor = [UIColor whiteColor];
        [_backScrollV addSubview:hasCatrgoryLabel];

        UILabel *separatorLine = [[UILabel alloc] init];
        separatorLine.backgroundColor = topSeparator.backgroundColor;
        [_backScrollV addSubview:separatorLine];


        _tableV = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableV.delegate = self;
        _tableV.dataSource = self;
        _tableV.backgroundColor = [UIColor whiteColor];
        [_backScrollV addSubview:_tableV];

        [_tableV registerClass:[UITableViewCell class] forCellReuseIdentifier:NSStringFromClass([UITableViewCell class])];

        alertTextField.sd_layout
        .leftSpaceToView(_backScrollV, 10)
        .topSpaceToView(_backScrollV, 10)
        .rightSpaceToView(_backScrollV, 10)
        .heightIs(45);

        alertTextField.sd_cornerRadiusFromHeightRatio = @(0.1);



        topSeparator.sd_layout
        .leftEqualToView(alertTextField)
        .rightEqualToView(alertTextField)
        .topSpaceToView(alertTextField, 0)
        .heightIs(3);



        hasCatrgoryLabel.sd_layout
        .leftEqualToView(alertTextField)
        .topSpaceToView(topSeparator, 0)
        .heightIs(30)
        .rightEqualToView(alertTextField);

        hasCatrgoryLabel.sd_cornerRadiusFromHeightRatio = @(0.1);

        separatorLine.sd_layout
        .leftEqualToView(topSeparator)
        .rightEqualToView(topSeparator)
        .topSpaceToView(hasCatrgoryLabel, 0)
        .heightIs(1);

        _tableV.sd_layout
        .leftEqualToView(alertTextField)
        .topSpaceToView(separatorLine, 0)
        .rightEqualToView(alertTextField)
        .heightIs(autoScaleH(100));

        _tableV.sd_cornerRadiusFromHeightRatio = @(0.05);


        _backScrollV.layer.borderColor = [UIColor lightGrayColor].CGColor;
        _backScrollV.layer.borderWidth = 0.8;
        _backScrollV.hidden = NO;

        alertTextField.text = textField.text;
}
-(void)textFieldDidEndEditing:(UITextField *)textField{


    if (textField == alertTextField) {

        alertTextField.textAlignment = NSTextAlignmentCenter;
//        [_saveInfoDic setObject:alertTextField.text forKey:@"cname"];
        if (![_getKeyArray containsObject:textField.text] && ![textField.text isNull]) {
            [_getKeyArray addObject:textField.text];
        }
        [self closeShowCategory];
    }
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self closeShowCategory];
    return YES;
}
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer{
    CGPoint point = [gestureRecognizer locationInView:_backScrollV];

    if (gestureRecognizer == [_backScrollV.gestureRecognizers lastObject] && CGRectContainsPoint(_tableV.frame, point)) {
        return NO;
    }

    return YES;
}
- (void)backScrollVClick:(UITapGestureRecognizer *)tapGR{
    CGPoint point = [tapGR locationInView:_backScrollV];
    if (!CGRectContainsPoint(_tableV.frame, point) && !CGRectContainsPoint(alertTextField.frame, point)) {
        [self closeShowCategory];
    }
}
- (void)closeShowCategory{
    if (![alertTextField.text isNull] && _dismissBlock) {
//        [_getKeyArray addObject:alertTextField.text];
        _dismissBlock(alertTextField.text);
    }

    [self dismissViewControllerAnimated:YES completion:^{

    }];
//    [alertTextField resignFirstResponder];
//    [UIView animateWithDuration:.35 animations:^{
//
//        while (_backScrollV.subviews.count) {
//            [_backScrollV.subviews.lastObject removeFromSuperview];
//        }
//        [_backScrollV removeFromSuperview];
//        _backScrollV = nil;
//    }];
}

#pragma mark ---  菜品分类展示框 ---

#pragma mark -- tableV delegate ---
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _getKeyArray.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 35;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([UITableViewCell class])];
    cell.textLabel.text = _getKeyArray[indexPath.row];
    cell.textLabel.textColor = [UIColor lightGrayColor];
    cell.textLabel.font = [UIFont systemFontOfSize:12];
    cell.selectionStyle = 0;

    return  cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *selectedCellStr = [_tableV cellForRowAtIndexPath:indexPath].textLabel.text;
    alertTextField.text = selectedCellStr;
    _textField.text = selectedCellStr;
    [self closeShowCategory];
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
