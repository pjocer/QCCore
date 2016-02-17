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

typedef NS_OPTIONS(int, PinType) {
    DebugPinType,
    WGSPinType,
    GCJPinType,
    BDPinType
};

@interface QCLocationManager ()
- (void)setDebugCoordinate:(CLLocationCoordinate2D)coordinate;
@end

@interface QCDebugPin : NSObject <MKAnnotation>

@property (nonatomic, assign) CLLocationCoordinate2D coordinate;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, assign) PinType type;

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
    
    QCDebugPin *pinWGS = [[QCDebugPin alloc] init];
    pinWGS.coordinate = [QCLocationManager defaultManager].coordinateWGS;
    pinWGS.title = [NSString stringWithFormat:@"WGS: %.6f,%.6f",pinWGS.coordinate.latitude,pinWGS.coordinate.longitude];
    pinWGS.type = WGSPinType;
    [_mapView addAnnotation:pinWGS];
    
    QCDebugPin *pinGCJ = [[QCDebugPin alloc] init];
    pinGCJ.coordinate = [QCLocationManager defaultManager].coordinateGCJ;
    pinGCJ.title = [NSString stringWithFormat:@"GCJ: %.6f,%.6f",pinGCJ.coordinate.latitude,pinGCJ.coordinate.longitude];
    pinGCJ.type = GCJPinType;
    [_mapView addAnnotation:pinGCJ];
    
    QCDebugPin *pinBD = [[QCDebugPin alloc] init];
    pinBD.coordinate = [QCLocationManager defaultManager].coordinateBD;
    pinBD.title = [NSString stringWithFormat:@"BD: %.6f,%.6f",pinBD.coordinate.latitude,pinBD.coordinate.longitude];
    pinBD.type = BDPinType;
    [_mapView addAnnotation:pinBD];
    
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
    for (QCDebugPin *pin in _mapView.annotations) {
        [_mapView removeAnnotations:@[pin]];
    }
    
    QCDebugPin *pin = [[QCDebugPin alloc] init];
    pin.coordinate = dpcoordinate;
    pin.title = [NSString stringWithFormat:@"%.6f,%.6f",dpcoordinate.latitude,dpcoordinate.longitude];
    pin.type = DebugPinType;
    [_mapView addAnnotation:pin];
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation
{
    if (((QCDebugPin *)annotation).type == DebugPinType) {
        NSString *identifier = @"pin";
        MKPinAnnotationView *view = (MKPinAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:identifier];
        if (!view) {
            view = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:identifier];
            view.canShowCallout = YES;
        }
        return view;
    }else {
        NSString *identifier = @"location";
        MKAnnotationView *view = (MKAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:identifier];
        if (!view) {
            view = [[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:identifier];
            view.frame = CGRectMake(0, 0, 14, 14);
//            view.clipsToBounds = YES;
            view.layer.cornerRadius = 7;
            view.layer.borderWidth = 1/[UIScreen mainScreen].scale;
            view.layer.borderColor = [UIColor grayColor].CGColor;
            view.canShowCallout = YES;
        }
        switch (((QCDebugPin *)annotation).type) {
            case WGSPinType: view.backgroundColor = [UIColor blueColor]; break;
            case GCJPinType: view.backgroundColor = [UIColor redColor]; break;
            case BDPinType: view.backgroundColor = [UIColor yellowColor]; break;
            default: view.backgroundColor = [UIColor lightGrayColor]; break;
        }
        return view;
    }
}

@end
