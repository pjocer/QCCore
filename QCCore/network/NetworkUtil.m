//
//  NetworkUtil.m
//  browserHD
//
//  Created by kevinxu on 13-5-7.
//  Copyright (c) 2013年 Terry. All rights reserved.
//

#import "NetworkUtil.h"
#include <ifaddrs.h>
#include <arpa/inet.h>
#include <net/if_var.h>
#import <CoreTelephony/CTCarrier.h>
#import <CoreTelephony/CTTelephonyNetworkInfo.h>
#import <SystemConfiguration/SystemConfiguration.h>

#import <sys/socket.h>
#import <netinet/in.h>
#import <netinet6/in6.h>
#import <netdb.h>

NSString * const NetworkStatusChangedNotification = @"__networkStatusChanged";

static void ReachabilityCallback(SCNetworkReachabilityRef target, SCNetworkReachabilityFlags flags, void* info) {
    
#pragma unused (target, flags)
    NSCAssert(info, @"info was NULL in ReachabilityCallback");
    NSCAssert([(NSObject*)CFBridgingRelease(info) isKindOfClass: [NetSniffer class]], @"info was the wrong class in ReachabilityCallback");
    
    @autoreleasepool {
        [[NSNotificationCenter defaultCenter] postNotificationName:NetworkStatusChangedNotification object:(__bridge NetSniffer *)info];
    }
}

@implementation NetSniffer
{
    SCNetworkReachabilityRef _reachabilityRef;
}

+ (NetSniffer *)defaultSniffer
{
    static NetSniffer *defaultSniffer;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        defaultSniffer = [[NetSniffer alloc] init];
    });
    return defaultSniffer;
}

- (id)init
{
    if (self = [super init]) {
        struct sockaddr_in zeroAddress;
        bzero(&zeroAddress, sizeof(zeroAddress));
        zeroAddress.sin_len = sizeof(zeroAddress);
        zeroAddress.sin_family = AF_INET;
        
        SCNetworkReachabilityRef ref = SCNetworkReachabilityCreateWithAddress(kCFAllocatorDefault, (const struct sockaddr*)&zeroAddress);
        if (ref) {
            _reachabilityRef = ref;
            [self startSnif];
        }
    }
    return self;
}

- (void)dealloc
{
    [self stopSnif];
    _reachabilityRef = NULL;
}

- (BOOL)startSnif {
    SCNetworkReachabilityContext context = {0, (__bridge void * _Nullable)(self), NULL, NULL, NULL};
    if(SCNetworkReachabilitySetCallback(_reachabilityRef, ReachabilityCallback, &context)) {
        if(SCNetworkReachabilityScheduleWithRunLoop(_reachabilityRef, CFRunLoopGetCurrent(), kCFRunLoopDefaultMode)) {
            return YES;
        }
    }
    return NO;
}

- (void)stopSnif {
    if(_reachabilityRef) {
        SCNetworkReachabilityUnscheduleFromRunLoop(_reachabilityRef, CFRunLoopGetCurrent(), kCFRunLoopDefaultMode);
    }
}

- (NetworkStatus)currentStatus {
    
    NSAssert(_reachabilityRef, @"currentReachabilityStatus called with NULL reachabilityRef");
    
    SCNetworkReachabilityFlags flags = 0;
    NetworkStatus status = 0;
    
    if (SCNetworkReachabilityGetFlags(_reachabilityRef, &flags)) {
        status = [self networkStatusForFlags:flags];
        return status;
    }
    return NetworkNotConnect;
}

- (NSString *)currentStatusString
{
    switch ([NetSniffer defaultSniffer].currentStatus) {
        case NetworkNotConnect: return @"unconnect";
            break;
        case NetworkViaWIFI: return @"wifi";
            break;
        case NetworkViaWWAN: return @"wwan";
            break;
    }
}

const SCNetworkReachabilityFlags kConnectionDown =  kSCNetworkReachabilityFlagsConnectionRequired |
kSCNetworkReachabilityFlagsTransientConnection;

- (NetworkStatus)networkStatusForFlags:(SCNetworkReachabilityFlags) flags {
    if (flags & kSCNetworkReachabilityFlagsReachable) {
        if (flags & kSCNetworkReachabilityFlagsIsWWAN) { return NetworkViaWWAN; }
        
        flags &= ~kSCNetworkReachabilityFlagsReachable;
        flags &= ~kSCNetworkReachabilityFlagsIsDirect;
        flags &= ~kSCNetworkReachabilityFlagsIsLocalAddress;
        
        if (flags == kConnectionDown) { return NetworkNotConnect; }
        
        if (flags & kSCNetworkReachabilityFlagsTransientConnection)  { return NetworkViaWIFI; }
        
        if (flags == 0) { return NetworkViaWIFI; }

        if (flags & kSCNetworkReachabilityFlagsConnectionRequired) { return NetworkViaWIFI; }
        
        return 0;
    }
    return 0;
}

@end

NSString *IPAddress()
{
    NSString *address;
    struct ifaddrs *interfaces = NULL;
    struct ifaddrs *temp_addr = NULL;
    int success = 0;
    
    success = getifaddrs(&interfaces);
    if (success == 0)
    {
        temp_addr = interfaces;
        while(temp_addr != NULL)
        {
            if(temp_addr->ifa_addr->sa_family == AF_INET)
            {
                if([[NSString stringWithUTF8String:temp_addr->ifa_name] isEqualToString:@"en0"])
                {
                    address = [NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *)temp_addr->ifa_addr)->sin_addr)];
                }
            }
            temp_addr = temp_addr->ifa_next;
        }
    }
    freeifaddrs(interfaces);
    return address;
}

NSDictionary<NSString *, NSNumber *> * NetworkFlowNumbers()
{
    BOOL success;
    struct ifaddrs *addrs;
    struct ifaddrs *cursor;
    struct if_data *networkStatisc;
    unsigned long long WiFiSent = 0;
    unsigned long long WiFiReceived = 0;
    unsigned long long WWANSent = 0;
    unsigned long long WWANReceived = 0;
    NSString *name;
    success = getifaddrs(&addrs) == 0;
    if (success)
    {
        cursor = addrs;
        while (cursor != NULL)
        {
            name=[NSString stringWithFormat:@"%s",cursor->ifa_name];
            if (cursor->ifa_addr->sa_family == AF_LINK)
            {
                if ([name hasPrefix:@"en"])
                {
                    networkStatisc = (struct if_data *) cursor->ifa_data;
                    WiFiSent+=networkStatisc->ifi_obytes;
                    WiFiReceived+=networkStatisc->ifi_ibytes;
                }
                if ([name hasPrefix:@"pdp_ip"])
                {
                    networkStatisc = (struct if_data *) cursor->ifa_data;
                    WWANSent+=networkStatisc->ifi_obytes;
                    WWANReceived+=networkStatisc->ifi_ibytes;
                }
            }
            cursor = cursor->ifa_next;
        }
        freeifaddrs(addrs);
    }
    return @{WIFISentName:[NSNumber numberWithUnsignedLongLong:WiFiSent], WIFIReceviedName:[NSNumber numberWithUnsignedLongLong:WiFiReceived], WWANSentName:[NSNumber numberWithUnsignedLongLong:WWANSent], WWANReceviedName:[NSNumber numberWithUnsignedLongLong:WWANReceived]};
}

NSString * const WIFIReceviedName = @"wifi_received";
NSString * const WIFISentName = @"wifi_sent";
NSString * const WWANReceviedName = @"wwan_received";
NSString * const WWANSentName = @"wwan_sent";
