//
//  JudgeViewController.m
//  wdKuaiKe_iOS
//
//  Created by 张森森 on 17/1/9.
//  Copyright © 2017年 weiDianKuaiKe. All rights reserved.
//

#import "JudgeViewController.h"
#import "UIBarButtonItem+SSExtension.h"
#import "ImagepickerViewController.h"
#import "UIImageView+WebCache.h"
#import "MBProgressHUD+SS.h"
#import "QYXNetTool.h"
#import "StartView.h"
#import "StarGradeView.h"
#import "MyorderViewController.h"
#import "COSImageTool.h"
@interface JudgeViewController ()<StarGradeViewDelegate>

@property (nonatomic,strong)UITextView * feedbackview;
@property (nonatomic,strong)UILabel * pllabel;
@property (nonatomic,strong)NSMutableArray * btntitleary;
@property (nonatomic,strong)NSMutableArray * zanary;
@property (nonatomic,strong)NSMutableArray * collectay;
@property (nonatomic,strong)NSMutableArray * textary;
@property (nonatomic,assign)NSInteger scoreint;
@property (nonatomic,copy)NSString * uploadimagestr;
@property (nonatomic,strong)NSArray * caiAry;
@property (nonatomic,strong)NSMutableArray * judeImageary;//图骗数组
@property (nonatomic,copy)NSString * storeid;
@property (nonatomic,strong)NSMutableArray * uploadImageAry;//上传的图片
/**    (strong) **/
@property (nonatomic, strong) dispatch_group_t groupQueue;
@end

@implementation JudgeViewController

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
   self.navigationController.navigationBar.hidden = NO;
    self.tabBarController.tabBar.hidden = YES;
