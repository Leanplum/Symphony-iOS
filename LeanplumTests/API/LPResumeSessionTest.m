//
//  LPResumeSessionTest.m
//  LeanplumTests
//
//  Created by Grace on 5/17/19.
//  Copyright © 2019 Leanplum. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <OHHTTPStubs/OHHTTPStubs.h>
#import <OHHTTPStubs/OHPathHelpers.h>
#import "LPResumeSessionApi.h"
#import "LPAPIConfig.h"
#import "LPConstants.h"
#import "LPTestHelper.h"
#import "LPApiConstants.h"
#import "LPRequestQueue.h"

@interface LPResumeSessionTest : XCTestCase

@end

@implementation LPResumeSessionTest

- (void)setUp {
    [super setUp];
    [LPTestHelper setup];
}

- (void)tearDown {
    [super tearDown];
    [OHHTTPStubs removeAllStubs];
}

- (void)testResumeSessionApi {
    XCTestExpectation *expectation = [self expectationWithDescription:@"Query timed out."];
    [LPResumeSessionApi resumeSessionWithParameters:nil success:^ {
        [expectation fulfill];
    } failure:^(NSError *error) {
    } isMulti: NO];
    
    [self waitForExpectationsWithTimeout:30.0 handler:^(NSError *error) {
        if (error) {
            NSLog(@"Error: %@", error);
        }
    }];
}

- (void)testResumeSessionApiWithMulti {
    sleep(1);
    XCTestExpectation *expectation = [self expectationWithDescription:@"Query timed out."];
    [LPResumeSessionApi resumeSessionWithParameters:nil success:^ {
        [expectation fulfill];
    } failure:^(NSError *error) {
    } isMulti:YES];
    [[LPRequestQueue sharedInstance] sendRequests:^{
        NSLog(@"success");
    } failure:^(NSError * _Nonnull error) {
        NSLog(@"failure");
    }];

    [self waitForExpectationsWithTimeout:30.0 handler:^(NSError *error) {
        if (error) {
            NSLog(@"Error: %@", error);
        }
    }];
}

- (void)testResumeSessionApiWithAttributes {
    XCTestExpectation *expectation = [self expectationWithDescription:@"Query timed out."];
    NSDictionary *attributes = @{ @"testKey": @"testValue" };
    [LPResumeSessionApi resumeSessionWithParameters:attributes success:^ {
        [expectation fulfill];
    } failure:^(NSError *error) {
    } isMulti: NO];
    
    [self waitForExpectationsWithTimeout:10.0 handler:^(NSError *error) {
        if (error) {
            NSLog(@"Error: %@", error);
        }
    }];
}

- (void)testResumeSessionApiWithHttpError {
    XCTestExpectation *expectation = [self expectationWithDescription:@"Query timed out."];
    // change device id to empty string
    [LPTestHelper setup:APPLICATION_ID withAccessKey:DEVELOPMENT_KEY withDeviceId:@""];
    [LPResumeSessionApi resumeSessionWithParameters:nil success:^ {
    } failure:^(NSError *error) {
        NSString *expected = @"At least one of deviceId or userId is required.";
        XCTAssertEqualObjects([error userInfo][NSLocalizedDescriptionKey], expected);
        [expectation fulfill];
    } isMulti: NO];
    
    [self waitForExpectationsWithTimeout:10.0 handler:^(NSError *error) {
        if (error) {
            NSLog(@"Error: %@", error);
        }
    }];
}

- (void)testResumeSessionApiWithIosError {
    [LPTestHelper setupStub:400 withFileName:@"simple_post_success_response.json"];
    XCTestExpectation *expectation = [self expectationWithDescription:@"Query timed out."];
    [LPResumeSessionApi resumeSessionWithParameters:nil success:^ {
    } failure:^(NSError *error) {
        NSString *expected = @"A server with the specified hostname could not be found.";
        [expectation fulfill];
    } isMulti: NO];
    
    [self waitForExpectationsWithTimeout:10.0 handler:^(NSError *error) {
        if (error) {
            NSLog(@"Error: %@", error);
        }
    }];
}

- (void)testResumeSessionApiStub {
    [LPTestHelper setupStub:200 withFileName:@"simple_post_success_response.json"];
    XCTestExpectation *expectation = [self expectationWithDescription:@"Query timed out."];
    [LPResumeSessionApi resumeSessionWithParameters:nil success:^ {
        [expectation fulfill];
    } failure:^(NSError *error) {
    } isMulti: NO];
    
    [self waitForExpectationsWithTimeout:10.0 handler:^(NSError *error) {
        if (error) {
            NSLog(@"Error: %@", error);
        }
    }];
}

- (void)testResumeSessionApiWithAttributesStub {
    [LPTestHelper setupStub:200 withFileName:@"simple_post_success_response.json"];
    XCTestExpectation *expectation = [self expectationWithDescription:@"Query timed out."];
    NSDictionary *attributes = @{@"testKey": @"testValue" };
    [LPResumeSessionApi resumeSessionWithParameters:attributes success:^ {
        [expectation fulfill];
    } failure:^(NSError *error) {
    } isMulti: NO];
    
    [self waitForExpectationsWithTimeout:10.0 handler:^(NSError *error) {
        if (error) {
            NSLog(@"Error: %@", error);
        }
    }];
}

- (void)testResumeSessionApiHttpErrorStub {
    [LPTestHelper setupStub:400 withFileName:@"simple_post_error_response.json"];
    XCTestExpectation *expectation = [self expectationWithDescription:@"Query timed out."];
    [LPResumeSessionApi resumeSessionWithParameters:nil success:^ {
    } failure:^(NSError *error) {
        NSString *expectedMessage = @"This is a test error message";
        XCTAssertEqualObjects(expectedMessage, [error userInfo][NSLocalizedDescriptionKey]);
        [expectation fulfill];
    } isMulti: NO];
    
    [self waitForExpectationsWithTimeout:10.0 handler:^(NSError *error) {
        if (error) {
            NSLog(@"Error: %@", error);
        }
    }];
}

- (void)testResumeSessionApiMalformedResponseStub {
    [LPTestHelper setupStub:200 withFileName:@"malformed_success_response.json"];
    XCTestExpectation *expectation = [self expectationWithDescription:@"Query timed out."];
    [LPResumeSessionApi resumeSessionWithParameters:nil success:^ {
    } failure:^(NSError *error) {
        NSString *expectedMessage = @"Unknown error, please contact Leanplum.";
        XCTAssertEqualObjects(expectedMessage, [error userInfo][NSLocalizedDescriptionKey]);
        [expectation fulfill];
    } isMulti: NO];
    
    [self waitForExpectationsWithTimeout:10.0 handler:^(NSError *error) {
        if (error) {
            NSLog(@"Error: %@", error);
        }
    }];
}

@end
