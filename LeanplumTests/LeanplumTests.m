//
//  LeanplumTests.m
//  LeanplumTests
//
//  Created by Mayank Sanganeria on 3/27/19.
//  Copyright © 2019 Leanplum. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <OCMock/OCMock.h>
#import <OHHTTPStubs/OHHTTPStubs.h>
#import "LPAPIConfig.h"
#import "LPApiConstants.h"
#import "LPTestHelper.h"
#import "Leanplum.h"
#import "LPRequestQueue.h"
#import "LPInternalState.h"
#import "LeanplumInternal.h"

@interface LeanplumTests : XCTestCase


@end

@implementation LeanplumTests

- (void)setUp {
    [super setUp];
    [LPInternalState sharedState].calledStart = true;
    [LPInternalState sharedState].issuedStart = true;
    [LPTestHelper setup];
}

- (void)tearDown {
    [super tearDown];
    [LPInternalState sharedState].calledStart = false;
    [LPInternalState sharedState].issuedStart = false;
    [OHHTTPStubs removeAllStubs];
}


- (void)testConfiguration
{
    NSString* host = @"test_host";
    NSString* servlet = @"servlet";

    XCTAssertEqualObjects([LPApiConstants sharedState].apiHostName, @"api.leanplum.com");
    XCTAssertEqualObjects([LPApiConstants sharedState].apiServlet, @"api");

    [Leanplum setApiHostName:host withServletName:servlet usingSsl:true];

    XCTAssertEqual([LPApiConstants sharedState].apiHostName, host);
    XCTAssertEqual([LPApiConstants sharedState].apiServlet, servlet);

    [Leanplum setApiHostName:nil withServletName:nil usingSsl:true];

    XCTAssertEqual([LPApiConstants sharedState].apiHostName, host);
    XCTAssertEqual([LPApiConstants sharedState].apiServlet, servlet);

    [Leanplum setApiHostName:host withServletName:nil usingSsl:true];

    XCTAssertEqual([LPApiConstants sharedState].apiHostName, host);
    XCTAssertEqual([LPApiConstants sharedState].apiServlet, servlet);

    int timeout = 10;

    [Leanplum setNetworkTimeoutSeconds:timeout];
    XCTAssertEqual([LPApiConstants sharedState].networkTimeoutSeconds, timeout);
    XCTAssertEqual([LPApiConstants sharedState].networkTimeoutSecondsForDownloads, timeout);

    [Leanplum setNetworkTimeoutSeconds: -1];
    XCTAssertEqual([LPApiConstants sharedState].networkTimeoutSeconds, timeout);
    XCTAssertEqual([LPApiConstants sharedState].networkTimeoutSecondsForDownloads, timeout);

    [Leanplum setNetworkTimeoutSeconds:timeout forDownloads:timeout];
    XCTAssertEqual([LPApiConstants sharedState].networkTimeoutSeconds, timeout);
    XCTAssertEqual([LPApiConstants sharedState].networkTimeoutSecondsForDownloads, timeout);

    [Leanplum setNetworkTimeoutSeconds:20 forDownloads:-1];
    XCTAssertEqual([LPApiConstants sharedState].networkTimeoutSeconds, timeout);
    XCTAssertEqual([LPApiConstants sharedState].networkTimeoutSecondsForDownloads, timeout);

    [Leanplum setNetworkTimeoutSeconds:-1 forDownloads:20];
    XCTAssertEqual([LPApiConstants sharedState].networkTimeoutSeconds, timeout);
    XCTAssertEqual([LPApiConstants sharedState].networkTimeoutSecondsForDownloads, timeout);
}

/**
 * Tests whether setting user attributes and id works correctly.
 */
- (void) testUserId
{
    sleep(1);
    [LPTestHelper setup];
    XCTestExpectation *expectation = [self expectationWithDescription:@"Query timed out."];
    // Try to set user id and attributes.
    [Leanplum setUserId:DEVICE_ID withUserAttributes:nil withSuccess:^{
        [expectation fulfill];
    } withFailure:^(NSError *error) {
    }];
    [[LPRequestQueue sharedInstance] sendRequests:^{
        NSLog(@"test");
    } failure:^(NSError * _Nonnull error) {
        NSLog(@"failrure");
    }];

    [self waitForExpectationsWithTimeout:20.0 handler:^(NSError *error) {
        if (error) {
            NSLog(@"Error: %@", error);
        }
    }];
}

