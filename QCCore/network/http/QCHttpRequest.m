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
    NSDate *_startDate;
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
    _startDate = [NSDate date];
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

- (void)setRequestFinished
{
    _responseInterval = [[NSDate date] timeIntervalSinceDate:_startDate];
    DLog(@"ResponseInterval= %.3f, ResponseLength= %lu, URL= %@",self.responseInterval, (unsigned long)self.responseData.length, self.url);
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

- (NSString *)description
{
    NSMutableString *desc = [NSMutableString string];
    [desc appendString:[super description]];
    [desc appendFormat:@"\nURL= %@",self.url];
    [desc appendFormat:@"\nMethod= %@", (self.requestMethod == GET?@"GET":(self.requestMethod == POST?@"POST":(self.requestMethod == PUT?@"PUT":@"DELETE")))];
    [desc appendFormat:@"\nTimeOut= %.3fs",self.timeoutInterval];
    [desc appendFormat:@"\nHeaders= %@",self.requestHeaders.description];
    [desc appendFormat:@"\nParameters= %@",self.requestParams.description];
    [desc appendFormat:@"\nResponseCode= %d",(int)self.responseStatusCode];
    [desc appendFormat:@"\nResponseDataLength= %ld", (long)self.responseData.length];
    [desc appendFormat:@"\nResponseInterval= %.3f",self.responseInterval];
    return desc;
}

@end
