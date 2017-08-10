//
//  RestaurantViewController.m
//  微点筷客商户端
//
//  Created by 张森森 on 16/10/27.
//  Copyright © 2016年 张森森. All rights reserved.
//

#import "RestaurantViewController.h"
#import "UIBarButtonItem+SSExtension.h"
#import "LoginTableViewCell.h"
#import "ZTTimerPickerView.h"
#import "MBProgressHUD+SS.h"
#import "ScopeViewController.h"
#import "ZTAlertSheetView.h"
#import "ErectViewController.h"
#import "QYXNetTool.h"
#import "MBProgressHUD+SS.h"
#import "SystemViewController.h"
#import "VerifyViewController.h"
//#import "TXYTImageTool.h"
#import <UIImageView+WebCache.h>
#import "TimeErectViewController.h"
#import "NSObject+JudgeNull.h"

@interface RestaurantViewController ()<UITableViewDelegate,UITableViewDataSource,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
@property (nonatomic,strong)NSArray * titleary;
@property (nonatomic,strong)NSArray * rightary;
@property (nonatomic,strong)UILabel * daitilabel;
@property (nonatomic,strong)UIView  * timeview;
@property (nonatomic,strong)UILabel * tislabel;
@property (nonatomic,strong) UIImageView * headimage;
@property (nonatomic,strong)UILabel * moneylabel;
@property (nonatomic,strong)UIView  * moneyview;
@property (nonatomic,strong)UITextField * mimatext;
@property (nonatomic,strong)UIView  * bigview;
@property (nonatomic,strong)NSArray * ztary;
@property (nonatomic,strong)ButtonStyle * tijiaoBtn;
@property (nonatomic,strong)UILabel * fwlabel;
@property (nonatomic, strong)NSMutableDictionary *submitStatusDic;
@property (nonatomic,copy)NSString * urlstring;
@property (nonatomic,assign)CGFloat height;
@property (nonatomic,strong)NSString * editstr;
@end

@implementation RestaurantViewController{
    UITableView * restaurantTableV;
    BOOL notReload; //区分从哪里进来， 如果是从经营范围进来， 则不需要刷新， 设置为YES
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [ReloadVIew registerReloadView:self];
    [IQKeyboardManager sharedManager].shouldResignOnTouchOutside = YES;

    if (!notReload) {

        self.submitStatusDic = [NSMutableDictionary dictionary];
        if (_yminteger==1) {

            self.titleView.text = @"更多设置";
        }
        if (_yminteger==2) {

            self.titleView.text = @"初始设置";
        }
        self.view.backgroundColor = RGB(242, 242, 242);
        self.automaticallyAdjustsScrollViewInsets = NO;

        _height = [[UIApplication sharedApplication] statusBarFrame].size.height + self.navigationController.navigationBar.frame.size.height;

        _erectary = [NSMutableArray array];
        _typeary = [NSMutableArray array];

        if (_yminteger==1) {

            NSString * userid= UserId;
            NSString * storeid = storeID;
            NSString * token =TOKEN;
            //        NSString * token = @"54654sdsa654asdasd";
            [MBProgressHUD showMessage:@"请稍等"];

            NSString *uploadUrl = [NSString stringWithFormat:@"%@api/merchant/searchStoreInfo?token=%@&storeId=%@&userId=%@",kBaseURL,token,storeid,userid];

            [[QYXNetTool shareManager] postNetWithUrl:uploadUrl urlBody:nil bodyStyle:QYXBodyString header:nil response:QYXJSON success:^(id result) {
                [MBProgressHUD hideHUD];
                NSLog(@"resulttt%@",result);
                id objvalue = [result objectForKey:@"obj"];
                NSLog(@"%@",[objvalue class]);
                if (![objvalue isNull] && ![objvalue isKindOfClass:[NSString class]]) {


                    _storematerialdict = [result objectForKey:@"obj"];

                    _editstr = [NSString stringWithFormat:@"%@",[_storematerialdict objectForKey:@"isEdit"]];
                    _sdwebstr = [NSString stringWithFormat:@"%@",[_storematerialdict objectForKey:@"storeImage"]] ;
                    NSString * catastr = [NSString stringWithFormat:@"%@",[_storematerialdict objectForKey:@"catagory"]];
                    NSArray * cataary = [catastr componentsSeparatedByString:@","];
                    for (int i =0; i<cataary.count; i++) {
                        NSString * str = cataary[i];
                        [_typeary addObject:str];
                    }

                    NSString * pricestr = [NSString stringWithFormat:@"%@",[_storematerialdict objectForKey:@"perCapitaPrice"]];
                    NSString * opentime = [NSString stringWithFormat:@"%@",[_storematerialdict objectForKey:@"openTime"]];
                    [_erectary addObject:catastr];
                    [_erectary addObject:pricestr];
                    [_erectary addObject:opentime];

                    [self creatZl];

                }

            } failure:^(NSError *error) {
                [MBProgressHUD showError:@"网络错误"];
                [MBProgressHUD hideHUD];

            }];

        } else if (_yminteger==2) {
            [self creatZl];
        }
    }
    if (notReload && _yminteger == 1) {
        notReload = NO;
    }
}

