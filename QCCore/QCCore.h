//
//  QCCore.h
//  QCCore
//
//  Created by XuQian on 12/22/15.
//  Copyright © 2015 qcwl. All rights reserved.
//

#import <UIKit/UIKit.h>

FOUNDATION_EXPORT double QCCoreVersionNumber;
FOUNDATION_EXPORT const unsigned char QCCoreVersionString[];

/// category
#import <QCCore/UIDevice+Hardware.h>

/// network
#import <QCCore/QCNetworkService.h>
#import <QCCore/QCAPIRequest.h>
#import <QCCore/QCHttpRequest.h>
#import <QCCore/QCAPIDataRequest.h>
#import <QCCore/NetworkUtil.h>

/// log
#import <QCCore/CrashLog.h>
#import <QCCore/CrashManager.h>

/// secure
#import <QCCore/QCCodingUtilities.h>

/// debug
#import <QCCore/DebugKits.h>
#import <QCCore/QCDebugController.h>
#import <QCCore/QCDebugLogo.h>

/// location
#import <QCCore/QCLocationManager.h>

