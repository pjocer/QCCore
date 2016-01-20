//
//  UIDevice+Hardware.h
//  XQBase
//
//  Created by kevinxuls on 10/12/15.
//  Copyright © 2015 kevinxuls. All rights reserved.
//

#include <sys/socket.h>
#include <sys/sysctl.h>
#include <net/if.h>
#include <net/if_dl.h>
#include <mach/mach.h>

#import "UIDevice+Hardware.h"

@implementation UIDevice (Hardware)

#pragma mark sysctlbyname utils
- (NSString *) getSysInfoByName:(char *)typeSpecifier
{
    size_t size;
    sysctlbyname(typeSpecifier, NULL, &size, NULL, 0);
    
    char *answer = malloc(size);
    sysctlbyname(typeSpecifier, answer, &size, NULL, 0);
    
    NSString *results = [NSString stringWithCString:answer encoding: NSUTF8StringEncoding];

    free(answer);
    return results;
}

- (NSString *) platform
{
    return [self getSysInfoByName:"hw.machine"];
}

- (NSString *) hwmodel
{
    return [self getSysInfoByName:"hw.model"];
}

- (NSString *) UUID
{
	CFUUIDRef uuidObj = CFUUIDCreate(nil);
	NSString *uuidString = (__bridge_transfer NSString*)CFUUIDCreateString(nil, uuidObj);
	CFRelease(uuidObj);
	return uuidString;
}

#pragma mark sysctl utils
- (unsigned long) getSysInfo: (u_int) typeSpecifier
{
    size_t size = sizeof(int);
    unsigned long results;
    int mib[2] = {CTL_HW, typeSpecifier};
    sysctl(mib, 2, &results, &size, NULL, 0);
    return results;
}

- (unsigned long) cpuFrequency
{
    return [self getSysInfo:HW_CPU_FREQ];
}

- (unsigned long) busFrequency
{
    return [self getSysInfo:HW_BUS_FREQ];
}

- (unsigned long) cpuCount
{
    size_t size = sizeof(int);
    int results;
    int mib[2] = {CTL_HW, HW_NCPU};
    sysctl(mib, 2, &results, &size, NULL, 0);
    return results;
}

- (unsigned long) totalMemory
{
    return [self getSysInfo:HW_PHYSMEM];
}

- (unsigned long) userMemory
{
    return [self getSysInfo:HW_USERMEM];
}

- (unsigned long) pageSize {
    return [self getSysInfo:HW_PAGESIZE];
}

- (unsigned long) physicalMemorySize {
    return [self getSysInfo:HW_MEMSIZE];
}

- (unsigned long) maxSocketBufferSize
{
    return [self getSysInfo:KIPC_MAXSOCKBUF];
}

- (double)availableMemory
{
    vm_statistics_data_t vmStats;
    mach_msg_type_number_t infoCount = HOST_VM_INFO_COUNT;
    kern_return_t kernReturn = host_statistics(mach_host_self(),
                                               HOST_VM_INFO,
                                               (host_info_t)&vmStats,
                                               &infoCount);
    
    if (kernReturn != KERN_SUCCESS) {
        return NSNotFound;
    }
    return vm_page_size *vmStats.free_count;
}

- (double)usedMemory
{
    task_basic_info_data_t taskInfo;
    mach_msg_type_number_t infoCount = TASK_BASIC_INFO_COUNT;
    kern_return_t kernReturn = task_info(mach_task_self(),
                                         TASK_BASIC_INFO,
                                         (task_info_t)&taskInfo,
                                         &infoCount);
    
    if (kernReturn != KERN_SUCCESS
        ) {
        return NSNotFound;
    }
    
    return taskInfo.resident_size;
}

- (unsigned long long) totalDiskSpace
{
    NSDictionary *fattributes = [[NSFileManager defaultManager] attributesOfFileSystemForPath:NSHomeDirectory() error:nil];
    NSNumber *value = [fattributes objectForKey:NSFileSystemSize];
    return value ? [value unsignedLongLongValue] : 0;
}

- (unsigned long long) freeDiskSpace
{
    NSDictionary *fattributes = [[NSFileManager defaultManager] attributesOfFileSystemForPath:NSHomeDirectory() error:nil];
    NSNumber *value = [fattributes objectForKey:NSFileSystemFreeSize];
    return value ? [value unsignedLongLongValue] : 0;
}

- (BOOL) hasRetinaDisplay
{
    return ([UIScreen mainScreen].scale >= 2.0f);
}

- (natural_t)getFreeMemory
{
    mach_port_t host_port;
    mach_msg_type_number_t host_size;
    vm_size_t pagesize;
    host_port = mach_host_self();
    host_size = sizeof(vm_statistics_data_t) / sizeof(integer_t);
    host_page_size(host_port, &pagesize);
    vm_statistics_data_t vm_stat;
    
    if (host_statistics(host_port, HOST_VM_INFO, (host_info_t)&vm_stat, &host_size) != KERN_SUCCESS) {
        return 0;
    }
    
    unsigned long mem_free = vm_stat.free_count * pagesize;
    return (natural_t)mem_free;
}

- (NSString *)network
{
    return @"";
}

#pragma mark MAC addy

- (NSString *) macaddress
{
    int                 mib[6];
    size_t              len;
    char                *buf;
    unsigned char       *ptr;
    struct if_msghdr    *ifm;
    struct sockaddr_dl  *sdl;
    
    mib[0] = CTL_NET;
    mib[1] = AF_ROUTE;
    mib[2] = 0;
    mib[3] = AF_LINK;
    mib[4] = NET_RT_IFLIST;
    
    if ((mib[5] = if_nametoindex("en0")) == 0) {
        printf("Error: if_nametoindex error\n");
        return NULL;
    }
    
    if (sysctl(mib, 6, NULL, &len, NULL, 0) < 0) {
        printf("Error: sysctl, take 1\n");
        return NULL;
    }
    
    if ((buf = malloc(len)) == NULL) {
        printf("Error: Memory allocation error\n");
        return NULL;
    }
    
    if (sysctl(mib, 6, buf, &len, NULL, 0) < 0) {
        printf("Error: sysctl, take 2\n");
        free(buf); // Thanks, Remy "Psy" Demerest
        return NULL;
    }
    
    ifm = (struct if_msghdr *)buf;
    sdl = (struct sockaddr_dl *)(ifm + 1);
    ptr = (unsigned char *)LLADDR(sdl);
    NSString *outstring = [NSString stringWithFormat:@"%02X:%02X:%02X:%02X:%02X:%02X", *ptr, *(ptr+1), *(ptr+2), *(ptr+3), *(ptr+4), *(ptr+5)];

    free(buf);
    return [outstring uppercaseString];
}

#pragma mark - JailBroken

- (BOOL)isJB
{
    NSString *aptPath = @"/private/var/lib/apt/";
    return [[NSFileManager defaultManager] fileExistsAtPath:aptPath] ? YES : NO;
}

- (BOOL)isCYExist
{
    NSString *cyPath = @"/Applications/Cydia.app";
    return [[NSFileManager defaultManager] fileExistsAtPath:cyPath] ? YES : NO;
}

@end