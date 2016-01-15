//
//  CrashLog.m
//  QCCore
//
//  Created by XuQian on 1/15/16.
//  Copyright © 2016 qcwl. All rights reserved.
//

#import "CrashLog.h"
#import "UIDevice+Hardware.h"

@implementation CrashLog

+ (instancetype)newCrashLog
{
    return [[CrashLog alloc] init];
}

- (id)init
{
    if (self = [super init]) {
        _content = [NSMutableDictionary dictionary];
        [self setLanchedDateString:[NSDate date]];
        
        NSDictionary *bundleInfo = [[NSBundle mainBundle] infoDictionary];
        
        [self setAppName:bundleInfo[@"CFBundleName"]];
        [self setAppVersion:bundleInfo[@"CFBundleVersion"]];
        [self setSandbox:NSHomeDirectory()];
        
#if DEBUG
        [self setScheme:@"DEBUG"];
#else
        [self setScheme:@"RELEASE"];
#endif
        
        // TODO: add Channel
        [self setPlatform:[UIDevice currentDevice].platform];
        [self setOsv:[UIDevice currentDevice].systemName];
        [self setOrientation:[UIDevice currentDevice].orientation];
        [self setCpuFrequency:[UIDevice currentDevice].cpuFrequency];
        [self setBusFrequency:[UIDevice currentDevice].busFrequency];
        [self setCpuCount:[UIDevice currentDevice].cpuCount];
        [self setIsJB:[UIDevice currentDevice].isJB];
        [self setIsCYExist:[UIDevice currentDevice].isCYExist];
    }
    return self;
}

- (NSString *)description
{
    return _content.description;
}

#pragma mark - getter & setter

- (CrashType)crashType
{
    return (CrashType)[_content[@"crashType"] intValue];
}

- (SignalType)signalType
{
    return (SignalType)[_content[@"signalType"] intValue];
}

- (NSString *)name
{
    return _content[@"name"];
}

- (NSString *)reason
{
    return _content[@"reason"];
}

- (NSString *)stack
{
    return _content[@"stack"];
}

- (NSString *)lanchedDate
{
    return _content[@"lanchedDate"];
}

- (NSString *)occursDate
{
    return _content[@"occursDate"];
}

- (NSString *)appName
{
    return _content[@"appName"];
}

- (NSString *)appVersion
{
    return _content[@"appVersion"];
}

- (NSString *)sandbox
{
    return _content[@"sandbox"];
}

- (NSString *)scheme
{
    return _content[@"scheme"];
}

- (NSString *)channel
{
    return _content[@"channel"];
}

- (NSString *)platform
{
    return _content[@"platform"];
}

- (NSString *)osv
{
    return _content[@"osv"];
}

- (UIDeviceOrientation)orientation
{
    return (UIDeviceOrientation)[_content[@"orientation"] intValue];
}

- (unsigned long)cpuFrequency
{
    return [_content[@"cpuFrequency"] unsignedLongValue];
}

- (unsigned long)busFrequency
{
    return [_content[@"busFrequency"] unsignedLongValue];
}

- (int)cpuCount
{
    return [_content[@"cpuCount"] intValue];
}

- (unsigned long)totalMemory
{
    return [_content[@"totalMemory"] unsignedLongValue];
}

- (unsigned long)userMemory
{
    return [_content[@"userMemory"] unsignedLongValue];
}

- (unsigned long)freeMemory
{
    return [_content[@"freeMemory"] unsignedLongValue];
}

- (unsigned long)pageSize
{
    return [_content[@"pageSize"] unsignedLongValue];
}

- (unsigned long)physMemory
{
    return [_content[@"physMemory"] unsignedLongValue];
}

- (unsigned long)sockBufferSize
{
    return [_content[@"sockBufferSize"] unsignedLongValue];
}

- (unsigned long)totalSDSize
{
    return [_content[@"totalSDSize"] unsignedLongValue];
}

- (unsigned long)freeSDSize
{
    return [_content[@"freeSDSize"] unsignedLongValue];
}

- (NSString *)network
{
    return _content[@"network"];
}

- (BOOL)isJB
{
    return [_content[@"isJB"] boolValue];
}

- (BOOL)isCYExist
{
    return [_content[@"isCYExist"] boolValue];
}

- (void)setCrashType:(CrashType)crashType
{
    [_content setValue:[NSNumber numberWithInt:crashType] forKey:@"crashType"];
}

- (void)setSignalType:(SignalType)signalType
{
    [_content setValue:[NSNumber numberWithInt:signalType] forKey:@"signalType"];
}

