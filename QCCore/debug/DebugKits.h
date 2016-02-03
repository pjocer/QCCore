//
//  DebugKits.h
//  QCCore
//
//  Created by XuQian on 2/3/16.
//  Copyright © 2016 qcwl. All rights reserved.
//

#import <Foundation/Foundation.h>

/// QCCore内部调试模式
FOUNDATION_EXTERN BOOL QCCoreDebugMode();
/// QCCore内部调试模式开关
FOUNDATION_EXTERN void QCCoreDebugModeEnable(BOOL enable);

#ifdef DEBUG
/// 后台输出函数
#define DLog(fmt, ...) NSLog((@"%s #%d " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);
/// 后台打点函数
#define DTrace() NSLog(@"%s #%d DTrace", __PRETTY_FUNCTION__, __LINE__)
#else
#define DLog(...)
#define DTrace()
#endif
