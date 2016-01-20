//
//  DebugManager.m
//  QCCore
//
//  Created by XuQian on 1/20/16.
//  Copyright © 2016 qcwl. All rights reserved.
//

#import "DebugManager.h"

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
        
        NSString *apiDomain = [[NSUserDefaults standardUserDefaults] objectForKey:@"CustomDomain"];
        if (apiDomain && apiDomain.length > 0) {
            _customDomain = apiDomain;
        }
        
        
    }
    return self;
}

- (void)setCustomDomain:(NSString *)customDomain
{
    _customDomain = customDomain;
    if (!customDomain || customDomain.length == 0) {
        [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"CustomDomain"];
    }else {
        [[NSUserDefaults standardUserDefaults] setObject:customDomain forKey:@"CustomDomain"];
    }
    [[NSUserDefaults standardUserDefaults] synchronize];
}

@end
