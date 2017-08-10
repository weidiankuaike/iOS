//
//  VerifyViewController.m
//  微点筷客商户端
//
//  Created by 张森森 on 16/10/8.
//  Copyright © 2016年 张森森. All rights reserved.
//

#import "VerifyViewController.h"
#import "UIBarButtonItem+SSExtension.h"
#import "LoginTableViewCell.h"
#import "ErectViewController.h"
#import "RestaurantViewController.h"
#import "QYXNetTool.h"
#import "MBProgressHUD+SS.h"
#import "ZTAlertSheetView.h"
#import "AddressSetFromMapVC.h"
#import <CoreLocation/CoreLocation.h>
//#import "TXYTImageTool.h"
#import <UIButton+WebCache.h>

#define sourceSeparaTag @">@-@<"
typedef void(^uploadImageSuccess)(BOOL complete, NSString *sourceURL);
typedef void(^queueComplete)(BOOL complete);

@interface VerifyViewController ()<UITableViewDelegate,UITableViewDataSource,UIPickerViewDelegate,UIPickerViewDataSource,UINavigationControllerDelegate,UIImagePickerControllerDelegate,UITextFieldDelegate>
{
    UIScrollView * wholeScrollV;
    NSArray * firstary;
    NSArray * secondary;
    NSArray * firstfildary;
    NSArray * secondfildary;
    NSArray * imagelabelary;
    __weak LoginTableViewCell * _verifycell;
    NSMutableDictionary *_imageDic;
    BOOL _isOn;
    NSMutableDictionary *_fourImageDic;//需要在进入界面初始化，由于图片时一对一入座，选中图片后，先保存图片路径和需要生成，例如：filePath:directory. 取得时候就区allkey和allvalues。
    NSInteger successNum;
}
@property (nonatomic,strong) UITableView * verifyTableView;
@property (strong,nonatomic)NSArray *allProvinceArray;
@property (strong,nonatomic)NSMutableArray *cityArray;
@property (strong,nonatomic)NSMutableArray *quyuArry;
@property (assign,nonatomic)NSInteger row1;
@property (assign,nonatomic)NSInteger row2;
@property (assign,nonatomic)NSInteger row3;
@property(nonatomic,copy)NSString *pro_id;
@property (copy,nonatomic)NSString *areaId;
@property (copy,nonatomic)NSString *cityId;
@property(nonatomic,strong) UIPickerView *pickerView;//地址选择器
@property (strong,nonatomic)UIView *showAreaView;
@property (nonatomic,strong)UITextField * daititext;
@property (nonatomic,strong)UISwitch* mySwitch;
@property (nonatomic,strong)UIView * timeview;
@property (nonatomic,strong)ButtonStyle * addbtn;
@property (nonatomic,strong)NSMutableArray * brnary;
@property (nonatomic,strong)UITextField * addresstext;
@property (nonatomic,assign)CLLocationCoordinate2D daiticoordinate;
@property (nonatomic,strong)UILabel * tishilabel;
@property (nonatomic,strong)NSMutableArray * firstxxary;
@property (nonatomic,strong)NSArray * addresstrary;
@property (nonatomic,strong)NSString * phonestr;
@property (nonatomic,strong)NSString * serviceLicense;
@property (nonatomic,strong)NSMutableArray * threeimageary;
@property (nonatomic,strong)NSString * idcardup;
@property (nonatomic,strong)NSString * idcarddown;
//@property (nonatomic,strong)NSString * serveliscen;
@property (nonatomic,strong)ButtonStyle * daitibtn;
@property (nonatomic,strong)NSString * urlstring;
@property (nonatomic,strong)NSString * token;
@property (nonatomic,strong)NSString * idd;
@property (nonatomic,strong)NSMutableArray * btnary;
@property (nonatomic,strong)NSMutableDictionary * celltextdict;
@property (nonatomic,copy) NSString * userid;
@property (nonatomic,copy) NSString * storeid;
/** 提交按钮   (strong) **/
@property (nonatomic, strong) ButtonStyle * submitBT;
@end
@implementation VerifyViewController

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationItem setHidesBackButton:YES];

}

- (void)viewDidLoad {
    [super viewDidLoad];
    _fourImageDic = [NSMutableDictionary dictionary];
    _imageDic = [NSMutableDictionary dictionary];
    successNum = 0;
    [[IQKeyboardManager sharedManager] setShouldResignOnTouchOutside:YES];
    [[IQKeyboardManager sharedManager] setEnableAutoToolbar:YES];
    self.automaticallyAdjustsScrollViewInsets = NO;

    [self zssOnePieceMethod];
}

