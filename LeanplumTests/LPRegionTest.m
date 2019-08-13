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
#import "NSObject+Keychain.h"
#import "NSString+NSString_Extended.h"

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
    LPRegion *region0 = [[LPRegion alloc] initWithDictionary:regions[@"Alipore Panchsheel"]];
    [region0 storeToKeychainWithKey:@"regionTest"];
    LPRegion *unarchivedR  = (LPRegion *) [LPRegion dictionaryFromKeychainWithKey:@"regionTest"];
    
    /*NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:data forKey:@"regisionTest"];
    [[NSUserDefaults standardUserDefaults] synchronize];*/
    
    
    /*NSData *regionData = [[NSUserDefaults standardUserDefaults] dataForKey:@"regisionTest"];
    NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:regionData];
    LPRegion *unarchivedR = (LPRegion *) [unarchiver decodeObjectForKey:@"regisionTest"];*/
    
    XCTAssertEqualObjects(region0.name, @"Alipore Panchsheel");
    XCTAssertEqual([region0 lon], 88.32607819865063);
    XCTAssertEqual([region0 radius], 122);
    XCTAssertEqual([region0 version], 0);
    XCTAssertEqual([region0 lat], 22.52443304257146);

}

@end
