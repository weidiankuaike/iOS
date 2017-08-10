//
//  DishesInfoSetVC.m
//  微点筷客商户端
//
//  Created by Skyer God on 16/10/18.
//  Copyright © 2016年 张森森. All rights reserved.
//

#import "DishesInfoSetVC.h"
#import "DishesChangeVC.h"
#import "DishesInfoModel.h"
//#import "TXYTImageTool.h"
#import "UIImageView+ImageCut_Compress.h"
#import "ZTAlertSheetView.h"
#import <IQKeyboardManager.h>
#import "QYXNetTool.h"
#import "DishesInfoModel.h"
#import <MJExtension/MJExtension.h>
#import "NSObject+JudgeNull.h"
#import <MJExtension/MJExtension.h>
#import "UIViewClassHandleTools.h"
#import "SelectDishesCategoryVC.h"
//#import "UITextField.h"
@interface DishesInfoSetVC ()<UITextFieldDelegate, UITextViewDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate>
/** 菜名   (strong) **/
@property (nonatomic, strong) UITextField *dishesNameTextField;
/** textView   (strong) **/
@property (nonatomic, strong) UITextView *textView;
/** textView 占位label   (strong) **/
@property (nonatomic, strong) UILabel *placeLabel;
/** 保存按钮   (strong) **/
@property (nonatomic, strong) ButtonStyle *saveButton;

/** 背景ScrollView   (strong) **/
@property (nonatomic, strong) UIScrollView *wholeScrollV;

@property (nonatomic, assign) CGFloat keyBoardHeight;
@end

@implementation DishesInfoSetVC
{
    UIImageView *headerImageV;
    UILabel *placeHolderL;
    UIImage *oldImage;
    MBProgressHUD *HudProgress;
}
- (void)viewDidLoad {
    [super viewDidLoad];

    // Do any additional setup after loading the view.
    _saveInfoDic = [NSMutableDictionary dictionary];
    self.view.backgroundColor = [UIColor whiteColor];
    self.titleView.text = @"菜品修改";
    [self initWithDishesInfoView];
    [self judgeWholeInfoComplete];
}

- (void)uploadNewDishesData:(NSString *)imgUrl{
    DishesInfoModel *newModel = [DishesInfoModel mj_objectWithKeyValues:_saveInfoDic];
    //入驻后，请求
    NSString *keyUrl = @"api/merchant/operationDishesMgmt";
    NSString *storeId = storeID;
    NSString *offFood = @"0";
    NSString *operation = @"0";
    
    NSString *categoryId = newModel.categoryId;
    NSString *pid = newModel.dishesID;

    if ([categoryId isNull] || categoryId == nil) {
        categoryId = @"";
    }
    if ([pid isNull] || pid == nil) {
        pid = @"";
    }
    if (!_model) {

    } else {
        categoryId = _model.categoryId;
        pid = _model.dishesID;
        operation = @"2";
        offFood = _model.downStair;
    }
    NSString *cname = newModel.category;
    NSString *name = newModel.dishesName;

    NSString *pfee = newModel.price;
    if (imgUrl == nil) {
        imgUrl = _model.img;
    }
    NSString *images = imgUrl;
    NSString *note = newModel.descrpt;
    NSString *token = TOKEN;
    NSString *urlUpload = [NSString stringWithFormat:@"%@%@?token=%@&storeId=%@&offFood=%@&operation=%@&cid=%@&pname=%@&pid=%@&fee=%@&images=%@&note=%@&cname=%@",kBaseURL, keyUrl, token, storeId,offFood, operation, categoryId, name, pid, pfee, images, note, cname];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];

    [[QYXNetTool shareManager] postNetWithUrl:urlUpload urlBody:nil bodyStyle:QYXBodyString header:nil response:QYXJSON success:^(id result) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if ([result[@"msgType"] integerValue] == 0) {
            if (self.dishesInfoDic != nil) {
                self.dishesInfoDic(_saveInfoDic);
                //            ZTLog(@"%@", _saveInfoDic);
            }
            [self.navigationController popViewControllerAnimated:YES];
        } else {
            [SVProgressHUD showErrorWithStatus:@"上传失败，内容不能包含特殊字符"];
        }

    } failure:^(NSError *error) {

    }];
}

