//
//  LPHeartbeatApiTest.m
//  LeanplumTests
//
//  Created by Mayank Sanganeria on 5/22/19.
//  Copyright © 2019 Leanplum. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <OHHTTPStubs/OHHTTPStubs.h>
#import <OHHTTPStubs/OHPathHelpers.h>
#import "LPHeartbeatApi.h"
#import "LPAPIConfig.h"
#import "LPConstants.h"
#import "LPTestHelper.h"

@interface LPHeartbeatApiTest : XCTestCase

@end

@implementation LPHeartbeatApiTest

- (void)setUp {
    [super setUp];
    [LPTestHelper setup];
}

- (void)tearDown {
    [super tearDown];
    [OHHTTPStubs removeAllStubs];
}

- (void)testHeartbeatApi {
    XCTestExpectation *expectation = [self expectationWithDescription:@"Query timed out."];
    [LPHeartbeatApi heartbeatWithParameters:nil success:^ {
        [expectation fulfill];
    } failure:^(NSError *error) {
    }];
    
    [self waitForExpectationsWithTimeout:30.0 handler:^(NSError *error) {
        if (error) {
            NSLog(@"Error: %@", error);
        }
    }];
}

- (void)testHeartbeatApiWithParameters {
    XCTestExpectation *expectation = [self expectationWithDescription:@"Query timed out."];
    NSDictionary *params = @{ @"testKey": @"testValue" };
    [LPHeartbeatApi heartbeatWithParameters:params success:^ {
        [expectation fulfill];
    } failure:^(NSError *error) {
    }];
    
    [self waitForExpectationsWithTimeout:10.0 handler:^(NSError *error) {
        if (error) {
            NSLog(@"Error: %@", error);
        }
    }];
}

- (void)testHeartbeatApiWithHttpError {
    XCTestExpectation *expectation = [self expectationWithDescription:@"Query timed out."];
    // change device id to empty string
    [LPTestHelper setup:APPLICATION_ID withAccessKey:DEVELOPMENT_KEY withDeviceId:@""];
    [LPHeartbeatApi heartbeatWithParameters:nil success:^ {
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

- (void)testHeartbeatApiWithIosError {
    [LPTestHelper runWithApiHost:@"blah.leanplum.com" withBlock:^(void) {
        XCTestExpectation *expectation = [self expectationWithDescription:@"Query timed out."];
        [LPHeartbeatApi heartbeatWithParameters:nil success:^ {
        } failure:^(NSError *error) {
            NSString *expected = @"A server with the specified hostname could not be found.";
            XCTAssertEqualObjects([error userInfo][NSLocalizedDescriptionKey], expected);
            [expectation fulfill];
        }];
        
        [self waitForExpectationsWithTimeout:10.0 handler:^(NSError *error) {
            if (error) {
                NSLog(@"Error: %@", error);
            }
        }];
    }];
}

- (void)testHeartbeatApiStub {
    [LPTestHelper setupStub:200 withFileName:@"simple_post_success_response.json"];
    XCTestExpectation *expectation = [self expectationWithDescription:@"Query timed out."];
    [LPHeartbeatApi heartbeatWithParameters:nil success:^ {
        [expectation fulfill];
    } failure:^(NSError *error) {
    }];
    
    [self waitForExpectationsWithTimeout:10.0 handler:^(NSError *error) {
        if (error) {
            NSLog(@"Error: %@", error);
        }
    }];
}

- (void)testHeartbeatApiWithParametersStub {
    [LPTestHelper setupStub:200 withFileName:@"simple_post_success_response.json"];
    XCTestExpectation *expectation = [self expectationWithDescription:@"Query timed out."];
    NSDictionary *params = @{@"testKey": @"testValue" };
    [LPHeartbeatApi heartbeatWithParameters:params success:^ {
        [expectation fulfill];
    } failure:^(NSError *error) {
    }];
    
    [self waitForExpectationsWithTimeout:10.0 handler:^(NSError *error) {
        if (error) {
            NSLog(@"Error: %@", error);
        }
    }];
}

- (void)testHeartbeatApiHttpErrorStub {
    [LPTestHelper setupStub:400 withFileName:@"simple_post_error_response.json"];
    XCTestExpectation *expectation = [self expectationWithDescription:@"Query timed out."];
    [LPHeartbeatApi heartbeatWithParameters:nil success:^ {
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

- (void)testHeartbeatApiMalformedResponseStub {
    [LPTestHelper setupStub:200 withFileName:@"malformed_success_response.json"];
    XCTestExpectation *expectation = [self expectationWithDescription:@"Query timed out."];
    [LPHeartbeatApi heartbeatWithParameters:nil success:^ {
    } failure:^(NSError *error) {
        NSString *expectedMessage = @"Unknown error, please contact Leanplum.";
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
