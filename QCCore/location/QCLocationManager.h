//
//  QCLocationManager.h
//  QCCore
//
//  Created by XuQian on 1/18/16.
//  Copyright © 2016 qcwl. All rights reserved.
//

#import <CoreLocation/CoreLocation.h>

/// LocationAuthStatusChangedNotification在定位授权发生更变时或启动定位并发现不被授权时发出。userInfo中含LocationOldAuthStatusName和LocationCurrentAuthStatusName信息
FOUNDATION_EXTERN NSString * const LocationAuthStatusChangedNotification;

/// LocationStatusChangedNotification在定位状态发生更变时发出。userInfo中含LocationOldStatusName和LocationCurrentStatusName信息
FOUNDATION_EXTERN NSString * const LocationStatusChangedNotification;

/* LocationUpdatedNotification在位置信息发生更新时发出，更新频率约为100米距离。
    userInfo中含LocationCoordinateWGSName、LocationCoordinateGCJName、LocationCoordinateBDName、LocationAltitudeName、LocationCurrentStatusName和LocationCurrentAuthStatusName信息。
    其中CLLocationCoordinate2D，和CLLocationDistance请使用NSValue(CLLocation)类中提供的方法进行转换
 */
FOUNDATION_EXTERN NSString * const LocationUpdatedNotification;

// 下列名字用以访问通知userInfo中的数据
FOUNDATION_EXTERN NSString * const LocationOldAuthStatusName;
FOUNDATION_EXTERN NSString * const LocationCurrentAuthStatusName;
FOUNDATION_EXTERN NSString * const LocationOldStatusName;
FOUNDATION_EXTERN NSString * const LocationCurrentStatusName;
FOUNDATION_EXTERN NSString * const LocationCoordinateWGSName;
FOUNDATION_EXTERN NSString * const LocationCoordinateGCJName;
FOUNDATION_EXTERN NSString * const LocationCoordinateBDName;
FOUNDATION_EXTERN NSString * const LocationAltitudeName;

typedef NS_OPTIONS(uint8_t, LocationStatus) {
    LocationStopped            = 0,
    LocationLocating,
    LocationSucceed,
    LocationFailed,
    LocationTimeOut,
    LocationServiceDisabled
};

@interface QCLocationManager : CLLocationManager

+ (instancetype)defaultManager;
- (id)init NS_UNAVAILABLE;

/// 当前定位模块状态
@property (nonatomic, assign, readonly) LocationStatus currentStatus;

/// GPS全球定位系统坐标 WGS-84
@property (readonly) CLLocationCoordinate2D coordinateWGS;
/// 国家地理测绘坐标（火星坐标） GCJ-02
@property (readonly) CLLocationCoordinate2D coordinateGCJ;
/// 百度地图坐标 BD-09
@property (readonly) CLLocationCoordinate2D coordinateBD;
/// 海拔高度
@property (readonly) CLLocationDistance altitude;

//unavailable super functions
+ (CLAuthorizationStatus)authorizationStatus NS_UNAVAILABLE;
- (CLLocation *)location NS_UNAVAILABLE;

@end

FOUNDATION_EXTERN NSString * const LocationUpdatedGEOInfoNotification;

FOUNDATION_EXTERN NSString * const LocationPlacemarkName;
FOUNDATION_EXTERN NSString * const LocationGEOErrorName;

@interface QCLocationManager (GEOKits)

@property (nonatomic, strong, readonly) CLGeocoder *geoCoder;

- (void)reloadGEOInfo;
- (void)cancelGEOCoding;

@end

@interface QCLocationManager (OffsetCalculate)

///  WGS-84 坐标转换成 GCJ-02 坐标
+ (CLLocationCoordinate2D)transformFromWGSToGCJ:(CLLocationCoordinate2D)wgLoc;

///  GCJ-02 坐标转换成 BD-09 坐标
+ (CLLocationCoordinate2D)transformFromGCJToBD:(CLLocationCoordinate2D)gcLoc;

///   BD-09 坐标转换成 GCJ-02坐标
+ (CLLocationCoordinate2D)transformFromBDToGCJ:(CLLocationCoordinate2D)bdLoc;

@end

@interface NSValue (CLLocation)

+ (NSValue *)valueWithLocationCoordinate:(CLLocationCoordinate2D)coordinate;
- (CLLocationCoordinate2D)locationCoordinateValue;
+ (NSValue *)valueWithLocationDistance:(CLLocationDistance)distance;
- (CLLocationDistance)locationDistanceValue;

@end
