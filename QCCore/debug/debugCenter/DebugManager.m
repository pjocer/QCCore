//
//  DebugManager.m
//  QCCore
//
//  Created by XuQian on 1/20/16.
//  Copyright © 2016 qcwl. All rights reserved.
//

#import "DebugManager.h"

NSString * SavedDomainPath()
{
    return [NSTemporaryDirectory() stringByAppendingPathComponent:@"domain.dat"];
}

@implementation DebugManager
{
    NSMutableArray *_domains;
}

+ (instancetype)manager
{
    static DebugManager *manager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[DebugManager alloc] _init];
    });
    return manager;
}

- (id)_init
{
    if (self = [super init]) {
        _domains = [NSMutableArray array];
    }
    return self;
}

- (NSArray<Domain *> *)domains
{
    return _domains;
}

- (void)addDomain:(Domain *)domain
{
    if (!domain || ![domain isKindOfClass:[Domain class]]) return;
    [_domains addObject:domain];
}

@end

@interface Domain ()
@property (nonatomic, strong) NSString *domain;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, assign) BOOL isMain;
@end
@implementation Domain

+ (instancetype)domain:(NSString *)domain title:(NSString *)title isMain:(BOOL)isMain
{
    Domain *dom = [[Domain alloc] init];
    dom.domain = domain?:@"";
    dom.title = title?:@"自定义";
    dom.isMain = isMain;
    return dom;
}

+ (BOOL)supportsSecureCoding
{
    return YES;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super init]) {
        self.domain = [aDecoder decodeObjectForKey:@"domain"];
        self.title = [aDecoder decodeObjectForKey:@"title"];
        self.isMain = [aDecoder decodeBoolForKey:@"isMain"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.domain forKey:@"domain"];
    [aCoder encodeObject:self.title forKey:@"title"];
    [aCoder encodeBool:self.isMain forKey:@"isMain"];
}

@end
