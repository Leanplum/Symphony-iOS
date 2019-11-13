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
#import "LPMessage.h"

@interface LPMessageTest : XCTestCase

@end

@implementation LPMessageTest

- (void)setUp {
    [super setUp];
}

- (void)tearDown {
    [super tearDown];
}

- (void)testParseMessageResponse {
    NSString *filePath = [[[NSBundle bundleForClass:[self class]] resourcePath] stringByAppendingPathComponent:@"simple_start_response.json"];
    NSString *content = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];
    NSError *error = nil;
    id jsonObj = [NSJSONSerialization JSONObjectWithData:[content dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:&error];

    id response = jsonObj[@"response"][0];
    id messages = response[@"messages"];
    LPMessage *message0 = [[LPMessage alloc] initWithDictionary:messages[0]];
    LPMessage *message1 = [[LPMessage alloc] initWithDictionary:messages[1]];

    XCTAssertEqualObjects([message0 id], @"4529829664129024");
    XCTAssertEqualObjects([message0 action], @"Alert");
    XCTAssertEqual([message0 countdown], 86400);
    XCTAssertFalse([message0 hasImpressionCriteria]);
    XCTAssertEqualObjects([message0 parentCampaignId], [NSNull null]);
    XCTAssertEqual([message0 priority], 1000);

    XCTAssertEqualObjects([message1 id], @"4543656572354560");
    XCTAssertEqualObjects([message1 action], @"Center Popup");
    XCTAssertEqual([message1 countdown], 86400);
    XCTAssertTrue([message1 hasImpressionCriteria]);
    XCTAssertEqualObjects([message1 parentCampaignId], @"ABC");
    XCTAssertEqual([message1 priority], 1000);
}

@end
