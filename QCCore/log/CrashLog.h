//
//  CrashLog.h
//  QCCore
//
//  Created by XuQian on 1/15/16.
//  Copyright © 2016 qcwl. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_OPTIONS(uint8_t, CrashType) {
    UnsetType,
    NSObjectCrashType,
    SignalCrashType
};

typedef NS_OPTIONS(uint8_t, SignalType) {
    UnknownSignalType               = 0,
    AbortType                       = SIGABRT,
    IllegalInstructionType          = SIGILL,
    ZombieMemoryType                = SIGSEGV,
    FloatingPointExceptionType      = SIGFPE,
    BusErrorType                    = SIGBUS,
    WildPointerType                 = SIGPIPE
};

@interface CrashLog : NSObject <NSSecureCoding>

@property (nonatomic, assign, readonly) CrashType crashType;
@property (nonatomic, assign, readonly) SignalType signalType;
@property (nonatomic, strong, readonly, nullable) NSString *name;
@property (nonatomic, strong, readonly, nullable) NSString *reason;
@property (nonatomic, strong, readonly, nullable) NSArray *stack;
@property (nonatomic, strong, readonly, nullable) NSString *lanchedDate;
@property (nonatomic, strong, readonly, nullable) NSString *occursDate;
@property (nonatomic, strong, readonly, nullable) NSString *appName;
@property (nonatomic, strong, readonly, nullable) NSString *appVersion;
@property (nonatomic, strong, readonly, nullable) NSString *sandbox;
@property (nonatomic, strong, readonly, nullable) NSString *scheme;
@property (nonatomic, strong, readonly, nullable) NSString *channel;
@property (nonatomic, strong, readonly, nullable) NSString *platform;
@property (nonatomic, strong, readonly, nullable) NSString *osv;
@property (nonatomic, strong, readonly, nullable) NSString *apiDomain;
@property (nonatomic, assign, readonly) UIDeviceOrientation orientation;
@property (nonatomic, assign, readonly) unsigned long busFrequency;
@property (nonatomic, assign, readonly) unsigned long cpuFrequency;
@property (nonatomic, assign, readonly) int cpuCount;
@property (nonatomic, assign, readonly) unsigned long totalMemory;
@property (nonatomic, assign, readonly) unsigned long userMemory;
@property (nonatomic, assign, readonly) unsigned long freeMemory;
@property (nonatomic, assign, readonly) unsigned long pageSize;
@property (nonatomic, assign, readonly) unsigned long physMemory;
@property (nonatomic, assign, readonly) unsigned long sockBufferSize;
@property (nonatomic, assign, readonly) unsigned long totalSDSize;
@property (nonatomic, assign, readonly) unsigned long freeSDSize;
@property (nonatomic, strong, readonly, nullable) NSString *network;
@property (nonatomic, assign, readonly) BOOL isJB;
@property (nonatomic, assign, readonly) BOOL isCYExist;

+ (nullable instancetype)newCrashLog;
- (void)excuteWithException:(nonnull NSException *)exception;

@end
