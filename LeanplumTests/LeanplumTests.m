//
//  LeanplumTests.m
//  LeanplumTests
//
//  Created by Mayank Sanganeria on 3/27/19.
//  Copyright © 2019 Leanplum. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <OHHTTPStubs/OHHTTPStubs.h>
#import "LPAPIConfig.h"
#import "LPApiConstants.h"
#import "LPTestHelper.h"
#import "Leanplum.h"
#import "LPRequestQueue.h"
#import "LPInternalState.h"
#import "LeanplumInternal.h"
#import "LPCache.h"
#import "LPPauseSessionApi+Categories.h"
#import "LPPauseStateApi+Categories.h"
#import "LPResumeSessionApi+Categories.h"
#import "LPResumeStateApi+Categories.h"

@interface LeanplumTests : XCTestCase


@end

@implementation LeanplumTests

+ (void)setUp {
    [super setUp];
    [LPPauseSessionApi swizzle_methods];
    [LPPauseStateApi swizzle_methods];
    [LPResumeStateApi swizzle_methods];
    [LPResumeSessionApi swizzle_methods];
}

+ (void)tearDown {
    [super tearDown];
    [LPPauseSessionApi swizzle_methods];
    [LPPauseStateApi swizzle_methods];
    [LPResumeStateApi swizzle_methods];
    [LPResumeSessionApi swizzle_methods];
}

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
        NSLog(@"failure");
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
        NSLog(@"failure");
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
        NSLog(@"failure");
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
        NSLog(@"failure");
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
        NSLog(@"failure");
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
        NSLog(@"failure");
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
        NSLog(@"failure");
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
        NSLog(@"failure");
    }];
    [self waitForExpectationsWithTimeout:40.0 handler:^(NSError *error) {
        if (error) {
            NSLog(@"Error: %@", error);
        }
    }];
}

/**
 * Tests start API Call
 */
- (void) testStartApiCall
{
    sleep(1);
    [LPTestHelper setup];
    XCTestExpectation *expectation = [self expectationWithDescription:@"Query timed out."];
    NSString *userId = @"john.smith";
    
    // Try to set user id and attributes.
    [Leanplum startWithUserId:nil userAttributes:nil withSuccess:^{
        [expectation fulfill];
    } withFailure:^(NSError *error) {
        NSLog(@"failure");
    }];
    
    [[LPRequestQueue sharedInstance] sendRequests:^{
        NSLog(@"test");
    } failure:^(NSError * _Nonnull error) {
        NSLog(@"failure");
    }];
    [self waitForExpectationsWithTimeout:40.0 handler:^(NSError *error) {
        if (error) {
            NSLog(@"Error: %@", error);
        }
    }];
}

/**
 * Tests start API Call with UserId
 */
- (void) testStartApiCallWithUserId
{
    sleep(1);
    [LPTestHelper setup];
    XCTestExpectation *expectation = [self expectationWithDescription:@"Query timed out."];
    
    // Try to set user id and attributes.
    [Leanplum startWithUserId:DEVICE_ID userAttributes:nil withSuccess:^{
        [expectation fulfill];
    } withFailure:^(NSError *error) {
        NSLog(@"failure");
    }];
    
    [[LPRequestQueue sharedInstance] sendRequests:^{
        NSLog(@"test");
    } failure:^(NSError * _Nonnull error) {
        NSLog(@"failure");
    }];
    [self waitForExpectationsWithTimeout:40.0 handler:^(NSError *error) {
        if (error) {
            NSLog(@"Error: %@", error);
        }
    }];
}

/**
 * Tests start API Call with UserId
 */
- (void) testStartApiCallWithInvalidUserId
{
    sleep(1);
    [LPTestHelper setup];
    XCTestExpectation *expectation = [self expectationWithDescription:@"Query timed out."];
    
    // Try to set user id and attributes.
    [Leanplum startWithUserId:@"abc" userAttributes:nil withSuccess:^{
        [expectation fulfill];
    } withFailure:^(NSError *error) {
        NSLog(@"failure");
    }];
    
    [[LPRequestQueue sharedInstance] sendRequests:^{
        NSLog(@"test");
    } failure:^(NSError * _Nonnull error) {
        NSLog(@"failure");
    }];
    [self waitForExpectationsWithTimeout:40.0 handler:^(NSError *error) {
        if (error) {
            NSLog(@"Error: %@", error);
        }
    }];
}


/**
 * Tests start API Call with Caching Regisions
 */
- (void) testStartApiCallWithRegionsCaching
{
    sleep(1);
    [LPTestHelper setup];
    XCTestExpectation *expectation = [self expectationWithDescription:@"Query timed out."];
    
    [[LPCache sharedCache] clearCache];
    // Try to set user id and attributes.
    [Leanplum startWithUserId:DEVICE_ID userAttributes:nil withSuccess:^{
        NSArray<LPRegion *> *regions = [[LPCache sharedCache] regions];
        XCTAssertNotNil(regions);
        [expectation fulfill];
    } withFailure:^(NSError *error) {
        NSLog(@"failure");
    }];
    
    [[LPRequestQueue sharedInstance] sendRequests:^{
        NSLog(@"test");
    } failure:^(NSError * _Nonnull error) {
        NSLog(@"failure");
    }];
    [self waitForExpectationsWithTimeout:40.0 handler:^(NSError *error) {
        if (error) {
            NSLog(@"Error: %@", error);
        }
    }];
}

/**
 * Tests sdk states.
 */
- (void)test_pause_session
{
    XCTestExpectation *expectation = [self expectationWithDescription:@"Query timed out."];
    // This stub have to be removed when start command is successfully executed.
    [LPTestHelper setupStub:200 withFileName:@"simple_start_response.json"];
    // Remove stub after start is successful, so we don't capture requests from other methods.
    
    [LPPauseSessionApi validate_onResponse:^(NSDictionary *response) {
        [expectation fulfill];
    }];

    [Leanplum pause];
    [self waitForExpectationsWithTimeout:2 handler:nil];
}

- (void)test_pause_state
{
    XCTestExpectation *expectation = [self expectationWithDescription:@"Query timed out."];
    // This stub have to be removed when start command is successfully executed.
    [LPTestHelper setupStub:200 withFileName:@"simple_start_response.json"];
    // Remove stub after start is successful, so we don't capture requests from other methods.
    
    [LPPauseStateApi validate_onResponse:^(NSDictionary *response) {
        [expectation fulfill];
    }];

    [Leanplum pauseState];
    [self waitForExpectationsWithTimeout:2 handler:nil];
}

- (void)test_resume_session
{
    XCTestExpectation *expectation = [self expectationWithDescription:@"Query timed out."];
    // This stub have to be removed when start command is successfully executed.
    [LPTestHelper setupStub:200 withFileName:@"simple_start_response.json"];
    // Remove stub after start is successful, so we don't capture requests from other methods.
    
    [LPResumeSessionApi validate_onResponse:^(NSDictionary *response) {
        [expectation fulfill];
    }];

    [Leanplum resume];
    [self waitForExpectationsWithTimeout:2 handler:nil];
}

- (void)test_resume_state
{
    XCTestExpectation *expectation = [self expectationWithDescription:@"Query timed out."];
    // This stub have to be removed when start command is successfully executed.
    [LPTestHelper setupStub:200 withFileName:@"simple_start_response.json"];
    // Remove stub after start is successful, so we don't capture requests from other methods.
    
    [LPResumeStateApi validate_onResponse:^(NSDictionary *response) {
        [expectation fulfill];
    }];

    [Leanplum resumeState];
    [self waitForExpectationsWithTimeout:2 handler:nil];
}
@end