/**
 * Tests whether setting user attributes and id works error correctly.
 */
- (void) testUserAttributesError
{
    sleep(1);
    [LPTestHelper setup];
    [LPApiConstants sharedState].isMulti = NO;
    [LPTestHelper setupStub:400 withFileName:@"simple_error_success_response.json"];
    XCTestExpectation *expectation = [self expectationWithDescription:@"Query timed out."];
    NSDictionary *userAttributes = @{@"name": @"John Smith",
                                     @"age": @42,
                                     @"address": @"New York"
                                     };

    // Try to set user id and attributes.
    [Leanplum setUserId:nil withUserAttributes:userAttributes withSuccess:^{
    } withFailure:^(NSError *error) {
        NSString *expectedMessage = @"Unknown error, please contact Leanplum.";
        XCTAssertEqualObjects(expectedMessage, [error userInfo][NSLocalizedDescriptionKey]);
        [expectation fulfill];
    }];
    [[LPRequestQueue sharedInstance] sendRequests:^{
        NSLog(@"test");
    } failure:^(NSError * _Nonnull error) {
        NSLog(@"failrure");
    }];
    [self waitForExpectationsWithTimeout:40.0 handler:^(NSError *error) {
        if (error) {
            NSLog(@"Error: %@", error);
        }
    }];
    [LPApiConstants sharedState].isMulti = YES;
}

/**
 * Tests whether setting user attributes and id works correctly with API Call
 */
- (void) testUserAttributesApiCall
{
    sleep(1);
    [LPTestHelper setup];
    XCTestExpectation *expectation = [self expectationWithDescription:@"Query timed out."];
    NSString *userId = @"john.smith";
    NSDictionary *userAttributes = @{@"name": @"John Smith",
                                     @"age": @42,
                                     @"address": @"New York"
                                     };

    // Try to set user id and attributes.
    [Leanplum setUserId:userId withUserAttributes:userAttributes withSuccess:^{
        [expectation fulfill];
    } withFailure:^(NSError *error) {
    }];
    [[LPRequestQueue sharedInstance] sendRequests:^{
        NSLog(@"test");
    } failure:^(NSError * _Nonnull error) {
        NSLog(@"failrure");
    }];
    [self waitForExpectationsWithTimeout:40.0 handler:^(NSError *error) {
        if (error) {
            NSLog(@"Error: %@", error);
        }
    }];
}


/**
 * Tests whether setting user attributes and id works error correctly.
 */
- (void) testSetUserAttributesError
{
    sleep(1);
    [LPTestHelper setup];
    [LPApiConstants sharedState].isMulti = NO;
    [LPTestHelper setupStub:400 withFileName:@"simple_error_success_response.json"];
    XCTestExpectation *expectation = [self expectationWithDescription:@"Query timed out."];
    NSDictionary *userAttributes = @{@"name": @"John Smith",
                                     @"age": @42,
                                     @"address": @"New York"
                                     };

    // Try to set user id and attributes.
    [Leanplum setUserAttributes:userAttributes withSuccess:^{
    } withFailure:^(NSError *error) {
        NSString *expectedMessage = @"Unknown error, please contact Leanplum.";
        XCTAssertEqualObjects(expectedMessage, [error userInfo][NSLocalizedDescriptionKey]);
        [expectation fulfill];
    }];
    [[LPRequestQueue sharedInstance] sendRequests:^{
        NSLog(@"test");
    } failure:^(NSError * _Nonnull error) {
        NSLog(@"failrure");
    }];
    [self waitForExpectationsWithTimeout:40.0 handler:^(NSError *error) {
        if (error) {
            NSLog(@"Error: %@", error);
        }
    }];
    [LPApiConstants sharedState].isMulti = YES;
}


/**
 * Tests whether setting user attributes and id works error correctly.
 */
