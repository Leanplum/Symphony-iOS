//
//  LPPlatformTests.m
//  LeanplumTests
//
//  Created by Hrishikesh Amravatkar on 10/14/19.
//  Copyright © 2019 Leanplum. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "LPPlatform.h"

@interface LPPlatformTests : XCTestCase

@end

@implementation LPPlatformTests

- (void)setUp {
    [super setUp];
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
}

- (void)testPlatformData {
    XCTAssertNotNil(LPPlatform.platform);
}


@end
