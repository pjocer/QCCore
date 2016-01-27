//
//  DebugManager.h
//  QCCore
//
//  Created by XuQian on 1/20/16.
//  Copyright © 2016 qcwl. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Domain;

FOUNDATION_EXTERN NSString * SavedDomainPath();

@interface DebugManager : NSObject

+ (instancetype)manager;
- (id)init NS_UNAVAILABLE;

@property (readonly) NSArray<Domain *> *domains;
- (void)addDomain:(Domain *)domain;
@end

@interface Domain : NSObject <NSSecureCoding>
@property (nonatomic, strong, readonly) NSString *domain;
@property (nonatomic, strong, readonly) NSString *title;
@property (nonatomic, assign, readonly) BOOL isMain;
+ (instancetype)domain:(NSString *)domain title:(NSString *)title isMain:(BOOL)isMain;
@end

