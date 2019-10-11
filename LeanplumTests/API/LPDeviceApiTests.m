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
    [LPApiConstants sharedState].isMulti = NO;
}

- (void)tearDown {
    [super tearDown];
    [LPApiConstants sharedState].isMulti = YES;
    [OHHTTPStubs removeAllStubs];
}

- (void)testDeviceApi {
    if(isSwizzlingEnabled) {
        [LPDeviceApi swizzle_methods];
    }
    XCTestExpectation *expectation = [self expectationWithDescription:@"Query timed out."];
    [LPDeviceApi setDeviceId:DEVICE_ID withDeviceAttributes:nil success:^ {
        [expectation fulfill];
    } failure:^(NSError *error) {
    }];

    [self waitForExpectationsWithTimeout:30.0 handler:^(NSError *error) {
        if (error) {
            NSLog(@"Error: %@", error);
        }
    }];
}

- (void)testDeviceApiWithMulti {
    sleep(1);
    if(isSwizzlingEnabled) {
        [LPDeviceApi swizzle_methods];
    }
    XCTestExpectation *expectation = [self expectationWithDescription:@"Query timed out."];
    [LPApiConstants sharedState].isMulti = YES;
    [LPRequestManager deleteRequestsWithLimit:100];
    [LPDeviceApi setDeviceId:DEVICE_ID withDeviceAttributes:nil success:^ {
        [expectation fulfill];
    } failure:^(NSError *error) {
    }];
    [[LPRequestQueue sharedInstance] sendRequests:^{
        NSLog(@"success");
    } failure:^(NSError * _Nonnull error) {
        NSLog(@"failure");
    }];
   [LPApiConstants sharedState].isMulti = NO;
    [self waitForExpectationsWithTimeout:20.0 handler:^(NSError *error) {
        if (error) {
            NSLog(@"Error: %@", error);
        }
    }];
}

- (void)testDeviceApiWithDeviceAttributes {
    if(isSwizzlingEnabled) {
        [LPDeviceApi swizzle_methods];
    }
    XCTestExpectation *expectation = [self expectationWithDescription:@"Query timed out."];
    NSDictionary *deviceAttributes = @{@"OS" : @"iOS"};
    [LPDeviceApi setDeviceId:DEVICE_ID withDeviceAttributes:deviceAttributes success:^ {
        [expectation fulfill];
    } failure:^(NSError *error) {
    }];
    
    [self waitForExpectationsWithTimeout:10.0 handler:^(NSError *error) {
        if (error) {
            NSLog(@"Error: %@", error);
        }
    }];
}

- (void)testDeviceApiWithHttpError {
    if(isSwizzlingEnabled) {
        [LPDeviceApi swizzle_methods];
    }
    XCTestExpectation *expectation = [self expectationWithDescription:@"Query timed out."];
    // change device id to empty string
    [LPTestHelper setup:APPLICATION_ID withAccessKey:DEVELOPMENT_KEY withDeviceId:@""];
    [LPDeviceApi setDeviceId:nil withDeviceAttributes:nil success:^ {
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

- (void)testDeviceApiWithIosError {
    if(isSwizzlingEnabled) {
        [LPDeviceApi swizzle_methods];
    }
    [LPTestHelper runWithApiHost:@"blah.leanplum.com" withBlock:^(void) {
        XCTestExpectation *expectation = [self expectationWithDescription:@"Query timed out."];
        [LPDeviceApi setDeviceId:@"1" withDeviceAttributes:nil success:^ {
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

- (void)testDeviceApiStub {
    if(isSwizzlingEnabled) {
        [LPDeviceApi swizzle_methods];
    }
    [LPTestHelper setupStub:200 withFileName:@"simple_post_success_response.json"];
    XCTestExpectation *expectation = [self expectationWithDescription:@"Query timed out."];
    [LPDeviceApi setDeviceId:@"1" withDeviceAttributes:nil success:^ {
        [expectation fulfill];
    } failure:^(NSError *error) {
    }];
    
    [self waitForExpectationsWithTimeout:10.0 handler:^(NSError *error) {
        if (error) {
            NSLog(@"Error: %@", error);
        }
    }];
}

- (void)testDeviceApiWithDeviceAttributesStub {
    if(isSwizzlingEnabled) {
        [LPDeviceApi swizzle_methods];
    }
    [LPTestHelper setupStub:200 withFileName:@"simple_post_success_response.json"];
    XCTestExpectation *expectation = [self expectationWithDescription:@"Query timed out."];
    NSDictionary *deviceAttributes = @{@"OS" : @"iOS"};
    [LPDeviceApi setDeviceId:DEVICE_ID withDeviceAttributes:deviceAttributes success:^ {
        [expectation fulfill];
    } failure:^(NSError *error) {
    }];
    
    [self waitForExpectationsWithTimeout:10.0 handler:^(NSError *error) {
        if (error) {
            NSLog(@"Error: %@", error);
        }
    }];
}

- (void)testDeviceApiHttpErrorStub {
    if(isSwizzlingEnabled) {
        [LPDeviceApi swizzle_methods];
    }
    [LPTestHelper setupStub:400 withFileName:@"simple_post_error_response.json"];
    XCTestExpectation *expectation = [self expectationWithDescription:@"Query timed out."];
    [LPDeviceApi setDeviceId:@"1" withDeviceAttributes:nil success:^ {
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

- (void)testDeviceApiMalformedResponseStub {
    if(isSwizzlingEnabled) {
        [LPDeviceApi swizzle_methods];
    }
    [LPTestHelper setupStub:200 withFileName:@"malformed_success_response.json"];
    XCTestExpectation *expectation = [self expectationWithDescription:@"Query timed out."];
    [LPDeviceApi setDeviceId:@"1" withDeviceAttributes:nil success:^ {
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
