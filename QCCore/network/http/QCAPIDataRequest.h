//
//  QCAPIDataRequest.h
//  QCCore
//
//  Created by XuQian on 1/13/16.
//  Copyright © 2016 qcwl. All rights reserved.
//

#import <QCCore/QCCore.h>

@class QCAPIDataRequest;

typedef void (^APIDataSuccessBlock)(QCAPIDataRequest * _Nonnull request);
typedef void (^APIDataFailedBlock)(QCAPIDataRequest * _Nonnull request);

@interface QCAPIDataRequest : QCAPIRequest

- (nullable id)initWithUrl:(nonnull NSString *)url data:(nonnull NSData *)data;

- (nullable NSURLSessionUploadTask *)startWithSuccessBlock:(nullable APIDataSuccessBlock)successBlock
                                                faildBlock:(nullable APIDataFailedBlock)faildBlock;

#pragma mark - 失效函数
/// @unavailable 弃用父类函数
- (nullable id)initWithUrl:(nonnull NSString *)url NS_UNAVAILABLE;
/// @unavailable 弃用父类函数
- (nullable id)initWithUrl:(nonnull NSString *)url requestMethod:(RequestMethod)requestMethod NS_UNAVAILABLE;
/// @unavailable 弃用父类函数
- (nullable id)initWithUrl:(nonnull NSString *)url requestMethod:(RequestMethod)requestMethod timeoutInterval:(NSTimeInterval)timeoutInterval NS_UNAVAILABLE;
/// @unavailable 弃用父类函数
- (nullable id)initWithUrl:(nonnull NSString *)url requestMethod:(RequestMethod)requestMethod timeoutInterval:(NSTimeInterval)timeoutInterval cacheStrategy:(CacheStrategy)cacheStrategy NS_UNAVAILABLE;
/// @unavailable 弃用父类函数
- (void)startWithAPISuccessBlock:(nullable APISuccessBlock)successBlock APIFailedBlock:(nullable APISuccessBlock)failedBlock NS_UNAVAILABLE;

@end
