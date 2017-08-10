//
//  MyMaterialViewController.m
//  wdKuaiKe_iOS
//
//  Created by 张森森 on 16/9/21.
//  Copyright © 2016年 weiDianKuaiKe. All rights reserved.
//

#import "MyMaterialViewController.h"
#import "UIBarButtonItem+SSExtension.h"
#import "ChangeimageView.h"
#import "MyMaterTableViewCell.h"
#import "ZTAlertSheetView.h"
#import "MBProgressHUD+SS.h"
#import "QYXNetTool.h"
#import "RevisePhoneViewController.h"
#import "PhoneyzViewController.h"
#import "ChangelogincodeViewController.h"
#import "COSImageTool.h"
#import "ChangeNameViewController.h"
#import "ZTAddOrSubAlertView.h"
#import "WTThirdPartyLoginManager.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import <AVFoundation/AVCaptureDevice.h>
#import <AVFoundation/AVMediaFormat.h>
@interface MyMaterialViewController ()<UITableViewDelegate,UITableViewDataSource,UIImagePickerControllerDelegate,UIGestureRecognizerDelegate>
{
    NSString * lllstring;
    BOOL isChange ;
    UILabel * rightlabel;
}
@property (nonatomic,strong)NSArray * titleary;
@property (nonatomic,strong)UITableView * toushutable;
@property (nonatomic,strong)NSArray * sectitleary;
@property (nonatomic,strong)NSArray * imageary;
@property (nonatomic,strong)UIImageView * headimageview;
@property (nonatomic,strong)NSArray * ztary;
@property (nonatomic,strong)UILabel * daitilabel;
@property (nonatomic,strong)NSArray * mimaary;
@property (nonatomic,strong)NSMutableArray * xinxiAry;
@end
static CGRect oldframe;
@implementation MyMaterialViewController
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = NO;
    self.navigationController.navigationBar.translucent = NO;
    [self.navigationController.navigationBar setBarTintColor:UIColorFromRGB(0xfd7577)];
    self.tabBarController.tabBar.hidden = YES;
    [self getData];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    isChange = NO;
    self.view.backgroundColor = RGB(238, 238, 238);
    UILabel * titlabel = [[UILabel alloc]init];
    titlabel.frame = CGRectMake(0, 0, 80, 30);
    titlabel.textAlignment = NSTextAlignmentCenter;
    titlabel.font = [UIFont systemFontOfSize:15];
    titlabel.text = @"我的资料";
    titlabel.textColor = [UIColor whiteColor];
    self.navigationItem.titleView = titlabel;
    UIBarButtonItem * backbtn = [UIBarButtonItem itemWithTarget:self Action:@selector(Back) image:@"left-1" selectImage:nil];
    self.navigationItem.leftBarButtonItem = backbtn;

    
      _titleary = @[@"头像",@"用户名"];
    _sectitleary = @[@"手机",@"微博",@"QQ",@"微信"];
    _imageary = @[@"手机",@"微博",@"QQ",@"微信"];
