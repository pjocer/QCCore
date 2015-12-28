//
//  UIDevice+Hardware.m
//  XQBase
//
//  Created by kevinxuls on 10/12/15.
//  Copyright © 2015 kevinxuls. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIDevice (Hardware)

/**
 返回设备模型标识
 @return @"i386"      on the simulator
 @return @"iPod1,1"   on iPod Touch
 @return @"iPod2,1"   on iPod Touch Second Generation
 @return @"iPod3,1"   on iPod Touch Third Generation
 @return @"iPod4,1"   on iPod Touch Fourth Generation
 @return @"iPod5,1"   on iPod Touch Fifth Generation
 @return @"iPhone1,1" on iPhone
 @return @"iPhone1,2" on iPhone 3G
 @return @"iPhone2,1" on iPhone 3GS
 @return @"iPad1,1"   on iPad
 @return @"iPad2,1"   on iPad 2
 @return @"iPad3,1"   on 3rd Generation iPad
 @return @"iPad3,2":  on iPad 3(GSM+CDMA)
 @return @"iPad3,3":  on iPad 3(GSM)
 @return @"iPad3,4":  on iPad 4(WiFi)
 @return @"iPad3,5":  on iPad 4(GSM)
 @return @"iPad3,6":  on iPad 4(GSM+CDMA)
 @return @"iPhone3,1" on iPhone 4
 @return @"iPhone4,1" on iPhone 4S
 @return @"iPhone5,1" on iPhone 5
 @return @"iPad3,4"   on 4th Generation iPad
 @return @"iPad2,5"   on iPad Mini
 @return @"iPhone5,1" on iPhone 5(GSM)
 @return @"iPhone5,2" on iPhone 5(GSM+CDMA)
 @return @"iPhone5,3  on iPhone 5c(GSM)
 @return @"iPhone5,4" on iPhone 5c(GSM+CDMA)
 @return @"iPhone6,1" on iPhone 5s(GSM)
 @return @"iPhone6,2" on iPhone 5s(GSM+CDMA)
 @return @"iPhone7,1" on iPhone 6 Plus
 @return @"iPhone7,2" on iPhone 6
 @return @"iPhone8,1" on iPhone 6s Plus
 @return @"iPhone8,2" on iPhone 6s
 */
- (NSString *) platform;

- (NSString *) hwmodel;
- (NSString *) UUID;

- (int) cpuFrequency;
- (int) busFrequency;
- (int) cpuCount;
- (int) totalMemory;
- (int) userMemory;
- (int) pageSize;
- (int) physicalMemorySize;
- (int) maxSocketBufferSize;
- (NSNumber *) totalDiskSpace;
- (NSNumber *) freeDiskSpace;
- (natural_t)getFreeMemory;

- (double)availableMemory;
- (double)usedMemory;

- (NSString *) macaddress;

- (BOOL) hasRetinaDisplay;

#pragma mark - JailBroken

- (BOOL)isJB;
- (BOOL)isCYExist;

@end