//    self.navigationController.navigationBar.translucent = NO;
    [self.navigationController.navigationBar setBarTintColor:UIColorFromRGB(0xfd7577)];
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = RGB(238, 238, 238);
    UILabel * titlabel = [[UILabel alloc]init];
    titlabel.frame = CGRectMake(0, 0, 80, 30);
    titlabel.textAlignment = NSTextAlignmentCenter;
    titlabel.font = [UIFont systemFontOfSize:15];
    titlabel.text = @"欢迎评价";
    titlabel.textColor = [UIColor whiteColor];
    self.navigationItem.titleView = titlabel;
    UIBarButtonItem * backbtn = [UIBarButtonItem itemWithTarget:self Action:@selector(Back) image:@"left-1" selectImage:nil];
    self.navigationItem.leftBarButtonItem = backbtn;
    _uploadImageAry = [NSMutableArray array];

    [self getData];
}
- (void)getData
{
    [MBProgressHUD showMessage:@"请稍等"];
    NSString * judestr = [NSString stringWithFormat:@"%@/api/user/evalMyOrder?token=%@&orderId=%@&operation=0",commonUrl,Token,_orderId];
    NSArray * urlAry = [judestr componentsSeparatedByString:@"?"];
    [[QYXNetTool shareManager]postNetWithUrl:urlAry.firstObject urlBody:urlAry.lastObject bodyStyle:QYXBodyString header:nil response:QYXJSON success:^(id result) {
        NSLog(@"judeeeee%@",result);
        [MBProgressHUD hideHUD];
        NSString * msgstr = [NSString stringWithFormat:@"%@",result[@"msgType"]];
        if ([msgstr isEqualToString:@"0"]) {
            NSDictionary * objdict = result[@"obj"];
            _caiAry = objdict[@"orderDets"];
            _namestr = objdict[@"storeName"];
            _imagestr = objdict[@"storeImage"];
            _storeid = objdict[@"storeId"];
        }
        [self Creatfirsttable];
        if (_caiAry.count!=0) {
            
            [self Creatbottomview];

        }
        
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUD];
        [MBProgressHUD showError:@"请求失败"];
    }];
    
}
- (void)Creatfirsttable
{
    UIView * firstview = [[UIView alloc]init];
    firstview.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:firstview];
    firstview.sd_layout.leftEqualToView(self.view).rightEqualToView(self.view).topEqualToView(self.view).heightIs(autoScaleH(420));
    firstview.userInteractionEnabled = YES;
    
    UIImageView * storeimage = [[UIImageView alloc]init];
    [storeimage sd_setImageWithURL:[NSURL URLWithString:_imagestr]placeholderImage:[UIImage imageNamed:@"1"]];
    [firstview addSubview:storeimage];
    storeimage.sd_layout.leftSpaceToView(firstview,autoScaleW(100)).topSpaceToView(firstview,autoScaleH(15)).widthIs(autoScaleW(30)).heightIs(autoScaleW(30));
    
    UILabel * storename = [[UILabel alloc]init];
    storename.text = _namestr;
    storename.textColor = [UIColor lightGrayColor];
    storename.font = [UIFont systemFontOfSize:autoScaleW(13)];
    [firstview addSubview:storename];
    storename.sd_layout.leftSpaceToView(storeimage,autoScaleW(10)).topSpaceToView(firstview,autoScaleH(22)).heightIs(autoScaleH(15));
    [storename setSingleLineAutoResizeWithMaxWidth:300];
    
    UILabel * dafenlabel = [[UILabel alloc]init];
    dafenlabel.text = @"给餐厅打分吧";
    dafenlabel.textColor = [UIColor lightGrayColor];
    dafenlabel.font = [UIFont systemFontOfSize:11];
    [firstview addSubview:dafenlabel];
    dafenlabel.sd_layout.centerXEqualToView(firstview).topSpaceToView(storename,autoScaleH(10)).widthIs(autoScaleW(75)).heightIs(autoScaleH(13));
    
    UILabel * leftline = [[UILabel alloc]init];
    leftline.backgroundColor = [UIColor lightGrayColor];
    [firstview addSubview:leftline];
    leftline.sd_layout.leftSpaceToView(firstview,autoScaleW(10)).rightSpaceToView(dafenlabel,autoScaleW(10)).topSpaceToView(storename,autoScaleH(17)).heightIs(0.5);
    
    UILabel * rightline = [[UILabel alloc]init];
    rightline.backgroundColor = [UIColor lightGrayColor];
    [firstview addSubview:rightline];
    rightline.sd_layout.leftSpaceToView(dafenlabel,autoScaleW(10)).rightSpaceToView(firstview,autoScaleW(10)).topSpaceToView(storename,autoScaleH(17)).heightIs(0.5);
    
    StarGradeView *view = [[StarGradeView alloc] initWithFrame:CGRectMake((GetWidth-5*autoScaleW(35))/2, autoScaleH(80), autoScaleW(35)*5, autoScaleH(25)) withtNumberOfPart:5];
    view.delegate = self;
    [firstview addSubview:view];
    
    NSArray * btntitary = @[@"好吃",@"实惠",@"服务好",@"环境好",@"物美价廉",@"经济实惠",@"品类多",@"地道"];
    
    for (int i =0; i<btntitary.count; i++) {
        
        UIButton * bqbtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [bqbtn setTitle:btntitary[i] forState:UIControlStateNormal];
        
        [bqbtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        [bqbtn setTitleColor:UIColorFromRGB(0xfd7577) forState:UIControlStateSelected];
        bqbtn.tag = 600 + i;
        bqbtn.layer.masksToBounds = YES;
        bqbtn.layer.cornerRadius = 3;
        bqbtn.layer.borderWidth = 1;
        bqbtn.layer.borderColor = [UIColor lightGrayColor].CGColor;
        bqbtn.titleLabel.font = [UIFont systemFontOfSize:autoScaleW(15)];
        [bqbtn addTarget:self action:@selector(Biaoqian:) forControlEvents:UIControlEventTouchUpInside];
        [firstview addSubview:bqbtn];
        bqbtn.sd_layout.leftSpaceToView(firstview,autoScaleW(15)+i%4*((GetWidth - 20)/4)).topSpaceToView(dafenlabel, autoScaleH(65)+i/4*(40)).widthIs((GetWidth - autoScaleW(20))/4 - autoScaleW(10)).heightIs(autoScaleH(30));
        [_btntitleary addObject:bqbtn];
    }
    _feedbackview = [[UITextView alloc]init];
    _feedbackview.font = [UIFont systemFontOfSize:autoScaleW(13)];
    _feedbackview.layer.borderWidth = 1;
    _feedbackview.layer.borderColor = [UIColor lightGrayColor].CGColor;
    _feedbackview.delegate = self;
    [firstview addSubview:_feedbackview];
    _feedbackview.sd_layout.leftSpaceToView(firstview,autoScaleW(15)).rightSpaceToView(firstview,autoScaleW(15)).topSpaceToView(dafenlabel,autoScaleH(65)+autoScaleH(80)+10).heightIs(autoScaleH(100));
    _pllabel = [[UILabel alloc]init];
    _pllabel.enabled = NO;
    _pllabel.text = @"说说你对餐厅的印象，吐槽也无妨...";
    _pllabel.font =[UIFont systemFontOfSize:autoScaleW(13)];
    _pllabel.backgroundColor = [UIColor clearColor];
    CGSize size = [_pllabel.text sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:_pllabel.font,NSFontAttributeName, nil]];
    CGFloat wind = size.width;
    [_feedbackview addSubview:_pllabel];
    _pllabel.sd_layout.leftSpaceToView(_feedbackview,10).topSpaceToView(_feedbackview,autoScaleH(10)).widthIs(wind).heightIs(autoScaleH(15));
    
