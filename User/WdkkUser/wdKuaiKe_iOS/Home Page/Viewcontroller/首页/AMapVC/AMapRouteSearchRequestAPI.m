//
//  AMapRouteSearchRequestAPI.m
//  wdKuaiKe_iOS
//
//  Created by Skyer God on 16/10/9.
//  Copyright © 2016年 weiDianKuaiKe. All rights reserved.
//

#import "AMapRouteSearchRequestAPI.h"

#import <AMapFoundationKit/AMapFoundationKit.h>
#import <AMapSearchKit/AMapSearchKit.h>
#import <AMapLocationKit/AMapLocationKit.h>
#import <MAMapView.h>
#import <MAMapKit/MAMapKit.h>
#import "NaviPointAnnotation.h"
#import "SelectableOverlay.h"
#import <AMapNaviKit/AMapNaviKit.h>
@interface AMapRouteSearchRequestAPI ()<AMapSearchDelegate, MAMapViewDelegate, AMapNaviDriveViewDelegate>
@property (nonatomic, strong) AMapSearchAPI *aMapSearch;
@property (nonatomic, strong) AMapGeoPoint *startPoint;
@property (nonatomic, strong) AMapGeoPoint *endPoint;
@property (nonatomic, strong) NSMutableArray *routeIndicatorInfoArray;
@property (nonatomic, strong) MAMapView *mapView;
@property (nonatomic, strong) AMapDrivingRouteSearchRequest *driveManager;
@property (nonatomic, strong) AMapWalkingRouteSearchRequest *walkManager;
@property (nonatomic, strong) AMapTransitRouteSearchRequest *busManager;
@property (nonatomic, strong) MAPolyline *polyline;
@property (nonatomic,retain) NSArray *pathPolylines;

@property (strong, nonatomic) UISegmentedControl *routeSegmentControl;
@property (nonatomic, strong) NSArray *availableMaps;
@property (nonatomic, strong) UIAlertController *actionSheet;
@end

@implementation AMapRouteSearchRequestAPI


- (NSArray *)pathPolylines
{
    if (!_pathPolylines) {
        _pathPolylines = [NSArray array];
    }
    return _pathPolylines;
}
- (AMapSearchAPI *)aMapSearch
{
    if (!_aMapSearch) {
        _aMapSearch = [[AMapSearchAPI alloc] init];
        _aMapSearch.delegate = self;
    }
    return _aMapSearch;
}
-(MAMapView *)mapView{

    if (!_mapView) {
        _mapView = [[MAMapView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds))];
        _mapView.delegate = self;
        _mapView.showsUserLocation = YES;    //YES 为打开定位，NO为关闭定位

        [_mapView setUserTrackingMode: MAUserTrackingModeFollow animated:NO]; //地图跟着位置移动

        //自定义定位经度圈样式
        _mapView.customizeUserLocationAccuracyCircleRepresentation = NO;

        _mapView.userTrackingMode = MAUserTrackingModeFollow;

        //后台定位
        _mapView.pausesLocationUpdatesAutomatically = NO;

//        _mapView.allowsBackgroundLocationUpdates = YES;//iOS9以上系统必须配置

        _mapView.desiredAccuracy = kCLLocationAccuracyBest;
        _mapView.headingFilter = 30;
        _mapView.distanceFilter = 3;

    }
    return _mapView;


}
- (void)viewWillAppear:(BOOL)animated
{
    [ super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = YES;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    self.view.backgroundColor = [UIColor whiteColor];
    [self.view insertSubview:self.mapView atIndex:0];

    [self initMapView];
    [self initProperties];
    [self initAnnotations];
    [self initDriveManager];
    [self initWalkingManager];
    [self initBusManager];
    [self initBottomNaviButtonView];

    self.routeSegmentControl.selectedSegmentIndex = 1;;
    self.routeSegmentControl.selected = YES;
    [self clickSegmentBtn:_routeSegmentControl];



}
- (void)initProperties{
    //为了方便展示驾车多路径规划，选择了固定的起终点
    NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:@"location"];
    CLLocation *location = [NSKeyedUnarchiver unarchiveObjectWithData:data];

    self.startPoint = [AMapGeoPoint locationWithLatitude:location.coordinate.latitude longitude:location.coordinate.longitude];

    self.endPoint   = [AMapGeoPoint locationWithLatitude:[_latstr floatValue] longitude:[_lngstr floatValue]];
    self.routeIndicatorInfoArray = [NSMutableArray array];
    self.destinationPoint = [[MAPointAnnotation alloc] init];
    self.destinationPoint.coordinate = CLLocationCoordinate2DMake(_endPoint.latitude, _endPoint.longitude);
}

