//
//  RequestCache.m
//  QCWL_SYT
//
//  Created by Chen on 15/3/19.
//  Copyright (c) 2015年 qcwl. All rights reserved.
//

#import "QCRequestCache.h"
#import "FMDB.h"

static NSString *REQUEST_CACHE_DATABASE_NAME = @"reqeust_cahche_db.sqlite";
static NSString *REQUEST_CACHE_TABLE = @"request_cache";
static NSString *KEY_URL = @"url";
static NSString *KEY_RESPONSE = @"response";
static NSString *KEY_STRATEGY = @"strategy";
static NSString *KEY_TIMESTAMP = @"timestamp";

@interface QCRequestCache ()

@property (strong, nonatomic) FMDatabaseQueue *databaseQueue;

@end

@implementation QCRequestCache

+ (QCRequestCache *)sharedInstance {
    static QCRequestCache *defaultCache;
    static dispatch_once_t token;
    dispatch_once(&token, ^{
        defaultCache = [[QCRequestCache alloc] initSingle];
    });
    return defaultCache;
}

- (id)initSingle {
    self = [super init];
    if (self) {

        NSString *docsDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
        NSString *dbPath = [docsDir stringByAppendingPathComponent:REQUEST_CACHE_DATABASE_NAME];
        _databaseQueue = [FMDatabaseQueue databaseQueueWithPath:dbPath];

        [_databaseQueue inDatabase:^(FMDatabase *db) {
            NSString *createSQL = [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS %@ (%@ STRING PRIMARY KEY, %@ VARBINARY, %@ INTEGER, %@ LONG)", REQUEST_CACHE_TABLE, KEY_URL, KEY_RESPONSE, KEY_STRATEGY, KEY_TIMESTAMP];
            [db executeUpdate:createSQL];
        }];
    }
    return self;
}

- (id)init {
    return [QCRequestCache sharedInstance];
}

- (void)put:(QCAPIRequest *)request {
    NSData *responseData = [self getRequestCache:request];
    if (responseData) {
        [self updateRequestCache:request];
    } else {
        [self addRequestCache:request];
    }
}

- (NSData *)get:(QCAPIRequest *)request {
    return [self getRequestCache:request];
}

- (void)remove:(QCAPIRequest *)request {
    [self deleteRequestCache:request];
}

- (void)clear {
    [self clearRequestCache];
}

- (void)addRequestCache:(QCAPIRequest *)request {
    NSString *insertSQL = [NSString stringWithFormat:@"INSERT INTO %@ (%@, %@, %@, %@) VALUES (?, ?, ?, ?)", REQUEST_CACHE_TABLE, KEY_URL, KEY_RESPONSE, KEY_STRATEGY, KEY_TIMESTAMP];

    [_databaseQueue inDatabase:^(FMDatabase *db) {
        [db executeUpdate:insertSQL, [request uniqueKey], request.responseData, [NSNumber numberWithInteger:[request cacheStrategy]], [NSNumber numberWithLong:[[NSDate date] timeIntervalSince1970]]];
    }];
}

- (void)updateRequestCache:(QCAPIRequest *)request {
    NSString *updateSQL = [NSString stringWithFormat:@"UPDATE %@ SET %@ = ?, %@ = ?, %@ = ? WHERE %@ = ?", REQUEST_CACHE_TABLE, KEY_RESPONSE, KEY_STRATEGY, KEY_TIMESTAMP, KEY_URL];

    [_databaseQueue inDatabase:^(FMDatabase *db) {
        [db executeUpdate:updateSQL, request.responseData, [NSNumber numberWithInteger:[request cacheStrategy]], [NSNumber numberWithLong:[[NSDate date] timeIntervalSince1970]], [request uniqueKey]];
    }];
}

- (NSData *)getRequestCache:(QCAPIRequest *)request {

    __block NSData *responseData;
    [_databaseQueue inDatabase:^(FMDatabase *db) {
        NSString *selectSQL = [NSString stringWithFormat:@"SELECT * FROM %@ WHERE %@ = ?", REQUEST_CACHE_TABLE, KEY_URL];
        FMResultSet *resultSet = [db executeQuery:selectSQL, request.uniqueKey];
        if ([resultSet next] && [self checkCacheAvailableStatus:resultSet]) {
            responseData = [resultSet dataForColumn:KEY_RESPONSE];
        }
        [resultSet close];
    }];
    return responseData;
}

- (void)deleteRequestCache:(QCAPIRequest *)request {
    NSString *deleteSQL = [NSString stringWithFormat:@"DELETE FROM %@ WHERE %@ = ?", REQUEST_CACHE_TABLE, KEY_URL];

    [_databaseQueue inDatabase:^(FMDatabase *db) {
        [db executeUpdate:deleteSQL, [request uniqueKey]];
    }];
}

- (void)clearRequestCache {
    NSString *clearSQL = [NSString stringWithFormat:@"DELETE FROM %@", REQUEST_CACHE_TABLE];
    [_databaseQueue inDatabase:^(FMDatabase *db) {
        [db executeUpdate:clearSQL];
    }];
}

- (BOOL)checkCacheAvailableStatus:(FMResultSet *)resultSet {
    long availableTime;
    int strategy = [resultSet intForColumn:KEY_STRATEGY];
    switch (strategy) {
    case CacheStrategyNormal:
        availableTime = 5 * 60;
        break;
    case CacheStrategyHourly:
        availableTime = 60 * 60;
        break;
    case CacheStrategyDaily:
        availableTime = 24 * 60 * 60;
        break;
    case CacheStrategyPersist:
    case CacheStrategyCachePrecedence:
        availableTime = NSIntegerMax;
        break;
    default:
        availableTime = 5 * 60;
        break;
    }

    return (long)((NSTimeInterval)[[NSDate date] timeIntervalSince1970]) - [resultSet longForColumn:KEY_TIMESTAMP] < availableTime ? YES : NO;
}

@end
