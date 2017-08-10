//
//  AddressSetFromMapVC.m
//  微点筷客商户端
//
//  Created by Skyer God on 16/11/8.
//  Copyright © 2016年 张森森. All rights reserved.
//

#import "AddressSetFromMapVC.h"
#import <AMapSearchKit/AMapSearchKit.h>
#import <AMapFoundationKit/AMapFoundationKit.h>
#import <MAMapKit/MAMapKit.h>

@interface AddressSetFromMapVC ()<AMapSearchDelegate, MAMapViewDelegate, UIGestureRecognizerDelegate, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate>
//创建搜索管理对象
@property (nonatomic, strong)  AMapSearchAPI *search;
/** 高德地图   (strong) **/
@property (nonatomic, strong) MAMapView *mapView;
//保存当前位置信息
@property (nonatomic,retain) MAUserLocation *currentLocation;
/** 中心大头针的位置   (strong) **/
@property (nonatomic, strong) UIImageView *imageV;

/** 当前搜索的位置   (strong) **/
@property (nonatomic,retain) AMapPOI *currentPOI;

/** 当前的位置信息展示**/
@property (nonatomic, strong) UILabel *currentLabel;
/** 展示数据   (strong) **/
@property (nonatomic, strong) UITableView *addressListTableV;
/** 保存大头针位置检索信息   (strong) **/
@property (nonatomic, strong) NSMutableArray *addressListArr;
/** 初始化searchBar   (strong) **/
@property (nonatomic, strong) UISearchBar *searchBar;
/** 搜索状态   (ass) **/
@property (nonatomic, assign) BOOL isSearch;
/** 当前城市   (strong) **/
@property (nonatomic, copy)  NSString *currentCity;
/** 展示搜索提示信息   (strong) **/
@property (nonatomic, strong) UITableView *searchTableV;
/** 保存搜索提示信息   (strong) **/
@property (nonatomic, strong) NSMutableArray *searchListArr;


/** 当前位置信息   (strong) **/
@property (nonatomic, assign) CLLocationCoordinate2D currentLocationPostion;
@end

@implementation AddressSetFromMapVC
-(MAMapView *)mapView{

    if (!_mapView) {
        _mapView = [[MAMapView alloc] initWithFrame:CGRectMake(0, 20, self.view.frame.size.width, 270)];
        _mapView.delegate = self;
        _mapView.showsUserLocation = YES;    //YES 为打开定位，NO为关闭定位
        ////
        [_mapView setUserTrackingMode: MAUserTrackingModeFollow animated:NO]; //地图跟着位置移动
        //
        //
        ///地图需要v4.5.0及以上版本才必须要打开此选项（v4.5.0以下版本，需要手动配置info.plist）
        [AMapServices sharedServices].enableHTTPS = YES;
        //        //后台定位
        _mapView.pausesLocationUpdatesAutomatically = YES;
        //
        _mapView.desiredAccuracy = kCLLocationAccuracyBest;
        _mapView.headingFilter = 30;
        _mapView.distanceFilter = 3;
        _mapView.showsUserLocation = YES;
        _mapView.userTrackingMode = MAUserTrackingModeFollow;
        [_mapView setZoomLevel:13];

    }
    return _mapView;
}
-(UITableView *)addressListTableV{
    if (!_addressListTableV) {
        _addressListTableV = [[UITableView alloc] init];
        _addressListTableV.delegate = self;
        _addressListTableV.dataSource = self;

    }
    return _addressListTableV;
}

- (UITableView *)searchTableV{
    if (!_searchTableV) {
        _searchTableV = [[UITableView alloc] init];
        _searchTableV.delegate = self;
        _searchTableV.dataSource = self;
        [self.view addSubview:_searchTableV];
        _searchTableV.sd_layout
        .leftSpaceToView(self.view, 0)
        .topSpaceToView(self.view, 64 + _searchBar.frame.size.height)
        .rightEqualToView(self.view)
        .bottomEqualToView(self.view);
        _searchTableV.hidden = YES;
    }
    return _searchTableV;
}

- (UIImageView *)imageV{
    if (!_imageV) {
        _imageV = [[UIImageView alloc] initWithFrame:CGRectZero];
        _imageV.image = [UIImage imageNamed:@"定位"];
        _imageV.frame = CGRectMake(0, 0, _imageV.image.size.width, _imageV.image.size.height);
    }
    return _imageV;
}

