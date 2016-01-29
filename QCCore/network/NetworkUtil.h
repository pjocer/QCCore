//
//  NetworkUtil.h
//  browserHD
//
//  Created by kevinxu on 13-5-7.
//  Copyright (c) 2013年 Terry. All rights reserved.
//

#import <Foundation/Foundation.h>

FOUNDATION_EXTERN NSString * const NetworkStatusChangedNotification;

typedef enum{
    NetworkNotConnect,
    NetworkViaWWAN,
    NetworkViaWIFI
}NetworkStatus;

@interface NetSniffer : NSObject

+ (NetSniffer *)defaultSniffer;
- (BOOL)startSnif;

@property (nonatomic, readonly) NetworkStatus currentStatus;
@property (readonly) NSString *currentStatusString;

@end

FOUNDATION_EXTERN NSString * const WIFIReceviedName;
FOUNDATION_EXTERN NSString * const WIFISentName;
FOUNDATION_EXTERN NSString * const WWANReceviedName;
FOUNDATION_EXTERN NSString * const WWANSentName;

//FOUNDATION_EXPORT NetworkStatus CurrentNetworkStatus();
FOUNDATION_EXPORT NSString* IPAddress();
FOUNDATION_EXPORT NSDictionary<NSString *, NSNumber *> * NetworkFlowNumbers();

