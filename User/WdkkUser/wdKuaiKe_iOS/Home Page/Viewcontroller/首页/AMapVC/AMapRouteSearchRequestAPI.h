//
//  AMapRouteSearchRequestAPI.h
//  wdKuaiKe_iOS
//
//  Created by Skyer God on 16/10/9.
//  Copyright © 2016年 weiDianKuaiKe. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MAMapKit/MAMapKit.h>
#import <AMapSearchKit/AMapSearchKit.h>
@interface AMapRouteSearchRequestAPI : UIViewController
@property (nonatomic,retain) MAUserLocation *currentLocation;
@property (nonatomic,retain) AMapPOI *currentPOI;

@property (nonatomic,retain) MAPointAnnotation *destinationPoint;//目标点
//终点经纬度
@property (nonatomic,copy)NSString * latstr;
@property (nonatomic,copy)NSString * lngstr;
@end