- (UISearchBar *)searchBar{
    if (!_searchBar) {
        _searchBar = [[UISearchBar alloc] init];
        _searchBar.delegate = self;
        _searchBar.placeholder = @"输入位置信息查询";
        _searchBar.showsCancelButton = NO;
        [_mapView addSubview:_searchBar];

        _searchBar.sd_layout
        .leftSpaceToView(_mapView, 0)
        .topSpaceToView(_mapView, 64 - _mapView.origin.y)
        .rightSpaceToView(_mapView, 0)
        .heightIs(45);

    }
    return _searchBar;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    self.addressListArr = [NSMutableArray array];
    self.searchListArr = [NSMutableArray array];
    //初始化视图
    [self initwithMapView];
    //搜索功能
    [self initwithSearch];
}
- (void)initwithMapView{
    //地图
    self.mapView.backgroundColor = [UIColor redColor];
    [self.view addSubview:_mapView];
    //中心固定的大头针
    self.imageV.backgroundColor = [UIColor clearColor];
    [_mapView addSubview:_imageV];
//    _mapView.centerCoordinate = _mapView.userLocation.coordinate;
    _imageV.center = _mapView.center;
    _imageV.hidden = _mapView.showsUserLocation;
    UIView *backView = [[UIView alloc] init];
    backView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:backView];

    UIImageView *imageV = [[UIImageView alloc] init];
    imageV.image = [UIImage imageNamed:@"定位"];
    [backView addSubview:imageV];

    ButtonStyle *button = [ButtonStyle buttonWithType:UIButtonTypeCustom];
    [button setTitle:@"[当前]" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [button.titleLabel setFont:[UIFont systemFontOfSize:14]];
    [button addTarget:self action:@selector(locationButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [backView addSubview:button];

    _currentLabel = [[UILabel alloc] init];
    _currentLabel.font = button.titleLabel.font;
    [backView addSubview:_currentLabel];
    backView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    backView.layer.borderWidth = 0.8;

    backView.sd_layout
    .leftEqualToView(self.view)
    .topSpaceToView(_mapView, 0)
    .rightEqualToView(self.view)
    .heightIs(40);

    imageV.sd_layout
    .leftSpaceToView(backView, 7)
    .centerYEqualToView(backView)
    .widthIs(imageV.image.size.width * 0.7)
    .heightIs(imageV.image.size.height * 0.7);

    button.sd_layout
    .leftSpaceToView(imageV, 3)
    .centerYEqualToView(backView);
    [button setupAutoSizeWithHorizontalPadding:1 buttonHeight:30];

    _currentLabel.sd_layout
    .leftSpaceToView(button, 1)
    .centerYEqualToView(backView)
    .heightIs(30);
    [_currentLabel setSingleLineAutoResizeWithMaxWidth:320];


    //创建tableView 展示数据列表
    self.addressListTableV.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_addressListTableV];


    self.addressListTableV.sd_layout
    .leftEqualToView(backView)
    .topSpaceToView(backView, 0)
    .rightEqualToView(backView)
    .bottomSpaceToView(self.view, 0);


    //初始化searchBar
    self.searchBar.backgroundColor = [UIColor whiteColor];


}
- (void)initwithSearch{
    //高德搜索对象
    self.search = [[AMapSearchAPI alloc] init];
    self.search.delegate = self;

    //地理编码
    AMapGeocodeSearchRequest *geo = [[AMapGeocodeSearchRequest alloc] init];
//    geo.address = _targetAddress;
    [self.search AMapGeocodeSearch:geo];



}

#pragma mark --map delegate ---
//监听地图偏移量
- (void)mapView:(MAMapView *)mapView mapDidMoveByUser:(BOOL)wasUserAction{
    _imageV.hidden = NO;
    if (wasUserAction) {
        _mapView.showsUserLocation = NO;
    }
    CLLocationCoordinate2D coordinate = [_mapView convertPoint:_imageV.center toCoordinateFromView:_mapView];
    NSLog(@"%lf, %lf", coordinate.longitude, coordinate.latitude);
#pragma mark -----你地理编码 ---
    AMapReGeocodeSearchRequest *regeo = [[AMapReGeocodeSearchRequest alloc] init];
    regeo.location = [AMapGeoPoint locationWithLatitude:coordinate.latitude longitude:coordinate.longitude];
    regeo.radius = 1000;
    regeo.requireExtension = YES;
    //发起逆地理编码
    [self.search AMapReGoecodeSearch: regeo];

    //需求变动 ， 当需要根据省市区来定位模糊位置的时候，用这个
    _currentLocationPostion = coordinate;


#pragma mark -=- 周边检索 --
    /** 周边检索 **/
    AMapPOIAroundSearchRequest *aroundRequest = [[AMapPOIAroundSearchRequest alloc] init];
    aroundRequest.location = [AMapGeoPoint locationWithLatitude:coordinate.latitude longitude:coordinate.longitude];
    //按照距离排序
    aroundRequest.sortrule = 0;
    aroundRequest.radius = 1000;
    aroundRequest.requireExtension = YES;
    [self.search AMapPOIAroundSearch:aroundRequest];


}
//监听用户位置更新
-(void)mapView:(MAMapView *)mapView didUpdateUserLocation:(MAUserLocation *)userLocation updatingLocation:(BOOL)updatingLocation{
    _mapView.centerCoordinate = _mapView.userLocation.coordinate;
    _mapView.showsUserLocation = NO;
    if(updatingLocation) {
        //        //取出当前位置的坐标
        //        NSLog(@"%f,%f,%@",userLocation.coordinate.latitude,userLocation.coordinate.longitude,userLocation.title);
        _currentLocationPostion = userLocation.coordinate;
    }
}
/** 地理位置解码 **/
- (void)onGeocodeSearchDone:(AMapGeocodeSearchRequest *)request response:(AMapGeocodeSearchResponse *)response
{
    if (response.geocodes.count == 0) {
        return;
    }

    CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(response.geocodes.firstObject.location.latitude, response.geocodes.firstObject.location.longitude);
    //解析response获取地理信息
    NSLog(@"%@", response.geocodes.firstObject.location);
    self.mapView.centerCoordinate = coordinate;
}
//实现逆地理编码的回调函数
- (void)onReGeocodeSearchDone:(AMapReGeocodeSearchRequest *)request response:(AMapReGeocodeSearchResponse *)response
{

    if(response.regeocode != nil)
    {
        //通过AMapReGeocodeSearchResponse对象处理搜索结果
        NSString *result = [NSString stringWithFormat:@"ReGeocode: %@", response.regeocode];
        NSLog(@"ReGeo: %@", result);

        _currentLabel.text = [response.regeocode.addressComponent.district  stringByAppendingString:response.regeocode.addressComponent.township];
    }
}
/** 输入提示回调 **/
-(void)onInputTipsSearchDone:(AMapInputTipsSearchRequest *)request response:(AMapInputTipsSearchResponse *)response{
    if (response.tips.count == 0) {
        return;
    }

    [response.tips enumerateObjectsUsingBlock:^(AMapTip * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj.address isEqualToString:@""]) {
            obj.address = @" ";
        }
        if (obj.name == nil) {
            obj.name = @"  ";
        }

        if (obj.location == nil) {
//            ZTLog(@"%@,%@", obj.name, obj.location);
        } else {
            [_searchListArr addObject:@{@"name":obj.name, @"address":obj.address, @"location":obj.location}];
        }
    }];

    [_searchTableV reloadData];

}