//    _phonestr = [[NSUserDefaults standardUserDefaults]objectForKey:@"loginName"];
    
    _ztary = @[@"拍照",@"相册中选取",@"取消"];
    _mimaary = @[@"旧密码修改",@"验证码修改",@"取消"];
    _xinxiAry = [NSMutableArray array];

}
- (void)Creattable
{
    _toushutable = [[UITableView alloc]init];
    _toushutable.separatorStyle = UITableViewCellSeparatorStyleNone;
    _toushutable.delegate = self;
    _toushutable.dataSource = self;
    _toushutable.backgroundColor = RGB(242, 242, 242);
    [self.view addSubview:_toushutable];
    _toushutable.sd_layout.leftSpaceToView(self.view,0).topSpaceToView(self.view,0).widthIs(self.view.frame.size.width).heightIs(self.view.frame.size.height);

}
//网络请求
- (void)getData
{
    
    NSString * url = [NSString stringWithFormat:@"%@/api/user/userInfoManage?token=%@&userId=%@&operation=0",commonUrl,Token,Userid];
    NSArray * urlary = [url componentsSeparatedByString:@"?"];
    [MBProgressHUD showMessage:@"请稍等"];

    [[QYXNetTool shareManager]postNetWithUrl:urlary.firstObject urlBody:urlary.lastObject bodyStyle:QYXBodyString header:nil response:QYXJSON success:^(id result) {
        [MBProgressHUD hideHUD];

        NSString * msgtype = [NSString stringWithFormat:@"%@",result[@"msgType"]];
        if ([msgtype isEqualToString:@"0"]) {
            NSDictionary * obldict = result[@"obj"];
            NSString * imagestr = obldict[@"avatar"];
            _namestr = obldict[@"name"];
            //http图片转https
            NSArray * imageary = [imagestr componentsSeparatedByString:@":"];
            NSMutableArray * imagemustary = [NSMutableArray arrayWithArray:imageary];
            [imagemustary replaceObjectAtIndex:0 withObject:@"https"];
            _headimage = [imagemustary componentsJoinedByString:@":"];
            _phonestr = [NSString stringWithFormat:@"%@",obldict[@"isMobile"]];
            NSString * wxstr = [NSString stringWithFormat:@"%@",obldict[@"bindWX"]];
            NSString * qqstr = [NSString stringWithFormat:@"%@",obldict[@"bindQQ"]];
            
            NSString * wbstr = [NSString stringWithFormat:@"%@",obldict[@"bindWB"]];
            [_xinxiAry removeAllObjects];//更改玩状态之后，不删除会重复添加
            [_xinxiAry addObject:wbstr];
            [_xinxiAry addObject:qqstr];
            [_xinxiAry addObject:wxstr];

              if (!_toushutable) {
                
                 [self Creattable];
            }
            else{
                [_toushutable reloadData];
            }
        }
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUD];

        [MBProgressHUD showError:@"请求失败"];
    }];
    
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section==0) {
        
        return 2;
    }
    if (section==1) {
        
        return 4;
    }
    
    return 1;
    
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MyMaterTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"mine"];
    if (!cell) {
        
        cell = [[MyMaterTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"mine"];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.userInteractionEnabled = YES;
    
    UILabel * linlabel = [[UILabel alloc]init];
    linlabel.backgroundColor = RGB(230, 230, 230);
    [cell addSubview:linlabel];
    linlabel.sd_layout.leftSpaceToView(cell,0).rightSpaceToView(cell,0).bottomSpaceToView(cell,0).heightIs(autoScaleH(1));
    
//    UIImageView * rightimage = [[UIImageView alloc]init];
//    rightimage.image = [UIImage imageNamed:@"arrow-1-拷贝"];
//    [cell addSubview:rightimage];
//    rightimage.sd_layout.rightSpaceToView(cell,autoScaleW(15)).topSpaceToView(cell,15).widthIs(10).heightIs(15);
//    if (!rightlabel) {
//        
//        rightlabel = [[UILabel alloc]init];
//        rightlabel.font = [UIFont systemFontOfSize:15];
//        rightlabel.textAlignment = NSTextAlignmentRight;
//        [cell addSubview:rightlabel];
//        rightlabel.sd_layout.rightSpaceToView(rightimage,15).topSpaceToView(cell,15).widthIs(260).heightIs(15);
//    }
   
    
    if (indexPath.section==0) {
        
        cell.titlelabel.text = _titleary[indexPath.row];
        if (indexPath.row==0) {
            cell.rightlabel.hidden = YES;
            _headimageview = [[UIImageView alloc]init];
             [_headimageview sd_setImageWithURL:[NSURL URLWithString:_headimage]placeholderImage:[UIImage imageNamed:@"1"]];
            _headimageview.layer.masksToBounds = YES;
            _headimageview.layer.cornerRadius = 15;
            [cell addSubview:_headimageview];
            _headimageview.sd_layout.rightSpaceToView(cell.rightimage,15).topSpaceToView(cell,7).widthIs(30).heightIs(30);
            _headimageview.userInteractionEnabled = YES;
            
        }
        else if (indexPath.row==1)
        {
            cell.rightlabel.text = _namestr;
           cell.rightlabel.textColor = [UIColor blackColor];
            
        }
        
    }
    if (indexPath.section==1) {
        
        cell.titlelabel.text = _sectitleary[indexPath.row];
        cell.titlelabel.sd_layout.leftSpaceToView(cell,45).topSpaceToView(cell,15).widthIs(50).heightIs(15);
        
        
        UIImageView * leftimage = [[UIImageView alloc]init];
        leftimage.image = [UIImage imageNamed:_imageary[indexPath.row]];
        [cell addSubview:leftimage];
        leftimage.sd_layout.leftSpaceToView(cell,15).topSpaceToView(cell,15).widthIs(15).heightIs(15);
        if (indexPath.row==0) {
            
           cell.rightlabel.text = _phonestr;
            cell.rightlabel.textColor = [UIColor blackColor];
            _daitilabel = cell.rightlabel;
            
        }
        else
        {
            NSString * bindType = _xinxiAry[indexPath.row-1];
            if ([bindType isEqualToString:@"1"]) {
                cell.rightlabel.text = @"解绑";
            }else{
                cell.rightlabel.text = @"未绑定";
            }
            
              cell.rightlabel.textColor = UIColorFromRGB(0x3dabff);
        }
        
        
    }
    if (indexPath.section==2) {
        
        cell.titlelabel.text = @"登录密码";
        cell.rightlabel.text = @"设置";
        cell.rightlabel.textColor = UIColorFromRGB(0x000000);
    }
    
    
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return autoScaleH(45);
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section==0) {
        
        return 15;
    }
    if (section==1) {
        
        return 30;
    }
    
    return 30;
}
-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView * headsection = [[UIView alloc]init];
    
    if (section==1||section==2) {
        UILabel * headlabel = [[UILabel alloc]init];
        if (section==1) {
            headlabel.text = @"账号绑定";
        }
        else if (section==2)
        {
            headlabel.text = @"安全设置";
        }
        headlabel.font = [UIFont systemFontOfSize:13];
        headlabel.textColor = UIColorFromRGB(0x000000);
        [headsection addSubview:headlabel];
        headlabel.sd_layout.leftSpaceToView(headsection,15).topSpaceToView(headsection,7).widthIs(70).heightIs(15);
    }
    
    return headsection;
}



