//
//  NetworkService.m
//  QCCore
//
//  Created by Chen on 15/4/1.
//  Copyright (c) 2015年 Quancheng-ec. All rights reserved.
//

#import "QCNetworkService.h"
#import "AFNetworking.h"
#import "QCRequestCache.h"
#import "NetworkUtil.h"

@interface QCHttpRequest ()
@property (nonatomic, strong) AFHTTPRequestOperation *requestOperation;
@property (assign) id successBlock;
@property (assign) id failedBlock;
- (void)formatResponseOperation:(AFHTTPRequestOperation *)operation;
- (void)postprocessRequest;
- (void)preprocessRequest;
- (void)setRequestFinished;
@end

@implementation QCNetworkService {
    AFHTTPRequestOperationManager *_manager;
    NSMutableArray *_runningRequestArray;
}

+ (QCNetworkService *)sharedInstance {
    static QCNetworkService *defaultNetworkService;
    static dispatch_once_t token;
    dispatch_once(&token, ^{
        defaultNetworkService = [[QCNetworkService alloc] initSingle];
    });
    return defaultNetworkService;
}

- (id)initSingle {
    self = [super init];
    if (self) {
        _manager = [AFHTTPRequestOperationManager manager];
        _runningRequestArray = [NSMutableArray new];
        
//        [[NetSniffer defaultSniffer] startSnif]; //callback与AFN冲突，暂时不要启用
    }
    return self;
}

- (id)init {
    return [QCNetworkService sharedInstance];
}

- (void)exec:(QCHttpRequest *)request {
    if ([_runningRequestArray containsObject:request]) {
        NSLog(@"Can't exec duplicate request at same time");
    } else {
//        [request preprocessRequest];
        [self handleRequest:request];
    }
}
- (void)abort:(QCHttpRequest *)request {
    [request.requestOperation cancel];
    [_runningRequestArray removeObject:request];
}

- (void)handleRequest:(QCHttpRequest *)request {
    _manager.requestSerializer.timeoutInterval = request.timeoutInterval;

    NSDictionary *headerDict = [request requestHeaders];
    if (headerDict != nil) {
        for (id httpHeaderField in headerDict.allKeys) {
            id value = headerDict[httpHeaderField];
            if ([httpHeaderField isKindOfClass:[NSString class]] && [value isKindOfClass:[NSString class]]) {
                [_manager.requestSerializer setValue:(NSString *)value forHTTPHeaderField:(NSString *)httpHeaderField];
            }
        }
    }

    _manager.responseSerializer = [AFHTTPResponseSerializer serializer];

    switch (request.requestMethod) {
    case GET: {
        [_manager GET:request.url
            parameters:request.requestParams
            success:^(AFHTTPRequestOperation *operation, id responseObject) {
                [request formatResponseOperation:operation];
                [self handleResult:request error:nil];
            }
            failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                [request formatResponseOperation:operation];
                [self handleResult:request error:error];
            }];
        break;
    }
    case POST: {
        request.requestOperation = [_manager POST:request.url
            parameters:request.requestParams
            success:^(AFHTTPRequestOperation *operation, id responseObject) {
                [request formatResponseOperation:operation];
                [self handleResult:request error:nil];
            }
            failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                [request formatResponseOperation:operation];
                [self handleResult:request error:error];
            }];

        break;
    }
    case PUT: {
        request.requestOperation = [_manager PUT:request.url
            parameters:request.requestParams
            success:^(AFHTTPRequestOperation *operation, id responseObject) {
                [request formatResponseOperation:operation];
                [self handleResult:request error:nil];
            }
            failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                [request formatResponseOperation:operation];
                [self handleResult:request error:error];
            }];
        break;
    }
    case DELETE: {
        request.requestOperation = [_manager DELETE:request.url
            parameters:request.requestParams
            success:^(AFHTTPRequestOperation *operation, id responseObject) {
                [request formatResponseOperation:operation];
                [self handleResult:request error:nil];
            }
            failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                [request formatResponseOperation:operation];
                [self handleResult:request error:error];
            }];
        break;
    }
    default:
        break;
    }
    [_runningRequestArray addObject:request];
}

- (void)handleResult:(QCHttpRequest *)request error:(NSError *)error {
    [request setRequestFinished];
    
    [_runningRequestArray removeObject:request];
    [request postprocessRequest];
    
    if (request.responseStatusCode >= 200 && request.responseStatusCode <= 299) {
        if (request.successBlock) ((SuccessBlock)request.successBlock)(request);
    }else {
        if (request.failedBlock) ((FailedBlock)request.failedBlock)(request);
    }
}

- (void)clearCaches
{
    [[QCRequestCache sharedInstance] clear];
}

@end