- (void)getData{

    NSString *uploadUrl = [NSString stringWithFormat:@"%@api/merchant/searchStoreInfo?token=%@&storeId=%@&userId=%@",kBaseURL,TOKEN,storeID , UserId];

    [[QYXNetTool shareManager] postNetWithUrl:uploadUrl urlBody:nil bodyStyle:QYXBodyString header:nil response:QYXJSON success:^(id result) {
        [MBProgressHUD hideHUD];
        NSLog(@"resulttt%@",result);
        id objvalue = [result objectForKey:@"obj"];
        NSLog(@"%@",[objvalue class]);
        if (![objvalue isNull] && ![objvalue isKindOfClass:[NSString class]]) {


            _storematerialdict = [result objectForKey:@"obj"];

            _editstr = [NSString stringWithFormat:@"%@",[_storematerialdict objectForKey:@"isEdit"]];
            _sdwebstr = [NSString stringWithFormat:@"%@",[_storematerialdict objectForKey:@"storeImage"]] ;
            NSString * catastr = [NSString stringWithFormat:@"%@",[_storematerialdict objectForKey:@"catagory"]];
            NSArray * cataary = [catastr componentsSeparatedByString:@","];
            for (int i =0; i<cataary.count; i++) {
                NSString * str = cataary[i];
                [_typeary addObject:str];
            }

            NSString * pricestr = [NSString stringWithFormat:@"%@",[_storematerialdict objectForKey:@"perCapitaPrice"]];
            NSString * opentime = [NSString stringWithFormat:@"%@",[_storematerialdict objectForKey:@"openTime"]];
            [_erectary addObject:catastr];
            [_erectary addObject:pricestr];
            [_erectary addObject:opentime];

            [restaurantTableV reloadData];

        }

    } failure:^(NSError *error) {
        [MBProgressHUD showError:@"网络错误"];
        [MBProgressHUD hideHUD];

    }];
}
-(void)leftBarButtonItemAction{
    [self Back];
}
-(void)creatZl
{

    UIView * headview = [[UIView alloc]init];
    headview.frame = CGRectMake(autoScaleW(15), _height, kScreenWidth, autoScaleH(200));
    [self.view addSubview:headview];


    UILabel * first = [[UILabel alloc]init];
    first.text = @"餐厅LOGO";
    first.font = [UIFont systemFontOfSize:autoScaleW(13)];
    first.textColor = [UIColor lightGrayColor];
    [headview addSubview:first];
    first.sd_layout.leftSpaceToView(headview,autoScaleW(15)).topSpaceToView(headview,autoScaleH(10)).widthIs(autoScaleW(100)).heightIs(autoScaleH(20));

    UILabel * linelabel = [[UILabel alloc]init];
    linelabel.backgroundColor = RGB(230, 230, 230);
    [headview addSubview:linelabel];
    linelabel.sd_layout.leftSpaceToView(headview,autoScaleW(15)).topSpaceToView(first,autoScaleH(10)).widthIs(kScreenWidth-autoScaleW(30)).heightIs(0.5);

    _headimage = [[UIImageView alloc]init];
    if (_yminteger==1) {
        NSString *url = [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:_sdwebstr]] ? _sdwebstr : [_sdwebstr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        [_headimage sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:[UIImage imageNamed:@"loadingIcon"]];
    }
    if (_yminteger==2) {
        _headimage.backgroundColor = RGB(153, 153, 153);

    }
    _headimage.layer.masksToBounds =YES;
    _headimage.layer.cornerRadius = autoScaleW(40);
    [headview addSubview:_headimage];
    _headimage.sd_layout.centerXEqualToView(headview).topSpaceToView(linelabel,autoScaleH(20)).widthIs(autoScaleW(80)).heightIs(autoScaleH(80));
    _headimage.userInteractionEnabled = YES;
    UITapGestureRecognizer * tap1 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(Add)];
    [_headimage addGestureRecognizer:tap1];


    if (_yminteger==2) {
        _tislabel = [[UILabel alloc]init];
        _tislabel.text = @"点击上传";
        _tislabel.textColor = [UIColor grayColor];
        _tislabel.textAlignment = NSTextAlignmentCenter;
        _tislabel.font = [UIFont systemFontOfSize:autoScaleW(13)];
        [_headimage addSubview:_tislabel];
        _tislabel.sd_layout.centerXEqualToView(_headimage).centerYEqualToView(_headimage).widthIs(_headimage.frame.size.width).heightIs(autoScaleH(15));
    }

    restaurantTableV = [[UITableView alloc]init];
    restaurantTableV.separatorStyle = UITableViewCellSeparatorStyleNone;
    restaurantTableV.delegate = self;
    restaurantTableV.dataSource = self;
    restaurantTableV.scrollEnabled = NO;
    restaurantTableV.tableHeaderView = headview;
    [self.view addSubview:restaurantTableV];
    if (_yminteger==2) {
        restaurantTableV.sd_layout.leftEqualToView(self.view).topSpaceToView(self.view,_height).rightEqualToView(self.view).heightIs(autoScaleH(220)+autoScaleH(60)*3);
    }
    if (_yminteger==1) {

        restaurantTableV.sd_layout.leftEqualToView(self.view).topSpaceToView(self.view,_height).rightEqualToView(self.view).heightIs(autoScaleH(220)+autoScaleH(60)*4);
    }

    _tijiaoBtn = [ButtonStyle buttonWithType:UIButtonTypeCustom];
    [_tijiaoBtn setTitle:@"下一步(1/2)" forState:UIControlStateNormal];
    [_tijiaoBtn setBackgroundColor:[UIColor grayColor]];
    _tijiaoBtn.userInteractionEnabled = NO;
    [_tijiaoBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _tijiaoBtn .titleLabel.font =[UIFont systemFontOfSize:autoScaleW(15)];
    [_tijiaoBtn addTarget:self action:@selector(Tijiao) forControlEvents:UIControlEventTouchUpInside];
    _tijiaoBtn.layer.masksToBounds = YES;
    _tijiaoBtn.layer.cornerRadius = autoScaleW(5);
    [self.view addSubview:_tijiaoBtn];
    _tijiaoBtn.sd_layout.leftSpaceToView(self.view,autoScaleW(10)).rightSpaceToView(self.view,autoScaleW(10)).bottomSpaceToView(self.view,autoScaleH(10)).heightIs(autoScaleH(33));
    if (_yminteger==1) {

        _tijiaoBtn.hidden = YES;
    }
    if (_yminteger==2) {

        _tijiaoBtn.hidden = NO;
    }

    _titleary = @[@"基本信息",@"经营范围",@"人均消费",@"营业时间",];
    _rightary = @[@"经营范围",@"人均消费",@"营业时间",];
    _ztary = @[@"拍照",@"相册中选取",@"取消"];


}
-(void)Add
{
    ZTAlertSheetView * ztview = [[ZTAlertSheetView alloc]initWithTitleArray:_ztary];
    [ztview showView];
    ztview.alertSheetReturn = ^(NSInteger count)
    {
        if (count == 0) {
            //                NSLog(@"camera");
            [CameraManageTools openCamera:self];
            [_timeview removeFromSuperview];
        }
        if (count == 1) {
            //                NSLog(@"picture");
            [CameraManageTools openImagePickController:self];
            [_timeview removeFromSuperview];
        }
    };


}
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{

    UIImage * image = [info objectForKey:UIImagePickerControllerOriginalImage];

    [picker dismissViewControllerAnimated:YES completion:^{
        [_timeview removeFromSuperview];

        //        NSString * idd = UserId;
        _headimage.image = image;
        _headimage.image = [_headimage OriginImage:image scaleToSize:CGSizeMake(200, 200)];
        NSData *data;
        if (UIImagePNGRepresentation(_headimage.image) == nil) {
            data = UIImageJPEGRepresentation(_headimage.image, 1);
        } else {
            data = UIImagePNGRepresentation(_headimage.image);
        }
        //图片保存的路径
        //这里将图片放在沙盒的documents文件夹中
        NSString * DocumentsPath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
        //文件管理器
        NSFileManager *fileManager = [NSFileManager defaultManager];

        //把刚刚图片转换的data对象拷贝至沙盒中 并保存为image.png
        /** 用店铺id绑定图片名 **/
        NSString *imageName = [NSString stringWithFormat:@"/tian%@.png", _BaseModel.storeBase.id];
        [fileManager createDirectoryAtPath:DocumentsPath withIntermediateDirectories:YES attributes:nil error:nil];
        [fileManager createFileAtPath:[DocumentsPath stringByAppendingString:imageName] contents:data attributes:nil];
        //得到选择后沙盒中图片的完整路径
        NSString *_filePath = [[NSString alloc]initWithFormat:@"%@%@",DocumentsPath,  imageName];
        NSString *directroy = [NSString stringWithFormat:@"vertify/%@/logo", UserId];
        [[COSImageTool shareManager] uploadImageWithPath:_filePath directory:directroy attrs:@"logo" success:^(COSObjectUploadTaskRsp *rsp) {
            if (rsp.sourceURL !=nil) {
                _urlstring = rsp.sourceURL;
                NSLog (@"url = %@",_urlstring);
                [_submitStatusDic setObject:@(YES) forKey:@"logo"];
                [self judgeSubmitStatus];
            }
        } progress:^(int64_t bytesWritten, int64_t totalBytesWritten, int64_t totalBytesExpectedToWrite) {


        } error:^(NSInteger retCode) {


        }];

        _tislabel.hidden = YES;

    }];


}

