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

/**
 * Tests whether setting user attributes and id works correctly.
 */
- (void) test_user_attributes
{
    [LPTestHelper setupStub:200 withFileName:@"simple_success_response.json"];
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
    
    [self waitForExpectationsWithTimeout:10.0 handler:^(NSError *error) {
        if (error) {
            NSLog(@"Error: %@", error);
        }
    }];
}

/**
 * Tests whether setting user attributes and id works correctly with API Call
 */
- (void) test_user_attributes_api_call
{
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
    
    [self waitForExpectationsWithTimeout:10.0 handler:^(NSError *error) {
        if (error) {
            NSLog(@"Error: %@", error);
        }
    }];
}
@end
