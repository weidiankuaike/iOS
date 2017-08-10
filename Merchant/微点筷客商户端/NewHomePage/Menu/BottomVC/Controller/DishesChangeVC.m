//
//  DishesChangeVC.m
//  微点筷客商户端
//
//  Created by Skyer God on 16/10/18.
//  Copyright © 2016年 张森森. All rights reserved.
//

#import "DishesChangeVC.h"

#import "DishesInfoSetVC.h"
#import "DishesCollectionReusableView.h"
#import "DishesManageCell.h"
#import "BaseButton.h"
//#import "SelectAlertView.h"
//#import "SingleDeleteAlertView.h"
#import "ZTAlertSheetView.h"
#import <UIImageView+WebCache.h>
#import "QYXNetTool.h"
#import "DishesInfoModel.h"
#import <MJExtension/MJExtension.h>
#import "NSObject+JudgeNull.h"
#import "MJChiBaoziHeader.h"
#import "ZTPopOverMenu.h"
@interface DishesChangeVC ()<UINavigationControllerDelegate, UIImagePickerControllerDelegate, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>
/** 相机背景图   (strong) **/
@property (nonatomic, strong) UIView *cameraView;
/** 拍照button   (strong) **/
@property (nonatomic, strong) ButtonStyle *cameraBT;

/** 弹出遮罩页   (strong) **/
@property (nonatomic, strong) UIView *maskView;

/** 图片路径   (copy) **/
@property (nonatomic, copy) NSString *filePath;
/** 添加菜品后展示CollectV   (strong) **/
@property (nonatomic, strong) UICollectionView *showCollectV;
/** 增加或者删除   (strong) **/
@property (nonatomic, strong) NSMutableIndexSet *selectedIndexSet;

/** 左边上架按钮   (strong) **/
@property (nonatomic, strong) BaseButton *leftUpStairBT;
/** 右边下架按钮   (strong) **/
@property (nonatomic, strong) BaseButton *rightDownStairBT;


/** 确定删除分栏所有项   (strong) **/
@property (nonatomic, strong) UIView *groupDeleteView;
/** 确定删除单个菜品   (strong) **/
@property (nonatomic, strong) UIView *singleDeleteView;

/** 保存删除button的indexPath   (strong) **/
@property (nonatomic, strong) NSIndexPath *deleteIndexPath;


//数据源
@property(nonatomic,strong)NSMutableArray * dataArr;
/** 保存分类信息   (strong) **/
@property (nonatomic, strong) NSMutableArray *categoryArr;
/** 菜品集合   (strong) **/
@property (nonatomic, strong) NSMutableDictionary *allDishesDic;
/** 保存选中后的cell状态   (strong) **/
@property (nonatomic, strong) NSMutableDictionary *selectDic;
/** 当前选中的section  (NSString) **/
@property (nonatomic, assign) NSInteger currentSection;
/** 完成按钮  (NSString) **/
@property (nonatomic, strong) ButtonStyle *submitBT;

/** 展示上下架   (strong) **/
@property (nonatomic, assign) BOOL showDownStair;

/** 上下架选择  (as) **/
@property (nonatomic, assign) BOOL isDownStair;

/** 展示删除   (NSInteger) **/
@property (nonatomic, assign) BOOL showDelete;

/** 保存collectionView item大小 进行压缩   (strong) **/
@property (nonatomic, assign) CGSize currentItemSize;

@end

