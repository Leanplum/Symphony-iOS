//
//  LPApiUtilsTest.m
//  LeanplumTests
//
//  Created by Mayank Sanganeria on 7/17/19.
//  Copyright © 2019 Leanplum. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "LPApiUtils.h"

@interface LPApiUtilsTest : XCTestCase

@end

@implementation LPApiUtilsTest

- (void)setUp {
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
}

-(void)testResponseDictionaryFromResponseForObject {
    NSDictionary *response = @{
                               @"success" : @1,
                               @"reqId" : @"Dummy"
                               };
    NSDictionary *parsedResponse = [LPApiUtils responseDictionaryFromResponse:response];

    NSDictionary *expectedResponse = response;
    XCTAssertEqual(parsedResponse, expectedResponse);
}

-(void)testResponseDictionaryFromResponseForArray {
    NSDictionary *singleResponse = @{
                               @"success" : @1,
                               @"reqId" : @"Dummy"
                               };
    NSDictionary *response = @{
                               @"response":
                                   @[singleResponse]
                               };
    NSDictionary *parsedResponse = [LPApiUtils responseDictionaryFromResponse:response];

    NSDictionary *expectedResponse = singleResponse;
    XCTAssertEqual(parsedResponse, expectedResponse);
}

@end
