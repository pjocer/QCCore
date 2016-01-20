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

/// 为deprecated函数专门生成的header，deprecated完之后可以删除
@property (nonatomic, strong) NSDictionary *deprecatedHeader;

+ (QCNetworkService *)sharedInstance;

- (void)exec:(QCHttpRequest *)request;

- (void)abort:(QCHttpRequest *)request;

- (void)clearCaches;

@end

