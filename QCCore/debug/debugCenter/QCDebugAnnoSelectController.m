//
//  QCDebugAnnoSelectController.m
//  QCCore
//
//  Created by XuQian on 1/20/16.
//  Copyright © 2016 qcwl. All rights reserved.
//

#import "QCDebugAnnoSelectController.h"
#import <MapKit/MapKit.h>
#import "QCLocationManager.h"

@interface QCLocationManager ()
- (void)setDebugCoordinate:(CLLocationCoordinate2D)coordinate;
@end

@interface QCDebugPin : NSObject <MKAnnotation>

@property (nonatomic, assign) CLLocationCoordinate2D coordinate;
@property (nonatomic, copy) NSString *title;

@end

@implementation QCDebugPin

@synthesize coordinate;

@end

@interface QCDebugAnnoSelectController ()<MKMapViewDelegate>
{
    MKMapView *_mapView;
    CLLocationCoordinate2D dpcoordinate;
}
@end

@implementation QCDebugAnnoSelectController

- (void)loadView
{
    [super loadView];
    
    self.title = @"选择坐标点";
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(resetClicked)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"确定" style:UIBarButtonItemStylePlain target:self action:@selector(setClicked)];
    
    _mapView = [[MKMapView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    _mapView.delegate = self;
    [self.view addSubview:_mapView];
    
    UILongPressGestureRecognizer *press = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(addPin:)];
    [_mapView addGestureRecognizer:press];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    QCDebugPin *pin = [[QCDebugPin alloc] init];
    pin.coordinate = [QCLocationManager defaultManager].coordinateGCJ;
    pin.title = [NSString stringWithFormat:@"%.6f,%.6f",pin.coordinate.latitude,pin.coordinate.longitude];
    [_mapView addAnnotation:pin];
    
    dpcoordinate = [QCLocationManager defaultManager].coordinateGCJ;
}

- (void)resetClicked
{
    [[QCLocationManager defaultManager] setDebugCoordinate:CLLocationCoordinate2DMake(0, 0)];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)setClicked
{
    [[QCLocationManager defaultManager] setDebugCoordinate:dpcoordinate];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)addPin:(UIGestureRecognizer *)gesture
{
    CGPoint dp = [gesture locationInView:_mapView];
    dpcoordinate = [_mapView convertPoint:dp toCoordinateFromView:_mapView];
    [_mapView removeAnnotations:_mapView.annotations];
    
    QCDebugPin *pin = [[QCDebugPin alloc] init];
    pin.coordinate = dpcoordinate;
    pin.title = [NSString stringWithFormat:@"%.6f,%.6f",dpcoordinate.latitude,dpcoordinate.longitude];
    [_mapView addAnnotation:pin];
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation
{
    NSString *identifier = @"pin";
    MKPinAnnotationView *view = (MKPinAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:identifier];
    if (!view) {
        view = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:identifier];
        view.canShowCallout = YES;
    }
    return view;
}

@end