- (void)zssOnePieceMethod{
    self.titleView.text = @"申请验证";
    self.view.backgroundColor = RGB(242, 242, 242);

    CGFloat height = [[UIApplication sharedApplication] statusBarFrame].size.height + self.navigationController.navigationBar.frame.size.height;



    wholeScrollV = [[UIScrollView alloc]initWithFrame:self.view.frame];
    //    shenhescrollview.
    wholeScrollV.scrollEnabled = NO;
    wholeScrollV.pagingEnabled = YES;
    wholeScrollV.contentSize = CGSizeMake(kScreenWidth*3, kScreenHeight-height);
    wholeScrollV.contentOffset = CGPointMake(kScreenWidth, 0);
    [self.view addSubview:wholeScrollV];
    wholeScrollV.sd_layout.spaceToSuperView(UIEdgeInsetsZero);
    NSArray * imageary = @[@"r1",@"2",@"3",];
    NSArray * selectary = @[@"1",@"r2",@"3",];
    NSArray * thary = @[@"1",@"2",@"r3"];
    _brnary = [NSMutableArray arrayWithObjects:imageary,selectary,thary, nil];



    //    UILabel * linelabel = [[UILabel alloc]init];
    //    linelabel.backgroundColor = [UIColor lightGrayColor];
    //    [self.view addSubview:linelabel];
    //    linelabel.sd_layout.leftSpaceToView(self.view,0).rightSpaceToView(self.view,0).topSpaceToView(self.view,autoScaleH(90)+height).heightIs(autoScaleH(0.5));

    NSArray * arAy = @[@"亲爱的店主您好，我们已经收到你的提交申请！",@"为保证您能尽快上线，正在加速审核状态"];
    NSArray * threeary = @[@"亲爱的店主您好，您的提交已通过审核",@"点击上线营业，立刻开始布置你的线上餐厅吧！",];
    for (int i=0; i<3; i++) {

        UIView * cellContentView = [[UIView alloc]init];
        cellContentView.tag = 200+i;
        [wholeScrollV addSubview:cellContentView];
        cellContentView.sd_layout
        .leftSpaceToView(wholeScrollV,i*kScreenWidth)
        .topSpaceToView(wholeScrollV,64)
        .widthIs(kScreenWidth)
        .heightIs(wholeScrollV.frame.size.height - 64);

        UIView * headView = [[UIView alloc]init];
        headView.backgroundColor = RGB(242, 242, 242);
        headView.frame = CGRectMake(0, 0, kScreenWidth, autoScaleH(105));
        [cellContentView addSubview:headView];

        for (int a =0; a<3; a++) {

            ButtonStyle * threebtn = [ButtonStyle buttonWithType:UIButtonTypeCustom];
            threebtn.tag = 300 +i;
            [threebtn setBackgroundImage:[UIImage imageNamed:_brnary[i][a]] forState:UIControlStateNormal];

            threebtn.userInteractionEnabled = NO;
            threebtn.imageView.contentMode =  UIViewContentModeScaleToFill;

            [headView addSubview:threebtn];
            threebtn.sd_layout.leftSpaceToView(headView,autoScaleW(25)+a*autoScaleW(108)).topSpaceToView(headView,autoScaleH(30)).widthIs(autoScaleW(108)).heightIs(autoScaleH(55));
        }
        if (i==0)
        {
            _verifyTableView = [[UITableView alloc]init];
            _verifyTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
            _verifyTableView.delegate = self;
            _verifyTableView.dataSource = self;
            _verifyTableView.tableHeaderView = headView;
            [cellContentView addSubview:_verifyTableView];
            _verifyTableView.sd_layout.spaceToSuperView(UIEdgeInsetsZero);
        }
        if (i==1) {

            UIImageView * timeimage = [[UIImageView alloc]init];
            timeimage.image = [UIImage imageNamed:@"等待"];
            [cellContentView addSubview:timeimage];
            timeimage.sd_layout.centerXEqualToView(cellContentView).topSpaceToView(cellContentView,autoScaleH(140)).widthIs(autoScaleW(66)).heightIs(autoScaleW(66));

            for (int a=0; a<2; a++) {

                UILabel * tixinglabel = [[UILabel alloc]init];
                tixinglabel.textAlignment = NSTextAlignmentCenter;
                tixinglabel.text = arAy[a];
                tixinglabel.font = [UIFont systemFontOfSize:autoScaleW(11)];
                tixinglabel.textColor = RGB(182, 182, 182);
                [cellContentView addSubview:tixinglabel];
                tixinglabel.sd_layout.centerXEqualToView(cellContentView).topSpaceToView(timeimage,autoScaleH(15)+a*autoScaleH(20)).heightIs(autoScaleH(15)).widthIs(autoScaleW(300));
            }
            ButtonStyle * secStep = [ButtonStyle buttonWithType:UIButtonTypeCustom];
            //            [secStep setTitle:@"等待审核(2/3)" forState:UIControlStateNormal];
            [secStep setTitle:@"查看审核进度" forState:UIControlStateNormal];
            [secStep setBackgroundColor:UIColorFromRGB(0xfd7577)];
            [secStep setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            secStep .titleLabel.font =[UIFont systemFontOfSize:autoScaleW(15)];
            [secStep addTarget:self action:@selector(waitServiceCheckIn:) forControlEvents:UIControlEventTouchUpInside];
            secStep.layer.masksToBounds = YES;
            secStep.layer.cornerRadius = autoScaleW(5);
            [cellContentView addSubview:secStep];
            secStep.sd_layout
            .leftSpaceToView(cellContentView,autoScaleW(10))
            .rightSpaceToView(cellContentView,autoScaleW(10))
            .bottomSpaceToView(cellContentView,autoScaleH(20))
            .heightIs(autoScaleH(33));
        }
        if (i==2) {

            UIImageView * timeimage = [[UIImageView alloc]init];
            timeimage.image = [UIImage imageNamed:@"勾"];
            [cellContentView addSubview:timeimage];
            timeimage.sd_layout.centerXEqualToView(cellContentView).topSpaceToView(cellContentView,autoScaleH(140)).widthIs(autoScaleW(66)).heightIs(autoScaleW(66));

            for (int b=0; b <2; b++) {

                UILabel * tixinglabel = [[UILabel alloc]init];
                tixinglabel.textAlignment = NSTextAlignmentCenter;
                tixinglabel.text = threeary[b];
                tixinglabel.font = [UIFont systemFontOfSize:autoScaleW(11)];
                tixinglabel.textColor = RGB(182, 182, 182);
                [cellContentView addSubview:tixinglabel];
                tixinglabel.sd_layout.centerXEqualToView(cellContentView).topSpaceToView(timeimage,autoScaleH(15)+b*autoScaleH(20)).heightIs(autoScaleH(15)).widthIs(autoScaleW(300));
            }

            ButtonStyle * dengdaibtn = [ButtonStyle buttonWithType:UIButtonTypeCustom];
            [dengdaibtn setTitle:@"上线营业(3/3)" forState:UIControlStateNormal];
            [dengdaibtn setBackgroundColor:UIColorFromRGB(0xfd7577)];
            [dengdaibtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            dengdaibtn .titleLabel.font =[UIFont systemFontOfSize:autoScaleW(15)];
            [dengdaibtn addTarget:self action:@selector(Finish) forControlEvents:UIControlEventTouchUpInside];
            dengdaibtn.layer.masksToBounds = YES;
            dengdaibtn.layer.cornerRadius = autoScaleW(5);
            [cellContentView addSubview:dengdaibtn];
            dengdaibtn.sd_layout
            .leftSpaceToView(cellContentView,autoScaleW(10))
            .rightSpaceToView(cellContentView,autoScaleW(10))
            .bottomSpaceToView(cellContentView,autoScaleH(20))
            .heightIs(autoScaleH(33));



        }



    }
    if (_pageOffset==0) {

        wholeScrollV.contentOffset=CGPointMake(0, 0);
    }
    if (_pageOffset==1) {

        wholeScrollV.contentOffset=CGPointMake(kScreenWidth, 0);
    }
    if (_pageOffset==2) {
        wholeScrollV.contentOffset = CGPointMake(kScreenWidth*2, 0);
    }

    firstary = @[@"负责人",@"身份证号",@"商铺名称",];
    secondary = @[@"联系电话",@"详细地址",];
    firstfildary = @[@"请输入您的姓名",@"请输入您的身份证号",@"请输入您的商铺名称"];
    secondfildary = @[@"请输入您的电话",@"请输入您的地址"];
    imagelabelary = @[@"身份证正面",@"身份证反面",@"营业执照",@"服务许可证"];
    _firstxxary = [NSMutableArray array];
    _threeimageary = [NSMutableArray array];

    _celltextdict = [NSMutableDictionary dictionary];

    if (_isJohnedStatus==2) {

        ZTLog(@"dict==%@",_xxdict);
        NSString * namestr =[ _xxdict objectForKey:@"storeManager"];
        NSString * idcard = [_xxdict objectForKey:@"idCard"];
        NSString * storename = [_xxdict objectForKey:@"name"];
        [_firstxxary addObject:namestr];
        [_firstxxary addObject:idcard];
        [_firstxxary addObject:storename];
        _phonestr = [_xxdict objectForKey:@"cellphone"];
        _serviceLicense = [_xxdict objectForKey:@"storeLicense"];//服务许可证
        NSString * opzzstr = [_xxdict objectForKey:@"openZz"];//营业执照
        NSString * idcardup = [_xxdict objectForKey:@"idCardImgUp"];
        NSString * idcardDown = [_xxdict objectForKey:@"idCardImgDown"];
        [_threeimageary addObject:idcardup];
        [_threeimageary addObject:idcardDown];
        [_threeimageary addObject:opzzstr];
        NSString * address  = [_xxdict objectForKey:@"address"];
        NSArray * addary = [address componentsSeparatedByString:@","];
        _addresstrary = addary;
        NSString * latstr = [_xxdict objectForKey:@"lat"];
        NSString * lngstr = [_xxdict objectForKey:@"lng"];
        [_celltextdict setObject:latstr forKey:@"lat"];
        [_celltextdict setObject:lngstr forKey:@"lng"];
        //        NSLog(@"ary===%@..%@",addary,address);
    }

    _token = TOKEN;

    if (_isJohnedStatus==2) {

        _idd = UserId;
        _userid = UserId;
        _storeid = storeID;
    }
    if (_isJohnedStatus==1) {
        _idd = UserId;
    }


    _btnary = [NSMutableArray array];


}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 14;

}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString * cellident = [NSString stringWithFormat:@"%ld-ver", (long)indexPath.row];
    LoginTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellident];
    if (!cell) {
        cell = [[LoginTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellident];
    }

    cell.index = indexPath.row;
    UILabel * linlabel = [[UILabel alloc]init];
    linlabel.backgroundColor = UIColorFromRGB(0xeeeeee);
    [cell addSubview:linlabel];
    linlabel.sd_layout.leftSpaceToView(cell,0).rightSpaceToView(cell,0).bottomSpaceToView(cell,0).heightIs(0.5);

    cell.selectionStyle = UITableViewCellSelectionStyleNone;

    cell.textfild.tag = indexPath.row;
    cell.textfild.delegate = self;


    //    if (indexPath.section==0) {

    if (indexPath.row==0||indexPath.row==4||indexPath.row==9) {
        cell.textfild.userInteractionEnabled = NO;
        cell.textfild.enabled = NO;
        cell.backgroundColor = RGB(242, 242, 242);
    }  else {
        dispatch_async(dispatch_get_main_queue(), ^{


        });
        NSString * text = [_celltextdict objectForKey:[NSString stringWithFormat:@"%ld",(long)cell.textfild.tag]];

        if (indexPath.row==1||indexPath.row==2||indexPath.row==3)
        {
            cell.leftlabel.text = firstary[indexPath.row-1];
            if (_isJohnedStatus==2) {
                if (text==nil) {
                    cell.textfild.text = _firstxxary[indexPath.row-1];
                } else {
                    cell.textfild.text = text;
                }
                [_celltextdict setObject:cell.textfild.text forKey:[NSString stringWithFormat:@"%ld",(long)cell.textfild.tag]];

            }
            if (_isJohnedStatus==1) {
                if (text==nil) {
                    cell.textfild.placeholder = firstfildary[indexPath.row-1];
                } else {
                    cell.textfild.text = text;
                }
            }
        }
        if (indexPath.row==5) {
            cell.leftlabel.text = @"联系电话";
            if (_isJohnedStatus==2) {
                if (text == nil) {
                    cell.textfild.text = _phonestr;
                } else {

                }
                [_celltextdict setObject:cell.textfild.text forKey:[NSString stringWithFormat:@"%ld",(long)cell.textfild.tag]];
            }
            if (_isJohnedStatus==1) {
                //                    cell.textfild.placeholder = @"请输入你的电话";
                if (text==nil) {

                    cell.textfild.placeholder = @"请输入你的电话";
                } else {
                    cell.textfild.text = text;
                }
            }

        }
        if (indexPath.row==6) {

            cell.leftlabel.text = @"所属区域";
            if (_isJohnedStatus==2) {

                if (text == nil) {
                    cell.textfild.text = [NSString stringWithFormat:@"%@,%@,%@",_addresstrary[0],_addresstrary[1],_addresstrary[2]] ;
                } else {

                }
                [_celltextdict setObject:cell.textfild.text forKey:[NSString stringWithFormat:@"%ld",(long)cell.textfild.tag]];
            }
            if (_isJohnedStatus==1) {
                //                    cell.textfild.placeholder = @"请输入您所在省、市、区";
                if (text==nil) {

                    cell.textfild.placeholder = @"请输入您所在省、市、区";
                } else {
                    cell.textfild.text = text;
                }
            }
            cell.textfild.userInteractionEnabled = NO;
            _daititext = cell.textfild;
        }
        if (indexPath.row==7) {
            cell.leftlabel.text = @"店铺地址";
            if (_isJohnedStatus==2) {
                if (text == nil) {
                    cell.textfild.text = _addresstrary[3];
                } else {

                }
                [_celltextdict setObject:cell.textfild.text forKey:[NSString stringWithFormat:@"%ld",(long)cell.textfild.tag]];
            }
            if (_isJohnedStatus==1) {
                //                    cell.textfild.placeholder = @"添加您的地址";
                if (text==nil) {

                    cell.textfild.placeholder = @"添加您的地址";
                } else {
                    cell.textfild.text = text;
                }
            }
            cell.textfild.userInteractionEnabled = NO;
            _addresstext = cell.textfild;


        }
        if (indexPath.row==8) {
            cell.leftlabel.text = @"详细地址";

            if (_isJohnedStatus==1) {
                //                    cell.textfild.placeholder = @"添加详细地址";
                if (text==nil) {

                    cell.textfild.placeholder = @"添加详细地址";
                } else {
                    cell.textfild.text = text;
                }

            }
            if (_isJohnedStatus==2) {
                if (text == nil) {
                    cell.textfild.text = _addresstrary[4];
                }
            }

        }
        if (indexPath.row==10||indexPath.row==11||indexPath.row==12||indexPath.row==13) {
            [cell.textfild removeFromSuperview];
            cell.leftlabel.text = imagelabelary[indexPath.row-10];
            cell.identify = @"入驻资料";
            _addbtn = [cell viewWithTag:300 + indexPath.row ];
            if (_addbtn == nil) {
                _addbtn = [ButtonStyle buttonWithType:UIButtonTypeCustom];
            }
            _addbtn.frame = CGRectMake(autoScaleW(15),autoScaleH(45) , kScreenWidth-autoScaleW(30), autoScaleH(145));
            _addbtn.tag = 300+indexPath.row;
            [_addbtn addTarget:self action:@selector(Photo:) forControlEvents:UIControlEventTouchUpInside];
            _addbtn.backgroundColor = RGB(238, 238, 238);
            CAShapeLayer * borderlayer = [CAShapeLayer layer];
            borderlayer.frame = _addbtn.bounds;
            borderlayer.position = CGPointMake(CGRectGetMidX(_addbtn.bounds), CGRectGetMidY(_addbtn.bounds));
            borderlayer.path = [UIBezierPath bezierPathWithRect:borderlayer.bounds].CGPath;
            borderlayer.lineWidth = 1 ;
            borderlayer.lineDashPattern = @[@3,@3];
            borderlayer.fillColor = [UIColor clearColor].CGColor;
            borderlayer.strokeColor = [UIColor grayColor].CGColor;
            [_addbtn.layer addSublayer:borderlayer];
            [cell addSubview:_addbtn];
            [_btnary addObject:_addbtn];
            _addbtn.userInteractionEnabled = YES;
            UIImageView * addimage = [[UIImageView alloc]init];
            addimage.image = [UIImage imageNamed:@"加号"];
            [_addbtn addSubview:addimage];
            addimage.sd_layout.centerXEqualToView(_addbtn).centerYEqualToView(_addbtn).widthIs(autoScaleW(55)).heightIs(autoScaleH(55));
            UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(Photo:)];
            [addimage addGestureRecognizer:tap];
            if (indexPath.row==10||indexPath.row==11||indexPath.row==12) {

                if (_isJohnedStatus==2) {
                    if (_imageDic.count > 0 && [_imageDic.allKeys containsObject:@(_addbtn.tag)]) {
                        [_addbtn setBackgroundImage:_imageDic[@(_addbtn.tag)] forState:UIControlStateNormal];
                    } else {
                        NSString *url = [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:_threeimageary[indexPath.row-10]]] ? _threeimageary[indexPath.row-10] : [_threeimageary[indexPath.row-10] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
                        [_addbtn sd_setImageWithURL:[NSURL URLWithString:url] forState:UIControlStateNormal];
                    }
                    addimage.hidden = YES;
                }
                else if (_isJohnedStatus==1) {
                    addimage.hidden = NO;
                    if (_imageDic.count > 0 && [_imageDic.allKeys containsObject:@(_addbtn.tag)]) {
                        UIImage *image = [_imageDic objectForKey:@(_addbtn.tag)];
                        if (![image isNull]) {
                            [_addbtn setBackgroundImage:image forState:UIControlStateNormal];
                            addimage.hidden = YES;
                        }
                    }

                }

            }

            if (indexPath.row==13) {
                if ([cell viewWithTag:200 + indexPath.row] == nil) {
                    _mySwitch = [[UISwitch alloc]init];
                    _mySwitch.on = YES;
                    [cell addSubview:_mySwitch];
                }
                _mySwitch.tag = 200 + indexPath.row;
                [_mySwitch setOnTintColor:UIColorFromRGB(0xfd7577)];
                [_mySwitch addTarget:self action:@selector(swChange:) forControlEvents:UIControlEventTouchUpInside];


                _mySwitch.sd_layout.rightSpaceToView(cell,autoScaleW(15)).topSpaceToView(cell,autoScaleH(8)).widthIs(autoScaleW(8)).heightIs(autoScaleH(11));
                if (_tishilabel == nil) {
                    _tishilabel = [[UILabel alloc]init];
                    _tishilabel.font= [UIFont systemFontOfSize:autoScaleW(13)];
                    //            _tishilabel.textAlignment = NSTextAlignmentCenter;
                    _tishilabel.numberOfLines = 0;
                    _tishilabel.textColor = [UIColor blackColor];
                    [cell addSubview:_tishilabel];
                    _tishilabel.hidden = YES;
                }
                _tishilabel.text = @"若有服务许可证，请尽量提供详尽照片。若不上服务许可证，则需我方人员到店考察方能帮助您通过审核，可能会造成审核时间过长。";
                _tishilabel.sd_layout.centerXEqualToView(cell).topSpaceToView(cell,autoScaleH(45)).widthIs(kScreenWidth-autoScaleW(30)).heightIs(autoScaleH(145));


                //                    //入住后修改
                //                    if ([_serviceLicense isNull]|| _serviceLicense == nil) {
                //                        _tishilabel.hidden = NO;
                //                        _mySwitch.on = NO;
                //                        _addbtn.hidden = YES;
                //                    } else {
                //                        _tishilabel.hidden = YES;
                //                        addimage.hidden = YES;
                //                        _mySwitch.on = YES;
                //                        [_addbtn sd_setImageWithURL:[NSURL URLWithString:_serviceLicense] forState:UIControlStateNormal];
                //                    }
                if (_submitBT == nil) {
                    _submitBT = [ButtonStyle buttonWithType:UIButtonTypeCustom];
                }
                [_submitBT setTitle:@"提交资料(1/3)" forState:UIControlStateNormal];
                [_submitBT setBackgroundColor:UIColorFromRGB(0xfd7577)];
                [_submitBT setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                _submitBT .titleLabel.font =[UIFont systemFontOfSize:autoScaleW(15)];
                [cell addSubview:_submitBT];

                [_submitBT addTarget:self action:@selector(Tijiao:) forControlEvents:UIControlEventTouchUpInside];
                _submitBT.layer.masksToBounds = YES;
                _submitBT.layer.cornerRadius = autoScaleW(5);
                _submitBT.sd_layout.leftSpaceToView(cell,autoScaleW(15)).rightSpaceToView(cell,autoScaleW(15)).topSpaceToView(_addbtn,autoScaleH(15)).heightIs(autoScaleH(33));

                if (_isJohnedStatus==1 && indexPath.row == 13) {
                    addimage.hidden = NO;
                    if (_imageDic.count > 0 && [_imageDic.allKeys containsObject:@(_addbtn.tag)]) {
                        UIImage *image = [_imageDic objectForKey:@(_addbtn.tag)];
                        if (![image isNull]) {
                            [_addbtn setBackgroundImage:image forState:UIControlStateNormal];
                            addimage.hidden = YES;
                        }
                    }
                }
                if (([_serviceLicense isNull]|| _serviceLicense == nil) && !_isOn) {

                    _mySwitch.on = NO;
                    _addbtn.hidden = YES;
                    _tishilabel.hidden = NO;
                } else {
                    _tishilabel.hidden = YES;
                    _mySwitch.on=YES;
                    _addbtn.hidden= NO;
                    addimage.hidden = YES;
                    _isOn = YES;
                    if (_imageDic.count > 0 && [_imageDic.allKeys containsObject:@(_addbtn.tag)]) {
                        UIImage *image = [_imageDic objectForKey:@(_addbtn.tag)];
                        [_addbtn setBackgroundImage:image forState:UIControlStateNormal];
                    } else {
                        dispatch_async(dispatch_get_main_queue(), ^{
                             NSString *url = [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:_serviceLicense]] ? _serviceLicense : [_serviceLicense stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
                            [_addbtn sd_setImageWithURL:[NSURL URLWithString:url] forState:UIControlStateNormal];
                        });
                    }
                }
            }
        }

    }
    [_celltextdict setObject:cell.textfild.text forKey:[NSString stringWithFormat:@"%ld",(long)cell.textfild.tag]];
    NSString *tempText = [_celltextdict objectForKey:[NSString stringWithFormat:@"%ld",(long)cell.textfild.tag]];
    if (![tempText isNull]) {
        cell.textfild.text = tempText;
    }
    return cell;

}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row==6) {
        [self customAddressView];
    }
