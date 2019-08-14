//
//  LPFileAttributeTest.m
//  SymphonyTests
//
//  Created by Grace on 4/11/19.
//  Copyright © 2019 Leanplum. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <OHHTTPStubs/OHHTTPStubs.h>
#import <OHHTTPStubs/OHPathHelpers.h>
#import "LPFileAttribute.h"
#import "NSObject+Keychain.h"
#import "NSString+NSString_Extended.h"

@interface LPFileAttributeTest : XCTestCase

@end

@implementation LPFileAttributeTest

- (void)setUp {
    [super setUp];
}

- (void)tearDown {
    [super tearDown];
}

- (void)testParseFileAttributeResponse {
    NSString *filePath = [[[NSBundle bundleForClass:[self class]] resourcePath] stringByAppendingPathComponent:@"simple_start_response.json"];
    NSString *content = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];
    NSError *error = nil;
    id jsonObj = [NSJSONSerialization JSONObjectWithData:[content dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:&error];
    
    id response = jsonObj[@"response"][0];
    id fileAttributes = response[@"fileAttributes"];
    
    LPFileAttribute *fileAttribute0 = [[LPFileAttribute alloc] initWithDictionary:fileAttributes[0]];
    LPFileAttribute *fileAttribute1 = [[LPFileAttribute alloc] initWithDictionary:fileAttributes[1]];
    NSString *url0 = @"http://lh3.googleusercontent.com/e2z4y3k9XdthAt_3B2p1HsxZ3BmExqdxaoj7kqaxECGlmtDLrAW6H2-AI-jpIyM3GcADoNeGZuzPs8P9NAMy";
    NSString *url1 = @"http://lh3.googleusercontent.com/e2z4y3k9XdthAt_3B2p1HsxZ3BmExqdxaoj7kqaxECGlmtDLrAW6H2-AI-jpIyM3GcADoNeGZuzPs8P9NAMyy";
    
    XCTAssertEqualObjects([fileAttribute0 name], @"mozart.jpg");
    XCTAssertEqual([fileAttribute0 size], 89447);
    XCTAssertEqualObjects([fileAttribute0 fileAttributeHash], [NSNull null]);
    XCTAssertEqualObjects([fileAttribute0 servingUrl], url0);
    
    XCTAssertEqualObjects([fileAttribute1 name], @"mozart2.jpg");
    XCTAssertEqual([fileAttribute1 size], 89448);
    XCTAssertEqualObjects([fileAttribute1 fileAttributeHash], @"ABC");
    XCTAssertEqualObjects([fileAttribute1 servingUrl], url1);
}

- (void)testParseFileAttributeCache {
    NSString *filePath = [[[NSBundle bundleForClass:[self class]] resourcePath] stringByAppendingPathComponent:@"simple_start_response.json"];
    NSString *content = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];
    NSError *error = nil;
    id jsonObj = [NSJSONSerialization JSONObjectWithData:[content dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:&error];
    
    id response = jsonObj[@"response"][0];
    id fileAttributes = response[@"fileAttributes"];
    
    LPFileAttribute *fileAttribute0 = [[LPFileAttribute alloc] initWithDictionary:fileAttributes[0]];
    [fileAttribute0 storeToKeychainWithKey:@"fileAttributeTest"];
    LPFileAttribute *unarchivedfileAttribute0  = (LPFileAttribute *) [LPFileAttribute dictionaryFromKeychainWithKey:@"fileAttributeTest"];
    
    LPFileAttribute *fileAttribute1 = [[LPFileAttribute alloc] initWithDictionary:fileAttributes[1]];
    [fileAttribute1 storeToKeychainWithKey:@"fileAttributeTest"];
    LPFileAttribute *unarchivedfileAttribute1  = (LPFileAttribute *) [LPFileAttribute dictionaryFromKeychainWithKey:@"fileAttributeTest"];
    
    NSString *url0 = @"http://lh3.googleusercontent.com/e2z4y3k9XdthAt_3B2p1HsxZ3BmExqdxaoj7kqaxECGlmtDLrAW6H2-AI-jpIyM3GcADoNeGZuzPs8P9NAMy";
    NSString *url1 = @"http://lh3.googleusercontent.com/e2z4y3k9XdthAt_3B2p1HsxZ3BmExqdxaoj7kqaxECGlmtDLrAW6H2-AI-jpIyM3GcADoNeGZuzPs8P9NAMyy";
    
    XCTAssertEqualObjects([unarchivedfileAttribute0 name], @"mozart.jpg");
    XCTAssertEqual([unarchivedfileAttribute0 size], 89447);
    XCTAssertEqualObjects([unarchivedfileAttribute0 fileAttributeHash], [NSNull null]);
    XCTAssertEqualObjects([unarchivedfileAttribute0 servingUrl], url0);
    
    XCTAssertEqualObjects([unarchivedfileAttribute1 name], @"mozart2.jpg");
    XCTAssertEqual([unarchivedfileAttribute1 size], 89448);
    XCTAssertEqualObjects([unarchivedfileAttribute1 fileAttributeHash], @"ABC");
    XCTAssertEqualObjects([unarchivedfileAttribute1 servingUrl], url1);
}


@end
