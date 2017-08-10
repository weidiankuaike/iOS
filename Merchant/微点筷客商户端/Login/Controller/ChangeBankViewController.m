//
//  ChangeBankViewController.m
//  微点筷客商户端
//
//  Created by 张森森 on 16/10/7.
//  Copyright © 2016年 张森森. All rights reserved.
//

#import "ChangeBankViewController.h"
#import "UIBarButtonItem+SSExtension.h"
#import "BaseButton.h"
#import "TixianViewController.h"
#import "ZTAlertSheetView.h"
#import "NumberViewController.h"

#define sourceSeparaTag @">@-@<"
typedef void(^uploadImageSuccess)(BOOL complete, NSString *sourceURL);
typedef void(^queueComplete)(BOOL complete);
@interface ChangeBankViewController ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate>
{
    UIScrollView * shenhescrollview;
}
@property (nonatomic,strong)NSArray * tixingary;
@property (nonatomic,strong)NSArray * arAy;
@property (nonatomic,strong)NSArray * threeary;
@property (nonatomic,strong)UIView * timeview;
@property (nonatomic,strong)ButtonStyle * daitibtn;
@property (nonatomic,strong)ButtonStyle * firbtn;
@property (nonatomic,strong)ButtonStyle *secbtn;
@property (nonatomic,strong)NSArray * ary;
@end

@implementation ChangeBankViewController{
    NSMutableDictionary *photoFilePathDic;
    NSInteger successNum;
    NSString *idCardImageUrl;
    NSString *bankCardImageUrl;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden=NO;
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    photoFilePathDic = [NSMutableDictionary dictionary];
    if (_xianinteger==2) {
        
        self.titleView.text = @"修改提现支付宝号";

    }
    if (_xianinteger==1) {
        
        self.titleView.text = @"修改提现银行卡号";

    }
    self.view.backgroundColor = UIColorFromRGB(0xffffff);
    UIBarButtonItem * backbtn = [UIBarButtonItem itemWithTarget:self Action:@selector(Back) image:@"形状" selectImage:nil];
    self.navigationItem.leftBarButtonItem = backbtn;
    CGFloat height = [[UIApplication sharedApplication] statusBarFrame].size.height + self.navigationController.navigationBar.frame.size.height;
    NSArray * imageary = @[@"111",@"222",@"331",];
    NSArray * selectary = @[@"11",@"22",@"3333",];
    _ary = @[@"拍照",@"相册中选取",@"取消",];
    
    for (int i=0; i<3; i++) {
        
        BaseButton * threebtn = [BaseButton buttonWithType:UIButtonTypeCustom];
        threebtn.tag = 300 +i;
        [threebtn setBackgroundImage:[UIImage imageNamed:imageary[i]] forState:UIControlStateNormal];
        [threebtn setBackgroundImage:[UIImage imageNamed:selectary[i]] forState:UIControlStateSelected];
        [threebtn addTarget:self action:@selector(Shenhe:) forControlEvents:UIControlEventTouchUpInside];
        threebtn.imageView.contentMode =  UIViewContentModeScaleToFill;
        if (i==0) {
            
            threebtn.selected = YES;
        }
        [self.view addSubview:threebtn];
        threebtn.sd_layout.leftSpaceToView(self.view,autoScaleW(25)+i*autoScaleW(108)).topSpaceToView(self.view,autoScaleH(30)+height).widthIs(autoScaleW(108)).heightIs(autoScaleH(55));
        
        
    }
       UILabel * linelabel = [[UILabel alloc]init];
    linelabel.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:linelabel];
    linelabel.sd_layout.leftSpaceToView(self.view,autoScaleW(35)).rightSpaceToView(self.view,autoScaleW(35)).topSpaceToView(self.view,autoScaleH(130)+height).heightIs(autoScaleH(0.5));
    
    shenhescrollview = [[UIScrollView alloc]init];
