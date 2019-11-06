//
//  LPDeviceApiTests.m
//  LeanplumTests
//
//  Created by Grace on 5/10/19.
//  Copyright © 2019 Leanplum. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <OHHTTPStubs/OHHTTPStubs.h>
#import <OHHTTPStubs/OHPathHelpers.h>
#import "LPDeviceApi.h"
#import "LPDeviceApi+Categories.h"
#import "LPAPIConfig.h"
#import "LPTestHelper.h"
#import "LPApiConstants.h"
#import "LPRequestQueue.h"
#import "LPRequestManager.h"

@interface LPDeviceApiTests : XCTestCase

@end

@implementation LPDeviceApiTests

- (void)setUp {
    [super setUp];
    [LPTestHelper setup];
}

- (void)tearDown {
    [super tearDown];
    [OHHTTPStubs removeAllStubs];
}

- (void)testDeviceApi {
    XCTestExpectation *expectation = [self expectationWithDescription:@"Query timed out."];
    [LPDeviceApi setDeviceId:[LPAPIConfig sharedConfig].deviceId withDeviceAttributes:nil success:^ {
        [expectation fulfill];
    } failure:^(NSError *error) {
    } isMulti: NO];

    [self waitForExpectationsWithTimeout:30.0 handler:^(NSError *error) {
        if (error) {
            NSLog(@"Error: %@", error);
        }
    }];
}

- (void)testDeviceApiWithMulti {
    sleep(1);
    XCTestExpectation *expectation = [self expectationWithDescription:@"Query timed out."];
    [LPDeviceApi setDeviceId:[LPAPIConfig sharedConfig].deviceId withDeviceAttributes:nil success:^ {
        [expectation fulfill];
    } failure:^(NSError *error) {
    } isMulti: NO];
    [[LPRequestQueue sharedInstance] sendRequests:^{
        NSLog(@"success");
    } failure:^(NSError * _Nonnull error) {
        NSLog(@"failure");
    }];
    
    [self waitForExpectationsWithTimeout:20.0 handler:^(NSError *error) {
        if (error) {
            NSLog(@"Error: %@", error);
        }
    }];
}

- (void)testDeviceApiWithDeviceAttributes {
    XCTestExpectation *expectation = [self expectationWithDescription:@"Query timed out."];
    NSDictionary *deviceAttributes = @{@"OS" : @"iOS"};
    [LPDeviceApi setDeviceId:DEVICE_ID withDeviceAttributes:deviceAttributes success:^ {
        [expectation fulfill];
    } failure:^(NSError *error) {
    } isMulti: NO];
    
    [self waitForExpectationsWithTimeout:10.0 handler:^(NSError *error) {
        if (error) {
            NSLog(@"Error: %@", error);
        }
    }];
}

- (void)testDeviceApiWithHttpError {
    XCTestExpectation *expectation = [self expectationWithDescription:@"Query timed out."];
    // change device id to empty string
    [LPTestHelper setup:APPLICATION_ID withAccessKey:DEVELOPMENT_KEY withDeviceId:@""];
    [LPDeviceApi setDeviceId:nil withDeviceAttributes:nil success:^ {
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

- (void)testDeviceApiWithIosError {
    [LPTestHelper runWithApiHost:@"blah.leanplum.com" withBlock:^(void) {
        XCTestExpectation *expectation = [self expectationWithDescription:@"Query timed out."];
        [LPDeviceApi setDeviceId:@"1" withDeviceAttributes:nil success:^ {
        } failure:^(NSError *error) {
            NSString *expected = @"A server with the specified hostname could not be found.";
            XCTAssertEqualObjects([error userInfo][NSLocalizedDescriptionKey], expected);
            [expectation fulfill];
        } isMulti: NO];
        
        [self waitForExpectationsWithTimeout:10.0 handler:^(NSError *error) {
            if (error) {
                NSLog(@"Error: %@", error);
            }
        }];
    }];
}

- (void)testDeviceApiStub {
    [LPTestHelper setupStub:200 withFileName:@"simple_post_success_response.json"];
    XCTestExpectation *expectation = [self expectationWithDescription:@"Query timed out."];
    [LPDeviceApi setDeviceId:@"1" withDeviceAttributes:nil success:^ {
        [expectation fulfill];
    } failure:^(NSError *error) {
    } isMulti: NO];
    
    [self waitForExpectationsWithTimeout:10.0 handler:^(NSError *error) {
        if (error) {
            NSLog(@"Error: %@", error);
        }
    }];
}

- (void)testDeviceApiWithDeviceAttributesStub {
    [LPTestHelper setupStub:200 withFileName:@"simple_post_success_response.json"];
    XCTestExpectation *expectation = [self expectationWithDescription:@"Query timed out."];
    NSDictionary *deviceAttributes = @{@"OS" : @"iOS"};
    [LPDeviceApi setDeviceId:DEVICE_ID withDeviceAttributes:deviceAttributes success:^ {
        [expectation fulfill];
    } failure:^(NSError *error) {
    } isMulti: NO];
    
    [self waitForExpectationsWithTimeout:10.0 handler:^(NSError *error) {
        if (error) {
            NSLog(@"Error: %@", error);
        }
    }];
}

- (void)testDeviceApiHttpErrorStub {
    [LPTestHelper setupStub:400 withFileName:@"simple_post_error_response.json"];
    XCTestExpectation *expectation = [self expectationWithDescription:@"Query timed out."];
    [LPDeviceApi setDeviceId:@"1" withDeviceAttributes:nil success:^ {
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

- (void)testDeviceApiMalformedResponseStub {
    [LPTestHelper setupStub:200 withFileName:@"malformed_success_response.json"];
    XCTestExpectation *expectation = [self expectationWithDescription:@"Query timed out."];
    [LPDeviceApi setDeviceId:@"1" withDeviceAttributes:nil success:^ {
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
