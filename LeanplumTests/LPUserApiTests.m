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
    [LPUserApi setUsersAttributes:@"1" withUserAttributes:nil success:^ {
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
    [LPUserApi setUsersAttributes:@"1" withUserAttributes:nil success:^ {
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
        [LPUserApi setUsersAttributes:@"1" withUserAttributes:nil success:^ {
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
    [OHHTTPStubs stubRequestsPassingTest:^BOOL(NSURLRequest * _Nonnull request) {
        return [request.URL.host isEqualToString:API_HOST];
    } withStubResponse:^OHHTTPStubsResponse * _Nonnull(NSURLRequest * _Nonnull request) {
        NSString *response_file = OHPathForFile(@"simple_error_response.json", self.class);
        NSLog(@"response file is %@", response_file);
        return [OHHTTPStubsResponse responseWithFileAtPath:response_file statusCode:400
                                                   headers:@{@"Content-Type":@"application/json"}];
    }];
    XCTestExpectation *expectation = [self expectationWithDescription:@"Query timed out."];
    [LPUserApi setUsersAttributes:@"1" withUserAttributes:nil success:^ {
        //NSLog(@"HERE");
        //[expectation fulfill];
    } failure:^(NSError *error) {
        NSLog(@"Error");
        NSString *message = @"This is a test error message";
        XCTAssertEqualObjects(message, [error userInfo][NSLocalizedDescriptionKey]);
        [expectation fulfill];
    }];
    
    [self waitForExpectationsWithTimeout:10.0 handler:^(NSError *error) {
        if (error) {
            NSLog(@"Error: %@", error);
        }
    }];
    
}

@end
