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
    LPAPIConfig *lpApiConfig = [LPAPIConfig sharedConfig];
    [lpApiConfig setAppId:APPLICATION_ID withAccessKey:APPLICATION_ID];
    [LPUserApi setUsersAttributes:@"1" withUserAttributes:nil success:^(NSString *httpCode) {
        NSLog(@"HERE");
    } failure:^(NSError *error) {
        NSLog(@"Error");
    }];
}

@end