#pragma mark -- 初始化界面 -----
- (void)initWithDishesInfoView{

    self.navigationController.navigationBar.hidden = NO;
    self.tabBarController.tabBar.hidden = YES;

    self.wholeScrollV = [[UIScrollView alloc] initWithFrame:self.view.frame];
    [self.view addSubview:_wholeScrollV];
    _wholeScrollV.backgroundColor = self.view.backgroundColor;
    _wholeScrollV.showsVerticalScrollIndicator = NO;
    _wholeScrollV.sd_layout.spaceToSuperView(UIEdgeInsetsZero);


    headerImageV = [[UIImageView alloc] init];

    UILongPressGestureRecognizer *longGR = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longGRAction:)];
    [headerImageV addGestureRecognizer:longGR];
    headerImageV.userInteractionEnabled = YES;
    [_wholeScrollV addSubview:headerImageV];

    placeHolderL = [[UILabel alloc] init];
    placeHolderL.text = @"长按图片可重新选择";
    placeHolderL.textColor = UIColorFromRGB(0xfd7577);
    placeHolderL.textAlignment = NSTextAlignmentCenter;
    placeHolderL.font = [UIFont systemFontOfSize:autoScaleW(15)];
    [headerImageV addSubview:placeHolderL];


    headerImageV.sd_layout
    .leftSpaceToView(_wholeScrollV, 12)
    .topSpaceToView(_wholeScrollV, 64 + 8)
    .rightSpaceToView(_wholeScrollV, 12)
    .heightRatioToView(self.view, 1/3.5);

    placeHolderL.sd_layout
    .centerXEqualToView(headerImageV)
    .centerYEqualToView(headerImageV)
    .heightIs(30);
    [placeHolderL setSingleLineAutoResizeWithMaxWidth:200];

    if (_image == nil) {
        NSString *url = [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:_model.img]] ? _model.img : [_model.img stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        [headerImageV sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:[UIImage imageNamed:@"loadingIcon"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        }];
        oldImage = headerImageV.image;
    } else {
        __block UIImage *image = _image;
        __weak typeof(headerImageV) weakImageV = headerImageV;
        headerImageV.didFinishAutoLayoutBlock = ^(CGRect rect){
            weakImageV.image = [weakImageV cutImage:image withTargetSize:rect.size];
        };
    }

    dispatch_async(dispatch_get_main_queue(), ^{
        placeHolderL.hidden = YES;
        UIImage *image = [UIViewClassHandleTools shotWithView:headerImageV scope:placeHolderL.frame];
        placeHolderL.hidden = NO;
        UIColor *color = [UIViewClassHandleTools mostColor:image scale:0.5];
//        headerImageV.image = [UIViewClassHandleTools shotWithView:headerImageV scope:placeHolderL.frame];
        placeHolderL.textColor = color;
        ZTLog(@"%@", color);
    });

    NSArray *placeholderArr = @[@" 名称（必填）", @" 价格（必填）", @" 品类（必填）", @" 菜品描述（选填）"];
    for (NSInteger i = 0; i < placeholderArr.count; i++) {
        //        CGFloat start_y = autoScaleH(20);
        CGFloat height = autoScaleH(50);

        NSMutableAttributedString *att = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@" %@", placeholderArr[i]]];
        [att addAttribute:NSForegroundColorAttributeName value:RGB(199, 199, 199) range:NSRangeFromString(att.string)];
        [att addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"Arial" size:autoScaleW(12)] range:NSRangeFromString(att.string)];

        if (i < placeholderArr.count - 1) {

            UITextField *dishesNameTextField = [[UITextField alloc] init];
            dishesNameTextField.backgroundColor = [UIColor whiteColor];

            dishesNameTextField.placeholder = placeholderArr[i];
            [dishesNameTextField setValue:[UIFont fontWithName:@"Arial" size:autoScaleW(12)] forKeyPath:@"_placeholderLabel.font"];
            dishesNameTextField.autocorrectionType = UITextAutocorrectionTypeNo;
            dishesNameTextField.returnKeyType = UIReturnKeyDefault;
            dishesNameTextField.tag = 1000 + i;
            dishesNameTextField.delegate = self;
            dishesNameTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
            [_wholeScrollV addSubview:dishesNameTextField];





            dishesNameTextField.sd_layout
            .leftEqualToView(headerImageV)
            .topSpaceToView(headerImageV,12 + (12 + height) * i)
            .rightEqualToView(headerImageV)
            .heightIs(height);
            dishesNameTextField.layer.borderWidth = 0.8;
            dishesNameTextField.layer.borderColor = [UIColor lightGrayColor].CGColor;
            [dishesNameTextField setSd_cornerRadiusFromHeightRatio:@(0.1)];
            if (i == 0) {
                dishesNameTextField.text = self.model.dishesName;
            } else if(i == 1) {
                dishesNameTextField.text = _model.price;
            } else {
                dishesNameTextField.text = _model.category;
                //                dishesNameTextField.delegate = nil;
                [dishesNameTextField addTarget:self action:@selector(createCategoryAlertView:) forControlEvents:UIControlEventTouchDown];

            }

            if (i == 1) {
                dishesNameTextField.keyboardType = UIKeyboardTypeDecimalPad;
            }
            //首行缩进
            dishesNameTextField.attributedText = [[NSAttributedString alloc] initWithString:dishesNameTextField.text attributes:[self handleTextWithStyle]];
        }   else  {
            _textView = [[UITextView alloc] initWithFrame:CGRectZero];
            _textView.backgroundColor = [UIColor whiteColor];
            _textView.delegate = self;//设置它的委托方法
            _textView.keyboardType = UIKeyboardTypeDefault;//键盘类型
            _textView.returnKeyType = UIReturnKeyDone;
            _textView.attributedText = [[NSAttributedString alloc] initWithString:_textView.text attributes:[self handleTextWithStyle]];
            _textView.scrollEnabled = YES;//是否可以拖动

            _textView.textAlignment = NSTextAlignmentLeft; //文本显示的位置默认为居左

            _textView.autoresizingMask = UIViewAutoresizingFlexibleHeight;//自适应高度

            _textView.dataDetectorTypes = UIDataDetectorTypeAll; //显示数据类型的连接模式（如电话号码、网址、地址等）
            _textView.editable = YES;        //是否允许编辑内容，默认为“YES”

            _textView.text = _model.descrpt;

            [_wholeScrollV addSubview:_textView];

            _textView.sd_layout
            .leftEqualToView(headerImageV)
            .topSpaceToView([self.view viewWithTag:1002], 12)
            .rightEqualToView(headerImageV)
            .heightIs(autoScaleH(120));
            _textView.layer.borderColor = [self.view viewWithTag:1002].layer.borderColor;
            _textView.layer.borderWidth = [self.view viewWithTag:1002].layer.borderWidth;
            [_textView setSd_cornerRadiusFromHeightRatio:@(0.075)];

            _placeLabel = [[UILabel alloc] init];
            _placeLabel.attributedText = att;
            _placeLabel.textColor = [UIColor lightGrayColor];
            _placeLabel.font = [UIFont systemFontOfSize:14];
            [_textView addSubview:_placeLabel];

            _placeLabel.sd_layout
            .leftSpaceToView(_textView, 0)
            .topSpaceToView(_textView, 3)
            .heightIs(20);
            [_placeLabel setSingleLineAutoResizeWithMaxWidth:300];

            if (_model.descrpt) {
                _placeLabel.hidden = YES;
            } else {

            }
            _saveButton = [ButtonStyle buttonWithType:UIButtonTypeCustom];
            [_saveButton setTitle:@"保存" forState:UIControlStateNormal];
            [_saveButton setBackgroundColor:RGB(100, 100, 100)];
            [_wholeScrollV addSubview:_saveButton];

            _saveButton.sd_layout
            .topSpaceToView(_textView, autoScaleH(50))
            .leftEqualToView(_textView)
            .rightEqualToView(_textView)
            .heightIs(autoScaleH(45));
            [_saveButton setSd_cornerRadiusFromHeightRatio:@(0.08)];

            [_wholeScrollV setupAutoContentSizeWithBottomView:_saveButton bottomMargin:autoScaleH(10)];
        }
    }
}

