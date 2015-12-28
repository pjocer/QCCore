//
//  NetworkService.h
//  QCCore
//
//  Created by Chen on 15/4/1.
//  Copyright (c) 2015年 Quancheng-ec. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "QCHttpRequest.h"

@interface QCNetworkService : NSObject

+ (QCNetworkService *)sharedInstance;

- (void)exec:(QCHttpRequest *)request;

- (void)abort:(QCHttpRequest *)request;

@end
