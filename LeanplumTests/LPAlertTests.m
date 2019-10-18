//
//  LPAlertTests.m
//  LeanplumTests
//
//  Created by Hrishikesh Amravatkar on 10/18/19.
//  Copyright © 2019 Leanplum. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <OHHTTPStubs/OHHTTPStubs.h>
#import <OHHTTPStubs/OHPathHelpers.h>
#import "LPAlert.h"
#import "LPActionDefinition.h"
#import "NSObject+Keychain.h"
#import "NSString+NSString_Extended.h"

@interface LPAlertTests : XCTestCase

@end

@implementation LPAlertTests

- (void)setUp {
    [super setUp];
}

- (void)tearDown {
    [super tearDown];
}

- (void)testParseAlertResponse {
    NSString *filePath = [[[NSBundle bundleForClass:[self class]] resourcePath] stringByAppendingPathComponent:@"simple_start_response.json"];
    NSString *content = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];
    NSError *error = nil;
    id jsonObj = [NSJSONSerialization JSONObjectWithData:[content dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:&error];
    
    id response = jsonObj[@"response"][0];
    id actionDefinitions = response[@"actionDefinitions"];
    LPActionDefinition *actionDefinition0 = [[LPActionDefinition alloc] initWithDictionary:actionDefinitions];
    LPAlert *alert = [actionDefinition0 alert];
    
    XCTAssertEqual([alert kind], 3);
    XCTAssertNotNil([alert kinds]);

}

- (void)testParseAlertResponseCache {
    
    NSString *filePath = [[[NSBundle bundleForClass:[self class]] resourcePath] stringByAppendingPathComponent:@"simple_start_response.json"];
    NSString *content = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];
    NSError *error = nil;
    id jsonObj = [NSJSONSerialization JSONObjectWithData:[content dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:&error];
    
    id response = jsonObj[@"response"][0];
    id actionDefinitions = response[@"actionDefinitions"];
    LPActionDefinition *actionDefinition0 = [[LPActionDefinition alloc] initWithDictionary:actionDefinitions];
    LPAlert *alert = [actionDefinition0 alert];
    [alert storeToKeychainWithKey:@"alertTest"];
    LPAlert *unarchivedR  = (LPAlert *) [LPAlert dictionaryFromKeychainWithKey:@"alertTest"];
    
    XCTAssertEqual([unarchivedR kind], 3);
    XCTAssertNotNil([unarchivedR kinds]);

}

@end
