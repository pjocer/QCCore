//
//  CrashLog.m
//  QCCore
//
//  Created by XuQian on 1/15/16.
//  Copyright © 2016 qcwl. All rights reserved.
//

#import "CrashLog.h"

@implementation CrashLog

+ (instancetype)newCrashLog
{
    return [[CrashLog alloc] init];
}

- (id)init
{
    if (self = [super init]) {
        _content = [NSMutableDictionary dictionary];
        
        _crashType = UnsetType;
        _signalType = UnknownType;
        
        [self setLanchedDateString:[NSDate date]];
        
        NSDictionary *bundleInfo = [[NSBundle mainBundle] infoDictionary];
        
        
    }
    return self;
}

- (NSString *)description
{
    return _content.description;
}

- (NSString *)lanchedDate
{
    return _content[@"lanchedDate"];
}

- (void)setLanchedDateString:(NSDate *)lanchedDate
{
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    [fmt setDateFormat:@"yyyy-MM-dd HH:mm:ss.SSS"];
    [_content setValue:[fmt stringFromDate:lanchedDate] forKey:@"lanchedDate"];
}

//- (NSString *)appName
//{
//    return _content[@""];
//}

@end