-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        
       
            
            if (indexPath.row==0) {
                ZTAlertSheetView * ztview = [[ZTAlertSheetView alloc]initWithTitleArray:_ztary];
                [ztview showView];
                ztview.alertSheetReturn = ^(NSInteger ztcount)
                {
                    if (ztcount==0) {
                        
                        [self camersJur];
                    }
                    if (ztcount==1) {
                        
                        [self photoLibraryJur];
                    }
                    
                };

                
            }
            else if (indexPath.row==1){
                
                ChangeNameViewController * changeNameview = [[ChangeNameViewController alloc]init];
                [self.navigationController pushViewController:changeNameview animated:YES];
            }
        
    }
    
    if (indexPath.section==1) {
        
        if (indexPath.row==0)
        {
          
            RevisePhoneViewController * revisephoneview = [[RevisePhoneViewController alloc]init];
            
            revisephoneview.block = ^(NSString * str)
            {
                if (![str isEqualToString:@"0"]) {
                    
                    _daitilabel.text = str;
                }
                
            };
            
            [self.navigationController pushViewController:revisephoneview animated:YES];
        }else{
            
            NSString * bindtype = _xinxiAry[indexPath.row-1];
            if ([bindtype isEqualToString:@"0"]) {
                WTLoginType loginType;
                __weak NSString * thirdidType = nil;
                if (indexPath.row ==1)
                {
//                    loginType = WTLoginTypeWeiBo;
//                    thirdidType = @"wb";
                    [MBProgressHUD showError:@"功能暂未开放"];

                }
                else if (indexPath.row-1 ==  WTLoginTypeTencent)
                {
                    loginType =  WTLoginTypeTencent;
                    thirdidType = @"qq";
                }
                else if (indexPath.row-1 == WTLoginTypeWeiXin)
                {
                    if ([WXApi isWXAppSupportApi]) {
                        loginType =WTLoginTypeWeiXin;
                        thirdidType = @"wx";
                    }
                    
                }
                
                    [WTThirdPartyLoginManager getUserInfoWithWTLoginType:loginType result:^(NSDictionary *LoginResult, NSString *error) {
                      
                        NSString * openidstr = [LoginResult objectForKey:@"third_id"];
                        [self Getdatawithoperation:@"9" image:thirdidType thirdid:openidstr];
                        
                    }];
                    
                
            }else{
                ZTAddOrSubAlertView * ztview = [[ZTAddOrSubAlertView alloc]initWithStyle:ZTalertSheetStyleTitle];
                ztview.titleLabel.text = [NSString stringWithFormat:@"您确定要解绑%@",_sectitleary[indexPath.row]] ;
                ztview.complete = ^(BOOL choose){
                  
                    if (choose ==YES) {
                        if (indexPath.row==1) {
                             [self Getdatawithoperation:@"8" image:@"wb" thirdid:nil];
                        }else if (indexPath.row==2){
                            [self Getdatawithoperation:@"8" image:@"qq"thirdid:nil];
                        }else if (indexPath.row==3){
                            [self Getdatawithoperation:@"8" image:@"wx" thirdid:nil];

                        }
                        
                    }
                };
                
            }
            
            
            
        }
    }
    if (indexPath.section==2) {
        if (![_phonestr isEqualToString:@""]) {
            
            if (indexPath.row==0) {
                
                ZTAlertSheetView * ztview = [[ZTAlertSheetView alloc]initWithTitleArray:_mimaary];
                [ztview showView];
                ztview.alertSheetReturn = ^(NSInteger ztcount)
                {
                    if (ztcount==0) {
                        
                        ChangelogincodeViewController * changeloginview =[[ChangelogincodeViewController alloc]init];
                        changeloginview.phonestr = _phonestr;
                        [self.navigationController pushViewController:changeloginview animated:YES];
                    }
                    else if (ztcount==1) {
                        
                        PhoneyzViewController * phoneview = [[PhoneyzViewController alloc]init];
                        phoneview.phonestr = _daitilabel.text;
                        [self.navigationController pushViewController:phoneview animated:YES];
                        
                    }
                    
                };
                
                
            }
        }else{
            [MBProgressHUD showError:@"您未绑定账号"];
        }
  
    }
    
}
-(void)Back
{
    [self.navigationController popViewControllerAnimated:NO];
        
}
-(void)Changeimage
{
       NSLog(@">>>>>><<<<");
    
}

