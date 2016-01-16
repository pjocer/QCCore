//
//  DebugKits.h
//  QCCore
//
//  Created by XuQian on 1/16/16.
//  Copyright © 2016 qcwl. All rights reserved.
//

#ifndef DebugKits_h
#define DebugKits_h

#ifdef DEBUG
#define DLog(fmt, ...) NSLog((@"%s #%d " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);
#define DTrace() NSLog(@"%s #%d DTrace", __PRETTY_FUNCTION__, __LINE__)
#else
#define DLog(...)
#define DTrace()
#endif

#endif
