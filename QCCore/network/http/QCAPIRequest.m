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
//#import "DebugManager.h"

#define ENCRYPTION_AES @"CLB_AES"
#define ENCRYOT_PASSWORD @"ELQmHaX5ECDEJDd5r19eAWdZBzIwci4u"

#ifdef DEBUG
NSString *const DefaultAPIHost = @"http://api.qccost.com/";
NSString *const TrialAPIHost = @"http://trial.fk.com/api/";
#else
NSString *const DefaultAPIHost = @"http://api.qccost.com/";
NSString *const TrialAPIHost = @"http://trial.qccost.com/";
#endif

static Domain *__currentDomain = nil;

Domain * QCCurrentDomain()
{
    return __currentDomain;
}

void QCChangeCurrentDomain( Domain * domain)
{
    __currentDomain = domain;
}

// 配合deprecated方法写的函数，去除deprecated函数后可以删除
static inline NSString * FilteURLDomain(NSString * url)
{
    if ([url rangeOfString:DefaultAPIHost].location != NSNotFound) {
        return [url stringByReplacingOccurrencesOfString:DefaultAPIHost withString:QCCurrentDomain().domain];
    }else if ([url rangeOfString:TrialAPIHost].location != NSNotFound) {
        return [url stringByReplacingOccurrencesOfString:TrialAPIHost withString:QCCurrentDomain().domain];
    }
    return url;
}

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

- (nullable id)initWithAPIName:(nonnull APIName *)apiName
                 requestMethod:(RequestMethod)requestMethod {
    self = [super initWithUrl:[NSString stringWithFormat:@"%@%@", QCCurrentDomain().domain, apiName] requestMethod:requestMethod];
    return self;
}

- (void)startRequest {
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
    if (_responseDict && _responseDict[@"status"]) return [_responseDict[@"status"] intValue];
    return -1;
}

- (NSDictionary *)data
{
    if (_responseDict && _responseDict[@"data"] && [_responseDict[@"data"] isKindOfClass:[NSDictionary class]]) return _responseDict[@"data"];
    return nil;
}

- (NSString *)message
{
    if (_responseDict && _responseDict[@"message"] && [_responseDict[@"message"] isKindOfClass:[NSString class]]) return _responseDict[@"message"];
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

- (NSString *)description
{
    NSMutableString *desc = [NSMutableString string];
    [desc appendString:[super description]];
    [desc appendFormat:@"\nResponseStatus= %d", (int)self.status];
    [desc appendFormat:@"\nResponseMessage= %@", self.message];
    [desc appendFormat:@"\nResponseData= %@", self.data];
    return desc;
}

#pragma mark - deprecated

- (id)initWithUrl:(NSString *)url
{
    self = [super initWithUrl:FilteURLDomain(url)];
    [self.requestHeaders setValuesForKeysWithDictionary:[QCNetworkService sharedInstance].deprecatedHeader];
    return self;
}

- (id)initWithUrl:(NSString *)url requestMethod:(RequestMethod)requestMethod
{
    self = [super initWithUrl:FilteURLDomain(url) requestMethod:requestMethod];
    [self.requestHeaders setValuesForKeysWithDictionary:[QCNetworkService sharedInstance].deprecatedHeader];
    return self;
}

- (id)initWithUrl:(NSString *)url requestMethod:(RequestMethod)requestMethod timeoutInterval:(NSTimeInterval)timeoutInterval
{
    self = [super initWithUrl:FilteURLDomain(url) requestMethod:requestMethod timeoutInterval:timeoutInterval];
    [self.requestHeaders setValuesForKeysWithDictionary:[QCNetworkService sharedInstance].deprecatedHeader];
    return self;
}

- (void)start
{
    [super start];
}

@end