#pragma mark ---- 地图处理结果回调 ----------
    if (indexPath.row == 7) {
        AddressSetFromMapVC *addressVC = [[AddressSetFromMapVC alloc] init];
        [self.navigationController pushViewController:addressVC animated:YES];

        //            LoginTableViewCell *cell = (LoginTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
        //            __weak typeof(cell) weakCell = cell;
        //            __weak typeof(self) weakSelf = self;
        addressVC.targetAddress = _daititext.text;
        [addressVC returnAddressFromMap:^(NSString *address, CLLocationCoordinate2D coordinate) {

            _addresstext.text = address;
            _daiticoordinate = coordinate;
            [_celltextdict setObject:address forKey:[NSString stringWithFormat:@"%ld", (long)indexPath.row]];
            NSString * latstr = [NSString stringWithFormat:@"%f",_daiticoordinate.latitude];
            [_celltextdict setObject:latstr forKey:@"lat"];
            NSString * lngstr = [NSString stringWithFormat:@"%f",_daiticoordinate.longitude];
            [_celltextdict setObject:lngstr forKey:@"lng"];
            //处理coordinate
            //weakSelf.xxxx = coordinate;


        }];
    }





}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{

    if (indexPath.row==0||indexPath.row==4||indexPath.row==9) {

        return autoScaleH(9);
    }
    else
    {
        if (indexPath.row==10||indexPath.row==11||indexPath.row==12) {

            return autoScaleH(190);
        }
        if (indexPath.row==13) {

            return autoScaleH(190+70);
        }
    }
    return autoScaleH(45);
}
#pragma mark cell的textfield代理方法

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    LoginTableViewCell *cell = [_verifyTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:textField.tag - 1  inSection:0]];
    UILabel *_leftlabel = cell.leftlabel;
    if ([_leftlabel.text containsString:@"手机号"] || [_leftlabel.text containsString:@"身份证"] || [_leftlabel.text containsString:@"号"] || [_leftlabel.text containsString:@"电话"] ) {
        //        textField.keyboardType = UIKeyboardTypeNumberPad;
    }
    return YES;
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField{

    [textField resignFirstResponder];
    return YES;
}
-(void)textFieldDidEndEditing:(UITextField *)textField{

    [_celltextdict setObject:textField.text forKey:[NSString stringWithFormat:@"%ld",(long)textField.tag]];
    LoginTableViewCell *cell = [_verifyTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:textField.tag inSection:0]];
    UILabel *_leftlabel = cell.leftlabel;
    NSString *phoneNum = [textField.text deleteTabOrSpaceStr];
    if ([_leftlabel.text containsString:@"手机号"]  || [_leftlabel.text containsString:@"电话"]) {
        if ([phoneNum isMobileNumber]) {
            [textField resignFirstResponder];
        } else {
            [textField becomeFirstResponder];
            [SVProgressHUD showInfoWithStatus:@"请输入正确的手机号码"];
        }
    }
    if ([_leftlabel.text containsString:@"身份证"]) {
        if (![textField.text simpleVerifyIdentityCardNum]) {
            [SVProgressHUD showInfoWithStatus:@"请输入正确的身份证号"];
        }
    }
    if ([_leftlabel.text containsString:@"卡号"]) {
        if (![textField.text bankCardluhmCheck]) {
            [SVProgressHUD showInfoWithStatus:@"请输入正确的提现卡号"];
        }
    }
}
#pragma mark 开关按钮
-(void)swChange:(UISwitch*)sw {
    for (ButtonStyle * btn in _btnary) {

        if (btn.tag==sw.tag+100) {
            if (sw.on == YES) {
                btn.hidden = NO;
                _tishilabel.hidden = YES;
            } else {
                btn.hidden = YES;
                _tishilabel.hidden = NO;
            }
        }
    }
        _isOn = sw.isOn;

}
-(void)leftBarButtonItemAction
{
    if (_isJohnedStatus ==1) {
      
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
    else if(_isJohnedStatus==2){
      [self.navigationController popViewControllerAnimated:YES];
    }
}
#pragma mark 等待
-(void)waitServiceCheckIn:(ButtonStyle *)sender
{
    [sender setBackgroundColor:UIColorFromRGB(0xfd7577)];
    //点击判断 是否审核通过
    NSString *keyUrl = @"api/merchant/getMuserData";

    NSString *uploadUrl = [NSString stringWithFormat:@"%@%@?token=%@&loginName=%@", kBaseURL, keyUrl, TOKEN, LoginName];

      
    [[QYXNetTool shareManager] postNetWithUrl:uploadUrl urlBody:nil bodyStyle:QYXBodyString header:nil response:QYXJSON success:^(id result) {
        if ([result[@"msgType"] integerValue] == 0) {
            //isChecked -1 未提交审核 0 等待审核 1 审核通过 2 初始化设置 3 完成设置
            //isEdit 0 提交资料｜被拒（修改资料） 1 正在审核 2 完成认证
            //如果入驻成功后，isCheck ＝ 3
            NSInteger isCheckStatus = [result[@"obj"][@"isChecked"] integerValue];
            NSInteger innerIsCheck = [result[@"obj"][@"storeBase"][@"isChecked"] integerValue];
            NSInteger innerIsEdit = [result[@"obj"][@"storeBase"][@"isEdit"] integerValue];
            if (isCheckStatus == 0) {
                [SVProgressHUD showInfoWithStatus:@"正在审核中"];
            } else if (isCheckStatus == -1){
                [SVProgressHUD showInfoWithStatus:@"审核被拒，请核查资料后重新提交"];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    wholeScrollV.contentOffset = CGPointMake(0, 0);
                });
            } else {
                //                ZTLog(@"%@%@", _BaseModel.storeBase.isChecked, _BaseModel.storeBase.isEdit);
                if ( innerIsCheck >= 1 && isCheckStatus == 3) {
                    if (innerIsEdit == 1) {
                        [SVProgressHUD showInfoWithStatus:@"正在审核中"];
                    } else if (innerIsEdit == 0) {
                        [SVProgressHUD showInfoWithStatus:@"审核被拒，请核查资料后重新提交"];
                        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                            wholeScrollV.contentOffset = CGPointMake(0, 0);
                        });
                    } else {
                        [SVProgressHUD showSuccessWithStatus:@"审核通过"];
                        [self.navigationController popViewControllerAnimated:YES];
                    }
                } else {
                    wholeScrollV.contentOffset = CGPointMake(kScreenWidth*2, 0);
                }
                //重置登录状态
                NSUserDefaults * userde = [NSUserDefaults standardUserDefaults];
                NSData *archData = [NSKeyedArchiver  archivedDataWithRootObject:result[@"obj"]];
                [userde setObject:archData forKey:LocationLoginInResultsKey];
            }
        } else {
            [SVProgressHUD showErrorWithStatus:@"操作异常"];
        }
    } failure:^(NSError *error) {

    }];
}
-(void)Finish{
    RestaurantViewController * restauview = [[RestaurantViewController alloc] init];
    restauview.yminteger = 2;
    [self.navigationController pushViewController:restauview animated:YES];
}
#pragma mark 自定义pickview
-(void)customAddressView
{
    if (!self.allProvinceArray) {
        NSData *data = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"area_list" ofType:@"txt"]];
        NSError *error = nil;

        NSArray *allProvince = [NSJSONSerialization JSONObjectWithData:data
                                                               options:0
                                                                 error:&error];

        self.allProvinceArray = [[NSArray alloc]initWithArray:allProvince];

        NSDictionary *cityDict = [self.allProvinceArray objectAtIndex:self.row1];
        NSArray *city = [cityDict objectForKey:@"city_list"];
        self.cityArray = [[NSMutableArray alloc]initWithArray:city];
        NSDictionary *quyuDic = [self.cityArray objectAtIndex:self.row2];
        NSArray *quyu = [quyuDic objectForKey:@"area_list"];
        self.quyuArry = [[NSMutableArray alloc]initWithArray:quyu];
    }
    [self createShowArea];
}

