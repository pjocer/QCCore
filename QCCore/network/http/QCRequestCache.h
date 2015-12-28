//
//  RequestCache.h
//  QCWL_SYT
//
//  Created by Chen on 15/3/19.
//  Copyright (c) 2015年 qcwl. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "QCAPIRequest.h"

@interface QCRequestCache : NSObject

+ (QCRequestCache *)sharedInstance;
- (void)put:(QCAPIRequest *)request;
- (NSData *)get:(QCAPIRequest *)request;
- (void)remove:(QCAPIRequest *)request;
- (void)clear;

@end
