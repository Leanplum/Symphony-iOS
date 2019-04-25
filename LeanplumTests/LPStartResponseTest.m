//
//  LPStartResponseTest.m
//  SymphonyTests
//
//  Created by Grace on 4/12/19.
//  Copyright © 2019 Leanplum. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "LPStartResponse.h"
#import "LPRegion.h"

@interface LPStartResponseTest : XCTestCase

@end

@implementation LPStartResponseTest

- (void)setUp {
    [super setUp];
}

- (void)tearDown {
    [super tearDown];
}

- (void)testParseStartResponse {
    NSString *filePath = [[[NSBundle bundleForClass:[self class]] resourcePath] stringByAppendingPathComponent:@"simple_start_response.json"];
    NSString *content = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];
    NSError *error = nil;
    id jsonObj = [NSJSONSerialization JSONObjectWithData:[content dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:&error];
    
    id response = jsonObj[@"response"][0];
    LPStartResponse *startResponse0 = [[LPStartResponse alloc] initWithDictionary:response];
    LPRegion *region = [startResponse0 regions][0];
    NSDictionary *regionDict = @{ @"name" : @"Apple Office",
                                  @"lon" : [NSNumber numberWithDouble:-122.02973470209167],
                                  @"radius" : [NSNumber numberWithFloat:460],
                                  @"version" : [NSNumber numberWithFloat:0],
                                  @"lat" : [NSNumber numberWithDouble:37.3315925570794]
                                  };
    LPRegion *regionTest = [[LPRegion alloc] initWithDictionary:regionDict];
    XCTAssertEqualObjects([region name], [regionTest name]);
    XCTAssertEqual([region lon], [regionTest lon]);
    XCTAssertEqual([region radius], [regionTest radius]);
    XCTAssertEqual([region version], [regionTest version]);
    XCTAssertEqual([region lat], [regionTest lat]);
    
}

@end