-(void)Creatmoneyui
{
    self.navigationController.view.backgroundColor = [UIColor whiteColor];
    _bigview = [[UIView alloc]init];
    _bigview.backgroundColor = RGBA(0, 0, 0, 0.3);
    [self.navigationController.view addSubview:_bigview];
    _bigview.sd_layout
    .leftSpaceToView(self.navigationController.view,0)
    .topSpaceToView(self.navigationController.view,0)
    .widthIs(kScreenWidth)
    .heightIs(kScreenHeight);
    UITapGestureRecognizer * tap2 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(Remove)];
    [_bigview addGestureRecognizer:tap2];

    _moneyview = [[UIView alloc]init];
    _moneyview.backgroundColor = [UIColor whiteColor];
    _moneyview.layer.masksToBounds = YES;
    _moneyview.layer.cornerRadius =autoScaleW(3);
    [_bigview addSubview:_moneyview];

    _moneyview.sd_layout
    .centerXEqualToView(_bigview)
    .bottomSpaceToView(_bigview,0)
    .widthIs(kScreenWidth)
    .heightIs(autoScaleH(150));

    UILabel * tishilabel = [[UILabel alloc]init];
    tishilabel.text = @"请输入人均消费";
    tishilabel.font = [UIFont systemFontOfSize:autoScaleW(15)];
    tishilabel.textColor = [UIColor blackColor];
    [_moneyview addSubview:tishilabel];

    tishilabel.sd_layout
    .centerXEqualToView(_moneyview)
    .topSpaceToView(_moneyview,autoScaleH(5))
    .widthIs(autoScaleW(120))
    .heightIs(autoScaleH(30));

    ButtonStyle * chabtn = [ButtonStyle buttonWithType:UIButtonTypeCustom];
    [chabtn setTitle:@"取消" forState:UIControlStateNormal];
    chabtn.titleLabel.font = [UIFont systemFontOfSize:autoScaleW(15)];
    [chabtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [chabtn addTarget:self action:@selector(Delet) forControlEvents:UIControlEventTouchUpInside];
    [_moneyview addSubview:chabtn];

    chabtn.sd_layout
    .leftSpaceToView(_moneyview,autoScaleW(10))
    .topSpaceToView(_moneyview,autoScaleH(5))
    .widthIs(autoScaleW(40))
    .heightIs(autoScaleH(30));

    _mimatext = [[UITextField alloc]init];
    _mimatext.layer.borderColor = [UIColor lightGrayColor].CGColor;
    _mimatext.layer.borderWidth = 1;
    _mimatext.textAlignment = NSTextAlignmentCenter;
    _mimatext.keyboardType = UIKeyboardTypeDecimalPad;
    _mimatext.font = [UIFont systemFontOfSize:autoScaleW(13)];
    [_moneyview addSubview:_mimatext];

    _mimatext.sd_layout
    .leftSpaceToView(_moneyview ,autoScaleW(10))
    .rightSpaceToView(_moneyview, autoScaleW(10))
    .topSpaceToView(tishilabel,autoScaleH(17))
    .heightIs(autoScaleH(35));

    UILabel * moneylabel = [[UILabel alloc]init];
    moneylabel.text= @"人民币/元";

    moneylabel.font = [UIFont systemFontOfSize:autoScaleW(11)];
    moneylabel.textColor = [UIColor lightGrayColor];
    [_mimatext addSubview:moneylabel];

    moneylabel.sd_layout
    .rightSpaceToView(_mimatext,autoScaleW(3))
    .centerYEqualToView(_mimatext)
    .widthIs(autoScaleW(60))
    .heightIs(autoScaleH(20));

    ButtonStyle * querenbtn = [ButtonStyle buttonWithType:UIButtonTypeCustom];
    [querenbtn setTitle:@"确认" forState:UIControlStateNormal];
    [querenbtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    querenbtn.layer.masksToBounds = YES;
    querenbtn.layer.cornerRadius = autoScaleW(5);
    querenbtn.titleLabel.font = [UIFont systemFontOfSize:autoScaleW(15)];
    [querenbtn setBackgroundColor:UIColorFromRGB(0xfd7577)];
    [querenbtn addTarget:self action:@selector(Queren) forControlEvents:UIControlEventTouchUpInside ];

    [_moneyview addSubview:querenbtn];
    querenbtn.sd_layout
    .centerXEqualToView(_moneyview)
    .topSpaceToView(_mimatext,autoScaleH(15))
    .widthIs(_moneyview.frame.size.width- autoScaleW(20))
    .heightIs(autoScaleH(40));

    _bigview.alpha = 0;
    [UIView animateWithDuration:0.3 animations:^{
        _bigview.alpha = 1;

    } completion:^(BOOL finished) {


    }];
}
#pragma mark 人均消费取消按钮
-(void)Delet {
    [_bigview removeFromSuperview];

}
#pragma mark 人均消费确定按钮
-(void)Queren
{
    if (![_mimatext.text isEqualToString:@""] ) {
        _moneylabel.text = [NSString stringWithFormat:@"%@元/人",_mimatext.text];
        if (![_moneylabel.text isEqualToString:@"设置"]) {
            [_submitStatusDic setObject:@(YES) forKey:@"money"];
            [self judgeSubmitStatus];
        }
        [_bigview removeFromSuperview];
        self.navigationController.navigationBar.backgroundColor = [UIColor whiteColor];
    } else {
        [MBProgressHUD showError:@"请输入金额"];
    }
}
- (void)judgeSubmitStatus{

    __block BOOL tempStatus = NO;
    if (_submitStatusDic.allKeys.count == 4) {
        [_submitStatusDic enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
            if ([obj isEqualToNumber:@(YES)]) {
                tempStatus = YES;
            } else {
                tempStatus = NO;
                *stop = YES;
            }
        }];
        if (tempStatus) {
            _tijiaoBtn.backgroundColor = UIColorFromRGB(0xfd7577);
            _tijiaoBtn.userInteractionEnabled = YES;
        }
    }
}
-(void)Remove
{

    [self.view endEditing:YES];

}
#pragma mark 监听键盘
-(void)keyboardwill:(NSNotification *)sender
{
    //获取键盘高度
    NSDictionary *dict=[sender userInfo];
    NSValue *value=[dict objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardrect = [value CGRectValue];
    CGFloat height=keyboardrect.size.height;
    //如果输入框的高度低于键盘出现后的高度，视图就上升；
    if ((_moneyview.frame.size.height + _moneyview.frame.origin.y)>(_bigview.frame.size.height-height))
    {
        _moneyview.sd_layout.centerXEqualToView(_bigview).bottomSpaceToView(_bigview,height).widthIs(kScreenWidth).heightIs(autoScaleH(120));

    }
}
#pragma mark 键盘下落
-(void)keybaordhide:(NSNotification *)sender
{
    _moneyview.sd_layout.centerXEqualToView(_bigview).bottomSpaceToView(_bigview,0).widthIs(kScreenWidth).heightIs(autoScaleH(120));
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (_yminteger==1) {

        return 5;
    }
    if (_yminteger==2) {

        return 4;
    }
    return 0;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    LoginTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"mor"];
    if (!cell) {

        cell = [[LoginTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"mor"];
    }
    UILabel * linlabb =[[UILabel alloc]init];
    linlabb.backgroundColor = UIColorFromRGB(0xeeeeee);
    [cell addSubview:linlabb];
    linlabb.sd_layout.leftSpaceToView(cell,0).rightSpaceToView(cell,0).bottomSpaceToView(cell,0).heightIs(0.5);

    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.leftlabel.font = [UIFont systemFontOfSize:15];
    //    cell.leftlabel.sd_layout.leftSpaceToView(self,autoScaleW(15)).topSpaceToView(self,autoScaleH(25)).widthIs(autoScaleW(120)).heightIs(autoScaleH(15));

    cell.textfild.hidden = YES;

    if (_yminteger==1) {

        if (indexPath.row==0) {

            cell.backgroundColor = RGB(242, 242, 242);
        } else {
            cell.leftlabel.text = _titleary[indexPath.row-1];
            cell.leftlabel.font = [UIFont systemFontOfSize:13];

            UIImageView * rightimage = [[UIImageView alloc]init];
            rightimage.image = [UIImage imageNamed:@"形状-3-拷贝"];
            [cell addSubview:rightimage];
            rightimage.sd_layout.rightSpaceToView(cell,autoScaleW(15)).topSpaceToView(cell,autoScaleH(25)).widthIs(autoScaleW(11)).heightIs(autoScaleH(15));

            UILabel * timelabel = [[UILabel alloc]init];
            timelabel.textColor = [UIColor lightGrayColor];
            timelabel.font = [UIFont systemFontOfSize:13];
            timelabel.textAlignment = NSTextAlignmentRight;

            if (indexPath.row==2) {
                timelabel.text = _erectary[indexPath.row-2];

                _fwlabel = timelabel;
            }
            if (indexPath.row==3) {
                timelabel.text = [NSString stringWithFormat:@"%@元/人",_erectary[indexPath.row-2]];
                _moneylabel = timelabel;
            }
            if (indexPath.row==4) {
                timelabel.text =@"设置";

                _daitilabel = timelabel;
            }

            if (indexPath.row==1) {

                NSString * editstr = _editstr;
                if ([editstr isEqualToString:@"0"]) {

                    timelabel.text = @"修改";
                }
                if ([editstr isEqualToString:@"1"]) {

                    timelabel.text = @"审核中";

                }
                if ([editstr isEqualToString:@"2"]) {

                    timelabel.text = @"审核通过";
                }
            }



            [cell addSubview:timelabel];
            timelabel.sd_layout.rightSpaceToView(rightimage,autoScaleW(10)).topSpaceToView(cell,autoScaleH(25)).widthIs(autoScaleW(200)).heightIs(autoScaleH(15));

        }

    }
    if (_yminteger==2) {

        if (indexPath.row==0) {

            cell.backgroundColor = RGB(242, 242, 242);
        }
        else
        {
            cell.leftlabel.text = _rightary[indexPath.row-1];

            UIImageView * rightimage = [[UIImageView alloc]init];
            rightimage.image = [UIImage imageNamed:@"形状-3-拷贝"];
            [cell addSubview:rightimage];
            rightimage.sd_layout.rightSpaceToView(cell,autoScaleW(15)).topSpaceToView(cell,autoScaleH(25)).widthIs(autoScaleW(11)).heightIs(autoScaleH(15));

            UILabel * timelabel = [[UILabel alloc]init];
            timelabel.text = @"设置";
            timelabel.textColor = [UIColor lightGrayColor];
            timelabel.font = [UIFont systemFontOfSize:13];
            timelabel.textAlignment = NSTextAlignmentRight;
            if (indexPath.row==1) {

                _fwlabel = timelabel;
            }
            if (indexPath.row==2) {

                _moneylabel = timelabel;
            }
            if (indexPath.row==3) {

                _daitilabel = timelabel;
            }
            [cell addSubview:timelabel];
            timelabel.sd_layout.rightSpaceToView(rightimage,autoScaleW(10)).topSpaceToView(cell,autoScaleH(25)).widthIs(autoScaleW(200)).heightIs(autoScaleH(15));

        }

    }

    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row==0)
    {

        return autoScaleH(20);
    }

    return autoScaleH(60);
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

    //yminteger 1 代表跳转
    LoginTableViewCell * cell = [tableView cellForRowAtIndexPath:indexPath];
    if (_yminteger==1) {

        if (indexPath.row==1)
        {
            VerifyViewController * verfyview = [[VerifyViewController alloc]init];
            if ([_BaseModel.isChecked integerValue] == 3 && [_BaseModel.storeBase.isEdit integerValue] == 2) {
                verfyview.pageOffset = 0;
            } else {
                verfyview.pageOffset = [_editstr integerValue];
            }
            verfyview.isJohnedStatus = 2;//认证状态 第二个状态
            verfyview.xxdict = _storematerialdict;
            [self.navigationController pushViewController:verfyview animated:YES];
        }

        if (indexPath.row==2) {

            ScopeViewController * scopeview = [[ScopeViewController alloc]init];
            scopeview.btnary = _typeary;
            scopeview.block = ^(NSString * str)
            {
                if (![str isEqualToString:@""] && ![str isEqualToString:@"设置"]) {
                    _fwlabel.text = str ;
                    cell.textfild.text = str;
                    [_submitStatusDic setObject:@(YES) forKey:@"scop"];
                    [self judgeSubmitStatus];
                    notReload = YES;
                }
            };
            [self.navigationController pushViewController:scopeview animated:YES];
        }
        if (indexPath.row==3) {


            [self Creatmoneyui];

        }

        if (indexPath.row==4) {

            notReload = YES;
            TimeErectViewController * timeerect = [[TimeErectViewController alloc]init];
            timeerect.isChecked = YES;
            timeerect.timeSuccess = ^(BOOL success){
                if (success) {
                    [_submitStatusDic setObject:@(YES) forKey:@"time"];
                    [self judgeSubmitStatus];
                    notReload = YES;
                }
            };
            [self.navigationController pushViewController:timeerect animated:YES];
        }

    }
    if (_yminteger==2) {

        if (indexPath.row==1) {

            ScopeViewController * scopeview = [[ScopeViewController alloc]init];

            scopeview.ztinteger = 1;


            scopeview.block = ^(NSString * str)
            {
                _fwlabel.text = str ;

                if (![_fwlabel.text isEqualToString:@"设置"])
                {
                    cell.textfild.text = str;
                    [_submitStatusDic setObject:@(YES) forKey:@"scop"];
                    [self judgeSubmitStatus];
                    notReload = YES;
                }

            };
            [self.navigationController pushViewController:scopeview animated:YES];
        }
        if (indexPath.row==2) {


            [self Creatmoneyui];

        }

        if (indexPath.row==3) {

            TimeErectViewController * timeerect = [[TimeErectViewController alloc]init];
            timeerect.isChecked = NO;
            timeerect.timeSuccess = ^(BOOL isSucess){
                if (isSucess) {
                    [_submitStatusDic setObject:@(YES) forKey:@"time"];
                    [self judgeSubmitStatus];
                    notReload = YES;
                }
            };
            [self.navigationController pushViewController:timeerect animated:YES];

        }

    }

}

