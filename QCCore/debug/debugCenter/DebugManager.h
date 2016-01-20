//
//  DebugManager.h
//  QCCore
//
//  Created by XuQian on 1/20/16.
//  Copyright © 2016 qcwl. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DebugManager : NSObject

+ (instancetype)manager;
- (id)init NS_UNAVAILABLE;

@property (nonatomic, strong) NSString *customDomain;

@end
