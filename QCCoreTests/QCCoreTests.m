//
//  QCCoreTests.m
//  QCCoreTests
//
//  Created by XuQian on 12/22/15.
//  Copyright © 2015 qcwl. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "QCCore.h"

@interface QCCoreTests : XCTestCase
@property (nonatomic) dispatch_group_t requestGroup;
@end

@implementation QCCoreTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    
    self.requestGroup = dispatch_group_create();
    [self waitForGroupToBeEmptyWithTimeout:3];
    
    [super tearDown];
}

- (BOOL)waitForGroupToBeEmptyWithTimeout:(NSTimeInterval)timeout;
{
    NSDate * const end = [[NSDate date] dateByAddingTimeInterval:5];
    
    __block BOOL didComplete = NO;
    dispatch_group_notify(self.requestGroup, dispatch_get_main_queue(), ^{
        didComplete = YES;
    });
    while ((! didComplete) && (0. < [end timeIntervalSinceNow])) {
        if (! [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate dateWithTimeIntervalSinceNow:0.2]]) {
            [NSThread sleepForTimeInterval:1];
        }
    }
    return didComplete;
}

- (void)testNetwork
{
    XCTestExpectation *exp = [self expectationWithDescription:@"async"];
    
    NSString *url = @"http://dev.fk.com/api/home/manage";
    QCAPIRequest *request = [[QCAPIRequest alloc] initWithUrl:url requestMethod:POST];
    request.cacheStrategy = CacheStrategyNone;
    [request startWithAPISuccessBlock:^(QCAPIRequest * _Nonnull request) {
        [exp fulfill];
        NSLog(@"request was success");
        NSLog(@"%@",request.responseDict);
    } APIFailedBlock:^(QCAPIRequest * _Nonnull request) {
        [exp fulfill];
        XCTFail(@"request was failed");
    }];
    
    [self waitForExpectationsWithTimeout:5 handler:nil];
}

@end