/* POI 搜索回调. */
/* POI 搜索回调. */

- (void)onPOISearchDone:(AMapPOISearchBaseRequest *)request response:(AMapPOISearchResponse *)response
{
    if (response.pois.count == 0)
    {
        return;
    }
    //解析response获取POI信息
    NSMutableArray *addressArray = [NSMutableArray array];
    [response.pois enumerateObjectsUsingBlock:^(AMapPOI * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {

        if ([obj.address isEqualToString:@""]) {
            obj.address = @" ";
        }
        if (obj.name == nil) {
            obj.name = @"  ";
        }
        if (obj.location == nil) {
//            ZTLog(@"%@,%@,%@", obj.name, obj.address, obj.location);
        } else {
            [addressArray addObject:@{@"name":obj.name, @"address":obj.address, @"location":obj.location}];
        }
    }];

    _addressListArr = [NSMutableArray arrayWithArray:addressArray];
    [_addressListTableV reloadData];

}

#pragma mark -- 添加大头针  --
/** 添加大头针 **/
- (void)addAnnotation{
    MAPointAnnotation *pointAnnotation = [[MAPointAnnotation alloc] init];
    pointAnnotation.coordinate = _currentLocation.coordinate;
    pointAnnotation.coordinate = CLLocationCoordinate2DMake(_currentPOI.location.latitude, _currentPOI.location.longitude);
    pointAnnotation.title = _currentPOI.name;
    pointAnnotation.subtitle = _currentPOI.address;
    [_mapView addAnnotation:pointAnnotation];
    [_mapView selectAnnotation:pointAnnotation animated:YES];

}
/** 大头针的回调处理 **/
- (MAAnnotationView *)mapView:(MAMapView *)mapView viewForAnnotation:(id<MAAnnotation>)annotation{
    /** 自定义的userloCation对应的annotationView **/
    if ([annotation isKindOfClass:[MAUserLocation class]]) {
        static NSString *userLocationStyleReuseIndetifier = @"userLocationStyleReuseIndetifier";
        MAAnnotationView *annotationView = [mapView dequeueReusableAnnotationViewWithIdentifier:userLocationStyleReuseIndetifier];
        if (annotationView == nil) {
            annotationView = [[MAAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:userLocationStyleReuseIndetifier];
        }
        annotationView.image = [UIImage imageNamed:@"定位"];
        return annotationView;
    }
    /** 大头针 **/
    if ([annotation isKindOfClass:[MAPointAnnotation class]]) {
        static NSString *pointReuseIndentifier = @"pointReuseIndentifier";
        MAPinAnnotationView*annotationView = (MAPinAnnotationView*)[mapView dequeueReusableAnnotationViewWithIdentifier:pointReuseIndentifier];
        if (annotationView == nil)
        {
            annotationView = [[MAPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:pointReuseIndentifier];
        }

        annotationView.image = [UIImage imageNamed:@"目的地"];
        //        annotationView.canShowCallout= YES;       //设置气泡可以弹出，默认为NO
        //        annotationView.animatesDrop = YES;        //设置标注动画显示，默认为NO
        //        annotationView.draggable = YES;        //设置标注可以拖动，默认为NO
        //        annotationView.pinColor = MAPinAnnotationColorPurple;

        return annotationView;
    }
    return nil;
}
#pragma mark -- tableV delegate --------
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView == _searchTableV) {
        if (_searchListArr.count == 0) {
            return 1;
        }
        return _searchListArr.count;
    } else
    return _addressListArr.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{


    static NSString *str = @"addressListCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:str];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:str];
    }
    if (tableView == _searchTableV) {
        if (_searchListArr.count == 0) {
            cell.textLabel.text = @"未查找到位置信息";
        } else {
            cell.textLabel.text = _searchListArr[indexPath.row][@"name"];
            cell.detailTextLabel.text = _searchListArr[indexPath.row][@"address"];
        }
    } else {
        cell.textLabel.text = _addressListArr[indexPath.row][@"name"];
        cell.detailTextLabel.text = _addressListArr[indexPath.row][@"address"];
    }

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == _searchTableV) {
        if (_searchListArr.count == 0) {
            return;
        } else{
            AMapGeoPoint *geo = _searchListArr[indexPath.row][@"location"];
            self.address([_searchListArr[indexPath.row][@"name"] stringByAppendingString:_searchListArr[indexPath.row][@"address"]], CLLocationCoordinate2DMake(geo.latitude, geo.longitude));
        }

    } else {
        AMapGeoPoint *geo = _addressListArr[indexPath.row][@"location"];
        self.address([_addressListArr[indexPath.row][@"name"] stringByAppendingString:_addressListArr[indexPath.row][@"address"]], CLLocationCoordinate2DMake(geo.latitude, geo.longitude));
    }


    [self.navigationController popViewControllerAnimated:YES];
}

