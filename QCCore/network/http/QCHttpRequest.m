//
//  QCHttpRequest.m
//  QCColumbus
//
//  Created by Chen on 15/4/8.
//  Copyright (c) 2015年 Quancheng-ec. All rights reserved.
//

#import "QCHttpRequest.h"
#import "QCNetworkService.h"
#import "AFNetworking.h"

@interface QCHttpRequest ()
{
    NSMutableDictionary *_requestHeaders;
    SuccessBlock _successBlock;
    FailedBlock _failedBlock;
}
@property (nonatomic, strong) AFHTTPRequestOperation *requestOperation;
@end

static NSTimeInterval DEFAULT_TIMEOUT_INTERVAL = 20.0f;

@implementation QCHttpRequest

- (id)initWithUrl:(NSString *)url {
    return [self initWithUrl:url requestMethod:GET];
}

- (id)initWithUrl:(NSString *)url requestMethod:(RequestMethod)requestMethod {
    return [self initWithUrl:url requestMethod:requestMethod timeoutInterval:DEFAULT_TIMEOUT_INTERVAL];
}

- (id)initWithUrl:(NSString *)url requestMethod:(RequestMethod)requestMethod timeoutInterval:(NSTimeInterval)timeoutInterval {
    self = [super init];
    if (self) {
        _url = url;
        _requestMethod = requestMethod;
        _timeoutInterval = timeoutInterval;
        _requestHeaders = [NSMutableDictionary dictionary];
        _requestParams = [NSMutableDictionary dictionary];
    }
    return self;
}

- (void)setValue:(nonnull id)value forHTTPHeaderKey:(nonnull NSString *)HTTPHeaderKey
{
    [_requestHeaders setValue:value forKey:HTTPHeaderKey];
}

- (NSString *)uniqueKey {
    NSString *uniqueKey = [NSString stringWithFormat:@"%@?", self.url];
    for (NSString *key in _requestParams) {
        uniqueKey = [uniqueKey stringByAppendingString:[NSString stringWithFormat:@"%@=", key]];
        uniqueKey = [uniqueKey stringByAppendingString:[NSString stringWithFormat:@"%@&", _requestParams[key]]];
    }
    return uniqueKey;
}

- (void)start {
    [[QCNetworkService sharedInstance] exec:self];
}

- (void)startWithSuccessBlock:(SuccessBlock)successBlock failedBlock:(FailedBlock)failedBlock
{
    _successBlock = successBlock;
    _failedBlock = failedBlock;
    [self start];
}

- (void)cancel {
    [[QCNetworkService sharedInstance] abort:self];
    _successBlock = nil;
    _failedBlock = nil;
}

- (void)formatResponseOperation:(AFHTTPRequestOperation *)operation {
    self.requestOperation = operation;
    _responseStatusCode = operation.response.statusCode;
    _responseData = operation.responseData;
}

- (void)postprocessRequest
{
    
}

- (void)preprocessRequest
{
    
}

- (NSDictionary *)requestHeaders
{
    return _requestHeaders;
}

- (NSInteger)responseStatusCode
{
    return _responseStatusCode;
}

- (NSData *)responseData
{
    return _responseData;
}

- (SuccessBlock)successBlock
{
    return _successBlock;
}

- (void)setSuccessBlock:(SuccessBlock)successBlock
{
    _successBlock = successBlock;
}

- (FailedBlock)failedBlock
{
    return _failedBlock;
}

- (void)setFailedBlock:(FailedBlock)failedBlock
{
    _failedBlock = failedBlock;
}

@end
