//
//  DebugKits.m
//  QCCore
//
//  Created by XuQian on 2/3/16.
//  Copyright © 2016 qcwl. All rights reserved.
//

#import "DebugKits.h"

static BOOL __Core_Debug_Mode__ = NO;

BOOL QCCoreDebugMode()
{
    return __Core_Debug_Mode__;
}

void QCCoreDebugModeEnable(BOOL enable)
{
    __Core_Debug_Mode__ = enable;
}