-(void)returnAddressFromMap:(returnMapAddress)mapAddress{
    self.address = mapAddress;
}
- (void)locationButtonAction:(ButtonStyle *)sender{
    _mapView.centerCoordinate = _currentLocationPostion;
    [_mapView setZoomLevel:17 animated:YES];
}
#pragma  mark ------    uisearchBar delegate --

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {

    [_searchListArr removeAllObjects];
    if (searchText.length == 0 ) {
        _isSearch = NO;

    }else {
        _isSearch = YES;

        //输入提示检索
        AMapInputTipsSearchRequest *tips = [[AMapInputTipsSearchRequest alloc] init];
        tips.keywords = searchText;
        tips.cityLimit = YES;
        if (_currentCity == nil) {
            tips.city = @"厦门";
        } else {
            tips.city = _currentCity;

        }

        [self.search AMapInputTipsSearch:tips];
    }

}

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
    [UIView animateWithDuration:0.3 animations:^{
        _searchBar.showsCancelButton = YES;
        self.searchTableV.backgroundColor = [UIColor whiteColor];
        _searchTableV.hidden = NO;

    }];
}
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    _searchBar.frame = CGRectMake(0, 64, self.view.frame.size.width, 44);
    self.navigationController.navigationBarHidden = NO;
    _searchBar.showsCancelButton = NO;
    [_searchBar resignFirstResponder];
    _searchBar.text = @"";


    _searchTableV.hidden = YES;

}
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    if (scrollView == _searchTableV) {
        [_searchBar resignFirstResponder];
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
