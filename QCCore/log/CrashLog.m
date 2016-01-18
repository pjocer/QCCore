//
//  CrashLog.m
//  QCCore
//
//  Created by XuQian on 1/15/16.
//  Copyright © 2016 qcwl. All rights reserved.
//

#import "CrashLog.h"
#import "UIDevice+Hardware.h"
#import "AFNetworkReachabilityManager.h"

static inline NSString * GetCrashDateString()
{
    NSDate *date = [NSDate date];
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    [fmt setDateFormat:@"yyyy-MM-dd HH:mm:ss.SSS"];
    return [fmt stringFromDate:date];
}

@implementation CrashLog

+ (instancetype)newCrashLog
{
    return [[CrashLog alloc] init];
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super init]) {
        _crashType = [[aDecoder decodeObjectOfClass:[NSNumber class] forKey:@"crashType"] intValue];
        _signalType = [[aDecoder decodeObjectOfClass:[NSNumber class] forKey:@"signalType"] intValue];
        _name = [aDecoder decodeObjectForKey:@"name"];
        _reason = [aDecoder decodeObjectForKey:@"reason"];
        _stack = [aDecoder decodeObjectOfClass:[NSArray class] forKey:@"stack"];
        _lanchedDate = [aDecoder decodeObjectForKey:@"lanchedDate"];
        _occursDate = [aDecoder decodeObjectForKey:@"occursDate"];
        _appName = [aDecoder decodeObjectForKey:@"appName"];
        _appVersion = [aDecoder decodeObjectForKey:@"appVersion"];
        _sandbox = [aDecoder decodeObjectForKey:@"sandbox"];
        _scheme = [aDecoder decodeObjectForKey:@"scheme"];
        _channel = [aDecoder decodeObjectForKey:@"channel"];
        _platform = [aDecoder decodeObjectForKey:@"platform"];
        _osv = [aDecoder decodeObjectForKey:@"osv"];
        _network = [aDecoder decodeObjectForKey:@"network"];
        _orientation = [[aDecoder decodeObjectOfClass:[NSNumber class] forKey:@"orientation"] integerValue];
        _cpuCount = [[aDecoder decodeObjectOfClass:[NSNumber class] forKey:@"cpuCount"] intValue];
        _totalMemory = [[aDecoder decodeObjectOfClass:[NSNumber class] forKey:@"totalMemory"] unsignedLongValue];
        _userMemory = [[aDecoder decodeObjectOfClass:[NSNumber class] forKey:@"userMemory"] unsignedLongValue];
        _freeMemory = [[aDecoder decodeObjectOfClass:[NSNumber class] forKey:@"freeMemory"] unsignedLongValue];
        _pageSize = [[aDecoder decodeObjectOfClass:[NSNumber class] forKey:@"pageSize"] unsignedLongValue];
        _physMemory = [[aDecoder decodeObjectOfClass:[NSNumber class] forKey:@"physMemory"] unsignedLongValue];
        _sockBufferSize = [[aDecoder decodeObjectOfClass:[NSNumber class] forKey:@"sockBufferSize"] unsignedLongValue];
        _totalSDSize = [[aDecoder decodeObjectOfClass:[NSNumber class] forKey:@"totalSDSize"] unsignedLongValue];
        _freeSDSize = [[aDecoder decodeObjectOfClass:[NSNumber class] forKey:@"freeSDSize"] unsignedLongValue];
        _isJB = [[aDecoder decodeObjectOfClass:[NSNumber class] forKey:@"isJB"] boolValue];
        _isCYExist = [[aDecoder decodeObjectOfClass:[NSNumber class] forKey:@"isCYExist"] boolValue];
    }
    return self;
}

- (id)init
{
    if (self = [super init]) {
        _lanchedDate = GetCrashDateString();
        
        NSDictionary *bundleInfo = [[NSBundle mainBundle] infoDictionary];
        _appName = bundleInfo[@"CFBundleName"];
        _appVersion = bundleInfo[@"CFBundleVersion"];
        _sandbox = NSHomeDirectory();
#if DEBUG
        _scheme = @"DEBUG";
#else
        _scheme = @"RELEASE";
#endif
        // TODO: add Channel
        _platform = [UIDevice currentDevice].platform;
        _osv = [UIDevice currentDevice].systemVersion;
        _orientation = [UIDevice currentDevice].orientation;
        _cpuCount = (int)[UIDevice currentDevice].cpuCount;
        _isJB = [UIDevice currentDevice].isJB;
        _isCYExist = [UIDevice currentDevice].isCYExist;
    }
    return self;
}