@implementation DishesChangeVC
{
    UILabel *middleLabel;
    UILabel *secondLabel;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [ReloadVIew registerReloadView:self];
    _isDownStair = YES;
    self.titleView.text = @"菜品管理";
    self.rightBarItem.hidden = NO;
    [self.rightBarItem setImage:[UIImage imageNamed:@"more_point"] forState:UIControlStateNormal];

    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    //    _currentSection = -1;
    //    _dataArr = [NSMutableArray array];
    //    _categoryArr = [NSMutableArray array];
    //    _selectDic = [NSMutableDictionary dictionary];


    [self createBackView];
    [self initWithWholeView];



}
- (void)getData{


    //入驻后，请求
    [_dataArr removeAllObjects];
    NSString *keyUrl = @"api/merchant/searchDishesMgmt";
    NSString *storeId = storeID;
    NSString *offFood = nil;
    if (_isDownStair) {
        offFood = @"0";
    } else {
        offFood = @"1";
    }

    NSString *token = TOKEN;
    NSString *urlUpload = [NSString stringWithFormat:@"%@%@?token=%@&storeId=%@&offFood=%@",kBaseURL, keyUrl, token, storeId,offFood];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];

    [[QYXNetTool shareManager] postNetWithUrl:urlUpload urlBody:nil bodyStyle:QYXBodyString header:nil response:QYXJSON success:^(id result) {
                ZTLog(@"%@", result);
        id obj = result[@"obj"];
        if ([obj isKindOfClass:[NSString class]] && [obj isNull]) {
            [self createPlaceHoloderView];
        } else {
            _currentSection = -1;
            _dataArr = [NSMutableArray array];
            _categoryArr = [NSMutableArray array];
            _selectDic = [NSMutableDictionary dictionary];
            NSArray *categoryArr = result[@"obj"];
            _allDishesDic = [NSMutableDictionary dictionaryWithDictionary:result[@"flag"]];
            [categoryArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                NSString *categoryStr = obj[@"name"];
                NSArray *dishesArr = obj[@"products"];
                [_categoryArr addObject:@{categoryStr:obj[@"id"]}];
                [_dataArr addObject:@{categoryStr:dishesArr}];
            }];
            [_showCollectV reloadData];
        }
        [_showCollectV.mj_header endRefreshing];
        [self createPlaceHoloderView];
        [MBProgressHUD  hideHUDForView:self.view animated:YES];
    } failure:^(NSError *error) {
        [_showCollectV reloadData];
        //        [self createPlaceHoloderView];
        [MBProgressHUD  hideHUDForView:self.view animated:YES];
    }];
   
}
- (void)createPlaceHoloderView{
    if (_categoryArr.count == 0 ) {
        if (middleLabel == nil) {
            middleLabel = [[UILabel alloc] init];
            middleLabel.text = @"当前没有任何菜品上线";
            middleLabel.font = [UIFont systemFontOfSize:17];
            middleLabel.textColor = RGB(150, 150, 150);
            middleLabel.textAlignment = NSTextAlignmentCenter;
            [self.view addSubview:middleLabel];

            middleLabel.sd_layout
            .centerXEqualToView(self.view)
            .centerYIs(self.view.center.y - 15)
            .heightIs(20);
            [middleLabel setSingleLineAutoResizeWithMaxWidth:350];


            secondLabel = [[UILabel alloc] init];
            secondLabel.text = @"快点击发布添加吧";
            secondLabel.font = middleLabel.font;
            secondLabel.textColor = RGB(150, 150, 150);
            secondLabel.textAlignment = NSTextAlignmentCenter;
            [self.view addSubview:secondLabel];

            secondLabel.sd_layout
            .centerXEqualToView(self.view)
            .centerYIs(self.view.center.y + 15)
            .heightIs(20);
            [secondLabel setSingleLineAutoResizeWithMaxWidth:350];
        }
    } else {
        [middleLabel removeFromSuperview];
        [secondLabel removeFromSuperview];
        middleLabel = nil;
    }
}
- (void)createBackView{

    [self createShowCollectionViewView];

    _submitBT = [ButtonStyle buttonWithType:UIButtonTypeCustom];
    [_submitBT setTitle:@"完成" forState:UIControlStateNormal];
    [_submitBT setBackgroundColor:UIColorFromRGB(0xfd7577)];
    _submitBT.hidden = YES;
    [_submitBT addTarget:self action:@selector(clickDelectedButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_submitBT];

    _submitBT.sd_layout
    .leftSpaceToView(self.view, 20)
    .bottomSpaceToView(self.view, 20)
    .rightSpaceToView(self.view, 20)
    .heightIs(35);


}
- (void)leftBarButtonItemAction{
    [self dismissViewControllerAnimated:YES completion:nil];
}
-(void)rightBarButtonItemAction:(ButtonStyle *)sender{
    [self clickDishesManage:sender];
}
- (void)initWithWholeView{
    /** 如果请求数据为空或者刚刚入驻 **/
    self.navigationController.navigationBar.hidden = NO;
    self.tabBarController.tabBar.hidden = YES;

    _cameraView = [[UIView alloc] init];
    _cameraView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_cameraView];

    UIView *backView = [[UIView alloc] init];
    backView.backgroundColor = [UIColor whiteColor];
    [_cameraView addSubview:backView];

    _cameraBT = [ButtonStyle buttonWithType:UIButtonTypeCustom];
    [_cameraBT setBackgroundImage:[UIImage imageNamed:@"添加菜品按钮"] forState:UIControlStateNormal];
    _cameraBT.contentMode = UIViewContentModeScaleAspectFit;
    [_cameraBT addTarget:self action:@selector(camerBTAction:) forControlEvents:UIControlEventTouchUpInside];
    [_cameraView addSubview:_cameraBT];

    _cameraView.sd_layout
    .leftEqualToView(self.view)
    .bottomSpaceToView(self.view, 0)
    .rightEqualToView(self.view)
    .heightIs(_cameraBT.currentBackgroundImage.size.width * 1.7 * 3 / 2);

    backView.sd_layout
    .centerXEqualToView(_cameraView)
    .bottomSpaceToView(_cameraView, 0)
    .widthIs(self.view.size.width);

    UILabel *separatorLIne = [[UILabel alloc] init];
    separatorLIne.backgroundColor = [UIColor lightGrayColor];
    [backView addSubview:separatorLIne];


    ButtonStyle *cameraTitleBT = [ButtonStyle buttonWithType:UIButtonTypeCustom];
    [cameraTitleBT setTitle:@"发布菜品" forState:UIControlStateNormal];
    [cameraTitleBT setTitleColor:RGBA(0, 0, 0, 0.7) forState:UIControlStateNormal];
    [cameraTitleBT.titleLabel setFont:[UIFont systemFontOfSize:13]];
    [backView addSubview:cameraTitleBT];
    [cameraTitleBT addTarget:self action:@selector(camerBTAction:) forControlEvents:UIControlEventTouchUpInside];


    /** 已上架菜品 **/
    _leftUpStairBT = [BaseButton buttonWithType:UIButtonTypeCustom];
    [_leftUpStairBT setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
    [_leftUpStairBT setImage:[UIImage imageNamed:@"菜品上架选中"] forState:UIControlStateNormal];
    [_leftUpStairBT setTitle:@"已上架" forState:UIControlStateNormal];
    //    [_leftUpStairBT setTitleColor:RGBA(0, 0, 0, 0.7) forState:UIControlStateNormal];
    [_leftUpStairBT.titleLabel setFont:[UIFont systemFontOfSize:13]];
    [_leftUpStairBT addTarget:self action:@selector(downOrUpStairClick:) forControlEvents:UIControlEventTouchUpInside];
    _leftUpStairBT.selected = YES;
    [backView addSubview:_leftUpStairBT];

    /** 右边下架菜品 **/

    _rightDownStairBT = [BaseButton buttonWithType:UIButtonTypeCustom];
    [_rightDownStairBT setImage:[UIImage imageNamed:@"菜品下架按钮"] forState:UIControlStateNormal];
    [_rightDownStairBT setTitle:@"已下架" forState:UIControlStateNormal];
    [_rightDownStairBT setTitleColor:RGBA(0, 0, 0, 0.7) forState:UIControlStateNormal];
    _rightDownStairBT.titleLabel.font = _leftUpStairBT.titleLabel.font;
    [_rightDownStairBT addTarget:self action:@selector(downOrUpStairClick:) forControlEvents:UIControlEventTouchUpInside];
    [backView addSubview:_rightDownStairBT];

    separatorLIne.sd_layout
    .leftEqualToView(backView)
    .rightEqualToView(backView)
    .topSpaceToView(backView, 0)
    .heightIs(0.8);

    _leftUpStairBT.sd_layout
    .leftSpaceToView(backView, 20)
    .centerYEqualToView(backView)
    .widthIs(65)
    .heightIs(55);

    _rightDownStairBT.sd_layout
    .rightSpaceToView(backView, 20)
    .centerYEqualToView(backView)
    .widthIs(65)
    .heightIs(55);



    _cameraBT.sd_layout
    .centerXEqualToView(_cameraView)
    .bottomSpaceToView(backView, -_cameraBT.currentBackgroundImage.size.width * 1.7 / 2)
    .widthIs(_cameraBT.currentBackgroundImage.size.width * 1.7)
    .heightEqualToWidth(0);

    [_cameraBT setSd_cornerRadiusFromWidthRatio:@(0.5)];
    cameraTitleBT.sd_layout
    .centerXEqualToView(backView)
    .bottomEqualToView(backView);

    [cameraTitleBT setupAutoSizeWithHorizontalPadding:1 buttonHeight:20];

    [backView setupAutoHeightWithBottomView:_leftUpStairBT bottomMargin:1];
    [_cameraView setupAutoHeightWithBottomViewsArray:@[_cameraBT, backView] bottomMargin:0];

    _leftUpStairBT.Image_X = 14;
    _leftUpStairBT.Image_Y = 6;
    _leftUpStairBT.Title_Space = 10;

    _rightDownStairBT.Image_X = _leftUpStairBT.Image_X;
    _rightDownStairBT.Image_Y = _leftUpStairBT.Image_Y;
    _rightDownStairBT.Title_Space = _leftUpStairBT.Title_Space;

}
//选择筛选上下架菜品
- (void)downOrUpStairClick:(BaseButton *)sender{
    _dataArr = [NSMutableArray new];
    if (sender == _leftUpStairBT) {
        //        NSLog(@"菜品上架");
        _isDownStair = YES;
        [_leftUpStairBT setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
        [_leftUpStairBT setImage:[UIImage imageNamed:@"菜品上架选中"] forState:UIControlStateNormal];
        [_rightDownStairBT setTitleColor:RGBA(0, 0, 0, 0.7) forState:UIControlStateNormal];
        [_rightDownStairBT setImage:[UIImage imageNamed:@"菜品下架按钮"] forState:UIControlStateNormal];

    } else {
        //        NSLog(@"菜品下架");
        _isDownStair = NO;
        [_rightDownStairBT setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
        [_leftUpStairBT setTitleColor:RGBA(0, 0, 0, 0.7) forState:UIControlStateNormal];
        [_leftUpStairBT setImage:[UIImage imageNamed:@"菜品上架"] forState:UIControlStateNormal];
        [_rightDownStairBT setImage:[UIImage imageNamed:@"菜品下架选中"] forState:UIControlStateNormal];
    }
    [self getData];

}

- (void)camerBTAction:(ButtonStyle *)sender{
    NSArray *arr = @[@"拍照",@"图库选取", @"取消"];
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
#pragma mark --- uipaickerViewController delegate   --------------
//当选择一张图片后进入这里
-(void)imagePickerController:(UIImagePickerController*)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{

    NSString *type = [info objectForKey:UIImagePickerControllerMediaType];

    //当选择的类型是图片
    if ([type isEqualToString:@"public.image"])
    {
        //先把图片转成NSData
        //        UIImage* image = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
        UIImage *image = [info valueForKey:UIImagePickerControllerEditedImage];
        UIImage *tempImage = image;
        image = [self OriginImage:image scaleToSize:CGSizeMake(_currentItemSize.width, _currentItemSize.width)];
        NSData *data;
        if (UIImagePNGRepresentation(image) == nil)
        {
            data = UIImageJPEGRepresentation(image, 1);
        }
        else
        {
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
        DishesInfoSetVC *dishesInfoVC = [[DishesInfoSetVC alloc] init];
        dishesInfoVC.image = tempImage;
        dishesInfoVC.filePath = _filePath;
#pragma mark ---  选择图片并且点击完成后的回调设置 --------------------------------- Mark  mark  Mark -------------
        [dishesInfoVC saveClick:^(NSMutableDictionary *dishesInfoDic){
            /** 当传回值后，删除占位视图 **/
            if (dishesInfoDic) {
                [self getData];

            } else {

            }

        }];
#pragma mark   -------------------------------------------------------------------mark   -----------------
        NSMutableArray *keyArrs = [NSMutableArray array];
        [_dataArr enumerateObjectsUsingBlock:^(NSDictionary *obj, NSUInteger idx, BOOL * _Nonnull stop) {

            [keyArrs addObject:[obj.allKeys firstObject]];

        }];

#pragma mark  -----------------跳转信息设置页--------------------
        dishesInfoVC.getKeyArray = [NSMutableArray arrayWithArray:keyArrs];
        dishesInfoVC.allDishesInfoDic = _allDishesDic;
        [self.navigationController pushViewController:dishesInfoVC animated:NO];
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

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)leftBarButtonItemAction:(ButtonStyle *)sender{
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}
-(void)clickDishesManage:(ButtonStyle *)sender{

    ZTPopOverMenuConfiguration *config = [ZTPopOverMenuConfiguration defaultConfiguration];
    config.menuWidth = 110;
    config.allowRoundedArrow = NO;
    config.menuIconMargin = 10;
    config.tintColor = [UIColor whiteColor];
    config.textColor = [UIColor blackColor];
    [ZTPopOverMenu showForSender:sender
                   withMenuArray:@[_isDownStair ? @"下架菜品" : @"上架菜品",@"删除菜品"]
                      imageArray:@[_isDownStair ? @"菜品下架按钮" : @"菜品上架", @"删除菜品按钮"]
                       doneBlock:^(NSInteger selectedIndex) {
                           _cameraView.hidden = YES;
                           _submitBT.hidden = NO;
                           if (selectedIndex == 1) {
                               //        NSLog(@"删除菜品");
                               _showDelete = YES;
                               _showDownStair = NO;
                               [_selectDic removeAllObjects];
                           } else {
                               //        NSLog(@"菜品上下架");
                               _showDownStair = YES;
                               _showDelete = NO;
                           }
                           [_showCollectV reloadData];
                       } dismissBlock:^{

                       }];

}
- (void)createShowCollectionViewView{

    if (_showCollectV == nil) {

        self.automaticallyAdjustsScrollViewInsets = NO;

        CGFloat start_x = 20;
        CGFloat start_y = 20;
        CGFloat row_sapace = 15;
        CGFloat width = (self.view.frame.size.width - start_x * 2 - row_sapace * 2) / 3;

        UICollectionViewFlowLayout *flowL = [[UICollectionViewFlowLayout alloc] init];
        flowL.itemSize = CGSizeMake(width, width + 30);
        self.currentItemSize = flowL.itemSize;
        flowL.minimumInteritemSpacing = 0;
        flowL.minimumLineSpacing = start_y;
        flowL.scrollDirection = UICollectionViewScrollDirectionVertical;
        flowL.sectionInset = UIEdgeInsetsMake(start_y, start_x, 0, start_x);


        _showCollectV = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowL];
        _showCollectV.backgroundColor = [UIColor whiteColor];
        _showCollectV.delegate = self;
        _showCollectV.dataSource = self;
        [self.view addSubview:_showCollectV];
        _showCollectV.mj_header = [MJChiBaoziHeader headerWithRefreshingTarget:self refreshingAction:@selector(getData)];
        [_showCollectV.mj_header beginRefreshing];

        _showCollectV.sd_layout
        .leftEqualToView(self.view)
        .topSpaceToView(self.view, 64)
        .rightEqualToView(self.view)
        .bottomSpaceToView(self.view, 71);

        [_showCollectV registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:NSStringFromClass([UICollectionViewCell class])];
        [_showCollectV registerClass:[DishesCollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:NSStringFromClass([DishesCollectionReusableView class])];
        [_showCollectV registerClass:[DishesManageCell class] forCellWithReuseIdentifier:NSStringFromClass([DishesManageCell class])];

    }
}
#pragma mark ------ collectionView delegate ---------
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    return CGSizeMake(self.view.frame.size.width - 20 * 2, 40);
}
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return _dataArr.count;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if ([[[_dataArr[section] allValues] firstObject] isNull ]) {
        return 0;
    } else
        return [[[_dataArr[section] allValues] firstObject] count];
}
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    if (kind == UICollectionElementKindSectionHeader) {

        DishesCollectionReusableView *headerV = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:NSStringFromClass([DishesCollectionReusableView class]) forIndexPath:indexPath];
        NSString *str = [[_dataArr[indexPath.section] allKeys] firstObject];
        NSMutableAttributedString *att = [[NSMutableAttributedString alloc] initWithString:str];

        //首行缩进
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        paragraphStyle.lineSpacing = 3;    //行间距
        paragraphStyle.firstLineHeadIndent = 8;    /**首行缩进宽度*/
        paragraphStyle.alignment = NSTextAlignmentJustified;
        [att addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:[str rangeOfString:str]];
        headerV.titleLabel.attributedText = att;


        headerV.indexP = indexPath;

        headerV.deleteClick = ^(NSIndexPath *indexP){
            [self deleteSection:indexP];
        };

        if (_showDelete) {
            headerV.selectAllBT.hidden = NO;
        } else {
            headerV.selectAllBT.hidden = YES;
        }
        if (_showDownStair) {
            headerV.selectAllBT.hidden = YES;
        }
        return headerV;
    } else {
        return nil;
    }
}
- (void)deleteSection:(NSIndexPath *)indexP{
#pragma mark --- 删除分类更新 --
    [self uploadNewDishesDataWithIndexP:indexP deleteAllOrSingle:YES];

    [_dataArr removeObjectAtIndex:indexP.section];
    [_showCollectV deleteSections:[NSIndexSet indexSetWithIndex:indexP.section]];
    if (indexP.section  < _dataArr.count) {
        for (NSInteger section = indexP.section; section < _dataArr.count; ++section) {
            DishesCollectionReusableView *headV = (DishesCollectionReusableView *)[_showCollectV supplementaryViewForElementKind:UICollectionElementKindSectionHeader atIndexPath:[NSIndexPath indexPathForItem:0 inSection:section]];
            headV.indexP = [NSIndexPath indexPathForRow:0 inSection:section];

            ItemCount itemsCount = [_showCollectV numberOfItemsInSection:section];
            for (NSInteger item = 0; item < itemsCount; item++) {
                DishesManageCell *cell = (DishesManageCell *)[_showCollectV cellForItemAtIndexPath:[NSIndexPath indexPathForItem:item inSection:section]];
                cell.indexP = [NSIndexPath indexPathForItem:item inSection:section];
            }
        }
    }
}
- (void)deleteItem:(NSIndexPath *)indexP{
    [self uploadNewDishesDataWithIndexP:indexP deleteAllOrSingle:NO];
    //获取当前item数组
    NSArray *arry = [[_dataArr[indexP.section] allValues] firstObject];
    NSMutableArray *mulArr = [arry mutableCopy];
    //删除选中的item
    [mulArr removeObjectAtIndex:indexP.item];
    //在原来的位置插入删除后的item数组字典，更新数据源
    NSString *category =[[_dataArr[indexP.section] allKeys] firstObject];
    [_dataArr insertObject:@{category:mulArr} atIndex:indexP.section];

    //删除旧的item数组
    [_dataArr removeObjectAtIndex:indexP.section + 1];

    [_showCollectV deleteItemsAtIndexPaths:@[[NSIndexPath indexPathForItem:indexP.item inSection:indexP.section]]];

    if (indexP.item  < mulArr.count) {
        for (NSInteger item = indexP.item; item < _dataArr.count; ++item) {
            DishesManageCell *cell = (DishesManageCell *)[_showCollectV cellForItemAtIndexPath:[NSIndexPath indexPathForItem:item inSection:indexP.section]];
            cell.indexP = [NSIndexPath indexPathForItem:item inSection:indexP.section];
        }
    }
}
//菜品删除
- (void)uploadNewDishesDataWithIndexP:(NSIndexPath *)indexP deleteAllOrSingle:(BOOL)isDeleteAll{
    NSString *storeId = storeID;
    //入驻后，请求
    NSString *keyUrl = @"api/merchant/operationDishesMgmt";
    NSString *token = TOKEN;
    NSString *offFood = nil;
    NSString *oldImageUrl = nil;
    // operation 0：增加 1：删除 2.修改
    //offFood 0：未下架 1：下架
    if (_isDownStair) {
        offFood = @"0";
    } else {
        offFood = @"1";
    }
    NSString *operation = @"1";
    NSString *urlUpload = @"";
    NSString *categoryStr = [[_dataArr[indexP.section] allKeys] firstObject];
    //删除分类
    if (isDeleteAll) {
        NSString *categoryId = [[_categoryArr objectAtIndex:indexP.section] objectForKey:categoryStr];
        urlUpload = [NSString stringWithFormat:@"%@%@?token=%@&storeId=%@&offFood=%@&operation=%@&cid=%@&cname=%@", kBaseURL, keyUrl, token, storeId, offFood, operation, categoryId, categoryStr];
    } else {
        //删除单个
        NSArray *arry = [[_dataArr[indexP.section] allValues] firstObject];
        NSDictionary *cellDic = arry[indexP.item];
        DishesInfoModel *cellModel = [DishesInfoModel mj_objectWithKeyValues:cellDic];
        NSString *storeId = cellModel.pstoreId;
        NSString *offFood = cellModel.downStair;
        NSString *pid = cellModel.dishesID;
        NSString *pfee = cellModel.price;
        NSString *images = cellModel.img;
        NSString *note = cellModel.descrpt;
        oldImageUrl = cellModel.img;
        urlUpload = [NSString stringWithFormat:@"%@%@?token=%@&storeId=%@&offFood=%@&operation=%@&pid=%@&pfee=%@&images=%@&note=%@&cname=%@",kBaseURL, keyUrl, token, storeId,offFood, operation, pid, pfee, images, note, categoryStr];

    }
    //
    [MBProgressHUD  showHUDAddedTo:self.view animated:YES];

    [[QYXNetTool shareManager] postNetWithUrl:urlUpload urlBody:nil bodyStyle:QYXBodyString header:nil response:QYXJSON success:^(id result) {
        if ([result[@"msgType"] integerValue] == 0) {
            if (isDeleteAll) {
                if (isDeleteAll) {
                    [_categoryArr removeObjectAtIndex:indexP.section];
                }
            }
        } else {
            [SVProgressHUD showErrorWithStatus:@"操作异常，请重新删除"];
        }

        [MBProgressHUD  hideHUDForView:self.view animated:YES];
    } failure:^(NSError *error) {

    }];
}
//菜品上下架
- (void)uploadDownOrUpStairDishesData:(NSIndexPath *)indexP downOrUpStatus:(BOOL)isDown{
    NSString *storeId = storeID;
    //入驻后，请求
    NSString *keyUrl = @"api/merchant/operationDishesMgmt";
    NSString *token = TOKEN;
    NSString *offFood = nil;
    // operation 0：增加、修改 1：删除
    //offFood 0：未下架 1：下架
    if (isDown) {
        offFood = @"1";
    } else {
        offFood = @"0";
    }
    NSString *operation = @"2";
    NSString *urlUpload = @"";

    NSArray *arry = [[_dataArr[indexP.section] allValues] firstObject];
    NSDictionary *cellDic = arry[indexP.item];
    DishesInfoModel *cellModel = [DishesInfoModel mj_objectWithKeyValues:cellDic];
    NSString *categoryId = cellModel.categoryId;
    NSString *name = cellModel.category;
    NSString *pid = cellModel.dishesID;
    NSString *fee = cellModel.price;
    NSString *dishesName = cellModel.dishesName;
    NSString *images = cellModel.img;
    NSString *note = cellModel.descrpt;

    urlUpload = [NSString stringWithFormat:@"%@%@?token=%@&storeId=%@&offFood=%@&operation=%@&cid=%@&cname=%@&pid=%@&pname=%@&fee=%@&images=%@&note=%@",kBaseURL, keyUrl, token, storeId,offFood, operation, categoryId, name, pid, dishesName, fee, images, note];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];

    [[QYXNetTool shareManager] postNetWithUrl:urlUpload urlBody:nil bodyStyle:QYXBodyString header:nil response:QYXJSON success:^(id result) {

        //        ZTLog(@"%@", result);
        //下架成功之后马上请求，并刷新一次
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [self getData];
    } failure:^(NSError *error) {
        [[MBProgress_GodSkyer shareManager] showWithLabelWithMessage:@"下架失败" inView:self.view];
    }];

}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{

    DishesManageCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([DishesManageCell class]) forIndexPath:indexPath];
    cell.indexP = indexPath;
    cell.backgroundColor = [UIColor whiteColor];
    NSArray *arry = [[_dataArr[indexPath.section] allValues] firstObject];
    NSDictionary *cellDic = arry[indexPath.item];
    DishesInfoModel *cellModel = [DishesInfoModel mj_objectWithKeyValues:cellDic];
    cellModel.allDishesIdDic = _allDishesDic;
    cell.model = cellModel;
    //    [cell.deleteBT addTarget:self action:@selector(showSingleDeleteView:) forControlEvents:UIControlEventTouchUpInside];
    cell.deleteClick = ^(NSIndexPath *indexp){
        [self deleteItem:indexp];
    };

    if (_showDelete) {

        cell.downStairLabel.hidden = YES;
        cell.deleteBT.selected = YES;
        cell.deleteBT.hidden = NO;
    } else {
        cell.deleteBT.hidden = YES;
    }

    if (_showDownStair) {
        if (_isDownStair) {
             cell.downStairLabel.text = @"下架菜品";
        } else {
             cell.downStairLabel.text = @"上架菜品";
        }
        cell.downStairLabel.hidden = NO;
        cell.deleteBT.hidden = YES;
    } else {
        cell.downStairLabel.hidden = YES;
    }
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (_showDelete || _showDownStair) {
        //删除 或者 上下架 处理，暂时放在一块处理  需要再设置一个字典专门存放上下架数目
        [self.selectDic setObject:[NSNumber numberWithBool:YES] forKey:indexPath];
        if (_showDownStair) {
            [self uploadDownOrUpStairDishesData:indexPath downOrUpStatus:_isDownStair];
        }
    } else {
        //如果cell、 没有功能处理，点击后进入详情页，并修改信息
        //1. 把现有信息传给setVC
        NSArray *arry = [[_dataArr[indexPath.section] allValues] firstObject];
        NSDictionary *cellDic = arry[indexPath.item];
        DishesInfoModel *model = [DishesInfoModel mj_objectWithKeyValues:cellDic];
        model.allDishesIdDic = _allDishesDic;
        //        DishesManageCell *cell = (DishesManageCell *)[collectionView cellForItemAtIndexPath:indexPath];

        DishesInfoSetVC *setVc = [[DishesInfoSetVC alloc] init];
        setVc.model = model;
        //        setVc.filePath = _filePath;
        NSMutableArray *keyArrs = [NSMutableArray array];
        [_dataArr enumerateObjectsUsingBlock:^(NSDictionary *obj, NSUInteger idx, BOOL * _Nonnull stop) {

            [keyArrs addObject:[obj.allKeys firstObject]];

        }];
        //传值
        setVc.getKeyArray = [NSMutableArray arrayWithArray:keyArrs];
        //        __weak typeof(cell) weakCell = cell;
        //2. 信息设置完后穿回, 三种情况，>1. 修改分类 >2.没修改分类 >3.没修改，或者修改后没保存直接返回
        [setVc saveClick:^(NSMutableDictionary *dishesInfoDic) {

            if (dishesInfoDic) {
                [self getData];
            }
        }];
        [self.navigationController pushViewController:setVc animated:YES];
    }


    NSLog(@"%@", _selectDic);

}


-(void)clickDelectedButton:(ButtonStyle *)sender{
    if (_showDownStair) {
        //        NSLog(@"下架管理完成");
        _showDownStair = NO;
    }
    if (_showDelete) {
        //        NSLog(@"删除管理完成");
        _showDelete = NO;
    }
    [_showCollectV reloadData];
    _cameraView.hidden = NO;
    sender.hidden = YES;
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