- (void) testSetUserAttributesValidationScalarError
{
    sleep(1);
    [LPTestHelper setup];
    [LPApiConstants sharedState].isMulti = NO;
    [LPTestHelper setupStub:400 withFileName:@"simple_error_success_response.json"];
    XCTestExpectation *expectation = [self expectationWithDescription:@"Query timed out."];
    NSDictionary *userAttributes = @{@"name": @"John Smith",
                                     @"age": [NSNull class],
                                     @"address": @"New York"
                                     };

    // Try to set user id and attributes.
    [Leanplum setUserAttributes:userAttributes withSuccess:^{
    } withFailure:^(NSError *error) {
        NSString *expectedMessage = @"Unknown error, please contact Leanplum.";
        XCTAssertEqualObjects(expectedMessage, [error userInfo][NSLocalizedDescriptionKey]);
        [expectation fulfill];
    }];
    [[LPRequestQueue sharedInstance] sendRequests:^{
        NSLog(@"test");
    } failure:^(NSError * _Nonnull error) {
        NSLog(@"failrure");
    }];
    [self waitForExpectationsWithTimeout:20.0 handler:^(NSError *error) {
        if (error) {
            NSLog(@"Error: %@", error);
        }
    }];
    [LPApiConstants sharedState].isMulti = YES;
}

/**
 * Tests whether setting user attributes and id works correctly with API Call
 */
- (void) testSetUserAttributesApiCall
{
    sleep(1);
    [LPTestHelper setup];
    XCTestExpectation *expectation = [self expectationWithDescription:@"Query timed out."];
    NSString *userId = @"john.smith";
    NSDictionary *userAttributes = @{@"name": @"John Smith",
                                     @"age": @42,
                                     @"address": @"New York"
                                     };

    // Try to set user id and attributes.
    [Leanplum setUserAttributes:userAttributes withSuccess:^{
        [expectation fulfill];
    } withFailure:^(NSError *error) {
    }];
    [[LPRequestQueue sharedInstance] sendRequests:^{
        NSLog(@"test");
    } failure:^(NSError * _Nonnull error) {
        NSLog(@"failrure");
    }];
    [self waitForExpectationsWithTimeout:20.0 handler:^(NSError *error) {
        if (error) {
            NSLog(@"Error: %@", error);
        }
    }];
}

/**
 * Tests whether setting user attributes and id works error correctly.
 */
- (void) testSetUserError
{
    sleep(1);
    [LPTestHelper setup];
    [LPApiConstants sharedState].isMulti = NO;
    [LPTestHelper setupStub:400 withFileName:@"simple_error_success_response.json"];
    XCTestExpectation *expectation = [self expectationWithDescription:@"Query timed out."];

    // Try to set user id and attributes.
    [Leanplum setUserId:nil withSuccess:^{
    } withFailure:^(NSError *error) {
        NSString *expectedMessage = @"Unknown error, please contact Leanplum.";
        XCTAssertEqualObjects(expectedMessage, [error userInfo][NSLocalizedDescriptionKey]);
        [expectation fulfill];
    }];
    [[LPRequestQueue sharedInstance] sendRequests:^{
        NSLog(@"test");
    } failure:^(NSError * _Nonnull error) {
        NSLog(@"failrure");
    }];
    [self waitForExpectationsWithTimeout:40.0 handler:^(NSError *error) {
        if (error) {
            NSLog(@"Error: %@", error);
        }
    }];
    [LPApiConstants sharedState].isMulti = YES;
}

/**
 * Tests whether setting user attributes and id works correctly with API Call
 */
- (void) testSetUserApiCall
{
    sleep(1);
    [LPTestHelper setup];
    XCTestExpectation *expectation = [self expectationWithDescription:@"Query timed out."];
    NSString *userId = @"john.smith";

    // Try to set user id and attributes.
    [Leanplum setUserId:userId withSuccess:^{
        [expectation fulfill];
    } withFailure:^(NSError *error) {
    }];
    [[LPRequestQueue sharedInstance] sendRequests:^{
        NSLog(@"test");
    } failure:^(NSError * _Nonnull error) {
        NSLog(@"failrure");
    }];
    [self waitForExpectationsWithTimeout:40.0 handler:^(NSError *error) {
        if (error) {
            NSLog(@"Error: %@", error);
        }
    }];
}

@end