- (void)excuteWithException:(NSException *)exception
{
    _occursDate = GetCrashDateString();
    
    _name = exception.name;
    _reason = exception.reason;
    
    NSArray *stack = exception.callStackSymbols;
    if (stack) {
        _crashType = NSObjectCrashType;
    }else {
        stack = exception.userInfo[@"stack"];
        if (stack) {
            _crashType = SignalCrashType;
            _signalType = [exception.userInfo[@"signalType"] intValue];
        }
    }
    _stack = stack;
    
    UIDevice *device = [UIDevice currentDevice];
    _totalMemory = device.totalMemory;
    _userMemory = device.userMemory;
    _freeMemory = device.getFreeMemory;
    _pageSize = device.pageSize;
    _physMemory = device.physicalMemorySize;
    _sockBufferSize = device.maxSocketBufferSize;
    _totalSDSize = [device.totalDiskSpace unsignedLongValue];
    _freeSDSize = [device.freeDiskSpace unsignedLongValue];
    _network = device.network;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:[NSNumber numberWithInt:_crashType] forKey:@"crashType"];
    [aCoder encodeObject:[NSNumber numberWithInt:_signalType] forKey:@"signalType"];
    [aCoder encodeObject:_name?:@"" forKey:@"name"];
    [aCoder encodeObject:_reason?:@"" forKey:@"reason"];
    [aCoder encodeObject:_stack?:@[] forKey:@"stack"];
    [aCoder encodeObject:_lanchedDate?:@"" forKey:@"lanchedDate"];
    [aCoder encodeObject:_occursDate?:@"" forKey:@"occursDate"];
    [aCoder encodeObject:_appName?:@"" forKey:@"appName"];
    [aCoder encodeObject:_appVersion?:@"" forKey:@"appVersion"];
    [aCoder encodeObject:_sandbox?:@"" forKey:@"sandbox"];
    [aCoder encodeObject:_scheme?:@"" forKey:@"scheme"];
    [aCoder encodeObject:_channel?:@"" forKey:@"channel"];
    [aCoder encodeObject:_platform?:@"" forKey:@"platform"];
    [aCoder encodeObject:_osv?:@"" forKey:@"osv"];
    [aCoder encodeObject:_network?:@"" forKey:@"network"];
    [aCoder encodeObject:[NSNumber numberWithInteger:_orientation] forKey:@"orientation"];
    [aCoder encodeObject:[NSNumber numberWithInt:_cpuCount] forKey:@"cpuCount"];
    [aCoder encodeObject:[NSNumber numberWithUnsignedLong:_totalMemory] forKey:@"totalMemory"];
    [aCoder encodeObject:[NSNumber numberWithUnsignedLong:_userMemory] forKey:@"userMemory"];
    [aCoder encodeObject:[NSNumber numberWithUnsignedLong:_freeMemory] forKey:@"freeMemory"];
    [aCoder encodeObject:[NSNumber numberWithUnsignedLong:_pageSize] forKey:@"pageSize"];
    [aCoder encodeObject:[NSNumber numberWithUnsignedLong:_physMemory] forKey:@"physMemory"];
    [aCoder encodeObject:[NSNumber numberWithUnsignedLong:_sockBufferSize] forKey:@"sockBufferSize"];
    [aCoder encodeObject:[NSNumber numberWithUnsignedLong:_freeSDSize] forKey:@"freeSDSize"];
    [aCoder encodeObject:[NSNumber numberWithBool:_isJB] forKey:@"isJB"];
    [aCoder encodeObject:[NSNumber numberWithBool:_isCYExist] forKey:@"isCYExist"];
}

+ (BOOL)supportsSecureCoding
{
    return YES;
}

- (NSString *)description
{
    NSMutableString *str = [NSMutableString string];
    [str appendFormat:@"crashType: %@",(_crashType==UnsetType?@"Unset":(_crashType==NSObjectCrashType?@"NSObjectCrash":@"SignalCrash"))];
    [str appendFormat:@"\nsignalType: %@",(_signalType==AbortType?@"Abort":
                                           (_signalType==IllegalInstructionType?@"IllegalInstruction":
                                            (_signalType==ZombieMemoryType?@"ZombieMemory":
                                             (_signalType==FloatingPointExceptionType?@"FloatingPointException":
                                              (_signalType==BusErrorType?@"BusError":
                                               (_signalType==WildPointerType?@"WildPointer":@"unknown"))))))];
    [str appendFormat:@"\nname: %@",_name];
    [str appendFormat:@"\nreason: %@",_reason];
    [str appendFormat:@"\nstack: %@",_stack];
    [str appendFormat:@"\nlanchedDate: %@",_lanchedDate];
    [str appendFormat:@"\noccursDate: %@",_occursDate];
    [str appendFormat:@"\nappName: %@",_appName];
    [str appendFormat:@"\nappVersion: %@",_appVersion];
    [str appendFormat:@"\nsandbox: %@",_sandbox];
    [str appendFormat:@"\nscheme: %@",_scheme];
    [str appendFormat:@"\nchannel: %@",_channel];
    [str appendFormat:@"\nplatform: %@",_platform];
    [str appendFormat:@"\nosv: %@",_osv];
    [str appendFormat:@"\nnetwork: %@",_network];
    [str appendFormat:@"\norientation: %d", (int)_orientation];
    [str appendFormat:@"\ncpuCount: %d", (int)_cpuCount];
    [str appendFormat:@"\ntotalMemory: %lu", _totalMemory];
    [str appendFormat:@"\nuserMemory: %lu", _userMemory];
    [str appendFormat:@"\nfreeMemory: %lu", _freeMemory];
    [str appendFormat:@"\npageSize: %lu", _pageSize];
    [str appendFormat:@"\nphysMemory: %lu", _physMemory];
    [str appendFormat:@"\nsockBufferSize: %lu", _sockBufferSize];
    [str appendFormat:@"\ntotalSDSize: %lu", _totalSDSize];
    [str appendFormat:@"\nfreeSDSize: %lu", _freeSDSize];
    [str appendFormat:@"\nisJailBreak: %@", _isJB?@"YES":@"NO"];
    [str appendFormat:@"\nisCydiaExist: %@", _isCYExist?@"YES":@"NO"];
    return str;
}

@end