- (void)longGRAction:(UILongPressGestureRecognizer *)longGR{
    NSArray *arr = @[@"拍照",@"图库选取", @"取消"];
    if (longGR.state == UIGestureRecognizerStateBegan) {
        ZTAlertSheetView *alertView = [[ZTAlertSheetView alloc] initWithTitleArray:arr];
        [alertView showView];
        alertView.alertSheetReturn = ^(NSInteger count){
            if (count == 0) {
                //                NSLog(@"camera");
                [CameraManageTools openCamera:self];
            }
            if (count == 1) {
                //                NSLog(@"picture");
                [CameraManageTools openImagePickController:self];
            }
        };

    }
}
#pragma mark --- uipaickerViewController delegate   --------------
//当选择一张图片后进入这里
-(void)imagePickerController:(UIImagePickerController*)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    NSString *type = [info objectForKey:UIImagePickerControllerMediaType];

    //当选择的类型是图片
    if ([type isEqualToString:@"public.image"]) {
        //先把图片转成NSData
        //        UIImage* image = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
        UIImage *image = [info valueForKey:UIImagePickerControllerEditedImage];
        dispatch_async(dispatch_get_main_queue(), ^{
            headerImageV.image = [self OriginImage:image scaleToSize:headerImageV.size_sd];
        });
        image = [self OriginImage:image scaleToSize:CGSizeMake(450, 300)];
        NSData *data;
        if (image == nil) {
            data = UIImageJPEGRepresentation(image, 1);
        } else {
            data = UIImagePNGRepresentation(image);
        }
        //图片保存的路径
        //这里将图片放在沙盒的documents文件夹中
        NSString * DocumentsPath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];

        //文件管理器
        NSFileManager *fileManager = [NSFileManager defaultManager];

        //把刚刚图片转换的data对象拷贝至沙盒中 并保存为image.png
        /** 用日期作为图片名 **/
        NSString *imageName = [NSString stringWithFormat:@"/tian%@.png", [NSDate date]];
        [fileManager createDirectoryAtPath:DocumentsPath withIntermediateDirectories:YES attributes:nil error:nil];
        [fileManager createFileAtPath:[DocumentsPath stringByAppendingString:imageName] contents:data attributes:nil];

        //得到选择后沙盒中图片的完整路径
        _filePath = [[NSString alloc]initWithFormat:@"%@%@",DocumentsPath,  imageName];

        //拍照后跳转到菜品信息设置界面
        //        DishesInfoSetVC *dishesInfoVC = [[DishesInfoSetVC alloc] init];
        //        dishesInfoVC.image = image;
