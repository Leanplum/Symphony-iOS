//
//  LPEventDataManagerTest.m
//  LeanplumTests
//
//  Created by Hrishikesh Amravatkar on 6/19/19.
//  Copyright © 2019 Leanplum. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <OHHTTPStubs/OHHTTPStubs.h>
#import <OHHTTPStubs/OHPathHelpers.h>
#import "LPRequestManager.h"
#import "LPAPIConfig.h"
#import "LPTestHelper.h"


@interface LPRequestManagerTest : XCTestCase

@end

@implementation LPRequestManagerTest

- (void)setUp {
    [super setUp];
    [LPRequestManager deleteRequestsWithLimit:1000];
    [LPTestHelper setup];
}

- (void)tearDown {
    [super tearDown];
    [OHHTTPStubs removeAllStubs];
}

- (LPRequest *)sampleData
{
    LPRequest *request = [[LPRequest alloc] initWithApiMethod:LPApiMethodTrack
                                                       params:nil
                                                      success:nil
                                                      failure:nil];
    return request;
}

- (void)testAddRequest {
    // Add Event.
    [LPRequestManager addRequest:[self sampleData]];
    NSArray *events = [LPRequestManager requestsWithLimit:10000];
    XCTAssertTrue(events.count == 1);
    [LPRequestManager deleteRequestsWithLimit:1000];
}

- (void)testAddRequests {
    // Add Event.
    NSArray *inputRequests = @[[self sampleData], [self sampleData]];
    [LPRequestManager addRequests:inputRequests];
    NSArray *events = [LPRequestManager requestsWithLimit:10000];
    XCTAssertTrue(events.count == 2);
    [LPRequestManager deleteRequestsWithLimit:1000];
}


- (void)testDeleteRequest {
    // Add Event.
    [LPRequestManager addRequest:[self sampleData]];
    NSArray *requests = [LPRequestManager requestsWithLimit:10000];
    XCTAssertTrue(requests.count == 1);
    [LPRequestManager deleteRequestsWithLimit:1000];
     XCTAssertTrue([LPRequestManager count] == 0);
}

- (void)testRequestCount {
    // Add Event.
    NSArray *inputRequests = @[[self sampleData], [self sampleData], [self sampleData], [self sampleData]];
    [LPRequestManager addRequests:inputRequests];
    XCTAssertTrue(inputRequests.count == 4);
    [LPRequestManager deleteRequestsWithLimit:1000];
    XCTAssertTrue([LPRequestManager count] == 0);
}

- (void)testRequestsWithLimit {
    // Add Event.
    NSArray *inputRequests = @[[self sampleData], [self sampleData], [self sampleData], [self sampleData]];
    [LPRequestManager addRequests:inputRequests];
    XCTAssertTrue(inputRequests.count == 4);
    NSArray *requests = [LPRequestManager requestsWithLimit:1000];
    XCTAssertTrue([requests count] == 4);
    [LPRequestManager deleteRequestsWithLimit:1000];
    XCTAssertTrue([LPRequestManager count] == 0);
}

- (void)testDeleteRequestsWithRequestId {
    NSArray *inputRequests = @[[self sampleData], [self sampleData], [self sampleData], [self sampleData]];
    [LPRequestManager addRequests:inputRequests];
    XCTAssertTrue(inputRequests.count == 4);
    NSArray *requests = [LPRequestManager requestsWithLimit:1000];
    XCTAssertTrue([requests count] == 4);
    NSString *reqId = [requests[0] objectForKey:@"reqId"];
    [LPRequestManager deleteRequestsWithRequestId:reqId];
    NSArray *requests2 = [LPRequestManager requestsWithLimit:1000];
    XCTAssertTrue([requests2 count] == 3);
}

@end