//    shenhescrollview.
    shenhescrollview.scrollEnabled = NO;
    shenhescrollview.pagingEnabled = YES;
    shenhescrollview.contentSize = CGSizeMake(kScreenWidth*3, kScreenHeight-autoScaleH(135)-height);
    shenhescrollview.contentOffset = CGPointMake(kScreenWidth, 0);
    [self.view addSubview:shenhescrollview];
    shenhescrollview.sd_layout.leftEqualToView(self.view).topSpaceToView(self.view,autoScaleH(135)+height).widthIs(kScreenWidth).heightIs(kScreenHeight-autoScaleH(135)-height);
    
   
        _tixingary = @[@"1.本人手持身份证一张(必须为身份证正面)",@"2.本人手持银行卡照一张(欲更换的提现银行卡)",];
        _arAy = @[@"亲爱的店主您好，我们已经收到你的提交申请！",@"审核一般为24小时，请耐心等待"];
        _threeary = @[@"您的提现卡已修改成功，为保证资金安全",@"在48小时之后方可进行提现，点击完成返回",];
        
    
    
    
    for (int i=0; i<3; i++) {
        
        UIView * shenheView = [[UIView alloc]init];
        shenheView.tag = 200+i;
        if (i==0)
        {
            shenhescrollview.contentOffset=CGPointMake(0, 0);
            
            
        }
        if (i==1) {
            
            UIImageView * timeimage = [[UIImageView alloc]init];
            timeimage.image = [UIImage imageNamed:@"等待"];
            [shenheView addSubview:timeimage];
            timeimage.sd_layout.centerXEqualToView(shenheView).topSpaceToView(shenheView,autoScaleH(90)).widthIs(autoScaleW(66)).heightIs(autoScaleW(66));
            
            for (int a=0; a<2; a++) {
                
                UILabel * tixinglabel = [[UILabel alloc]init];
                tixinglabel.textAlignment = NSTextAlignmentCenter;
                tixinglabel.text = _arAy[a];
                tixinglabel.font = [UIFont systemFontOfSize:autoScaleW(11)];
                tixinglabel.textColor = RGB(182, 182, 182);
                [shenheView addSubview:tixinglabel];
                tixinglabel.sd_layout.centerXEqualToView(shenheView).topSpaceToView(timeimage,autoScaleH(15)+a*autoScaleH(20)).heightIs(autoScaleH(15)).widthIs(autoScaleW(300));
            }

            ButtonStyle * dengdaibtn = [ButtonStyle buttonWithType:UIButtonTypeCustom];
            [dengdaibtn setTitle:@"等待审核(2/3)" forState:UIControlStateNormal];
            [dengdaibtn setBackgroundColor:RGB(191, 191, 191)];
            [dengdaibtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            dengdaibtn .titleLabel.font =[UIFont systemFontOfSize:autoScaleW(15)];
            [dengdaibtn addTarget:self action:@selector(Dengdai) forControlEvents:UIControlEventTouchUpInside];
            dengdaibtn.layer.masksToBounds = YES;
            dengdaibtn.layer.cornerRadius = autoScaleW(5);
            [shenheView addSubview:dengdaibtn];
            dengdaibtn.sd_layout.leftSpaceToView(shenheView,autoScaleW(10)).rightSpaceToView(shenheView,autoScaleW(10)).bottomSpaceToView(shenheView,autoScaleH(20)).heightIs(autoScaleH(33));
        }
        if (i==2) {
            
            UIImageView * timeimage = [[UIImageView alloc]init];
            timeimage.image = [UIImage imageNamed:@"勾"];
            [shenheView addSubview:timeimage];
            timeimage.sd_layout.centerXEqualToView(shenheView).topSpaceToView(shenheView,autoScaleH(90)).widthIs(autoScaleW(66)).heightIs(autoScaleW(66));
            
            for (int b=0; b <2; b++) {
                
                UILabel * tixinglabel = [[UILabel alloc]init];
                tixinglabel.textAlignment = NSTextAlignmentCenter;
                tixinglabel.text = _threeary[b];
                tixinglabel.font = [UIFont systemFontOfSize:autoScaleW(11)];
                tixinglabel.textColor = RGB(182, 182, 182);
                [shenheView addSubview:tixinglabel];
                tixinglabel.sd_layout.centerXEqualToView(shenheView).topSpaceToView(timeimage,autoScaleH(15)+b*autoScaleH(20)).heightIs(autoScaleH(15)).widthIs(autoScaleW(300));
            }
            
            ButtonStyle * dengdaibtn = [ButtonStyle buttonWithType:UIButtonTypeCustom];
            [dengdaibtn setTitle:@"完成(3/3)" forState:UIControlStateNormal];
            [dengdaibtn setBackgroundColor:UIColorFromRGB(0xfd7577)];
            [dengdaibtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            dengdaibtn .titleLabel.font =[UIFont systemFontOfSize:autoScaleW(15)];
            [dengdaibtn addTarget:self action:@selector(Finish) forControlEvents:UIControlEventTouchUpInside];
            dengdaibtn.layer.masksToBounds = YES;
            dengdaibtn.layer.cornerRadius = autoScaleW(5);
            [shenheView addSubview:dengdaibtn];
            dengdaibtn.sd_layout.leftSpaceToView(shenheView,autoScaleW(10)).rightSpaceToView(shenheView,autoScaleW(10)).bottomSpaceToView(shenheView,autoScaleH(20)).heightIs(autoScaleH(33));

        }
        [shenhescrollview addSubview:shenheView];
        shenheView.sd_layout.leftSpaceToView(shenhescrollview,i*kScreenWidth).topSpaceToView(shenhescrollview,0).widthIs(kScreenWidth).heightIs(shenhescrollview.frame.size.height);
        
        
    }
    // 第一个页面
        UIView * firstview = (UIView*)[shenhescrollview viewWithTag:200];
        firstview.userInteractionEnabled = YES;
        UILabel * headlabel = [[UILabel alloc]init];
        headlabel.text =@"申诉材料要求";
        headlabel.font = [UIFont systemFontOfSize:autoScaleW(13)];
        [firstview addSubview:headlabel];
        headlabel.sd_layout.centerXEqualToView(firstview).topSpaceToView(firstview,autoScaleH(5)).widthIs(autoScaleW(100)).heightIs(autoScaleH(15));
    
      for (int i=0; i<2; i++) {
        
        UILabel * tixinglabel = [[UILabel alloc]init];
        tixinglabel.text = _tixingary[i];
        tixinglabel.font = [UIFont systemFontOfSize:autoScaleW(11)];
        tixinglabel.textColor = RGB(182, 182, 182);
        [firstview addSubview:tixinglabel];
        tixinglabel.sd_layout.leftSpaceToView(firstview,autoScaleW(75)).rightSpaceToView(firstview,autoScaleW(45)).topSpaceToView(headlabel,autoScaleH(5)+i*autoScaleH(20)).heightIs(autoScaleH(15));
      
          ButtonStyle * addbtn = [ButtonStyle buttonWithType:UIButtonTypeCustom];
          addbtn.frame = CGRectMake(autoScaleW(10),autoScaleH(80)+i*autoScaleH(165) , kScreenWidth-autoScaleW(20), autoScaleH(145));
          addbtn.backgroundColor = RGB(238, 238, 238);
          addbtn.tag = 200 +i;
          [addbtn addTarget:self action:@selector(Photo:) forControlEvents:UIControlEventTouchUpInside];
          CAShapeLayer * borderlayer = [CAShapeLayer layer];
          borderlayer.frame = addbtn.bounds;
          borderlayer.position = CGPointMake(CGRectGetMidX(addbtn.bounds), CGRectGetMidY(addbtn.bounds));
          borderlayer.path = [UIBezierPath bezierPathWithRect:borderlayer.bounds].CGPath;
          borderlayer.lineWidth = 1 ;
          borderlayer.lineDashPattern = @[@3,@3];
          borderlayer.fillColor = [UIColor clearColor].CGColor;
          borderlayer.strokeColor = [UIColor grayColor].CGColor;
          
          [addbtn.layer addSublayer:borderlayer];
                   [firstview addSubview:addbtn];
         
          UIImageView * addimage = [[UIImageView alloc]init];
          addimage.image = [UIImage imageNamed:@"加号"];
          
          [addbtn addSubview:addimage];
          addimage.sd_layout.centerXEqualToView(addbtn).centerYEqualToView(addbtn).widthIs(autoScaleW(55)).heightIs(autoScaleH(55));
          addimage.userInteractionEnabled = YES;
          
      }
    
    ButtonStyle * tijiaoBtn = [ButtonStyle buttonWithType:UIButtonTypeCustom];
    [tijiaoBtn setTitle:@"提交资料(1/3)" forState:UIControlStateNormal];
    [tijiaoBtn setBackgroundColor:UIColorFromRGB(0xfd7577)];
    [tijiaoBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    tijiaoBtn .titleLabel.font =[UIFont systemFontOfSize:autoScaleW(15)];
    [tijiaoBtn addTarget:self action:@selector(Tijiao) forControlEvents:UIControlEventTouchUpInside];
    tijiaoBtn.layer.masksToBounds = YES;
    tijiaoBtn.layer.cornerRadius = autoScaleW(5);
    [firstview addSubview:tijiaoBtn];
    tijiaoBtn.sd_layout.leftSpaceToView(firstview,autoScaleW(10)).rightSpaceToView(firstview,autoScaleW(10)).bottomSpaceToView(firstview,autoScaleH(20)).heightIs(autoScaleH(33));
   
    
    
}


//拍照
-(void)takephoto
{
   
        
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        
        picker.delegate = self;
        
        picker.allowsEditing = YES; //是否可编辑
        
        //摄像头
        
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        
        [self presentViewController:picker animated:YES completion:^{
            [_timeview removeFromSuperview];
        }];
        
    

}
-(void)libarayphoto
{
    
    
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    
    picker.delegate = self;
    
    picker.allowsEditing = YES;
    
    //打开相册选择照片
    
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    
    [self presentViewController:picker animated:YES completion:^{
        [_timeview removeFromSuperview];
    }];
    

    
}
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    
    UIImage * image = [info objectForKey:UIImagePickerControllerOriginalImage];

    [picker dismissViewControllerAnimated:YES completion:^{
        [_timeview removeFromSuperview];
        _daitibtn.userInteractionEnabled = NO;
         UIImage *tempImage = [_daitibtn.imageView OriginImage:image scaleToSize:_daitibtn.size_sd];
        [_daitibtn setBackgroundImage:tempImage forState:UIControlStateNormal];
        for (UIImageView * addimage in _daitibtn.subviews) {
            
            addimage.hidden = YES;
        }
        NSData *data;
        if (UIImagePNGRepresentation(tempImage) == nil) {
            data = UIImageJPEGRepresentation(tempImage, 1);
        } else {
            data = UIImagePNGRepresentation(tempImage);
        }

        //图片保存的路径
        //这里将图片放在沙盒的documents文件夹中
        NSString * DocumentsPath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];

        //文件管理器
        NSFileManager *fileManager = [NSFileManager defaultManager];

        //把刚刚图片转换的data对象拷贝至沙盒中 并保存为image.png
        /** 用店铺id 和 tag值绑定图片名 **/

        NSString *imageName = [NSString stringWithFormat:@"/tianVerify%@%ld.png", storeID, (long)_daitibtn.tag];
        [fileManager createDirectoryAtPath:DocumentsPath withIntermediateDirectories:YES attributes:nil error:nil];
        [fileManager createFileAtPath:[DocumentsPath stringByAppendingString:imageName] contents:data attributes:nil];

        //得到选择后沙盒中图片的完整路径
        NSString *_filePath = [[NSString alloc]initWithFormat:@"%@%@",DocumentsPath,  imageName];
        NSString *directory = [NSString stringWithFormat:@"%@/%@", storeID, UserId];

        [photoFilePathDic setObject:[NSString stringWithFormat:@"%@%@%@", _filePath, sourceSeparaTag, directory] forKey:@(_daitibtn.tag)];
        ZTLog(@"%@", photoFilePathDic);
    }];
    
    
}
#pragma mark 选取照片
-(void)Photo:(ButtonStyle *)btn
{
    _daitibtn = btn;
    
    ZTAlertSheetView * ztview = [[ZTAlertSheetView alloc]initWithTitleArray:_ary];
    [ztview showView];
    ztview.alertSheetReturn = ^(NSInteger ztcount)
    {
        if (ztcount==0) {
            
            [self takephoto];
        }
        if (ztcount==1) {
            
            [self libarayphoto];
        }
        
    };
    
    
}
-(void)Shenhe:(ButtonStyle *)btn {

}
//队列上传图片
- (void)uploadAllImageWithSourceDic:(NSDictionary *)sourceDic complete:(queueComplete)queueComplete{

    dispatch_group_t uploadImageGroup = dispatch_group_create();
    dispatch_group_enter(uploadImageGroup);
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        //200身份证正面， 201 手持银行卡
        if (sourceDic.count > 0 && [sourceDic.allKeys containsObject:@(200)]) {
            NSArray *tempArr = [sourceDic[@(200)] componentsSeparatedByString:sourceSeparaTag];
            [self uploadFourImageWithSourcePath:[tempArr firstObject] directory:[tempArr lastObject] complete:^(BOOL complete,  NSString *sourceURL) {
                if (complete) {
                    //上传成功
                    successNum++;
                    idCardImageUrl = sourceURL;
                    if (successNum == photoFilePathDic.count) {
                        dispatch_group_leave(uploadImageGroup);
                    }
                } else {
                    [SVProgressHUD showErrorWithStatus:@"身份证正面照上传失败"];
                    queueComplete(NO);
                    return ;
                }
            }];
        }
    });
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        //201 身份证
        if (sourceDic.count > 0 && [sourceDic.allKeys containsObject:@(201)]) {
            NSArray *tempArr = [sourceDic[@(201)] componentsSeparatedByString:sourceSeparaTag];
            [self uploadFourImageWithSourcePath:[tempArr firstObject] directory:[tempArr lastObject] complete:^(BOOL complete,  NSString *sourceURL) {
                if (complete) {
                    //上传成功
                    successNum++;
                    bankCardImageUrl = sourceURL;
                    if (successNum == photoFilePathDic.count) {
                        dispatch_group_leave(uploadImageGroup);
                    }
                } else {
                    [SVProgressHUD showErrorWithStatus:@"身份证背面照上传失败"];
                    queueComplete(NO);
                    return ;
                }
            }];
        }
    });
    //上次图片
    dispatch_group_notify(uploadImageGroup,dispatch_get_main_queue(),^{
        //全部上传完，继续上传别的
        successNum = 0;
        queueComplete(YES);
    });

}
//上传图片
- (void)uploadFourImageWithSourcePath:(NSString *)filePath directory:(NSString *)directory complete:(uploadImageSuccess)success{
    [[COSImageTool shareManager] uploadImageWithPath:filePath directory:directory attrs:@"入驻" success:^(COSObjectUploadTaskRsp *rsp) {
        ZTLog(@"%@", rsp.sourceURL);
        if (rsp.sourceURL !=nil) {
            success(YES, rsp.sourceURL);
        } else {
            success(NO, nil);
        }
    } progress:^(int64_t bytesWritten, int64_t totalBytesWritten, int64_t totalBytesExpectedToWrite) {

    } error:^(NSInteger retCode) {
        success(NO, nil);
    }];
}
#pragma mark 提交
-(void)Tijiao
{
    if (photoFilePathDic.count != 2) {
        [SVProgressHUD showInfoWithStatus:@"请选择图片"];
        return;
    }
    //信息完全正确后上传
    [self uploadAllImageWithSourceDic:photoFilePathDic complete:^(BOOL complete) {
        if (complete) {
            NSString *keyUrl = @"api/merchant/editBankOrAlipay";
            NSString *cardNo = _idcardstr; //银行卡号
            NSString *cardHolder = _namestr; //持卡人
            NSString *handBankCard = bankCardImageUrl; //手持银行卡图片
            NSString *handIdCard = idCardImageUrl; //手持身份证
            NSString *type = @"cardNo"; //传cardNo修改银行，传alipay修改支付宝
            NSString *uploadUrl = [NSString stringWithFormat:@"%@%@?token=%@&cardNo=%@&cardHolder=%@&handBankCard=%@&handIdCard=%@&type=%@", kBaseURL, keyUrl, TOKEN, cardNo, cardHolder, handBankCard, handIdCard, type];

              
            [[QYXNetTool shareManager] postNetWithUrl:uploadUrl urlBody:nil bodyStyle:QYXBodyString header:nil response:QYXJSON success:^(id result) {
                [MBProgressHUD hideHUDForView:self.view animated:YES];

                //上传成功之后返回，修改的地方又一个字段判断是否审核通过
                [self Back];

            } failure:^(NSError *error) {

                [MBProgressHUD hideHUDForView:self.view animated:YES];
                //            NSLog(@"lll%@",error);
            }];
        } else {
            [SVProgressHUD showErrorWithStatus:@"上传失败"];
        }
    }];

    //老方法 老需求
//    shenhescrollview.contentOffset = CGPointMake(kScreenWidth, 0);
//    ButtonStyle * firstbtn = (ButtonStyle *)[self.view viewWithTag:300];
//    firstbtn.selected = NO;
//    ButtonStyle * twobtn = (ButtonStyle *)[self.view viewWithTag:301];
//    twobtn.selected = YES;


}
#pragma mark 等待
-(void)Dengdai
{
    shenhescrollview.contentOffset = CGPointMake(kScreenWidth*2, 0);
    
    ButtonStyle * firstbtn = (ButtonStyle *)[self.view viewWithTag:301];
    firstbtn.selected = NO;
    ButtonStyle * twobtn = (ButtonStyle *)[self.view viewWithTag:302];
    twobtn.selected = YES;
    
}
-(void)Finish
{
    TixianViewController * tixianview = [[TixianViewController alloc]init];
    [self.navigationController pushViewController:tixianview animated:YES];
}
-(void)Back
{
        
    for (UIViewController *controller in self.navigationController.viewControllers) {
        if ([controller isKindOfClass:[NumberViewController class]]) {
            NumberViewController *revise =(NumberViewController *)controller;
            [self.navigationController popToViewController:revise animated:YES];
        }
    }
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