-(void)createShowArea
{
    if (!self.showAreaView) {
        //        self.showAreaView = [[UIView alloc]initWithFrame:CGRectMake(0, kScreenHeight -162 - 84 - 64, kScreenWidth, 162+84)];
        self.showAreaView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
        self.showAreaView.backgroundColor = RGBA(0, 0, 0, 0.3);
        self.showAreaView.hidden = YES;
        [self.showAreaView addSubview:[self createAreaInputView]];
        UIPickerView *pickView = [[UIPickerView alloc]initWithFrame:CGRectMake(0, kScreenHeight-162, kScreenWidth, 162)];
        pickView.backgroundColor = [UIColor redColor];
        pickView.dataSource = self;

        pickView.backgroundColor = [UIColor whiteColor];
        pickView.delegate = self;
        pickView.showsSelectionIndicator = NO;
        [self.showAreaView addSubview:pickView];
        self.pickerView=pickView;


    }
    if (self.showAreaView.hidden) {
        self.showAreaView.hidden = NO;
        [self.navigationController.view addSubview:self.showAreaView];
    }
}
-(void)cancle
{


    self.showAreaView.hidden = YES;
    [self.showAreaView removeFromSuperview];
}

-(UIView *)createAreaInputView
{
    UIView *pickView = [[UIView alloc]initWithFrame:CGRectMake(0, kScreenHeight-162-34, kScreenWidth, 34)];
    pickView.backgroundColor = [UIColor whiteColor];
    ButtonStyle *cancle = [[ButtonStyle alloc]initWithFrame:CGRectMake(10, 7, 60, 20)];
    [cancle setTitle:@"取 消" forState:UIControlStateNormal];
    cancle.titleLabel.font=[UIFont systemFontOfSize:15];
    [cancle setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [cancle addTarget:self action:@selector(cancle) forControlEvents:UIControlEventTouchUpInside];
    [cancle setBackgroundImage:[UIImage imageNamed:@"cancelbtn.png"] forState:UIControlStateNormal];
    cancle.layer.cornerRadius = 5.0f;
    [pickView addSubview:cancle];

    ButtonStyle *sure = [[ButtonStyle alloc]initWithFrame:CGRectMake(kScreenWidth - 10 - 60 ,7,60, 20)];
    [sure setTitle:@"确 定" forState:UIControlStateNormal];
    sure.titleLabel.font=[UIFont systemFontOfSize:15];
    [sure setTitleColor:UIColorFromRGB(0xfd7577) forState:UIControlStateNormal];
    [sure addTarget:self action:@selector(sure) forControlEvents:UIControlEventTouchUpInside];

    sure.layer.cornerRadius = 5.0f;
    [pickView addSubview:sure];

    return pickView;
}
-(void)sure
{
    self.showAreaView.hidden = YES;

    [self.showAreaView removeFromSuperview];

    NSDictionary *dict = [self.allProvinceArray objectAtIndex:self.row1];
    NSString *province = [dict objectForKey:@"province"];
    self.pro_id=[dict objectForKey:@"id"];
    NSDictionary *cityDic = [self.cityArray objectAtIndex:self.row2];
    NSString *city = [cityDic objectForKey:@"city"];
    self.cityId = [cityDic objectForKey:@"id"];
    NSDictionary *quyuDic = nil;
    if (self.quyuArry.count > 0) {
        quyuDic = [self.quyuArry objectAtIndex:self.row3];
        NSString *content =  [quyuDic objectForKey:@"area"];
        self.areaId = [quyuDic objectForKey:@"id"];
        _daititext.text = [NSString stringWithFormat:@"%@,%@,%@",province,city,content];
    } else {
        self.areaId = @"0";
        _daititext.text = [NSString stringWithFormat:@"%@-%@",province,city];
    }
    //    NSLog(@"%@,%@,%@ ",self.pro_id,self.cityId,self.areaId);
    [_celltextdict setObject:_daititext.text forKey:@"6"];

}
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 3;
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (component == 0) {
        return self.allProvinceArray.count;
    }else if (component == 1)
    {
        return self.cityArray.count;
    }else
    {
        return self.quyuArry.count;
    }
    return 0;
}



