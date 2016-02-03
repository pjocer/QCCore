//
//  CrashManager.m
//  QCCore
//
//  Created by XuQian on 1/16/16.
//  Copyright © 2016 qcwl. All rights reserved.
//

#import "CrashManager.h"
#import "UIDevice+Hardware.h"
#include <libkern/OSAtomic.h>
#include <execinfo.h>

volatile int32_t CrashCount = 0;
const int32_t CrashMaximum = 10;

@interface CrashManager ()
- (void)saveCrashLog:(NSException *)exception;
@end

static inline NSString * XQCrashLogPath()
{
    return [NSTemporaryDirectory() stringByAppendingPathComponent:@"crashLogs"];
}

NSArray * crashBacktrace()
{
    void* callstack[128];
    int frames = backtrace(callstack, 128);
    char **strs = backtrace_symbols(callstack, frames);
    
    NSMutableArray *backtrace = [NSMutableArray arrayWithCapacity:frames];
    int i = 0;
    while (strs[i]) {
        [backtrace addObject:[NSString stringWithUTF8String:strs[i]]];
        i++;
    }
    free(strs);
    
    return backtrace;
}

static void HandleException(NSException *exception)
{
    [[CrashManager manager] performSelectorOnMainThread:@selector(saveCrashLog:) withObject:exception waitUntilDone:YES];
}

static void SignalHandler(int signal)
{
    int32_t exceptionCount = OSAtomicIncrement32(&CrashCount);
    if (exceptionCount > CrashMaximum) return;
    NSMutableDictionary *userInfo = [NSMutableDictionary dictionaryWithObject:[NSNumber numberWithInt:signal] forKey:@"signalType"];
    NSArray *callStack = crashBacktrace();
    [userInfo setObject:callStack forKey:@"stack"];
    NSException *exp = [NSException exceptionWithName:@"Signal Type Crash" reason:[NSString stringWithFormat:@"Signal %d was raised.",signal] userInfo:userInfo];
    [[CrashManager manager] performSelectorOnMainThread:@selector(saveCrashLog:) withObject:exp waitUntilDone:YES];
}

@implementation CrashManager
{
    CrashLog *_currentLog;
    NSString *_logName;
    NSString *_logPath;
    NSMutableArray *_logStatus;
}

+ (instancetype)manager
{
    static CrashManager *manager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[CrashManager alloc] _init];
    });
    return manager;
}

- (id)_init
{
    if (self = [super init]) {
        
        if (![[NSFileManager defaultManager] fileExistsAtPath:XQCrashLogPath()]) {
            [[NSFileManager defaultManager] createDirectoryAtPath:XQCrashLogPath() withIntermediateDirectories:YES attributes:nil error:nil];
        }
        _logName = [NSString stringWithFormat:@"%.0f.dat",[[NSDate date] timeIntervalSince1970]];
        _logPath = [XQCrashLogPath() stringByAppendingPathComponent:_logName];
        
        NSString *statusPath = [XQCrashLogPath() stringByAppendingPathComponent:@"info.plist"];
        if ([[NSFileManager defaultManager] fileExistsAtPath:statusPath]) {
            _logStatus = [NSMutableArray arrayWithContentsOfFile:statusPath];
        }else {
            _logStatus = [NSMutableArray array];
            [_logStatus writeToFile:statusPath atomically:YES];
        }
    }
    return self;
}

- (NSArray *)unCheckedLogNames
{
    NSMutableArray *logs = [NSMutableArray array];
    for (NSDictionary *dic in _logStatus) {
        if (![dic[@"status"] boolValue]) {
            [logs addObject:dic];
        }
    }
    return logs;
}

- (NSArray *)allLogNames
{
    return _logStatus;
}

- (CrashLog *)crashLogWithName:(NSString *)name
{
    NSParameterAssert(name);
    
    NSString *path = [XQCrashLogPath() stringByAppendingPathComponent:name];
    return [NSKeyedUnarchiver unarchiveObjectWithFile:path];
}

- (void)checkLogWithName:(NSString *)name
{
    [_logStatus enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSDictionary *dic = obj;
        if ([dic[@"name"] isEqualToString:name]) {
            NSMutableDictionary *newDic = [NSMutableDictionary dictionaryWithDictionary:dic];
            [newDic setObject:[NSNumber numberWithBool:YES] forKey:@"status"];
            [_logStatus replaceObjectAtIndex:idx withObject:newDic];
            return;
        }
    }];
}

- (void)installCrashHandler
{
    NSSetUncaughtExceptionHandler(&HandleException);
    signal(SIGABRT, &SignalHandler);
    signal(SIGILL, &SignalHandler);
    signal(SIGSEGV, &SignalHandler);
    signal(SIGFPE, &SignalHandler);
    signal(SIGBUS, &SignalHandler);
    signal(SIGPIPE, &SignalHandler);
    
    _currentLog = [CrashLog newCrashLog];
}

- (void)saveCrashLog:(NSException *)exception
{
    [_currentLog excuteWithException:exception];
    
    CoreLog(@"%@", _currentLog);
    
    [NSKeyedArchiver archiveRootObject:_currentLog toFile:_logPath];
    [_logStatus insertObject:@{@"name":_logName, @"status":[NSNumber numberWithBool:NO]} atIndex:0];
    [_logStatus writeToFile:[XQCrashLogPath() stringByAppendingPathComponent:@"info.plist"] atomically:YES];
}

- (void)clearHistoryLogs
{
    NSArray *paths = [[NSFileManager defaultManager] subpathsAtPath:XQCrashLogPath()];
    for (NSString *path in paths) {
        if (![path isEqualToString:@"info.plist"]) {
            [[NSFileManager defaultManager] removeItemAtPath:[XQCrashLogPath() stringByAppendingPathComponent:path] error:nil];
        }
    }
    
    NSString *statusPath = [XQCrashLogPath() stringByAppendingPathComponent:@"info.plist"];
    [@[] writeToFile:statusPath atomically:YES];
}

@end
