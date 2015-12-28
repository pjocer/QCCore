//
//  QCBaseRequest.h
//  QCCore
//
//  Created by Chen on 15/4/1.
//  Copyright (c) 2015年 Quancheng-ec. All rights reserved.
//

#import "QCHttpRequest.h"
@class QCAPIRequest;

FOUNDATION_EXTERN NSString * _Nonnull const APIRequestErrorMessage;

typedef void (^APICompletionBlock)(QCAPIRequest * _Nonnull request, NSError * _Nullable error);

/**
 网络数据的缓存策略
 */
typedef NS_OPTIONS(short, CacheStrategy) {
    /// 网络数据的缓存策略：不缓存
    CacheStrategyNone               = 0,
    /// 网络数据的缓存策略：5分钟
    CacheStrategyNormal,
    /// 网络数据的缓存策略：1小时
    CacheStrategyHourly,
    /// 网络数据的缓存策略：1天
    CacheStrategyDaily,
    /// 网络数据的缓存策略：永久
    CacheStrategyPersist,
    /// 网络数据的缓存策略：优先读取缓存，请求结束刷新缓存
    CacheStrategyCachePrecedence
};

@interface QCAPIRequest : QCHttpRequest

//Whether response data is from cache or not
@property (nonatomic, assign, readonly) BOOL isFromCache;

//The strategy of how to use cache
@property (nonatomic, assign) CacheStrategy cacheStrategy;

//Response data in dictionary format
@property (nonatomic, strong, readonly, nullable) NSDictionary *responseDict;

//已将responseModel替换为只读属性访问

/// API返回状态码
@property (readonly) int status;
/// API返回数据内容
@property (readonly, nullable) NSDictionary *data;
/// API返回附加信息
@property (readonly, nullable) NSString *message;

/**
 创建请求
 @param url 非空的请求地址
 @param requestMethod 即HTTPMethod
 @param timeoutInterval 超时时间
 @param cacheStrategy 缓存策略
 @return QCAPIRequest对象
*/
- (nullable id)initWithUrl:(nonnull NSString *)url
             requestMethod:(RequestMethod)requestMethod
           timeoutInterval:(NSTimeInterval)timeoutInterval
             cacheStrategy:(CacheStrategy)cacheStrategy;

- (void)startWithAPICompletionBlock:(nullable APICompletionBlock)block;

@end


