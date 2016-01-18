//
//  AppDelegate.m
//  QCCoreExample
//
//  Created by XuQian on 1/16/16.
//  Copyright © 2016 qcwl. All rights reserved.
//

#import "AppDelegate.h"
#import <QCCore/QCCore.h>

@interface AppDelegate ()
{
    __unsafe_unretained NSMutableArray *array;
}
@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    [[CrashManager manager] installCrashHandler];
    
    
//    NSArray *logs = [CrashManager manager].unCheckedLogNames;
//    for (NSDictionary *dic in logs) {
//        CrashLog *log = [[CrashManager manager] crashLogWithName:dic[@"name"]];
//        NSLog(@"%@",log);
//    }
    
//    array = [NSArray array];
//    NSString *str = @"";
//    [array addObject:str];
    
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

@end
