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
    }
    return self;
}

- (NSString *)uniqueKey {
    NSString *uniqueKey = [NSString stringWithFormat:@"%@?", self.url];
    for (NSString *key in _requestParams) {
        uniqueKey = [uniqueKey stringByAppendingString:[NSString stringWithFormat:@"%@=", key]];
        uniqueKey = [uniqueKey stringByAppendingString:[NSString stringWithFormat:@"%@&", _requestParams[key]]];
    }
    return uniqueKey;
}

- (void)setValue:(id)value forHeaderField:(NSString *)headerField
{
    NSParameterAssert(value);
    NSParameterAssert(headerField);
    [_requestHeaders setValue:value forKey:headerField];
}

- (void)start {
    [[QCNetworkService sharedInstance] exec:self];
}

- (void)startWithCompletionBlock:(nullable CompletionBlock)block {
    _block = block;
    [self start];
}

- (void)cancel {
    [[QCNetworkService sharedInstance] abort:self];
    _block = nil;
}

- (void)formatResponseOperation:(AFHTTPRequestOperation *)operation {
    self.requestOperation = operation;
    _responseStatusCode = operation.response.statusCode;
    _responseHeaders = operation.response.allHeaderFields;
    _responseData = operation.responseData;
}

- (NSDictionary *)requestHeaders
{
    return _requestHeaders;
}

- (NSInteger)responseStatusCode
{
    return _responseStatusCode;
}

- (NSDictionary *)responseHeaders
{
    return _responseHeaders;
}

- (NSData *)responseData
{
    return _responseData;
}

- (CompletionBlock)completionBlock
{
    return _block;
}

@end
