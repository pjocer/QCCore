//
//  QCLocationManager.m
//  QCCore
//
//  Created by XuQian on 1/18/16.
//  Copyright © 2016 qcwl. All rights reserved.
//

#import "QCLocationManager.h"
#import "UIDevice+Hardware.h"

#define LOCATION_TIMEOUT 20

NSString * const LocationAuthStatusChangedNotification = @"__qc_location_authorization_status_changed";
NSString * const LocationStatusChangedNotification = @"__qc_location_status_changed";
NSString * const LocationUpdatedNotification = @"__qc_location_updated";

NSString * const LocationOldAuthStatusName = @"LocationOldAuthStatus";
NSString * const LocationCurrentAuthStatusName = @"LocationCurrentAuthStatus";
NSString * const LocationOldStatusName = @"LocationOldStatus";
NSString * const LocationCurrentStatusName = @"LocationCurrentStatus";
NSString * const LocationCoordinateWGSName = @"LocationCoordinateWGS";
NSString * const LocationCoordinateGCJName = @"LocationCoordinateGCJ";
NSString * const LocationCoordinateBDName = @"LocationCoordinateBD";
NSString * const LocationAltitudeName = @"LocationAltitude";

@interface QCLocationManager () <CLLocationManagerDelegate>
{
    NSTimer *_stableTimer;
    CLLocation *_lastLocation;
    CLAuthorizationStatus _authStatus;
}

@end

@implementation QCLocationManager

+ (instancetype)defaultManager
{
    static QCLocationManager *defaultManager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        defaultManager = [[QCLocationManager alloc] _init];
    });
    return defaultManager;
}

- (id)_init
{
    if (self = [super init]) {
        self.delegate = self;
        self.desiredAccuracy = kCLLocationAccuracyBestForNavigation;
        self.distanceFilter = 100;   // 更新坐标的频率，即移动100米更新一次
        _currentStatus = LocationStopped;
        
//        if (IOS8Later) {
//            [self requestWhenInUseAuthorization];
//        }
        
        if (IOS8Later &&
            [QCLocationManager authorizationStatus] == kCLAuthorizationStatusNotDetermined &&
            [self respondsToSelector:@selector(requestAlwaysAuthorization)])
        {
            [self performSelector:@selector(requestAlwaysAuthorization) withObject:nil];
        }
    }
    return self;
}

- (void)startUpdatingLocation {
    if (_currentStatus == LocationStopped) {
        
        if (![QCLocationManager locationServicesEnabled]) {
            self.currentStatus = LocationServiceDisabled;
            return;
        }
        
        _authStatus = [QCLocationManager authorizationStatus];
        if (_authStatus == kCLAuthorizationStatusDenied || _authStatus == kCLAuthorizationStatusRestricted) {
            [[NSNotificationCenter defaultCenter] postNotificationName:LocationAuthStatusChangedNotification
                                                                object:nil
                                                              userInfo:@{LocationCurrentAuthStatusName:[NSNumber numberWithInt:_authStatus]}];
            return;
        }
        
        self.currentStatus = LocationLocating;
        [self performSelector:@selector(locationTimeOut) withObject:nil afterDelay:LOCATION_TIMEOUT];
        [super startUpdatingLocation];
    }
}

- (void)stopUpdatingLocation {
    [super stopUpdatingLocation];
    self.currentStatus = LocationStopped;
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(locationTimeOut) object:nil];
    if (_stableTimer != nil) {
        [_stableTimer invalidate];
        _stableTimer = nil;
    }
}

- (void)setCurrentStatus:(LocationStatus)currentStatus
{
    LocationStatus oldStatus = _currentStatus;
    _currentStatus = currentStatus;
    [[NSNotificationCenter defaultCenter] postNotificationName:LocationStatusChangedNotification
                                                        object:nil
                                                      userInfo:@{LocationOldStatusName:[NSNumber numberWithInt:oldStatus],
                                                                 LocationCurrentStatusName:[NSNumber numberWithInt:_currentStatus]}];
    
}

