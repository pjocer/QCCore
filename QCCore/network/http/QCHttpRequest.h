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

/// 返回请求URL
@property (nonatomic, strong, readonly, nullable) NSString *url;
/// 返回请求方法
@property (nonatomic, assign, readonly) RequestMethod requestMethod;
/// 返回请求头信息，不允许直接进行操作，指允许查看，插入头信息请使用 setValue:forHTTPHeaderKey: 函数
@property (nonatomic, strong, readonly, nonnull) NSDictionary *requestHeaders;
/// 请求传参
@property (nonatomic, strong, nullable) NSDictionary *requestParams;
/// 超时时间
@property (nonatomic, assign) NSTimeInterval timeoutInterval;
/// 返回HTTP Response Status Code
@property (readonly) NSInteger responseStatusCode;
/// 返回Response头信息
@property (readonly, nullable) NSDictionary *responseHeaders;
/// 返回Response数据
@property (readonly, nullable) NSData *responseData;
/// 请求唯一标识字符串
@property (readonly, nullable) NSString *uniqueKey;

@property (nonatomic, readonly) NSTimeInterval responseInterval;

- (nullable id)initWithUrl:(nonnull NSString *)url;
- (nullable id)initWithUrl:(nonnull NSString *)url requestMethod:(RequestMethod)requestMethod;
- (nullable id)initWithUrl:(nonnull NSString *)url requestMethod:(RequestMethod)requestMethod timeoutInterval:(NSTimeInterval)timeoutInterval;

/**
 插入请求头信息。不允许直接对requestHeader进行操作
 @param value 头信息内容
 @param HTTPHeaderKey 头信息关键字
 */
- (void)setValue:(nonnull id)value forHTTPHeaderKey:(nonnull NSString *)HTTPHeaderKey;

/**
 启动请求操作
 @param successBlock 上传成功的回调 可传nil
 @param failedBlock 上传失败的回调 可传nil
 */
- (void)startWithSuccessBlock:(nullable SuccessBlock)successBlock failedBlock:(nullable FailedBlock)failedBlock;

/// 中断请求操作
- (void)cancel;

@end
