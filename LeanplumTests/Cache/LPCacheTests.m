//
//  LPCacheTests.m
//  LeanplumTests
//
//  Created by Hrishikesh Amravatkar on 8/13/19.
//  Copyright © 2019 Leanplum. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "LPCache.h"
#import "LPRegion.h"
#import "LPFileAttribute.h"

@interface LPCacheTests : XCTestCase


@end

@implementation LPCacheTests

- (void)setUp {
    [super setUp];
}

- (void)tearDown {
    [super tearDown];
}

- (void)testCacheRegion {
    NSString *filePath = [[[NSBundle bundleForClass:[self class]] resourcePath] stringByAppendingPathComponent:@"simple_start_response.json"];
    NSString *content = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];
    NSError *error = nil;
    id jsonObj = [NSJSONSerialization JSONObjectWithData:[content dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:&error];
    
    id response = jsonObj[@"response"][0];
    id regions = response[@"regions"];
    LPRegion *region0 = [[LPRegion alloc] initWithDictionary:regions[@"Alipore Panchsheel"]];
    
    NSArray *regionList = @[region0];
    [[LPCache sharedCache] setRegions:regionList];
    
    NSArray *regionListCached = [[LPCache sharedCache] regions];
    XCTAssertEqual([regionListCached count], 1);
}

- (void) testCacheFileAttributes {
    NSString *filePath = [[[NSBundle bundleForClass:[self class]] resourcePath] stringByAppendingPathComponent:@"simple_start_response.json"];
    NSString *content = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];
    NSError *error = nil;
    id jsonObj = [NSJSONSerialization JSONObjectWithData:[content dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:&error];
    
    id response = jsonObj[@"response"][0];
    id fileAttributes = response[@"fileAttributes"];
    
    LPFileAttribute *fileAttribute0 = [[LPFileAttribute alloc] initWithDictionary:fileAttributes[0]];
    NSArray *fileAttributeList = @[fileAttribute0];
    [[LPCache sharedCache] setFileAttributes:fileAttributeList];

    NSArray *fileAttributeListCached = [[LPCache sharedCache] fileAttributes];
    XCTAssertEqual([fileAttributeListCached count], 1);
}

@end
