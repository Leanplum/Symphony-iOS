//
//  LPMarkNewsfeedMessageAsReadApiTest.m
//  LeanplumTests
//
//  Created by Mayank Sanganeria on 5/22/19.
//  Copyright © 2019 Leanplum. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <OHHTTPStubs/OHHTTPStubs.h>
#import <OHHTTPStubs/OHPathHelpers.h>
#import "LPMarkNewsfeedMessageAsReadApi.h"
#import "LPAPIConfig.h"
#import "LPConstants.h"
#import "LPTestHelper.h"
#import "LPApiConstants.h"
#import "LPRequestQueue.h"

@interface LPMarkNewsfeedMessageAsReadApiTest : XCTestCase

@end

@implementation LPMarkNewsfeedMessageAsReadApiTest

- (void)setUp {
    [super setUp];
    [LPTestHelper setup];
}

- (void)tearDown {
    [super tearDown];
    [OHHTTPStubs removeAllStubs];
}

//ToDo: Cannot use backend call, we might have to delete this api
/*
- (void)testMarkNewsfeedMessageAsReadApi {
    XCTestExpectation *expectation = [self expectationWithDescription:@"Query timed out."];
    [LPMarkNewsfeedMessageAsReadApi markNewsfeedMessageAsReadWithMessageId:@"0" parameters:nil success:^ {
        [expectation fulfill];
    } failure:^(NSError *error) {
    }];
    
    [self waitForExpectationsWithTimeout:30.0 handler:^(NSError *error) {
        if (error) {
            NSLog(@"Error: %@", error);
        }
    }];
}

- (void)testMarkNewsfeedMessageAsReadApiWithParameters {
    XCTestExpectation *expectation = [self expectationWithDescription:@"Query timed out."];
    NSDictionary *params = @{ @"testKey": @"testValue" };
    [LPMarkNewsfeedMessageAsReadApi markNewsfeedMessageAsReadWithMessageId:@"0" parameters:nil success:^ {
        [expectation fulfill];
    } failure:^(NSError *error) {
    }];
    
    [self waitForExpectationsWithTimeout:10.0 handler:^(NSError *error) {
        if (error) {
            NSLog(@"Error: %@", error);
        }
    }];
}
*/
- (void)testMarkNewsfeedMessageAsReadApiWithHttpError {
    XCTestExpectation *expectation = [self expectationWithDescription:@"Query timed out."];
    // change device id to empty string
    [LPTestHelper setup:APPLICATION_ID withAccessKey:DEVELOPMENT_KEY withDeviceId:@""];
    [LPMarkNewsfeedMessageAsReadApi markNewsfeedMessageAsReadWithMessageId:@"0" parameters:nil success:^ {
    } failure:^(NSError *error) {
        NSString *expected = @"At least one of deviceId or userId is required.";
        XCTAssertEqualObjects([error userInfo][NSLocalizedDescriptionKey], expected);
        [expectation fulfill];
    } isMulti:NO];
    
    [self waitForExpectationsWithTimeout:10.0 handler:^(NSError *error) {
        if (error) {
            NSLog(@"Error: %@", error);
        }
    }];
}

- (void)testMarkNewsfeedMessageAsReadApiWithIosError {
    [LPTestHelper runWithApiHost:@"blah.leanplum.com" withBlock:^(void) {
        XCTestExpectation *expectation = [self expectationWithDescription:@"Query timed out."];
        [LPMarkNewsfeedMessageAsReadApi markNewsfeedMessageAsReadWithMessageId:@"0" parameters:nil success:^ {
        } failure:^(NSError *error) {
            NSString *expected = @"A server with the specified hostname could not be found.";
            XCTAssertEqualObjects([error userInfo][NSLocalizedDescriptionKey], expected);
            [expectation fulfill];
        } isMulti:NO];
        
        [self waitForExpectationsWithTimeout:10.0 handler:^(NSError *error) {
            if (error) {
                NSLog(@"Error: %@", error);
            }
        }];
    }];
}

- (void)testMarkNewsfeedMessageAsReadApiStub {
    [LPTestHelper setupStub:200 withFileName:@"simple_post_success_response.json"];
    XCTestExpectation *expectation = [self expectationWithDescription:@"Query timed out."];
    [LPMarkNewsfeedMessageAsReadApi markNewsfeedMessageAsReadWithMessageId:@"0" parameters:nil success:^ {
        [expectation fulfill];
    } failure:^(NSError *error) {
    } isMulti:NO];
    
    [self waitForExpectationsWithTimeout:10.0 handler:^(NSError *error) {
        if (error) {
            NSLog(@"Error: %@", error);
        }
    }];
}

- (void)testMarkNewsfeedMessageAsReadApiWithParametersStub {
    [LPTestHelper setupStub:200 withFileName:@"simple_post_success_response.json"];
    XCTestExpectation *expectation = [self expectationWithDescription:@"Query timed out."];
    [LPMarkNewsfeedMessageAsReadApi markNewsfeedMessageAsReadWithMessageId:@"0" parameters:nil success:^ {
        [expectation fulfill];
    } failure:^(NSError *error) {
    } isMulti:NO];
    
    [self waitForExpectationsWithTimeout:10.0 handler:^(NSError *error) {
        if (error) {
            NSLog(@"Error: %@", error);
        }
    }];
}

- (void)testMarkNewsfeedMessageAsReadApiHttpErrorStub {
    [LPTestHelper setupStub:400 withFileName:@"simple_post_error_response.json"];
    XCTestExpectation *expectation = [self expectationWithDescription:@"Query timed out."];
    [LPMarkNewsfeedMessageAsReadApi markNewsfeedMessageAsReadWithMessageId:@"0" parameters:nil success:^ {
    } failure:^(NSError *error) {
        NSString *expectedMessage = @"This is a test error message";
        XCTAssertEqualObjects(expectedMessage, [error userInfo][NSLocalizedDescriptionKey]);
        [expectation fulfill];
    } isMulti:NO];
    
    [self waitForExpectationsWithTimeout:10.0 handler:^(NSError *error) {
        if (error) {
            NSLog(@"Error: %@", error);
        }
    }];
}

- (void)testMarkNewsfeedMessageAsReadApiMalformedResponseStub {
    [LPTestHelper setupStub:200 withFileName:@"malformed_success_response.json"];
    XCTestExpectation *expectation = [self expectationWithDescription:@"Query timed out."];
    [LPMarkNewsfeedMessageAsReadApi markNewsfeedMessageAsReadWithMessageId:@"0" parameters:nil success:^ {
    } failure:^(NSError *error) {
        NSString *expectedMessage = @"Unknown error, please contact Leanplum.";
        XCTAssertEqualObjects(expectedMessage, [error userInfo][NSLocalizedDescriptionKey]);
        [expectation fulfill];
    } isMulti:NO];
    
    [self waitForExpectationsWithTimeout:10.0 handler:^(NSError *error) {
        if (error) {
            NSLog(@"Error: %@", error);
        }
    }];
}

@end
