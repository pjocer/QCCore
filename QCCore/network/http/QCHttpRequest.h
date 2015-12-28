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

typedef void (^CompletionBlock)(QCHttpRequest * _Nonnull request, NSError * _Nullable error);

@interface QCHttpRequest : NSObject
{
    @protected
    NSInteger _responseStatusCode;
    NSDictionary *_responseHeaders;
    NSData *_responseData;
    CompletionBlock _block;
}

@property (nonatomic, strong, readonly, nullable) NSString *url;

@property (nonatomic, assign, readonly) RequestMethod requestMethod;

@property (readonly, nullable) NSDictionary *requestHeaders;

@property (nonatomic, strong, readonly, nullable) NSDictionary *requestParams;

@property (nonatomic, assign) NSTimeInterval timeoutInterval;

@property (readonly) NSInteger responseStatusCode;

@property (readonly, nullable) NSDictionary *responseHeaders;

@property (readonly, nullable) NSData *responseData;

- (nullable id)initWithUrl:(nonnull NSString *)url;
- (nullable id)initWithUrl:(nonnull NSString *)url requestMethod:(RequestMethod)requestMethod;
- (nullable id)initWithUrl:(nonnull NSString *)url requestMethod:(RequestMethod)requestMethod timeoutInterval:(NSTimeInterval)timeoutInterval;

- (nullable NSString *)uniqueKey;

- (void)setValue:(nonnull id)value forHeaderField:(nonnull NSString *)headerField;

- (void)startWithCompletionBlock:(nullable CompletionBlock)block;

- (void)cancel;

@end