- (void)locationSucceed {
    if (_stableTimer != nil) {
        [_stableTimer invalidate];
        _stableTimer = nil;
    }
    if (self.location) {
        self.currentStatus = LocationSucceed;
    }else {
        _stableTimer = [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(locationSucceed) userInfo:nil repeats:NO];
    }
}

- (void)locationTimeOut
{
    self.currentStatus = LocationTimeOut;
}

- (void)cancelTimeOut{
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(locationTimeOut) object:nil];
}

#pragma mark - CLLocationManagerDelegate

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    if (_currentStatus != LocationSucceed) {
        [self cancelTimeOut];
        if (_stableTimer != nil) {
            [_stableTimer invalidate];
            _stableTimer = nil;
        }
        _stableTimer = [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(locationSucceed) userInfo:nil repeats:NO];
    }else {
        if (locations && locations.count > 0) {
            _lastLocation = [locations.firstObject copy];
        }else {
            _lastLocation = self.location;
        }
        [[NSNotificationCenter defaultCenter] postNotificationName:LocationUpdatedNotification
                                                            object:nil
                                                          userInfo:@{LocationCurrentAuthStatusName:[NSNumber numberWithInt:_authStatus],
                                                                     LocationCurrentStatusName:[NSNumber numberWithInt:_currentStatus],
                                                                     LocationCoordinateWGSName:[NSValue valueWithLocationCoordinate:self.coordinateWGS],
                                                                     LocationCoordinateGCJName:[NSValue valueWithLocationCoordinate:self.coordinateGCJ],
                                                                     LocationCoordinateBDName:[NSValue valueWithLocationCoordinate:self.coordinateBD],
                                                                     LocationAltitudeName:[NSValue valueWithLocationDistance:self.altitude]}];
    }
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    [self stopUpdatingLocation];
    self.currentStatus = LocationFailed;
}

- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status {
    //系统定位许可与应用定位许可
    if (![QCLocationManager locationServicesEnabled]) {
        _authStatus = status;
        return;
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:LocationAuthStatusChangedNotification
                                                        object:nil
                                                      userInfo:@{LocationCurrentAuthStatusName:[NSNumber numberWithInt:status],
                                                                 LocationOldAuthStatusName:[NSNumber numberWithInt:_authStatus]}];
    
    _authStatus = status;
    
    if (status == kCLAuthorizationStatusDenied || status == kCLAuthorizationStatusRestricted) {
        return;
    }
    
    [self startUpdatingLocation];
}

- (CLLocationCoordinate2D)coordinateWGS
{
    return _lastLocation?_lastLocation.coordinate:CLLocationCoordinate2DMake(0, 0);
}

- (CLLocationCoordinate2D)coordinateGCJ
{
    return _lastLocation?[QCLocationManager transformFromWGSToGCJ:_lastLocation.coordinate]:CLLocationCoordinate2DMake(0, 0);
}

- (CLLocationCoordinate2D)coordinateBD
{
    if (_lastLocation) {
        CLLocationCoordinate2D gcj = [QCLocationManager transformFromWGSToGCJ:_lastLocation.coordinate];
        return [QCLocationManager transformFromGCJToBD:gcj];
    }
    return CLLocationCoordinate2DMake(0, 0);
}

- (CLLocationDistance)altitude
{
    return _lastLocation?_lastLocation.altitude:0;
}

@end



@implementation QCLocationManager (OffsetCalculate)

const double a = 6378245.0;
const double ee = 0.00669342162296594323;

