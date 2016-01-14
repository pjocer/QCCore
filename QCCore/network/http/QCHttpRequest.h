//
//  QCHttpRequest.h
//  QCColumbus
//
//  Created by Chen on 15/4/8.
//  Copyright (c) 2015年 Quancheng-ec. All rights reserved.
//

#import <Foundation/Foundation.h>

@class QCHttpRequest;

typedef NS_OPTIONS(short, RequestMethod) {
    GET         = 0,
    POST,
    PUT,
    DELETE
};

typedef void (^SuccessBlock)(QCHttpRequest * _Nonnull request);
typedef void (^FailedBlock)(QCHttpRequest * _Nonnull request);

@interface QCHttpRequest : NSObject
{
    @protected
    NSInteger _responseStatusCode;
    NSData *_responseData;
}

@property (nonatomic, strong, readonly, nullable) NSString *url;

@property (nonatomic, assign, readonly) RequestMethod requestMethod;

@property (nonatomic, strong, readonly, nonnull) NSDictionary *requestHeaders;

@property (nonatomic, strong, nullable) NSDictionary *requestParams;

@property (nonatomic, assign) NSTimeInterval timeoutInterval;

@property (readonly) NSInteger responseStatusCode;

@property (readonly, nullable) NSDictionary *responseHeaders;

@property (readonly, nullable) NSData *responseData;

- (nullable id)initWithUrl:(nonnull NSString *)url;
- (nullable id)initWithUrl:(nonnull NSString *)url requestMethod:(RequestMethod)requestMethod;
- (nullable id)initWithUrl:(nonnull NSString *)url requestMethod:(RequestMethod)requestMethod timeoutInterval:(NSTimeInterval)timeoutInterval;

- (void)setValue:(nonnull id)value forHTTPHeaderKey:(nonnull NSString *)HTTPHeaderKey;

- (nullable NSString *)uniqueKey;

- (void)startWithSuccessBlock:(nullable SuccessBlock)successBlock failedBlock:(nullable FailedBlock)failedBlock;

- (void)cancel;

@end
