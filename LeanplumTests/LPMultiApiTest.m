//
//  LPMultiApiTest.m
//  LeanplumTests
//
//  Created by Mayank Sanganeria on 5/22/19.
//  Copyright © 2019 Leanplum. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <OHHTTPStubs/OHHTTPStubs.h>
#import <OHHTTPStubs/OHPathHelpers.h>
#import "LPMultiApi.h"
#import "LPAPIConfig.h"
#import "LPConstants.h"
#import "LPTestHelper.h"

@interface LPMultiApiTest : XCTestCase

@end

@implementation LPMultiApiTest

- (void)setUp {
    [super setUp];
    [LPTestHelper setup];
}

- (void)tearDown {
    [super tearDown];
    [OHHTTPStubs removeAllStubs];
}

- (void)testMultiApi {
    XCTestExpectation *expectation = [self expectationWithDescription:@"Query timed out."];
    [LPMultiApi multiWithData:[self sampleData] success:^ (NSArray *results){
        [expectation fulfill];
    } failure:^(NSError *error) {
    }];
    
    [self waitForExpectationsWithTimeout:30.0 handler:^(NSError *error) {
        if (error) {
            NSLog(@"Error: %@", error);
        }
    }];
}

- (void)testMultiApiWithParameters {
    // TODO: check on possible rate limit for just multi
    sleep(1);
    XCTestExpectation *expectation = [self expectationWithDescription:@"Query timed out."];
    [LPMultiApi multiWithData:[self sampleData] success:^ (NSArray *results) {
        [expectation fulfill];
    } failure:^(NSError *error) {
        NSLog(@"Error: %@", error);
    }];

    [self waitForExpectationsWithTimeout:20.0 handler:^(NSError *error) {
        if (error) {
            NSLog(@"Error: %@", error);
        }
    }];
}

- (void)testMultiApiWithHttpError {
    XCTestExpectation *expectation = [self expectationWithDescription:@"Query timed out."];
    // send empty data
    [LPTestHelper setup:APPLICATION_ID withAccessKey:DEVELOPMENT_KEY withDeviceId:@""];
    [LPMultiApi multiWithData:nil success:^ (NSArray *results) {
        NSLog(@"here");
    } failure:^(NSError *error) {
        NSString *expected = @"No data argument supplied";
        XCTAssertEqualObjects([error userInfo][NSLocalizedDescriptionKey], expected);
        [expectation fulfill];
    }];

    [self waitForExpectationsWithTimeout:20.0 handler:^(NSError *error) {
        if (error) {
            NSLog(@"Error: %@", error);
        }
    }];
}

- (void)testMultiApiWithIosError {
    [LPTestHelper runWithApiHost:@"blah.leanplum.com" withBlock:^(void) {
        XCTestExpectation *expectation = [self expectationWithDescription:@"Query timed out."];
        [LPMultiApi multiWithData:[self sampleData] success:^ (NSArray *results) {
        } failure:^(NSError *error) {
            NSString *expected = @"A server with the specified hostname could not be found.";
            XCTAssertEqualObjects([error userInfo][NSLocalizedDescriptionKey], expected);
            [expectation fulfill];
        }];
        
        [self waitForExpectationsWithTimeout:20.0 handler:^(NSError *error) {
            if (error) {
                NSLog(@"Error: %@", error);
            }
        }];
    }];
}

- (void)testMultiApiStub {
    [LPTestHelper setupStub:200 withFileName:@"simple_post_success_response.json"];
    XCTestExpectation *expectation = [self expectationWithDescription:@"Query timed out."];
    [LPMultiApi multiWithData:[self sampleData] success:^ (NSArray *results) {
        [expectation fulfill];
    } failure:^(NSError *error) {
    }];
    
    [self waitForExpectationsWithTimeout:20.0 handler:^(NSError *error) {
        if (error) {
            NSLog(@"Error: %@", error);
        }
    }];
}

// TODO: check if multi accepts / uses parameters?
- (void)testMultiApiWithParametersStub {
    [LPTestHelper setupStub:200 withFileName:@"simple_post_success_response.json"];
    XCTestExpectation *expectation = [self expectationWithDescription:@"Query timed out."];
    [LPMultiApi multiWithData:[self sampleData] success:^ (NSArray *results) {
        [expectation fulfill];
    } failure:^(NSError *error) {
    }];
    
    [self waitForExpectationsWithTimeout:20.0 handler:^(NSError *error) {
        if (error) {
            NSLog(@"Error: %@", error);
        }
    }];
}

- (void)testMultiApiHttpErrorStub {
    [LPTestHelper setupStub:400 withFileName:@"simple_post_error_response.json"];
    XCTestExpectation *expectation = [self expectationWithDescription:@"Query timed out."];
    [LPMultiApi multiWithData:[self sampleData] success:^ (NSArray *results) {
    } failure:^(NSError *error) {
        NSString *expectedMessage = @"This is a test error message";
        XCTAssertEqualObjects(expectedMessage, [error userInfo][NSLocalizedDescriptionKey]);
        [expectation fulfill];
    }];
    
    [self waitForExpectationsWithTimeout:20.0 handler:^(NSError *error) {
        if (error) {
            NSLog(@"Error: %@", error);
        }
    }];
}

- (void)testMultiApiMalformedResponseStub {
    [LPTestHelper setupStub:200 withFileName:@"malformed_multi_success_response.json"];
    XCTestExpectation *expectation = [self expectationWithDescription:@"Query timed out."];
    [LPMultiApi multiWithData:[self sampleData] success:^ (NSArray *results) {
        NSLog(@"%@", results);
        XCTAssertEqualObjects(results[0][@"error"][@"message"], @"Error message provided here.");
        [expectation fulfill];
    } failure:^(NSError *error) {
        NSString *expectedMessage = @"Unknown error, please contact Leanplum.";
        XCTAssertEqualObjects(expectedMessage, [error userInfo][NSLocalizedDescriptionKey]);
    }];
    
    [self waitForExpectationsWithTimeout:20.0 handler:^(NSError *error) {
        if (error) {
            NSLog(@"Error: %@", error);
        }
    }];
}

- (NSArray *)sampleData {
    NSArray *data = @[@{
                          @"action": @"track",
                          @"deviceId": @"5C8824DD-7F71-4587-AE56-0F62763296F7",
                          @"userId": @"5C8824DD-7F71-4587-AE56-0F62763296F7",
                          @"client": @"ios",
                          @"sdkVersion": @"2.4.2",
                          @"devMode": @(YES),
                          @"time": @"1559307918.899670",
                          @"event": @"testEvent",
                          @"value": @"0.000000",
                          @"uuid": @"D5967389-5457-4DAA-8378-3C47F63817FF"
                          }];
    return data;
}

@end