#pragma mark 权限
- (void)jurwithStr:(NSString*)str{
    
   
        
        UIAlertController * alertView = [UIAlertController alertControllerWithTitle:nil message:str preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction * cancelAction = [UIAlertAction actionWithTitle:@"偏不" style:UIAlertActionStyleCancel handler:nil];
        UIAlertAction * okAction = [UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            NSURL * url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
            
            if([[UIApplication sharedApplication] canOpenURL:url]) {
                
                NSURL*url =[NSURL URLWithString:UIApplicationOpenSettingsURLString];           [[UIApplication sharedApplication] openURL:url];
                
            }
            
        }];
        
        [alertView addAction:cancelAction];
        [alertView addAction:okAction];
        
        [self presentViewController:alertView animated:YES completion:nil];
    
    
    
}
-(void)camersJur{
    
    AVAuthorizationStatus authstatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    
    if (authstatus == AVAuthorizationStatusDenied) {
        
        [self jurwithStr:@"您未开启相机权限，是否开启"];
        
    }else{
        
        
        
        [self takephoto];
        
        
    }

    
}
#pragma mark 相册权限
- (void)photoLibraryJur{
    
    ALAuthorizationStatus author = [ALAssetsLibrary authorizationStatus];
    
    if( author ==ALAuthorizationStatusDenied){
        
        //无权限
        [self jurwithStr:@"您未开启相册权限，是否开启"];
    }
    else{
        
        [self libarayphoto];
    }
    
    
    
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
    }];
    
    
    
}
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    
    UIImage * image = [info objectForKey:UIImagePickerControllerOriginalImage];
    
    UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil);
    [picker dismissViewControllerAnimated:YES completion:^{
        
        
//        _headimageview.image = image;
        [self upDeloadWithimage:image];
    }];
    
    
}
#pragma mark 图片上传
- (void)upDeloadWithimage:(UIImage*)image{
    //    UIImage * image = _selectedPhotos.lastObject;
    NSData * data = UIImageJPEGRepresentation(image, 0.5);
    //图片保存的路径
    //这里将图片放在沙盒的documents文件夹中
    NSString * DocumentsPath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
    
    //文件管理器
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    //把刚刚图片转换的data对象拷贝至沙盒中 并保存为image.png
    /** 用日期作为图片名 **/
    NSString *imageName = [NSString stringWithFormat:@"/sen%@.png", [NSDate date]];
    [fileManager createDirectoryAtPath:DocumentsPath withIntermediateDirectories:YES attributes:nil error:nil];
    [fileManager createFileAtPath:[DocumentsPath stringByAppendingString:imageName] contents:data attributes:nil];
    
    //得到选择后沙盒中图片的完整路径
    NSString *filePath = [[NSString alloc]initWithFormat:@"%@%@",DocumentsPath,imageName];
    NSString * dicr = [NSString stringWithFormat:@"material/%@",Userid];
    
    [[COSImageTool shareManager] uploadImageWithPath:filePath directory:dicr attrs:nil success:^(COSObjectUploadTaskRsp *rsp) {
        
        NSLog(@"Rspp%@",rsp.sourceURL);
        if (![rsp.sourceURL isEqualToString:@""]) {
            
            [_headimageview sd_setImageWithURL:[NSURL URLWithString:rsp.sourceURL]];
            
            [self Getdatawithoperation:@"1" image:rsp.sourceURL thirdid:nil];
            [[NSUserDefaults standardUserDefaults]setObject:rsp.sourceURL forKey:@"headimage"];
        }
       
        
        
    } progress:^(int64_t bytesWritten, int64_t totalBytesWritten, int64_t totalBytesExpectedToWrite) {
        
        NSLog(@"innnnnnnt%ld %ld %ld",bytesWritten,totalBytesWritten,totalBytesExpectedToWrite);
    } error:^(NSInteger retCode) {
        
    }];
    
}
- (void)Getdatawithoperation:(NSString*)operation image:(NSString*)image thirdid:(NSString*)thirdid
{
    __weak NSString * urlstr = nil;
    __weak NSArray * urlary = nil;
    if ([operation isEqualToString:@"1"]) {
        urlstr = [NSString stringWithFormat:@"%@/api/user/userInfoManage?token=%@&userId=%@&operation=1&avatar=%@",commonUrl,Token,Userid,image];
        
    }
    else if ([operation isEqualToString:@"8"]){
        urlstr = [NSString stringWithFormat:@"%@/api/user/userInfoManage?token=%@&userId=%@&operation=8&type=%@",commonUrl,Token,Userid,image];
    }else if ([operation isEqualToString:@"9"]){
        urlstr = [NSString stringWithFormat:@"%@/api/user/userInfoManage?token=%@&userId=%@&operation=9&type=%@&thirdId=%@",commonUrl,Token,Userid,image,thirdid];
        
    }
    urlary = [urlstr componentsSeparatedByString:@"?"];
    [MBProgressHUD showMessage:@"请稍等"];
    [[QYXNetTool shareManager]postNetWithUrl:urlary.firstObject urlBody:urlary.lastObject bodyStyle:QYXBodyString header:nil response:QYXJSON success:^(id result) {
        NSLog(@">>.%@",result);
        [MBProgressHUD hideHUD];
        if ([operation isEqualToString:@"8"]||[operation isEqualToString:@"9"]) {
            NSString * msgtype = [NSString stringWithFormat:@"%@",result[@"msgType"]];
            if ([msgtype isEqualToString:@"0"]) {
                [MBProgressHUD showSuccess:@"更改成功"];
                [self getData];

            }
        }
        
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUD];
        [MBProgressHUD showError:@"请求失败"];
    }];
    
}
-(void)Changebig
{

       [ChangeimageView showImage:_headimage];
       
}

-(void)text:(newBlock)block
{
    self.bolck = block;
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    
    if (self.bolck !=nil) {
        
        self.bolck(_headimage.image);
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
