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


@interface LeanplumTests : XCTestCase

@end

@implementation LeanplumTests

- (void)setUp {
    [super setUp];
    [LPTestHelper setup];
}

- (void)tearDown {
    [super tearDown];
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
    [LPTestHelper setup];
    XCTestExpectation *expectation = [self expectationWithDescription:@"Query timed out."];
    // Try to set user id and attributes.
    [Leanplum setUserId:DEVICE_ID withUserAttributes:nil withSuccess:^{
        [expectation fulfill];
    } withFailure:^(NSError *error) {
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
    [LPTestHelper setup];
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
    
    [self waitForExpectationsWithTimeout:40.0 handler:^(NSError *error) {
        if (error) {
            NSLog(@"Error: %@", error);
        }
    }];
}

/**
 * Tests whether setting user attributes and id works correctly with API Call
 */
- (void) testUserAttributesApiCall
{
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
    [LPTestHelper setup];
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
    
    [self waitForExpectationsWithTimeout:40.0 handler:^(NSError *error) {
        if (error) {
            NSLog(@"Error: %@", error);
        }
    }];
}


/**
 * Tests whether setting user attributes and id works error correctly.
 */
- (void) testSetUserAttributesValidationScalarError
{
    [LPTestHelper setup];
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
    
    [self waitForExpectationsWithTimeout:40.0 handler:^(NSError *error) {
        if (error) {
            NSLog(@"Error: %@", error);
        }
    }];
}

/**
 * Tests whether setting user attributes and id works correctly with API Call
 */
- (void) testSetUserAttributesApiCall
{
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
    
    [self waitForExpectationsWithTimeout:40.0 handler:^(NSError *error) {
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
    [LPTestHelper setup];
    [LPTestHelper setupStub:400 withFileName:@"simple_error_success_response.json"];
    XCTestExpectation *expectation = [self expectationWithDescription:@"Query timed out."];

    // Try to set user id and attributes.
    [Leanplum setUserId:nil withSuccess:^{
    } withFailure:^(NSError *error) {
        NSString *expectedMessage = @"Unknown error, please contact Leanplum.";
        XCTAssertEqualObjects(expectedMessage, [error userInfo][NSLocalizedDescriptionKey]);
        [expectation fulfill];
    }];
    
    [self waitForExpectationsWithTimeout:40.0 handler:^(NSError *error) {
        if (error) {
            NSLog(@"Error: %@", error);
        }
    }];
}

/**
 * Tests whether setting user attributes and id works correctly with API Call
 */
- (void) testSetUserApiCall
{
    [LPTestHelper setup];
    XCTestExpectation *expectation = [self expectationWithDescription:@"Query timed out."];
    NSString *userId = @"john.smith";
    
    // Try to set user id and attributes.
    [Leanplum setUserId:userId withSuccess:^{
        [expectation fulfill];
    } withFailure:^(NSError *error) {
    }];
    
    [self waitForExpectationsWithTimeout:40.0 handler:^(NSError *error) {
        if (error) {
            NSLog(@"Error: %@", error);
        }
    }];
}

@end
