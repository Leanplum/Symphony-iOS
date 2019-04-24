//
//  LPActionDefinitionTest.m
//  SymphonyTests
//
//  Created by Grace on 4/23/19.
//  Copyright © 2019 Leanplum. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "LPStartResponse.h"
#import "LPActionDefinition.h"
#import "LPAlert.h"
#import "LPAlertKinds.h"
#import "LPAlertValues.h"
#import "LPValuesDismissAction.h"

@interface LPActionDefinitionTest : XCTestCase

@end

@implementation LPActionDefinitionTest

- (void)setUp {
    [super setUp];
}

- (void)tearDown {
    [super tearDown];
}

- (void)testParseActionDefinitionResponse {
    NSString *filePath = [[[NSBundle bundleForClass:[self class]] resourcePath] stringByAppendingPathComponent:@"simple_start_response.json"];
    NSString *content = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];
    NSError *error = nil;
    id jsonObj = [NSJSONSerialization JSONObjectWithData:[content dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:&error];
    
    id response = jsonObj[@"response"][0];
    id actionDefinitions = response[@"actionDefinitions"];
    LPActionDefinition *actionDefinition0 = [[LPActionDefinition alloc] initWithDictionary:actionDefinitions];
    LPAlert *alert = [actionDefinition0 alert];
    LPAlertKinds *alertKinds = [alert kinds];
    LPAlertValues *alertValues = [alert values];
    LPValuesDismissAction *valuesDismissAction = [alertValues dismissAction];
    
    NSDictionary *valuesDismissActionDict = @{@"__name__" : @""};
    LPValuesDismissAction *valuesDismissActionTest = [[LPValuesDismissAction alloc] initWithDictionary:valuesDismissActionDict];
    NSDictionary *alertValuesDict = @{
                                      @"dismissAction": valuesDismissActionDict,
                                      @"dismissText": @"OK",
                                      @"message": @"Alert message goes here.",
                                      @"title": @"LeanplumSample"
                                      };
    LPAlertValues *alertValuesTest = [[LPAlertValues alloc] initWithDictionary:alertValuesDict];
    NSDictionary *alertKindsDict = @{
                                     @"dismissAction": @"ACTION",
                                     @"dismissText": @"TEXT",
                                     @"message": @"TEXT",
                                     @"title": @"TEXT",
                                     };
    XCTAssertEqualObjects([valuesDismissAction name], [valuesDismissActionTest name]);
    XCTAssertTrue([[valuesDismissAction name] length] == 0);
    XCTAssertEqualObjects([[alertValues dismissAction] name], [[alertValuesTest dismissAction] name]);
    XCTAssertEqualObjects([alertValues message], @"Alert message goes here.");
    XCTAssertEqualObjects([alertKinds dismissAction], @"ACTION");
    NSDictionary *alertDict = @{
                                @"kind": @3,
                                @"kinds": alertKindsDict,
                                @"options": [NSNull null],
                                @"values": alertValuesDict,
                                };
    LPAlert *alertTest = [[LPAlert alloc] initWithDictionary:alertDict];
    XCTAssertEqual([alertTest kind], 3);
    XCTAssertEqualObjects([[alert values] title], @"LeanplumSample");
    XCTAssertEqualObjects([[alert kinds] title], @"TEXT");
    XCTAssertEqualObjects([[[alert values] dismissAction] name], [valuesDismissActionTest name]);
}

@end
