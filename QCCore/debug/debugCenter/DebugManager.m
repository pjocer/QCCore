//
//  DebugManager.m
//  QCCore
//
//  Created by XuQian on 1/20/16.
//  Copyright © 2016 qcwl. All rights reserved.
//

#import "DebugManager.h"
#import <UIKit/UIKit.h>
#import "QCDebugLogo.h"

#ifdef DEBUG
NSString *const DefaultAPIHost = @"http://api.qccost.com/";
NSString *const TrialAPIHost = @"http://trial.fk.com/api/";
#else
NSString *const DefaultAPIHost = @"http://api.qccost.com/";
NSString *const TrialAPIHost = @"http://trial.qccost.com/";
#endif

NSString *const PreReleaseAPIHost = @"http://dev.qccost.com/api/";
NSString *const QAAPIHost = @"http://api.qa.fk.com/";
NSString *const DeveloperAPIHost = @"http://dev.fk.com/api/";

@implementation DebugManager

+ (instancetype)manager
{
    static DebugManager *manager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[DebugManager alloc] _init];
    });
    return manager;
}

- (id)_init
{
    if (self = [super init]) {
        
    }
    return self;
}

- (NSString *)customDomain
{
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"CustomDomain"];
}

- (void)setCustomDomain:(NSString *)customDomain
{
    if (!customDomain || customDomain.length == 0) {
        [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"CustomDomain"];
    }else {
        [[NSUserDefaults standardUserDefaults] setObject:customDomain forKey:@"CustomDomain"];
    }
    [[NSUserDefaults standardUserDefaults] synchronize];
}

@end
