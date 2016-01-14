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

/*
 创建数据上传Request
 @param apiName 传入接口名
 @param data 传入上传数据
 */
- (nullable id)initWithAPIName:(nonnull NSString *)apiName data:(nonnull NSData *)data;

/*
 启动上传操作
 @param successBlock 上传成功的回调 可传nil
 @param failedBlock 上传失败的回调 可传nil
 @return 启动上传后，返回Task信息
 */
- (nullable NSURLSessionUploadTask *)startWithSuccessBlock:(nullable APIDataSuccessBlock)successBlock
                                               failedBlock:(nullable APIDataFailedBlock)failedBlock;

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
- (nullable id)initWithAPIName:(nonnull NSString *)apiName requestMethod:(RequestMethod)requestMethod NS_UNAVAILABLE;
/// @unavailable 弃用父类函数
- (void)startWithAPISuccessBlock:(nullable APISuccessBlock)successBlock APIFailedBlock:(nullable APISuccessBlock)failedBlock NS_UNAVAILABLE;

@end
