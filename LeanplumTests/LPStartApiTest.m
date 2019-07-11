//
//  LPStartApiTest.m
//  LeanplumTests
//
//  Created by Hrishikesh Amravatkar on 7/11/19.
//  Copyright © 2019 Leanplum. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "LPStartApi.h"
#import "LPAPIConfig.h"
#import "LPConstants.h"
#import "LPTestHelper.h"
#import <OHHTTPStubs/OHHTTPStubs.h>
#import <OHHTTPStubs/OHPathHelpers.h>
#import "LPStartResponse.h"

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

- (void)testStartApiWithParameters {
    XCTestExpectation *expectation = [self expectationWithDescription:@"Query timed out."];
    NSDictionary *params = @{ @"testKey": @"testValue" };
    [LPStartApi startWithParameters:params success:^(LPStartResponse *response) {
        XCTAssertNotNil(response);
        [expectation fulfill];
    } failure:^(NSError *error) {
    }];
    
    [self waitForExpectationsWithTimeout:10.0 handler:^(NSError *error) {
        if (error) {
            NSLog(@"Error: %@", error);
        }
    }];
}

- (void)testStartApiWithHttpError {
    XCTestExpectation *expectation = [self expectationWithDescription:@"Query timed out."];
    // change device id to empty string
    [LPTestHelper setup:APPLICATION_ID withAccessKey:DEVELOPMENT_KEY withDeviceId:@""];
    
    [LPStartApi startWithParameters:nil success:^(LPStartResponse *response) {
    } failure:^(NSError *error) {
        NSString *expected = @"At least one of deviceId or userId is required.";
        XCTAssertEqualObjects([error userInfo][NSLocalizedDescriptionKey], expected);
        [expectation fulfill];
    }];
    [self waitForExpectationsWithTimeout:10.0 handler:^(NSError *error) {
        if (error) {
            NSLog(@"Error: %@", error);
        }
    }];
}

@end