//    UITapGestureRecognizer * tap1 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(Remove)];
//    [self.view addGestureRecognizer:tap1];
    
    ImagepickerViewController * imagepickview = [[ImagepickerViewController alloc]init];
    imagepickview.storeid = _storeid;
    imagepickview.block = ^(NSMutableArray * imageary){
        
        _judeImageary = imageary;
    };
    
    imagepickview.view.frame = CGRectMake(autoScaleW(15), autoScaleH(65)+autoScaleH(80)+autoScaleH(10)+autoScaleH(65)+autoScaleH(110), GetWidth, 150);
        [firstview addSubview:imagepickview.view];
    [self addChildViewController:imagepickview];
    
    _btntitleary = [NSMutableArray array];
    _zanary = [NSMutableArray array];
    _collectay = [NSMutableArray array];
    _textary = [NSMutableArray array];
 }
#pragma mark 底部视图
-(void)Creatbottomview
{
    UIScrollView * bottomview = [[UIScrollView alloc]init];
    bottomview.backgroundColor = [UIColor whiteColor];
    bottomview.contentSize = CGSizeMake(0, _caiAry.count*autoScaleH(30)+autoScaleH(30));
    [self.view addSubview:bottomview];
    bottomview.sd_layout.leftEqualToView(self.view).rightEqualToView(self.view).topSpaceToView(self.view,autoScaleH(420)).heightIs(self.view.frame.size.height - autoScaleH(420)-autoScaleH(50));
    

    UILabel * dafenlabel = [[UILabel alloc]init];
    dafenlabel.text = @"点评一下吧";
    dafenlabel.textColor = [UIColor lightGrayColor];
    dafenlabel.font = [UIFont systemFontOfSize:11];
    [bottomview addSubview:dafenlabel];
    dafenlabel.sd_layout.centerXEqualToView(bottomview).topSpaceToView(bottomview,autoScaleH(10)).widthIs(autoScaleW(75)).heightIs(autoScaleH(13));
    
    
    UILabel * leftline = [[UILabel alloc]init];
    leftline.backgroundColor = [UIColor lightGrayColor];
    [bottomview addSubview:leftline];
    leftline.sd_layout.leftSpaceToView(bottomview,autoScaleW(10)).rightSpaceToView(dafenlabel,autoScaleW(10)).topSpaceToView(bottomview,autoScaleH(17)).heightIs(0.5);
    
    
    UILabel * rightline = [[UILabel alloc]init];
    rightline.backgroundColor = [UIColor lightGrayColor];
    [bottomview addSubview:rightline];
    rightline.sd_layout.leftSpaceToView(dafenlabel,autoScaleW(10)).rightSpaceToView(bottomview,autoScaleW(10)).topSpaceToView(bottomview,autoScaleH(17)).heightIs(0.5);

    for (int i=0; i<_caiAry.count; i++)
    {
        
        UIView * caidanlabel = [[UIView alloc]init];
        [bottomview addSubview:caidanlabel];
        caidanlabel.sd_layout.leftSpaceToView(bottomview,autoScaleW(15)).topSpaceToView(leftline,autoScaleH(15)+i*autoScaleH(30)).widthIs(GetWidth-autoScaleW(30)).heightIs(autoScaleH(20));
        
        UILabel * namelabel = [[UILabel alloc]init];
        namelabel.text = _caiAry[i][@"productName"];
        namelabel.font = [UIFont systemFontOfSize:autoScaleW(13)];
        namelabel.textColor = [UIColor lightGrayColor];
        [caidanlabel addSubview:namelabel];
        namelabel.sd_layout.leftSpaceToView(caidanlabel,autoScaleW(28)).topSpaceToView(caidanlabel,0).widthIs(autoScaleW(150)).heightIs(autoScaleH(15));
        
        UIButton * zanbtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [zanbtn setBackgroundImage:[UIImage imageNamed:@"赞1"] forState:UIControlStateNormal];
        [zanbtn setBackgroundImage:[UIImage imageNamed:@"赞"] forState:UIControlStateSelected];
        zanbtn.tag = 1000 + i ;
        [zanbtn addTarget:self action:@selector(Zan:) forControlEvents:UIControlEventTouchUpInside];
        [caidanlabel addSubview:zanbtn];
        zanbtn.sd_layout.leftSpaceToView(namelabel,autoScaleW(40)).topSpaceToView(caidanlabel,2).widthIs(autoScaleW(20)).heightIs(autoScaleH(15));
        
        UIButton * collectbtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [collectbtn setBackgroundImage:[UIImage imageNamed:@"收藏2"] forState:UIControlStateNormal];
        [collectbtn setBackgroundImage:[UIImage imageNamed:@"收藏1"] forState:UIControlStateSelected];
        NSString * collect = [NSString stringWithFormat:@"%@",_caiAry[i][@"isCollected"]];
        if ([collect isEqualToString:@"1"]) {
            
            collectbtn.selected = YES;
        }
        collectbtn.tag = 1500 + i;
        [collectbtn addTarget:self action:@selector(Collect:) forControlEvents:UIControlEventTouchUpInside];
        [caidanlabel addSubview:collectbtn];
        collectbtn.sd_layout.rightSpaceToView(caidanlabel,autoScaleW(28)).topSpaceToView(caidanlabel,2).widthIs(autoScaleW(20)).heightIs(autoScaleH(15));
    }
    UIButton * tijiaobtn = [UIButton buttonWithType:UIButtonTypeCustom];
    tijiaobtn.backgroundColor = UIColorFromRGB(0xfd7577);
    [tijiaobtn setTitle:@"提交评价" forState:UIControlStateNormal];
    [tijiaobtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    tijiaobtn.titleLabel.font = [UIFont systemFontOfSize:autoScaleW(15)];
    [tijiaobtn addTarget:self action:@selector(Tijiao) forControlEvents:UIControlEventTouchUpInside];
    tijiaobtn.layer.cornerRadius = 3;
    [self.view addSubview:tijiaobtn];
    tijiaobtn.sd_layout.leftSpaceToView(self.view,autoScaleW(15)).rightSpaceToView(self.view,autoScaleW(15)).bottomSpaceToView(self.view,autoScaleH(10)).heightIs(autoScaleH(30));
    
}
#pragma mark 标签
-(void)Biaoqian:(UIButton *)btn
{
    NSString *selectName = btn.titleLabel.text;
    if ([_btntitleary containsObject:selectName]) {
        [_btntitleary removeObject:selectName];
    } else {
        [_btntitleary addObject:selectName];
    }
            if (btn.selected ==NO) {
                
                btn.selected = YES;
                [btn setTitleColor:UIColorFromRGB(0xfd7577) forState:UIControlStateNormal];
                btn.layer.borderColor = UIColorFromRGB(0xfd7577).CGColor;
                
            }
            else
            {
                btn.selected = NO;
                [btn setTitleColor:[UIColor lightGrayColor]forState:UIControlStateNormal];
                btn.layer.borderColor = [UIColor lightGrayColor].CGColor;

            }
    
    
}
#pragma mark 判断提示词的消失
-(void)textViewDidChange:(UITextView *)textView
{
    if (textView.text.length ==0) {
        
        _pllabel.text = @"请留下您的宝贵意见和建议，我们将努力改进";
    }
    else
    {
        _pllabel.text = @"";
    }
}
#pragma mark 取消键盘
-(void)Remove
{
    [self.view endEditing:YES];
}
#pragma mark 点赞
- (void)Zan:(UIButton * )btn
{
    btn.selected = !btn.selected;
    
    NSString * idstr = _caiAry[btn.tag - 1000][@"productId"];
    
    if (btn.selected ==YES)
    {
        [_zanary addObject:idstr];
    }
    else
    {
        [_zanary removeObject:idstr];
    }
}
#pragma mark 收藏
-(void)Collect:(UIButton * )btn
{
    NSString * string = _caiAry[btn.tag-1500][@"productId"];
    [MBProgressHUD showMessage:@"请稍等"];
    
    NSString * urlstr = [NSString stringWithFormat:@"%@/api/user/myCollectManage?token=%@&userId=%@&storeId=%@&operation=1&productld=%@",commonUrl,Token,Userid,_model.storeid,string];
    
    NSArray * urlary = [urlstr componentsSeparatedByString:@"?"];
    
    [[QYXNetTool shareManager]postNetWithUrl:urlary.firstObject urlBody:urlary.lastObject bodyStyle:QYXBodyString header:nil response:QYXJSON success:^(id result){
        [MBProgressHUD hideHUD];
        NSLog(@"lallalla%@",result);
        NSString * typestr = [NSString stringWithFormat:@"%@",[result objectForKey:@"msgType"]];
        if ([typestr isEqualToString:@"0"]) {
            
            if (btn.selected == NO) {
                btn.selected = YES;
                [MBProgressHUD showSuccess:@"收藏成功"];
            }
            else
            {
                btn.selected = NO;
                [MBProgressHUD showSuccess:@"取消成功"];
            }
        }
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUD];
        [MBProgressHUD showError:@"收藏失败"];
    }];
    
}
#pragma mark 提交
-(void)Tijiao
{
    __weak NSString * love;
    __weak NSString * tag;
    static NSString * imagestr;
    if (_scoreint!=nil&&_scoreint!=0) {
        
        if (_zanary.count!=0) {
            NSString * lovestr = [_zanary componentsJoinedByString:@","];
            love = [NSString stringWithFormat:@"%@,",lovestr];
        }
        else{
            love = @"";
        }
        
        if (_btntitleary.count!=0) {
            NSString * tagstr = [_btntitleary componentsJoinedByString:@","];
            tag = [NSString stringWithFormat:@"%@,",tagstr];
        }else{
            tag = @"";
        }
        
        if (_judeImageary.count!=0) {
            _groupQueue = dispatch_group_create();
            dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
            
            for (UIImage * image in _judeImageary) {
                dispatch_group_async(_groupQueue, queue, ^{
                    dispatch_group_enter(_groupQueue);
                    UIImage * uploadimage = [self OriginImage:image scaleToSize:CGSizeMake(90, 90)];
                    [self upDeloadWithimage:uploadimage];//上传图片
                });
                
                }
            dispatch_group_notify(_groupQueue, dispatch_get_main_queue(),^{
                //全部上传完，继续上传别的
                NSString * imager = [_uploadImageAry componentsJoinedByString:@","];
                imagestr = [NSString stringWithFormat:@"%@,",imager];
                
                
                [MBProgressHUD showMessage:@"请稍等"];
                
                NSString * urlstr = [NSString stringWithFormat:@"%@/api/user/evalMyOrder?token=%@&orderId=%@&tag=%@&loveFoodIds=%@&score=%d&content=%@&evalImage=%@&operation=1",commonUrl,Token,_orderId,tag,love,_scoreint,_feedbackview.text,imagestr];
                
                NSArray * urlary = [urlstr componentsSeparatedByString:@"?"];
                
                [[QYXNetTool shareManager]postNetWithUrl:urlary.firstObject urlBody:urlary.lastObject bodyStyle:QYXBodyString header:nil response:QYXJSON success:^(id result)
                 {
                     [MBProgressHUD hideHUD];
                     NSLog(@"judeee%@",result);
                     NSString * msgstr = [NSString stringWithFormat:@"%@",result[@"msgType"]];
                     if ([msgstr isEqualToString:@"0"]) {
                         
                         for (UIViewController * view in self.navigationController.viewControllers) {
                             if ([view isKindOfClass:[MyorderViewController class]]) {
                                 
                                 [self.navigationController popToViewController:view animated:YES];
                             }
                         }
                     }
                     
                 } failure:^(NSError *error)
                 {
                     [MBProgressHUD hideHUD];
                     [MBProgressHUD showError:@"网络错误"];
                     
                 }];
                

                
                
            });
           }
        else{
            imagestr = @"";

        }
        

    }else{
        
        [MBProgressHUD showError:@"给个评分吧"];
    }
    
    
}
#pragma mark 星星评分
- (void)didSelectedIndex:(NSString *)index{
    if ([index integerValue]>5) {
        index = @"5";
    }else if ([index integerValue]<0){
        index = @"0";
    }
    _scoreint = [index integerValue];
    
}

