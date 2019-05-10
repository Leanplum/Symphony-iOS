//
//  LPUserApiTests.m
//  LeanplumTests
//
//  Created by Hrishikesh Amravatkar on 5/2/19.
//  Copyright © 2019 Leanplum. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <OHHTTPStubs/OHHTTPStubs.h>
#import <OHHTTPStubs/OHPathHelpers.h>
#import "LPUserApi.h"
#import "LPAPIConfig.h"
#import "LPTestHelper.h"


@interface LPUserApiTests : XCTestCase

@end

@implementation LPUserApiTests

- (void)setUp {
    [super setUp];
    [LPTestHelper setup];
}

- (void)tearDown {
    [super tearDown];
    [OHHTTPStubs removeAllStubs];
}

- (void)testUserApi {
    XCTestExpectation *expectation = [self expectationWithDescription:@"Query timed out."];
    [LPUserApi setUserAttributes:@"1" withUserAttributes:nil success:^ {
        NSLog(@"HERE");
        [expectation fulfill];
    } failure:^(NSError *error) {
        NSLog(@"Error");
        [expectation fulfill];
    }];
    
    [self waitForExpectationsWithTimeout:30.0 handler:^(NSError *error) {
        if (error) {
            NSLog(@"Error: %@", error);
        }
    }];
}

- (void)testUserApiWithHttpError {
    XCTestExpectation *expectation = [self expectationWithDescription:@"Query timed out."];
    // change device id to empty string
    [LPTestHelper setup:APPLICATION_ID withAccessKey:DEVELOPMENT_KEY withDeviceId:@""];
    [LPUserApi setUserAttributes:@"1" withUserAttributes:nil success:^ {
    } failure:^(NSError *error) {
        [expectation fulfill];
    }];
    
    [self waitForExpectationsWithTimeout:10.0 handler:^(NSError *error) {
        if (error) {
            NSLog(@"Error: %@", error);
        }
    }];
}

- (void)testUserApiWithIosError {
    [LPTestHelper runWithApiHost:@"blah.leanplum.com" withBlock:^(void) {
        XCTestExpectation *expectation = [self expectationWithDescription:@"Query timed out."];
        [LPUserApi setUserAttributes:@"1" withUserAttributes:nil success:^ {
        } failure:^(NSError *error) {
            [expectation fulfill];
        }];
        
        [self waitForExpectationsWithTimeout:10.0 handler:^(NSError *error) {
            if (error) {
                NSLog(@"Error: %@", error);
            }
        }];
    }];
}

- (void)testUserApiStub {
    [LPTestHelper setupStub:200 withFileName:@"simple_success_response.json"];
    XCTestExpectation *expectation = [self expectationWithDescription:@"Query timed out."];
    [LPUserApi setUserAttributes:@"1" withUserAttributes:nil success:^ {
        [expectation fulfill];
    } failure:^(NSError *error) {
    }];
    
    [self waitForExpectationsWithTimeout:10.0 handler:^(NSError *error) {
        if (error) {
            NSLog(@"Error: %@", error);
        }
    }];
}

- (void)testUserApiHttpErrorStub {
    [LPTestHelper setupStub:400 withFileName:@"simple_error_response.json"];
    XCTestExpectation *expectation = [self expectationWithDescription:@"Query timed out."];
    [LPUserApi setUserAttributes:@"1" withUserAttributes:nil success:^ {
    } failure:^(NSError *error) {
        NSString *expectedMessage = @"This is a test error message";
        XCTAssertEqualObjects(expectedMessage, [error userInfo][NSLocalizedDescriptionKey]);
        [expectation fulfill];
    }];
    
    [self waitForExpectationsWithTimeout:10.0 handler:^(NSError *error) {
        if (error) {
            NSLog(@"Error: %@", error);
        }
    }];
}

- (void)testUserApiMalformedResponseStub {
    [LPTestHelper setupStub:200 withFileName:@"malformed_success_response.json"];
    XCTestExpectation *expectation = [self expectationWithDescription:@"Query timed out."];
    [LPUserApi setUserAttributes:@"1" withUserAttributes:nil success:^ {
    } failure:^(NSError *error) {
        NSString *expectedMessage = @"Invalid Input";
        XCTAssertEqualObjects(expectedMessage, [error userInfo][NSLocalizedDescriptionKey]);
        [expectation fulfill];
    }];
    
    [self waitForExpectationsWithTimeout:10.0 handler:^(NSError *error) {
        if (error) {
            NSLog(@"Error: %@", error);
        }
    }];
}

@end