#pragma mark ---  选择图片并且点击完成后的回调设置 --------------------------------- Mark  mark  Mark -------------

        placeHolderL.hidden = NO;
        //关闭相册界面
        [picker dismissViewControllerAnimated:YES completion:nil];
    }
}
/**
 *  压缩图片
 *  image:将要压缩的图片   size：压缩后的尺寸
 */
-(UIImage*) OriginImage:(UIImage *)image scaleToSize:(CGSize)size
{
    // 下面方法，第一个参数表示区域大小。第二个参数表示是否是非透明的。如果需要显示半透明效果，需要传NO，否则传YES。第三个参数就是屏幕密度了
    UIGraphicsBeginImageContextWithOptions(size, NO, [UIScreen mainScreen].scale);

    [image drawInRect:CGRectMake(0, 0, size.width, size.height)];

    UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();

    UIGraphicsEndImageContext();

    return scaledImage;   //返回的就是已经改变的图片
}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    //    NSLog(@"您取消了选择图片");
    [picker dismissViewControllerAnimated:YES completion:nil];
}



- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
- (void)createCategoryAlertView:(UITextField *)textField{
    if (_getKeyArray.count == 0) {
        return;
    }
    SelectDishesCategoryVC *alertTextFieldVC = [[SelectDishesCategoryVC alloc] init];
    alertTextFieldVC.getKeyArray = _getKeyArray;
    alertTextFieldVC.textField = textField;
    alertTextFieldVC.dismissBlock = ^(NSString *text) {
        textField.text = text;

        if (![_getKeyArray containsObject:text]) {
            [_saveInfoDic setObject:textField.text forKey:@"cname"];
            [_getKeyArray addObject:text];
        }
        [self judgeWholeInfoComplete];
    };
    alertTextFieldVC.modalPresentationStyle = UIModalPresentationCustom;
    alertTextFieldVC.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [self presentViewController:alertTextFieldVC animated:YES completion:^{

    }];

}
#pragma mark -- textView or textfiled delegate ---
-(void)textViewDidBeginEditing:(UITextView *)textView{
    [self judgeWholeInfoComplete];
}
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    _placeLabel.hidden = YES;
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    return YES;
}
- (void)textViewDidEndEditing:(UITextView *)textView{
    //首行缩进

    textView.attributedText = [[NSAttributedString alloc] initWithString:textView.text attributes:[self handleTextWithStyle]];
    if ([textView.text length] == 0) {
        _placeLabel.hidden = NO;
    }
    [self judgeWholeInfoComplete];

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
-(void)saveClick:(dishesSetInfoDic)dishesInfoDic{
    self.dishesInfoDic = dishesInfoDic;
}
-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField{

    if (textField.tag == 1002 && textField.isFirstResponder) {
        if (_getKeyArray.count != 0) {
            [self createCategoryAlertView:textField];
        }
    }
    [self judgeWholeInfoComplete];
    return YES;
}
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{

        if (range.location > 5 && textField.tag == 1001) {
        [SVProgressHUD showInfoWithStatus:@"超出单价限额，请确认后重新输入"];
        return NO;
    }
    return YES;
}
-(void)textFieldDidEndEditing:(UITextField *)textField{

    textField.attributedText = [[NSAttributedString alloc] initWithString:textField.text attributes:[self handleTextWithStyle]];

    UITextField *textFieldOne = [self.view viewWithTag:1000];
    UITextField *textFieldTwo = [self.view viewWithTag:1001];
    UITextField *textFieldThree = [self.view viewWithTag:1002];

    if (textField == textFieldOne) {
        //处理所有重名异常
        if ([self.allDishesInfoDic.allValues containsObject:textFieldOne.text] || ([_model.allDishesIdDic.allValues containsObject:textField.text] && ![_model.dishesName isEqualToString:textField.text])) {
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"命名冲突" message:@"请尽量不要使用相同命名" preferredStyle:UIAlertControllerStyleAlert];
            [self presentViewController:alertController animated:YES completion:^{
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [self dismissViewControllerAnimated:YES completion:nil];
                    [textFieldOne becomeFirstResponder];
                });
            }];
        }
        [_saveInfoDic setObject:textField.text forKey:@"pname"];
    }
    if(textField == textFieldTwo) {
        [_saveInfoDic setObject:textField.text forKey:@"pfee"];
    }
    if (textField == textFieldThree) {
        [_saveInfoDic setObject:textField.text forKey:@"cname"];
    }

    [self judgeWholeInfoComplete];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