//压缩图片
-(UIImage*) OriginImage:(UIImage *)image scaleToSize:(CGSize)size
{
    // 下面方法，第一个参数表示区域大小。第二个参数表示是否是非透明的。如果需要显示半透明效果，需要传NO，否则传YES。第三个参数就是屏幕密度了
    UIGraphicsBeginImageContextWithOptions(size, NO, [UIScreen mainScreen].scale);
    
    [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
    
    UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return scaledImage;   //返回的就是已经改变的图片
}

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
    static NSString* imageName;
    dispatch_sync(dispatch_get_main_queue(), ^{
        NSString * datestr = [NSString stringWithFormat:@"%lf",[[NSDate dateWithTimeIntervalSinceNow:0] timeIntervalSince1970] * 10000000 + arc4random() % 100000000];
        imageName = [NSString stringWithFormat:@"/sen%@.png",datestr];
    });
    
    [fileManager createDirectoryAtPath:DocumentsPath withIntermediateDirectories:YES attributes:nil error:nil];
    [fileManager createFileAtPath:[DocumentsPath stringByAppendingString:imageName] contents:data attributes:nil];
    
    //得到选择后沙盒中图片的完整路径
    NSString *filePath = [[NSString alloc]initWithFormat:@"%@%@",DocumentsPath,imageName];
    NSString * dicr = [NSString stringWithFormat:@"judge/%@", _storeid];
    
    NSLog(@"<><><><///////////////%@",filePath);
    [[COSImageTool shareManager] uploadImageWithPath:filePath directory:dicr attrs:nil success:^(COSObjectUploadTaskRsp *rsp) {
        
        NSLog(@"<><><.%@",rsp.sourceURL);
        [_uploadImageAry addObject:rsp.sourceURL];
        dispatch_group_leave(_groupQueue);
        
    } progress:^(int64_t bytesWritten, int64_t totalBytesWritten, int64_t totalBytesExpectedToWrite) {
        
        
        } error:^(NSInteger retCode) {
        dispatch_group_leave(_groupQueue);
    }];
    
}


-(void)Back
{
    
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