-(UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    NSString *content = nil;
    if (component == 0) {
        NSDictionary *dict = [self.allProvinceArray objectAtIndex:row];
        content = [dict objectForKey:@"province"];
    }else if (component == 1)
    {
        NSDictionary *dict = [self.cityArray objectAtIndex:row];
        content = [dict objectForKey:@"city"];
    }else
    {
        NSDictionary *dict =  [self.quyuArry objectAtIndex:row];
        content = [dict objectForKey:@"area"];
    }
    UILabel *label = [[UILabel alloc]init];
    label.frame=CGRectMake(0, 0, kScreenWidth / 3.0, 35);
    label.font=[UIFont systemFontOfSize:15];
    label.textAlignment=NSTextAlignmentCenter;
    label.text=content;

    return label;
}

-(CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
    return 35;
}
-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if (component == 0) {
        if (row != self.row1) {

            self.row2 = 0;
            self.row3 = 0;
            [self.cityArray removeAllObjects];
            [self.quyuArry removeAllObjects];

            NSDictionary *cityDict = [self.allProvinceArray objectAtIndex:row];
            NSArray *city = [cityDict objectForKey:@"city_list"];
            [self.cityArray addObjectsFromArray:city];

            NSDictionary *quyuDic = [self.cityArray objectAtIndex:self.row2];
            NSArray *quyu = [quyuDic objectForKey:@"area_list"];
            [self.quyuArry addObjectsFromArray:quyu];
            [pickerView selectRow:0 inComponent:1 animated:NO];
            [pickerView selectRow:0 inComponent:2 animated:NO];
            [pickerView reloadComponent:1];
            [pickerView reloadComponent:2];

        }
        self.row1 = row;

    }else if (component == 1)
    {

        if (row != self.row2) {
            self.row3 = 0;
            [self.quyuArry removeAllObjects];
            NSDictionary *quyuDic = [self.cityArray objectAtIndex:row];
            NSArray *quyu = [quyuDic objectForKey:@"area_list"];
            [self.quyuArry addObjectsFromArray:quyu];
            [pickerView selectRow:0 inComponent:2 animated:NO];
            [pickerView reloadComponent:2];
        }
        self.row2 = row;

    }else

    {
        self.row3 = row;
    }

}
-(CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component
{
    return kScreenWidth / 3;
}

#pragma mark 选取照片
-(void)Photo:(ButtonStyle *)btn
{
    _daitibtn = btn;
    _daitibtn.tag = btn.tag;
    NSArray * ary = @[@"拍照",@"相册中选取",@"取消",];
    ZTAlertSheetView * ztalert = [[ZTAlertSheetView alloc]initWithTitleArray:ary];
    [ztalert showView];
    ztalert.alertSheetReturn = ^(NSInteger count)
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


        for (UIImageView * addimage in _daitibtn.subviews) {
            addimage.hidden = YES;
        }
        UIImage *tempImage = [_daitibtn.imageView OriginImage:image scaleToSize:_daitibtn.size_sd];
        [_daitibtn setBackgroundImage:tempImage forState:UIControlStateNormal];

        //        NSLog(@">>>%ld",_daitibtn.tag);


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

        NSString *imageName = [NSString stringWithFormat:@"/tianVerify%@.jpg", [NSDate date]];
        [fileManager createDirectoryAtPath:DocumentsPath withIntermediateDirectories:YES attributes:nil error:nil];
        [fileManager createFileAtPath:[DocumentsPath stringByAppendingString:imageName] contents:data attributes:nil];
        //得到选择后沙盒中图片的完整路径
        NSString *_filePath = [[NSString alloc]initWithFormat:@"%@%@",DocumentsPath,  imageName];
        NSString *directory = [NSString stringWithFormat:@"/vertify/%@", UserId];

        //入住前，根据_imageDic取图片对象 赋值cell的10 ——13这四个位置
        [_imageDic setObject:image forKey:@(_daitibtn.tag)];
        //修改或添加图片时，根据tag保存文件源路径 和 需要生成签名的路径，做统一保存上传。
        [_fourImageDic setObject:[NSString stringWithFormat:@"%@%@%@", _filePath, sourceSeparaTag, directory] forKey:@(_daitibtn.tag)];
        //        ZTLog(@"%@", _fourImageDic);
        [_verifyTableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForItem:_daitibtn.tag - 300 inSection:0]] withRowAnimation:UITableViewRowAnimationAutomatic];
    }];


}
//队列上传图片
- (void)uploadAllImageWithSourceDic:(NSDictionary *)sourceDic complete:(queueComplete)queueComplete{
    _submitBT.enabled = NO;
    if ([_threeimageary isNull]) {
        _threeimageary = [NSMutableArray arrayWithArray:@[@"",@"",@""]];
    }
    dispatch_group_t uploadImageGroup = dispatch_group_create();
    dispatch_group_enter(uploadImageGroup);
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        //310身份证正面， 311 身份证背面 312 营业许可证， 313 服务许可证（可选）
        if (sourceDic.count > 0 && [sourceDic.allKeys containsObject:@(310)]) {
            NSArray *tempArr = [sourceDic[@(310)] componentsSeparatedByString:sourceSeparaTag];
            [self uploadFourImageWithSourcePath:[tempArr firstObject] directory:[tempArr lastObject] complete:^(BOOL complete,  NSString *sourceURL) {
                if (complete) {
                    //上传成功
                    _idcardup = sourceURL;
                    [_threeimageary replaceObjectAtIndex:0 withObject:sourceURL];
                    successNum++;
                    if (successNum == _fourImageDic.count) {
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
        //311 身份证背面
        if (sourceDic.count > 0 && [sourceDic.allKeys containsObject:@(311)]) {
            NSArray *tempArr = [sourceDic[@(311)] componentsSeparatedByString:sourceSeparaTag];
            [self uploadFourImageWithSourcePath:[tempArr firstObject] directory:[tempArr lastObject] complete:^(BOOL complete,  NSString *sourceURL) {
                if (complete) {
                    //上传成功
                    _idcarddown = sourceURL;
                    [_threeimageary replaceObjectAtIndex:1 withObject:sourceURL];
                    successNum++;
                    if (successNum == _fourImageDic.count) {
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
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        //312 营业许可证
        if (sourceDic.count > 0 && [sourceDic.allKeys containsObject:@(312)]) {
            NSArray *tempArr = [sourceDic[@(312)] componentsSeparatedByString:sourceSeparaTag];
            [self uploadFourImageWithSourcePath:[tempArr firstObject] directory:[tempArr lastObject] complete:^(BOOL complete,  NSString *sourceURL) {
                //dispatch_group_leave(uploadImageGroup);
                if (complete) {
                    //上传成功
                    _urlstring = sourceURL;
                    [_threeimageary replaceObjectAtIndex:2 withObject:sourceURL];
                    successNum++;
                    if (successNum == _fourImageDic.count) {
                        dispatch_group_leave(uploadImageGroup);
                    }
                } else {
                    [SVProgressHUD showErrorWithStatus:@"营业许可证上传失败"];
                    dispatch_group_leave(uploadImageGroup);
                    queueComplete(NO);
                    return ;
                }
            }];
        }
    });
    if (_isOn) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            //313 服务许可证（可选）
            if (sourceDic.count > 0 && [sourceDic.allKeys containsObject:@(313)]) {
                NSArray *tempArr = [sourceDic[@(313)] componentsSeparatedByString:sourceSeparaTag];
                [self uploadFourImageWithSourcePath:[tempArr firstObject] directory:[tempArr lastObject] complete:^(BOOL complete,  NSString *sourceURL) {
                    if (complete) {
                        //上传成功
                        _serviceLicense = sourceURL;
                        successNum++;
                        if (successNum == _fourImageDic.count) {
                            dispatch_group_leave(uploadImageGroup);
                        }
                    } else {
                        [SVProgressHUD showErrorWithStatus:@"服务许可证上传失败"];
                        queueComplete(NO);
                        return ;
                    }
                }];
            } else {
                //dispatch_group_leave(uploadImageGroup);
            }
        });
    }
    dispatch_group_notify(uploadImageGroup,dispatch_get_main_queue(),^{
        //全部上传完，继续上传别的
        successNum = 0;
        queueComplete(YES);
    });

}
//上传图片
- (void)uploadFourImageWithSourcePath:(NSString *)filePath directory:(NSString *)directory complete:(uploadImageSuccess)success{
    [[COSImageTool shareManager] uploadImageWithPath:filePath directory:directory attrs:@"joinIn" success:^(COSObjectUploadTaskRsp *rsp) {
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
-(void)Tijiao:(ButtonStyle *)sender
{
    sender.enabled = NO;
    //验证文本信息是否正确
    NSString * bossName = [_celltextdict objectForKey:@"1"]; //名字
    NSString * bossIdCardNum = [_celltextdict objectForKey:@"2"]; //身份证号
    NSString * storeName = [_celltextdict objectForKey:@"3"]; //店铺名称
    NSString * phoneNum = [_celltextdict objectForKey:@"5"]; //电话号
    NSString * detailAddress = [_celltextdict objectForKey:@"8"]; //地址

    NSString * mapAddress;
    if (detailAddress==nil) {
        mapAddress = [NSString stringWithFormat:@"%@,%@",_daititext.text,_addresstext.text];
    }else{
        mapAddress = [NSString stringWithFormat:@"%@,%@,%@",_daititext.text,_addresstext.text,detailAddress];
    }
    NSString * latstr = [_celltextdict objectForKey:@"lat"];//经纬度
    NSString * lngstr = [_celltextdict objectForKey:@"lng"];
    if (![bossName isNull] &&![bossIdCardNum isNull] &&![storeName isNull] &&![phoneNum isNull]&& [bossIdCardNum simpleVerifyIdentityCardNum] && [phoneNum isMobileNumber] && ![latstr isNull] && ![lngstr isNull] && ![mapAddress isNull]) {
        //都不为空 ，继续走
    } else {
        UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"信息不能为空" preferredStyle:UIAlertControllerStyleAlert];
        __weak UIAlertAction * cancel = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:nil];

        [alert addAction:cancel];

        [self presentViewController:alert animated:YES completion:nil];
        return;
    }


    if (![phoneNum isMobileNumber]) {
        [SVProgressHUD showInfoWithStatus:@"请输入正确的手机号码"];
        return;
    }
    if (![bossIdCardNum simpleVerifyIdentityCardNum]) {
        [SVProgressHUD showInfoWithStatus:@"请输入正确的身份证号"];
        bossIdCardNum = @"";
        return;
    }
#pragma mark 入驻前
    if (_isJohnedStatus == 1) {
        //验证图片信息
        if (_isOn) {
            if (_fourImageDic.allValues.count != 4) {
                [SVProgressHUD showInfoWithStatus:@"请补全信息"];
                return;
            } else {
                [self uploadAllImageWithSourceDic:[_fourImageDic copy] complete:^(BOOL complete) {
                    if (complete) {
                        [self uploadAllDataBeforeImageSuccessWith:bossName bossIdNum:bossIdCardNum storeName:storeName phoneNum:phoneNum lontitude:lngstr latitude:latstr mapAddress:mapAddress];
                    }
                    _submitBT.enabled = YES;
                }];
            }

        } else {
            if (_fourImageDic.allValues.count != 3) {
                [SVProgressHUD showInfoWithStatus:@"请补全信息"];
                return;
            } else {
                [self uploadAllImageWithSourceDic:[_fourImageDic copy] complete:^(BOOL complete) {
                    if (complete) {
                        [self uploadAllDataBeforeImageSuccessWith:bossName bossIdNum:bossIdCardNum storeName:storeName phoneNum:phoneNum lontitude:lngstr latitude:latstr mapAddress:mapAddress];
                    }
                    _submitBT.enabled = YES;
                }];
            }
            //不用上传服务许可证
            _serviceLicense = @"";
            _mySwitch.on = NO;
        }
    } else {  //入住后修改资料上传图片
        if (_fourImageDic.count == 0) { //没修改图片
            [self uploadAllDataBeforeImageSuccessWith:bossName bossIdNum:bossIdCardNum storeName:storeName phoneNum:phoneNum lontitude:lngstr latitude:latstr mapAddress:mapAddress];
        } else {
            [self uploadAllImageWithSourceDic:[_fourImageDic copy] complete:^(BOOL complete) {
                if (complete) {
                    [self uploadAllDataBeforeImageSuccessWith:bossName bossIdNum:bossIdCardNum storeName:storeName phoneNum:phoneNum lontitude:lngstr latitude:latstr mapAddress:mapAddress];
                }
                _submitBT.enabled = YES;
            }];
        }
    }


}

- (void)uploadAllDataBeforeImageSuccessWith:(NSString *)bossName bossIdNum:(NSString *)bossIdCardNum storeName:(NSString *)storeName phoneNum:(NSString *)phoneNum lontitude:(NSString *)lontitude latitude:(NSString *)latitude mapAddress:(NSString *)mapAddress{
    if (_urlstring == nil || [_urlstring isNull]) {
        _urlstring= _threeimageary[2]; //营业执照
    }
    if (_idcardup == nil || [_urlstring isNull]) {
        _idcardup = _threeimageary[0]; //身份证正面
    }
    if (_idcarddown == nil || [_urlstring isNull]) {
        _idcarddown = _threeimageary[1]; //身份证背面
    }
    if (_isOn) {
        if ([_serviceLicense isNull] || _serviceLicense == nil) {
            UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"未上传营业执照" preferredStyle:UIAlertControllerStyleAlert];
            __weak UIAlertAction * cancel = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
#pragma mark ----    如果选中服务许可证，但是没上传成功 终止上传  ---
                return ;
            }];
            [alert addAction:cancel];
            [self presentViewController:alert animated:YES completion:nil];
        }
    } else {
        //不用上传服务许可证
        _serviceLicense = @"";
        //        _mySwitch.on = NO;
    }

    if (![bossName isNull] &&![bossIdCardNum isNull] &&![storeName isNull] &&![phoneNum isNull]&&![_idcardup isNull]&&![_idcarddown isNull]&&![_urlstring isNull] && [bossIdCardNum simpleVerifyIdentityCardNum] && [phoneNum isMobileNumber] && ![latitude isNull] && ![lontitude isNull]) {
        [MBProgressHUD showMessage:@"请稍等"];
        //入驻成功前后，上传参数不变
        //入驻前后， 获取参数改变
        //参数变化，如下所示：
        /*   参数名         入驻前（上传参数）            入住后（对应获取参数）

         营业执照        storeLicense                 openZz
         服务许可证       storePermit                 storeLicense
         店主名字        principal                   storeManager
         用户id            id                          userId
         店铺id            无                           storeId


         */
        NSString *keyUrl = nil;
        if (_isJohnedStatus == 1) { //入驻前
            keyUrl = @"inStore";
        } else {
            keyUrl = @"editInStore";
        }
        NSString *uploadUrl = [NSString stringWithFormat:@"%@api/merchant/%@?principal=%@&idCard=%@&storeName=%@&storePhone=%@&address=%@&storeLicense=%@&idCardImgUp=%@&idCardImgDown=%@&storePermit=%@&token=%@&id=%@&lng=%@&lat=%@",kBaseURL,keyUrl,bossName,bossIdCardNum,storeName,phoneNum,mapAddress, _urlstring,_idcardup,_idcarddown,_serviceLicense,_token,_idd, lontitude,latitude];
        if (_isJohnedStatus == 2) { // 多了storeId 参数
            uploadUrl = [NSString stringWithFormat:@"%@api/merchant/%@?storeManager=%@&idCard=%@&storeName=%@&storePhone=%@&address=%@&storeLicense=%@&idCardImgUp=%@&idCardImgDown=%@&storePermit=%@&token=%@&userId=%@&lng=%@&lat=%@&storeId=%@",kBaseURL,keyUrl,bossName,bossIdCardNum,storeName,phoneNum,mapAddress, _urlstring,_idcardup,_idcarddown,_serviceLicense,_token,_idd,lontitude,latitude, storeID];
        }
          
        [[QYXNetTool shareManager] postNetWithUrl:uploadUrl urlBody:nil bodyStyle:QYXBodyString header:nil response:QYXJSON success:^(id result) {
            [MBProgressHUD hideHUD];
            
            if ([result[@"msgType"] isEqualToString:@"0"]) {
                wholeScrollV.contentOffset = CGPointMake(kScreenWidth, 0);
            }
        } failure:^(NSError *error) {
            
            [MBProgressHUD hideHUD];
            //            NSLog(@"lll%@",error);
        }];
    } else {
        UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"信息不能为空" preferredStyle:UIAlertControllerStyleAlert];
        __weak UIAlertAction * cancel = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:nil];
        
        [alert addAction:cancel];
        
        [self presentViewController:alert animated:YES completion:nil];
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