- (void)setName:(NSString *)name
{
    [_content setValue:name?:@"" forKey:@"name"];
}

- (void)setReason:(NSString *)reason
{
    [_content setValue:reason?:@"" forKey:@"reason"];
}

- (void)setStack:(NSString *)stack
{
    [_content setValue:stack?:@"" forKey:@"stack"];
}

- (void)setLanchedDateString:(NSDate *)lanchedDate
{
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    [fmt setDateFormat:@"yyyy-MM-dd HH:mm:ss.SSS"];
    [_content setValue:[fmt stringFromDate:lanchedDate] forKey:@"lanchedDate"];
}

- (void)setOccursDateString:(NSDate *)occursDate
{
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    [fmt setDateFormat:@"yyyy-MM-dd HH:mm:ss.SSS"];
    [_content setValue:[fmt stringFromDate:occursDate] forKey:@"occursDate"];
}

- (void)setAppName:(NSString *)appName
{
    [_content setValue:appName?:@"" forKey:@"appName"];
}

- (void)setAppVersion:(NSString *)appVersion
{
    [_content setValue:appVersion?:@"" forKey:@"appVersion"];
}

- (void)setSandbox:(NSString *)sandbox
{
    [_content setValue:sandbox?:@"" forKey:@"sandbox"];
}

- (void)setScheme:(NSString *)scheme
{
    [_content setValue:scheme?:@"" forKey:@"scheme"];
}

- (void)setChannel:(NSString *)channel
{
    [_content setValue:channel?:@"" forKey:@"channel"];
}

- (void)setPlatform:(NSString *)platform
{
    [_content setValue:platform?:@"" forKey:@"platform"];
}

- (void)setOsv:(NSString *)osv
{
    [_content setValue:osv?:@"" forKey:@"osv"];
}

- (void)setOrientation:(UIDeviceOrientation)orientation
{
    [_content setValue:[NSNumber numberWithInt:orientation] forKey:@"orientation"];
}

- (void)setCpuFrequency:(unsigned long)cpuFrequency
{
    [_content setValue:[NSNumber numberWithUnsignedLong:cpuFrequency] forKey:@"cpuFrequency"];
}

- (void)setBusFrequency:(unsigned long)busFrequency
{
    [_content setValue:[NSNumber numberWithUnsignedLong:busFrequency] forKey:@"busFrequency"];
}

- (void)setCpuCount:(int)cpuCount
{
    [_content setValue:[NSNumber numberWithInt:cpuCount] forKey:@"cpuCount"];
}

- (void)setTotalMemory:(unsigned long)totalMemory
{
    [_content setValue:[NSNumber numberWithUnsignedLong:totalMemory] forKey:@"totalMemory"];
}

- (void)setUserMemory:(unsigned long)userMemory
{
    [_content setValue:[NSNumber numberWithUnsignedLong:userMemory] forKey:@"userMemory"];
}

- (void)setFreeMemory:(unsigned long)freeMemory
{
    [_content setValue:[NSNumber numberWithUnsignedLong:freeMemory] forKey:@"freeMemory"];
}

- (void)setPageSize:(unsigned long)pageSize
{
    [_content setValue:[NSNumber numberWithUnsignedLong:pageSize] forKey:@"pageSize"];
}

- (void)setPhysMemory:(unsigned long)physMemory
{
    [_content setValue:[NSNumber numberWithUnsignedLong:physMemory] forKey:@"physMemory"];
}

- (void)setSockBufferSize:(unsigned long)sockBufferSize
{
    [_content setValue:[NSNumber numberWithUnsignedLong:sockBufferSize] forKey:@"sockBufferSize"];
}

- (void)setTotalSDSize:(unsigned long)totalSDSize
{
    [_content setValue:[NSNumber numberWithUnsignedLong:totalSDSize] forKey:@"totalSDSize"];
}

- (void)setFreeSDSize:(unsigned long)freeSDSize
{
    [_content setValue:[NSNumber numberWithUnsignedLong:freeSDSize] forKey:@"freeSDSize"];
}

- (void)setNetwork:(NSString *)network
{
    [_content setValue:network?:@"" forKey:@"network"];
}

- (void)setIsJB:(BOOL)isJB
{
    [_content setValue:[NSNumber numberWithBool:isJB] forKey:@"isJB"];
}

- (void)setIsCYExist:(BOOL)isCYExist
{
    [_content setValue:[NSNumber numberWithBool:isCYExist] forKey:@"isCYExist"];
}

@end
