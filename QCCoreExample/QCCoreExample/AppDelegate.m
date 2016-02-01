//
//  AppDelegate.m
//  QCCoreExample
//
//  Created by XuQian on 1/16/16.
//  Copyright © 2016 qcwl. All rights reserved.
//

#import "AppDelegate.h"
#import <QCCore/QCCore.h>
#import "ViewController.h"
//#import "QCDebugLogo.h"

#ifdef DEBUG
static NSString *const DefaultAPIHost = @"http://api.qccost.com/";
static NSString *const TrialAPIHost = @"http://trial.fk.com/api/";
#else
static NSString *const DefaultAPIHost = @"http://api.qccost.com/";
static NSString *const TrialAPIHost = @"http://trial.qccost.com/";
#endif

static NSString *const PreReleaseAPIHost = @"http://dev.qccost.com/api/";
static NSString *const QAAPIHost = @"http://api.qa.fk.com/";
static NSString *const DeveloperAPIHost = @"http://dev.fk.com/api/";

@interface AppDelegate ()
{
    __unsafe_unretained NSMutableArray *array;
}
@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    [[CrashManager manager] installCrashHandler];
    
    [[NetSniffer defaultSniffer] startSnif];
    
    [[QCLocationManager defaultManager] startUpdatingLocation];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getLocation:) name:LocationUpdatedNotification object:nil];
    
    
    [[DebugManager manager] addDomain:[Domain domain:DefaultAPIHost title:@"正式" isMain:YES]];
    [[DebugManager manager] addDomain:[Domain domain:TrialAPIHost title:@"试用" isMain:YES]];
    [[DebugManager manager] addDomain:[Domain domain:PreReleaseAPIHost title:@"预发布" isMain:NO]];
    [[DebugManager manager] addDomain:[Domain domain:QAAPIHost title:@"测试" isMain:NO]];
    [[DebugManager manager] addDomain:[Domain domain:DeveloperAPIHost title:@"开发" isMain:NO]];
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:SavedDomainPath()]) {
        Domain *dom = [NSKeyedUnarchiver unarchiveObjectWithFile:SavedDomainPath()];
        QCChangeCurrentDomain(dom);
    }else {
        QCChangeCurrentDomain([Domain domain:DefaultAPIHost title:@"正式" isMain:YES]);
    }
    
    
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];
    
    QCDebugController *controller = [[QCDebugController alloc] init];
    UINavigationController *navi = [[UINavigationController alloc] initWithRootViewController:controller];
    self.window.rootViewController = [[ViewController alloc] init];
    
//    QCAPIRequest *request = [[QCAPIRequest alloc] initWithAPIName:@"home/backlog" requestMethod:POST];
//    [request startWithAPISuccessBlock:^(QCAPIRequest * _Nonnull request) {
//        
//    } APIFailedBlock:^(QCAPIRequest * _Nonnull request) {
//        
//    }];
    
//    [@[] objectAtIndex:1];
    [self.window makeKeyAndVisible];
    
//    [self.window addSubview:[QCDebugLogo logo]];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (void)getLocation:(NSNotification *)notification
{
    NSLog(@"%@",notification.userInfo);
    CLLocationCoordinate2D dis = [notification.userInfo[LocationCoordinateBDName] locationCoordinateValue];
    NSLog(@"%.6f,%.6f",dis.latitude, dis.longitude);
    NSLog(@"%.6f,%.6f",[QCLocationManager defaultManager].coordinateBD.latitude, [QCLocationManager defaultManager].coordinateBD.longitude);
    
    [[QCLocationManager defaultManager] reloadGEOInfo];
    
}

@end
