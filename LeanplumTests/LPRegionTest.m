//
//  LPRegionTest.m
//  SymphonyTests
//
//  Created by Grace on 4/8/19.
//  Copyright © 2019 Leanplum. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <OHHTTPStubs/OHHTTPStubs.h>
#import <OHHTTPStubs/OHPathHelpers.h>
#import "LPRegion.h"

@interface LPRegionTest : XCTestCase

@end

@implementation LPRegionTest

- (void)setUp {
    [super setUp];
}

- (void)tearDown {
    [super tearDown];
}

- (void)testParseRegionResponse {
    NSString *filePath = [[[NSBundle bundleForClass:[self class]] resourcePath] stringByAppendingPathComponent:@"simple_start_response.json"];
    NSString *content = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];
    NSError *error = nil;
    id jsonObj = [NSJSONSerialization JSONObjectWithData:[content dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:&error];
    
    id response = jsonObj[@"response"][0];
    id regions = response[@"regions"];
    LPRegion *region0 = [[LPRegion alloc] initWithDictionary:regions[0]];
    LPRegion *region1 = [[LPRegion alloc] initWithDictionary:regions[1]];
    
    XCTAssertEqualObjects([region0 name], @"Apple Office");
    XCTAssertEqual([region0 lon], -122.02973470209167);
    XCTAssertEqual([region0 radius], 460);
    XCTAssertEqual([region0 version], 0);
    XCTAssertEqual([region0 lat], 37.3315925570794);
    
    XCTAssertEqualObjects([region1 name], @"NYC");
    XCTAssertEqual([region1 lon], -74.00598724660182);
    XCTAssertEqual([region1 radius], 10000);
    XCTAssertEqual([region1 version], 0);
    XCTAssertEqual([region1 lat], 40.71550836434393);
}

@end
