//
//  LPUserApiTests.m
//  LeanplumTests
//
//  Created by Hrishikesh Amravatkar on 5/2/19.
//  Copyright © 2019 Leanplum. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "LPUserApi.h"
#import "LPAPIConfig.h"
#import "LPTestHelper.h"

@interface LPUserApiTests : XCTestCase

@end

@implementation LPUserApiTests

- (void)setUp {
    [super setUp];
}

- (void)tearDown {
    [super tearDown];
}

- (void)testUserApi {
    XCTestExpectation *expectation = [self expectationWithDescription:@"Query timed out."];
    LPAPIConfig *lpApiConfig = [LPAPIConfig sharedConfig];
    [lpApiConfig setAppId:APPLICATION_ID withAccessKey:DEVELOPMENT_KEY];
    [LPAPIConfig sharedConfig].deviceId = @"FCF96D6D-FE1C-4FC6-89D4-F862A5FFECE4";
    [LPUserApi setUsersAttributes:@"1" withUserAttributes:nil success:^(NSString *httpCode) {
        NSLog(@"HERE");
        [expectation fulfill];
    } failure:^(NSError *error) {
        NSLog(@"Error");
        [expectation fulfill];
    }];
    
    [self waitForExpectationsWithTimeout:10.0 handler:^(NSError *error) {
        if (error) {
            NSLog(@"Error: %@", error);
        }
    }];
}

@end