#pragma mark 下一步按钮
-(void)Tijiao
{
    //    ErectViewController * erectview = [[ErectViewController alloc]init];
    //    [self.navigationController pushViewController:erectview animated:YES];


    NSString * token = TOKEN;
    NSString * idd = UserId;
    long storebaseid = [idd integerValue];
    NSString * moneystr = [_moneylabel.text componentsSeparatedByString:@"元"].firstObject;



    NSString * url = [NSString stringWithFormat:@"%@api/merchant/storeSetOne?token=%@&id=%ld&storeImage=%@&openTime=%@&catagory=%@&perCapitaPrice=%@&ischange=0&storeId=%@",kBaseURL,token,storebaseid,_urlstring,_daitilabel.text,_fwlabel.text,moneystr, storeID];


    [MBProgressHUD showMessage:@"请稍等"];

    [[QYXNetTool shareManager] postNetWithUrl:url urlBody:nil bodyStyle:QYXBodyString header:nil response:QYXJSON success:^(id result) {
        [MBProgressHUD hideHUD];

        if ([result[@"msgType"] isEqualToString:@"0"]) {
            ErectViewController * erectview = [[ErectViewController alloc]init];
            [self.navigationController pushViewController:erectview animated:YES];
        } else {
            [SVProgressHUD showErrorWithStatus:@"网络错误"];
        }
    } failure:^(NSError *error) {
         [MBProgressHUD hideHUD];
         [MBProgressHUD showError:[NSString stringWithFormat:@"错误码：%@",error]];
     }];


}
-(void)Back
{
    if (_yminteger==1) {
        NSString * token = TOKEN;
        if (_urlstring == nil) {
            _urlstring= _sdwebstr;
        }
        NSString * moneystr = [_moneylabel.text componentsSeparatedByString:@"元"].firstObject;
        NSString * storeid = storeID;
        //初始设置 需改变此接口
        NSString * url = [NSString stringWithFormat:@"%@api/merchant/storeSetOne?token=%@&id=%@&storeImage=%@&openTime=%@&catagory=%@&perCapitaPrice=%@&ischange=%d&storeId=%@",kBaseURL,token,storeid,_urlstring,_daitilabel.text,_fwlabel.text,moneystr,1, storeID];
        
        [[QYXNetTool shareManager] postNetWithUrl:url urlBody:nil bodyStyle:QYXBodyString header:nil response:QYXJSON success:^(id result) {
            NSString *code = [NSString stringWithFormat:@"%@",[result objectForKey:@"msgType"]];
            if ([code isEqualToString:@"0"]) {
                
                [self.navigationController popViewControllerAnimated:YES];
                
            }
        } failure:^(NSError *error) {
            [MBProgressHUD showError:@"网络中断,操作失败"];
            [self.navigationController popViewControllerAnimated:YES];
        }];
    }
    if (_yminteger==2) {
        
        [self.navigationController popViewControllerAnimated:YES];
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
