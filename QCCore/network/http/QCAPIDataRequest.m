//
//  QCAPIDataRequest.m
//  QCCore
//
//  Created by XuQian on 1/13/16.
//  Copyright © 2016 qcwl. All rights reserved.
//

#import "QCAPIDataRequest.h"
#import "AFNetworking.h"
#import "RNDecryptor.h"
#import "UIDevice+Hardware.h"

@interface QCHttpRequest ()
- (void)formatResponseOperation:(AFHTTPRequestOperation *)operation;
- (void)postprocessRequest;
- (void)preprocessRequest;
- (void)start;
@end

@interface QCAPIRequest ()
- (void)decodeResponseData;
@end

#define ENCRYPTION_AES @"CLB_AES"
#define QCDataRequestBoundary @"us6dw2ks32i"

@implementation QCAPIDataRequest
{
    AFURLSessionManager *_manager;
    NSURLSessionConfiguration *_configuration;
    NSData *_data;
}

- (id)initWithUrl:(NSString *)url data:(NSData *)data
{
    if (self = [super initWithUrl:url requestMethod:POST]) {
        
        _data = data;
        
        _configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
        _configuration.requestCachePolicy = NSURLRequestReloadIgnoringLocalCacheData;
        _configuration.timeoutIntervalForRequest = 30;
        _configuration.discretionary = YES;
        _configuration.networkServiceType = NSURLNetworkServiceTypeBackground;
        
        [self preprocessRequest];
        
    }
    return self;
}

- (NSURLSessionUploadTask *)startWithSuccessBlock:(APIDataSuccessBlock)successBlock
                                       faildBlock:(APIDataFailedBlock)faildBlock
{
    
    _configuration.HTTPAdditionalHeaders = self.requestHeaders;
    
    _manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:_configuration];
    _manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    _manager.attemptsToRecreateUploadTasksForBackgroundSessions = YES;
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:[NSURL URLWithString:self.url]];
    [request setHTTPMethod:@"POST"];
    
    NSURLSessionUploadTask *task = [_manager uploadTaskWithRequest:request fromData:[QCAPIDataRequest requestHttpBody:_data] progress:nil completionHandler:^(NSURLResponse * _Nonnull response, id  _Nonnull responseObject, NSError * _Nonnull error) {
        
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
        _responseStatusCode = httpResponse.statusCode;
        if(_responseStatusCode == 200){
            _responseData = responseObject;
            [super decodeResponseData];
            successBlock(self);
        }else{
            faildBlock(self);
        }
    }];
    return task;
}

- (void)preprocessRequest {
    NSDictionary *bundleDict = [[NSBundle mainBundle] infoDictionary];
    NSString *version = [bundleDict objectForKey:@"CFBundleShortVersionString"];
    NSString *agent = [NSString stringWithFormat:@"(iOS;%@;%@)", [[UIDevice currentDevice] systemVersion], [UIDevice currentDevice].platform];
    
    [self.requestHeaders setValue:ENCRYPTION_AES forKey:@"Encryption"];
    [self.requestHeaders setValue:version forKey:@"VersionCode"];
    [self.requestHeaders setValue:agent forKey:@"Agent"];
    [self.requestHeaders setValue:@"application/vnd.columbus.v1+json" forKey:@"Accept"];
    [self.requestHeaders setValue:[NSString stringWithFormat:@"multipart/form-data; boundary=%@", QCDataRequestBoundary] forKey:@"Content-Type"];
}

+ (NSData *)requestHttpBody:(NSData *)imageData
{
    NSMutableData *body = [[NSMutableData alloc]init];
    if (imageData) {
        [body appendData:[[NSString stringWithFormat:@"--%@\r\n", QCDataRequestBoundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"; filename=\"image.jpg\"\r\n", @"file"] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[@"Content-Type: image/jpeg\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:imageData];
        [body appendData:[[NSString stringWithFormat:@"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    }
    [body appendData:[[NSString stringWithFormat:@"--%@--\r\n", QCDataRequestBoundary] dataUsingEncoding:NSUTF8StringEncoding]];
    return body;
}

@end