#pragma mark -----  判断信息是否填写完整  ------
- (void)judgeWholeInfoComplete{

    UITextField *textFieldOne = [self.view viewWithTag:1000];
    UITextField *textFieldTwo = [self.view viewWithTag:1001];
    UITextField *textFieldThree = [self.view viewWithTag:1002];
    if (textFieldOne.hasText && textFieldTwo.hasText && textFieldThree.hasText) {

        [_saveButton setBackgroundColor:RGB(241, 157, 56)];
        [_saveButton addTarget:self action:@selector(saveButtonAction:) forControlEvents:UIControlEventTouchUpInside];

    } else {
        [_saveButton setBackgroundColor:RGB(100, 100, 100)];
    }


    [_saveInfoDic setObject:(textFieldOne.text == nil ? @"" :textFieldOne.text) forKey:@"pname"];
    [_saveInfoDic setObject:(textFieldTwo.text == nil ? @"" :textFieldTwo.text) forKey:@"pfee"];
    [_saveInfoDic setObject:(textFieldThree.text == nil ? @"" :textFieldThree.text) forKey:@"cname"];
    [_saveInfoDic setObject:(textFieldOne.text == nil ? @"" :textFieldOne.text) forKey:@"images"];
    [_saveInfoDic setObject:(_textView.text == nil ? @"" :_textView.text) forKey:@"note"];
    if (_allDishesInfoDic.count != 0) {
        [_allDishesInfoDic enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
            if ([obj isEqualToString:textFieldThree.text]) {
                [_saveInfoDic setObject:key forKey:@"pid"];
                return ;
            } else {

            }
        }];
    }

}
- (void)saveButtonAction:(ButtonStyle *)sender{


    //    [self uploadNewDishesData:nil];

    DishesInfoModel *newModel = [DishesInfoModel mj_objectWithKeyValues:_saveInfoDic];
    if (_model && [_model.dishesName isEqualToString:newModel.dishesName] && [_model.price isEqualToString:newModel.price] && [_model.category isEqualToString:newModel.category] && [_model.descrpt isEqualToString:newModel.descrpt] && [oldImage isEqual:headerImageV.image]) {
        //cell点进来，并且没有修改信息，不进行上传
        [self.navigationController popViewControllerAnimated:YES];
    } else {
        if (_filePath == nil) {
            //没有修改图片
            [self uploadNewDishesData:nil];
        } else {
            //修改图片
            NSString *directroy = [NSString stringWithFormat:@"dishesCategory/%@", newModel.category];

            [[COSImageTool shareManager] uploadImageWithPath:_filePath directory:directroy attrs:@"123" success:^(COSObjectUploadTaskRsp *rsp) {
                ZTLog(@"+++++_+_+_+_+%@", rsp.sourceURL);
                if (rsp.sourceURL) {
                    [self uploadNewDishesData:rsp.sourceURL];
                }
                self.view.userInteractionEnabled = YES;
            } progress:^(int64_t bytesWritten, int64_t totalBytesWritten, int64_t totalBytesExpectedToWrite) {
                [SVProgressHUD showProgress:totalBytesWritten / totalBytesExpectedToWrite status:@"正在上传，请稍候"];
                self.view.userInteractionEnabled = NO;

            } error:^(NSInteger retCode) {
                self.view.userInteractionEnabled = YES;
                ZTLog(@"%ld", retCode);
            }];;

        }

    }
}
- (void)leftBarButtonItemAction{
    [self.navigationController popViewControllerAnimated:YES];
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
