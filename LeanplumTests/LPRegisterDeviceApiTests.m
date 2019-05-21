//
//  LPRegisterDeviceApiTests.m
//  LeanplumTests
//
//  Created by Grace on 5/14/19.
//  Copyright © 2019 Leanplum. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <OHHTTPStubs/OHHTTPStubs.h>
#import <OHHTTPStubs/OHPathHelpers.h>
#import "LPRegisterDeviceApi.h"
#import "LPAPIConfig.h"
#import "LPConstants.h"
#import "LPTestHelper.h"

@interface LPRegisterDeviceApiTests : XCTestCase

@end

@implementation LPRegisterDeviceApiTests

- (void)setUp {
    [super setUp];
    [LPTestHelper setup];
}

- (void)tearDown {
    [super tearDown];
    [OHHTTPStubs removeAllStubs];
}

- (void)testRegisterDeviceApi {
    XCTestExpectation *expectation = [self expectationWithDescription:@"Query timed out."];
    [LPRegisterDeviceApi registerDevice:nil success:^ {
        [expectation fulfill];
    } failure:^(NSError *error) {
    }];
    
    [self waitForExpectationsWithTimeout:30.0 handler:^(NSError *error) {
        if (error) {
            NSLog(@"Error: %@", error);
        }
    }];
}

- (void)testRegisterDeviceApiWithAttributes {
    XCTestExpectation *expectation = [self expectationWithDescription:@"Query timed out."];
    NSDictionary *attributes = @{ LP_PARAM_EMAIL: @"test@leanplum.com" };
    [LPRegisterDeviceApi registerDevice:attributes success:^ {
        [expectation fulfill];
    } failure:^(NSError *error) {
    }];

    [self waitForExpectationsWithTimeout:10.0 handler:^(NSError *error) {
        if (error) {
            NSLog(@"Error: %@", error);
        }
    }];
}

- (void)testRegisterDeviceApiWithHttpError {
    XCTestExpectation *expectation = [self expectationWithDescription:@"Query timed out."];
    // change device id to empty string
    [LPTestHelper setup:APPLICATION_ID withAccessKey:DEVELOPMENT_KEY withDeviceId:@""];
    [LPRegisterDeviceApi registerDevice:nil success:^ {
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

- (void)testRegisterDeviceApiWithIosError {
    [LPTestHelper runWithApiHost:@"blah.leanplum.com" withBlock:^(void) {
        XCTestExpectation *expectation = [self expectationWithDescription:@"Query timed out."];
        [LPRegisterDeviceApi registerDevice:nil success:^ {
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

- (void)testRegisterDeviceApiStub {
    [LPTestHelper setupStub:200 withFileName:@"simple_post_success_response.json"];
    XCTestExpectation *expectation = [self expectationWithDescription:@"Query timed out."];
    [LPRegisterDeviceApi registerDevice:nil success:^ {
        [expectation fulfill];
    } failure:^(NSError *error) {
    }];

    [self waitForExpectationsWithTimeout:10.0 handler:^(NSError *error) {
        if (error) {
            NSLog(@"Error: %@", error);
        }
    }];
}

- (void)testRegisterDeviceApiWithAttributesStub {
    [LPTestHelper setupStub:200 withFileName:@"simple_post_success_response.json"];
    XCTestExpectation *expectation = [self expectationWithDescription:@"Query timed out."];
    NSDictionary *attributes = @{ LP_PARAM_EMAIL: @"test@leanplum.com" };
    [LPRegisterDeviceApi registerDevice:attributes success:^ {
        [expectation fulfill];
    } failure:^(NSError *error) {
    }];

    [self waitForExpectationsWithTimeout:10.0 handler:^(NSError *error) {
        if (error) {
            NSLog(@"Error: %@", error);
        }
    }];
}

- (void)testRegisterDeviceApiHttpErrorStub {
    [LPTestHelper setupStub:400 withFileName:@"simple_post_error_response.json"];
    XCTestExpectation *expectation = [self expectationWithDescription:@"Query timed out."];
    [LPRegisterDeviceApi registerDevice:nil success:^ {
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

- (void)testRegisterDeviceApiMalformedResponseStub {
    [LPTestHelper setupStub:200 withFileName:@"malformed_success_response.json"];
    XCTestExpectation *expectation = [self expectationWithDescription:@"Query timed out."];
    [LPRegisterDeviceApi registerDevice:nil success:^ {
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
