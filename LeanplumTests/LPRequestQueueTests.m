//
//  LPRequestQueueTests.m
//  LeanplumTests
//
//  Created by Hrishikesh Amravatkar on 6/20/19.
//  Copyright © 2019 Leanplum. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <OHHTTPStubs/OHHTTPStubs.h>
#import <OHHTTPStubs/OHPathHelpers.h>
#import "LPRequestManager.h"
#import "LPRequestQueue.h"
#import "LPAPIConfig.h"
#import "LPTestHelper.h"


@interface LPRequestQueueTests : XCTestCase

@end

@implementation LPRequestQueueTests

- (void)setUp {
    [super setUp];
    [LPTestHelper setup];
}

- (void)tearDown {
    [super tearDown];
    [OHHTTPStubs removeAllStubs];
}

- (LPRequest *)sampleData
{
    LPRequest *request = [[LPRequest alloc] initWithApiMethod:LPApiMethodSetUserAttributes
                                                       params:nil
                                                      success:nil
                                                      failure:nil];
    return request;
}

- (LPRequest *)sampleDataError
{
    LPRequest *request = [[LPRequest alloc] initWithApiMethod:LPApiMethodTrack
                                                       params:nil
                                                      success:nil
                                                      failure:nil];
    return request;
}

- (void)testEnqueueRequestQueue {
    [[LPRequestQueue sharedInstance] enqueue:[self sampleData]];
    NSArray *requests = [LPRequestManager requestsWithLimit:10000];
    XCTAssertTrue(requests.count == 1);
    [LPRequestManager deleteRequestsWithLimit:1000];
    XCTAssertTrue([LPRequestManager count] == 0);
}

- (void)testSendRequestQueue {
    sleep(1);
    [LPRequestManager deleteRequestsWithLimit:1000];
    [[LPRequestQueue sharedInstance] enqueue:[self sampleData]];
    [[LPRequestQueue sharedInstance] enqueue:[self sampleData]];
    NSArray *requests = [LPRequestManager requestsWithLimit:10000];
    XCTAssertTrue(requests.count == 2);
    XCTestExpectation *expectation = [self expectationWithDescription:@"Query timed out."];
    [[LPRequestQueue sharedInstance] sendRequests:^{
        [expectation fulfill];
    } failure:^(NSError * _Nonnull error) {
        [LPRequestManager deleteRequestsWithLimit:1000];
    }];
    [self waitForExpectationsWithTimeout:20.0 handler:^(NSError *error) {
        if (error) {
            [LPRequestManager deleteRequestsWithLimit:1000];
            NSLog(@"Error: %@", error);
        }
    }];
    [LPRequestManager deleteRequestsWithLimit:1000];
    XCTAssertTrue([LPRequestManager count] == 0);
}

//ToDo: Multi call failure experience needs to be discussed and finalized.
- (void)testSendRequestQueueError {
    sleep(1);
    [LPRequestManager deleteRequestsWithLimit:1000];
    [[LPRequestQueue sharedInstance] enqueue:[self sampleDataError]];
    NSArray *requests = [LPRequestManager requestsWithLimit:10000];
    XCTAssertTrue(requests.count == 1);
    XCTestExpectation *expectation = [self expectationWithDescription:@"Query timed out."];
    [[LPRequestQueue sharedInstance] sendRequests:^{
        //ToDo: We have to finalize the experience for Multi call failures.
        [expectation fulfill];
    } failure:^(NSError * _Nonnull error) {
        [expectation fulfill];
        [LPRequestManager deleteRequestsWithLimit:1000];
    }];
    [self waitForExpectationsWithTimeout:10.0 handler:^(NSError *error) {
        if (error) {
            [LPRequestManager deleteRequestsWithLimit:1000];
            NSLog(@"Error: %@", error);
        }
    }];
    [LPRequestManager deleteRequestsWithLimit:1000];
    XCTAssertTrue([LPRequestManager count] == 0);
}

- (void)testSendRequestQueueSuccessCallback {
    sleep(1);
    [LPRequestManager deleteRequestsWithLimit:1000];
    XCTestExpectation *expectation = [self expectationWithDescription:@"Success callback not called."];
    LPRequest *request = [[LPRequest alloc] initWithApiMethod:LPApiMethodSetUserAttributes
                                                       params:nil
                                                      success:^(NSDictionary * _Nonnull dictionary) {
                                                          [expectation fulfill];
                                                       } failure:nil];
    [[LPRequestQueue sharedInstance] enqueue:[self sampleData]];
    [[LPRequestQueue sharedInstance] enqueue:[self sampleData]];
    [[LPRequestQueue sharedInstance] enqueue:request];

    NSArray *requests = [LPRequestManager requestsWithLimit:10000];
    XCTAssertTrue(requests.count == 3);

    [[LPRequestQueue sharedInstance] sendRequests:^{
    } failure:^(NSError * _Nonnull error) {
        [LPRequestManager deleteRequestsWithLimit:1000];
    }];
    [self waitForExpectationsWithTimeout:20.0 handler:^(NSError *error) {
        if (error) {
            [LPRequestManager deleteRequestsWithLimit:1000];
            NSLog(@"Error: %@", error);
        }
    }];
    [LPRequestManager deleteRequestsWithLimit:1000];
    XCTAssertTrue([LPRequestManager count] == 0);
}

- (void)testSendRequestQueueFailureCallback {
    sleep(1);
    [LPRequestManager deleteRequestsWithLimit:1000];
    XCTestExpectation *expectation = [self expectationWithDescription:@"Success callback not called."];
    LPRequest *request = [[LPRequest alloc] initWithApiMethod:LPApiMethodTrack
                                                       params:nil
                                                      success:nil
                                                      failure:^(NSError * _Nonnull error) {
                                                          [expectation fulfill];
                                                      }];
    [[LPRequestQueue sharedInstance] enqueue:[self sampleData]];
    [[LPRequestQueue sharedInstance] enqueue:[self sampleData]];
    [[LPRequestQueue sharedInstance] enqueue:request];

    NSArray *requests = [LPRequestManager requestsWithLimit:10000];
    XCTAssertTrue(requests.count == 3);

    [[LPRequestQueue sharedInstance] sendRequests:^{
    } failure:^(NSError * _Nonnull error) {
        [LPRequestManager deleteRequestsWithLimit:1000];
    }];
    [self waitForExpectationsWithTimeout:30.0 handler:^(NSError *error) {
        if (error) {
            [LPRequestManager deleteRequestsWithLimit:1000];
            NSLog(@"Error: %@", error);
        }
    }];
    [LPRequestManager deleteRequestsWithLimit:1000];
    XCTAssertTrue([LPRequestManager count] == 0);
}

@end
