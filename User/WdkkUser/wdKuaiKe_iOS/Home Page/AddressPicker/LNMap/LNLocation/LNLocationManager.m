//
//  LNLocationManager.m
//  BAddressPickerDemo
//
//  Created by 林洁 on 16/1/14.
//  Copyright © 2016年 onlylin. All rights reserved.
//

#import "LNLocationManager.h"

static CLLocation *oldLocation;

@implementation LNLocationManager

- (id)init{
    self = [super init];
    if (self) {
        
    }
    return self;
}


- (void)startWithBlock:(void (^)(void))start completionBlock:(void (^)(CLLocation *))success failure:(void (^)(CLLocation *, NSError *))failure{
    [self setStartBlock:start completionBlock:success failure:failure];
    [self startLocation];
}


- (void)setStartBlock:(void(^)(void))start completionBlock:(void(^)(CLLocation*))success failure:(void (^)(CLLocation *, NSError *))failure{
    self.startBlock = start;
    self.successCompletionBlock = success;
    self.failureCompletionBlock = failure;
}


- (void)startLocation{
    self.startBlock();
    self.loactionManager.delegate = self;
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0) {
        [self.loactionManager requestWhenInUseAuthorization];
    }
    self.loactionManager.desiredAccuracy = kCLLocationAccuracyBest;
    self.loactionManager.distanceFilter = 10.0f;
    [self.loactionManager startUpdatingLocation];

}


#pragma mark - CLLocationManager Delegate
//定位成功

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations{
    [self.loactionManager stopUpdatingLocation];
    oldLocation = [locations lastObject];
    self.successCompletionBlock(oldLocation);
    
    CLLocation *newLocation = locations[0];
    CLLocationCoordinate2D oldCoordinate = newLocation.coordinate;
    
    NSLog(@"旧的经度： %f 旧的维度 %f",  oldCoordinate.longitude, oldCoordinate.latitude);
    
    //创建地理位置解码编码器对象
    CLGeocoder *geoCoder = [[CLGeocoder alloc] init];
    [geoCoder reverseGeocodeLocation:newLocation completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        
        for (CLPlacemark *place in placemarks) {
            NSDictionary *locationDic = [place addressDictionary];
            NSLog(@"%@",[self dictionaryToJson:locationDic]);
        }
    }];
    
    
}
- (NSString*)dictionaryToJson:(NSDictionary *)dic

{
    
    NSError *parseError = nil;
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:&parseError];
    
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
}
//定位失败
- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error{
    self.failureCompletionBlock(oldLocation,error);
}


#pragma mark - Getter and Setter
- (CLLocationManager*)loactionManager{
    if (_loactionManager == nil) {
        _loactionManager = [[CLLocationManager alloc] init];
    }
    return _loactionManager;
}


@end