- (void)initMapView
{

    self.mapView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.mapView];
    self.mapView.sd_layout
    .topSpaceToView(self.view,30)
    .leftEqualToView(self.view)
    .rightEqualToView(self.view)
    .bottomSpaceToView(self.tabBarController.tabBar, autoScaleH(50));


    self.routeSegmentControl = [[UISegmentedControl alloc] initWithItems:@[@"步行",@"驾车",@"公交"]];
    _routeSegmentControl.backgroundColor = [UIColor whiteColor];
    _routeSegmentControl.tintColor = RGB(234,128,16);
    [_routeSegmentControl addTarget:self action:@selector(clickSegmentBtn:) forControlEvents:UIControlEventValueChanged];


    [self.view addSubview:_routeSegmentControl];

    self.routeSegmentControl.sd_layout.topSpaceToView(self.view, 0).heightIs(30).leftEqualToView(self.view).rightSpaceToView(self.view, 0);

    self.mapView.showsUserLocation = YES;


}
- (void)initBottomNaviButtonView{
#pragma mark -- 创建定位当前位置按钮 －－  设置导航功能按钮 －－－

    UIView *backView = [[UIView alloc] init];
    backView.backgroundColor = [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1.0];
    [self.view addSubview:backView];
    backView.sd_layout.leftEqualToView(self.view).bottomSpaceToView(self.tabBarController.tabBar, 0).rightEqualToView(self.view).topSpaceToView(_mapView, 0);

    UIButton *locaitonBT = [UIButton buttonWithType:UIButtonTypeCustom];
    [locaitonBT setTitle:@"我的位置" forState:UIControlStateNormal];
    [locaitonBT setTitleColor:[UIColor colorWithRed:0.098 green:0.098 blue:0.098 alpha:1.0] forState:UIControlStateNormal];;
    [backView addSubview:locaitonBT];

    [locaitonBT addTarget:self action:@selector(locationButtonAction:) forControlEvents:UIControlEventTouchUpInside];

    locaitonBT.titleLabel.font = [UIFont systemFontOfSize:autoScaleW(13)];
    locaitonBT.sd_layout.leftSpaceToView(backView, autoScaleW(5)).topSpaceToView(backView, 0).heightIs(autoScaleH(50)).widthIs(autoScaleW(60));

    /** shezhi导航 **/
    UIButton *navigationBT = [UIButton buttonWithType:UIButtonTypeCustom];
    [navigationBT setTitle:@"开始导航" forState:UIControlStateNormal];
    [navigationBT addTarget:self action:@selector(navigationButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [backView addSubview:navigationBT];
    [navigationBT setTitleColor:locaitonBT.titleLabel.textColor forState:UIControlStateNormal];
    navigationBT.titleLabel.font = locaitonBT.titleLabel.font;
    navigationBT.sd_layout.rightSpaceToView(backView, 5).bottomEqualToView(locaitonBT).heightIs(locaitonBT.size.height).widthIs(locaitonBT.size.width);
}

- (void)initDriveManager
{
    if (self.driveManager == nil)
    {
        self.driveManager = [[AMapDrivingRouteSearchRequest alloc] init];
        self.driveManager.requireExtension = YES;
        self.driveManager.strategy = 0;

    }
    /** 设置起始点 **/
    self.driveManager.origin = self.startPoint;
    self.driveManager.destination = self.endPoint;


}

- (void)initWalkingManager{
    if (self.walkManager == nil) {
        self.walkManager = [[AMapWalkingRouteSearchRequest alloc] init];
        self.walkManager.multipath = 0;
    }
    self.walkManager.origin = _startPoint;
    self.walkManager.destination = _endPoint;
}
- (void)initBusManager{
    if (self.busManager == nil) {
        self.busManager = [[AMapTransitRouteSearchRequest alloc] init];
        self.busManager.requireExtension = YES;
        self.busManager.strategy = 2;
        self.busManager.city = @"厦门";

    }

    self.busManager.origin = _startPoint;
    self.busManager.destination = _endPoint;

}
- (void)initAnnotations
{
    NaviPointAnnotation *beginAnnotation = [[NaviPointAnnotation alloc] init];
    [beginAnnotation setCoordinate:CLLocationCoordinate2DMake(self.startPoint.latitude, self.startPoint.longitude)];
    beginAnnotation.title = @"起始点";
    beginAnnotation.navPointType = NaviPointAnnotationStart;

    [self.mapView addAnnotation:beginAnnotation];

    NaviPointAnnotation *endAnnotation = [[NaviPointAnnotation alloc] init];
    [endAnnotation setCoordinate:CLLocationCoordinate2DMake(self.endPoint.latitude, self.endPoint.longitude)];
    endAnnotation.title = @"终点";
    endAnnotation.navPointType = NaviPointAnnotationEnd;

    [self.mapView addAnnotation:endAnnotation];
}

#pragma mark -- 大头针和遮盖

//自定义的经纬度和区域
- (MAOverlayRenderer *)mapView:(MAMapView *)mapView rendererForOverlay:(id <MAOverlay>)overlay
{
    /* 自定义定位精度对应的MACircleView. */
    if (overlay == mapView.userLocationAccuracyCircle)
    {
        MACircleRenderer *accuracyCircleRenderer = [[MACircleRenderer alloc] initWithCircle:overlay];

        accuracyCircleRenderer.lineWidth    = 2.f;
        accuracyCircleRenderer.strokeColor  = [UIColor lightGrayColor];
        accuracyCircleRenderer.fillColor    = [UIColor colorWithRed:1 green:0 blue:0 alpha:.3];

        return accuracyCircleRenderer;
    }

    //画路线
    //    if ([overlay isKindOfClass:[MAPolygon class]])
    //    {
    //
    //        MAPolygonRenderer *polygonView = [[MAPolygonRenderer alloc] initWithPolygon:overlay];
    //
    //        polygonView.lineWidth = 5.f;
    //        polygonView.strokeColor = [UIColor colorWithRed:0.986 green:0.185 blue:0.019 alpha:1.000];
    //        polygonView.fillColor = [UIColor colorWithRed:0.940 green:0.771 blue:0.143 alpha:0.800];
    //        polygonView.lineJoinType = kMALineJoinMiter;//连接类型
    //
    //        return polygonView;
    //    }
    //画路线
    if ([overlay isKindOfClass:[MAPolyline class]])
    {

        MAPolylineRenderer *polygonView = [[MAPolylineRenderer alloc] initWithPolyline:overlay];

        polygonView.lineWidth = 8.f;
        polygonView.strokeColor = [UIColor colorWithRed:0.015 green:0.658 blue:0.986 alpha:1.000];
        polygonView.fillColor = [UIColor colorWithRed:0.940 green:0.771 blue:0.143 alpha:0.800];
        polygonView.lineJoinType = kMALineJoinRound;//连接类型

        return polygonView;
    }
    return nil;
    
}
//添加大头针
- (void)addAnnotation
{
    MAPointAnnotation *pointAnnotation = [[MAPointAnnotation alloc] init];
    pointAnnotation.coordinate = _currentLocation.coordinate;
    pointAnnotation.coordinate = CLLocationCoordinate2DMake(_currentPOI.location.latitude, _currentPOI.location.longitude);
    pointAnnotation.title = _currentPOI.name;
    pointAnnotation.subtitle = @"厦门软件园观日路40号之一";
    //    pointAnnotation.subtitle = _currentPOI.address;


    [_mapView addAnnotation:pointAnnotation];
    [_mapView selectAnnotation:pointAnnotation animated:YES];
}
#pragma mark -- mmapDelegate --
#pragma mark - MAMapView Delegate

//大头针的回调
- (MAAnnotationView *)mapView:(MAMapView *)mapView viewForAnnotation:(id <MAAnnotation>)annotation
{

    /* 自定义userLocation对应的annotationView. */
    if ([annotation isKindOfClass:[MAUserLocation class]])
    {
        static NSString *userLocationStyleReuseIndetifier = @"userLocationStyleReuseIndetifier";
        MAAnnotationView *annotationView = [mapView dequeueReusableAnnotationViewWithIdentifier:userLocationStyleReuseIndetifier];
        if (annotationView == nil)
        {
            annotationView = [[MAAnnotationView alloc] initWithAnnotation:annotation
                                                          reuseIdentifier:userLocationStyleReuseIndetifier];
        }
        annotationView.image = [UIImage imageNamed:@"userPosition"];

        return annotationView;
    }

    //大头针
    if ([annotation isKindOfClass:[MAPointAnnotation class]])
    {
        static NSString *pointReuseIndentifier = @"pointReuseIndentifier";
        MAPinAnnotationView*annotationView = (MAPinAnnotationView*)[mapView dequeueReusableAnnotationViewWithIdentifier:pointReuseIndentifier];
        if (annotationView == nil)
        {
            annotationView = [[MAPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:pointReuseIndentifier];
        }
        annotationView.canShowCallout= YES;       //设置气泡可以弹出，默认为NO
        annotationView.animatesDrop = YES;        //设置标注动画显示，默认为NO
        annotationView.draggable = YES;        //设置标注可以拖动，默认为NO
        annotationView.pinColor = MAPinAnnotationColorPurple;

        return annotationView;
    }
    return nil;
}



-(void)mapView:(MAMapView *)mapView didUpdateUserLocation:(MAUserLocation *)userLocation updatingLocation:(BOOL)updatingLocation{

    if(updatingLocation)
    {
        //取出当前位置的坐标
        self.currentLocation = userLocation;

        //构造AMapReGeocodeSearchRequest对象
        AMapReGeocodeSearchRequest *regeo = [[AMapReGeocodeSearchRequest alloc] init];
        regeo.location = [AMapGeoPoint locationWithLatitude:userLocation.coordinate.latitude longitude:userLocation.coordinate.longitude];

        regeo.radius = 10000;
        regeo.requireExtension = YES;

        //发起逆地理编码
        [self.aMapSearch AMapReGoecodeSearch: regeo];
    }

}
#pragma mark -- amapsearchDelegate --

//实现路径搜索的回调函数
- (void)onRouteSearchDone:(AMapRouteSearchBaseRequest *)request response:(AMapRouteSearchResponse *)response
{
    if(response.route == nil)
    {
        return;
    }

    //通过AMapNavigationSearchResponse对象处理搜索结果


    if (response.count > 0)
    {
        [_mapView removeOverlays:_pathPolylines];
        _pathPolylines = nil;
        // 只显⽰示第⼀条 规划的路径
        if (request == _busManager) {
          _pathPolylines = [self polylinesForPathOfBusing:response.route.transits[1]];
        } else {

          _pathPolylines = [self polylinesForPath:response.route.paths[0]];

        }


        [_mapView addOverlays:_pathPolylines];


        //        解析第一条返回结果
        //        搜索路线
        MAPointAnnotation *currentAnnotation = [[MAPointAnnotation alloc]init];
        currentAnnotation.coordinate = _mapView.userLocation.coordinate;
        [_mapView showAnnotations:@[_destinationPoint, currentAnnotation] animated:YES];
        [_mapView addAnnotation:currentAnnotation];
    }


    //    [self drawPolygonWith:response.route.origin dest:response.route.destination];
}
//路线解析
- (NSArray *)polylinesForPath:(AMapPath *)path
{
    if (path == nil || path.steps.count == 0)
    {
        return nil;
    }
    NSMutableArray *polylines = [NSMutableArray array];
    [path.steps enumerateObjectsUsingBlock:^(AMapStep *step, NSUInteger idx, BOOL *stop) {
        NSUInteger count = 0;
        CLLocationCoordinate2D *coordinates = [self coordinatesForString:step.polyline
                                                         coordinateCount:&count
                                                              parseToken:@";"];


        MAPolyline *polyline = [MAPolyline polylineWithCoordinates:coordinates count:count];

        //          MAPolygon *polygon = [MAPolygon polygonWithCoordinates:coordinates count:count];

        [polylines addObject:polyline];
        free(coordinates), coordinates = NULL;
    }];
    return polylines;
}
//公交路线解析
- (NSArray *)polylinesForPathOfBusing:(AMapTransit *)transit
{
    if (transit == nil || transit.segments.count == 0)
    {
        return nil;
    }
    NSMutableArray *polylines = [NSMutableArray array];
    for (NSInteger i = 0 ; i < transit.segments.count; i ++) {

        if (transit.segments[i].walking == nil || transit.segments[i].walking.steps.count == 0) {
            break;
        } else {
            [transit.segments[i].walking.steps enumerateObjectsUsingBlock:^(AMapStep * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                NSUInteger count = 0;
                CLLocationCoordinate2D *coordinates = [self coordinatesForString:obj.polyline coordinateCount:&count parseToken:@";"];

                MAPolyline *polyline = [MAPolyline polylineWithCoordinates:coordinates count:count];
                [polylines addObject:polyline];
                free(coordinates), coordinates = NULL;
                
            }];
        }
        if (transit.segments[i].buslines == nil || transit.segments[i].buslines.count == 0) {
            break;
        } {
            [transit.segments[i].buslines enumerateObjectsUsingBlock:^(AMapBusLine * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                NSUInteger count = 0;
                CLLocationCoordinate2D *coordinates = [self coordinatesForString:obj.polyline coordinateCount:&count parseToken:@";"];
                MAPolyline *polyline = [MAPolyline polylineWithCoordinates:coordinates count:count];
                [polylines addObject:polyline];
                free(coordinates), coordinates = NULL;
            }];
        }


    }





    return polylines;
}
//解析经纬度
- (CLLocationCoordinate2D *)coordinatesForString:(NSString *)string
                                 coordinateCount:(NSUInteger *)coordinateCount
                                      parseToken:(NSString *)token
{
    if (string == nil)
    {
        return NULL;
    }

    if (token == nil)
    {
        token = @",";
    }

    NSString *str = @"";
    if (![token isEqualToString:@","])
    {
        str = [string stringByReplacingOccurrencesOfString:token withString:@","];
    }

    else
    {
        str = [NSString stringWithString:string];
    }

    NSArray *components = [str componentsSeparatedByString:@","];
    NSUInteger count = [components count] / 2;
    if (coordinateCount != NULL)
    {
        *coordinateCount = count;
    }
    CLLocationCoordinate2D *coordinates = (CLLocationCoordinate2D*)malloc(count * sizeof(CLLocationCoordinate2D));

    for (int i = 0; i < count; i++)
    {
        coordinates[i].longitude = [[components objectAtIndex:2 * i]     doubleValue];
        coordinates[i].latitude  = [[components objectAtIndex:2 * i + 1] doubleValue];
    }


    return coordinates;
}
        /** 获取路径失败时返回失败信息 **/
- (void)AMapSearchRequest:(id)request didFailWithError:(NSError *)error
{
    NSLog(@"Error: %@", error);
}
/** segmentContol事件响应 **/
- (void)clickSegmentBtn:(UISegmentedControl *)sender
{
    switch (sender.selectedSegmentIndex) {
        case 0:
                [self.aMapSearch  AMapWalkingRouteSearch:_walkManager];
            break;
        case 1:
            [self.aMapSearch AMapDrivingRouteSearch:_driveManager];
            break;
        case 2:
            [self.aMapSearch AMapTransitRouteSearch:_busManager];
            break;
        default:
            break;
    }
}
-(void)locationButtonAction:(UIButton *)sender{
    [_mapView setCenterCoordinate: _currentLocation.coordinate animated:YES];


    //恢复缩放比例和角度
    [_mapView setZoomLevel:18 animated:YES];

    [_mapView setRotationDegree:0 animated:YES duration:0.5];
    [_mapView setCameraDegree:0 animated:YES duration:0.5];


}

/** 设置检索本机地图 **/
- (void)navigationButtonAction:(UIButton *)sender{
    NSString *title = @"选择本机地图";
    NSString *message = @"A message should be a short, complete sentence.";
    NSString *cancelButtonTitle = NSLocalizedString(@"Cancel", nil);
    NSString *tencent = NSLocalizedString(@"腾讯地图", nil);
    NSString *baidu = NSLocalizedString(@"百度地图", nil);
    NSString *gaode = NSLocalizedString(@"高德地图", nil);
    NSString *apple = NSLocalizedString(@"苹果", nil);


    __block CLLocationCoordinate2D startCoor = self.mapView.userLocation.location.coordinate;
    __block CLLocationCoordinate2D endCoor = CLLocationCoordinate2DMake(startCoor.latitude+0.01, startCoor.longitude+0.01);
    _actionSheet = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:cancelButtonTitle style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        
    }];
    UIAlertAction *tencentAction = [UIAlertAction actionWithTitle:tencent style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        //qqmap://map/routeplan?type=drive&from=%E6%88%91%E7%9A%84%E4%BD%8D%E7%BD%AE&fromcoord=39.924653,116.477790&to=%E4%B8%AD%E5%85%B3%E6%9D%91&tocoord=39.9836,116.3164&policy=1&referer=tengxun
        NSString *tencentUrl = [NSString stringWithFormat:@"qqmap://map/routeplan?type=drive&fromcoord=39.924653,116.477790&tocoord=39.9836,116.3164&policy=1&referer=tengxun"];

        tencentUrl = [tencentUrl stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLPathAllowedCharacterSet]];
        NSURL *url = [NSURL URLWithString:tencentUrl];

        [[UIApplication sharedApplication]  openURL:[NSURL URLWithString:tencentUrl]];

    }];
    UIAlertAction *baiduAction = [UIAlertAction actionWithTitle:baidu style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        //baidumap://map/direction?origin=34.264642646862,108.95108518068&destination=40.007623,116.360582&mode=driving&src=webapp.navi.yourCompanyName.yourAppName
        NSString *string = [[NSString alloc] initWithFormat:@"baidumap://map/direction?origin=%lf,%lf&destination=%lf,%lf&mode=driving&src=webapp.navi.yourCompanyName.yourAppName", _currentLocation.coordinate.latitude, _currentLocation.coordinate.longitude, _endPoint.latitude, _endPoint.longitude];
        [[UIApplication sharedApplication]  openURL:[NSURL URLWithString:string]];
    }];
    UIAlertAction *gaodeAction = [UIAlertAction actionWithTitle:gaode style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        //        参数            说明                          是否必填
        //        navi	服务类型	是
        //        sourceApplication	第三方调用应用名称。如applicationName	是
        //        backScheme	第三方调回使用的scheme,如applicationScheme (第三方iOS客户端需要注册该scheme)	否
        //        poiname	POI名称	否
        //        poiid	对应sourceApplication 的POI ID	否
        //        lat	纬度	是
        //        lon	经度	是
        //        dev	是否偏移(0:lat和lon是已经加密后的,不需要国测加密;1:需要国测加密)	是
        //        style	导航方式：(0：速度最快，1：费用最少，2：距离最短，3：不走高速，4：躲避拥堵，5：不走高速且避免收费，6：不走高速且躲避拥堵，7：躲避收费和拥堵，8：不走高速躲避收费和拥堵)	是
        //   iosamap://navi?sourceApplication=applicationName&backScheme=applicationScheme&poiname=fangheng&poiid=BGVIS&lat=36.547901&lon=104.258354&dev=1&style=2
        NSString *string = [[NSString alloc] initWithFormat:@"iosamap://navi?sourceApplication=applicationName&backScheme=applicationScheme&poiname=xiamen&poiid=BGVIS&lat=%lf&lon=%lf&dev=1&style=2", _endPoint.latitude, _endPoint.longitude];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:string]];

    }];
    UIAlertAction *appleAction = [UIAlertAction actionWithTitle:apple style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {

        if ([[[UIDevice currentDevice] systemVersion] floatValue] < 6.0) { // ios6以下，调用google map

            NSString *urlString = [[NSString alloc] initWithFormat:@"http://maps.google.com/maps?saddr=%f,%lf&daddr=%f,%lf&dirfl=d", _currentLocation.coordinate.latitude, _currentLocation.coordinate.longitude, _endPoint.latitude, _endPoint.longitude];

            urlString =  [urlString stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
            NSURL *aURL = [NSURL URLWithString:urlString];
            [[UIApplication sharedApplication] openURL:aURL];
        } else{// 直接调用ios自己带的apple map

            NSString *string = [[NSString alloc] initWithFormat:@"http://maps.apple.com/?saddr=%lf,%lf&daddr=%lf,%lf", _currentLocation.coordinate.latitude, _currentLocation.coordinate.longitude, _endPoint.latitude, _endPoint.longitude];
            [[UIApplication sharedApplication]  openURL:[NSURL URLWithString:string]];
        }
    }];

    // 判断手机是否装有第三方地图，如果有就添加显示
    NSDictionary *appCategorys = @{@"qqmap://map":tencentAction, @"baidumap://":baiduAction, @"iosamap://":gaodeAction};

    for (NSString *url in appCategorys) {
        if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:url]]) {
            NSLog(@"可以打开%@", url);
            [_actionSheet addAction:appCategorys[url]];
        }
    }
    [_actionSheet addAction:appleAction];
    [_actionSheet addAction:cancelAction];
    
    [self presentViewController:_actionSheet animated:YES completion:nil];
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