+ (CLLocationCoordinate2D)transformFromWGSToGCJ:(CLLocationCoordinate2D)wgLoc
{
    CLLocationCoordinate2D mgLoc;
    if (outOfChina(wgLoc.latitude, wgLoc.longitude)) {
        mgLoc = wgLoc;
        return mgLoc;
    }
    double dLat = transformLat(wgLoc.longitude - 105.0, wgLoc.latitude - 35.0);
    double dLon = transformLon(wgLoc.longitude - 105.0, wgLoc.latitude - 35.0);
    double radLat = wgLoc.latitude / 180.0 * M_PI;
    double magic = sin(radLat);
    magic = 1 - ee * magic * magic;
    double sqrtMagic = sqrt(magic);
    dLat = (dLat * 180.0) / ((a * (1 - ee)) / (magic * sqrtMagic) * M_PI);
    dLon = (dLon * 180.0) / (a / sqrtMagic * cos(radLat) * M_PI);
    mgLoc.latitude = wgLoc.latitude + dLat;
    mgLoc.longitude = wgLoc.longitude + dLon;
    
    return mgLoc;
}

bool outOfChina(double lat, double lon)
{
    if (lon < 72.004 || lon > 137.8347)
        return true;
    if (lat < 0.8293 || lat > 55.8271)
        return true;
    return false;
}

double transformLat(double x, double y)
{
    double ret = -100.0 + 2.0 * x + 3.0 * y + 0.2 * y * y + 0.1 * x * y + 0.2 * sqrt(fabs(x));
    ret += (20.0 * sin(6.0 * x * M_PI) + 20.0 *sin(2.0 * x * M_PI)) * 2.0 / 3.0;
    ret += (20.0 * sin(y * M_PI) + 40.0 * sin(y / 3.0 * M_PI)) * 2.0 / 3.0;
    ret += (160.0 * sin(y / 12.0 * M_PI) + 320 * sin(y * M_PI / 30.0)) * 2.0 / 3.0;
    return ret;
}

double transformLon(double x, double y)
{
    double ret = 300.0 + x + 2.0 * y + 0.1 * x * x + 0.1 * x * y + 0.1 * sqrt(fabs(x));
    ret += (20.0 * sin(6.0 * x * M_PI) + 20.0 * sin(2.0 * x * M_PI)) * 2.0 / 3.0;
    ret += (20.0 * sin(x * M_PI) + 40.0 * sin(x / 3.0 * M_PI)) * 2.0 / 3.0;
    ret += (150.0 * sin(x / 12.0 * M_PI) + 300.0 * sin(x / 30.0 * M_PI)) * 2.0 / 3.0;
    return ret;
}

const double x_pi = 3.14159265358979324 * 3000.0 / 180.0;
+ (CLLocationCoordinate2D)transformFromGCJToBD:(CLLocationCoordinate2D)gcLoc
{
    double x = gcLoc.longitude, y = gcLoc.latitude;
    double z = sqrt(x * x + y * y) + 0.00002 * sin(y * x_pi);
    double theta = atan2(y, x) + 0.000003 * cos(x * x_pi);
    return CLLocationCoordinate2DMake(z*cos(theta)+0.0065, z*sin(theta)+0.006);
}

+ (CLLocationCoordinate2D)transformFromBDToGCJ:(CLLocationCoordinate2D)bdLoc
{
    double x = bdLoc.longitude - 0.0065, y = bdLoc.latitude - 0.006;
    double z = sqrt(x * x + y * y) - 0.00002 * sin(y * x_pi);
    double theta = atan2(y, x) - 0.000003 * cos(x * x_pi);
    return CLLocationCoordinate2DMake(z*cos(theta), z*sin(theta));
}

@end

@implementation NSValue (CLLocation)

+ (NSValue *)valueWithLocationCoordinate:(CLLocationCoordinate2D)coordinate
{
    return [NSValue valueWithBytes:&coordinate objCType:@encode(CLLocationCoordinate2D)];
}

- (CLLocationCoordinate2D)locationCoordinateValue
{
    CLLocationCoordinate2D coordinate;
    [self getValue:&coordinate];
    return coordinate;
}

+ (NSValue *)valueWithLocationDistance:(CLLocationDistance)distance
{
    return [NSValue valueWithBytes:&distance objCType:@encode(CLLocationDistance)];
}

- (CLLocationDistance)locationDistanceValue
{
    CLLocationDistance locationDistance;
    [self getValue:&locationDistance];
    return locationDistance;
}

@end




