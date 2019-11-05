//
//  LPStartApiTest.m
//  LeanplumTests
//
//  Created by Hrishikesh Amravatkar on 7/11/19.
//  Copyright © 2019 Leanplum. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "LPAPIConfig.h"
#import "LPApiConstants.h"
#import "LPConstants.h"
#import "LPTestHelper.h"
#import <OHHTTPStubs/OHHTTPStubs.h>
#import <OHHTTPStubs/OHPathHelpers.h>
#import "LPStartResponse.h"
#import "LPRequestQueue.h"
#import "LPStartApi.h"

@interface LPStartApiTest : XCTestCase

@end

@implementation LPStartApiTest

- (void)setUp {
    [super setUp];
    [LPTestHelper setup];
}

- (void)tearDown {
    [super tearDown];
    [OHHTTPStubs removeAllStubs];
}

- (void)testStartApiWithRegionsWithParameters {
    XCTestExpectation *expectation = [self expectationWithDescription:@"Query timed out."];
    NSDictionary *params = @{ @"testKey": @"testValue" };
    [LPStartApi startWithParameters:params success:^(LPStartResponse *response) {
        XCTAssertNotNil(response);
        XCTAssertNotNil(response.regions);
        [expectation fulfill];
    } failure:^(NSError *error) {
    }];
    

    [self waitForExpectationsWithTimeout:20.0 handler:^(NSError *error) {
        if (error) {
            NSLog(@"Error: %@", error);
        }
    }];
}

- (void)testStartApiWithRegionsWithParametersWithMulti {
    sleep(1);
    XCTestExpectation *expectation = [self expectationWithDescription:@"Query timed out."];
    NSDictionary *params = @{ @"testKey": @"testValue" };
    [LPStartApi startWithParameters:params success:^(LPStartResponse *response) {
        XCTAssertNotNil(response);
        XCTAssertNotNil(response.regions);
        [expectation fulfill];
    } failure:^(NSError *error) {
        NSLog(@"%@", error);
    }];
    [[LPRequestQueue sharedInstance] sendRequests:^{
        NSLog(@"success");
    } failure:^(NSError * _Nonnull error) {
        NSLog(@"failure");
    }];

    [self waitForExpectationsWithTimeout:10.0 handler:^(NSError *error) {
        if (error) {
            NSLog(@"Error: %@", error);
        }
    }];
}


@end
