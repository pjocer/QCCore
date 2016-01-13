//
//  QCBaseRequest.m
//  QCCore
//
//  Created by Chen on 15/4/1.
//  Copyright (c) 2015年 Quancheng-ec. All rights reserved.
//

#import "QCAPIRequest.h"
#import "QCNetworkService.h"
#import "QCRequestCache.h"
#import "sys/utsname.h"
#import "RNDecryptor.h"
#import "AFNetworking.h"
#import "UIDevice+Hardware.h"

#define ENCRYPTION_AES @"CLB_AES"
#define ENCRYOT_PASSWORD @"ELQmHaX5ECDEJDd5r19eAWdZBzIwci4u"

//隐藏了AFNetorking相关内容

@interface QCHttpRequest ()
- (void)formatResponseOperation:(AFHTTPRequestOperation *)operation;
- (void)postprocessRequest;
- (void)preprocessRequest;
- (void)start;
@end

@implementation QCAPIRequest
{
    APISuccessBlock _successBlock;
    APIFailedBlock _failedBlock;
}

- (id)initWithUrl:(NSString *)url requestMethod:(RequestMethod)requestMethod timeoutInterval:(NSTimeInterval)timeoutInterval cacheStrategy:(CacheStrategy)cacheStrategy {
    self = [super initWithUrl:url requestMethod:requestMethod timeoutInterval:timeoutInterval];
    if (self) {
        _cacheStrategy = cacheStrategy;
    }
    return self;
}

- (void)start
{
    [super start];
}

- (void)startRequest {
    //Tricky settings for api domain
//    NSString *apiDomain = [[NSUserDefaults standardUserDefaults] objectForKey:@"CustomDomain"];
//    if (apiDomain.length > 0) {
//        self.url = [self.url stringByReplacingOccurrencesOfString:APIHost withString:apiDomain];
//    }
    
    if (_cacheStrategy != CacheStrategyNone) {
        NSData *cacheResponseData = [[QCRequestCache sharedInstance] get:self];
        if (cacheResponseData) {
            _responseStatusCode = 200;
            _responseData = cacheResponseData;
            [self decodeResponseData];
            _isFromCache = YES;
            if (_successBlock) _successBlock(self);

            if (_cacheStrategy != CacheStrategyCachePrecedence) return;
        }
    }
    [super start];
}

- (void)startWithAPISuccessBlock:(APISuccessBlock)successBlock APIFailedBlock:(APISuccessBlock)failedBlock
{
    _successBlock = successBlock;
    _failedBlock = failedBlock;
    [self startRequest];
}

- (void)formatResponseOperation:(AFHTTPRequestOperation *)operation {
    [super formatResponseOperation:operation];
    [self decodeResponseData];
}

- (void)decodeResponseData {

    NSError *error = nil;
    if (self.responseData != nil && self.responseData.length > 0) {
        NSData *decodedBase64Data = [[NSData alloc] initWithBase64EncodedData:self.responseData options:0];
        NSData *decryptedData = [RNDecryptor decryptData:decodedBase64Data
                                            withPassword:ENCRYOT_PASSWORD
                                                   error:&error];

        _responseDict = [NSJSONSerialization JSONObjectWithData:decryptedData options:NSJSONReadingMutableLeaves error:&error];
    } else {
        _responseDict = nil;
    }
}

- (void)preprocessRequest {
    [super preprocessRequest];
    NSDictionary *bundleDict = [[NSBundle mainBundle] infoDictionary];
    NSString *version = [bundleDict objectForKey:@"CFBundleShortVersionString"];
    NSString *agent = [NSString stringWithFormat:@"(iOS;%@;%@)", [[UIDevice currentDevice] systemVersion], [UIDevice currentDevice].platform];
    
    [self.requestHeaders setValue:ENCRYPTION_AES forKey:@"Encryption"];
    [self.requestHeaders setValue:version forKey:@"VersionCode"];
    [self.requestHeaders setValue:agent forKey:@"Agent"];
    [self.requestHeaders setValue:@"application/vnd.columbus.v1+json" forKey:@"Accept"];
}

- (void)postprocessRequest {
    [super postprocessRequest];
    if (self.cacheStrategy != CacheStrategyNone && self.responseData.length > 0 && self.status == 0) {
        [[QCRequestCache sharedInstance] put:self];
    }
    
    _isFromCache = NO;
}

// 拆分了responseModel

- (int)status
{
    if (_responseDict && _responseDict[@"status"])
        return [_responseDict[@"status"] intValue];
    return -1;
}

- (NSDictionary *)data
{
    if (_responseDict && _responseDict[@"data"]) return _responseDict[@"data"];
    return nil;
}

- (NSString *)message
{
    if (_responseDict && _responseDict[@"message"]) return _responseDict[@"message"];
    return nil;
}

- (APISuccessBlock)successBlock
{
    return _successBlock;
}

- (void)setSuccessBlock:(APISuccessBlock)successBlock
{
    _successBlock = successBlock;
}

- (APIFailedBlock)failedBlock
{
    return _failedBlock;
}

- (void)setFailedBlock:(APIFailedBlock)failedBlock
{
    _failedBlock = failedBlock;
}

@end