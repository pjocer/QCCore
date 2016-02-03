//
//  CrashManager.h
//  QCCore
//
//  Created by XuQian on 1/16/16.
//  Copyright © 2016 qcwl. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CrashLog.h"

@interface CrashManager : NSObject

/// manager单例
+ (instancetype)manager;
- (id)init NS_UNAVAILABLE;

/// 在APP启动时安装崩溃观察者
- (void)installCrashHandler;

/// 显示未check的崩溃日志名，日志名不是日志详情，使用crashLogWithName:来获取详情
@property (nonatomic, readonly) NSArray *unCheckedLogNames;

/// 显示所有的崩溃日志名
@property (nonatomic, readonly) NSArray *allLogNames;

/// 通过文件名获取一个日志
- (CrashLog *)crashLogWithName:(NSString *)name;

/**
 给某个崩溃日志设置状态为checked
 @param name 传入日志文件名
 */
- (void)checkLogWithName:(NSString *)name;

/// 清空所有历史日志
- (void)clearHistoryLogs;

@end
