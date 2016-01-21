//
//  DebugManager.h
//  QCCore
//
//  Created by XuQian on 1/20/16.
//  Copyright © 2016 qcwl. All rights reserved.
//

#import <Foundation/Foundation.h>

FOUNDATION_EXTERN NSString *const DefaultAPIHost;
FOUNDATION_EXTERN NSString *const TrialAPIHost;
FOUNDATION_EXTERN NSString *const PreReleaseAPIHost;
FOUNDATION_EXTERN NSString *const QAAPIHost;
FOUNDATION_EXTERN NSString *const DeveloperAPIHost;

@interface DebugManager : NSObject

+ (instancetype)manager;
- (id)init NS_UNAVAILABLE;

@property (readwrite) NSString *customDomain;

@end
